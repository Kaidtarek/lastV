import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Chips_module.dart';

class Stock {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String product_name;
  DateTime expiry_date;
  DateTime added_date;
  double quantity;
  String unit;
  Stock(this.product_name, this.expiry_date, this.added_date, this.quantity,
      this.unit);
  bool AddProduct() {
    db.collection("Products").doc().set({
      "Product_name": product_name,
      "Quantity": quantity,
      "unit": unit,
      "Add_date": Timestamp.fromDate(added_date),
      "exp_date": Timestamp.fromDate(expiry_date)
    }).onError((error, stackTrace) => print("error : $error"));
    return true;
  }

  bool choose_p(String doc_id, double quantity) {
    double new_quantity = this.quantity - quantity;
    bool val = true;
    db.collection("Products").doc(doc_id).set({
      "Product_name": product_name,
      "Quantity": new_quantity,
      "Add_date": Timestamp.fromDate(added_date),
      "exp_date": Timestamp.fromDate(expiry_date),
      "unit": unit,
    }).onError((error, stackTrace) {
      print("error : $error");
      val = false;
    });
    return val;
  }

  bool cancel_p(String doc_id, double quantity) {
    double new_quantity = this.quantity - quantity;
    bool val = true;
    db.collection("Products").doc(doc_id).set({
      "Product_name": product_name,
      "Quantity": new_quantity,
      "Add_date": Timestamp.fromDate(added_date),
      "exp_date": Timestamp.fromDate(expiry_date),
      "unit": unit,
    }).onError((error, stackTrace) {
      print("error : $error");
      val = false;
    });
    return val;
  }

  bool edit(String doc_id) {
    bool val = true;
    db.collection("Products").doc(doc_id).set({
      "Product_name": product_name,
      "Quantity": quantity,
      "Add_date": Timestamp.fromDate(added_date),
      "exp_date": Timestamp.fromDate(expiry_date)
    }).onError((error, stackTrace) {
      print("error : $error");
      val = false;
    });
    return val;
  }

  static delete_product(String doc_id) {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("Products").doc(doc_id).delete();
  }
}

Future<void> fetchAndAddProductsToProvider(
    WidgetRef ref, BuildContext context) async {
  try {
    final CollectionReference<Map<String, dynamic>> productsRef =
        FirebaseFirestore.instance.collection('Products');

    // Use snapshots() to get real-time updates
    productsRef.snapshots().listen((querySnapshot) {
      final List<CustomStock> products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return CustomStock(
          s: Stock(
              data['Product_name'],
              data['exp_date'].toDate(),
              data['Add_date'].toDate(),
              double.parse(data['Quantity'].toString()),
              data['unit']),
          available: double.parse(data['Quantity'].toString()),
          consumed: 0,
        );
      }).toList();

        ref.read(choosedProductProvider.notifier).updatestate(products);
      print(ref.read(choosedProductProvider).length); 
    });
  } catch (e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("error"),
              content: Text("error in fetching products"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Back"))
              ],
            ));
  }
}
