class UserDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  UserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  // Convert UserDetails object to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }

  // Create a UserDetails object from a Map (database query)
  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
