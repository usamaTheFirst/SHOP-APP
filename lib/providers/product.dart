import 'package:flutter/cupertino.dart';

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
  toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
