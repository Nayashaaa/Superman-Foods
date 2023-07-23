// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supertest/features/home/home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _keepSignedIn = false;
  final _formKey = GlobalKey<FormState>();
  final pb = PocketBase('http://78.47.197.153');
  String _usernameOrEmail = '';
  String _password = '';
  bool isTrue = false;
  final TextEditingController _passwordController = TextEditingController();
  String uname='';
  String categories = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkLoggedIn();
  }

  void checkLoggedIn() async {
    bool isLoggedIn = await SessionManager().get("isLoggedIn") ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }


  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final authData = await pb.collection('users').authWithPassword(
          _usernameOrEmail,
          _password,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );

        print(pb.authStore.token);
        

        print('User logged in successfully');

        final record = await pb.collection('users').getOne(pb.authStore.model.id);
        //print(record);

        var sessionManager = SessionManager();

        if (_keepSignedIn) {
          // Set the value to true only when the checkbox is checked
          await sessionManager.set("isLoggedIn", true);
        }

        await sessionManager.set("username", record.getStringValue('username'));
        await sessionManager.set("userid", pb.authStore.model.id);
        await sessionManager.set("email", record.getStringValue('email'));

        dynamic uemail = await SessionManager().get("email");
        dynamic uid = await SessionManager().get("userid");
        dynamic unm = await SessionManager().get("username");
        dynamic log = await SessionManager().get("isLoggedIn");
        
      } catch (e) {
        print('Error logging in: $e');
      }
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
    return Scaffold(
    body: WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Form(
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
                      SizedBox(height: constraints.maxWidth * 0.305),
                      Container(
                        child: Center(
                          child: Text(
                            'Login to your Account',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.062,
                              fontFamily: 'Lato',
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxWidth * 0.095),
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
                            hintText: "Username or Email",
                            hintStyle: TextStyle(fontSize: constraints.maxWidth * 0.035, height: 1.6),
                            prefixIcon: Icon(Icons.person, color:Colors.red[300]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Username or Email';
                            }
                            return null;
                          },
                          onSaved: (value) => _usernameOrEmail = value!,
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
                            isTrue = true;
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                      ),

                      SizedBox(height: 5),
                      Container(
                        //color: Colors.black,
                        height: constraints.maxWidth * 0.10,
                        padding: EdgeInsets.only(left: constraints.maxWidth * 0.1385, bottom: 20 ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              _keepSignedIn = !_keepSignedIn;
                            });
                          },
                          child: CheckboxListTile(
                            title: Text(
                              'Keep me signed in',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontFamily: 'Lato',
                                color: Colors.white,
                              ),
                            ),
                            value: _keepSignedIn,
                            onChanged: (bool? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _keepSignedIn = newValue;
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

                      SizedBox(height: constraints.maxWidth * 0.06),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/forgotpw');
                        },
                        child: Text(
                          'Fogrot Password',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                            color: Colors.white,
                            fontFamily: 'Lato',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      SizedBox(height: constraints.maxWidth * 0.02),
                      InkWell(
                        onTap: () {

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
                            onPressed: (){
                              _loginUser();
                              // if(isTrue==true){
                              //   Navigator.pushNamed(context, '/home');
                              // }
                              // else{
                              //
                              // }
                            },
                            child: Center(
                              child: Text(
                                'Log In',
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
                      SizedBox(height: constraints.maxWidth * 0.045),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Do not have an account? Register here',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                            color: Colors.white,
                            fontFamily: 'Lato',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    )
    );
  }
}
