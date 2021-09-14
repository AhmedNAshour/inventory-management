import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/Services/auth.dart';
import 'package:inventory/constants.dart';
import 'package:url_launcher/url_launcher.dart';


class LeaderHome extends StatefulWidget {

  final Function toggleView;
  LeaderHome({ this.toggleView });

  @override
  _LeaderHomeState createState() => _LeaderHomeState();
}

class _LeaderHomeState extends State<LeaderHome> {

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  // text field state
  String email = '';
  String password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //subscriptionToAdmin();
    //getDeviceToken();
    _fcm.subscribeToTopic('AdminDemo');
    configureCallBacks();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hello Boss",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: kPrimaryColor
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: SvgPicture.asset(
                  "assets/images/home.svg",
                  height: size.height*0.35,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                            color: kPrimaryColor,
                            child: Text(
                              'Inventory',
                              style: TextStyle(color: Colors.white),
                            ),
                            // ignore: missing_return
                            onPressed: ()  {
                              Navigator.pushNamed(context, '/leaderInventory');
                            }
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                            color: kPrimaryColor,
                            child: Text(
                              'Logs',
                              style: TextStyle(color: Colors.white),
                            ),
                            // ignore: missing_return
                            onPressed: () {
                              Navigator.pushNamed(context, '/leaderLogs');
                            }
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 3),
                          width: size.width * 0.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                color: kPrimaryColor,
                                child: Text(
                                  'Add Salesman',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                // ignore: missing_return
                                onPressed: ()  {
                                  Navigator.pushNamed(context, '/addUser');
                                }
                            ),
                          ),
                        ),
                        //Remove Salesman
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 3),
                          width: size.width * 0.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(29),
                            child: FlatButton(
                                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                color: kPrimaryColor,
                                child: Text(
                                  'Remove Salesman',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                // ignore: missing_return
                                onPressed: ()  {
                                  Navigator.pushNamed(context, '/removeUser');
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: InkWell(
                        child: Text(
                          'Sign out',
                          style: TextStyle(
                            color: kPrimaryColor
                          ),
                        ),
                        onTap: (){
                          _auth.signOut();
                          _fcm.unsubscribeFromTopic('AdminDemo');
                         // Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void configureCallBacks() {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if(message['notification']['title'] == "PRODUCT SHORTAGE !!!"){
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.WARNING,
            animType: AnimType.BOTTOMSLIDE,
            title: message['notification']['title'],
            desc: message['notification']['body'],
          )..show();
        }else{
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.INFO,
            animType: AnimType.BOTTOMSLIDE,
            title: message['notification']['title'],
            desc: message['notification']['body'],
            btnOkOnPress: () {
              launch("tel://${message['data']['salesmanNumber']}");
            },
            btnOkText: 'Call Seller',
            btnOkColor: kPrimaryColor
          )..show();
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        // TODO optional
      },
    );
  }
}