import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
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
    var stuff = Provider.of<Products>(context).findByID(id) as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(stuff.title),
              background: Hero(
                tag: id,
                child: Image.network(
                  stuff.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              '\$ ${stuff.price}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                '${stuff.description}',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            SizedBox(
              height: 800,
            )
          ]))
        ],
      ),
    );
  }
}
