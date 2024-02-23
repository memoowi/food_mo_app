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
          margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.black,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  'Order Summary'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              orderMenu(context),
              const SizedBox(height: 20.0),
              orderTotal(),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Provider.of<OrderProvider>(context, listen: false)
                      .submitOrder(context, widget.code);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  side: const BorderSide(color: Colors.black),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  surfaceTintColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  elevation: 0.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_checkout),
                    const SizedBox(width: 10.0),
                    Text(
                      'confirm'.toUpperCase(),
                      style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.black,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        children: [
          const SizedBox(width: 10.0),
          const Text(
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
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }

  ListView orderMenu(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 14.0),
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
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
          ),
          leading: Image.network(
            '${Config.baseUrl}/${item.imageUrl!}',
            width: 50.0,
            height: 50.0,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
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
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price :',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Rp. ${item.price!} / each',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Text(
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    'Rp. ${item.price! * Provider.of<OrderProvider>(context).orderList['quantity']![Provider.of<OrderProvider>(context).orderList['menu_id']!.indexOf(item.id)]}',
                    style: const TextStyle(
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
        style: const TextStyle(
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
