import 'package:flutter/material.dart';

class confirmLocation extends StatefulWidget {
  const confirmLocation({super.key});

  @override
  State<confirmLocation> createState() => _confirmLocationState();
}

class _confirmLocationState extends State<confirmLocation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:  Container(
          decoration: BoxDecoration(
            color: Colors.grey[200]
          ),
          child: Column(
            children: [
              Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        top: MediaQuery.of(context).size.height * 0.02,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                    Text(
                      'Location',
                      style: TextStyle(
                        height:MediaQuery.of(context).size.height * 0.0025,
                        fontFamily: 'Lato',
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Align(alignment: Alignment.topLeft,
                child:Container(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
                  child: Text('Deliver to:',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w600
                )),
                ) 
                ),

                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xFFFCE479),
                                                Color(0xFFFFE607),
                                              ],
                                            ),
                    ),
                    child: Align(alignment: Alignment.center,
                    child: Text('Confirm',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.w500
                    )))
                    
                  )
                )
                
                

          ]),
        )
      ),
    );
  }

}