import 'package:fcfoodcourt/services/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_dish_list_view.dart';
import 'cart_view.dart';

/*
A form that shows confirmation.
The function createConfirmationView returns a Future<bool>
which tells if user confirmed or not
 */
class OrderedDishesPopUp extends StatelessWidget {
  String vendorId;
  OrderedDishesPopUp(this.vendorId, this.onChangeConfirm);
  final Function() onChangeConfirm;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(40),
            //border: Border.all(color: Color(0xfff85f6a), width: 4)
          ),
          height: 500,
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: CartDishListView(vendorId)),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Colors.white,
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      // CartService.cart = CartService.initCart;
                      // CartService.totalPrice = CartService.initTotal;
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Color(0xfff85f6a),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onChangeConfirm();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> createOrderedDishesPopUp(
    BuildContext context, String vendorId, Function onChangeConfirm) {
  return showDialog(
      context: context,
      builder: (context) {
        return OrderedDishesPopUp(vendorId, onChangeConfirm);
      });
}
