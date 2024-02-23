class OrderListModel {
  String? status;
  List<Data>? data;

  OrderListModel({this.status, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
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

  Data(
      {this.id,
      this.outletId,
      this.userId,
      this.totalPrice,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.outlet});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    outletId = json['outlet_id'];
    userId = json['user_id'];
    totalPrice = json['total_price'];
    status = json['status'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    outlet = json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null;
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
