import 'package:flutter/widgets.dart';
import '../models/dynamic_form_field.dart';
import '../models/text_field_config.dart';
import '../models/radio_field_config.dart';
import '../models/date_field_config.dart';
import '../controller/dynamic_form_controller.dart';
import 'fields/dynamic_text_field.dart';
import 'fields/dynamic_radio_field.dart';
import 'fields/dynamic_date_field.dart';

/// Type definition for custom field widget builders.
typedef FieldWidgetBuilder =
    Widget Function(DynamicFormField field, DynamicFormController controller);

/// Factory for creating field widgets based on field configuration.
///
/// This factory supports both built-in field types and custom field types
/// registered via the [register] method.
///
/// Example of registering a custom field:
/// ```dart
/// void main() {
///   FieldWidgetFactory.register<SliderFieldConfig>(
///     (field, controller) => CustomSliderWidget(
///       config: field,
///       controller: controller,
///     ),
///   );
///   runApp(MyApp());
/// }
/// ```
class FieldWidgetFactory {
  /// Registry for custom field builders.
  static final Map<Type, FieldWidgetBuilder> _customBuilders = {};

  /// Registers a custom field widget builder for a specific field type.
  ///
  /// Call this method in your app's [main] function before using the form.
  ///
  /// Example:
  /// ```dart
  /// FieldWidgetFactory.register<SliderFieldConfig>(
  ///   (field, controller) => CustomSliderWidget(
  ///     config: field,
  ///     controller: controller,
  ///   ),
  /// );
  /// ```
  static void register<T extends DynamicFormField>(
    Widget Function(T field, DynamicFormController controller) builder,
  ) {
    _customBuilders[T] = (field, controller) => builder(field as T, controller);
  }

  /// Builds a widget for the given [field] using the [controller].
  ///
  /// First checks for registered custom builders, then falls back to built-in types.
  /// Throws [UnimplementedError] if no builder is found for the field type.
  static Widget build(
    DynamicFormField field,
    DynamicFormController controller,
  ) {
    // Check for registered custom builder first
    final customBuilder = _customBuilders[field.runtimeType];
    if (customBuilder != null) {
      return customBuilder(field, controller);
    }

    // Fall back to built-in types
    if (field is TextFieldConfig) {
      return DynamicTextField(config: field, controller: controller);
    } else if (field is RadioFieldConfig) {
      return DynamicRadioField(config: field, controller: controller);
    } else if (field is DateFieldConfig) {
      return DynamicDateField(config: field, controller: controller);
    }

    throw UnimplementedError(
      'No widget builder registered for ${field.runtimeType}. '
      'Use FieldWidgetFactory.register<YourFieldType>(...) to register one.',
    );
  }

  /// Clears all registered custom builders.
  ///
  /// Useful for testing to ensure a clean state.
  static void clearRegistry() => _customBuilders.clear();

  /// Returns whether a builder is registered for the given type.
  static bool isRegistered<T extends DynamicFormField>() {
    return _customBuilders.containsKey(T);
  }
}
