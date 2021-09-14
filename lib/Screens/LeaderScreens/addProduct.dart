import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/constants.dart';


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final DatabaseService _db = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  final List<String> categories = ['Wire','Balloon','Balloon mounted','Stent'];
  String error = '';

  // text field state
  String productID = '';
  String _currentCategory = 'Wire';
  int quantity = 0;
  String name = '';
  Map productData;
  var textController = new TextEditingController();
  Timestamp expiryDate;
  String type = "";

  @override
  Widget build(BuildContext context) {
    productData = ModalRoute.of(context).settings.arguments;
    Size size = MediaQuery.of(context).size;
    if(productData['inventoryType'] == 'g'){
      type = "Government Inventory";
    }else{
      type = "Private Inventory";
    }
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
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Add Product",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: kPrimaryColor
                      ),
                    ),
                  ),
                ],
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
                              Icons.text_format,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Product name',
                            border: InputBorder.none
                        ),
                        validator: (val) => val.isEmpty ? 'Enter a valid name' : null,
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
                              Icons.add,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Quantity',
                            border: InputBorder.none
                        ),
                        validator: (val) =>  val.isEmpty || int.parse(val) <= 0 ? 'Enter a valid quantity' : null,
                        onChanged: (val) {
                          setState(() => quantity = int.parse(val));
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
                        controller: textController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.date_range,
                              color: kPrimaryColor,
                            ),
                            hintText: 'Expiry date',
                            border: InputBorder.none
                        ),
                        validator: (val) =>  val.isEmpty ? 'Enter an expiry date' : null,
                        onTap: (){
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2040)
                          ).then((value) =>  setState(() {
                            if(value==null){
                              textController.text='';
                            }else{
                              expiryDate = Timestamp.fromDate(value);
                              textController.text=DateFormat('dd-MM-yyyy').format(value);
                            }
                          })
                          );
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
                      child: DropdownButtonFormField(
                        icon: Icon(Icons.category,
                        color: kPrimaryColor,),
                        value: _currentCategory ?? 'Wire',
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text('$category'),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _currentCategory = val ),
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
                                dynamic result = await _db.addNewProduct(productData['inventoryType'],_currentCategory, name, quantity , expiryDate);
                                if(result == null) {
                                  //Navigator.pop(context);
                                  setState(() {
                                    error = 'Invalid Inputs format';
                                  });
                                }else {
                                  AwesomeDialog(
                                    context: context,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.SUCCES,
                                    animType: AnimType.BOTTOMSLIDE,
                                    body: Center(child: Text(
                                      'Product Added Successfully',
                                      style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20),
                                    ),),
                                    title: 'Product Added Successfully',
                                    desc: "",
                                    onDissmissCallback: (){
                                      Navigator.pop(context);
                                    },
                                    btnOkOnPress: () {
                                      //Navigator.pop(context);
                                    },
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
