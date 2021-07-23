import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/product_detail_screen.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id, title, imageUrl;
  // const ProductItem({Key key, this.id, this.title, this.imageUrl})
  //     : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('Product rebuilds');
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, productt, child) => IconButton(
              onPressed: () {
                productt.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              print(product.id);
              cart.addItems(product.id, product.price, product.title);
            },
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.shopping_cart),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            softWrap: true,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
