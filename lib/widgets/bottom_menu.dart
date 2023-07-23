import 'package:flutter/material.dart';
import 'package:supertest/features/cart/cart.dart';
import 'package:supertest/features/favourites/favourites.dart';
import 'package:supertest/features/home/home.dart';
import 'package:supertest/features/user/profile.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({Key? key, required this.activeIndex}) : super(key: key);
  final int activeIndex;

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: double.infinity,
          height: 65,
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  icon: Icon(
                    Icons.home_outlined,
                    color: widget.activeIndex == 0 ? Colors.yellow : Colors.white,
                    size: 36,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => favourites()),
                    );
                  },
                  icon: Icon(
                    Icons.favorite_border,
                    color: widget.activeIndex == 1 ? Colors.yellow : Colors.white,
                    size: 33,
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => cart()),
                    );
                  },
                  child: Transform.translate(
                  offset: Offset(0, -30),
                  child: Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                      MaterialPageRoute(builder: (context) => cart()),
                    );
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.redAccent,
                        size: 33,
                      ),
                    ),
                  ),
                ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.sticky_note_2_outlined,
                    color: widget.activeIndex == 3 ? Colors.yellow : Colors.white,
                    size: 33,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  },
                  icon: Icon(
                    Icons.person_2_outlined,
                    color: widget.activeIndex == 4 ? Colors.yellow : Colors.white,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}