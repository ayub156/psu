# 🚨 URGENT: Database Setup Required

## The Problem
Your app is failing with this error:
```
Registration failed: Exception: Failed to register: AuthRetryable FetchException (message: {"code":"unexpected_failure", "message":"Database error saving new user"}), statusCode: 500
```

**This means the Supabase database tables haven't been created yet!**

## ✅ Quick Fix (5 minutes)

### Step 1: Go to Supabase Dashboard
1. Open: https://supabase.com/dashboard/project/ooxojxeiqvasqhyxrdvk
2. Sign in to your account

### Step 2: Open SQL Editor
1. Click **"SQL Editor"** in the left sidebar
2. Click **"New query"**

### Step 3: Run This SQL Code
Copy and paste this **ENTIRE** code block into the SQL Editor:

```sql
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

-- Enable Row Level Security
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for teachers table
CREATE POLICY "Teachers can view their own profile" ON teachers
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Teachers can update their own profile" ON teachers
    FOR UPDATE USING (auth.uid() = id);

-- Allow the trigger to insert teacher records
CREATE POLICY "Allow trigger to insert teacher records" ON teachers
    FOR INSERT WITH CHECK (true);

-- Create RLS policies for attendance table
CREATE POLICY "Teachers can view their own attendance records" ON attendance
    FOR SELECT USING (auth.uid() = teacher_id);

CREATE POLICY "Teachers can insert their own attendance records" ON attendance
    FOR INSERT WITH CHECK (auth.uid() = teacher_id);

CREATE POLICY "Teachers can update their own attendance records" ON attendance
    FOR UPDATE USING (auth.uid() = teacher_id);

CREATE POLICY "Teachers can delete their own attendance records" ON attendance
    FOR DELETE USING (auth.uid() = teacher_id);

-- Create function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.teachers (id, full_name, phone_number)
    VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'phone_number'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create teacher record
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

### Step 4: Execute the SQL
1. Click **"Run"** button
2. Wait for "Success" message

### Step 5: Disable Email Confirmations
1. Go to **Authentication** → **Settings**
2. Find **"Email confirmations"**
3. **Turn OFF** email confirmations
4. Click **"Save"**

## ✅ Test the App
1. Go back to your Flutter app
2. Try registering a new teacher account
3. It should work now!

## 🎉 Success!
Once the database is set up, your app will work perfectly with:
- Teacher registration
- Login functionality
- Attendance tracking
- Profile management

---

**Need help?** The error will disappear once you run the SQL code above!
