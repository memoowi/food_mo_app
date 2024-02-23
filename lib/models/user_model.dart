class UserModel {
  int? id;
  String? name;
  String? email;
  String? username;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.username,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
