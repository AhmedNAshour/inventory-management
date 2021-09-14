import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Services/auth.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/constants.dart';

class AddUser extends StatefulWidget {

  final Function toggleView;
  AddUser({ this.toggleView });

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String number = '';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle,
                    color: kPrimaryColor,
                    size: 40,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "Add Salesman",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: kPrimaryColor
                      ),
                    ),
                  ),
                ],
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
                              Icons.person,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Name',
                            border: InputBorder.none
                        ),
                        validator: (val) => val.isEmpty ? 'Enter a name' : null,
                        onChanged: (val) {
                          setState(() => name = val);
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.phone_android,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Phone number',
                            border: InputBorder.none
                        ),
                        validator: (val) => val.length != 11 ? 'Enter a valid phone number' : null,
                        onChanged: (val) {
                          setState(() => number = val);
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
                        validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: size.width * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(29),
                        child: FlatButton(
                            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                            color: kPrimaryColor,
                            child: Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                            // ignore: missing_return
                            onPressed: () async {
                              if(_formKey.currentState.validate()){
                                Navigator.pushNamed(context, '/loading');
                                dynamic result = await _auth.registerWithEmailAndPassword(email, password,number,name);
                                if(result == null) {
                                  Navigator.pop(context);
                                  setState(() {
                                    error = 'Invalid Email';
                                  });
                                }else {
                                  await _auth.signOut();
                                  DatabaseService db = DatabaseService();
                                  await _auth.signInWithEmailAndPassword('ahmed.nasr.ashour@gmail.com', await db.readLeaderPassword());
                                  Navigator.of(context).pop();
                                  AwesomeDialog(
                                    context: context,
                                    headerAnimationLoop: false,
                                      dialogType: DialogType.SUCCES,
                                      animType: AnimType.BOTTOMSLIDE,
                                    body: Center(child: Text(
                                      'Salesman added Successfully',
                                      style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),
                                    ),),
                                    title: '',
                                    desc: '',
                                      onDissmissCallback: (){
                                        Navigator.pop(context);
                                      },
                                      btnOkOnPress: (){
                                      }
                                  )..show();
                                }
                              }
                            }
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