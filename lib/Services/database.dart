import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory/Models/product.dart';
import 'package:inventory/Models/salesLog.dart';
import 'package:inventory/Models/user.dart';
import 'package:inventory/constants.dart';

class DatabaseService{

  final String uid ;
  String productDocID;
  String inventoryType;
  DatabaseService({ this.uid });
  DatabaseService.named({this.uid , this.productDocID,this.inventoryType});

  final CollectionReference usersCollection  = Firestore.instance.collection('usersDemo');
  final CollectionReference productsCollection  = Firestore.instance.collection('productsDemo');
  final CollectionReference productsGovCollection  = Firestore.instance.collection('governmentProductsDemo');
  final CollectionReference salesLogsCollection  = Firestore.instance.collection('salesLogsDemo');

  Future updateUserData (String name , String number ) async {
    return await usersCollection.document(uid).setData(
      {
        'name': name,
        'number': number,
      }
    );
  }

  Future updateLeaderPassword (String password) async {
    return await usersCollection.document(adminID).updateData(
        {
          'password': password,
        }
    );
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        phoneNumber: snapshot.data['number'],
    );
  }
  List<UserData> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return UserData(
          uid: uid,
          name: doc.data['name'] ?? '',
          phoneNumber: doc.data['number'] ?? '0',
      );
    }).toList();
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
  Stream<List<UserData>> get userDataList {
    return usersCollection.snapshots()
        .map(_userListFromSnapshot);
  }
  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return Product(
          category: doc.data['category'] ?? '',
          name: doc.data['name'] ?? '',
          quantity: doc.data['quantity'] ?? '0',
          expiryDate: doc.data['expiryDate'],
          docId: doc.documentID
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Product>> get products {
    return productsCollection.snapshots()
        .map(_productListFromSnapshot);
  }

  Product _productMapFromSnapshot(DocumentSnapshot snapshot) {
      return Product(
          category: snapshot.data['category'] ?? '',
          name: snapshot.data['name'] ?? '',
          quantity: snapshot.data['quantity'] ?? '0',
          docId: snapshot.documentID
      );
  }

  // get brews stream
  Stream<Product> get productsMap {
    if(inventoryType=='g')
      {
        return productsGovCollection.document(productDocID).snapshots()
            .map(_productMapFromSnapshot);
      }else{
      return productsCollection.document(productDocID).snapshots()
          .map(_productMapFromSnapshot);
    }

  }



  List<Product> _productListFromSnapshotGov(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return Product(
          category: doc.data['category'] ?? '',
          name: doc.data['name'] ?? '',
          quantity: doc.data['quantity'] ?? '0',
          expiryDate: doc.data['expiryDate'],
          docId: doc.documentID
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Product>> get productsGov {
    return productsGovCollection.snapshots()
        .map(_productListFromSnapshotGov);
  }

  List<SalesLog> _salesLogsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return SalesLog(
          itemName: doc.data['name'] ?? '',
          salesManName: doc.data['salesmanName'] ?? '',
          quantity: doc.data['quantity'] ?? '0',
          priceEach: doc.data['priceEach'] ?? '0',
          destination: doc.data['destination'] ?? '',
          docId: doc.documentID,
          date: doc.data['date'],
          phoneNum: doc.data['salesmanNumber'] ?? '',
          expiryDate: doc.data['expiryDate']
      );
    }).toList();
  }

// get brews stream
  Stream<List<SalesLog>> get salesLogs {
    return salesLogsCollection.snapshots()
        .map(_salesLogsFromSnapshot);
  }


  Future addNewProduct(String inventoryType ,String category, String name, int quantity , Timestamp expiryDate) async {
    try {
      if(inventoryType =='g'){
        await Firestore.instance.collection('governmentProductsDemo').add({'category':category,'name':name,'quantity':quantity , 'expiryDate' : expiryDate});
        return 1;
      }else{
        await Firestore.instance.collection('productsDemo').add({'category':category,'name':name,'quantity':quantity , 'expiryDate': expiryDate});
        return 1;
      }

    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future addSaleLog(String name ,String destination, double priceEach , int quantity , String salesmanName , Timestamp date , String number , Timestamp expiryDate) async {
    try {
      await Firestore.instance.collection('salesLogsDemo').add({'name':name,'destination':destination,'quantity':quantity,'priceEach':priceEach , 'salesmanName' : salesmanName , 'date':date , 'salesmanNumber': number , 'expiryDate' : expiryDate});
      return 1;

    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  Future deleteProduct(String id) async {
    try {
      await Firestore.instance.collection('productsDemo').document(id).delete();
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future deleteProductGov(String id) async {
    try {
      await Firestore.instance.collection('governmentProductsDemo').document(id).delete();
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
  Future deleteUser(String id) async {
    try {
      await Firestore.instance.collection('usersDemo').document(id).delete();
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateProduct(String id, int quantity) async {
    try {
      await Firestore.instance.collection('productsDemo').document(id).updateData({'quantity': quantity});
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future updateProductGov(String id, int quantity) async {
    try {
      await Firestore.instance.collection('governmentProductsDemo').document(id).updateData({'quantity': quantity});
      return 1;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  Future<String> getUser_name () async{
    DocumentSnapshot s= await Firestore.instance.collection('usersDemo').document(uid).get();
    return s.data['name'];
  }

  Future<String> getUser_number () async{
    DocumentSnapshot s= await Firestore.instance.collection('usersDemo').document(uid).get();
    return s.data['number'];
  }

  Future<int> readProductCurrentQuantity (String id) async{
    DocumentSnapshot s= await Firestore.instance.collection('productsDemo').document(id).get();
    return s.data['quantity'];
  }

  Future<String> readLeaderPassword () async{
    DocumentSnapshot s= await Firestore.instance.collection('usersDemo').document(adminID).get();
    return s.data['password'];
  }
}
