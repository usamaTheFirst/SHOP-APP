import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/badge.dart';
import 'package:shop_app/Widgets/products_grid.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';

enum FilterOptions { All, Favorites }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview-screen';

  const ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool initCheck = true;
  bool _showOnlFavorite = false;
  bool loader = false;
  @override
  void initState() {
    ///This wont work
    ///Context is not available here
    ///There are two ways to get around it
    // Provider.of<Products>(context).fetchFromServer();

    ///First one

    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchFromServer();
    // });

    ///This method is just a hack and not advisable
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (initCheck) {
      setState(() {
        loader = true;
      });

      Provider.of<Products>(context).fetchFromServer().then((value) {
        setState(() {
          loader = false;
        });
      });
    }

    initCheck = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              child: ch,
              value: "${cart.length}",
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
          PopupMenuButton(
            // initialValue: FilterOptions.All,
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlFavorite = true;
                } else {
                  _showOnlFavorite = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOptions.All,
                ),
              ];
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
        title: Text("My Shop"),
      ),
      body: loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showOnlFavorite: _showOnlFavorite),
      drawer: CustomDrawer(),
    );
  }
}
