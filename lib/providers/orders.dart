import 'dart:convert';

import 'package:flutter/foundation.dart';

import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String token;
  final String userId;

  List<OrderItem> _orders = [];

  Orders(this._orders, {this.token, this.userId});

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final urlString =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token';
    final timeStamp = DateTime.now();
    var url = Uri.parse(urlString);

    final reponse = await http.post(url,
        body: json.encode({
          'amount': total,
          "dateTime": timeStamp.toIso8601String(),
          'products': cartProducts
              .map((product) => {
                    'id': product.id,
                    'amount': product.price,
                    'title': product.title,
                    'quantity': product.quantity
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(reponse.body)['name'],
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchOrdersFromServer() async {
    final urlString =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$token';
    var url = Uri.parse(urlString);

    final response = await http.get(url);
    // print(json.decode(response.body));
    final List<OrderItem> loadedItem = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderID, orderData) {
      loadedItem.add(OrderItem(
          id: orderID,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['amount']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedItem.reversed.toList();
    notifyListeners();
  }
}
