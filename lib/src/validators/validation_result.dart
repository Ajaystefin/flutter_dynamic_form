/// Result of form validation.
///
/// Contains the overall validation status and any field-specific errors.
class ValidationResult {
  /// Whether the form passed validation.
  final bool isValid;

  /// Map of field IDs to their error messages.
  ///
  /// Each field can have multiple error messages if multiple validators fail.
  final Map<String, List<String>> errors;

  /// Creates a validation result.
  const ValidationResult({required this.isValid, required this.errors});

  /// Creates a successful validation result with no errors.
  const ValidationResult.success() : isValid = true, errors = const {};

  /// Creates a failed validation result with the given errors.
  ValidationResult.failure(this.errors) : isValid = false;

  /// Returns the first error message for a given field ID.
  ///
  /// Returns null if the field has no errors.
  String? getFieldError(String fieldId) {
    final fieldErrors = errors[fieldId];
    return (fieldErrors != null && fieldErrors.isNotEmpty)
        ? fieldErrors.first
        : null;
  }

  /// Returns all error messages for a given field ID.
  List<String> getFieldErrors(String fieldId) {
    return errors[fieldId] ?? [];
  }

  /// Returns true if a specific field has errors.
  bool hasFieldError(String fieldId) {
    return errors.containsKey(fieldId) && errors[fieldId]!.isNotEmpty;
  }

  @override
  String toString() =>
      'ValidationResult(isValid: $isValid, errors: ${errors.length} fields)';
}
