class OutletModel {
  String? status;
  Data? data;
  String? message;

  OutletModel({this.status, this.data, this.message});

  OutletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
}

class Data {
  int? id;
  String? name;
  String? address;
  String? phone;
  String? code;
  String? openTime;
  String? closeTime;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.code,
      this.openTime,
      this.closeTime,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
