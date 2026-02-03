import 'package:flutter/foundation.dart';
import '../models/form_config.dart';
import '../validators/validation_result.dart';

/// Controller for managing dynamic form state and validation.
///
/// This controller uses [ChangeNotifier] to notify listeners when form values change.
/// It handles value storage, validation, and form submission.
///
/// Example:
/// ```dart
/// final controller = DynamicFormController(config: formConfig);
///
/// // Set a field value
/// controller.setValue('email', 'user@example.com');
///
/// // Get a field value
/// final email = controller.getValue<String>('email');
///
/// // Validate the form
/// final result = controller.validate();
/// if (result.isValid) {
///   controller.submit((values) {
///     print('Form submitted: $values');
///   });
/// }
/// ```
class DynamicFormController extends ChangeNotifier {
  /// The form configuration this controller manages.
  final FormConfig config;

  /// Internal storage for field values.
  final Map<String, dynamic> _values = {};

  /// Internal storage for field errors.
  final Map<String, List<String>> _errors = {};

  /// Whether the form has been validated at least once.
  bool _hasValidated = false;

  /// Creates a form controller with the given [config].
  ///
  /// Initializes field values with their initial values from the config.
  DynamicFormController({required this.config}) {
    _initializeValues();
  }

  /// Initializes field values from the form configuration.
  void _initializeValues() {
    for (final field in config.fields) {
      if (field.initialValue != null) {
        _values[field.id] = field.initialValue;
      }
    }
  }

  /// Returns a copy of all current form values.
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  /// Returns the value for a specific field by [fieldId].
  ///
  /// Returns null if the field has no value.
  T? getValue<T>(String fieldId) {
    return _values[fieldId] as T?;
  }

  /// Sets the value for a specific field by [fieldId].
  ///
  /// Notifies listeners and optionally validates if [validateOnChange] is enabled.
  void setValue(String fieldId, dynamic value) {
    _values[fieldId] = value;

    // Clear error for this field when value changes
    if (_errors.containsKey(fieldId)) {
      _errors.remove(fieldId);
    }

    // Validate on change if configured
    if (config.validateOnChange && _hasValidated) {
      _validateField(fieldId);
    }

    notifyListeners();
  }

  /// Validates a single field by [fieldId].
  void _validateField(String fieldId) {
    final field = config.getFieldById(fieldId);
    if (field == null) return;

    final value = _values[fieldId];
    final errors = <String>[];

    // Check required validation
    if (field.isRequired) {
      if (value == null ||
          (value is String && value.trim().isEmpty) ||
          (value is List && value.isEmpty)) {
        errors.add('This field is required');
      }
    }

    // Run custom validators
    for (final validator in field.validators) {
      final error = validator.validate(value);
      if (error != null) {
        errors.add(error);
      }
    }

    if (errors.isNotEmpty) {
      _errors[fieldId] = errors;
    } else {
      _errors.remove(fieldId);
    }
  }

  /// Validates all fields in the form.
  ///
  /// Returns a [ValidationResult] containing the validation status and any errors.
  ValidationResult validate() {
    _hasValidated = true;
    _errors.clear();

    for (final field in config.fields) {
      _validateField(field.id);
    }

    notifyListeners();

    return ValidationResult(
      isValid: _errors.isEmpty,
      errors: Map.unmodifiable(_errors),
    );
  }

  /// Returns whether the form is currently valid.
  ///
  /// Note: This only reflects the state after [validate] has been called.
  bool get isValid => _errors.isEmpty;

  /// Returns the first error message for a specific field.
  ///
  /// Returns null if the field has no errors.
  String? getFieldError(String fieldId) {
    final fieldErrors = _errors[fieldId];
    return (fieldErrors != null && fieldErrors.isNotEmpty)
        ? fieldErrors.first
        : null;
  }

  /// Returns all error messages for a specific field.
  List<String> getFieldErrors(String fieldId) {
    return _errors[fieldId] ?? [];
  }

  /// Returns whether a specific field has errors.
  bool hasFieldError(String fieldId) {
    return _errors.containsKey(fieldId) && _errors[fieldId]!.isNotEmpty;
  }

  /// Submits the form if validation passes.
  ///
  /// Validates the form first, then calls [onSubmit] with the form values if valid.
  /// Returns true if the form was submitted, false if validation failed.
  bool submit(void Function(Map<String, dynamic> values) onSubmit) {
    final result = validate();
    if (result.isValid) {
      onSubmit(values);
      return true;
    }
    return false;
  }

  /// Resets the form to its initial state.
  ///
  /// Clears all values and errors, then re-initializes with initial values.
  void reset() {
    _values.clear();
    _errors.clear();
    _hasValidated = false;
    _initializeValues();
    notifyListeners();
  }

  /// Clears all field values but keeps the form structure.
  void clear() {
    _values.clear();
    _errors.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _values.clear();
    _errors.clear();
    super.dispose();
  }
}
