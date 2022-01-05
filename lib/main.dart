import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(),
          update: (ctx, auth, prevProducts) =>
              prevProducts..update(auth.token, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, prevOrders) =>
              prevOrders..update(auth.token, auth.userId),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        ifAuth(targetScreen) => auth.isAuth ? targetScreen : AuthScreen();
        return MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnaphot) => authResultSnaphot
                              .connectionState ==
                          ConnectionState.waiting
                      ? SplashScreen() // enquanto espera o waiting acima, mostra essa
                      : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) =>
                ifAuth(ProductDetailScreen()),
            CartScreen.routeName: (ctx) => ifAuth(CartScreen()),
            OrdersScreen.routeName: (ctx) => ifAuth(OrdersScreen()),
            UserProductsScreen.routeName: (ctx) => ifAuth(UserProductsScreen()),
            EditProductScreen.routeName: (ctx) => ifAuth(EditProductScreen()),
          },
        );
      }),
    );
  }
}
