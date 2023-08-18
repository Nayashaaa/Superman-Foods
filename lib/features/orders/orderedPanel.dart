// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supertest/features/trackOrders/trackOrder.dart';

class Ordered extends StatefulWidget {
  const Ordered({Key? key}) : super(key: key);

  @override
  State<Ordered> createState() => _OrderedState();
}

class _OrderedState extends State<Ordered> {
  double screenWidth = 600;
  double screenHeight = 400;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

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
                      "lib/assets/images/ordered.svg",
                      height: 300,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      "Your order has been successfully placed",
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
                        "Thankyou for your order, you can track the delivery in the order section",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      "Order ID: 45555",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return InkWell(
                        onTap: () {
                          
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: constraints.maxWidth * 0.05,
                            left: 50,
                            right: 50,
                          ),
                          width: 300,
                          height: 75,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(0, 7), // Offset
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
                              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TrackOrder()),
                );
                            },
                            child: Center(
                              child: Text(
                                'Track your Order',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.06,
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
          }
          ),
    );
  }
}
