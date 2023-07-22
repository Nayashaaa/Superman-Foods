import 'package:flutter/material.dart';
import 'package:supertest/features/cart/cart.dart';
import 'package:supertest/features/categories/categories.dart';
import 'package:supertest/features/categories/category_menu.dart';
import 'package:supertest/features/favourites/favourites.dart';
import 'package:supertest/features/menu/popularMenu.dart';
import 'package:supertest/features/restaurant/popularRestaurant.dart';
import 'package:supertest/features/policies/privacy_policy.dart';
import 'package:supertest/features/user/profile.dart';
import 'package:supertest/features/user/profileSetting.dart';
import 'package:supertest/features/policies/return_policy.dart';
import 'package:supertest/features/menu/singleProduct.dart';
import 'package:supertest/splash/splash.dart';
import 'features/home/home.dart';
import 'features/resgister/register.dart';
import 'features/login/login.dart';
import 'features/user/forgotpw.dart';
import 'widgets/bottom_menu.dart';


void main() {
  runApp(MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgotpw': (context) => ForgotPwd(),
        '/profile': (context)=> profile(),
        '/profileSetting': (context)=>profileSet(),
        '/privacy': (context)=> priv(),
        '/return': (context)=> ret(),
        '/bottom_menu': (context)=> btm(),
        '/home': (context) => home(),
        '/categories': (context)=> cat(),
        '/popularMenu': (context)=> popMenu(),
        '/favourites': (context) => favfood(),
        '/carts': (context) => carts(),
        '/singleProduct': (context)=> singleProd(),
        '/popularRestaurant':(context)=> popRestaurant(),
        '/categoryMenu':(context)=> catMenu()
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationForm(),
    );
  }
}

class ForgotPwd extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ForgotPassword(),
    );
  }
}

class profile extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Profile(),
    );
  }
}

class profileSet extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: profileSetting(),
    );
  }
}

class priv extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Privacy(),
      bottomNavigationBar: BottomMenu(activeIndex: 4),
    );
  }
}

class ret extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Return(),
      bottomNavigationBar: BottomMenu(activeIndex: 4),
    );
  }
}

class btm extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: BottomMenu(activeIndex: 0),
    );
  }
}

class home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Home(),
      bottomNavigationBar: BottomMenu(activeIndex: 0),
    );
  }
}

class cat extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Categories(),
      bottomNavigationBar: BottomMenu(activeIndex: 0),
    );
  }
}

class popMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: popularMenu(),
      bottomNavigationBar: BottomMenu(activeIndex: 0),
    );
  }
}

class favfood extends StatelessWidget{
  @override
  Widget build(BuildContext context){   
    return Scaffold(
      body: favourites(),
      bottomNavigationBar: BottomMenu(activeIndex: 1),
    );
  }
}

class carts extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: cart(),
    );
  }
}

class singleProd extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: singleProduct(description: '', items: '', price: '', images: '',calories: '', ratings: '', reviews: '', itemId: '',),
    );
  }
}

class popRestaurant extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: popularRestaurant(),
      bottomNavigationBar: BottomMenu(activeIndex: 0),
    );
  }
}

class catMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: categoryMenu(catId: '', catName: '',)
    );
  }
}








