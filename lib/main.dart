import 'package:flutter/material.dart';
import 'package:inventory/Screens/LeaderScreens/leaderLogs.dart';
import 'package:inventory/Services/auth.dart';
import 'package:inventory/Services/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:inventory/Models/user.dart';
import 'package:inventory/Screens/LeaderScreens/editProduct.dart';
import 'package:inventory/Screens/LeaderScreens/addProduct.dart';
import 'package:inventory/Screens/LeaderScreens/leaderInventory.dart';
import 'package:inventory/Screens/LeaderScreens/leaderHome.dart';
import 'package:inventory/Screens/LeaderScreens/addUser.dart';
import 'package:inventory/Screens/Shared/login.dart';
import 'package:inventory/Screens/Shared/loading.dart';
import 'package:inventory/Screens/SalesmanScreens/salesmanInventory.dart';
import 'package:inventory/Screens/SalesmanScreens/sellProduct.dart';
import 'package:inventory/Screens/LeaderScreens/removeUser.dart';

void main() {
  runApp(Home());
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                }
            )
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        home: Wrapper(),
        routes: {
          '/login': (context) => Login(),
          '/loading': (context) => Loading(),
          '/addUser': (context) => AddUser(),
          '/editProduct': (context) => EditProduct(),
          '/addProduct': (context) => AddProduct(),
          '/leaderInventory': (context) => LeaderInventory(),
          '/leaderHome': (context) => LeaderHome(),
          '/salesInventory': (context) => SalesmanInventory(),
          '/sellProduct': (context) => SellProduct(),
          '/leaderLogs': (context) => LeaderLogs(),
          '/removeUser': (context) => RemoveUser(),
        },
      ),
    );
  }
}






