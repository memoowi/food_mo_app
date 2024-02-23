import 'package:flutter/material.dart';
import 'package:food_mo/models/menu_model.dart';
import 'package:food_mo/providers/order_provider.dart';
import 'package:food_mo/utils/config.dart';
import 'package:provider/provider.dart';

class CheckOutPage extends StatefulWidget {
  final String code;
  final MenuModel menu;
  const CheckOutPage({super.key, required this.code, required this.menu});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  int _totalSum = 0;

  void totalPrice(BuildContext context) {
    int totalSum = 0;
    for (int index = 0;
        index <
            Provider.of<OrderProvider>(context).orderList['menu_id']!.length;
        index++) {
      final int menuId =
          Provider.of<OrderProvider>(context).orderList['menu_id']![index];
      final int quantity =
          Provider.of<OrderProvider>(context).orderList['quantity']![index];

      final item =
          widget.menu.data!.firstWhere((element) => element.id == menuId);
      final price = item.price! * quantity;

      totalSum += price;
    }
    setState(() {
      _totalSum = totalSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    totalPrice(context);
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.black,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Order Summary'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              orderMenu(context),
              SizedBox(height: 20.0),
              orderTotal(),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .submitOrder(context, widget.code);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  side: BorderSide(color: Colors.black),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  surfaceTintColor: Colors.white,
                  minimumSize: Size(double.infinity, 60),
                  elevation: 0.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_checkout),
                    SizedBox(width: 10.0),
                    Text(
                      'confirm'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container orderTotal() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.black,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(width: 10.0),
          Text(
            'Total :',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              'Rp. $_totalSum',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(width: 10.0),
        ],
      ),
    );
  }

  ListView orderMenu(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 14.0),
      itemCount:
          Provider.of<OrderProvider>(context).orderList['menu_id']!.length,
      itemBuilder: (context, index) {
        final item = widget.menu.data!
            .where((element) =>
                element.id ==
                Provider.of<OrderProvider>(context)
                    .orderList['menu_id']![index])
            .first;
        return ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
          ),
          leading: Image.network(
            Config.baseUrl + '/' + item.imageUrl!,
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.error,
            ),
          ),
          title: Text(item.name!.toUpperCase()),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type: ${item.type!.toUpperCase()}',
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price :',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Rp. ${item.price!} / each',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'Quantity: ',
                  ),
                  Expanded(
                    child: Text(
                      Provider.of<OrderProvider>(context)
                              .orderList['menu_id']!
                              .contains(item.id)
                          ? Provider.of<OrderProvider>(context)
                              .orderList['quantity']![
                                  Provider.of<OrderProvider>(context)
                                      .orderList['menu_id']!
                                      .indexOf(item.id)]
                              .toString()
                          : '0',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Rp. ${item.price! * Provider.of<OrderProvider>(context).orderList['quantity']![Provider.of<OrderProvider>(context).orderList['menu_id']!.indexOf(item.id)]}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Check Out'.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      shadowColor: Colors.black54,
      elevation: 5.0,
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
    );
  }
}
