import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {Key key,
      @required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price})
      : super(key: key);
  final String id, title;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Text("\$$price"),
            ),
            title: Text(title),
            subtitle:
                Text("Total : \$${(price * quantity).toStringAsFixed(2)}"),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
