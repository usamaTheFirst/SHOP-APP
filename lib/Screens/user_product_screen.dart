import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/edit_product_screen.dart';
import 'package:shop_app/Widgets/app_drawer.dart';
import 'package:shop_app/Widgets/user_product.dart';
import 'package:shop_app/providers/products.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key key}) : super(key: key);
  static const routeName = '/user-product-screen';
  Future<void> _fresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchFromServer(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      body: FutureBuilder(
        future: _fresh(context),
        builder: (ctx, dataSnapshot) =>
            dataSnapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _fresh(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: productsData.items.length,
                          itemBuilder: (context, index) {
                            return UserProductItem(
                                id: productsData.items[index].id,
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl);
                          },
                        ),
                      ),
                    ),
                  ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
