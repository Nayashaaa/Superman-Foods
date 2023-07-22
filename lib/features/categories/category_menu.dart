import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/features/menu/singleProduct.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../widgets/bottom_menu.dart';

class categoryMenu extends StatefulWidget {
  final String catId;
  final String catName;
  categoryMenu(
      {required this.catId,
      required this.catName});
  @override
  _categoryMenuState createState() => _categoryMenuState();
}

class _categoryMenuState extends State<categoryMenu> {
  final pb = PocketBase('http://78.47.197.153');

  dynamic email;
  String cust_email = '';
  Future<void>? userFuture;

  List<String> items = [];
  List<String> images = [];
  List<String> description = [];
  List<String> price = [];
  List<String> ID = [];
  List<String> calories = []; 
  List<String> filteredItems = [];
  List<int> reviews = [];
  List<int> totalRating = [];
  List<double> rating = [];
  List<String> favourites = [];
  List<bool> isFav = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    userFuture = getuser();
    fetchItems();

  }

  Future<void> fetchItems({String? sortBy}) async {
    print('category = "${widget.catId}"');
    try {
      final resultList =
          await pb.collection('menu_item').getFullList(filter: 'category = "${widget.catId}"');
      

      setState(() {
        items = [];
        ID=[];
        images = [];
        price = [];
        rating = [];
        description = [];
        calories = [];
        reviews = [];
        totalRating = [];
        isFav = [];

        for (var record in resultList) {
          String name = record.getStringValue('name') as String;
          String itemId = record.id;
          String imageUrl = record.getStringValue('image') as String;
          String cost = record.getStringValue('price') as String;
          int rates = record.getIntValue('rating') as int;
          String descr = record.getStringValue('description') as String;
          String calorie = record.getStringValue('calories') as String;
          int review = record.getIntValue('reviews') as int;

          double rate = rates/review;
          items.add(name);
          images.add(imageUrl);
          price.add(cost);
          totalRating.add(rates);
          description.add(descr);
          calories.add(calorie);
          reviews.add(review);
          rating.add(rate);
          ID.add(itemId);
          isFav.add(false);
          
        }
        filteredItems = getFilteredItems();
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  List<String> getFilteredItems() {
    if (searchQuery.isEmpty) {
      return items;
    } else {
      return items
          .where(
              (name) => name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Sort by Alphabets'),
                onTap: () {
                  fetchItems(sortBy: 'name');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Sort by Price'),
                onTap: () {
                  fetchItems(sortBy: 'price');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> getuser() async {
    try {
      email = await SessionManager().get("email");
      cust_email = "\"$email\"";
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> addToFav(int index) async {
    final body = <String, dynamic>{
      "food_id": ID[index],
      "customer": email,
    };

    try {
      await pb.collection('favourites').create(body: body);
      setState(() {
        isFav[index] = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Item added to favourites!',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),),
          duration: Duration(seconds: 2),
        ),
      );
      print("Item added to favourites");
      
      } catch (e) {
      print("Error adding item to favourites: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Item exists in favourites!',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: mediaQuery.size.height * 0.01),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Container(
                    width: mediaQuery.size.width * 0.8,
                    child: Text(
                    'Find Your \nFavourite Food',
                    style: TextStyle(
                      fontSize: mediaQuery.size.width * 0.07,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                    child: Icon(
                      Icons.notifications_none,
                      size: 28,
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                children: [
                  Container(
                          width: MediaQuery.of(context).size.width * 0.745,
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
                                  filteredItems = getFilteredItems();
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
                  
                  Container(
                      height: 57,
                      width: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: IconButton(
                          onPressed: _showFilterDialog,
                          icon: Icon(Icons.filter_list, size: 25)))
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0),
                  child: Text(
                    '${widget.catName}',
                    style: TextStyle(
                      fontSize: mediaQuery.size.width * 0.05,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Column(
                children: List.generate(items.length, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => singleProduct(
                              items: items[index],
                              description: description[index],
                              price: price[index],
                              images: images[index],
                              calories: calories[index],
                              ratings: (rating[index]).toString(),
                              reviews: (reviews[index]).toString(),
                              itemId: (ID[index]),),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.16,
                            height: MediaQuery.of(context).size.height * 0.085,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Container(
                                        width: 210,
                                        child: Text(
                                          items[
                                              index], // Use the dynamic item name
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Lato',
                                          ),
                                        ),
                                      ),
 
                                      //SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.555,
                                      child: Padding(
                                      padding: EdgeInsets.only(left: 17.0),
                                      child: Text(
                                        '${description[index].substring(0, 25)}...',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize:mediaQuery.size.width * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        addToFav(index);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        decoration: BoxDecoration(
                                          color: Colors.pink[50],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Icon(
                                          isFav[index] ?
                                          Icons.favorite_rounded: Icons.favorite_border_rounded,
                                          size: 18,
                                          color: Colors
                                              .red, // Update the icon color dynamically
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    Text(
                                      price[index],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Lato',
                                        color: Color(0xFF28B996),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        
      ),
      
      bottomNavigationBar: BottomMenu(activeIndex: 0),
    )
      
); }
}