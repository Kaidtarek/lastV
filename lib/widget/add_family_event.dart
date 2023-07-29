import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafil/Services/Events.dart';
import 'package:kafil/Services/Stock.dart';
import 'package:kafil/widget/ProductsList.dart';
import 'package:kafil/widget/stockDialog.dart';

import '../Services/Chips_module.dart';
import 'Familyshow.dart';

class AddFamilyEvent extends ConsumerStatefulWidget {
  final Events e;
  const AddFamilyEvent({required this.e, super.key});

  @override
  ConsumerState<AddFamilyEvent> createState() => _AddFamilyEventState();
}

class _AddFamilyEventState extends ConsumerState<AddFamilyEvent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAndAddProductsToProvider(ref, context);
    print("i am rebulding add family page");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(productProvider);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Add family",
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Row(children: [
                      Text("products : "),
                      Expanded(
                        child: ProductList(),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => StockDialog());
                          },
                          icon: Icon(Icons.add))
                    ]),
                  ),
                  Expanded(
                    child: ShowFamilies(
                      doc_id: widget.e.doc_id,
                      Check_box: true,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        if (selected_fam == null) {
                          print("error");
                        } else {
                          final List<CustomStock> products =
                              ref.read(choosedProductProvider);
                          List<String> Fproducts = [];
                          for (var product in products) {
                            if (product.consumed != 0) {
                              Fproducts.add(product.to_String());
                              product.s.choose_p(product.doc_id, product.consumed) ; 
                            }
                          }

                          widget.e
                              .add_family(selected_fam!.family_name ,widget.e.doc_id, selected_fam!.doc_id,  Fproducts);
                          selected_fam = null;
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "ADD family",
                        style: TextStyle(fontSize: 30),
                      ))
                ]),
          ),
        ),
      ),
    );
  }
}