import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String category;
  final String name;
  final int quantity;
  final String docId;
  final Timestamp expiryDate;

  Product({ this.category,this.name, this.quantity ,this.docId , this.expiryDate});
}