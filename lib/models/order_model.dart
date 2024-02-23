class OrderModel {
  String? status;
  Data? data;

  OrderModel({this.status, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  int? outletId;
  int? userId;
  int? totalPrice;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Outlet? outlet;
  List<Orders>? orders;

  Data(
      {this.id,
      this.outletId,
      this.userId,
      this.totalPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.outlet,
      this.orders});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outletId = json['outlet_id'];
    userId = json['user_id'];
    totalPrice = json['total_price'];
    status = json['status'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    outlet = json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null;
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }
}

class Outlet {
  int? id;
  String? name;
  String? address;
  String? phone;
  String? code;
  String? openTime;
  String? closeTime;
  String? createdAt;
  String? updatedAt;

  Outlet(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.code,
      this.openTime,
      this.closeTime,
      this.createdAt,
      this.updatedAt});

  Outlet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    code = json['code'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class Orders {
  int? id;
  int? menuId;
  int? transactionId;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  Menu? menu;

  Orders(
      {this.id,
      this.menuId,
      this.transactionId,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.menu});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    menuId = json['menu_id'];
    transactionId = json['transaction_id'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    menu = json['menu'] != null ? Menu.fromJson(json['menu']) : null;
  }
}

class Menu {
  int? id;
  int? outletId;
  String? name;
  String? imageUrl;
  String? type;
  int? price;
  String? createdAt;
  String? updatedAt;

  Menu(
      {this.id,
      this.outletId,
      this.name,
      this.imageUrl,
      this.type,
      this.price,
      this.createdAt,
      this.updatedAt});

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outletId = json['outlet_id'];
    name = json['name'];
    imageUrl = json['image_url'];
    type = json['type'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
