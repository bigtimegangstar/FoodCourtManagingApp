import 'package:fcfoodcourt/models/user.dart';
import 'package:fcfoodcourt/views/FCManager/ReportView/PopUpForms/choose_date_view.dart';
import 'package:fcfoodcourt/views/FCManager/ReportView/PopUpForms/choose_month_view.dart';
import 'package:fcfoodcourt/views/FCManager/ReportView/report_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fcfoodcourt/services/authentication_service.dart';
import 'package:provider/provider.dart';

class SelectTypeView extends StatefulWidget {
  final User userData;
  const SelectTypeView({this.userData});
  @override
  _SelectTypeViewState createState() => _SelectTypeViewState();
}

class _SelectTypeViewState extends State<SelectTypeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //child: Scaffold(
        resizeToAvoidBottomInset: false, // address bottom overflow error
        //resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xffff8a84),
          title: Text(
            "VIEW REPORT",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
              onPressed: () async {
                await AuthenticationService().signOut();
              },)
          ],
        ),
        body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Row(
            children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  padding: EdgeInsets.only(top: 10),
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffff8a84), width: 4),
                  ),
                  child: Text(
                    'PLEASE CHOOSE REPORT TYPE',
                    style: TextStyle(
                      color: Color(0xffff8a84),
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                      ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
          Container(
                margin: EdgeInsets.only(top: 150),
                child: SizedBox(
                width: 200,
                height: 100,
                child: reportType("Monthly"),
              ),
          )         
          ]
        ),
        ],
        )
    );
    //  ),
  }
  Positioned reportType(String type) {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RaisedButton(
          color: Color(0xffff8a84),
          child: new Text(
            type, 
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              ),
          ),
          onPressed: () {
            /*if(type == 'Daily')
            {
              print(type);
              createPopUpChooseDate(context).then((onValue){
                if(onValue != null){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ReportView(onValue))
                  );
                }
              }
              );
            }*/
            if(type == 'Monthly')
            {
              print(type);
              createPopUpChooseMonth(context).then((onValue){
                if(onValue != null){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => ReportView(onValue))
                  );
                }
              }
              );
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0))
            ),
          ),
        );
  }
}