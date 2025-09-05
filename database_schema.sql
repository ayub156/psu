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
