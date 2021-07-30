import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/Models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  final String token;
  final String userId;
  List<Product> _items = [];

  Products([this.token, this._items, this.userId]);
  // var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchFromServer({bool filterByUser = false}) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final urlString =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$token$filterString';
    // print(urlString);
    var url = Uri.parse(urlString);

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData);
      if (extractedData == null) {
        return null;
      }
      final favUrl =
          'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$token';
      url = Uri.parse(favUrl);
      final favoriteResponse = await http.get(url);
      final favData = json.decode(favoriteResponse.body);

      final List<Product> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.insert(
            0,
            Product(
                id: key,
                isFavorite: favData == null ? false : favData[key] ?? false,
                title: value['title'],
                description: value['description'],
                imageUrl: value['imageUrl'],
                price: value['price']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
      print('ERROR has occured');
    }
  }

  Future<void> addProduct(Product product) async {
    final urlStirng =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$token';
    var url = Uri.parse(urlStirng);

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            "price": product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
          title: product.title,
          id: json.decode(response.body)['name'],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);

      _items.add(newProduct);

      notifyListeners();
      // print(newProduct.id);
    } catch (error) {
      throw error;
    }
  }

  findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final urlString =
          'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token';
      var url = Uri.parse(urlString);
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            "price": newProduct.price,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // print('nadadadadada');
    }
  }

  Future<void> deleteItem(String id) async {
    final UrlString =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token';
    var url = Uri.parse(UrlString);

    final existingItemIndex = _items.indexWhere((element) => element.id == id);
    var existingItem = _items[existingItemIndex];

    _items.removeAt(existingItemIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.add(existingItem);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingItem = null;
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}
