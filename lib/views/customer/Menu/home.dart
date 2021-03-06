import 'package:fcfoodcourt/models/order.dart';
import 'package:fcfoodcourt/models/vendor.dart';
import 'package:fcfoodcourt/services/order_db_service.dart';
import 'package:fcfoodcourt/services/search_service.dart';
import 'package:fcfoodcourt/services/vendor_db_service.dart';
import 'package:fcfoodcourt/services/authentication_service.dart';
import 'package:fcfoodcourt/models/user.dart';
import 'package:fcfoodcourt/views/customer/Menu/vendor_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:fcfoodcourt/views/customer/Menu/dishes_of_vendor.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:flushbar/flushbar.dart';
//import '../MyCart/dishes_cart.dart';
/*
This is the menu view that holds the frame for the whole menu
It does holds the add Dish button
 */
int currentIndex = 0;

class CustomerView extends StatefulWidget {
  final User userData; // userData passed down by the userRouter
  const CustomerView({Key key, this.userData}) : super(key: key);

  @override
  _CustomerViewState createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  final List<Widget> children = [];
  List<String> localHis = [];
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    children.add(VendorListView(
      onVendorSelected: (String id, String name) {
        setState(() {
          currentIndex = 1;
          CustomerDishView.vendorId = id;
          CustomerDishView.vendorName = name;
        });
      },
    ));
    children.add(CustomerDishView());
    Order.customerID = widget.userData.id;
    OrderDBService.customerID = widget.userData.name;
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Vendor>>.value(
        value: VendorDBService().allVendor,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: (currentIndex == 1)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              //inVendor = false;
                              setState(() {
                                CustomerDishView.vendorName = "";
                                currentIndex = 0;
                              });
                            })
                      ],
                    )
                  : SizedBox(),
              backgroundColor: Color(0xffff8a84),
              title: (currentIndex == 0)
                  ? Text(
                      "Food Court",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    )
                  : Marquee(
                      child: Text(
                        CustomerDishView.vendorName,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      direction: Axis.horizontal,
                      textDirection: TextDirection.ltr,
                      animationDuration: Duration(seconds: 1),
                      backDuration: Duration(milliseconds: 1800),
                      pauseDuration: Duration(milliseconds: 1800),
                      directionMarguee: DirectionMarguee.oneDirection,
                    ),
              centerTitle: true,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('logout'),
                  onPressed: () async {
                    await AuthenticationService().signOut();
                  },
                )
              ],
            ),
            body: WillPopScope(
              onWillPop: onWillPop,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: (currentIndex == 0)
                        ? <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    if (currentIndex == 0) {
                                      vendorID = "";
                                    } else {
                                      vendorID = CustomerDishView.vendorId;
                                    }
                                    localHis = await getStringList();
                                    passToSearchHelper();
                                    setState(() {
                                      if (localHis != null) {
                                        SearchHelper.history = localHis;
                                      } else {
                                        SearchHelper.history = [];
                                      }
                                    });
                                    // SharedPreferences preferences =
                                    //     await SharedPreferences.getInstance();
                                    // preferences.clear();
                                    showSearch(
                                            context: context,
                                            delegate: SearchService())
                                        .then((filter) {
                                      setState(() {
                                        CustomerDishView.vendorName = "";
                                      });
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffff8a84), width: 3),
                                      ),
                                      child: IgnorePointer(
                                        child: TextField(
                                          decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.search,
                                                  size: 30, color: Colors.grey),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 10),
                                              hintText: '   Search....',
                                              hintStyle: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey)),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(child: children[currentIndex]),
                          ]
                        : <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(child: children[currentIndex]),
                          ]),
              ),
            )));
  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    if (currentIndex == 0) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Press back again to exit");
        return Future.value(false);
      }
      return Future.value(true);
    } else {
      setState(() {
        //inVendor = false;
        CustomerDishView.vendorName = "";
        currentIndex = 0;
      });
      return Future.value(false);
    }
  }
}
