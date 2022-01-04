import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<cartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<cartItem> cartProducts, double total) async {
    final url =
        Uri.https('shop-app-747bd-default-rtdb.firebaseio.com', 'orders.json');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'amount': total.toStringAsFixed(2),
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title:': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price.toStringAsFixed(2),
                  })
              .toList(),
        }),
      );
      final newOrder = OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
