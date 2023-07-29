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

  void refresh(int index, double quantity) {
    state[index].edit(quantity);
    state = List.from(state);
  }

  void reset(int index) {
    state[index].reset();
    state = List.from(state);
  }

  void notify() {
    state = state;
  }

  void removeProduct(int index) {
    state.removeAt(index);
    state = List.from(state);
  }
}

class CustomStock {
  Stock s;
  double available;
  double consumed;
  String doc_id ; 
  CustomStock(
      { required this.s, required this.available, required this.consumed , required this.doc_id});

  void edit(double quantity) {
    this.available = available - quantity;
    consumed = consumed + quantity;
  }

  String to_String() {
    return "${consumed} ${s.product_name} ${s.unit}"; 
  }

  void reset() {
    available = available + consumed;
    consumed = 0;
  }
}