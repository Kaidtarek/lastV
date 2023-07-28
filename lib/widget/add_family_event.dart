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
                      Check_box: true,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        if (selected_fam == null) {
                          print("error");
                        } else {
                          widget.e.add_family(selected_fam!.family_name,
                              ref.read(productProvider.notifier).state);
                          Navigator.pop(context);
                          selected_fam = null;
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
