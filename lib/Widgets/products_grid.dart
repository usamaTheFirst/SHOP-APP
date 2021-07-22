import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/Widgets/product_item.dart';
import 'package:shop_app/providers/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showOnlFavorite;

  const ProductGrid({Key key, this.showOnlFavorite}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(showOnlFavorite);
    final productsData = Provider.of<Products>(context);

    final products =
        showOnlFavorite ? productsData.favoriteItems : productsData.items;
    print(products);

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),

      ///We are wrapping each Product Item with unique Provider(product[index]) so that
      ///upon creation the new widget can only access content of that particular provider
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // create: (context) => products[index],
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
