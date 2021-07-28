import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/Models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoriteOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchFromServer() async {
    const URL_STRING =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';
    var url = Uri.parse(URL_STRING);

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return null;
      }
      final List<Product> loadedProduct = [];
      extractedData.forEach((key, value) {
        loadedProduct.insert(
            0,
            Product(
                id: key,
                isFavorite: value['isFavorite'],
                title: value['title'],
                description: value['description'],
                imageUrl: value['imageUrl'],
                price: value['price']));
      });
      _items = loadedProduct;
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    const URL_STRING =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';
    var url = Uri.parse(URL_STRING);

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            "price": product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          title: product.title,
          id: json.decode(response.body)['name'],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);

      _items.add(newProduct);

      notifyListeners();
      print(newProduct.id);
    } catch (error) {
      throw error;
    }
  }

  findByID(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex > 0) {
      final URL_STRING =
          'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
      var url = Uri.parse(URL_STRING);
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
      print('nadadadadada');
    }
  }

  Future<void> deleteItem(String id) async {
    final URL_STRING =
        'https://shop-app-80dd1-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json';
    var url = Uri.parse(URL_STRING);

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
