/// Abstract base class for field validators.
///
/// Validators are used to check if a field value meets certain criteria.
/// Implement this class to create custom validators for your forms.
///
/// Example:
/// ```dart
/// class CustomValidator extends FieldValidator {
///   @override
///   String? validate(dynamic value) {
///     if (value == null || value.toString().isEmpty) {
///       return 'This field is required';
///     }
///     return null; // null means validation passed
///   }
/// }
/// ```
abstract class FieldValidator {
  /// Validates the given [value].
  ///
  /// Returns an error message string if validation fails, or null if valid.
  String? validate(dynamic value);

  /// Factory constructor for required field validation.
  ///
  /// Example:
  /// ```dart
  /// FieldValidator.required('This field is required')
  /// ```
  factory FieldValidator.required([String message]) = RequiredValidator;

  /// Factory constructor for email validation.
  ///
  /// Example:
  /// ```dart
  /// FieldValidator.email('Please enter a valid email')
  /// ```
  factory FieldValidator.email([String message]) = EmailValidator;

  /// Factory constructor for minimum length validation.
  ///
  /// Example:
  /// ```dart
  /// FieldValidator.minLength(8, 'Password must be at least 8 characters')
  /// ```
  factory FieldValidator.minLength(int length, [String? message]) =
      MinLengthValidator;

  /// Factory constructor for pattern/regex validation.
  ///
  /// Example:
  /// ```dart
  /// FieldValidator.pattern(RegExp(r'^\d+$'), 'Only numbers allowed')
  /// ```
  factory FieldValidator.pattern(RegExp pattern, [String message]) =
      PatternValidator;
}

/// Validator that ensures a field has a non-empty value.
class RequiredValidator implements FieldValidator {
  /// Error message to display when validation fails.
  final String message;

  /// Creates a required field validator.
  const RequiredValidator([this.message = 'This field is required']);

  @override
  String? validate(dynamic value) {
    if (value == null) return message;
    if (value is String && value.trim().isEmpty) return message;
    if (value is List && value.isEmpty) return message;
    return null;
  }
}

/// Validator that checks if a value is a valid email address.
class EmailValidator implements FieldValidator {
  /// Error message to display when validation fails.
  final String message;

  /// Regular expression for email validation.
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Creates an email validator.
  const EmailValidator([this.message = 'Please enter a valid email address']);

  @override
  String? validate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    if (!_emailRegex.hasMatch(value.toString())) return message;
    return null;
  }
}

/// Validator that ensures a string meets a minimum length requirement.
class MinLengthValidator implements FieldValidator {
  /// Minimum required length.
  final int minLength;

  /// Error message to display when validation fails.
  final String message;

  /// Creates a minimum length validator.
  MinLengthValidator(this.minLength, [String? message])
    : message = message ?? 'Must be at least $minLength characters';

  @override
  String? validate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    if (value.toString().length < minLength) return message;
    return null;
  }
}

/// Validator that checks if a value matches a regular expression pattern.
class PatternValidator implements FieldValidator {
  /// Regular expression pattern to match.
  final RegExp pattern;

  /// Error message to display when validation fails.
  final String message;

  /// Creates a pattern validator.
  const PatternValidator(this.pattern, [this.message = 'Invalid format']);

  @override
  String? validate(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    if (!pattern.hasMatch(value.toString())) return message;
    return null;
  }
}
