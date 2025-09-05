import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../config/supabase_config.dart';
import '../models/teacher.dart';
import '../models/attendance.dart';
import '../models/course.dart';
import '../models/student.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;
  static final ImagePicker _imagePicker = ImagePicker();

  // Authentication methods
  static Future<AuthResponse> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'email': email,
        },
      );

      // Ensure teacher record is created
      if (response.user != null) {
        await _ensureTeacherRecord(response.user!.id, fullName, email);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Ensure teacher record exists after sign in
      if (response.user != null) {
        await _ensureTeacherRecord(response.user!.id, '', email);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  static User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  // Helper method to ensure teacher record exists
  static Future<void> _ensureTeacherRecord(String userId, String fullName, String email) async {
    try {
      // Check if teacher record exists
      final existingTeacher = await _client
          .from(SupabaseConfig.teachersTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (existingTeacher == null) {
        // Create teacher record if it doesn't exist
        await _client.from(SupabaseConfig.teachersTable).insert({
          'id': userId,
          'full_name': fullName.isNotEmpty ? fullName : 'Teacher',
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      // Log error but don't throw - this is a fallback mechanism
      // Warning: Could not ensure teacher record: $e
    }
  }

  // Teacher methods
  static Future<Teacher> getTeacher(String teacherId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.teachersTable)
          .select()
          .eq('id', teacherId)
          .single();

      return Teacher.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get teacher: $e');
    }
  }

  static Future<Teacher> updateTeacher({
    required String teacherId,
    String? fullName,
    String? email,
    String? department,
    String? position,
    String? phoneNumber,
    String? bio,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (email != null) updateData['email'] = email;
      if (department != null) updateData['department'] = department;
      if (position != null) updateData['position'] = position;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (bio != null) updateData['bio'] = bio;

      final response = await _client
          .from(SupabaseConfig.teachersTable)
          .update(updateData)
          .eq('id', teacherId)
          .select()
          .single();

      return Teacher.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update teacher: $e');
    }
  }

  // Profile Picture methods
  static Future<String> uploadProfilePicture(String teacherId, File imageFile) async {
    try {
      final fileName = 'profile_$teacherId.jpg';
      final filePath = 'profiles/$fileName';
      
      await _client.storage
          .from('avatars')
          .upload(filePath, imageFile, fileOptions: const FileOptions(upsert: true));
      
      final imageUrl = _client.storage
          .from('avatars')
          .getPublicUrl(filePath);
      
      // Update teacher record with new profile picture URL
      await _client
          .from(SupabaseConfig.teachersTable)
          .update({
            'profile_picture_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', teacherId);
      
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  static Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      return image != null ? File(image.path) : null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  // Course methods
  static Future<List<Course>> getTeacherCourses(String teacherId) async {
    try {
      final response = await _client
          .from('courses')
          .select()
          .eq('teacher_id', teacherId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Course.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  static Future<Course> createCourse({
    required String name,
    required String code,
    required String teacherId,
    String? description,
    required int credits,
    required String semester,
    required int academicYear,
  }) async {
    try {
      final response = await _client
          .from('courses')
          .insert({
            'name': name,
            'code': code,
            'teacher_id': teacherId,
            'description': description,
            'credits': credits,
            'semester': semester,
            'academic_year': academicYear,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Course.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  static Future<Course> updateCourse({
    required String courseId,
    String? name,
    String? code,
    String? description,
    int? credits,
    String? semester,
    int? academicYear,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (name != null) updateData['name'] = name;
      if (code != null) updateData['code'] = code;
      if (description != null) updateData['description'] = description;
      if (credits != null) updateData['credits'] = credits;
      if (semester != null) updateData['semester'] = semester;
      if (academicYear != null) updateData['academic_year'] = academicYear;

      final response = await _client
          .from('courses')
          .update(updateData)
          .eq('id', courseId)
          .select()
          .single();

      return Course.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  static Future<void> deleteCourse(String courseId) async {
    try {
      await _client
          .from('courses')
          .delete()
          .eq('id', courseId);
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  // Student methods
  static Future<List<Student>> getStudents() async {
    try {
      final response = await _client
          .from('students')
          .select()
          .order('full_name', ascending: true);

      return (response as List)
          .map((json) => Student.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get students: $e');
    }
  }

  static Future<Student> createStudent({
    required String fullName,
    required String studentId,
    String? email,
    String? phoneNumber,
    String? department,
    required int year,
  }) async {
    try {
      final response = await _client
          .from('students')
          .insert({
            'full_name': fullName,
            'student_id': studentId,
            'email': email,
            'phone_number': phoneNumber,
            'department': department,
            'year': year,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Student.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create student: $e');
    }
  }

  // Attendance methods
  static Future<List<Attendance>> getAttendanceRecords(String teacherId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.attendanceTable)
          .select()
          .eq('teacher_id', teacherId)
          .order('timestamp', ascending: false);

      return (response as List)
          .map((json) => Attendance.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get attendance records: $e');
    }
  }

  static Future<Attendance> createAttendanceRecord({
    required String teacherId,
    required String studentName,
    required AttendanceStatus status,
    String? courseId,
  }) async {
    try {
      final response = await _client
          .from(SupabaseConfig.attendanceTable)
          .insert({
            'teacher_id': teacherId,
            'student_name': studentName,
            'status': status.value,
            'course_id': courseId,
            'timestamp': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Attendance.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create attendance record: $e');
    }
  }

  static Future<Attendance> updateAttendanceRecord({
    required String attendanceId,
    required AttendanceStatus status,
  }) async {
    try {
      final response = await _client
          .from(SupabaseConfig.attendanceTable)
          .update({
            'status': status.value,
            'timestamp': DateTime.now().toIso8601String(),
          })
          .eq('id', attendanceId)
          .select()
          .single();

      return Attendance.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update attendance record: $e');
    }
  }

  static Future<void> deleteAttendanceRecord(String attendanceId) async {
    try {
      await _client
          .from(SupabaseConfig.attendanceTable)
          .delete()
          .eq('id', attendanceId);
    } catch (e) {
      throw Exception('Failed to delete attendance record: $e');
    }
  }

  // Analytics methods
  static Future<Map<String, dynamic>> getAttendanceAnalytics(String teacherId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.attendanceTable)
          .select('status, timestamp')
          .eq('teacher_id', teacherId);

      final records = response as List;
      final totalRecords = records.length;
      final presentRecords = records.where((r) => r['status'] == 'present').length;
      final absentRecords = records.where((r) => r['status'] == 'absent').length;

      return {
        'total': totalRecords,
        'present': presentRecords,
        'absent': absentRecords,
        'attendanceRate': totalRecords > 0 ? (presentRecords / totalRecords * 100).roundToDouble() : 0.0,
      };
    } catch (e) {
      throw Exception('Failed to get attendance analytics: $e');
    }
  }

  // Real-time subscriptions
  static RealtimeChannel subscribeToAttendance(String teacherId) {
    return _client
        .channel('attendance_$teacherId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: SupabaseConfig.attendanceTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'teacher_id',
            value: teacherId,
          ),
          callback: (payload) {
            // Handle real-time updates
            // print('Attendance update: $payload');
          },
        )
        .subscribe();
  }

  static Future<void> unsubscribeFromAttendance(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }
}
