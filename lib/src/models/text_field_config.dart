import 'package:flutter/material.dart';
import 'dynamic_form_field.dart';
import 'field_type.dart';

/// Configuration for a text input field.
///
/// Supports single-line and multi-line text input with various customization options.
///
/// Example:
/// ```dart
/// TextFieldConfig(
///   id: 'email',
///   label: 'Email Address',
///   isRequired: true,
///   keyboardType: TextInputType.emailAddress,
///   validators: [FieldValidator.email()],
/// )
/// ```
class TextFieldConfig extends DynamicFormField {
  /// Maximum number of characters allowed.
  final int? maxLength;

  /// Maximum number of lines for multi-line input.
  ///
  /// Set to 1 for single-line input, or null for unlimited lines.
  final int? maxLines;

  /// The type of keyboard to display for this field.
  final TextInputType? keyboardType;

  /// Whether to obscure the text (for password fields).
  final bool obscureText;

  /// Hint text to display when the field is empty.
  final String? hintText;

  /// Prefix icon to display before the text field.
  final IconData? prefixIcon;

  /// Suffix icon to display after the text field.
  final IconData? suffixIcon;

  /// Creates a text field configuration.
  const TextFieldConfig({
    required super.id,
    required super.label,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    super.isRequired,
    super.initialValue,
    super.validators,
  });

  @override
  FieldType get fieldType => FieldType.text;

  @override
  String toString() =>
      'TextFieldConfig(id: $id, label: $label, maxLines: $maxLines, obscureText: $obscureText)';
}
