import 'package:flutter/material.dart';
import 'package:inventory/Models/product.dart';
import 'package:inventory/Services/auth.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/Services/productsGovList.dart';
import 'package:provider/provider.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/Services/productsList.dart';
class SalesmanInventory extends StatefulWidget {

  @override
  _SalesmanInventoryState createState() => _SalesmanInventoryState();
}

class _SalesmanInventoryState extends State<SalesmanInventory> {
  final AuthService _auth = AuthService();
  String name;
  var textController = new TextEditingController();
  bool showCancel = false;

  bool inventoryType = true;
  String search = '';
  String uid;

  void getData() async{
    uid =await _auth.getCurrentUID();
    final DatabaseService _db = DatabaseService(uid: uid);
    try{
      await _db.getUser_name();
    }catch(e){
      _auth.signOut();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    getData();

    //String search = '';
    //final DatabaseService db = DatabaseService(uid: user.uid);
    //s.then((s)=> name = s.data['name'].toString());
   // var snap = Firestore.instance.collection('users').document(user.uid.toString()).get().then((DocumentSnapshot) => name = DocumentSnapshot.data['name'].toString());
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
              _auth.signOut();
            },
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.exit_to_app,
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
              _auth.signOut();
            },
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}

