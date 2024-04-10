class User {
 String email;
String name;
  String password;

User({
  required this.email,
   required this.name,
  required this.password,
});
factory User.fromJson(
Map<String, dynamic> json) {
  return User(
  email: json['email'],
       name: json['name'],
  password: json['password'],
);
 }
}