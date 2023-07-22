import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/restaurant.dart';
import 'package:supertest/singleProduct.dart';

import 'category_menu.dart';
import 'notification_button.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> images = [
    'lib/assets/images/image1.jpg',
    'lib/assets/images/image2.jpg',
    'lib/assets/images/image1.jpg',
  ];
  final pb = PocketBase('http://78.47.197.153');

  List<String> categories = [];
  List<String> catImg = [];
  List<String> catID = [];

  List<String> items = [];
  List<String> itemImg = [];
  List<String> itemPrice = [];
  List<double> rating = [];
  List<String> description = [];
  List<String> calories = [];
  List<int> reviews = [];
  List<int> totalRating = [];
  List<String> ID = [];

  List<String> names = [];
  List<String> image = [];
  List<String> id = [];
  List<String> logo = [];
  List<bool> status = [];
  List<double> Rating = [];
  List<String> location = [];
  List<int> startTime = [];
  List<int> endTime = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchItems();
    fetchRestaurant();
  }

  Future<void> fetchCategories() async {
    try {
      final resultList =
          await pb.collection('food_category').getFullList(sort: 'name');

      setState(() {
        categories = [];
        catImg = [];
        catID = [];

        for (var record in resultList) {
          String name = record.getStringValue('name') as String;
          String imageUrl = record.getStringValue('image') as String;
          String Id = record.id;

          categories.add(name);
          catImg.add(imageUrl);
          catID.add(Id);
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchItems() async {
    try {
      final resultList =
          await pb.collection('menu_item').getFullList(sort: 'name');

      setState(() {
        items = [];
        itemImg = [];
        itemPrice = [];
        rating = [];
        description = [];
        calories = [];
        reviews = [];
        totalRating = [];
        ID = [];

        for (var record in resultList) {
          String name = record.getStringValue('name') as String;
          String imageUrl = record.getStringValue('image') as String;
          String cost = record.getStringValue('price') as String;
          int rates = record.getIntValue('rating') as int;
          String descr = record.getStringValue('description') as String;
          String calorie = record.getStringValue('calories') as String;
          int review = record.getIntValue('reviews') as int;
          String itemId = record.id;

          double rate = rates / review;

          ID.add(itemId);
          items.add(name);
          itemImg.add(imageUrl);
          itemPrice.add(cost);
          totalRating.add(rates);
          description.add(descr);
          calories.add(calorie);
          reviews.add(review);
          rating.add(rate);
        }
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> fetchRestaurant() async {
    try {
      final resultList =
          await pb.collection('restaurant').getFullList(sort: 'name');

      setState(() {
        names = [];
        id = [];
        image = [];
        logo = [];
        location = [];
        status = [];
        Rating = [];
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
          Rating.add(ratings);
          startTime.add(start);
          endTime.add(end);
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  String searchQuery = '';

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

  List<String> getFilteredRestaurant() {
    if (searchQuery.isEmpty) {
      return names;
    } else {
      return names
          .where(
              (name) => name.toLowerCase().contains(searchQuery.toLowerCase()))
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
                  final mediaQuery = MediaQuery.of(context);
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        children: [
                          SizedBox(
                            height: mediaQuery.size.height * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(width: constraints.maxWidth * 0.03),
                              Container(
                                width: mediaQuery.size.width * 0.82,
                                child: Row(children: [
                                  Icon(Icons.pin_drop,
                                      color: Colors.redAccent, size: 38),
                                  SizedBox(width: constraints.maxWidth * 0.02),
                                  Text(
                                    'Your location',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ]),
                              ),
                              NotificationButton(height: 45, width: 45)
                            ],
                          ),
                          SizedBox(height: constraints.maxHeight * 0.01),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: 45,
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
                                      EdgeInsets.symmetric(vertical: 10),
                                  hintText: 'Search Food, Restaurants etc',
                                  prefixIcon: Icon(Icons.search, size: 34),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 183.13,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                            ),
                            items: images.map((images) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      //color: Colors.redAccent,
                                      image: DecorationImage(
                                        image: AssetImage(images),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.025,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: constraints.maxWidth * 0.05),
                                Text(
                                  'Categories',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Lato'),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/categories');
                                    },
                                    child: Text(
                                      'View More',
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.redAccent),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                          Column(
                            children: List<Widget>.generate(
                              ((getFilteredCategories().length / 3).ceil() > 2)
                                  ? 2
                                  : (getFilteredCategories().length / 3).ceil(),
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
                                          .map((category) {
                                        int categoryIndex =
                                            getFilteredCategories()
                                                .indexOf(category);
                                        String img = catImg[categoryIndex];
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        categoryMenu(
                                                      catName: categories[
                                                          categoryIndex],
                                                      catId:
                                                          catID[categoryIndex],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.19,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.19,
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
                                                    img,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01),
                                            Text(
                                              category,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: constraints.maxWidth * 0.05),
                                Text(
                                  'Popular Menu',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Lato'),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.26,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/popularMenu');
                                    },
                                    child: Text(
                                      'View More',
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.redAccent),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          Column(
                            children: List<Widget>.generate(
                              (getFilteredItems().length) > 3
                                  ? 3
                                  : getFilteredItems().length,
                              (index) {
                                int startIndex = index;
                                int endIndex = (index + 1);
                                if (endIndex > getFilteredItems().length) {
                                  endIndex = getFilteredItems().length;
                                }

                                return Column(
                                  children: getFilteredItems()
                                      .sublist(startIndex, endIndex)
                                      .map(
                                    (item) {
                                      int itemIndex = items.indexOf(item);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  singleProduct(
                                                      items: items[itemIndex],
                                                      description: description[
                                                          itemIndex],
                                                      price:
                                                          itemPrice[itemIndex],
                                                      images:
                                                          itemImg[itemIndex],
                                                      calories:
                                                          calories[itemIndex],
                                                      ratings:
                                                          (rating[itemIndex])
                                                              .toString(),
                                                      reviews:
                                                          (reviews[itemIndex])
                                                              .toString(),
                                                      itemId: (ID[itemIndex])),
                                            ),
                                          );

                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.36,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.26,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(20),
                                                    topLeft:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(20),
                                                      topLeft:
                                                          Radius.circular(20),
                                                    ),
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    child: Image.network(
                                                      itemImg[itemIndex],
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    )),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.09,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, top: 2),
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          items[itemIndex],
                                                          style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.056,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.005,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              children: <Widget>[
                                                                if (rating[
                                                                        itemIndex] ==
                                                                    0.0)
                                                                  Icon(
                                                                    Icons
                                                                        .star_border_rounded,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 30,
                                                                  )
                                                                else if (rating[
                                                                            itemIndex] >
                                                                        0 &&
                                                                    rating[itemIndex] <
                                                                        5.0)
                                                                  Icon(
                                                                    Icons
                                                                        .star_half_rounded,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 30,
                                                                  )
                                                                else if (rating[
                                                                        itemIndex] ==
                                                                    5)
                                                                  Icon(
                                                                    Icons
                                                                        .star_rounded,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 30,
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            '${rating[itemIndex]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: constraints
                                                                      .maxWidth *
                                                                  0.48),
                                                          Text(
                                                            'Rs.${double.parse(itemPrice[itemIndex]).toStringAsFixed(2)}',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.044,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Color(
                                                                  0xFF28B996),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: constraints.maxWidth * 0.05),
                                Text(
                                  'Nearby Superhouses',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Lato'),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth * 0.1,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/popularRestaurant');
                                    },
                                    child: Text(
                                      'View More',
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.redAccent),
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.27,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                              enableInfiniteScroll: true,
                            ),
                            items: List<Widget>.generate(
                              (getFilteredRestaurant().length) > 3
                                  ? 3
                                  : getFilteredRestaurant().length,
                              (index) {
                                int startIndex = index;
                                int endIndex = (index + 1);
                                if (endIndex > getFilteredRestaurant().length) {
                                  endIndex = getFilteredRestaurant().length;
                                }
                                return Row(
                                  children: getFilteredRestaurant()
                                      .sublist(startIndex, endIndex)
                                      .map(
                                    (name) {
                                      int restIndex = names.indexOf(name);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Restaurant(
                                                rName: names[restIndex],
                                                rImage: image[restIndex],
                                                rId: id[restIndex],
                                                rLogo: logo[restIndex],
                                                rRating: Rating[restIndex],
                                                rLocation: location[restIndex],
                                                rStatus: status[restIndex],
                                                startTime: startTime[restIndex],
                                                endTime: endTime[restIndex],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width * 0.7,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width *0.5 ,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(25),
                                                      topRight:
                                                          Radius.circular(25),
                                                    ),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    child: Image.network(
                                                      logo[restIndex],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.only(left: mediaQuery.size.width * 0.05),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(bottomLeft:Radius.circular(25), bottomRight:Radius.circular(25)),
                                                  ),
                                                child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          names[restIndex],
                                                          style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.056,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.005,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Row(
                                                              children: <Widget>[
                                                                if (Rating[
                                                                        restIndex] ==
                                                                    0.0)
                                                                  Icon(
                                                                    Icons
                                                                        .star_border_rounded,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 30,
                                                                  )
                                                                else if (Rating[
                                                                            restIndex] >
                                                                        0 &&
                                                                    Rating[restIndex] <
                                                                        5.0)
                                                                  Icon(
                                                                    Icons
                                                                        .star_half_rounded,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 30,
                                                                  )
                                                                else if (Rating[
                                                                        restIndex] ==
                                                                    5)
                                                                  Icon(
                                                                    Icons
                                                                        .star_rounded,
                                                                    color: Colors
                                                                        .amber,
                                                                    size: 30,
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            '${Rating[restIndex]}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                                                                                  ],
                                                      ),
                                                    ],
                                                  ),

                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.95,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            // child: Expanded(
                            //   flex: 2,
                            //   child: Container(
                            //     color: Colors.transparent,
                            //     height: 100,
                            //     width: 100,
                            //     //child: Text('Expanded Widget'),
                            //       // child: Placeholder(), // Replace with your ad widget
                            //     ),
                            //
                            // ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.5,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
