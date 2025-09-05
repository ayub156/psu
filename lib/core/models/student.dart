class Student {
  final String id;
  final String fullName;
  final String studentId;
  final String? email;
  final String? phoneNumber;
  final String? department;
  final int year;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Student({
    required this.id,
    required this.fullName,
    required this.studentId,
    this.email,
    this.phoneNumber,
    this.department,
    required this.year,
    this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      studentId: json['student_id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      department: json['department'] as String?,
      year: json['year'] as int,
      profilePictureUrl: json['profile_picture_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'student_id': studentId,
      'email': email,
      'phone_number': phoneNumber,
      'department': department,
      'year': year,
      'profile_picture_url': profilePictureUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Student copyWith({
    String? id,
    String? fullName,
    String? studentId,
    String? email,
    String? phoneNumber,
    String? department,
    int? year,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      year: year ?? this.year,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, fullName: $fullName, studentId: $studentId, email: $email, phoneNumber: $phoneNumber, department: $department, year: $year, profilePictureUrl: $profilePictureUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.fullName == fullName &&
        other.studentId == studentId &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.department == department &&
        other.year == year &&
        other.profilePictureUrl == profilePictureUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        studentId.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        department.hashCode ^
        year.hashCode ^
        profilePictureUrl.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
