import 'package:intl/intl.dart';
import 'dynamic_form_field.dart';
import 'field_type.dart';

/// Configuration for a date picker field.
///
/// Allows users to select a date from a date picker dialog.
///
/// Example:
/// ```dart
/// DateFieldConfig(
///   id: 'dateOfBirth',
///   label: 'Date of Birth',
///   isRequired: true,
///   maxDate: DateTime.now(),
///   minDate: DateTime(1900),
///   displayFormat: DateFormat('dd/MM/yyyy'),
/// )
/// ```
class DateFieldConfig extends DynamicFormField {
  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Format for displaying the selected date.
  ///
  /// Defaults to 'yyyy-MM-dd' if not specified.
  final DateFormat? displayFormat;

  /// Initial date to show in the picker when opened.
  ///
  /// Defaults to the current date if not specified.
  final DateTime? initialPickerDate;

  /// Creates a date picker field configuration.
  const DateFieldConfig({
    required super.id,
    required super.label,
    this.minDate,
    this.maxDate,
    this.displayFormat,
    this.initialPickerDate,
    super.isRequired,
    super.initialValue,
    super.validators,
  });

  @override
  FieldType get fieldType => FieldType.date;

  /// Returns the date format to use for display.
  DateFormat get effectiveDisplayFormat =>
      displayFormat ?? DateFormat('yyyy-MM-dd');

  @override
  String toString() =>
      'DateFieldConfig(id: $id, label: $label, minDate: $minDate, maxDate: $maxDate)';
}
