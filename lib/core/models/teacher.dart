class Teacher {
  final String id;
  final String fullName;
  final String email;
  final String? profilePictureUrl;
  final String? department;
  final String? position;
  final String? phoneNumber;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  Teacher({
    required this.id,
    required this.fullName,
    required this.email,
    this.profilePictureUrl,
    this.department,
    this.position,
    this.phoneNumber,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profile_picture_url'] as String?,
      department: json['department'] as String?,
      position: json['position'] as String?,
      phoneNumber: json['phone_number'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'department': department,
      'position': position,
      'phone_number': phoneNumber,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Teacher copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profilePictureUrl,
    String? department,
    String? position,
    String? phoneNumber,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      department: department ?? this.department,
      position: position ?? this.position,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Teacher(id: $id, fullName: $fullName, email: $email, profilePictureUrl: $profilePictureUrl, department: $department, position: $position, phoneNumber: $phoneNumber, bio: $bio, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teacher &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.profilePictureUrl == profilePictureUrl &&
        other.department == department &&
        other.position == position &&
        other.phoneNumber == phoneNumber &&
        other.bio == bio &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        profilePictureUrl.hashCode ^
        department.hashCode ^
        position.hashCode ^
        phoneNumber.hashCode ^
        bio.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
