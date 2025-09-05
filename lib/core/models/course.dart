class Course {
  final String id;
  final String name;
  final String code;
  final String teacherId;
  final String? description;
  final int credits;
  final String semester;
  final int academicYear;
  final DateTime createdAt;
  final DateTime updatedAt;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.teacherId,
    this.description,
    required this.credits,
    required this.semester,
    required this.academicYear,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      teacherId: json['teacher_id'] as String,
      description: json['description'] as String?,
      credits: json['credits'] as int,
      semester: json['semester'] as String,
      academicYear: json['academic_year'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'teacher_id': teacherId,
      'description': description,
      'credits': credits,
      'semester': semester,
      'academic_year': academicYear,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Course copyWith({
    String? id,
    String? name,
    String? code,
    String? teacherId,
    String? description,
    int? credits,
    String? semester,
    int? academicYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      teacherId: teacherId ?? this.teacherId,
      description: description ?? this.description,
      credits: credits ?? this.credits,
      semester: semester ?? this.semester,
      academicYear: academicYear ?? this.academicYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Course(id: $id, name: $name, code: $code, teacherId: $teacherId, description: $description, credits: $credits, semester: $semester, academicYear: $academicYear, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.teacherId == teacherId &&
        other.description == description &&
        other.credits == credits &&
        other.semester == semester &&
        other.academicYear == academicYear &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        teacherId.hashCode ^
        description.hashCode ^
        credits.hashCode ^
        semester.hashCode ^
        academicYear.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
