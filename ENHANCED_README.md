# 🎓 PSU Attendance - Enhanced Teacher Management System

A comprehensive Flutter mobile application for Puntland State University (PSU) designed to streamline teacher attendance management with advanced features and professional UI.

## ✨ Enhanced Features

### 🎯 **Core Features**
- **Secure Authentication**: Email-based login with Supabase Auth
- **Profile Management**: Complete teacher profiles with photo upload
- **Attendance Tracking**: Real-time student attendance marking
- **Course Management**: Create and manage academic courses
- **Student Registry**: Comprehensive student database
- **Analytics Dashboard**: Detailed attendance reports and insights

### 🖼️ **Profile Picture System**
- **Camera Integration**: Take photos directly within the app
- **Gallery Selection**: Choose existing photos from device
- **Cloud Storage**: Automatic upload to Supabase Storage
- **Cached Images**: Fast loading with offline support

### 📊 **Advanced Analytics**
- **Real-time Statistics**: Live attendance rates and trends
- **Visual Reports**: Interactive charts and graphs
- **Performance Metrics**: Teacher and course performance tracking
- **Export Capabilities**: Generate and share reports

### 📚 **Course Management**
- **Course Creation**: Add new courses with detailed information
- **Semester Tracking**: Organize by Fall, Spring, Summer
- **Credit System**: Academic credit management
- **Course Analytics**: Individual course performance metrics

### 👥 **Student Management**
- **Student Registry**: Complete student database
- **Department Organization**: Organize by academic departments
- **Year Tracking**: Track student academic progress
- **Profile Pictures**: Student photo management

## 🎨 **Professional UI/UX Design**

### **Modern Design Language**
- **Material Design 3**: Latest Google design principles
- **Custom Theming**: PSU-branded color scheme
- **Responsive Layout**: Optimized for all screen sizes
- **Smooth Animations**: Professional transitions and effects

### **Enhanced Navigation**
- **Bottom Navigation**: Intuitive 4-tab navigation
- **Sliver App Bars**: Collapsible headers with profile integration
- **Card-based Layout**: Clean, organized information display
- **Gradient Backgrounds**: Modern visual appeal

### **Interactive Elements**
- **Floating Action Buttons**: Quick access to key features
- **Pull-to-Refresh**: Real-time data updates
- **Swipe Actions**: Quick attendance marking
- **Search & Filter**: Advanced data filtering capabilities

## 🛠️ **Technical Stack**

### **Frontend**
- **Flutter 3.0+**: Cross-platform mobile development
- **Dart**: Modern programming language
- **Riverpod**: State management solution
- **GoRouter**: Advanced navigation system

### **Backend & Database**
- **Supabase**: Complete backend-as-a-service
- **PostgreSQL**: Robust relational database
- **Real-time Subscriptions**: Live data synchronization
- **Row Level Security**: Advanced data protection

### **Additional Libraries**
- **Image Picker**: Camera and gallery integration
- **Cached Network Image**: Optimized image loading
- **File Picker**: Document management
- **URL Launcher**: External link handling
- **Share Plus**: Social sharing capabilities
- **Local Notifications**: Push notification system

## 📱 **App Screens**

### **1. Splash Screen**
- Animated PSU logo with loading indicators
- Smooth transition to authentication

### **2. Authentication Screens**
- **Login**: Email and password authentication
- **Registration**: Complete teacher registration
- **Password Recovery**: Secure password reset

### **3. Enhanced Dashboard**
- **Profile Header**: Teacher photo and welcome message
- **Analytics Cards**: Real-time attendance statistics
- **Quick Actions**: Grid-based feature access
- **Recent Activity**: Latest app interactions
- **Teacher Info**: Complete profile overview

### **4. Profile Management**
- **Photo Upload**: Camera and gallery integration
- **Personal Information**: Name, email, phone
- **Professional Details**: Department, position, bio
- **Edit Mode**: Inline editing with validation

### **5. Attendance Tracking**
- **Course Selection**: Choose specific courses
- **Student List**: Organized student database
- **Quick Marking**: Swipe-based attendance marking
- **Real-time Updates**: Live data synchronization

### **6. Course Management**
- **Course List**: All teacher courses
- **Course Creation**: Add new courses
- **Course Details**: Comprehensive course information
- **Student Enrollment**: Manage course participants

### **7. Student Registry**
- **Student Database**: Complete student information
- **Department Filtering**: Organize by academic departments
- **Search Functionality**: Find students quickly
- **Student Profiles**: Individual student details

