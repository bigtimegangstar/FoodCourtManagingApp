import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/getflutter.dart';

//import 'package:fcfoodcourt/services/dish_db_service.dart';
import '../../../models/dish.dart';
import 'package:fcfoodcourt/services/image_upload_service.dart';
import 'package:fcfoodcourt/services/view_logic_helper.dart';
import 'package:fcfoodcourt/services/cart_service.dart';
import 'pop_add.dart';

/*
This is the vendor element in the list view
it has call back fields so that the parent that contains this can specify
it's functionality.
 */
class ItemDishView extends StatelessWidget {
  final Dish dish;
  final String vendorName;

  const ItemDishView({Key key, this.dish, this.vendorName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 400,
      margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
      decoration: BoxDecoration(
        color: dish.isOutOfOrder ? Colors.grey[400] : Colors.transparent,
        border: Border.all(
          color: Colors.black45,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FittedBox(
        alignment: Alignment.centerLeft,
        child: Material(
          color: dish.isOutOfOrder ? Colors.grey[400] : Colors.transparent,
          elevation: 0,
          borderRadius: BorderRadius.circular(40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: dish.isOutOfOrder
                            ? Colors.grey[400]
                            : Colors.transparent,
                        width: 2,
                      )),
                  child: GFAvatar(
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: showImage(context)),
                    shape: GFAvatarShape.square,
                    radius: 25,
                    borderRadius: BorderRadius.circular(10),
                  )),

              Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          dish.name,
                          style: TextStyle(
                              color: Color(0xbb000000),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        )),
                    ViewLogic.displayPrice(context, dish),
                    SizedBox(
                      height: 4,
                      //width: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 63,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: dish.isOutOfOrder
                                ? Colors.grey
                                : Color(0xfff85f6a),
                            child: dish.isOutOfOrder
                                ? Text(
                                    'Out of order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.5,
                                    ),
                                  )
                                : Text(
                                    'Add to cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                            onPressed: () {
                              if (dish.isOutOfOrder == false) {
                                CartService().addDish(dish, vendorName);
                                createAddedView(context).then((onValue) {});
                              } else {
                                Fluttertoast.cancel();
                                Fluttertoast.showToast(
                                  msg: "Sorry, the dish is out of order",
                                );
                              }
                            },

                            ///
                          ),
                        ]),
                  ],
                ),
                //The price is displayed dynamically by view logic
              ) // ViewLogic.displayPrice(context, vendor)
            ],
          ),
        ),
      ),
    );
  }

  Widget showImage(BuildContext context) {
    if (dish.hasImage == false) {
      return Container(
          height: MediaQuery.of(context).size.height / 1.25,
          width: MediaQuery.of(context).size.width / 1.25,
          child: Image.asset(
            "assets/dish.png",
            fit: BoxFit.fill,
          ));
    } else if (dish.imageURL == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          dish.imageURL,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}
