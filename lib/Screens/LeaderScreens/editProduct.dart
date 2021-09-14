import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Models/product.dart';
import 'package:inventory/Screens/Shared/loading.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/constants.dart';


class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();

}

class _EditProductState extends State<EditProduct> {
  final DatabaseService _db = DatabaseService();


  final _formKey = GlobalKey<FormState>();
  String error = '';

  // text field state
  var textController = new TextEditingController();
  String name = '';
  String email = '';
  String password = '';
  Map productData = {};
  int newQuantity = 0;
  List<int> L = List<int>();
  //var snap = Firestore.instance.collection('products').document(docID).get().then((DocumentSnapshot) => name = DocumentSnapshot.data['name'].toString());
  var s ;
  int current;
  bool loading = true;
  String type = "";
  @override
  Widget build(BuildContext context)  {

    final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;
    Size size = MediaQuery.of(context).size;
    productData = ModalRoute.of(context).settings.arguments;
    if(productData['inventoryType'] == 'g'){
      type = "Government Inventory";
    }else{
      type = "Private Inventory";
    }
//    if(productData['inventoryType']=='g'){
//      s =  Firestore.instance.collection('governmentProducts').snapshots();
//    }else{
//      s =  Firestore.instance.collection('products').snapshots();
//    }

    return StreamBuilder<Product>(
      stream:DatabaseService.named(uid: adminID , productDocID: productData['docID'],inventoryType: productData['inventoryType']).productsMap ,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          Product product = snapshot.data;
          textController.text=product.quantity.toString();
          return Scaffold(
            body: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Updating ' + '\n"' + productData['name'] + '"',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: kPrimaryColor
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          type,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: kPrimaryColor
                          ),
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
                                    margin: EdgeInsets.fromLTRB(0, 25, 40, 5),
                                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                    decoration: BoxDecoration(
                                      color: kPrimaryLightColor,
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    child: TextFormField(
                                      enabled: false,
                                      controller: textController,

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
                                      'Quantity to \nRemove/Add',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 40, 25),
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
                                      validator: (val) => val.isEmpty || int.parse(val) < 0 ? 'Enter valid quantity' : null,
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
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 0 , horizontal: 10),
                                  width: size.width * 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(29),
                                    child: FlatButton(
                                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                        color: kPrimaryColor,
                                        child: Text(
                                          'Remove',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        // ignore: missing_return
                                        onPressed: () async {
                                          if(_formKey.currentState.validate()){
                                            Navigator.pushNamed(context, '/loading');
                                            if(product.quantity-newQuantity<0)
                                              {
                                                setState(() {
                                                  error = 'New quantity can not be less than 0\nConsider deleting the product instead';
                                                  Navigator.pop(context);
                                                });
                                              }else{
                                              dynamic result;
                                              if(productData['inventoryType']=='g'){
                                                result = await _db.updateProductGov(productData['docID'],product.quantity-newQuantity);
                                              }
                                              else{
                                                result = await _db.updateProduct(productData['docID'],product.quantity-newQuantity);
                                              }
                                              if(result == null) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  error = 'Could not update product';
                                                });
                                              }else {
                                                Navigator.pop(context);
                                                AwesomeDialog(
                                                    context: context,
                                                    headerAnimationLoop: false,
                                                    dialogType: DialogType.SUCCES,
                                                    animType: AnimType.BOTTOMSLIDE,
                                                    body: Center(child: Text(
                                                      'Product Updated Successfully',
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

                                          }

                                        }
                                    ),
                                  ),
                                ),
                                //Remove Salesman
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  width: size.width * 0.3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(29),
                                    child: FlatButton(
                                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                                        color: kPrimaryColor,
                                        child: Text(
                                          'Add',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        // ignore: missing_return
                                        onPressed: () async {
                                        if(_formKey.currentState.validate()){
                                            Navigator.pushNamed(context, '/loading');
                                            dynamic result;
                                            if(productData['inventoryType']=='g'){
                                               result = await _db.updateProductGov(productData['docID'],product.quantity+newQuantity);
                                            }
                                            else{
                                               result = await _db.updateProduct(productData['docID'],product.quantity+newQuantity);
                                            }
                                            if(result == null) {
                                                Navigator.pop(context);
                                                setState(() {
                                                      error = 'Could not update product';
                                                });
                                            }else {
                                              Navigator.pop(context);
                                              AwesomeDialog(
                                                  context: context,
                                                  headerAnimationLoop: false,
                                                  dialogType: DialogType.SUCCES,
                                                  animType: AnimType.BOTTOMSLIDE,
                                                  body: Center(child: Text(
                                                    'Product Updated Successfully',
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
                                        }
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10 ),
                              child: Text(
                                error,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red, fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
            floatingActionButton: !showFab ? null :FloatingActionButton (
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.delete_outline),
              onPressed: (){
                AwesomeDialog(
                  context: context,
                  headerAnimationLoop: false,
                  dialogType: DialogType.WARNING,
                  animType: AnimType.BOTTOMSLIDE,
                  title: "Delete Product",
                  desc: 'Are you sure you want to delete this product ?',
                  btnCancelOnPress: () {
                  },
                  btnOkOnPress: () async {
                    Navigator.pushNamed(context, '/loading');
                    dynamic result;
                    if(productData['inventoryType']=='g'){
                      result = await _db.deleteProductGov(productData['docID']);
                    }else{
                      result = await _db.deleteProduct(productData['docID']);
                    }
                    if(result == null) {
                      Navigator.pop(context);
                      setState(() {
                        error = 'Could not delete';
                      });
                    }else {
                      Navigator.pop(context);
                      //Navigator.pop(context);
                      AwesomeDialog(
                          context: context,
                          headerAnimationLoop: false,
                          dialogType: DialogType.SUCCES,
                          animType: AnimType.BOTTOMSLIDE,
                          body: Center(child: Text(
                            'Product Deleted Successfully',
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
                  },
                )..show();
              },
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}
