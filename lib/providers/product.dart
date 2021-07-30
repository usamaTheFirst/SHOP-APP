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

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final urlString =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token';
    var url = Uri.parse(urlString);

    final response = await http.put(url, body: json.encode(isFavorite));
    if (response.statusCode >= 400) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
