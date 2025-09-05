-- Enhanced PSU Attendance Database Schema
-- This schema includes all new features: profile pictures, courses, students, and analytics

-- Drop existing tables if they exist
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;

-- Create teachers table with enhanced fields
CREATE TABLE teachers (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    profile_picture_url TEXT,
    department TEXT,
    position TEXT,
    phone_number TEXT,
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create courses table
CREATE TABLE courses (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    code TEXT UNIQUE NOT NULL,
    teacher_id UUID REFERENCES teachers(id) ON DELETE CASCADE NOT NULL,
    description TEXT,
    credits INTEGER NOT NULL CHECK (credits > 0),
    semester TEXT NOT NULL CHECK (semester IN ('Fall', 'Spring', 'Summer')),
    academic_year INTEGER NOT NULL CHECK (academic_year >= 2020),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create students table
CREATE TABLE students (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name TEXT NOT NULL,
    student_id TEXT UNIQUE NOT NULL,
    email TEXT,
    phone_number TEXT,
    department TEXT,
    year INTEGER NOT NULL CHECK (year >= 1 AND year <= 5),
    profile_picture_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create enhanced attendance table with course reference
CREATE TABLE attendance (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    teacher_id UUID REFERENCES teachers(id) ON DELETE CASCADE NOT NULL,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    student_name TEXT NOT NULL,
    student_id TEXT REFERENCES students(student_id),
    status TEXT CHECK (status IN ('present', 'absent')) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for teachers table
CREATE POLICY "Teachers can view their own profile" ON teachers
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Teachers can update their own profile" ON teachers
    FOR UPDATE USING (auth.uid() = id);

-- Allow the trigger to insert teacher records
CREATE POLICY "Allow trigger to insert teacher records" ON teachers
    FOR INSERT WITH CHECK (true);

-- Create RLS policies for courses table
CREATE POLICY "Teachers can view their own courses" ON courses
    FOR SELECT USING (auth.uid() = teacher_id);

CREATE POLICY "Teachers can insert their own courses" ON courses
    FOR INSERT WITH CHECK (auth.uid() = teacher_id);

CREATE POLICY "Teachers can update their own courses" ON courses
    FOR UPDATE USING (auth.uid() = teacher_id);

CREATE POLICY "Teachers can delete their own courses" ON courses
    FOR DELETE USING (auth.uid() = teacher_id);

-- Create RLS policies for students table
CREATE POLICY "Teachers can view all students" ON students
    FOR SELECT USING (true);

CREATE POLICY "Teachers can insert students" ON students
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Teachers can update students" ON students
    FOR UPDATE USING (true);

CREATE POLICY "Teachers can delete students" ON students
    FOR DELETE USING (true);

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
    INSERT INTO public.teachers (id, full_name, email)
    VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'email'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create teacher record
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create indexes for better performance
CREATE INDEX idx_attendance_teacher_id ON attendance(teacher_id);
CREATE INDEX idx_attendance_course_id ON attendance(course_id);
CREATE INDEX idx_attendance_timestamp ON attendance(timestamp);
CREATE INDEX idx_courses_teacher_id ON courses(teacher_id);
CREATE INDEX idx_courses_semester_year ON courses(semester, academic_year);
CREATE INDEX idx_students_department ON students(department);
CREATE INDEX idx_students_year ON students(year);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_teachers_updated_at
    BEFORE UPDATE ON teachers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_courses_updated_at
    BEFORE UPDATE ON courses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_students_updated_at
    BEFORE UPDATE ON students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create function to get attendance analytics
CREATE OR REPLACE FUNCTION get_attendance_analytics(teacher_uuid UUID)
RETURNS TABLE (
    total_records BIGINT,
    present_records BIGINT,
    absent_records BIGINT,
    attendance_rate NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::BIGINT as total_records,
        COUNT(*) FILTER (WHERE status = 'present')::BIGINT as present_records,
        COUNT(*) FILTER (WHERE status = 'absent')::BIGINT as absent_records,
        CASE 
            WHEN COUNT(*) > 0 THEN 
                ROUND((COUNT(*) FILTER (WHERE status = 'present')::NUMERIC / COUNT(*)::NUMERIC) * 100, 2)
            ELSE 0
        END as attendance_rate
    FROM attendance 
    WHERE teacher_id = teacher_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;

-- Create storage buckets for profile pictures and documents
-- Note: These need to be created in the Supabase dashboard under Storage
-- Bucket name: 'avatars' for profile pictures
-- Bucket name: 'documents' for course materials and other files
