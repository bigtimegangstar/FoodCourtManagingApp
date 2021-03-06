import 'package:fcfoodcourt/models/vendor.dart';
import 'package:fcfoodcourt/services/authentication_service.dart';
import 'package:fcfoodcourt/services/vendor_db_service.dart';
import 'package:fcfoodcourt/views/FCManager/VendorsView/vendor_management_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fcfoodcourt/services/search_service.dart';
import 'vendor_list_view.dart';

/*
This is the menu view that holds the frame for the whole menu
It does holds the add Vendor button
 */
class VendorManagementView extends StatefulWidget {
  @override
  _VendorManagementViewState createState() => _VendorManagementViewState();
}

class _VendorManagementViewState extends State<VendorManagementView> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Vendor>>.value(
      value: VendorDBService().allVendor,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xffff8a84),
          title: Text(
            "FC VENDORS",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    showSearch(context: context, delegate: SearchForVendor());
                  },
                  child: Container(
                      padding: EdgeInsets.all(5),
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffff8a84), width: 3),
                      ),
                      child: IgnorePointer(
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search,
                                  size: 30, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 10),
                              hintText: '   Search....',
                              hintStyle:
                                  TextStyle(fontSize: 20, color: Colors.grey)),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: VendorListView()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffff8a84),
          onPressed: () => VendorManagementViewController.addVendor(context),
          child: Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
    );
  }
}
