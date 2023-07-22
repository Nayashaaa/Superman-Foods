import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/utils/utils.dart';


class profileSetting extends StatefulWidget {
  @override
  _profileSettingState createState() => _profileSettingState();
}

class _profileSettingState extends State<profileSetting>{
  dynamic uId;
  final pb = PocketBase('http://78.47.197.153');
  late String fullname;
  late String username;
  late String email;
  late String phone;
  late String address;
  late String img='';
  late var imgUrl=null;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  Future<void>? userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getuserId().then((_) {
      getUserDetails();
    });
  }

  Future<void> getuserId() async {
    try {
      uId = await SessionManager().get("userid");
      final record = await pb.collection('users').getOne(uId);
      final imgName = record.getStringValue('picture');
      final link = pb.files.getUrl(record, imgName);
      setState(() {
        img= imgName;
        imgUrl=link;
      });
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> getUserDetails() async {
    try {
      final record = await pb.collection('users').getOne(uId);
      
      setState(() {
        fullname = record.getStringValue('full_name');
        address = record.getStringValue('address');
        email = record.getStringValue('email');
        phone = record.getStringValue('contact');
        final imgName = record.getStringValue('picture');
        final link = pb.files.getUrl(record, imgName);

        _nameController.text = fullname;
        _emailController.text = email;
        _phoneController.text = phone;
        _addressController.text = address;
        imgUrl=link;

      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  Future<void> updateDetails() async{
    try{
      final body = <String, dynamic>{
        "full_name": _nameController.text,
        "address":_addressController.text,
        "email":_emailController.text,
        "phone": _phoneController.text,
      };
      await pb.collection('users').update(uId, body:body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    catch (e) {
      print('Error updating items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update profile'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void uploadimage() async{
    if (_image != null) {
    try {
      await pb.collection('users').update(uId,
        files: [
          http.MultipartFile.fromBytes(
            'picture',
            _image!,
            filename: 'profile_image.jpg',
          ),
        ],
      );
    } catch (e) {
      print('Error uploading image: $e');
    }
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
                    SizedBox(height: constraints.maxWidth * 0.07),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: constraints.maxWidth * 0.03, top: constraints.maxHeight * 0.02),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 25),
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.18),
                        Text(
                          'Profile Setting',
                          style: TextStyle(
                            height: constraints.maxHeight * 0.0025,
                            fontFamily: 'Lato',
                            fontSize: constraints.maxWidth * 0.065,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Container(
                      padding: EdgeInsets.fromLTRB(85, 0, 0, 0),
                      child: Stack(
                        children: [
                          _image!=null?
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!)
                          ):
                          img!=''? 
                          CircleAvatar(radius: 50,
                            backgroundImage: NetworkImage(imgUrl.toString())
                            ):
                        
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 55, color: Colors.redAccent),
                          ),

                          Container(
                              margin: EdgeInsets.all(60),
                              child: InkWell(
                                onTap: (){
                                  selectImage();
                                },
                                child:Container(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: MediaQuery.of(context).size.width * 0.15,
                                  padding: EdgeInsets.all(16.0), 
                                  decoration: BoxDecoration(
                                    color: Colors.amber[400],
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: Icon(Icons.camera_alt_outlined, size:30, color: Colors.white),
                                )
                                

                                
                              )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02,),
                    Container(
                      width: 340,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Name',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Lato',
                                color: Colors.redAccent
                              ),
                            ),
                          ),
                          TextField(
                            controller: _nameController,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                            ),
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.grey),
                              // ),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.03,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Address',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Lato',
                                  color: Colors.redAccent
                              ),
                            ),
                          ),
                          TextField(
                            controller: _addressController,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                            ),
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.grey),
                              // ),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.03,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Email',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Lato',
                                  color: Colors.redAccent
                              ),
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                            ),
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.grey),
                              // ),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.03,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Phone',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Lato',
                                  color: Colors.redAccent
                              ),
                            ),
                          ),
                          TextField(
                            controller: _phoneController,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                            ),
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                              // enabledBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.grey),
                              // ),
                            ),
                          ),
                          SizedBox(height: constraints.maxWidth * 0.09),
                          InkWell(
                            onTap: () {
                              
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: constraints.maxWidth * 0.05,
                                left: 50,
                                right: 50,
                              ),
                              width: 300,
                              height: 66,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Shadow color
                                    spreadRadius: 2, // Spread radius
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
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextButton(
                                onPressed:  () {
                                  updateDetails();
                                  uploadimage();
                                },
                                child: Center(
                                  child: Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.05,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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