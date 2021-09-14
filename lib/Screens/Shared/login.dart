import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/Screens/Shared/loading.dart';
import 'package:inventory/Services/auth.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/constants.dart';
class Login extends StatefulWidget {

  final Function toggleView;
  Login({ this.toggleView });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String warningMessage = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final  user = Provider.of<User>(context);
    return loading ? Loading(): Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: kPrimaryColor
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: SvgPicture.asset(
                  "assets/images/login.svg",
                  height: size.height*0.35,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Email',
                            border: InputBorder.none
                        ),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                      width: size.width*0.8,
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: kPrimaryColor,
                          ),
                          hintText: "Password",
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        validator: (val) => val.length< 6  ? ' Enter a password 6+ chars long ' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
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
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                            // ignore: missing_return
                            onPressed: () async {
                              if(_formKey.currentState.validate()){
                                //String fcmToken = await _fcm.getToken();
                                //print('Tokenn '+fcmToken);
                                //eWoatZR_65s:APA91bEwffb8xDUmppb336rPSS4_Dhw1BWooxuVbE0wyO61QnAFWhJqjkcnSu32A9a5KF3ydImB9STPi4mdwDCVZcZI9rzqIA5mxEVapberyR461KHROrfZBPDBrY9nD3PZw7cFmkoAJ
                                //Navigator.pushNamed(context, '/loading');
                                setState(() {
                                  loading=true;
                                });
                                dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                if(result == null) {
//                                  Navigator.pop(context);
                                  setState(() {
                                    loading=false;
                                    error = 'Could not sign in with those credentials';
                                  });
                                }else {
                                    DatabaseService db = DatabaseService(uid: await _auth.getCurrentUID());
                                    name = await db.getUser_name();
                                    if(await _auth.getCurrentUID()==adminID){
                                      db.updateLeaderPassword(password);
                                      _fcm.subscribeToTopic('AdminDemo');
                                      //Navigator.pop(context);
                                      //Navigator.pushReplacementNamed(context, '/leaderHome');
                                    }else{
                                      //Navigator.pop(context);
                                      //Navigator.pushReplacementNamed(context, '/salesInventory');
                                    }
                                }
                              }
                            }
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      width: size.width * 0.8,
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            showModalBottomSheet(context: context, builder: (context){
                              return FractionallySizedBox(
                                heightFactor: 0.65,
                                child: DraggableScrollableSheet(
                                    initialChildSize: 1.0,
                                    maxChildSize: 1.0,
                                    minChildSize: 0.25,
                                    builder: (BuildContext context , ScrollController scrollController){
                                      return SingleChildScrollView(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                                            child: Form(
                                              key: _formKey2,
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    'Reset Password',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                        color: kPrimaryColor
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 10),
                                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                                    width: size.width*0.8,
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryLightColor,
                                                      borderRadius: BorderRadius.circular(29),
                                                    ),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                          icon: Icon(
                                                            Icons.email,
                                                            color: kPrimaryColor,
                                                          ),
                                                          hintText: 'Email',
                                                          border: InputBorder.none
                                                      ),
                                                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                                                      onChanged: (val) {
                                                        setState(() => email = val);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    width: size.width * 0.5,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(29),
                                                      child: FlatButton(
                                                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                                                          color: kPrimaryColor,
                                                          child: Text(
                                                            'Send reset email',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          // ignore: missing_return
                                                          onPressed: () async {
                                                            if(_formKey2.currentState.validate()){
                                                              try{
                                                                await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
                                                                Navigator.pop(context);
                                                                AwesomeDialog(
                                                                  context: context,
                                                                  headerAnimationLoop: false,
                                                                  dialogType: DialogType.SUCCES,
                                                                  animType: AnimType.BOTTOMSLIDE,
                                                                  title: 'Reset Email Sent',
                                                                  desc: 'Please check your email and follow the link',
                                                                )..show();
                                                                warningMessage = '';
                                                              }catch(e) {
                                                                AwesomeDialog(
                                                                  context: context,
                                                                  headerAnimationLoop: false,
                                                                  dialogType: DialogType.ERROR,
                                                                  animType: AnimType.BOTTOMSLIDE,
                                                                  title: 'Invalid Email',
                                                                  desc: 'Please provide a valid email',
                                                                )..show();
                                                              }
                                                            }
                                                          }
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 20),
                                                    child: SvgPicture.asset(
                                                      "assets/images/forgotPassword.svg",
                                                      height: size.height*0.35,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ),
                                      );
                                    }
                                ),
                              );
                            },isScrollControlled: true);
                          },
                          child: Text(
                            'Forgot password ?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
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
}



