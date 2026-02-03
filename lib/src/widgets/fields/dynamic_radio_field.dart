import 'package:flutter/material.dart';
import '../../models/radio_field_config.dart';
import '../../controller/dynamic_form_controller.dart';

/// Widget for rendering a dynamic radio button field.
///
/// This widget automatically binds to the form controller and handles
/// value updates and validation display.
class DynamicRadioField extends StatelessWidget {
  /// The field configuration.
  final RadioFieldConfig config;

  /// The form controller managing this field's state.
  final DynamicFormController controller;

  const DynamicRadioField({
    super.key,
    required this.config,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final currentValue = controller.getValue<String>(config.id);
        final error = controller.getFieldError(config.id);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                config.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            // Radio options
            RadioGroup<String>(
              groupValue: currentValue,
              onChanged: (value) {
                if (value != null) {
                  controller.setValue(config.id, value);
                }
              },
              child:
                  config.direction == Axis.vertical
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            config.options
                                .map(
                                  (option) => _buildRadioTile(context, option),
                                )
                                .toList(),
                      )
                      : Wrap(
                        spacing: 16.0,
                        children:
                            config.options
                                .map(
                                  (option) => _buildRadioTile(context, option),
                                )
                                .toList(),
                      ),
            ),

            // Error message
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRadioTile(BuildContext context, RadioOption option) {
    return InkWell(
      onTap: () => controller.setValue(config.id, option.value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(value: option.value),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.label),
                if (option.description != null)
                  Text(
                    option.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
