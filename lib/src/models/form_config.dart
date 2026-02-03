import 'dynamic_form_field.dart';

/// Configuration for an entire dynamic form.
///
/// Contains a list of field configurations and optional form-level settings.
///
/// Example:
/// ```dart
/// final formConfig = FormConfig(
///   fields: [
///     TextFieldConfig(id: 'name', label: 'Full Name'),
///     RadioFieldConfig(id: 'gender', label: 'Gender', options: [...]),
///     DateFieldConfig(id: 'dob', label: 'Date of Birth'),
///   ],
///   submitButtonText: 'Submit',
/// );
/// ```
class FormConfig {
  /// List of field configurations for this form.
  final List<DynamicFormField> fields;

  /// Text to display on the submit button.
  ///
  /// If null, no submit button will be automatically rendered.
  final String? submitButtonText;

  /// Whether to validate the form on every field change.
  ///
  /// If false, validation only occurs when explicitly triggered or on submit.
  final bool validateOnChange;

  /// Creates a form configuration.
  const FormConfig({
    required this.fields,
    this.submitButtonText,
    this.validateOnChange = false,
  });

  /// Returns a field configuration by its ID.
  ///
  /// Returns null if no field with the given [id] exists.
  DynamicFormField? getFieldById(String id) {
    try {
      return fields.firstWhere((field) => field.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() => 'FormConfig(fields: ${fields.length})';
}
