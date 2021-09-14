import 'package:cloud_firestore/cloud_firestore.dart';

class SalesLog {
  final String itemName;
  final String salesManName;
  final String destination;
  final int quantity;
  final double priceEach;
  final Timestamp date;
  final Timestamp expiryDate;
  final docId;
  final String phoneNum;

  SalesLog({ this.itemName,this.salesManName, this.destination , this.quantity ,this.priceEach,this.docId,this.date , this.phoneNum , this.expiryDate});
}