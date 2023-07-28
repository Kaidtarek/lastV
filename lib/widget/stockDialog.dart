import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Services/Chips_module.dart';
import '../Services/Stock.dart';
import 'ProductsList.dart';

// Step 1: Create a StateNotifier class to manage the quantity state
class QuantityNotifier extends StateNotifier<double> {
  QuantityNotifier() : super(0.0);

  void updateQuantity(double newQuantity) {
    state = newQuantity;
  }
}

// Step 2: Create the StateNotifierProvider for the quantity state
final quantityProvider = StateNotifierProvider<QuantityNotifier, double>((ref) {
  return QuantityNotifier();
});

class StockDialog extends ConsumerStatefulWidget {
  StockDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<StockDialog> createState() => _StockDialogState();
}

class _StockDialogState extends ConsumerState<StockDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ProductsList = ref.watch(choosedProductProvider);
    final quantity = ref.watch(quantityProvider); // Get the quantity state

    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: ProductsList.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.grey[400],
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ListTile(
                              title: Text(
                                  "product : ${ProductsList[index].s.product_name}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "quanity : ${ProductsList[index].available}  ${ProductsList[index].s.unit}",
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Container(
                                    height: 200,
                                    padding: EdgeInsets.all(20),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "can't be empty";
                                                    }
                                                    if (double.parse(value) >
                                                        ProductsList[index]
                                                            .available) {
                                                      return "the selected value is bigger than the actual quantity";
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      quantityController,
                                                  decoration: InputDecoration(
                                                    hintText: "quantity",
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  ProductsList[index].s.unit,
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                ref.read(
                                                  choosedProductProvider
                                                      .notifier,
                                                ).refresh(
                                                  index,
                                                  double.parse(
                                                    quantityController.text,
                                                  ),
                                                );
                                                ref.read(
                                                  quantityProvider.notifier,
                                                ).updateQuantity(
                                                  double.parse(
                                                    quantityController.text,
                                                  ),
                                                );
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text("done"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
