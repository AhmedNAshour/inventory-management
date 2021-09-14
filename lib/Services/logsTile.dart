import 'package:flutter/material.dart';
import 'package:inventory/Models/salesLog.dart';
import 'package:inventory/constants.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SalesLogsTile extends StatefulWidget {

  final SalesLog log;
  //String type;
  SalesLogsTile({ this.log});
  @override
  _SalesLogsTileState createState() => _SalesLogsTileState();
}
class _SalesLogsTileState extends State<SalesLogsTile> {
  @override
  Widget build(BuildContext context) {
    //final  user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              elevation:5,
              color: kPrimaryLightColor,
              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                        title: Text(widget.log.salesManName),
                        subtitle: Text('${DateFormat('dd-MM-yyyy').format(widget.log.date.toDate())}\n' + widget.log.quantity.toString() + ' ${widget.log.itemName}\n' +'Expiry date: ${DateFormat('dd-MM-yyyy').format(widget.log.expiryDate.toDate())}\n' + '${widget.log.destination}'),
                        trailing: Text((widget.log.quantity * widget.log.priceEach).toString()+ ' EGP\n' + '${widget.log.priceEach.toString() + ' per piece'}'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                            Icons.call,color: kPrimaryColor,
                            size: 35,
                        ),
                        onPressed: (){
                          launch("tel://${widget.log.phoneNum}");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}