import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafil/Services/Chips_module.dart';

class ProductList extends ConsumerWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(choosedProductProvider);
    print("rebuilded!");
    List<CustomStock> Fproducts = [];
    for (var product in products) {
      if (product.consumed != 0) {
        Fproducts.add(product);
      }
    }
    print("fporducts : ${Fproducts.length}");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: 50,
      decoration: const BoxDecoration(
        color: Color.fromARGB(76, 155, 39, 176),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Fproducts.length,
        itemBuilder: (context, index) {
          return Chip(
            label: Text(Fproducts[index].s.product_name +
                " ${Fproducts[index].consumed} " +
                Fproducts[index].s.unit),
            backgroundColor: Colors.white,
            deleteIcon: Icon(Icons.close),
            onDeleted: () {
              ref.read(choosedProductProvider.notifier).removeProduct(index);
            },
          );
        },
      ),
    );
  }
}
