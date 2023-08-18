import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/notification_button.dart';
import '../home/home.dart';

class Reviews extends StatefulWidget {
  @override
  State<Reviews> createState() => _reviewsState();
}

class _reviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: Column(
                    children: [
                      SizedBox(height: screenWidth * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: screenWidth * 0.03,
                                top: screenHeight * 0.02),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.redAccent, size: 25),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              },
                            ),
                          ),
                          Text(
                            'Reviews',
                            style: TextStyle(
                              height: screenHeight * 0.0025,
                              fontFamily: 'Lato',
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(top: 14.0, right: 20),
                              child: NotificationButton(
                                height: 50,
                                width: 50,
                              ))
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              '4.5',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                fontSize: screenWidth * 0.1,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: RatingBarIndicator(
                                  rating: 4.5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: Colors.redAccent.shade200,
                                  ),
                                  itemCount: 5,
                                  itemSize: 35,
                                  direction: Axis.horizontal,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: Text(
                                  '100 Reviews',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w100,
                                    fontSize: screenWidth * 0.040,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Column(
                        children: [
                          Container(
                            height: screenHeight * 0.13,
                            width: screenWidth * 0.95,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                SizedBox(width: screenWidth * 0.05),
                                Container(
                                  width: screenWidth * 0.16,
                                  height: screenHeight * 0.085,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Text(
                                              'Bat Man',
                                              style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 20, 0),
                                            child: RatingBarIndicator(
                                              rating: 5,
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star_rounded,
                                                color:
                                                    Colors.redAccent.shade200,
                                              ),
                                              itemCount: 5,
                                              itemSize: 25,
                                              direction: Axis.horizontal,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Text(
                                          '05 May, 2023',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Lato',
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            indent: 15,
                            endIndent: 15,
                          ),
                        ],
                      ),
                      SizedBox(height: screenWidth * 0.03),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
