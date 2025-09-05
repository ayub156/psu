# PSU Attendance App - Setup Guide

## Quick Setup Checklist

### 1. Flutter Environment
- [ ] Install Flutter SDK (>=3.0.0)
- [ ] Install Dart SDK (>=3.0.0)
- [ ] Verify installation: `flutter doctor`

### 2. Supabase Configuration
- [ ] Create Supabase account at [supabase.com](https://supabase.com)
- [ ] Create new project
- [ ] Get project URL and anon key from Settings > API
- [ ] Update `lib/core/config/supabase_config.dart` with your credentials

### 3. Database Setup
- [ ] Open Supabase SQL Editor
- [ ] Run the SQL from `database_schema.sql`
- [ ] Verify tables are created: `teachers` and `attendance`

### 4. Authentication Setup
- [ ] Go to Authentication > Settings in Supabase
- [ ] Disable email confirmations
- [ ] Enable phone number authentication (optional)

### 5. Run the App
- [ ] Install dependencies: `flutter pub get`
- [ ] Run on device/emulator: `flutter run`

## Configuration Files to Update

### Supabase Config
```dart
// lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL_HERE';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
}
```

## Testing the App

1. **Register a new teacher account**
2. **Login with the created account**
3. **Mark student attendance**
4. **Update profile information**
5. **Test real-time updates**

## Troubleshooting

### Common Issues

1. **Supabase connection error**
   - Check your URL and anon key
   - Verify your Supabase project is active

2. **Authentication issues**
   - Ensure RLS policies are properly set up
   - Check if email confirmations are disabled

3. **Build errors**
   - Run `flutter clean` then `flutter pub get`
   - Check Flutter and Dart versions

4. **Database errors**
   - Verify the SQL schema was run correctly
   - Check table permissions in Supabase

## Next Steps

1. Customize the app theme and colors
2. Add more validation rules
3. Implement additional features
4. Deploy to app stores

## Support

If you encounter any issues:
1. Check the README.md for detailed instructions
2. Review the database_schema.sql file
3. Verify all configuration files are updated
4. Check Flutter and Supabase documentation
