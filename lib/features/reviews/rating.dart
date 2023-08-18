import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class Rating extends StatefulWidget {
  final String title;
  final IconData avatarIcon;
  final String userName;
  final String userRole;
  // final String databaseTable;

  Rating({
    required this.title,
    required this.avatarIcon,
    required this.userName,
    required this.userRole,
    // required this.databaseTable,
  });

  @override
  State<Rating> createState() => _ratingState();
}

class ratingRider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Rating(
        title: 'Rider Review',
        avatarIcon: Icons.person,
        userName: 'Superman KC',
        userRole: 'Delivery Man',
        // databaseTable: 'rider_reviews',
      ),
    );
  }
}

class ratingFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Rating(
        title: 'Food Review',
        avatarIcon: Icons.fastfood,
        userName: 'Pizza Margherita',
        userRole: 'Pizza',
        // databaseTable: 'food_reviews',
      ),
    );
  }
}

class ratingRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Rating(
        title: 'Restaurant Review',
        avatarIcon: Icons.fastfood,
        userName: 'The burger House',
        userRole: 'restaurant',
        // databaseTable: 'food_reviews',
      ),
    );
  }
}

class _ratingState extends State<Rating> {
  @override
  String get ratingText {
    if (widget.title == 'Rider Review') {
      return 'Please Rate Delivery Service';
    } else if (widget.title == 'Food Review') {
      return 'Please Rate Food';
    } else if (widget.title == 'Restaurant Review') {
      return 'Please Rate Restaurant';
    }
    return 'Please Rate';
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),
                child: Column(
                  children: [
                    SizedBox(height: screenWidth * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.03,
                              top: screenHeight * 0.02),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new,
                                color: Colors.redAccent.shade200, size: 25),
                            onPressed: () {
                              if (widget.title == 'Rider Review') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              }
                              if (widget.title == 'Food Review') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ratingRider()),
                                );
                              }
                              if (widget.title == 'Restaurant Review') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ratingFood()),
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: screenHeight * 0.0025,
                              fontFamily: 'Lato',
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03 + 40),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(widget.avatarIcon,
                            size: 55, color: Colors.redAccent),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      widget.userName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      widget.userRole,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 22,
                        fontWeight: FontWeight.w100,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      ratingText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 50,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                              Icons.star_rounded,
                              color: Colors.redAccent.shade200,
                            ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        }),
                    SizedBox(height: screenHeight * 0.2),
                    GestureDetector(
                      onTap: () {
                        if (widget.title == 'Rider Review') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ratingFood()),
                          );
                        } else if (widget.title == 'Food Review') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ratingRestaurant()),
                          );
                        } else if (widget.title == 'Restaurant Review') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home()),
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: screenWidth * 0.05,
                          left: 50,
                          right: 50,
                        ),
                        width: 300,
                        height: 75,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFCE479),
                              Color(0xFFFFE607),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (widget.title == 'Rider Review') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ratingFood()),
                              );
                            } else if (widget.title == 'Food Review') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ratingRestaurant()),
                              );
                            } else if (widget.title == 'Restaurant Review') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              'Submit Review',
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
