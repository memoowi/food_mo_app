import 'package:flutter/material.dart';
import 'package:food_mo/providers/order_list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderHistoryBox extends StatelessWidget {
  const OrderHistoryBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderListProvider>(context, listen: false)
        .getOrderList(context);
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order History'.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.0),
          Consumer(builder: (context, OrderListProvider provider, child) {
            if (provider.orderList.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 14.0),
                itemCount: provider.orderList.length,
                itemBuilder: (context, index) {
                  final sortedOrderList = List.from(provider.orderList);
                  sortedOrderList
                      .sort((a, b) => b.createdAt.compareTo(a.createdAt));
                  final order = sortedOrderList[index];
                  return orderTile(
                    context,
                    order.id,
                    order.outlet.name,
                    order.createdAt,
                  );
                },
              );
            } else {
              return Container(
                child: Text('No Orders'),
              );
            }
          })
        ],
      ),
    );
  }

  ListTile orderTile(context, orderNumber, outlet, date) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/order_detail', arguments: orderNumber);
      },
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.black,
        ),
      ),
      leading: Icon(Icons.receipt_long),
      title: Text(
        'Order Number: $orderNumber',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Outlet: $outlet'),
          Text(
            'Date: ' + DateFormat('EEE, dd MMM yyyy').format(date),
          ),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
