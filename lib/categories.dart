import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/category_menu.dart';

import 'notification_button.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final pb = PocketBase('http://78.47.197.153');

  List<String> categories = [];
  List<String> images = [];
  List<String> catId = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final resultList =
          await pb.collection('food_category').getFullList(sort: 'name');

      setState(() {
        categories = [];
        images = [];
        catId = [];


        for (var record in resultList) {
          String name = record.getStringValue('name') as String;
          String imageUrl = record.getStringValue('image') as String;
          String cId = record.id;

          categories.add(name);
          images.add(imageUrl);
          catId.add(cId);
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  List<String> getFilteredCategories() {
    if (searchQuery.isEmpty) {
      return categories;
    } else {
      return categories
          .where((category) =>
              category.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        SizedBox(height: constraints.maxWidth * 0.03),
                        Row(
                          children: [
                            SizedBox(width: constraints.maxWidth * 0.045),
                            Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.07,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.45,
                            ),
                            NotificationButton(
                              height: 50,
                              width: 50,
                            )
                          ],
                        ),
                        SizedBox(height: constraints.maxHeight * 0.01),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                hintText: 'What do you want to order?',
                                prefixIcon: Icon(Icons.search, size: 34),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.025),
                        Column(
                          children: List<Widget>.generate(
                            (getFilteredCategories().length / 3).ceil(),
                            (index) {
                              int startIndex = index * 3;
                              int endIndex = (index + 1) * 3;
                              if (endIndex > getFilteredCategories().length) {
                                endIndex = getFilteredCategories().length;
                              }

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: getFilteredCategories()
                                        .sublist(startIndex, endIndex)
                                        .map(
                                      (category) {
                                        int categoryIndex =
                                            categories.indexOf(category);
                                        String image = images[categoryIndex];
                                        String Id = catId[categoryIndex];
                                        String name = categories[categoryIndex];
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => categoryMenu(
                                                      catName:name,
                                                      catId: Id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.18,
                                                height: MediaQuery.of(context).size.width * 0.18,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child: Image.network(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    10), 
                                            Text(
                                              category,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  SizedBox(height: 30),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
