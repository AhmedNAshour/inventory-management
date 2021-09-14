import 'package:inventory/Models/user.dart';
import 'package:inventory/Screens/LeaderScreens/leaderHome.dart';
import 'package:inventory/Screens/SalesmanScreens/salesmanInventory.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Screens/Shared/login.dart';
import 'package:provider/provider.dart';
import 'package:inventory/constants.dart';
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();

}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {
    final user =  Provider.of<User>(context);

    if (user == null){
      return Login();
    } else {
      if(user.uid == adminID){
        return LeaderHome();
      }else{
        return SalesmanInventory();
        }
      }
    }
  }
