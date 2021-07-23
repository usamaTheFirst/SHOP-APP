import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({Key key, this.orderItem}) : super(key: key);

  final OrderItem orderItem;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              '\$${orderItem.amount}',
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              DateFormat(
                'dd/MM/yyyy hh:mm',
              ).format(orderItem.dateTime).toString(),
              style: TextStyle(color: Colors.black87),
            ),
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: min(orderItem.products.length * 20.0 + 10, 180),
                child: ListView.builder(
                  itemCount: orderItem.products.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          orderItem.products[index].title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${orderItem.products[index].quantity}x \$${orderItem.products[index].price}",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
