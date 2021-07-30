import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/auth_screen.dart';
import 'package:shop_app/Screens/cart_screen.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Screens/loading_screen.dart';
import 'package:shop_app/Screens/orders_screen.dart';
import 'package:shop_app/Screens/product_detail_screen.dart';
import 'package:shop_app/Screens/user_product_screen.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';

import 'Screens/prodcts_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products('', [], ''),
              update: (context, auth, previousProduct) => Products(
                  auth.token,
                  previousProduct == null ? [] : previousProduct.items,
                  auth.userID)),
          ChangeNotifierProxyProvider<Auth, Orders>(
              update: (context, auth, previousOrders) => Orders(
                  previousOrders == null ? [] : previousOrders.orders,
                  token: auth.token,
                  userId: auth.userID)),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple, accentColor: Colors.deepOrange),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogIn(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? LoadingScreen()
                            : AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrderScreen.routeName: (_) => OrderScreen(),
              UserProductScreen.routeName: (_) => UserProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
              AuthScreen.routeName: (_) => AuthScreen(),
              ProductsOverviewScreen.routeName: (_) => ProductDetailScreen()
            },
          ),
        ));
  }
}
