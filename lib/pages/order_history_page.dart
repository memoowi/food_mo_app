import 'package:flutter/material.dart';
import 'package:food_mo/providers/auth_provider.dart';
import 'package:food_mo/providers/order_provider.dart';
import 'package:food_mo/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatelessWidget {
  final int id;
  const OrderHistoryPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Number : $id'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false)
            .getOrder(context, id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final order = snapshot.data!;
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Number: ${order.data!.id}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          DateFormat('EEE, dd MMM yyyy').format(
                            order.data!.createdAt!,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Customer Name: ${Provider.of<AuthProvider>(context).user?.name}',
                    ),
                    Text(
                      'Order Status: ${order.data!.status!.toUpperCase()}',
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Outlet Details',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${order.data!.outlet!.name}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${order.data!.outlet!.address}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${order.data!.outlet!.phone}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${order.data!.outlet!.code}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        'Order Details',
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.0),
                      itemCount: order.data!.orders!.length,
                      itemBuilder: (context, index) {
                        final item = order.data!.orders![index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                          ),
                          leading: Image.network(
                            Config.baseUrl + '/' + item.menu!.imageUrl!,
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.error,
                            ),
                          ),
                          title: Text(item.menu!.name!.toUpperCase()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type: ${item.menu!.type!.toUpperCase()}',
                              ),
                              Text(
                                'Quantity: ${item.quantity}',
                              ),
                              Text(
                                'Price: Rp. ${item.menu!.price} / each',
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sum :',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Rp. ${item.menu!.price! * item.quantity!}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Rp. ${order.data!.totalPrice}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Text('No order found'),
            );
          }
        },
      ),
    );
  }
}
