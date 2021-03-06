/*
This is the menu view that holds the frame for the whole menu
It does holds the add Dish button
 */
import 'dart:io';

import 'package:fcfoodcourt/models/user.dart';
import 'package:fcfoodcourt/services/authentication_service.dart';
import 'package:fcfoodcourt/services/image_upload_service.dart';
import 'package:fcfoodcourt/services/user_db_service.dart';
import 'package:fcfoodcourt/views/profileViews/change_password_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:getflutter/shape/gf_avatar_shape.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  // userData passed down by the userRouter
  const ProfilePage({Key key}) : super(key: key);
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<ProfilePage> {
  bool pickedImage = false;
  File image;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User userData = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffff8a84),
        title: Text(
          "PROFILE",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Log Out'),
            onPressed: () async {
              await AuthenticationService().signOut();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(),
                      InkWell(
                        //TODO: remove after debug
                        onTap: () {
                          print(userData.toString());
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                            msg: userData.toString(),
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          padding: EdgeInsets.all(10),
                          margin:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.orange,
                                width: 5,
                              )),
                          child: GFAvatar(
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: showImage(context, userData)),
                            shape: GFAvatarShape.circle,
                            radius: 1000,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                File returnImage = await ImageUploadService()
                                    .getImageFromImagePicker();
                                setState(() {
                                  image = returnImage;
                                  pickedImage = true;
                                });
                                //upload image here
                                UserDBService(userData.id)
                                    .uploadProfileImage(userData.imageFile);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Name: ",
                    style: TextStyle(
                        color: Color(0xffffa834),
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${userData.name}",
                    style: TextStyle(
                      color: Color(0xffffa834),
                      fontSize: 40.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Role:",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${userData.role}",
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Email:",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${userData.email}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "UID: ${userData.id}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: Color(0xfff85f6a),
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      createPopUpChangePassword(context, userData)
                          .then((onValue) {
                        if (onValue != null) {
                          Fluttertoast.showToast(msg: onValue);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showImage(BuildContext context, User userData) {
    if (pickedImage == true) {
      return Image.file(
        image,
        fit: BoxFit.fill,
      );
    }
    if (userData.hasImage == false) {
      return Container(
          child: Image.asset(
        "assets/user.png",
        fit: BoxFit.fill,
      ));
    } else if (userData.imageURL == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          userData.imageURL,
          fit: BoxFit.fill,
        ),
      );
    }
  }
}
