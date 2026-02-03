/// Represents the type of a form field.
///
/// This class supports both built-in field types ([text], [radio], [date])
/// and custom field types via the [FieldType.custom] constructor.
///
/// Example:
/// ```dart
/// // Using built-in types
/// final textType = FieldType.text;
/// final radioType = FieldType.radio;
///
/// // Creating custom types
/// final sliderType = FieldType.custom('slider');
/// final colorPickerType = FieldType.custom('color_picker');
/// ```
class FieldType {
  /// The name identifier for this field type.
  final String name;

  const FieldType._(this.name);

  /// Built-in text field type for single or multi-line text input.
  static const text = FieldType._('text');

  /// Built-in radio button field type for single selection from options.
  static const radio = FieldType._('radio');

  /// Built-in date picker field type for date selection.
  static const date = FieldType._('date');

  /// Creates a custom field type with the given [name].
  ///
  /// Use this to extend the package with your own field types.
  ///
  /// Example:
  /// ```dart
  /// final sliderType = FieldType.custom('slider');
  /// ```
  const FieldType.custom(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldType &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'FieldType($name)';
}
