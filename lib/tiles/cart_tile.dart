import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/models/cart_model.dart';

import '../datas/cart_product.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  const CartTile({super.key, required this.cartProduct});

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8),
            width: 140,
            height: 100,
            child: Image.network(
              cartProduct.productData!.images?[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartProduct.productData!.title ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData!.price?.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: cartProduct.quantity > 1
                            ? () {
                                CartModel.of(context).decProduct(cartProduct);
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(cartProduct.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                        icon: const Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                      ),
                      TextButton(
                          onPressed: () {
                            CartModel.of(context).removeCartItem(cartProduct);
                          },
                          child: Text(
                            "Remover",
                            style: TextStyle(color: Colors.grey[500]),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("products")
                    .doc(cartProduct.category)
                    .collection("items")
                    .doc(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 70,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }
                })
            : _buildContent());
  }
}
