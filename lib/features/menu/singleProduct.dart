import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/features/cart/cart.dart';

class singleProduct extends StatefulWidget {
  final String items;
  final String description;
  final String price;
  final String images;
  final String calories;
  final String ratings;
  final String reviews;
  final String itemId;
  singleProduct(
      {required this.items,
      required this.description,
      required this.price,
      required this.images,
      required this.calories,
      required this.reviews,
      required this.ratings,
      required this.itemId});

  @override
  _singleProductState createState() => _singleProductState();
}

class _singleProductState extends State<singleProduct> {
  final pb = PocketBase('http://78.47.197.153');
  int _counter = 1;
  late double rate;
  Future<void>? userFuture;
  dynamic email;

  @override
  void initState() {
    super.initState();
    userFuture = getuser();
  }

  Future<void> getuser() async {
    try {
      email = await SessionManager().get("email");
           
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
  }

  Future<void> addToCart() async {
    rate = double.parse(widget.price) ;
    final body = <String, dynamic>{
      "name": widget.items,
      "image": widget.images,
      "description": widget.description,
      "quantity": _counter,
      "price": rate * _counter,
      "customer": email,
      "rate" : rate
    };

    try {
      final record = await pb.collection('cart_details').create(body: body);
      print("Item added to cart: $record");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            titlePadding: EdgeInsets.fromLTRB(42, 50, 0, 30),
            title: Text('Item added to cart!',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            actions: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context); // Redirect to the same page
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(15)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ))),
                    TextButton(
                      child: Text(
                        'View cart',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => cart()),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        },
      );
    } catch (e) {
      print("Error adding item to cart: $e");
    }
  }

  Future<void> addToFav() async {
    final body = <String, dynamic>{
      "food_id": widget.itemId,
      "customer": email,
    };

    try {
      await pb.collection('favourites').create(body: body);
      print("Item added to favourites");
      
      } catch (e) {
      print("Error adding item to favourites: $e");
    }
  }



  String get totalPrice => (double.parse(widget.price) * _counter).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return SafeArea( 
    child:Scaffold(
      body: Container(
          child: Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final mediaQuery = MediaQuery.of(context);
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Stack(
                    children: [
                      Container(
                          height: mediaQuery.size.height * 0.5,
                          width: constraints.maxWidth * 1,
                          child: Stack(
                            children: [
                              Image.network(
                                widget.images,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                top: mediaQuery.size.height * 0.02,
                                right: mediaQuery.size.width * 0.85,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white, size: 35),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          )

                          //padding: EdgeInsets.only(top: 45, left: 15),

                          ),
                      Positioned(
                          top: mediaQuery.size.height * 0.4,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: mediaQuery.size.height * 0.6,
                            padding: EdgeInsets.only(top: 30, left: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.white),
                            child: Column(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.items,
                                  style: TextStyle(
                                      fontSize: mediaQuery.size.width * 0.075,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.005,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_half_rounded,
                                    color: Colors.redAccent,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.02,
                                  ),
                                  Text(widget.ratings,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    ' (${widget.reviews} Reviews)',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.26,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.22,
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.fromBorderSide(
                                          BorderSide(color: Color(0xFF28B996))),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Deliverable',
                                        style: TextStyle(
                                            color: Color(0xFF28B996),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.003,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.grey, size: 25),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.03,
                                  ),
                                  Text(
                                    '2.0 KM',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.06,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.05,
                                  ),
                                  Text(
                                    '🔥 ${widget.calories} Kcal',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.06,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.07,
                                  ),
                                  Text(
                                    '⏰  20 Min',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.01,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.21,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0,0,20,0),
                                    child: Text(
                                      widget.description,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: mediaQuery.size.width * 0.038,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              
                              Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: _decrementCounter,
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                          fontSize: mediaQuery.size.width * 0.063, color: Colors.green),
                                    ),
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        Size(15, 15),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        CircleBorder(),
                                      ),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                            width: 2, color: Color(0xFF28B996)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color(0xFF28B996),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '$_counter',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: mediaQuery.size.width * 0.054,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: _incrementCounter,
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: mediaQuery.size.width * 0.063,
                                          color: Color(0xFF28B996)),
                                    ),
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        Size(22, 22),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        CircleBorder(),
                                      ),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                            width: 1.8, color: Color(0xFF28B996)),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: mediaQuery.size.width * 0.26,
                                  ),
                                  Text(
                                    'Rs. $totalPrice',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: mediaQuery.size.width * 0.06,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF28B996)),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: mediaQuery.size.height * 0.01,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        // Perform the sign-up action here
                                        // You can access the entered values using TextEditingController
                                      },
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          width: mediaQuery.size.width * 0.67,
                                          height: mediaQuery.size.height * 0.076,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5), // Shadow color
                                                spreadRadius:
                                                    2, // Spread radius
                                                blurRadius: 5, // Blur radius
                                                offset: Offset(0, 3), // Offset
                                              ),
                                            ],
                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFFCE479),
                                                Color(0xFFFFE607),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: TextButton(
                                            onPressed: () {
                                              addToCart();
                                            },
                                            child: Center(
                                              child: Text(
                                                'Add to Cart',
                                                style: TextStyle(
                                                  fontSize:
                                                      constraints.maxWidth *
                                                          0.05,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    width: constraints.maxWidth * 0.04,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      addToFav();
                                    },
                                    child: Container(
                                      width: mediaQuery.size.width * 0.16,
                                      height: mediaQuery.size.height * 0.076,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color.fromRGBO(244, 80, 80, 0.3),
                                      ),
                                      child: Icon(Icons.favorite_rounded,
                                          color: Color(0xFFF45050), size: 27),
                                    ),
                                  )
                                ],
                              )
                            ]),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      )),
    )
    );
  }
}