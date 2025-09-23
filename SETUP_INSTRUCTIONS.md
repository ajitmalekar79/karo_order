# Karo Order - Flutter Authentication App

A complete Flutter authentication system with Supabase integration featuring splash screen, sign up, sign in, and base screens.

## Features

- **Splash Screen** with animated branding and authentication check
- **Sign Up Screen** with username, mobile number, email (optional), and password
- **Sign In Screen** with mobile number and password login
- **Base Screen** with bottom navigation (Home, Orders, Profile)
- **Supabase Integration** for authentication and database
- **Form Validation** with proper error handling
- **Modern UI** with Google Fonts and Material 3 design
- **State Management** using GetX (reactive state management)
- **Route Management** with GetX named routes
- **Dependency Injection** with GetX bindings

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- A Supabase account and project

## Supabase Setup

1. **Create a Supabase Project**:
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Get your project URL and anon key from the project settings

2. **Create Users Table**:
   Execute this SQL in your Supabase SQL editor:
   ```sql
   CREATE TABLE users (
     id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
     username TEXT NOT NULL UNIQUE,
     mobile_no TEXT NOT NULL UNIQUE,
     email TEXT,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE,
     
     CONSTRAINT username_length CHECK (length(username) >= 3 AND length(username) <= 50),
     CONSTRAINT mobile_no_format CHECK (mobile_no ~ '^[6-9][0-9]{9}$')
   );

   -- Enable RLS (Row Level Security)
   ALTER TABLE users ENABLE ROW LEVEL SECURITY;

   -- Create policy for users to read their own data
   CREATE POLICY "Users can view own profile" ON users
     FOR SELECT USING (auth.uid() = id);

   -- Create policy for users to insert their own data
   CREATE POLICY "Users can insert own profile" ON users
     FOR INSERT WITH CHECK (auth.uid() = id);

   -- Create policy for users to update their own data
   CREATE POLICY "Users can update own profile" ON users
     FOR UPDATE USING (auth.uid() = id);
   ```

3. **Update Configuration**:
   - Open `lib/utils/constants.dart`
   - Replace `YOUR_SUPABASE_PROJECT_URL` with your actual Supabase project URL
   - Replace `YOUR_SUPABASE_ANON_KEY` with your actual Supabase anon key

## Installation

1. **Clone or setup the project**:
   ```bash
   cd /path/to/your/project
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Update Supabase credentials** in `lib/utils/constants.dart`:
   ```dart
   static const String supabaseUrl = 'https://your-project.supabase.co';
   static const String supabaseAnonKey = 'your-anon-key-here';
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry point with GetX setup
├── bindings/
│   └── auth_binding.dart    # GetX dependency injection
├── controllers/
│   └── auth_controller.dart # GetX state management
├── models/
│   └── user_model.dart      # User data model
├── routes/
│   ├── app_routes.dart      # Route constants
│   └── app_pages.dart       # GetX route configuration
├── screens/
│   ├── splash_screen.dart   # Animated splash screen
│   ├── signin_screen.dart   # Mobile + password login
│   ├── signup_screen.dart   # Registration with validation
│   └── base_screen.dart     # Main app with bottom navigation
├── services/
│   └── auth_service.dart    # Supabase authentication service
└── utils/
    ├── constants.dart       # App constants and configuration
    └── validators.dart      # Form validation utilities
```

## Authentication Flow

1. **App Launch**: Splash screen checks authentication status
2. **Unauthenticated**: Redirects to Sign In screen
3. **Sign In**: Mobile number + password authentication
4. **Sign Up**: Username, mobile, email (optional), password registration
5. **Authenticated**: Redirects to Base screen with bottom navigation

## Key Features

### Form Validation
- Mobile number: Indian format (10 digits starting with 6-9)
- Email: Optional but validated if provided
- Password: Minimum 6 characters
- Username: 3-50 characters, alphanumeric + underscore

### Security
- Row Level Security (RLS) enabled on Supabase
- Users can only access their own data
- Passwords hashed by Supabase Auth

### UI/UX
- Material 3 design system
- Google Fonts (Poppins)
- Responsive layouts
- Loading states and error handling
- Smooth animations and transitions

## Customization

### Colors
Update the color scheme in `main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.yourColor, // Change this
),
```

### App Name
Update `AppConstants.appName` in `lib/utils/constants.dart`

### Validation Rules
Modify validation constants in `lib/utils/constants.dart`

## Troubleshooting

### Common Issues

1. **Supabase Connection Error**:
   - Verify your URL and anon key are correct
   - Check internet connection
   - Ensure Supabase project is active

2. **Build Errors**:
   - Run `flutter clean && flutter pub get`
   - Check Flutter and Dart SDK versions

3. **Authentication Issues**:
   - Verify the users table is created with correct schema
   - Check RLS policies are properly configured
   - Ensure email confirmation is disabled in Supabase Auth settings

### Debug Mode
The app includes comprehensive error handling and displays user-friendly error messages.

## Production Checklist

- [ ] Update Supabase credentials
- [ ] Configure app icons and splash screen
- [ ] Set up proper error monitoring
- [ ] Configure build settings for release
- [ ] Test on multiple devices and screen sizes
- [ ] Set up CI/CD pipeline

## Next Steps

- Implement forgot password functionality
- Add social login options
- Implement proper routing with named routes
- Add offline support
- Implement order management features
- Add push notifications

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review Supabase documentation
3. Check Flutter documentation
4. Create an issue in the project repository
