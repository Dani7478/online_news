class User {
  final String email;
  final String username;
  final String password;
  // final int price;
  // final String image;

  static final columns = ["email", "username", "password"];
  User(this.email, this.username, this.password);
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      data['email'],
      data['username'],
      data['password'],
    );
  }
  Map<String, dynamic> toMap() => {
        "email": email,
        "username": username,
        "password": password,
      };
}
