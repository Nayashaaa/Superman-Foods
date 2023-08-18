import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:collection/collection.dart';
import 'package:supertest/features/reviews/rating.dart';
import 'package:supertest/features/reviews/review.dart';

import '../home/home.dart';

class TrackOrder extends StatefulWidget {
  @override
  State<TrackOrder> createState() => _trackOrderState();
}

class _trackOrderState extends State<TrackOrder> {
  final pb = PocketBase('http://78.47.197.153');
  double subTotal = 0;
  int totalQty = 0;
  int disAmt = 0;
  int deliveryFee = 100;

  Future<void>? userFuture;
  dynamic email;
  List<String> id = [];
  List<String> items = [];
  List<String> images = [];
  List<String> description = [];
  List<double> price = [];
  List<int> quantity = [];
  List<double> rate = [];
  String cust_email = '';
  String ID = '';

  @override
  void initState() {
    super.initState();
    userFuture = getuser();
    userFuture?.then((_) {
      getCartDetails();
    });
  }

  Future<void> getuser() async {
    try {
      email = await SessionManager().get("email");
      cust_email = "\"$email\"";
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> getCartDetails() async {
    try {
      String fltr = 'customer = $cust_email';
      final resultList =
          await pb.collection('cart_details').getFullList(filter: fltr);
      print(fltr);

      setState(() {
        id = [];
        items = [];
        quantity = [];
        images = [];
        description = [];
        price = [];
        rate = [];

        for (var record in resultList) {
          String ID = record.id as String;
          int qty = record.getIntValue('quantity') as int;
          String name = record.getStringValue('name') as String;
          String imageUrl = record.getStringValue('image') as String;
          String desc = record.getStringValue('description') as String;
          double cost = record.getDoubleValue('price') as double;
          double cpi = record.getDoubleValue('rate') as double;

          id.add(ID);
          items.add(name);
          quantity.add(qty);
          images.add(imageUrl);
          description.add(desc);
          price.add(cost);
          rate.add(cpi);
        }
        subTotal = price.sum;
        totalQty = id.length;
        print(subTotal);
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                    constraints: BoxConstraints(minHeight: screenHeight),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.03,
                                top: screenHeight * 0.02,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                },
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.20),
                            Text(
                              'View Status',
                              style: TextStyle(
                                height: screenHeight * 0.0025,
                                fontFamily: 'Lato',
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 22.0), // Adjust this to fit your needs.
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Order ID: 55555',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 22.0), // Adjust this to fit your needs.
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Order Date: June 1, 2023',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        Column(
                          children: [
                            Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.105,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.03),
                                  Container(
                                    width: screenWidth * 0.16,
                                    height: screenHeight * 0.080,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // center alignment horizontally
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 0,
                                              bottom:
                                                  0), // Adjust the value as needed
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width: screenWidth * 0.04),
                                              Text(
                                                'Burger',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Lato',
                                                ),
                                              ),
                                              SizedBox(
                                                  width: screenWidth * 0.25),
                                              Container(
                                                width: screenWidth * 0.065,
                                                height: screenWidth * 0.065,
                                                child: Icon(
                                                  Icons
                                                      .fiber_manual_record_rounded,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                '2 items',
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.01),
                                        Row(
                                          children: [
                                            SizedBox(width: screenWidth * 0.04),
                                            Text(
                                              'Rs. 100',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Lato',
                                                color: Color(0xFF28B996),
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.28),
                                            Container(
                                              width: screenWidth * 0.2,
                                              height: screenHeight * 0.03,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                //color: Colors.greenAccent,
                                                border: Border.fromBorderSide(
                                                    BorderSide(
                                                  color: Color(0xFF28B996),
                                                )),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Received',
                                                  style: TextStyle(
                                                    color: Color(0xFF28B996),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenWidth * 0.04),

                        // * STATUS CODE CONTAINER COLUMN
                        Column(
                          children: [
                            //1
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.10,
                                    height: screenHeight * 0.05,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.red[100], // background color
                                      borderRadius: BorderRadius.circular(
                                          8), // border corner radius
                                    ),
                                    child: Icon(
                                      Icons.receipt_long_rounded,
                                      size: 30,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center alignment vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // start alignment horizontally
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0,
                                            0), // Adjust the value as needed
                                        child: Text(
                                          'Order Received',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'Lato',
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ], //children
                                  ),
                                  const Expanded(
                                    // Expands to take up remaining space
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // center alignment vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // end alignment horizontally
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0, 0,
                                              0), // Adjust the value as needed
                                          child: Text(
                                            '12:20 AM',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              fontFamily: 'Lato',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ], //children
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //2
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.10,
                                    height: screenHeight * 0.05,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.red[100], // background color
                                      borderRadius: BorderRadius.circular(
                                          8), // border corner radius
                                    ),
                                    child: Icon(
                                      Icons.receipt_outlined,
                                      size: 30,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center alignment vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // start alignment horizontally
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0,
                                            0), // Adjust the value as needed
                                        child: Text(
                                          'Order Accepted',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ], //children
                                  ),
                                  const Expanded(
                                    // Expands to take up remaining space
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // center alignment vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // end alignment horizontally
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0, 0,
                                              0), // Adjust the value as needed
                                          child: Text(
                                            '12:20 AM',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              fontFamily: 'Lato',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ], //children
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //3
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.10,
                                    height: screenHeight * 0.05,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.red[100], // background color
                                      borderRadius: BorderRadius.circular(
                                          8), // border corner radius
                                    ),
                                    child: Icon(
                                      Icons.fastfood_outlined,
                                      size: 30,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center alignment vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // start alignment horizontally
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0,
                                            0), // Adjust the value as needed
                                        child: Text(
                                          'Order Repaired',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ], //children
                                  ),
                                  const Expanded(
                                    // Expands to take up remaining space
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // center alignment vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // end alignment horizontally
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0, 0,
                                              0), // Adjust the value as needed
                                          child: Text(
                                            '12:20 AM',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              fontFamily: 'Lato',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ], //children
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //4
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.10,
                                    height: screenHeight * 0.05,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.red[100], // background color
                                      borderRadius: BorderRadius.circular(
                                          8), // border corner radius
                                    ),
                                    child: Icon(
                                      Icons.delivery_dining_outlined,
                                      size: 30,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center alignment vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // start alignment horizontally
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0,
                                            0), // Adjust the value as needed
                                        child: Text(
                                          'Order Pickup',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ], //children
                                  ),
                                  const Expanded(
                                    // Expands to take up remaining space
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // center alignment vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // end alignment horizontally
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0, 0,
                                              0), // Adjust the value as needed
                                          child: Text(
                                            '12:20 AM',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              fontFamily: 'Lato',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ], //children
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //5
                            SizedBox(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.10,
                                    height: screenHeight * 0.05,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.red[100], // background color
                                      borderRadius: BorderRadius.circular(
                                          8), // border corner radius
                                    ),
                                    child: Icon(
                                      Icons.notifications_none,
                                      size: 30,
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center alignment vertically
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // start alignment horizontally
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0,
                                            0), // Adjust the value as needed
                                        child: Text(
                                          'Order Delivered',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w100,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ], //children
                                  ),
                                  const Expanded(
                                    // Expands to take up remaining space
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly, // center alignment vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end, // end alignment horizontally
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(20, 0, 0,
                                              0), // Adjust the value as needed
                                          child: Text(
                                            '12:20 AM',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w100,
                                              fontFamily: 'Lato',
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ], //children
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenWidth * 0.08),

