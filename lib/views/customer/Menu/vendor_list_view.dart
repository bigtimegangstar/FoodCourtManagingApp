import 'dart:ui';
import 'package:fcfoodcourt/services/search_service.dart';
import 'package:fcfoodcourt/models/vendor.dart';
//import 'package:fcfoodcourt/services/vendor_db_service.dart';
import 'package:fcfoodcourt/views/customer/Menu/vendor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

/* This is the frame list of dishes. It actively listen to dishDB changes and refresh it's view accordingly
    It also define the function for each button from the dish elements in the list
 */

class VendorListView extends StatefulWidget {
  final Function(String, String) onVendorSelected;
  const VendorListView({Key key, this.onVendorSelected}) : super(key: key);
  @override
  _VendorListViewState createState() => _VendorListViewState();
}

class _VendorListViewState extends State<VendorListView> {
  @override
  Widget build(BuildContext context) {
    final List<Vendor> vendorList = Provider.of<List<Vendor>>(context);
    //SearchService.listVendor = vendorList;
    return ListView.builder(
      itemCount: vendorList == null ? 0 : vendorList.length,
      itemBuilder: (context, index) {
        return VendorView(
          vendor: vendorList[index],
          onVendorSelected: widget.onVendorSelected,
          /*onRemoveSelected: () {
            //Remove chosen, ask user for confirmation and remove in DB if confirmed
            createConfirmationView(context).then((onValue) {
              if (onValue == true) {
                DishDBService().removeDish(dishList[index]);
              }
            });
          },
          onEditSelected: () {
            //Edit chosen, show edit form and process returned information
            //The return value is Dish with name and price (no realPrice,...)
            createPopUpEditDish(context, dishList[index]).then((onValue) {
              if (onValue != null) {
                DishDBService().editDish(dishList[index], onValue);
              }
            });
          },
          onDiscountSelected: () {
            //Discount chosen, show discount form and process returned information
            //The return value is Dish with discounted price and percentage (no name,...)
            createPopUpDiscountDish(context, dishList[index]).then((onValue) {
              if (onValue != null) {
                DishDBService().discountDish(dishList[index], onValue);
              }
            });
          },*/
        );
      },
    );
  }
}
