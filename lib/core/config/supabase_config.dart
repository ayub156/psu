class SupabaseConfig {
  // Supabase credentials
  static const String url = 'https://ooxojxeiqvasqhyxrdvk.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9veG9qeGVpcXZhc3FoeXhyZHZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5OTM5MjgsImV4cCI6MjA3MjU2OTkyOH0.5bVdcmH_PGZ95_IbHKLYE8xoM-ICNID-t-sr9hOzaBg';

  // Database table names
  static const String teachersTable = 'teachers';
  static const String attendanceTable = 'attendance';
  static const String coursesTable = 'courses';
  static const String studentsTable = 'students';

  // Storage bucket names
  static const String avatarsBucket = 'avatars';
  static const String documentsBucket = 'documents';
}
