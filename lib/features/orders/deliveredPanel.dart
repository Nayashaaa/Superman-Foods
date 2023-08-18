// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Delivered extends StatefulWidget {
  const Delivered({Key? key}) : super(key: key);

  @override
  State<Delivered> createState() => _DeliveredState();
}

class _DeliveredState extends State<Delivered> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageView.builder(
          itemCount: 3,
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "lib/assets/images/delivered.svg",
                      height: 300,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Your order has been delivered successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        "Thank you for your order, you can write a review to the rider, restaurant, and food",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return GestureDetector(
                        onTap: () {
                          // actions here
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
                                blurRadius: 10,
                                offset: Offset(0, 7),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFCE479),
                                Color.fromARGB(255, 255, 217, 46),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/ratingRider');
                            },
                            child: Center(
                              child: Text(
                                'Write a Review',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ]),
            );
          }),
    );
  }
}

