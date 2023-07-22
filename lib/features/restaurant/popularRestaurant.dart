import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/features/restaurant/restaurant.dart';

import '../../widgets/notification_button.dart';

class popularRestaurant extends StatefulWidget {
  @override
  _popularRestaurantState createState() => _popularRestaurantState();
}

class _popularRestaurantState extends State<popularRestaurant> {
  final pb = PocketBase('http://78.47.197.153');
  List<dynamic> restaurantRecords = [];
  List<String> names = [];
  List<String> image = [];
  List<String> id = [];
  List<String> logo = [];
  List<bool> status = [];
  List<double> rating = [];
  List<String> location = [];
  List<int> startTime = [];
  List<int> endTime = [];
  String searchQuery = '';

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchRestaurant();
  }

  Future<void> fetchRestaurant({String? sortBy}) async {
    try {
      final resultList = await pb.collection('restaurant').getFullList(sort: sortBy);

      setState(() {
        names = [];
        id = [];
        image = [];
        logo = [];
        location = [];
        status = [];
        rating = [];
        startTime = [];
        endTime = [];

        for (var record in resultList) {
          String ID = record.id;
          String name = record.getStringValue('name') as String;
          String imgName = record.getStringValue('bg_image');
          var imageUrl = pb.files.getUrl(record, imgName);
          String logoUrl = record.getStringValue('logo') as String;
          String loc = record.getStringValue('address') as String;
          bool Status = record.getBoolValue('status');
          double ratings = record.getDoubleValue('rating');
          int start = record.getIntValue('opening_time');
          int end = record.getIntValue('closing_time');

          names.add(name);
          id.add(ID);
          image.add(imageUrl.toString());
          logo.add(logoUrl);
          location.add(loc);
          status.add(Status);
          rating.add(ratings);
          startTime.add(start);
          endTime.add(end);
        }
        print(logo);
        filteredItems = getFilteredItems();
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  List<String> getFilteredItems() {
    if (searchQuery.isEmpty) {
      return names;
    } else {
      return names
          .where((name) => name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
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
                  NotificationButton(height: 50, width: 50)
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
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
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      hintText: 'What do you want to order?',
                      prefixIcon: Icon(Icons.search, size: 34),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0), // Adjust the left padding as needed
                  child: Text(
                    'Popular Restaurant',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 160 / 200,
                  crossAxisSpacing: 20, // Add cross-axis spacing
                  mainAxisSpacing: 20, // Add main-axis spacing
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: 20), // Add horizontal padding
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Restaurant(
                            rName: filteredItems[index],
                            rImage: image[index],
                            rId: id[index],
                            rLogo: logo[index],
                            rRating: rating[index],
                            rLocation: location[index],
                            rStatus: status[index],
                            startTime: startTime[index],
                            endTime: endTime[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: mediaQuery.size.height * 0.031,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.network(
                              logo[index],
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            filteredItems[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}


