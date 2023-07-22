// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final pb = PocketBase('http://78.47.197.153');
  String _Email = '';
  bool isTrue= false;
  final TextEditingController _emailController = TextEditingController();

  Future<void> _ForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await pb.collection('users').requestPasswordReset(_Email);

      print('Email sent successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF45050),
            image: DecorationImage(
              image: AssetImage('lib/assets/images/background.png'),
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
                      SizedBox(height: constraints.maxWidth * 0.10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Container(
                          margin: EdgeInsets.only(left: constraints.maxWidth * 0.05, top: constraints.maxHeight * 0.02),
                          child:IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white, size: 35, ),
                            onPressed: () {
                              Navigator.pop(context); // Redirect to the previous page
                            },
                          ),
                        )
                      ),

                      SizedBox(height: constraints.maxWidth * 0.17),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:Container(
                          margin: EdgeInsets.only(left: constraints.maxWidth * 0.1),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: constraints.maxWidth * 0.1,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: constraints.maxWidth * 0.1),
                          child: Text(
                            'Please enter your registered \nemail address',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.05,
                              color: Colors.black,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * 0.25),

                      Container(
                        width: double.infinity,
                        height: constraints.maxWidth * 0.15,
                        margin: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.1385,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: constraints.maxWidth * 0.04, height: 1.8),
                            prefixIcon: Icon(Icons.person, color:Colors.red[300]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Username or Email';
                            }else if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            isTrue= true;
                            return null;
                          },
                          onSaved: (value) => _Email = value!,
                        ),
                      ),

                      SizedBox(height: constraints.maxWidth * 0.2),

                      GestureDetector(
                        onTap: () {
                          _ForgotPassword();
                          if(isTrue==true){
                            showDialog(
                              barrierColor: Colors.redAccent,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  //backgroundColor: Colors.redAccent,
                                  title: Text('Success!'),
                                  content: Text('The reset link has been sent to your email'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.redAccent
                                      ),),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            top: constraints.maxWidth * 0.05,
                            left: 70,
                            right: 70,
                          ),
                          width: 180,
                          height: 56,
                          decoration: BoxDecoration(
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
                            child: Center(
                              child: Text(
                                'Send Email',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.05,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: constraints.maxWidth * 0.045),

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
