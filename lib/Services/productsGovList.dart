import 'package:inventory/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Screens/Shared/loading.dart';
import 'package:inventory/Services/productsTile.dart';
import 'package:provider/provider.dart';

class ProductsGovList extends StatefulWidget {
  String type;
  String search;
  List<Product> searchList;


  ProductsGovList(String type,String search){
    this.type = type;
    this.search = search;
  }

  @override
  _ProductsGovListState createState() => _ProductsGovListState();
}

class _ProductsGovListState extends State<ProductsGovList> {
  @override
  Widget build(BuildContext context) {

    final productsGovList = Provider.of<List<Product>>(context);
    if(productsGovList!=null)
    {

        setState(() {
          widget.searchList=productsGovList.where((element) => (element.name.toLowerCase().contains(widget.search.toLowerCase())
              || element.category.toLowerCase().contains(widget.search.toLowerCase())
          )).toList();
          widget.searchList.sort((a,b) {
            var adate = a.category; //before -> var adate = a.expiry;
            var bdate = b.category; //before -> var bdate = b.expiry;
            return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
          });
        });



        if(widget.search==null){
          return ListView.builder(
            itemCount: productsGovList.length,
            itemBuilder: (context, index) {
              return ProductTile(product : productsGovList[index] , type: widget.type);
            },
          );
        }else{
          return ListView.builder(
            itemCount: widget.searchList.length,
            itemBuilder: (context, index) {
              return ProductTile(product : widget.searchList[index] , type: widget.type);
            },
          );
        }

    }else{
      return Loading();
    }
  }
}