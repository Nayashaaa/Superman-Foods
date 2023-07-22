import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/singleProduct.dart';

import 'notification_button.dart';

class favourites extends StatefulWidget {
  @override
  _favouritesState createState() => _favouritesState();
}

class _favouritesState extends State<favourites> {
  final pb = PocketBase('http://78.47.197.153');

  dynamic email;
  String cust_email = '';
  Future<void>? userFuture;
  Future<void>? itemFuture;

  List<String> items = [];
  List<String> images = [];
  List<String> description = [];
  List<String> price = [];
  List<String> ID = [];
  List<String> calories = []; 
  List<String> filteredItems = [];
  List<int> reviews = [];
  List<int> totalRating = [];
  List<double> rating = [];
  List<String> pk = [];
  List<bool> isFav = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    userFuture = getuser();
    userFuture?.then((_) {
      itemFuture = getFavItem();
      itemFuture?.then((_){
        fetchItems();
      });
    });
  }

  Future<void> getuser() async {
    try {
      email = await SessionManager().get("email");
      setState(() {
        cust_email = "\"$email\"";
      });
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  void _deleteItem(int index) async {
    final itemId = pk[index];

    try {
      await pb.collection('favourites').delete(itemId);
      setState(() {
        isFav[index] = false;
      });
    } catch (e) {
      print('Error deleting item: $e');
    }
  }


  Future<void> getFavItem() async{
    String fltr = 'customer = $cust_email';
    try{ 
      final records = await pb.collection('favourites').getFullList(filter: fltr);
      
      setState(() {
        ID =[];
        pk = [];
        isFav = [];
        for (var record in records){
        String foodId = record.getStringValue('food_id');
        String itemID = record.id;
        ID.add(foodId);
        pk.add(itemID);
        isFav.add(true);
      }
      });
      
    }
    catch (e){
      print(e);
    }
  }


  Future<void> fetchItems() async {
    try {
      setState(() {
        items = [];
        images = [];
        price = [];
        rating = [];
        description = [];
        calories = [];
        reviews = [];
        totalRating = [];
      });
      ID = (ID.toSet()).toList();
      for(String item in ID){
        item = "\"$item\"";
        String filt = 'id = $item';
        final resultList = await pb.collection('menu_item').getFullList(filter: filt);
        setState(() {
        for (var record in resultList) {
          String name = record.getStringValue('name') as String;
          String imageUrl = record.getStringValue('image') as String;
          String cost = record.getStringValue('price') as String;
          int rates = record.getIntValue('rating') as int;
          String descr = record.getStringValue('description') as String;
          String calorie = record.getStringValue('calories') as String;
          int review = record.getIntValue('reviews') as int;

          double rate = rates/review;
          items.add(name);
          images.add(imageUrl);
          price.add(cost);
          totalRating.add(rates);
          description.add(descr);
          calories.add(calorie);
          reviews.add(review);
          rating.add(rate);
          
        }
      });
      }
        
    } catch (e) {
      print('Error fetching items: $e');
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
                                  Navigator.pushNamed(context, '/home');
                                },
                              ),
                            ),
                            SizedBox(width: constraints.maxWidth * 0.14),
                            Text(
                              'Your Favourites',
                              style: TextStyle(
                                height: constraints.maxHeight * 0.0025,
                                fontFamily: 'Lato',
                                fontSize: constraints.maxWidth * 0.06,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * 0.1,
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
                        SizedBox(
                          height: constraints.maxHeight * 0.03,
                        ),
                        Column(
                children: List.generate(items.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => singleProduct(
                              items: items[index],
                              description: description[index],
                              price: price[index],
                              images: images[index],
                              calories: calories[index],
                              ratings: (rating[index]).toString(),
                              reviews: (reviews[index]).toString(),
                              itemId: (ID[index]),),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.12,
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.16,
                            height: MediaQuery.of(context).size.height * 0.085,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                      Container(
                                        width: 210,
                                        child: Text(
                                          items[
                                              index], // Use the dynamic item name
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Lato',
                                          ),
                                        ),
                                      ),

                                      //SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.555,
                                      child: Padding(
                                      padding: EdgeInsets.only(left: 17.0),
                                      child: Text(
                                        '${description[index].substring(0, 25)}...',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize:MediaQuery.of(context).size.width * 0.035,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _deleteItem(index);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        decoration: BoxDecoration(
                                          color: Colors.pink[50],
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Icon(
                                          isFav[index]?
                                          Icons.favorite_rounded:Icons.favorite_border_rounded,
                                          size: 18,
                                          color: Colors.red, // Update the icon color dynamically
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                    Text(
                                      price[index],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Lato',
                                        color: Color(0xFF28B996),
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
