import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/constants/constant.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product-screen';

  const EditProductScreen({Key key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final imageUrlController = TextEditingController();
  final imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool isInit = true;
  var _editedProduct =
      Product(id: null, title: "", description: '', imageUrl: '', price: 0);
  var _initialValues = {
    'title': '',
    "description": '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void didChangeDependencies() {
    if (isInit) {
      var id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findByID(id);
        _initialValues['price'] = _editedProduct.price.toString();
        _initialValues['description'] = _editedProduct.description;
        _initialValues['imageUrl'] = '';
        _initialValues['title'] = _editedProduct.title;
        imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageFocusNode.removeListener(_updateImageUrl);
    imageFocusNode.dispose();
    imageUrlController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!imageFocusNode.hasFocus) {
      if (imageUrlController.text.isEmpty ||
          (!imageUrlController.text.startsWith('http') &&
              !imageUrlController.text.startsWith('https'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      print("EDITING");
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      print("ADDING");
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initialValues['title'],
                validator: (value) {
                  if (value.isEmpty)
                    return 'Please enter a title';
                  else
                    return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: value,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: kTextInputDecoration,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _initialValues['price'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  } else if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  } else if (double.parse(value) < 0) {
                    return ' Please enter a number greater than 0';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(value));
                },
                decoration: kTextInputDecoration.copyWith(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _initialValues['description'],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description';
                  } else if (value.length < 10) {
                    return "length must be greater than 10";
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price);
                },
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.start,
                decoration: kTextInputDecoration.copyWith(
                  labelText: 'Description',
                ),
                minLines: 3,
                maxLines: 5,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple)),
                    child: imageUrlController.text.isEmpty
                        ? Center(child: Text("Enter a URL"))
                        : FittedBox(
                            child: Image.network(
                              imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter url';
                        } else if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter a valid url';
                        } else {
                          return null;
                        }
                      },

                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value,
                            price: _editedProduct.price);
                      },
                      focusNode: imageFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      // onEditingComplete: () => _saveForm,
                      controller: imageUrlController,
                      textAlign: TextAlign.start,
                      decoration: kTextInputDecoration.copyWith(
                        labelText: 'image url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
