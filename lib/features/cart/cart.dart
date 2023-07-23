import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:collection/collection.dart';

import '../user/confirmLocation.dart';

class cart extends StatefulWidget {
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  final pb = PocketBase('http://78.47.197.153');
  late int _counter;
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
  String ID ='';

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

  final TextEditingController _couponController = TextEditingController();

  void _validateCoupon() async {
    print(_couponController.text);
    try {
      final records = await pb.collection('coupons').getFullList(filter: 'coupon = "${_couponController.text}"');
      for (var record in records) {
      setState(() {
        disAmt = record.getIntValue('amount');
        ID= record.id;
        print(disAmt);
      }
      );
      await pb.collection('coupons').delete('$ID');
    } 
    if(disAmt==0){
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Aai ullu banako?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Ok'),
              ),
            ],
          );
        },
      );
    }
    }catch (e) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Aai ullu banako?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Haina dai'),
              ),
            ],
          );
        },
      );
    }
  }

  void _incrementCounter(int index) async {
    final Id = id[index];
    final updatedQuantity = quantity[index] + 1;
    final double updatedPrice = rate[index] * updatedQuantity;
    final formattedPrice = updatedPrice.toStringAsFixed(2);
    print(formattedPrice);

    final body = {
      'quantity': updatedQuantity,
      'price': formattedPrice,
    };

    try {
      await pb.collection('cart_details').update('$Id', body: body);
      setState(() {
        quantity[index] = updatedQuantity;
        price[index] = updatedPrice;
        subTotal = price.sum;
      });
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void _decrementCounter(int index) async {
    String Id = id[index];
    if (quantity[index] > 1) {
      final updatedQuantity = quantity[index] - 1;
      final double updatedPrice = rate[index] * updatedQuantity;
      final formattedPrice =
          updatedPrice.toStringAsFixed(2); // Format price with 2 decimal places
      final body = {
        'quantity': updatedQuantity,
        'price': formattedPrice,
      };
      try {
        await pb.collection('cart_details').update('$Id', body: body);
        setState(() {
          quantity[index] = updatedQuantity;
          price[index] = updatedPrice;
          subTotal = price.sum;
        });
      } catch (e) {
        print('Error updating quantity: $e');
      }
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
    return Scaffold(
      body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: constraints.maxWidth * 0.03,
                                top: constraints.maxHeight * 0.02,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.redAccent,
                                  size: 25,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: constraints.maxWidth * 0.23),
                            Text(
                              'Your Cart',
                              style: TextStyle(
                                height: constraints.maxHeight * 0.0025,
                                fontFamily: 'Lato',
                                fontSize: constraints.maxWidth * 0.06,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            children: [
                              Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    _counter = quantity[index];
                                    return Dismissible(
                                      key: Key(id[index]),
                                      background: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.redAccent,
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (_) {
                                        return showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirm'),
                                              content: Text(
                                                  'Are you sure you want to remove this item?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: Text('Yes'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (_) {
                                        _deleteItem(index);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.94,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.16,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.085,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                child: Image.network(
                                                  images[index],
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top:MediaQuery.of(context).size.height * 0.02,
                                                    ),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.45,
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              items[index],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontFamily:
                                                                    'Lato',
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01,
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width,
                                                            child: Text(
                                                              '${description[index].substring(0, 45)}...',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Lato',
                                                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.27,
                                                    child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(top: 17),
                                                        child: Text(
                                                          price[index]
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily: 'Lato',
                                                            color: Color(
                                                                0xFF28B996),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 0),
                                                        child:Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.11,
                                                            child:ElevatedButton(
                                                            onPressed: () =>
                                                                _decrementCounter(
                                                                    index),
                                                            child: Text(
                                                              '-',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              minimumSize:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Size>(
                                                                Size(15, 15),
                                                              ),
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      OutlinedBorder>(
                                                                CircleBorder(),
                                                              ),
                                                              side: MaterialStateProperty
                                                                  .all<
                                                                      BorderSide>(
                                                                BorderSide(
                                                                    width: 2,
                                                                    color: Color(
                                                                        0xFF28B996)),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Color>(
                                                                Colors.white,
                                                              ),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Color>(
                                                                Color(
                                                                    0xFF28B996),
                                                              ),
                                                            ),
                                                          ),

                                                          ),
                                                                                                                    Text(
                                                            _counter.toString(),
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.115,
                                                            child: ElevatedButton(
                                                            onPressed: () =>
                                                                _incrementCounter(
                                                                    index),
                                                            child: Text(
                                                              '+',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                color: Color(
                                                                    0xFF28B996),
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              minimumSize:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Size>(
                                                                Size(15, 15),
                                                              ),
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      OutlinedBorder>(
                                                                CircleBorder(),
                                                              ),
                                                              side: MaterialStateProperty
                                                                  .all<
                                                                      BorderSide>(
                                                                BorderSide(
                                                                    width: 2,
                                                                    color: Color(
                                                                        0xFF28B996)),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Color>(
                                                                Colors.white,
                                                              ),
                                                              foregroundColor:
                                                                  MaterialStateProperty
                                                                      .all<
                                                                          Color>(
                                                                Colors.green,
                                                              ),
                                                            ),
                                                          ),
 
                                                          ),
                                                          ],
                                                      ),
 
                                                      ),
                                                      ],
                                                  ),

                                                  ),
                                                  ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/popularMenu');
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.7),
                              child: Text(
                                '+ Add Item',
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent),
                              ),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.48),
              height: MediaQuery.of(context).size.height * 0.52,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: SingleChildScrollView(
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(40, 35, 0, 10),
                        child: Text(
                          'Add Coupon:',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: MediaQuery.of(context).size.height * 0.06,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7),
                                bottomLeft: Radius.circular(7))),
                        child: TextFormField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _validateCoupon();
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(7),
                                    bottomRight: Radius.circular(7))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Items',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          totalQty.toString(),
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sub-Total',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rs. ${subTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discount',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rs. $disAmt',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery fee',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rs.${deliveryFee}',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 41),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      '-------------------------------',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: MediaQuery.of(context).size.width * 0.0717,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Rs. ${(subTotal-disAmt+deliveryFee).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => confirmLocation()),
                      );
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.067,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFFCE479),
                                                Color(0xFFFFE607),
                                              ],
                                            ),),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        )),
                  )
                ]),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }

  void _deleteItem(int index) async {
    final itemId = id[index];

    try {
      await pb.collection('cart_details').delete(itemId);
      setState(() {
        id.removeAt(index);
        items.removeAt(index);
        quantity.removeAt(index);
        images.removeAt(index);
        description.removeAt(index);
        price.removeAt(index);
        totalQty = id.length;
        subTotal = price.sum;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deleted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
}