import 'package:flutter/material.dart';
import '../../models/date_field_config.dart';
import '../../controller/dynamic_form_controller.dart';

/// Widget for rendering a dynamic date picker field.
///
/// This widget automatically binds to the form controller and handles
/// value updates and validation display.
class DynamicDateField extends StatelessWidget {
  /// The field configuration.
  final DateFieldConfig config;

  /// The form controller managing this field's state.
  final DynamicFormController controller;

  const DynamicDateField({
    super.key,
    required this.config,
    required this.controller,
  });

  Future<void> _selectDate(BuildContext context) async {
    final currentValue = controller.getValue<DateTime>(config.id);
    final initialDate =
        currentValue ?? config.initialPickerDate ?? DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _clampDate(initialDate),
      firstDate: config.minDate ?? DateTime(1900),
      lastDate: config.maxDate ?? DateTime(2100),
    );

    if (selectedDate != null) {
      controller.setValue(config.id, selectedDate);
    }
  }

  DateTime _clampDate(DateTime date) {
    if (config.minDate != null && date.isBefore(config.minDate!)) {
      return config.minDate!;
    }
    if (config.maxDate != null && date.isAfter(config.maxDate!)) {
      return config.maxDate!;
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final value = controller.getValue<DateTime>(config.id);
        final error = controller.getFieldError(config.id);
        final displayText =
            value != null ? config.effectiveDisplayFormat.format(value) : null;

        return InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: config.label,
              errorText: error,
              suffixIcon: const Icon(Icons.calendar_today),
              border: const OutlineInputBorder(),
            ),
            child: Text(
              displayText ?? 'Select date',
              style:
                  displayText == null
                      ? TextStyle(color: Theme.of(context).hintColor)
                      : null,
            ),
          ),
        );
      },
    );
  }
}
