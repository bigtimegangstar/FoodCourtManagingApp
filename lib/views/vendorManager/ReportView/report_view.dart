
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fcfoodcourt/models/user.dart';
import 'package:fcfoodcourt/views/vendorManager/ReportView/PopUpForms/invalid_view.dart';
import 'package:fcfoodcourt/services/VendorReportDBService/vendor_report_db_service.dart';
import 'package:fcfoodcourt/models/vendor_report.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:fcfoodcourt/shared/dialog_loading_view.dart';
//import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';

class ReportView extends StatefulWidget{
  final User userData;
  final String date;
  final List<Order> orders;
  final List<DailyVendorReport> dailyVendorReport;
  const ReportView(this.date, this.orders, this.dailyVendorReport, {this.userData});
  @override 
  _ReportViewState createState() => _ReportViewState(this.date, this.orders, this.dailyVendorReport);
}

class _ReportViewState extends State<ReportView> with SingleTickerProviderStateMixin{
  TabController _tabController;
  static String currentVendorId;
  static String previousDate = "Please choose the date!!";
  static String previousMonth = "Please choose the month!!";
  static List<Order> previousOrders;
  static List<DailyVendorReport> previousReport;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  static double totalSale;
  static double totalReturn;
  int reportType;
  int toggleReportType = 0;
  String date;
  String formattedDate;
  String formattedMonth;
  String formatId;
  List<Order> orders;
  List<DailyVendorReport> dailyVendorReport;
  //var orderss;
  _ReportViewState(this.date, this.orders, this.dailyVendorReport);
  @override
  void initState() {
    super.initState();
    if(currentVendorId == null)
      currentVendorId = VendorReportDBService.vendorId;
    else{
      if(currentVendorId != VendorReportDBService.vendorId)
        {
          previousDate = "Please choose the date!!";
          previousMonth = "Please choose the month!!";
          currentVendorId = VendorReportDBService.vendorId;
        }
    }
    reportType = checkReportType(date);
    _tabController = TabController(initialIndex: reportType, vsync: this, length: 2);
    if(reportType == 0){
      previousOrders = orders;
      totalSale = VendorReportDBService().calculateTotalSale(previousOrders);
    }
    else{
      previousReport = dailyVendorReport;
      totalReturn = VendorReportDBService().calculateTotalReturn(previousReport);
    }
  }
  Widget printTotalSale(String totalSale, String type){
    return Container(                      
            color: Colors.black,
            height: 75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 18),
                  height: 75,
                  width: 230,
                  //color: Colors.yellow,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 4)
                    )
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 75,
                  width: 176.4,
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 4)
                    )
                  ),
                  child: Text(
                    "$totalSale\$",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
        )
  );
  }
  //DataTable for monthly report
  Widget monthlyTable() {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
          'Date',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ),
        DataColumn(
          label: Text(
          'Sale',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        )
      ],
      rows: previousReport
        .map(
          (report) => DataRow(cells: [
            DataCell(
              Text(report.date),
            ),
            DataCell(
              Text("${report.sale} VND"),
            ),
          ])
        ).toList()
    );
  }
  //DataTable for daily report
  Widget dailyTable(){ 
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
          'Orders',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ),
        DataColumn(
          label: Text(
          'Quantity',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ),
        DataColumn(
          label: Text(
          'Price',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ),
        DataColumn(
          label: Text(
          'Revenue',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ),
      ],
      rows: previousOrders
        .map(
          (order) => DataRow(cells: [
            DataCell(
              Text(order.name),
            ),
            DataCell(
              Text("${order.quantity}"),
            ),
            DataCell(
              Text("${order.price} VND"),
            ),
            DataCell(
              Text("${order.revenue} VND"),
            )
          ])        
        ).toList()
    );
  }
  // check if choose new date or not
  Widget checkNewDate() {
    if(reportType == 0)
    {
      previousDate = ' $date';
      return Text(
        ' $date',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.start,
      );
    }
    return Text(
        previousDate,
        style: TextStyle(
          color: Colors.black87,
          fontSize:  previousDate == "Please choose the date!!" ? 30 : 20,
          fontWeight: FontWeight.bold
        ),
        textAlign:  previousDate == "Please choose the date!!" ? TextAlign.center : TextAlign.start,
      );
  }
  // check if choose new month or not
  Widget checkNewMonth() {
    if(reportType == 1)
    {
      previousMonth = ' $date';
      return Text(
        ' $date',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.start,
      );
    }
    return Text(
        previousMonth,
        style: TextStyle(
          color: Colors.black87,
          fontSize: previousMonth == "Please choose the month!!" ? 30 : 20,
          fontWeight: FontWeight.bold
        ),
        textAlign: previousMonth == "Please choose the month!!" ? TextAlign.center : TextAlign.start,
      );
  }
  // Change date or month button
  Widget changeTime(String type){
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: RaisedButton(
          color: Color(0xffff8a84),
          child: new Text(
            type, 
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              ),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            if(type == 'Choose Date')
            {
              showDatePicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime(2020), 
                lastDate: DateTime(2030))
              .then((onValue) {
                if(onValue != null){
                  formattedDate = DateFormat('dd/MM/yyyy').format(onValue);
                  formatId = DateFormat('ddMMyyyy').format(onValue);
                  Dialogs.showLoadingDialog(context, _keyLoader);
                  VendorReportDBService().checkAvailableDailyReport(formatId).then((onValue) {
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    if(onValue != null)
                    {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => ReportView(formattedDate, onValue, null))                    
                      );
                    }
                    else {
                      createPopUpInvalidMessage(context);
                    }
                  });
                }
              }
              );
            }
            if(type == 'Choose Month')
            {
              showMonthPicker(
                context: context, 
                initialDate: DateTime.now(), 
                firstDate: DateTime(2020), 
                lastDate: DateTime(2030))
              .then((onValue){
                if(onValue != null){
                  formattedMonth = DateFormat('MM/yyyy').format(onValue);
                  formatId = DateFormat('MMyyyy').format(onValue);
                  Dialogs.showLoadingDialog(context, _keyLoader);
                  VendorReportDBService().checkAvailableMonthlyReport(formatId).then((onValue){
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    if(onValue != null)
                    {
                      Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => ReportView(formattedMonth, null, onValue))                    
                      );
                    }
                    else {
                      createPopUpInvalidMessage(context);
                    }
                  });
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
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false, // address bottom overflow error
      resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xffff8a84),
          title: Text(
            "VIEW REPORT",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
            tabs: <Widget>[
              Tab(child: Text(
                  'Daily',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )
              ),
              Tab(child: Text(
                  'Monthly',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (int type) {
              type++;
              if(type == 1)
                totalSale = VendorReportDBService().calculateTotalSale(previousOrders);
              else
                totalReturn = VendorReportDBService().calculateTotalReturn(previousReport);
            },
          ),
          //automaticallyImplyLeading: false,
        ),
        body: TabBarView(
              //physics: const ScrollPhysics(),
              children: <Widget>[
                //DAILY REPORT
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [               
                    Row(
                    children: [
                      // date or message
                      Container(
                        margin: EdgeInsets.only(top: previousDate == "Please choose the date!!" && reportType != 0 ? 150 : 20),
                        padding: EdgeInsets.only(top: 20),
                        height: 50,
                        //alignment: previousDate == "Please choose the date!!" ? Alignment.center : Alignment.centerLeft,
                        child: checkNewDate(),
                        width: previousDate == "Please choose the date!!" ? 400 : 130,                        
                      ),
                      // If there is already a searched daily report
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(top: 20),
                        height: 50,
                        width: previousDate == "Please choose the date!!" ? 0 : 270,
                        alignment: Alignment.centerRight,
                        child: previousDate == "Please choose the date!!" ? null : changeTime("Choose Date")
                      )
                    ]
                    ),
                    // if there is not any searched daily report
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: previousDate != "Please choose the date!!" ? 0 : 20),
                          padding: EdgeInsets.only(top: previousDate != "Please choose the date!!" ? 0 : 20),
                          height: previousDate != "Please choose the date!!" ? 0 : 75,
                          width: previousDate != "Please choose the date!!" ? 0 : 200,
                          alignment: Alignment.center,
                          child: previousDate != "Please choose the date!!" ? null : SizedBox(
                            width: 200,
                            height: 100,
                            child: changeTime("Choose Date")
                          )  
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(scrollDirection: Axis.vertical, child: previousDate == "Please choose the date!!" ? null : dailyTable(),)
                      )
                    ),
                    // Print total sale
                    Container(
                      child: previousDate == "Please choose the date!!" ? null : printTotalSale("$totalSale", "Total Daily Sale")
                    )
                  ],
                ),
                // MONTHLY REPORT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: previousMonth == "Please choose the month!!" && reportType != 1 ? 150 : 20),
                        padding: EdgeInsets.only(top: 20),
                        height: 50,
                        alignment: previousMonth == "Please choose the month!!" ? Alignment.center : Alignment.centerLeft,
                        child: checkNewMonth(),
                        width: previousMonth == "Please choose the month!!" ? 400 : 125,                        
                      ),
                      // If there is already a searched monthly report
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.only(top: 20),
                        height: 50,
                        width: previousMonth == "Please choose the month!!" ? 0 : 275,
                        alignment: Alignment.centerRight,
                        child: previousMonth == "Please choose the month!!" ? null : changeTime("Choose Month")
                      )
                    ]
                    ),
                    // if there is not any searched monthly report
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: previousMonth != "Please choose the month!!" ? 0 : 20),
                          padding: EdgeInsets.only(top: previousMonth != "Please choose the month!!" ? 0 : 10),
                          height: previousMonth != "Please choose the month!!" ? 0 : 75,
                          width: previousMonth != "Please choose the month!!" ? 0 : 200,
                          child: previousMonth != "Please choose the month!!" ? null : SizedBox(
                            width: 200,
                            height: 100,
                            child: changeTime("Choose Month")
                          ),
                          alignment: Alignment.center,
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(scrollDirection: Axis.vertical, child: previousMonth == "Please choose the month!!" ? null : monthlyTable())
                      )
                    ),
                    //Print total return
                    Container(
                      child: previousMonth == "Please choose the month!!" ? null : printTotalSale("$totalReturn", "Total Monthly Sale")
                    )
                  ],
                ),
              ],
              controller: _tabController,
            ),
      );
  }
int checkReportType(String  date)
{
  reportType = 0;
  if(date.length < 9)
    reportType = 1;
  return reportType;
}
}

var orderss = <Order>[Order(name: "pho", price: 400 , quantity: 4, revenue: 1600000 ),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),
                Order(name: "Bun bo", price: 40, quantity: 5, revenue: 200),]; 

