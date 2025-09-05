# PSU Attendance - Teacher Management System

A Flutter mobile application for Puntland State University (PSU) focused on teacher attendance management.

## 🎯 Features

- **Teacher Authentication**: Secure registration and login system
- **Attendance Management**: Mark student attendance (Present/Absent)
- **Real-time Updates**: Live attendance tracking with Supabase
- **Profile Management**: Update teacher information
- **Modern UI**: Material Design 3 with smooth animations
- **Responsive Design**: Works on all screen sizes

## 📱 Screens

1. **Splash Screen** - App logo with loading animation
2. **Register Screen** - Teacher registration with validation
3. **Login Screen** - Secure authentication
4. **Dashboard Screen** - Overview and quick actions
5. **Attendance Screen** - Mark and manage student attendance
6. **Profile Screen** - Manage teacher profile and settings

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (Auth, Realtime DB, Postgres)
- **State Management**: Riverpod
- **UI Framework**: Material Design 3
- **Navigation**: GoRouter

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Supabase account
- Android Studio / VS Code with Flutter extensions

### Setup Instructions

#### 1. Clone the Repository

```bash
git clone <repository-url>
cd attendance
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Supabase Setup

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Settings > API to get your project URL and anon key
3. Run the SQL schema from `database_schema.sql` in your Supabase SQL Editor
4. Update `lib/core/config/supabase_config.dart` with your credentials:

```dart
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

#### 4. Configure Authentication

In your Supabase dashboard:
1. Go to Authentication > Settings
2. Disable email confirmations (since we're using phone numbers)
3. Enable phone number authentication if needed

#### 5. Run the App

```bash
flutter run
```

## 📊 Database Schema

### Teachers Table
- `id` (UUID, Primary Key) - References auth.users
- `full_name` (TEXT) - Teacher's full name
- `phone_number` (TEXT, Unique) - Teacher's phone number
- `created_at` (TIMESTAMP) - Account creation time
- `updated_at` (TIMESTAMP) - Last update time

### Attendance Table
- `id` (UUID, Primary Key) - Unique attendance record ID
- `teacher_id` (UUID) - References teachers.id
- `student_name` (TEXT) - Name of the student
- `status` (ENUM) - 'present' or 'absent'
- `timestamp` (TIMESTAMP) - When attendance was marked

## 🔐 Security Features

- Row Level Security (RLS) enabled on all tables
- Teachers can only access their own data
- Secure authentication with Supabase Auth
- Input validation and sanitization

## 🎨 UI/UX Features

- Material Design 3 components
- Smooth animations and transitions
- Responsive design for all screen sizes
- Dark/Light theme support
- Intuitive navigation with bottom navigation bar

## 📱 App Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── models/          # Data models
│   ├── services/        # Backend services
│   ├── router/          # Navigation routing
│   └── theme/           # App theming
├── features/
│   ├── auth/            # Authentication feature
│   ├── dashboard/       # Dashboard feature
│   ├── attendance/      # Attendance management
│   ├── profile/         # Profile management
│   └── splash/          # Splash screen
└── main.dart           # App entry point
```

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Version History

- **v1.0.0** - Initial release with core features
  - Teacher authentication
  - Attendance management
  - Profile management
  - Real-time updates

---

**Built with ❤️ for Puntland State University**