## 🗄️ **Database Schema**

### **Enhanced Tables**
```sql
-- Teachers with profile pictures and professional info
teachers (id, full_name, email, profile_picture_url, department, position, phone_number, bio, created_at, updated_at)

-- Course management
courses (id, name, code, teacher_id, description, credits, semester, academic_year, created_at, updated_at)

-- Student registry
students (id, full_name, student_id, email, phone_number, department, year, profile_picture_url, created_at, updated_at)

-- Enhanced attendance with course linking
attendance (id, teacher_id, course_id, student_name, student_id, status, timestamp)
```

### **Security Features**
- **Row Level Security**: Data access control
- **Authentication Triggers**: Automatic profile creation
- **Permission Management**: Role-based access control
- **Data Validation**: Input sanitization and validation

## 🚀 **Setup Instructions**

### **1. Prerequisites**
```bash
# Install Flutter SDK
flutter --version

# Install dependencies
flutter pub get
```

### **2. Supabase Configuration**
1. Create a Supabase project
2. Run the `ENHANCED_DATABASE_SCHEMA.sql` script
3. Create storage buckets: `avatars` and `documents`
4. Update `lib/core/config/supabase_config.dart` with your credentials

### **3. Environment Setup**
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### **4. Platform Configuration**
```bash
# Android setup
flutter create --platforms android .

# iOS setup (macOS only)
flutter create --platforms ios .

# Web setup
flutter create --platforms web .
```

## 📋 **Database Setup**

### **1. Run Enhanced Schema**
Execute the complete SQL script from `ENHANCED_DATABASE_SCHEMA.sql` in your Supabase SQL Editor.

### **2. Create Storage Buckets**
In Supabase Dashboard → Storage:
- Create bucket: `avatars` (for profile pictures)
- Create bucket: `documents` (for course materials)
- Set appropriate RLS policies

### **3. Configure Authentication**
- Disable email confirmations for testing
- Set up password policies
- Configure social login (optional)

## 🔧 **Configuration**

### **Supabase Configuration**
```dart
// lib/core/config/supabase_config.dart
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  // Table names
  static const String teachersTable = 'teachers';
  static const String attendanceTable = 'attendance';
  static const String coursesTable = 'courses';
  static const String studentsTable = 'students';
  
  // Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String documentsBucket = 'documents';
}
```

### **Theme Configuration**
```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color backgroundColor = Color(0xFFF5F5F5);
}
```

## 📱 **Platform Support**

### **Android**
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 33 (Android 13)
- Permissions: Camera, Storage, Internet

### **iOS**
- Minimum iOS: 12.0
- Target iOS: 16.0
- Permissions: Camera, Photo Library, Internet

### **Web**
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Responsive design for desktop and tablet

## 🔒 **Security Features**

### **Authentication**
- Secure email-based authentication
- Password hashing and validation
- Session management
- Automatic logout on inactivity

### **Data Protection**
- Row Level Security (RLS)
- Encrypted data transmission
- Secure file uploads
- Input validation and sanitization

### **Privacy**
- Local data caching
- Secure credential storage
- GDPR compliance features
- Data export and deletion

## 📊 **Performance Optimization**

### **Image Optimization**
- Automatic image compression
- Cached network images
- Lazy loading
- Progressive image loading

### **Data Management**
- Efficient database queries
- Real-time subscriptions
- Offline data caching
- Background sync

### **UI Performance**
- Const constructors
- Efficient widget rebuilding
- Smooth animations
- Memory management

## 🧪 **Testing**

### **Unit Tests**
```bash
flutter test
```

### **Widget Tests**
```bash
flutter test test/widget_test.dart
```

### **Integration Tests**
```bash
flutter test integration_test/
```

## 📦 **Build & Deploy**

### **Android APK**
```bash
flutter build apk --release
```

### **Android App Bundle**
```bash
flutter build appbundle --release
```

### **iOS Archive**
```bash
flutter build ios --release
```

### **Web Build**
```bash
flutter build web --release
```

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 **Support**

For support and questions:
- Create an issue on GitHub
- Contact the development team
- Check the documentation

## 🔄 **Updates & Maintenance**

### **Regular Updates**
- Flutter SDK updates
- Dependency updates
- Security patches
- Feature enhancements

### **Backup & Recovery**
- Database backups
- File storage backups
- Configuration backups
- Disaster recovery procedures

---

**Built with ❤️ for Puntland State University**

*Empowering teachers with modern technology for better education management.*
