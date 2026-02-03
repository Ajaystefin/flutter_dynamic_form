import 'field_type.dart';
import '../validators/field_validator.dart';

/// Abstract base class for all dynamic form field configurations.
///
/// This class defines the common properties shared by all field types.
/// Extend this class to create custom field types for your application.
///
/// Example:
/// ```dart
/// class SliderFieldConfig extends DynamicFormField {
///   final double min;
///   final double max;
///
///   const SliderFieldConfig({
///     required super.id,
///     required super.label,
///     required this.min,
///     required this.max,
///     super.isRequired,
///     super.initialValue,
///     super.validators,
///   });
///
///   @override
///   FieldType get fieldType => FieldType.custom('slider');
/// }
/// ```
abstract class DynamicFormField {
  /// Unique identifier for this field.
  ///
  /// This ID is used to retrieve field values from the form controller.
  final String id;

  /// Display label for this field.
  final String label;

  /// Whether this field is required.
  ///
  /// When true, the field will be validated to ensure it has a value.
  final bool isRequired;

  /// Initial value for this field.
  ///
  /// The type of this value should match the expected type for the field.
  /// For example, a [TextFieldConfig] would have a [String] initial value,
  /// while a [DateFieldConfig] would have a [DateTime] initial value.
  final dynamic initialValue;

  /// List of validators to apply to this field.
  ///
  /// Validators are executed in order when the form is validated.
  final List<FieldValidator> validators;

  /// Creates a new dynamic form field configuration.
  const DynamicFormField({
    required this.id,
    required this.label,
    this.isRequired = false,
    this.initialValue,
    this.validators = const [],
  });

  /// Returns the type of this field.
  ///
  /// Subclasses must implement this to specify their field type.
  FieldType get fieldType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicFormField &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          isRequired == other.isRequired &&
          initialValue == other.initialValue;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      isRequired.hashCode ^
      initialValue.hashCode;

  @override
  String toString() =>
      'DynamicFormField(id: $id, label: $label, type: $fieldType)';
}
