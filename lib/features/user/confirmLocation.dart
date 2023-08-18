import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:supertest/features/orders/order.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:collection/collection.dart';
import 'package:supertest/features/orders/orderedPanel.dart';

class confirmLocation extends StatefulWidget {
  const confirmLocation({super.key});

  @override
  State<confirmLocation> createState() => _confirmLocationState();
}

class _confirmLocationState extends State<confirmLocation> {
  final pb = PocketBase('http://78.47.197.153');

  Future<void>? userFuture;
  dynamic email;
  List<String> id = [];
  List<String> items = [];
  String cust_email = '';
  String userId = '';
  dynamic user;

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
      user = await SessionManager().get("userid");
      userId = "\"$user\"";
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  List<String> images = [];
  List<String> description = [];
  List<double> price = [];
  List<int> quantity = [];
  List<double> rate = [];
  double subTotal = 0;
  int totalQty = 0;
  int itemIndex = 0;

  Future<void> getCartDetails() async {
    try {
      print("apple");
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
        print(items);
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> addToOrder() async {
    print("one ordered");
    var data = {
      "customer": "$user",
      "total_cost": subTotal,
      "rider": "",
      "status": "Order Placed",
      "delivery_address": ""
    };
    try {
      final record = await pb.collection('orders').create(body: data);
    } catch (e) {
      print("Error adding item: $e");
    }
  }

  String orderId = "";
  Future<void> getOrders() async {
    try {
      var record = await pb
          .collection('orders')
          .getFullList(filter: 'customer = "$user"', sort: '-created');
      setState(() {
        orderId = record[0].id;
      });
      
    } catch (e) {
      print("errorS:$e");
    }
  }

  Future<void> createOrderItem() async {
    try {
      itemIndex= 0;
      for (var item in items) {
        var itemId = await pb.collection('menu_item').getFirstListItem('name = \"$item\"');
        print(itemId.id);
        var data = {
          "item": "${itemId.id}",
          "quantity": quantity[itemIndex],
          "rate": rate[itemIndex],
          "orderID": "$orderId"
        };
        final record = await pb.collection('ordered_item').create(body: data);
        print(itemIndex);
        itemIndex+=1;
      }
    } catch (e) {
      print("error:$e");
    }
  }
  Future<void> deleteFromCart() async {
    for(var item in id){
      await pb.collection('cart_details').delete('$item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                  top: MediaQuery.of(context).size.height * 0.02,
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
              SizedBox(width: MediaQuery.of(context).size.width * 0.23),
              Text(
                'Location',
                style: TextStyle(
                  height: MediaQuery.of(context).size.height * 0.0025,
                  fontFamily: 'Lato',
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07),
                child: Text('Deliver to:',
                    style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.w600)),
              )),
          InkWell(
              onTap: () async {
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Ordered()),
                );
                await addToOrder();
                await getOrders();
                await createOrderItem();
                await deleteFromCart();

                
                
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.height * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFFCE479),
                        Color(0xFFFFE607),
                      ],
                    ),
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('Confirm',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              fontWeight: FontWeight.w500))))),
          
        ]),
      )),
    );
  }
}
