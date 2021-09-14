import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Models/product.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/Services/productsGovList.dart';
import 'package:provider/provider.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/Services/productsList.dart';

class LeaderInventory extends StatefulWidget {

  @override
  _LeaderInventoryState createState() => _LeaderInventoryState();
}

class _LeaderInventoryState extends State<LeaderInventory> {

  var textController = new TextEditingController();
  bool showCancel = false;
  bool inventoryType = true;
  String search = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if(inventoryType){
      //inventoryType=false;
      return StreamProvider<List<Product>>.value(
        value: DatabaseService().products,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Center(
              child: Text(
                'Private Inventory',
              ),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.swap_calls, color: Colors.white,),
              onPressed: (){
                setState(() {
                  inventoryType=!inventoryType;
                });
              },)
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: size.width * 0.5,
                    margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: kPrimaryColor,
                        ),
                        hintText: "Search Products",
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() => search = val);
                      },
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: kPrimaryColor,
                  ),
                  enableFeedback: showCancel,
                  onPressed: (){
                    setState(() {
                      search='';
                      textController.text='';
                      showCancel=false;
                    });

                  },
                  // DateFormat('dd-MM-yyyy').format(value))
                ),
              ],
            ),
              Expanded(child: ProductList("p",search)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, '/addProduct',arguments: {
                'inventoryType': 'p',
              });
            },
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      );
    }else{
      return StreamProvider<List<Product>>.value(
        value: DatabaseService().productsGov,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Center(
              child: Text(
                'Government Inventory',
              ),
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.swap_calls, color: Colors.white,),
                onPressed: (){
                  setState(() {
                    inventoryType=!inventoryType;
                  });
                },)
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width * 0.5,
                    margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: kPrimaryColor,
                        ),
                        hintText: "Search Products",
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() => search = val);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: kPrimaryColor,
                    ),
                    enableFeedback: showCancel,
                    onPressed: (){
                      setState(() {
                        search='';
                        textController.text='';
                        showCancel=false;
                      });

                    },
                    // DateFormat('dd-MM-yyyy').format(value))
                  ),
                ],
              ),

              Expanded(child: ProductsGovList("g",search)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, '/addProduct',arguments: {
                'inventoryType': 'g',
              });
            },
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

  }
}

