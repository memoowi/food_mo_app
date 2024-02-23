class MenuModel {
  String? status;
  List<Data>? data;
  String? message;

  MenuModel({this.status, this.data, this.message});

  MenuModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class Data {
  int? id;
  int? outletId;
  String? name;
  String? imageUrl;
  String? type;
  int? price;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.outletId,
      this.name,
      this.imageUrl,
      this.type,
      this.price,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
