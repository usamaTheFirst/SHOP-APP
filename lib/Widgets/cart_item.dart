import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget(
      {Key key,
      @required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.productID})
      : super(key: key);
  final String id, title, productID;
  final int quantity;
  final double price;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Dismissible(
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to remove the item from the cart"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No")),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'))
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) {
        cart.deleteItem(productID);
      },
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Text("\$${price.toStringAsFixed(2)}"),
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
