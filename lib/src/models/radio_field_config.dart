import 'package:flutter/material.dart';
import 'dynamic_form_field.dart';
import 'field_type.dart';

/// Represents a single option in a radio button group.
class RadioOption {
  /// The value that will be stored when this option is selected.
  final String value;

  /// The display label for this option.
  final String label;

  /// Optional description or subtitle for this option.
  final String? description;

  /// Creates a radio option.
  const RadioOption({
    required this.value,
    required this.label,
    this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioOption &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => value.hashCode ^ label.hashCode;

  @override
  String toString() => 'RadioOption(value: $value, label: $label)';
}

/// Configuration for a radio button field.
///
/// Allows single selection from a list of predefined options.
///
/// Example:
/// ```dart
/// RadioFieldConfig(
///   id: 'gender',
///   label: 'Gender',
///   options: [
///     RadioOption(value: 'male', label: 'Male'),
///     RadioOption(value: 'female', label: 'Female'),
///     RadioOption(value: 'other', label: 'Other'),
///   ],
///   direction: Axis.horizontal,
/// )
/// ```
class RadioFieldConfig extends DynamicFormField {
  /// List of available options for selection.
  final List<RadioOption> options;

  /// Layout direction for the radio buttons.
  ///
  /// Use [Axis.horizontal] for horizontal layout or [Axis.vertical] for vertical.
  final Axis direction;

  /// Creates a radio button field configuration.
  const RadioFieldConfig({
    required super.id,
    required super.label,
    required this.options,
    this.direction = Axis.vertical,
    super.isRequired,
    super.initialValue,
    super.validators,
  });

  @override
  FieldType get fieldType => FieldType.radio;

  @override
  String toString() =>
      'RadioFieldConfig(id: $id, label: $label, options: ${options.length}, direction: $direction)';
}
