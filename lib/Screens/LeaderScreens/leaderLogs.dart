import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory/Models/salesLog.dart';
import 'package:inventory/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:inventory/constants.dart';
import 'package:inventory/Services/logsList.dart';

class LeaderLogs extends StatefulWidget {

  @override
  _LeaderLogsState createState() => _LeaderLogsState();
}

class _LeaderLogsState extends State<LeaderLogs> {
  var textController = new TextEditingController();
  String search='';
  bool showCancel = false;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return StreamProvider<List<SalesLog>>.value(
      value: DatabaseService().salesLogs,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Center(
            child: Text(
              'Sales Logs',
            ),
          ),
        ),
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: size.width * 0.5,
                    margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: kPrimaryColor,
                        ),
                        hintText: "Search Products",
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        setState(() => search = val);
                      },

                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.date_range,color: kPrimaryColor,),
                    onPressed: (){
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030)
                      ).then((value) =>  setState(() {
                        if(value==null){
                           search='';
                           textController.text='';
                           showCancel=false;


                        }else{
                          search = DateFormat('dd-MM-yyyy').format(value);
                          textController.text=DateFormat('dd-MM-yyyy').format(value);
                          showCancel=true;
                        }
                      })
                      );
                    },
                     // DateFormat('dd-MM-yyyy').format(value))
                  ),
                  IconButton(
                    icon: Icon(
                        Icons.cancel,
                        color: kPrimaryColor,
                    ),
                    enableFeedback: showCancel,
                    onPressed: (){
                      setState(() {
                        search='';
                        textController.text='';
                        showCancel=false;
                      });

                    },
                    // DateFormat('dd-MM-yyyy').format(value))
                  ),
                ],
              ),
            ),
            Expanded(
                child: LogsList(search)
            )

          ],
        ),

      ),

    );

  }
}

