// ignore_for_file: unused_field, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../main.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final bool _keepSignedIn = false;
  bool _emailSpecialPricing = false;
  final _formKey = GlobalKey<FormState>();
  final pb = PocketBase('http://78.47.197.153');
  String _username = '';
  String _fullname = '';
  String _email = '';
  String _password = '';
  String _cpassword = '';
  
  final TextEditingController _passwordController = TextEditingController();


  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final body = <String, dynamic>{
        "full_name": _fullname,
        "username": _username,
        "email": _email,
        "emailVisibility": true,
        "password": _password,
        "passwordConfirm": _cpassword
      };

      final record = await pb.collection('users').create(body: body);
      await pb.collection('users').requestVerification(_email);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

      print('User registered successfully');

    }
  }

  Future<void> loadFont() async {
    final fontData = await rootBundle.load('lib/assets/fonts/Viga-Regular.ttf');
    final font = FontLoader('Viga');
    font.addFont(Future.value(ByteData.view(fontData.buffer)));
    await font.load();
  }

  @override
  void initState() {
    super.initState();
    loadFont();
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
                    SizedBox(height: constraints.maxWidth * 0.28),
                    Container(
                      height: 58,
                      child: Center(
                        child: Text(
                          'SUPERMAN',
                          style: TextStyle(
                            fontFamily: 'Viga',
                            fontSize: constraints.maxWidth * 0.13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: constraints.maxWidth * 0.17),
                        child: Text(
                          'Food-Delivery',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.05,
                            color: Colors.white,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth * 0.105),
                    Container(
                      child: Center(
                        child: Text(
                          'Sign Up For Free',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.062,
                            fontFamily: 'Lato',
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth * 0.045),
                    Container(
                      width: double.infinity,
                      height: constraints.maxWidth * 0.136,
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
                          hintText: "Full Name",
                          hintStyle: TextStyle(fontSize: constraints.maxWidth * 0.035, height: 1.6),
                          prefixIcon: Icon(Icons.person, color:Colors.red[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                        onSaved: (value) => _fullname = value!,
                      ),
                    ),

                    SizedBox(height: constraints.maxWidth * 0.035),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.136,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1385,
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
                          hintText: "Username",
                          hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035, height: 1.6),
                          prefixIcon: Icon(Icons.person, color:Colors.red[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onSaved: (value) => _username = value!,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.035),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.136,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1385,
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
                          hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035, height: 1.6),
                          prefixIcon: Icon(Icons.email_rounded, color:Colors.red[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value!,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.035),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.136,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1385,
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
                          hintText: "Password",
                          hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035, height: 1.6),
                          prefixIcon: Icon(Icons.lock, color:Colors.red[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.035),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.136,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1385,
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
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035, height: 1.6),
                          prefixIcon: Icon(Icons.lock, color:Colors.red[300]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onSaved: (value) => _cpassword = value!,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Container(
                    //   //color: Colors.black,
                    //   height: constraints.maxWidth * 0.10,
                    //   padding: EdgeInsets.only(left: constraints.maxWidth * 0.1385, bottom: 20 ),
                    //   child: InkWell(
                    //     behavior: HitTestBehavior.translucent,
                    //     onTap: () {
                    //       setState(() {
                    //         _keepSignedIn = !_keepSignedIn;
                    //       });
                    //     },
                    //     // child: CheckboxListTile(
                    //     //   title: Text(
                    //     //     'Keep me signed in',
                    //     //     style: TextStyle(
                    //     //       fontSize: MediaQuery.of(context).size.width * 0.04,
                    //     //       fontFamily: 'Lato',
                    //     //       color: Colors.white,
                    //     //     ),
                    //     //   ),
                    //     //   value: _keepSignedIn,
                    //     //   onChanged: (bool? newValue) {
                    //     //     if (newValue != null) {
                    //     //       setState(() {
                    //     //         _keepSignedIn = newValue;
                    //     //       });
                    //     //     }
                    //     //   },
                    //     //   activeColor: Colors.white,
                    //     //   checkColor: Colors.red,
                    //     //   controlAffinity: ListTileControlAffinity.leading,
                    //     //   contentPadding: EdgeInsets.zero,
                    //     // ),
                    //   ),
                    // ),
                    SizedBox(height: 4),
                    Container(
                      height: constraints.maxWidth * 0.06,
                      padding: EdgeInsets.only(left: constraints.maxWidth * 0.1385),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            _emailSpecialPricing = !_emailSpecialPricing;
                          });
                        },
                        child: CheckboxListTile(
                          title: Text(
                            'Get special pricing by email',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontFamily: 'Lato',
                              color: Colors.white,
                            ),
                          ),
                          value: _emailSpecialPricing,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _emailSpecialPricing = newValue;
                              });
                            }
                          },
                          activeColor: Colors.white,
                          checkColor: Colors.red,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxWidth * 0.07),
                    InkWell(
                      onTap: () {
                        // Perform the sign-up action here
                        // You can access the entered values using TextEditingController
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: constraints.maxWidth * 0.05,
                          left: 70,
                          right: 70,
                        ),
                        width: 250,
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
                        child: TextButton(
                          onPressed: _registerUser,
                          child: Center(
                            child: Text(
                              'Create Account',
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
                    SizedBox(height: constraints.maxWidth * 0.040),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.04,
                          color: Colors.white,
                          fontFamily: 'Lato',
                          decoration: TextDecoration.underline,
                        ),
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

