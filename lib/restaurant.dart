import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/singleProduct.dart';

import 'bottom_menu.dart';

class Restaurant extends StatefulWidget {
  final String rName;
  final String rImage;
  final String rId;
  final String rLogo;
  final double rRating;
  final bool rStatus;
  final String rLocation;
  final int startTime;
  final int endTime;
  Restaurant(
      {required this.rName,
      required this.rImage,
      required this.rId,
      required this.rLogo,
      required this.rRating,
      required this.rStatus,
      required this.rLocation,
      required this.startTime,
      required this.endTime});

  
  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  
  final pb = PocketBase('http://78.47.197.153');

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
  int currentHour = 0;
  Future<void>? details;

  @override
  void initState() {
    super.initState();
    details = getDetails();
  }

  Future<void> getDetails()async {
    try {
      final resultList =
          await pb.collection('menu_item').getFullList(filter: 'restaurant = "${widget.rId}"');
          print(widget.rId);

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
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
    setState(() {
      currentHour = DateTime.now().hour;
    });
    print(currentHour);
  }

   Future<void> fetchItems({String? sortBy}) async {
    
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.54,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.rImage),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      25, 25, 25, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(-1.05, -1),
                                          child: IconButton(
                                            color: Colors.yellowAccent,
                                            icon: Icon(
                                                Icons.arrow_back_ios_new_sharp,
                                                color: Colors.white,
                                                size: 30),
                                            onPressed: () {
                                              Navigator.pushNamed(context, '/popularRestaurant');
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.16,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(-0.09, 0.71),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.87,
                        height: MediaQuery.of(context).size.height * 0.3,
                        constraints: BoxConstraints(
                          maxWidth: double.infinity,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(15),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, -1),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        widget.rLogo),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
                              child: Text(
                                widget.rName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(25, 10, 25, 0),
                              child: Text(
                                widget.rLocation,
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Text(
                                'Opens ${widget.startTime}:00 - ${widget.endTime}:00',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(50, 10, 30, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        45, 0, 0, 0),
                                    child: Container(
                                              child: Row(
                                                children: <Widget>[
                                                  if (widget.rRating == 0.0)
                                                    Icon(Icons.star_border_rounded,
                                                      color: Colors.amber,
                                                      size: 30,
                                                    )
                                                  else if (widget.rRating >
                                                          0 &&
                                                      widget.rRating <
                                                          5.0)
                                                    Icon(
                                                      Icons
                                                          .star_half_rounded,
                                                      color:
                                                          Colors.amber,
                                                      size: 30,
                                                    )
                                                  else if (widget.rRating ==
                                                      5)
                                                    Icon(
                                                      Icons
                                                          .star_rounded,
                                                      color:
                                                          Colors.amber,
                                                      size: 30,
                                                    )
                                                ],
                                              ),
                                                    ),

                                  ),
                                  Text(
                                    '${widget.rRating}',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(45, 0, 0, 0),
                                    child: Icon(
                                      Icons.fiber_manual_record_rounded,
                                      color: (currentHour<widget.startTime || currentHour>=widget.endTime)? Colors.red : Colors.green,
                                      size: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                                    child: Text(
                                      (currentHour<widget.startTime || currentHour>=widget.endTime)? 'Inactive' : 'Active',
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child:Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: SingleChildScrollView
                (child: Column(
                children: List.generate(items.length, (index) {
                  return GestureDetector(
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
                                          fontSize:MediaQuery.of(context).size.width * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // addToFav(index);
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

,))
              
                )
                
             
            ],
          ),
        ),
      bottomNavigationBar: BottomMenu(activeIndex: 0),
      ),
    
);  }
}