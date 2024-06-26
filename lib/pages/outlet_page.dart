import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_mo/models/menu_model.dart';
import 'package:food_mo/models/outlet_model.dart';
import 'package:food_mo/providers/order_provider.dart';
import 'package:food_mo/utils/config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OutletPage extends StatefulWidget {
  final OutletModel outlet;
  final MenuModel menu;
  const OutletPage({super.key, required this.outlet, required this.menu});

  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  OrderProvider? _orderProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderProvider = Provider.of<OrderProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
    _orderProvider?.clearOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.outlet.data!.name!),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 30.0,
            right: 30.0,
            top: 20.0,
            bottom: 150.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.outlet.data!.name!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Address: ${widget.outlet.data!.address!}',
              ),
              Text(
                'Phone: ${widget.outlet.data!.phone!}',
              ),
              Text(
                'Code: ${widget.outlet.data!.code!}',
              ),
              const SizedBox(height: 10.0),
              timeBox(),
              const SizedBox(height: 30.0),
              Text(
                'Food List'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10.0),
              menuList('food'),
              const SizedBox(height: 20.0),
              Text(
                'Beverage List'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10.0),
              menuList('beverage'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_orderProvider!.orderList['menu_id']!.isNotEmpty) {
            Navigator.pushNamed(context, '/check_out', arguments: {
              'code': widget.outlet.data!.code!,
              'menu': widget.menu,
            });
          }
        },
        icon: const Icon(Icons.shopping_bag),
        label: Text(
          'Order'.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }

  ListView menuList(type) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 14.0),
      itemCount:
          widget.menu.data!.where((element) => element.type == type).length,
      itemBuilder: (context, index) {
        final List foodItems =
            widget.menu.data!.where((element) => element.type == type).toList();
        final item = foodItems[index];
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
                      'Rp. ${item.price!}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  IconButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .removeOrder(item.id);
                    },
                    tooltip: 'clear',
                    icon: const Icon(Icons.clear),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .decrementOrder(item.id);
                    },
                    tooltip: 'remove',
                    icon: const Icon(Icons.remove),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .incrementOrder(item.id);
                    },
                    tooltip: 'add',
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
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

  Row timeBox() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.clock,
                  size: 30.0,
                ),
                const SizedBox(width: 10.0),
                Text(
                  DateFormat('hh:mm a').format(DateTime.parse(
                      '2000-01-01 ${widget.outlet.data!.openTime!}')),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.clock_fill,
                  size: 30.0,
                  color: Colors.white,
                ),
                const SizedBox(width: 10.0),
                Text(
                  DateFormat('hh:mm a').format(DateTime.parse(
                      '2000-01-01 ${widget.outlet.data!.closeTime!}')),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
