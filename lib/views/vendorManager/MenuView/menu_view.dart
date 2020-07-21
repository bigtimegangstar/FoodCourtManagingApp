
import 'package:fcfoodcourt/models/dish.dart';
import 'package:fcfoodcourt/models/user.dart';
import 'package:fcfoodcourt/services/dish_db_service.dart';
import 'package:fcfoodcourt/services/authentication_service.dart';
import 'package:fcfoodcourt/views/vendorManager/MenuView/menu_view_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dish_list_view.dart';

/*
This is the menu view that holds the frame for the whole menu
It does holds the add Dish button
 */
class MenuView extends StatefulWidget {
  const MenuView({Key key}) : super(key: key);
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final User userData =  Provider.of<User>(context);
    //IMPORTANT: HAVE TO SET THE SERVICE'S VENDOR ID FROM HERE
    DishDBService.vendorID = userData == null? null : userData.manageID;


    return StreamProvider<List<Dish>>.value(
      value: DishDBService().allVendorDishes,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xffff8a84),
          title: Text(
            "VENDOR MENU",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
              onPressed: () async {
                await AuthenticationService().signOut();
              },)
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 50,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffff8a84), width: 4),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                        hintText: '   Search....'),
                  ),
                ),
                Icon(Icons.search, size: 50, color: Color(0xffff8a84)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(child: DishListView()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffff8a84),
          onPressed: () => onNewDishSelected(),
          child: Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
    );
  }


  void onNewDishSelected(){
    MenuViewController.addDish(context);
  }
}

