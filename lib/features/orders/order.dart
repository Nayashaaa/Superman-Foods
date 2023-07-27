import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/features/menu/singleProduct.dart';
import 'package:supertest/widgets/bottom_menu.dart';

import '../../widgets/notification_button.dart';

class orders extends StatefulWidget {
  @override
  _ordersState createState() => _ordersState();
}

class _ordersState extends State<orders> {
 

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
