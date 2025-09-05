enum AttendanceStatus {
  present,
  absent;

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
    }
  }

  String get value {
    switch (this) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
    }
  }

  static AttendanceStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      default:
        throw ArgumentError('Invalid attendance status: $value');
    }
  }
}

class Attendance {
  final String id;
  final String teacherId;
  final String studentName;
  final AttendanceStatus status;
  final DateTime timestamp;

  const Attendance({
    required this.id,
    required this.teacherId,
    required this.studentName,
    required this.status,
    required this.timestamp,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as String,
      teacherId: json['teacher_id'] as String,
      studentName: json['student_name'] as String,
      status: AttendanceStatus.fromString(json['status'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'student_name': studentName,
      'status': status.value,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  Attendance copyWith({
    String? id,
    String? teacherId,
    String? studentName,
    AttendanceStatus? status,
    DateTime? timestamp,
  }) {
    return Attendance(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      studentName: studentName ?? this.studentName,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Attendance && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Attendance(id: $id, teacherId: $teacherId, studentName: $studentName, status: $status, timestamp: $timestamp)';
  }
}
