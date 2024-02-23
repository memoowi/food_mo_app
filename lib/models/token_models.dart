class TokenModel {
  String? status;
  Data? data;
  String? token;
  String? message;

  TokenModel({this.status, this.data, this.token, this.message});

  TokenModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    token = json['token'];
    message = json['message'];
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? username;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.name,
      this.email,
      this.username,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
