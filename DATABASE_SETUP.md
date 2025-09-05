# Database Setup Guide for PSU Attendance App

## 🗄️ Supabase Database Configuration

### Step 1: Access Your Supabase Project
1. Go to [supabase.com](https://supabase.com) and sign in
2. Open your project: `ooxojxeiqvasqhyxrdvk`
3. Navigate to the **SQL Editor** tab

### Step 2: Run the Database Schema
Copy and paste the following SQL code into the SQL Editor and click **Run**:

```sql
-- PSU Attendance Database Schema for Supabase
-- Run this SQL in your Supabase SQL Editor

-- Create teachers table
CREATE TABLE IF NOT EXISTS teachers (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    full_name TEXT NOT NULL,
    phone_number TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create attendance table
CREATE TABLE IF NOT EXISTS attendance (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_id UUID REFERENCES teachers(id) ON DELETE CASCADE NOT NULL,
    student_name TEXT NOT NULL,
    status TEXT CHECK (status IN ('present', 'absent')) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_attendance_teacher_id ON attendance(teacher_id);
CREATE INDEX IF NOT EXISTS idx_attendance_timestamp ON attendance(timestamp);
CREATE INDEX IF NOT EXISTS idx_teachers_phone_number ON teachers(phone_number);

-- Enable Row Level Security (RLS)
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for teachers table
CREATE POLICY "Teachers can view their own profile" ON teachers
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Teachers can update their own profile" ON teachers
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Teachers can insert their own profile" ON teachers
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Create RLS policies for attendance table
CREATE POLICY "Teachers can view their own attendance records" ON attendance
    FOR SELECT USING (auth.uid() = teacher_id);

CREATE POLICY "Teachers can insert their own attendance records" ON attendance
    FOR INSERT WITH CHECK (auth.uid() = teacher_id);

CREATE POLICY "Teachers can update their own attendance records" ON attendance
    FOR UPDATE USING (auth.uid() = teacher_id);

CREATE POLICY "Teachers can delete their own attendance records" ON attendance
    FOR DELETE USING (auth.uid() = teacher_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_teachers_updated_at
    BEFORE UPDATE ON teachers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON teachers TO anon, authenticated;
GRANT ALL ON attendance TO anon, authenticated;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
```

### Step 3: Configure Authentication Settings
1. Go to **Authentication** → **Settings**
2. Under **Auth Providers**, ensure **Email** is enabled
3. Disable **Email confirmations** (since we're using phone numbers as emails)
4. Save the settings

### Step 4: Verify Database Setup
1. Go to **Table Editor**
2. Verify you can see both `teachers` and `attendance` tables
3. Check that the tables have the correct columns and constraints

### Step 5: Test the App
1. Run `flutter run -d chrome` in your terminal
2. The app should open in Chrome
3. Try registering a new teacher account
4. Test the login functionality
5. Mark some attendance records

## 🔧 Troubleshooting

### Common Issues:

1. **"Table doesn't exist" error**
   - Make sure you ran the complete SQL schema
   - Check that you're in the correct Supabase project

2. **Authentication errors**
   - Verify your Supabase URL and anon key are correct
   - Check that email confirmations are disabled

3. **Permission denied errors**
   - Ensure RLS policies are created correctly
   - Check that the user is authenticated

4. **App won't start**
   - Run `flutter clean` then `flutter pub get`
   - Check for any compilation errors

## 📱 Next Steps

Once the database is set up:
1. Test teacher registration
2. Test login functionality
3. Test attendance marking
4. Test profile updates
5. Verify real-time updates work

## 🆘 Support

If you encounter issues:
1. Check the Supabase logs in the dashboard
2. Verify all SQL commands executed successfully
3. Check the Flutter console for error messages
4. Ensure your internet connection is stable

---

**Your Supabase Project Details:**
- **URL**: `https://ooxojxeiqvasqhyxrdvk.supabase.co`
- **Project ID**: `ooxojxeiqvasqhyxrdvk`
- **Status**: ✅ Configured and ready
