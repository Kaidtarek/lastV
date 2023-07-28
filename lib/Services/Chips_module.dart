import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kafil/Services/Stock.dart';
import 'Family.dart';

final productProvider = StateNotifierProvider<ProductNotifier, List<String>>(
  (ref) => ProductNotifier(),
);

final choosedProductProvider =
    StateNotifierProvider<choosedProductNotifier, List<CustomStock>>((ref) {
  return choosedProductNotifier();
});

class ProductNotifier extends StateNotifier<List<String>> {
  ProductNotifier() : super([]);

  void addProduct(String product) {
    state = [...state, product];
  }

  void removeProduct(int index) {
    state = List.from(state)..removeAt(index);
  }
}

class choosedProductNotifier extends StateNotifier<List<CustomStock>> {
  choosedProductNotifier() : super([]);

  void addProduct(CustomStock s) {
    state = [...state, s];
  }

  void updatestate(List<CustomStock> newList) {
    state = newList; 
  }

  void refresh( int index, double quantity) {
    state[index].edit(quantity);
    state = state;
  
  }

  void removeProduct(int index) {
    state = List.from(state).removeAt(index);
  }
}

class CustomStock {
  Stock s;
  double available;
  double consumed;
  CustomStock(
      {required this.s, required this.available, required this.consumed});

  void edit(double quantity) {
    this.available = available - quantity;
    consumed = consumed + quantity;
  }
}
