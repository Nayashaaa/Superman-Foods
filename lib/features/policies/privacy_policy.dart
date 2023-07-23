import 'package:flutter/material.dart';
import 'package:supertest/widgets/bottom_menu.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/privacy.png'),
              fit: BoxFit.cover,
            ),
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
                                      color: Colors.white, size: 30),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: constraints.maxWidth * 0.145),
                              Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  height: constraints.maxHeight * 0.0025,
                                  fontFamily: 'Lato',
                                  fontSize: constraints.maxWidth * 0.07,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: constraints.maxHeight * 0.105),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  padding: EdgeInsets.only(
                                      left: constraints.maxWidth * 0.05,
                                      right: constraints.maxWidth * 0.05),
                                  child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ornare diam purus, quis dictum diam eleifend nec. Ut suscipit, tellus vel viverra imperdiet, tellus diam pretium turpis, non blandit mi lacus pulvinar metus. Mauris ultrices tortor vel tempor sodales. Aenean nec sem eros. Quisque hendrerit metus ut elit dapibus, vel tincidunt mauris volutpat. Mauris finibus tortor gravida dolor vestibulum, id blandit orci mollis. Mauris porttitor lacus id arcu fermentum, non iaculis mi tempor. In felis orci, varius eu augue non, fringilla vulputate tortor. Morbi et ipsum maximus, hendrerit massa convallis, elementum odio. Integer condimentum tristique lectus, ac ornare massa pulvinar at.'
                                      'Phasellus ultrices porta nisi, a consectetur quam facilisis vitae. Donec in justo nec est imperdiet molestie. Cras nec ante dolor. Nam enim urna, hendrerit interdum lacinia sit amet, hendrerit in lectus. Ut mattis urna dapibus aliquet semper. Aliquam semper nunc leo, vel tempus velit aliquam at. Duis imperdiet facilisis neque sed faucibus. Nunc ullamcorper tristique dictum. Nulla molestie, erat rutrum aliquet fringilla, nunc risus venenatis lectus, vel scelerisque libero velit id orci. Morbi eget neque tempus mi faucibus tempor quis non nunc. In viverra molestie nulla non ornare.'
                                      'Ut pulvinar nunc tortor, in mattis risus ultricies a. Etiam eget nulla vel ante tristique accumsan. Proin ante quam, dapibus eu volutpat quis, mollis sit amet mi. Donec id dui ex. Ut venenatis ante eu quam tristique, sed lacinia nulla convallis. Proin quis porttitor magna. Duis eu sem felis. Duis malesuada cursus nisi, ac laoreet urna tristique a. Vestibulum vitae libero in odio elementum vulputate. In vitae lobortis arcu, eget dignissim risus.'
                                      'Pellentesque tristique leo eu dapibus eleifend. Curabitur id sagittis velit, id suscipit lorem. Integer sed lorem mi. Duis in venenatis dui, a placerat nibh. Etiam tellus dolor, fringilla ut magna eleifend, convallis consequat tellus. Vestibulum scelerisque dignissim pretium. Aliquam varius porta sollicitudin. Pellentesque nec massa metus. Ut non aliquet sem. Morbi consequat tellus lobortis arcu faucibus, ut accumsan libero ultrices. Nullam id leo tempor, rutrum dui sed, mattis sapien. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla aliquet justo ac fringilla eleifend. Integer sed consequat odio. Proin porta purus non erat egestas ultricies. Morbi rutrum non tortor vitae tincidunt.'
                                      'Integer turpis lorem, consectetur non eros vitae, placerat euismod quam. Quisque hendrerit, augue non varius ullamcorper, nulla mauris accumsan lorem, nec aliquet turpis leo ut neque. Duis elementum nibh at tellus efficitur cursus. Proin pulvinar lorem ipsum, quis condimentum libero pulvinar quis. Ut blandit sem sagittis nibh vehicula mollis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec convallis diam in volutpat tempor. Nullam ultricies cursus sollicitudin. Proin ex ligula, sollicitudin non auctor eget, euismod non diam. Pellentesque et felis commodo, dapibus est ac, commodo erat.',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth * 0.04,
                                        fontFamily: 'Lato',
                                      ))))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )),
          
      bottomNavigationBar: BottomMenu(activeIndex: 4),
    ));
  }
}