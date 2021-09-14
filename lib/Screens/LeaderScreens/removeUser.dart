import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventory/Screens/Shared/loading.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/constants.dart';
import 'package:cloud_functions/cloud_functions.dart';
class RemoveUser extends StatefulWidget {



  @override
  _RemoveUserState createState() => _RemoveUserState();
}

class _RemoveUserState extends State<RemoveUser> {
  final DatabaseService _db = DatabaseService();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String number = '';
  final HttpsCallable deleteUserFunction = CloudFunctions.instance.getHttpsCallable(
    functionName: 'deleteUser',
  );

  List<String> userList = List<String>();
  int index ;
  String selectedName;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    userList.clear();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Form(
                child: StreamBuilder<QuerySnapshot> (
                  stream: Firestore.instance.collection('usersDemo').snapshots(),
                  builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(userList.length == 0) {
                          for (int i = 0; i < snapshot.data.documents.length; i++) {
                            if(snapshot.data.documents[i].documentID==adminID){
                              index=i;
                            }else{
                              String name = snapshot.data.documents[i]['name'];
                              userList.add(name);
                            }
                          }
                        }
                        return userList.length==0 ? NoMoreUsers() : Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Select salesman to fire",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey
                                ),
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
                              child: DropdownButtonFormField(
                                icon: Icon(Icons.person_outline,
                                  color: kPrimaryColor,),
                                value: selectedName ?? userList[0],
                                items: userList.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text('$category'),
                                  );
                                }).toList(),
                                onChanged: (val) => setState(() => selectedName = val ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0,30,0,60),
                              width: size.width * 0.6,

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: RaisedButton(
                                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),

                                  color: kPrimaryColor,
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(color: Colors.white,fontSize: 20),
                                  ),
                                  onPressed: () async{
                                    setState (() async {
                                      AwesomeDialog(
                                        context: context,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.WARNING,
                                        animType: AnimType.BOTTOMSLIDE,
                                        title: "Fire Salesman",
                                        desc: 'Are you sure you want to Fire this emplpoyee ?',
                                        btnCancelOnPress: () {
                                        },
                                        btnOkOnPress: () async {
                                          Navigator.pushNamed(context, '/loading');
                                          for(int i = 0 ; i < userList.length;i++)
                                          {
                                            if(selectedName==userList[i])
                                            {
                                              if(i >= index)
                                              {
                                                i=i+1;
                                              }
                                              dynamic resp = await deleteUserFunction.call(<String, dynamic>{
                                                'uid': snapshot.data.documents[i].documentID,
                                              });
                                              _db.deleteUser(snapshot.data.documents[i].documentID);
                                              if(resp == null)
                                              {
                                                setState(() {
                                                  error='Could not delete user\nplease Try again later';
                                                  Navigator.pop(context);
                                                });
                                              }
                                              else{
                                                Navigator.pop(context);
                                                AwesomeDialog(
                                                    context: context,
                                                    headerAnimationLoop: false,
                                                    dialogType: DialogType.SUCCES,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    body: Center(child: Text(
                                                      'Employee Fired Successfully',
                                                      style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),
                                                    ),),
                                                    title: 'Sale Successful',
                                                    desc: '',
                                                    onDissmissCallback: (){
                                                      Navigator.pop(context);
                                                    },
                                                    btnOkOnPress: (){
                                                    }
                                                )..show();

                                              }

                                              break;
                                            }

                                          }
                                        },
                                      )..show();
                                    });


                                  },
                                ),
                              ),
                            ),
                            Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),
                            ),

                          ],
                        );
                      }else{
                        return Loading();
                      }
                  }
                ),
              ),
              Container(
                child: SvgPicture.asset(
                  "assets/images/remove.svg",
                  height: size.height*0.33,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}