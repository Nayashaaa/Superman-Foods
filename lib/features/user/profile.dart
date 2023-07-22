import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:supertest/main.dart';
import 'package:pocketbase/pocketbase.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{
  final pb = PocketBase('http://78.47.197.153');
  dynamic uname;
  dynamic uId;
  dynamic email;
  late var imgUrl=null;
  late String img ='';
  Future<void>? userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getuser();
  }
  Future<void> getuser() async {
    try{
      uId = await SessionManager().get("userid");
      uname = await SessionManager().get("username");
      email = await SessionManager().get("email");
      final record = await pb.collection('users').getOne(uId);
      final imgName = record.getStringValue('picture');
      final link = pb.files.getUrl(record, imgName);
      setState(() {
        img = imgName;
        imgUrl=link;
      });
    }
    catch(e){
      print('Error fetching user details: $e');
    }
  }

  Future<void> logout() async {
    try{
      await SessionManager().destroy();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
    }
    catch(e){
      print('Error logging out: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/profile.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03, top: MediaQuery.of(context).size.height * 0.02),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25),
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                        Text(
                          'Profile',
                          style: TextStyle(
                            height: MediaQuery.of(context).size.height * 0.0025,
                            fontFamily: 'Lato',
                            fontSize: MediaQuery.of(context).size.width * 0.065,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                    img!=''?
                    CircleAvatar(radius: MediaQuery.of(context).size.width * 0.13,
                            backgroundImage: NetworkImage(imgUrl.toString())
                            ):
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.13,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 55, color: Colors.redAccent),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                    FutureBuilder<void>(
                    future: userFuture,
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); 
                      } else if (snapshot.hasError) {
                        return Text('Error fetching user details'); 
                      } else {
                        return Column(
                          children: [
                            Text(
                              uname ?? '',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              email ?? '',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.075,),

                    Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/profileSetting');
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.06))
                                ),
                                child: Row(
                                    children: [
                                      SizedBox(width: constraints.maxWidth * 0.12,),
                                      Icon(Icons.person_2_outlined, color: Colors.redAccent),
                                      SizedBox(width: constraints.maxWidth * 0.05,),
                                      Text(
                                        'Profile setting',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(width: constraints.maxWidth * 0.342),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 21),
                                    ]
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('Your fav tapped!');
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.06))
                                ),
                                child: Row(
                                    children: [
                                      SizedBox(width: constraints.maxWidth * 0.12,),
                                      Icon(Icons.favorite_border_rounded, color: Colors.redAccent),
                                      SizedBox(width: constraints.maxWidth * 0.05,),
                                      Text(
                                        'Your favorites',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: constraints.maxWidth * 0.3435,),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 21),
                                    ]
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.06))
                                ),
                                child: Row(
                                    children: [
                                      SizedBox(width: constraints.maxWidth * 0.12,),
                                      Icon(Icons.event_note_outlined, color: Colors.redAccent),
                                      SizedBox(width: constraints.maxWidth * 0.05,),
                                      Text(
                                        'Your Orders',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: constraints.maxWidth * 0.3835,),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 21),
                                    ]
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/privacy');
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.06))
                                ),
                                child: Row(
                                    children: [
                                      SizedBox(width: constraints.maxWidth * 0.12,),
                                      Icon(Icons.privacy_tip_outlined, color: Colors.redAccent),
                                      SizedBox(width: constraints.maxWidth * 0.05,),
                                      Text(
                                        'Privacy policy',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: constraints.maxWidth * 0.348,),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 21),
                                    ]
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/return');
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.06))
                                ),

                                child: Row(
                                  children: [
                                    SizedBox(width: constraints.maxWidth * 0.12,),
                                    Icon(Icons.assignment_return_outlined, color: Colors.redAccent),
                                    SizedBox(width: constraints.maxWidth * 0.05,),
                                    Text(
                                      'Return policy',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(width: constraints.maxWidth * 0.362,),
                                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 21),
                                  ]
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.withOpacity(0.06))
                                ),
                                child: Row(
                                    children: [
                                      SizedBox(width: constraints.maxWidth * 0.12,),
                                      Icon(Icons.track_changes_outlined, color: Colors.redAccent),
                                      SizedBox(width: constraints.maxWidth * 0.05,),
                                      Text(
                                        'Track your order',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: constraints.maxWidth * 0.303,),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Colors.redAccent, size: 21),
                                    ]
                                ),
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.04,),

                            InkWell(
                              onTap: () {
                                logout();
                              },
                              child: Container(
                                height: constraints.maxHeight * 0.068,
                                child: Row(
                                    children: [
                                      SizedBox(width: constraints.maxWidth * 0.12,),
                                      Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                                        child: Icon(Icons.logout_outlined, color: Colors.redAccent),
                                      ),
                                      SizedBox(width: constraints.maxWidth * 0.05,),
                                      Text(
                                        'Logout',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ],
                        )
                    )
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