/*
A form that shows edit.
The function createEditView returns a Future<Dish>
that Dish only contain edit information (name, origin price)
 */
import 'dart:io';

import 'package:fcfoodcourt/models/staff.dart';
import 'package:fcfoodcourt/services/image_upload_service.dart';
import 'package:fcfoodcourt/services/input_field_validator.dart';
import 'package:fcfoodcourt/shared/confirmation_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';

class EditStaffForm extends StatefulWidget {
  final Staff staff;

  const EditStaffForm({Key key, this.staff}) : super(key: key);

  @override
  _EditStaffFormState createState() => _EditStaffFormState();
}

class _EditStaffFormState extends State<EditStaffForm> {
  String name;
  String phone;
  String position;

  String imageName;
  ImageUploadService _imageUploadService = ImageUploadService();
  File _image;
  bool hasImage;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    name = widget.staff.name;
    phone = widget.staff.phone;
    position = widget.staff.position;
    imageName = widget.staff.id;
    hasImage = widget.staff.hasImage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GFAvatar(
                backgroundColor: Colors.transparent,
                shape: GFAvatarShape.square,
                radius: 50,
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
                hintText: "${widget.staff.name}",
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Phone:',
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
            child: TextFormField(
              validator: InputFieldValidator.phoneValidator,
              onChanged: (String phone) {
                this.phone = phone;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "${widget.staff.phone}",
              ),
            ),
          ),
          Spacer(),
          Text(
            'Position:',
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
              onChanged: (String position) {
                this.position = position;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "${widget.staff.position}",
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
                  if(_formKey.currentState.validate()){
                    createConfirmationView(context).then((onValue) {
                      if (onValue == true) {
                        hasImage = _image !=null? true : false;
                        Navigator.of(context).pop(new Staff(name, imageFile: _image,hasImage: hasImage,phone: phone, position: position));
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget showImage(BuildContext context){
    if(widget.staff.hasImage==false){
      return Container(
          height: MediaQuery.of(context).size.height /
              1.25,
          width: MediaQuery.of(context).size.width /
              1.25,
          child: Image.asset("assets/staff.png", fit: BoxFit.fill,));
    }else if(widget.staff.imageURL==null){
      return CircularProgressIndicator();
    }else{
      return Container(
        height:
        MediaQuery.of(context).size.height,
        width:
        MediaQuery.of(context).size.width,
        child: Image.network(
          widget.staff.imageURL,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}

Future<Staff> createPopUpEditStaff(BuildContext context, Staff staff) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                'Edit Staff Form',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xffff6624),
                ),
              ),
              content: SizedBox(
                  height: 500,
                  width: 300,
                  child: EditStaffForm(
                    staff: staff,
                  )),
            ),
          ),
        );
      });
}
