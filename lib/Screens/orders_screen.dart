import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/order_items.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/orders.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  bool loader = false;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    // print('Buildig orders');
    // final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      body: FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchOrdersFromServer(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapShot.error != null) {
              Future(() {
                // Future Callback
                Alert(
                  context: ctx,
                  type: AlertType.error,
                  title: "ERROR",
                  desc: "Something went wrong",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Scaffold.of(ctx).openDrawer();
                      },
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(116, 116, 191, 1.0),
                        Color.fromRGBO(52, 138, 199, 1.0)
                      ]),
                    ),
                  ],
                ).show();
              });
              return Container();
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, index) {
                    return OrderItemWidget(
                      orderItem: orderData.orders[index],
                    );
                  },
                ),
              );
            }
          }
        },
      ),
      drawer: CustomDrawer(),
    );
  }
}
