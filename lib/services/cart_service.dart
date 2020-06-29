
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcfoodcourt/models/dish.dart';
import 'package:fcfoodcourt/models/order.dart';
import 'package:fcfoodcourt/services/image_upload_service.dart';
import 'package:fcfoodcourt/services/dish_db_service.dart';
class CartService {
  //Collection reference for DishDB
  final CollectionReference dishDB = Firestore.instance.collection("orderDB");

  //the dish db only response the correct menu according to the user's id (vendor's id)
  //this field is static and set when we first go to home page (menu,... in this case)
  static String orderID;

  //add dish as a new document to db, id is randomize by Firebase
  /*Future addOrder(Order order) async {
    DocumentReference _orderRef = orderDB.document();
    return await _orderRef.setData({
      "id": _orderRef.documentID,
      "totalPrice": order.totalPrice,
    });
  }*/

  Future addDish(Dish dish) async {
    DocumentReference _dishRef = dishDB.document();
    ImageUploadService().uploadPic(dish.imageFile,_dishRef.documentID);
    return await _dishRef.setData({
      "name": dish.name,
      "id": _dishRef.documentID,
      "originPrice": dish.originPrice,
      "realPrice": dish.realPrice,
      "discountPercentage": dish.discountPercentage,
      "hasImage" : dish.hasImage,
      "isOutOfOrder": dish.isOutOfOrder,
    });
  }

  //update dish, changing name, original price and reset it's discount state
  /*Future editDish(Dish dish, Dish newDish) async {
    DocumentReference _dishRef = dishDB.document(dish.id);
    ImageUploadService().uploadPic(newDish.imageFile,_dishRef.documentID);
    return await _dishRef.updateData({
      "name": newDish.name,
      "originPrice": newDish.originPrice,
      "realPrice": newDish.originPrice, //reset on edit
      "discountPercentage": 0.0, //reset on edit
      "hasImage" : dish.hasImage==true?true:newDish.hasImage==true?true:false,
      "isOutOfOrder" : false, // reset on edit
      //no update vendor ID
    });
  }*/

  //update discount prices
  /*Future discountDish(Dish dish, Dish newDish) async {
    DocumentReference _dishRef = dishDB.document(dish.id);
    return await _dishRef.updateData({
      "realPrice": newDish.realPrice,
      "discountPercentage": newDish.discountPercentage,
    });
  }*/

  //remove document from database collection
  Future removeDish(Dish dish) async {
    DocumentReference _orderRef = dishDB.document(dish.id);
    return await _orderRef.delete();
  }

  //set Dish out of order
  /*Future setOutOfOrder(Dish dish) async {
    DocumentReference _dishRef = dishDB.document(dish.id);
    return await _dishRef.updateData({
      "isOutOfOrder" : dish.isOutOfOrder, //this data is set in the dish above
      //no update vendor ID
    });
  }*/

  Stream<List<Dish>> get allOrderDishes {
    return dishDB.snapshots().map(_dishListFromSnapshot);
  }
  //get DishDB snapshot stream, this stream will auto-update if DB have change and notify any listener
  List<Dish> _dishListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) {
      return Dish(
        doc.data['name'] ?? '', doc.data['originPrice'] ?? 0.0,
        discountPercentage: doc.data['discountPercentage'] ?? 0.0,
        realPrice: doc.data['realPrice'] ?? 0.0,
        id: doc.data['id'] ?? '',
        hasImage: doc.data['hasImage'] ?? false,
        isOutOfOrder: doc.data ['isOutOfOrder'] ?? false,
      );
    }).toList();
  }

}
