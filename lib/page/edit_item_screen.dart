import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_management_flutter/page/dashboard_screen.dart';
import 'package:stock_management_flutter/widgets/dropdown_category_widget.dart';

class EditItemScreen extends StatefulWidget {
  final String productName;
  final int productPrice;
  final int productStock;

  EditItemScreen(this.productName, this.productPrice, this.productStock);
  @override
  _EditItemScreen createState() => _EditItemScreen();
}

class _EditItemScreen extends State<EditItemScreen> {
  File _image;
  final itemNameController = TextEditingController();
  final itemCountController = TextEditingController();
  final itemPriceController = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference itemCollection = firestore.collection('items');
    //set initial value
    itemNameController.text = widget.productName;
    itemPriceController.text = widget.productPrice.toString();
    itemCountController.text = widget.productStock.toString();
    ItemCategoryController itemCategoryController =
        ItemCategoryController(itemCategory: '');

    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Edit Item"),
      ),
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          // ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
          // child: Padding(
          //   padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.grey,
                // padding: EdgeInsets.all(48),
                child: IconButton(
                  iconSize: 150,
                  icon: Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () {
                    //image picker
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: itemNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Nama Item"),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: itemCountController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Jumlah Item"),
              ),
              SizedBox(
                height: 15,
              ),
              DropDownCategoryWidget(
                itemCategoryController,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: itemPriceController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixText: "Rp. ",
                    labelText: "Harga Per Item"),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: itemWidth / 3,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.grey)))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.save,
                              color: Colors.black,
                            )
                          ]),
                      onPressed: () {
                        if (itemNameController.text.isEmpty ||
                            itemCountController.text.isEmpty ||
                            itemPriceController.text.isEmpty ||
                            itemCategoryController.itemCategory == '') {
                          Fluttertoast.showToast(
                            msg:
                                'Gagal mengupdate barang. Seluruh kolom harus diisi.',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0,
                          );
                          setState(() {
                            _validate = true;
                          });
                        } else {
                          _updateItem(
                              widget.productName,
                              itemNameController.text,
                              int.tryParse(itemCountController.text),
                              int.tryParse(itemPriceController.text),
                              itemCategoryController.itemCategory);
                          // itemCollection.doc().update({
                          //   'namaBarang': StringUtils.capitalize(
                          //       itemNameController.text),
                          //   'jumlahBarang':
                          //       int.tryParse(itemCountController.text),
                          //   'hargaBarang':
                          //       int.tryParse(itemPriceController.text),
                          //   'kategori': itemCategoryController.itemCategory,
                          // });
                          Fluttertoast.showToast(
                            msg: 'Berhasil mengupdate barang',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            fontSize: 16.0,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateItem(String productName, String newName, int newCount,
      int newPrice, String newCategory) async {
    CollectionReference itemCollection =
        FirebaseFirestore.instance.collection('items');

    var filteredDocumentByName =
        await itemCollection.where('namaBarang', isEqualTo: productName).get();
    for (var doc in filteredDocumentByName.docs) {
      await doc.reference
          .update({'namaBarang': StringUtils.capitalize(newName)});
      await doc.reference.update({'jumlahBarang': newCount});
      await doc.reference.update({'hargaBarang': newPrice});
      await doc.reference.update({'kategori': newCategory});
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    itemCountController.dispose();
    itemPriceController.dispose();
    super.dispose();
  }
}