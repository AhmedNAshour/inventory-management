import 'package:intl/intl.dart';
import 'package:inventory/Models/salesLog.dart';
import 'package:flutter/material.dart';
import 'package:inventory/Screens/Shared/loading.dart';
import 'package:provider/provider.dart';
import 'logsTile.dart';

class LogsList extends StatefulWidget {
  @override
  _LogsListState createState() => _LogsListState();
  String search='';
  List<SalesLog> searchList = List<SalesLog>();
  LogsList( String search){
    this.search = search;
  }
}
class _LogsListState extends State<LogsList> {
  @override
  Widget build(BuildContext context) {
    final salesLogsList = Provider.of<List<SalesLog>>(context);
       if(salesLogsList != null){
         setState(() {
           //print(DateFormat('dd-MM-yyyy').format(salesLogsList[0].date.toDate()));
           widget.searchList=salesLogsList.where((element) => (element.itemName.toLowerCase().contains(widget.search.toLowerCase())
               || element.salesManName.toLowerCase().contains(widget.search.toLowerCase())
               || element.destination.toLowerCase().contains(widget.search.toLowerCase())
               || DateFormat('dd-MM-yyyy').format(element.date.toDate()).contains(widget.search)
           )).toList();
           widget.searchList.sort((b,a) {
             var adate = a.date; //before -> var adate = a.expiry;
             var bdate = b.date; //before -> var bdate = b.expiry;
             return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
           });
         });

         if(widget.search==null)
         {
           return ListView.builder(
             itemCount: salesLogsList.length,
             itemBuilder: (context, index) {
               return SalesLogsTile(log : salesLogsList[index]);
             },
           );
         }else{
           return ListView.builder(
             itemCount: widget.searchList.length,
             itemBuilder: (context, index) {
               return SalesLogsTile( log: widget.searchList[index]);
             },
           );
         }

       }else{
         return Loading();
       }


  }
}