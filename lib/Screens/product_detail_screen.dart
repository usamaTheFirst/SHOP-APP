import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // const ProductDetailScreen({Key key, this.title}) : super(key: key);
  // final String title;

  static const routeName = '/product_detail';
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
    // final providerData = Provider.of<Products>(context);
    // final product = providerData.items;
    var stuff = Provider.of<Products>(context).findByID(id);

    return Scaffold(
      appBar: AppBar(
        title: Text(stuff.title),
      ),
    );
  }
}
