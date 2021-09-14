import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/Models/product.dart';
import 'package:inventory/Models/user.dart';
import 'package:inventory/constants.dart';
import 'package:provider/provider.dart';


class ProductTile extends StatefulWidget {

  final Product product;
  String type;
  ProductTile({ this.product,this.type });
  @override
  _ProductTileState createState() => _ProductTileState();
}
class _ProductTileState extends State<ProductTile> {

  bool available = true;
  Color tileColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    final  user = Provider.of<User>(context);

    if(widget.product.expiryDate.toDate().difference(DateTime.now()).inDays < 60 || widget.product.quantity <=50){
      print(widget.product.expiryDate.toString());
      tileColor=Color(0xFFf1c40f);
      textColor=Colors.black;
    }else{
      tileColor=kPrimaryLightColor;
      textColor=Colors.black;
    }
    if(widget.product.quantity ==0 || widget.product.expiryDate.toDate().isBefore(DateTime.now())){
      tileColor=Color(0xFFc0392b);
      textColor=Colors.white;
    }

    if(widget.product.quantity ==0 && user.uid.toString() != adminID){
      available = false;

    }else{

      available = true;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        elevation:5,
        color: tileColor,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5 , horizontal: 15),
          enabled: available,
          title: Text(widget.product.name,style: TextStyle(color: textColor)),
          subtitle: Text('Expiry date: ' + DateFormat('dd-MM-yyyy').format(widget.product.expiryDate.toDate()) + '\n' + widget.product.quantity.toString() + ' pieces in stock' ,style: TextStyle(color: textColor),),
          trailing: Text(widget.product.category.toString(),style: TextStyle(color: textColor)),

          onTap: () {
            if(user.uid.toString()== adminID){
              Navigator.pushNamed(context, '/editProduct',arguments: {
                'inventoryType': widget.type,
                'name': widget.product.name,
                'category': widget.product.category,
                'quantity': widget.product.quantity,
                'docID': widget.product.docId,
              });
            }else{
              Navigator.pushNamed(context, '/sellProduct',arguments: {
                'inventoryType': widget.type,
                'name': widget.product.name,
                'category': widget.product.category,
                'quantity': widget.product.quantity,
                'docID': widget.product.docId,
                'expiryDate' : widget.product.expiryDate
              });
            }
          },
        ),
      ),
    );
  }
}