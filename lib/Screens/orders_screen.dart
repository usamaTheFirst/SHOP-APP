import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/order_items.dart';
import 'package:shop_app/providers/orders.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key key}) : super(key: key);
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (context, index) {
          return OrderItemWidget(
            orderItem: orders.orders[index],
          );
        },
      ),
      drawer: CustomDrawer(),
    );
  }
}
