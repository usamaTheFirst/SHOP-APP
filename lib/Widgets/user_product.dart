import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/providers/products.dart';

/// Sometimes context is not available and dart is not sure about and it talks about ancestors so better
/// store it in a variable and use it elsewhere
class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {Key key, @required this.title, @required this.imageUrl, this.id})
      : super(key: key);

  final String title, imageUrl, id;
  @override
  Widget build(BuildContext context) {
    final sccafold = ScaffoldMessenger.of(context);
    final secondScaff = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName,
                  arguments: id);
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteItem(id);
                sccafold.hideCurrentSnackBar();
                sccafold.showSnackBar(SnackBar(
                    content:
                        Text("$title deleted", textAlign: TextAlign.center)));
              } catch (error) {
                sccafold.hideCurrentSnackBar();
                sccafold.showSnackBar(SnackBar(
                    content: Text(
                  "Couldn't delete $title ",
                  textAlign: TextAlign.center,
                )));
                print(error);
                await showDialog(
                  context: secondScaff.context,
                  builder: (context) => AlertDialog(
                    title: Text('An error occurred!'),
                    content: Text(
                      'Something went wrong.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              }
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
