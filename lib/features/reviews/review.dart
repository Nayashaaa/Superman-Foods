import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class Reviews extends StatefulWidget {
  @override
  State<Reviews> createState() => _reviewsState();
}

class _reviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxWidth * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: constraints.maxWidth * 0.03,
                                top: constraints.maxHeight * 0.02),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  color: Colors.redAccent, size: 25),
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                            ),
                          ),
                          Text(
                            'Reviews',
                            style: TextStyle(
                              height: constraints.maxHeight * 0.0025,
                              fontFamily: 'Lato',
                              fontSize: constraints.maxWidth * 0.065,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                              width: constraints.maxWidth * 0.03 +
                                  40), // Adding a SizedBox to balance the space taken by the IconButton.
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              '4.5',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w900,
                                fontSize: constraints.maxWidth * 0.1,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // This aligns children along the horizontal axis
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0,
                                    0), // You can adjust the padding value here
                                child: RatingBarIndicator(
                                  rating: 4.5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 40,
                                  direction: Axis.horizontal,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 0,
                                    0), // You can adjust the padding value here
                                child: Text(
                                  '100 Reviews',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w100,
                                    fontSize: constraints.maxWidth * 0.043,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: constraints.maxHeight * 0.04),
                      Column(
                        children: [
                          Container(
                            height: constraints.maxHeight * 0.13,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                SizedBox(width: constraints.maxWidth * 0.05),
                                Container(
                                  width: constraints.maxWidth * 0.16,
                                  height: constraints.maxHeight * 0.085,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Expanded(
                                  // Add this to make sure the column takes all the remaining width
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // center alignment horizontally
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // add another Row
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween, // Add this line
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Text(
                                              'Burger',
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
                                              rating: 4.5,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star_rounded,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 25,
                                              direction: Axis.horizontal,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: constraints.maxHeight * 0.01),
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
                          )
                        ],
                      ),
                      // //BUTTON
                      // GestureDetector(
                      //   onTap: () {
                      //     // Your Firebase code here to save the rating and comment
                      //     // Make sure to use `widget.databaseTable` to determine which table to save to
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(
                      //       top: constraints.maxWidth * 0.05,
                      //       left: 50,
                      //       right: 50,
                      //     ),
                      //     width: 300,
                      //     height: 75,
                      //     decoration: BoxDecoration(
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.grey
                      //               .withOpacity(0.5), // Shadow color
                      //           spreadRadius: 2, // Spread radius
                      //           blurRadius: 5, // Blur radius
                      //           offset: Offset(0, 3), // Offset
                      //         ),
                      //       ],
                      //       gradient: const LinearGradient(
                      //         begin: Alignment.centerLeft,
                      //         end: Alignment.centerRight,
                      //         colors: [
                      //           Color(0xFFFCE479),
                      //           Color(0xFFFFE607),
                      //         ],
                      //       ),
                      //       borderRadius: BorderRadius.circular(25),
                      //     ),
                      //     child: TextButton(
                      //       onPressed: () {},
                      //       child: Center(
                      //         child: Text(
                      //           'Submit Review',
                      //           style: TextStyle(
                      //             fontSize: constraints.maxWidth * 0.06,
                      //             fontWeight: FontWeight.w700,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: constraints.maxWidth * 0.03),
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
