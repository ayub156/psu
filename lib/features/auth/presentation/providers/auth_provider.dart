import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/teacher.dart';

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((data) => data.session?.user);
});

// Current teacher provider
final currentTeacherProvider = FutureProvider<Teacher?>((ref) async {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      try {
        return await SupabaseService.getTeacher(user.id);
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth controller provider
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref);
});

class AuthController {
  final Ref ref;

  AuthController(this.ref);

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String teacherId,
    String? fullName,
    String? email,
  }) async {
    try {
      await SupabaseService.updateTeacher(
        teacherId: teacherId,
        fullName: fullName,
        email: email,
      );
      
      // Refresh the current teacher data
      ref.invalidate(currentTeacherProvider);
    } catch (e) {
      rethrow;
    }
  }
}
