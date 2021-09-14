
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Models/user.dart';
import 'package:inventory/Services/auth.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/constants.dart';
import 'package:provider/provider.dart';


class SellProduct extends StatefulWidget {
  @override
  _SellProductState createState() => _SellProductState();
}

class _SellProductState extends State<SellProduct> {
  final DatabaseService _db = DatabaseService();


  final _formKey = GlobalKey<FormState>();
  String error = '';
  final AuthService _auth = AuthService();

  // text field state
  String name = '';
  String destination = '';
  String quantity = '';
  String priceEach = '';
  Map productData = {};
  int newQuantity = 0;
  bool sold = false;
  //var snap = Firestore.instance.collection('products').document(docID).get().then((DocumentSnapshot) => name = DocumentSnapshot.data['name'].toString());
  String uid;

  void getData() async{

    try{
      uid =await _auth.getCurrentUID();
      final DatabaseService _db = DatabaseService(uid: uid);
      await _db.getUser_name();
    }catch(e){
      _auth.signOut();
      Navigator.pop(context);
//      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context)  {

     DatabaseService db ;
    try {
      final  user = Provider.of<User>(context);
      getData();
       db = DatabaseService(uid: user.uid);
    } on Exception catch (e) {
      // TODO
     print(e);
    }

    Size size = MediaQuery.of(context).size;
    productData = ModalRoute.of(context).settings.arguments;
    if(productData['inventoryType'] == 'p'){
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Selling ' + '\n"' + productData['name'] + '"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: kPrimaryColor
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Current Quantity',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                enabled: false,
                                initialValue: productData['quantity'].toString(),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Quantity to sell',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                                validator: (val) => val.isEmpty || int.parse(val) <= 0 || int.parse(val) > int.parse(productData['quantity'].toString())? 'Enter valid quantity' : null,
                                onChanged: (val) {
                                  setState(() => newQuantity = int.parse(val));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Selling price per piece',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                                validator: (val) => val.isEmpty || double.parse(val) < 0 ? 'Enter valid price' : null,
                                onChanged: (val) {
                                  setState(() => priceEach = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Destination',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                                validator: (val) => val.isEmpty ? 'Enter a destination' : null,
                                onChanged: (val) {
                                  setState(() => destination = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                              color: kPrimaryColor,
                              child: Text(
                                'Sell',
                                style: TextStyle(color: Colors.white),
                              ),
                              // ignore: missing_return
                              onPressed: () async {
                                AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: "Sell Product",
                                  desc: 'Are you sure you want to confirm this sale ?',
                                  btnCancelOnPress: () {
                                  },
                                  btnOkOnPress: () async {
                                    if (_formKey.currentState
                                        .validate()) {
                                      Navigator.pushNamed(context, '/loading');
                                      dynamic result;
                                      dynamic result2;
                                      if (productData['inventoryType'] ==
                                          'g') {
                                        result =
                                        await _db.updateProductGov(
                                            productData['docID'],
                                            productData['quantity'] -
                                                newQuantity);
                                        result2 = 1;
                                      }
                                      else {
                                        result2 = await _db.addSaleLog(
                                            productData['name'],
                                            destination,
                                            double.parse(priceEach),
                                            newQuantity,
                                            await db.getUser_name(),
                                            Timestamp.now(),
                                            await db.getUser_number(),
                                            productData['expiryDate'],
                                        );
                                        result = await _db.updateProduct(
                                            productData['docID'],
                                            productData['quantity'] -
                                                newQuantity);
                                      }
                                      if (result == null ||
                                          result2 == null) {
                                        Navigator.pop(context);
                                        setState(() {
                                          error = 'Could not make sale';
                                        });
                                      } else {
                                        Navigator.pop(context);
                                        AwesomeDialog(
                                          context: context,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.SUCCES,
                                          animType: AnimType.BOTTOMSLIDE,
                                          body: Center(child: Text(
                                            'Product Sold Successfully',
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
                                    }
                                  },
                                )..show();
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }else{
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Selling ' + '"' + productData['name'] + '"',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: kPrimaryColor
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Current Quantity',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                enabled: false,
                                initialValue: productData['quantity'].toString(),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Text(
                                'Quantity to sell',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                              decoration: BoxDecoration(
                                color: kPrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                                validator: (val) => val.isEmpty || int.parse(val) <= 0 || int.parse(val) > int.parse(productData['quantity'].toString())? 'Enter valid quantity' : null,
                                onChanged: (val) {
                                  setState(() => newQuantity = int.parse(val));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: size.width * 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(29),
                          child: FlatButton(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                              color: kPrimaryColor,
                              child: Text(
                                'Sell',
                                style: TextStyle(color: Colors.white),
                              ),
                              // ignore: missing_return
                              onPressed: () async {
                                AwesomeDialog(
                                  context: context,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  title: "Sell Product",
                                  desc: 'Are you sure you want to confirm this sale ?',
                                  btnCancelOnPress: () {
                                  },
                                  btnOkOnPress: () async {
                                    if (_formKey.currentState
                                        .validate()) {
                                      Navigator.pushNamed(context, '/loading');
                                      dynamic result;
                                      dynamic result2;
                                      if (productData['inventoryType'] ==
                                          'g') {
                                        result =
                                        await _db.updateProductGov(
                                            productData['docID'],
                                            productData['quantity'] -
                                                newQuantity);
                                        result2 = 1;
                                      }
                                      else {
                                        result2 = await _db.addSaleLog(
                                            productData['name'],
                                            destination,
                                            double.parse(priceEach),
                                            newQuantity,
                                            await db.getUser_name(),
                                            Timestamp.now(),
                                            await db.getUser_number(),
                                            productData['expiryDate']
                                        );
                                        result = await _db.updateProduct(
                                            productData['docID'],
                                            productData['quantity'] -
                                                newQuantity);
                                      }
                                      if (result == null ||
                                          result2 == null) {
                                        setState(() {
                                          error = 'Could not make sale';
                                        });
                                      } else {
                                        Navigator.pop(context);
                                        AwesomeDialog(
                                            context: context,
                                            headerAnimationLoop: false,
                                            dialogType: DialogType.SUCCES,
                                            animType: AnimType.BOTTOMSLIDE,
                                            body: Center(child: Text(
                                              'Product Sold Successfully',
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
                                    }
                                  },
                                )..show();
                              }
                          ),
                        ),
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
}
