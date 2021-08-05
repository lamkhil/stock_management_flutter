import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_flutter/widgets/dropdown_category_widget.dart';
import 'package:stock_management_flutter/widgets/item_list_widget.dart';

import 'add_item_screen.dart';

class AllItemScreen extends StatefulWidget {
  @override
  _AllItemScreen createState() => _AllItemScreen();
}

class _AllItemScreen extends State<AllItemScreen> {
  final searchController = TextEditingController();
  String searchQuery = '';

  ItemCategoryController controller = ItemCategoryController(itemCategory: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Item'),
        backgroundColor: Colors.amber,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddItemScreen();
          }));
        },
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        print(searchQuery);
                      });
                    },
                    controller: searchController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.black),
                    ),
                  )),
                  Expanded(child: dropDown()),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  // padding: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: ItemListWidget(searchQuery),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dropDown() => DropDownCategoryWidget(controller);
  // Widget productCard() => ProductCardWidget();
}
