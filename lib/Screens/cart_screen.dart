import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/cart_item.dart';
import 'package:shop_app/providers/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      "${cart.totalAmount} USD",
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text("ORDER NOW"))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartItemWidget(
                    id: cart.items.values.toList()[index].id,
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    price: cart.items.values.toList()[index].price);
              },
            ),
          )
        ],
      ),
    );
  }
}