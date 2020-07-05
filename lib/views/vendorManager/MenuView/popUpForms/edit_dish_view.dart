
import 'dart:io';

import 'package:fcfoodcourt/models/dish.dart';
import 'package:fcfoodcourt/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';

import '../../../../shared/confirmation_view.dart';
//TODO: find a way to notify view and update when storage is updated
/*
A form that shows edit.
The function createEditView returns a Future<Dish>
that Dish only contain edit information (name, origin price)
 */
class EditDishForm extends StatefulWidget {
  final Dish dish;

  const EditDishForm({Key key, this.dish}) : super(key: key);

  @override
  _EditDishFormState createState() => _EditDishFormState();
}

class _EditDishFormState extends State<EditDishForm> {
  String name;
  double price;
  String imageName;
  ImageUploadService _imageUploadService = ImageUploadService();
  File _image;
  bool hasImage;

  @override
  void initState() {
    name = widget.dish.name;
    price = widget.dish.originPrice;
    imageName = widget.dish.id;
    hasImage = widget.dish.hasImage;
    super.initState();
  }
//TODO: add image picker,... after implementing better way to use image
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GFAvatar(
                shape: GFAvatarShape.square,
                radius: 50,
                backgroundColor: Colors.white,
                child: ClipRect(
                  child: new SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: showImage(context),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: IconButton(
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    File returnImage = await _imageUploadService.getImageFromImagePicker();
                    setState(() {
                      _image = returnImage;
                    });
                  },
                ),
              ),
            ],
          ),
          Text(
            'Name:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: TextField(
              onChanged: (String name) {
                this.name = name;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "${widget.dish.name}",
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Price:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2)),
            child: TextField(
              onChanged: (String price) {
                this.price = double.parse(price);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "${widget.dish.originPrice}",
              ),
            ),
          ),
          Spacer(),
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
                  Navigator.of(context).pop(null);
                },
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  createConfirmationView(context).then((onValue) {
                    if (onValue == true) {
                      hasImage = _image !=null? true : false;
                      Navigator.of(context).pop(new Dish(name, price,imageFile: _image,hasImage: hasImage));
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget showImage(BuildContext context){
    return  FutureBuilder(
      future: ImageUploadService().getImageFromCloud(context, imageName),
      builder: (context, snapshot) {
        if(_image != null){
          return Container(
              height: MediaQuery.of(context).size.height /
                  1.25,
              width: MediaQuery.of(context).size.width /
                  1.25,
              child: Image.file(_image, fit: BoxFit.fill,));
        }
        if(hasImage==false || snapshot.connectionState == ConnectionState.waiting){
          return Container(
              height: MediaQuery.of(context).size.height /
                  1.25,
              width: MediaQuery.of(context).size.width /
                  1.25,
              child: Image.asset("assets/bowl.png", fit: BoxFit.fill,));
        }
        if (snapshot.connectionState == ConnectionState.done) //image is found
          return Container(
            height:
            MediaQuery.of(context).size.height,
            width:
            MediaQuery.of(context).size.width,
            child: snapshot.data,
            //TODO: future builder will keep refreshing while scrolling, find a way to keep data offline and use a stream to watch changes instead.
          );
        return Container();

      },
    );
  }
}

Future<Dish> createPopUpEditDish(BuildContext context, Dish dish) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                'Edit Dish Form',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xffff6624),
                ),
              ),
              content: SizedBox(
                  height: 380,
                  width: 300,
                  child: EditDishForm(
                    dish: dish,
                  )),
            ),
          ),
        );
      });
}

