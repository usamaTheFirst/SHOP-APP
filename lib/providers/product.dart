import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});
  toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final URL_STRING =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
    var url = Uri.parse(URL_STRING);

    final response =
        await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
