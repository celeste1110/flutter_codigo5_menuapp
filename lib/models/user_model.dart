
class UserModel {
  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
  });

  String? id;
  String fullName;
  String email;
  String role;
  bool status;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    fullName: json["full_name"],
    email: json["email"],
    role: json["role"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "email": email,
    "role": role,
    "status": status,
  };
}
