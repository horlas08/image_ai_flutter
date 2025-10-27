class UserModel {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? avatarUrl;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.avatarUrl,
  });

  String get displayName => (firstName?.isNotEmpty == true || lastName?.isNotEmpty == true)
      ? [firstName, lastName].where((e) => (e ?? '').isNotEmpty).join(' ')
      : (username ?? email ?? '');

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString(),
      email: map['email'] as String?,
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      username: map['username'] as String?,
      avatarUrl: map['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'profile_image': avatarUrl,
    };
  }
}
