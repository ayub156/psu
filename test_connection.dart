import 'package:supabase_flutter/supabase_flutter.dart';

// This is a test file, so print statements are acceptable

// Supabase configuration
const String supabaseUrl = 'https://ooxojxeiqvasqhyxrdvk.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9veG9qeGVpcXZhc3FoeXhyZHZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5OTM5MjgsImV4cCI6MjA3MjU2OTkyOH0.5bVdcmH_PGZ95_IbHKLYE8xoM-ICNID-t-sr9hOzaBg';

void main() async {
  print('🔍 Testing Supabase Connection...\n');

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    print('✅ Supabase initialized successfully');
    
    final client = Supabase.instance.client;
    print('✅ Supabase client created');

    // Test connection by checking if we can access the database
    try {
      await client.from('teachers').select('count').limit(1);
      print('✅ Database connection successful');
      print('📊 Teachers table accessible');
    } catch (e) {
      print('❌ Database connection failed: $e');
      print('\n🔧 This suggests the database tables may not be created yet.');
      print('📋 Please run the SQL code from FINAL_SOLUTION.md');
      return;
    }

    // Test authentication
    try {
      print('\n🧪 Testing authentication...');
      
      // Try to sign up a test user
      final signUpResponse = await client.auth.signUp(
        email: 'test123@example.com',
        password: 'testpassword123',
        data: {
          'full_name': 'Test Teacher',
          'email': 'test123@example.com',
        },
      );

      if (signUpResponse.user != null) {
        print('✅ User registration successful');
        print('👤 User ID: ${signUpResponse.user!.id}');
        
        // Check if teacher record was created
        try {
          final teacherResponse = await client
              .from('teachers')
              .select()
              .eq('id', signUpResponse.user!.id)
              .single();
          
          print('✅ Teacher record created automatically');
          print('📝 Teacher Name: ${teacherResponse['full_name']}');
          print('📧 Email: ${teacherResponse['email']}');
        } catch (e) {
          print('❌ Teacher record not found: $e');
          print('🔧 This suggests the database trigger may not be working');
        }
        
        // Clean up - delete the test user
        await client.auth.signOut();
        print('🧹 Test user cleaned up');
      } else {
        print('❌ User registration failed');
        print('📧 Response: ${signUpResponse.session}');
      }
      
    } catch (e) {
      print('❌ Authentication test failed: $e');
    }

  } catch (e) {
    print('❌ Supabase initialization failed: $e');
  }

  print('\n🏁 Test completed');
}
