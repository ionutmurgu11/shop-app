import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_Item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtaineOrdersFuture() {
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtaineOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Istoric comenzi'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                //..
                //error handling
                return Center(
                  child: Text('A aparut o eroare.'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) =>
                        (orderData.orders.length == 0)
                            ? Center(
                                child: Text(
                                  'Nu au fost gasite comenzi anterioare.',
                                ),
                              )
                            : ListView.builder(
                                itemCount: orderData.orders.length,
                                itemBuilder: (ctx, i) {
                                  return OrderItem(orderData.orders[i]);
                                }));
              }
            }
          }),
    );
  }
}
