import 'package:flutter/foundation.dart';

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
    return [...orders];
  }

  void addOrder(List<cartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
