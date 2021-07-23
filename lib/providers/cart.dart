import 'package:flutter/foundation.dart';

class CartItem {
  final String id, title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  addItems(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity + 1,
              price: existingItem.price));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  int get length {
    return _items.length;
  }

  void deleteItem(String id) {
    print(id);
    _items.remove(id);
    notifyListeners();
  }

  void deleteSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity - 1,
              price: existing.price));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  clear() {
    _items = {};
    notifyListeners();
  }
}