                        //DRIVER KO LAGI BANAKO
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 22.0), // Adjust this to fit your needs.
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Driver Details',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenWidth * 0.04),

                        // TODO: BUTTON BANAUNU BAKI XA YO CONTAINER LAI USING GESTURE DETECTOR
                        Column(
                          children: [
                            Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.10,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.03),
                                  Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.075,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly, // center alignment horizontally
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(20, 0, 0,
                                            0), // Adjust the value as needed
                                        child: Text(
                                          'Superman',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Lato',
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 0, 0),
                                            child: SizedBox(
                                              width: screenWidth * 0.065,
                                              height: screenWidth * 0.065,
                                              child: const Icon(
                                                Icons.star_rounded,
                                                size: 25,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            '4.9',
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 16,
                                              color: Colors.black54,
                                            ),
                                          )
                                        ],
                                      ),
                                    ], //children
                                  ),

                                  //BUTTON WITH ICON
                                  // SizedBox(width: screenWidth * 0.25),
                                  // Container(
                                  //   width: screenWidth * 0.15,
                                  //   height: screenHeight * 0.075,
                                  //   decoration: BoxDecoration(
                                  //     color:
                                  //         Colors.redAccent, // background color
                                  //     border: Border.all(
                                  //       color: Colors.redAccent, // border color
                                  //       width: 1, // border width
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(
                                  //         20), // border corner radius
                                  //   ),
                                  //   child: const Icon(
                                  //     Icons.phone_in_talk_outlined,
                                  //     size: 35,
                                  //     color: Colors.white,
                                  //   ),
                                  // ),

                                  //BUTTON WITH 'Write a Review'
                                  SizedBox(width: screenWidth * 0.05),
                                  InkWell(
                                    onTap:(){
                                      Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => ratingRider()),
                                      );
                                    },
                                    child: Container(
                                    width: constraints.maxWidth * 0.35,
                                    height: constraints.maxHeight * 0.075,
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.redAccent, // background color
                                      border: Border.all(
                                        color: Colors.redAccent, // border color
                                        width: 1, // border width
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          20), // border corner radius
                                    ),
                                    child:Center(
                                      child: Text(
                                          'Write a Review',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize:
                                            constraints.maxWidth * 0.04,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ) 
                                    
                                  ),

                                  )
                                   ],
                              ),
                            )
                          ],
                        ),
                        //SECOND BOX OF PRICES
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03),
                          height: MediaQuery.of(context).size.height * 0.36,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                          child: Column(children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.009,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Gainda Chowk, Sauraha, Chitwan',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.black54,
                              indent: 40,
                              endIndent: 40,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order Summary',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item Total',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Rs. ${subTotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Discount',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Rs. $disAmt',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery fee',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF00b27c),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Rs.${deliveryFee}',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF00b27c),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black54,
                              indent: 40,
                              endIndent: 40,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Grand Total',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Rs. ${subTotal - disAmt + deliveryFee}',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ]),
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
