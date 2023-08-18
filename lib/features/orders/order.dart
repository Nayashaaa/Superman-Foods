import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/widgets/bottom_menu.dart';

import '../../widgets/notification_button.dart';

class orders extends StatefulWidget {
  @override
  _ordersState createState() => _ordersState();
}

class _ordersState extends State<orders> {
  final pb = PocketBase('http://78.47.197.153');
 
  Future<void>? userFuture;
  dynamic email;
  List<String> id = [];
  List<String> status = [];
  List<int> amount=[];
  List<String> dateTime = [];
  String cust_email = '';

  @override
  void initState() {
    super.initState();
    userFuture = getuser();
    userFuture?.then((_) {
      getOrders();
    });
    }
  

  Future<void> getuser() async {
    try {
      email = await SessionManager().get("userid");
      cust_email = "\"$email\"";
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> getOrders() async{
    try{
      String fltr = 'customer = $cust_email';
      final resultList = await pb.collection('orders').getList(filter:fltr,sort: '-created');
      print("$resultList \n");
    }
    catch(e){
      print("error: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
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
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: constraints.maxWidth * 0.03,
                                  top: constraints.maxHeight * 0.02),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new,
                                    color: Colors.redAccent, size: 25),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(width: constraints.maxWidth * 0.14),
                            Text(
                              'Your Orders',
                              style: TextStyle(
                                height: constraints.maxHeight * 0.0025,
                                fontFamily: 'Lato',
                                fontSize: constraints.maxWidth * 0.06,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.2,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 14.0),
                              child: NotificationButton(
                                height: 50,
                                width: 50
                                ,
                              )
                            )
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.015,),
                         Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.1,
                          margin: EdgeInsets.only(bottom: 20.0),
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.008),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.14,
                                
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(Icons.verified,
                                color:  Color(0xFF28B996),
                                size: MediaQuery.of(context).size.width * 0.1,),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0, bottom: 5.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width *
                                                0.04,
                                          ),
                                          Row(children: [
                                            Text(
                                              'Delivered',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Lato',
                                                color: Color(0xFF28B996),
                                              ),
                                           ),
                                          
                                          SizedBox(width: MediaQuery.of(context).size.width * 0.2,),
                                          Text('May 14',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: MediaQuery.of(context).size.width * 0.036,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey
                                          ),
                                          ),
                                          Text('  |  ',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: MediaQuery.of(context).size.width * 0.036,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey
                                          ),
                                          ),
                                          Text('12:13',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: MediaQuery.of(context).size.width * 0.036,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey
                                          ),
                                          ),

                                          ],)
                                          
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                                    Row(children: [
                                      Padding(
                                      padding: EdgeInsets.only(left: 17.0),
                                      child: Text(
                                        'Order Id',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize:MediaQuery.of(context).size.width * 0.045,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.28,),
                                    Text('Rs.500',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: MediaQuery.of(context).size.width * 0.046,
                                      fontWeight: FontWeight.w600,
                                      color:  Color(0xFF28B996),
                                    ),)
                                    ],)
                                    
                                    
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
          ],
        ),
      ),
      bottomNavigationBar: BottomMenu(activeIndex: 4),
    ));
  }
}
