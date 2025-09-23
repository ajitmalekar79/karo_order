class AppConstants {
  // Supabase Configuration
  // NOTE: Replace these with your actual Supabase project URL and anon key
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // App Configuration
  static const String appName = 'Karo Order';
  static const String appVersion = '1.0.0';

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  // Mobile number validation (Indian format)
  static const String mobileNumberPattern = r'^[6-9]\d{9}$';

  // Routes
  static const String splashRoute = '/';
  static const String signInRoute = '/signin';
  static const String signUpRoute = '/signup';
  static const String homeRoute = '/home';

  // Storage Keys
  static const String userDataKey = 'user_data';
  static const String isFirstLaunchKey = 'is_first_launch';

  // Error Messages
  static const String networkErrorMessage =
      'Please check your internet connection';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String invalidCredentialsMessage =
      'Invalid mobile number or password';
  static const String userExistsMessage =
      'User already exists with this mobile number';
  static const String invalidMobileMessage =
      'Please enter a valid mobile number';
  static const String invalidEmailMessage =
      'Please enter a valid email address';
  static const String passwordTooShortMessage =
      'Password must be at least $minPasswordLength characters';
  static const String usernameRequiredMessage = 'Username is required';
  static const String mobileRequiredMessage = 'Mobile number is required';
  static const String passwordRequiredMessage = 'Password is required';
}
