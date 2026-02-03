import 'package:flutter/material.dart';
import '../../models/text_field_config.dart';
import '../../controller/dynamic_form_controller.dart';

/// Widget for rendering a dynamic text field.
///
/// This widget automatically binds to the form controller and handles
/// value updates and validation display.
class DynamicTextField extends StatefulWidget {
  /// The field configuration.
  final TextFieldConfig config;

  /// The form controller managing this field's state.
  final DynamicFormController controller;

  const DynamicTextField({
    super.key,
    required this.config,
    required this.controller,
  });

  @override
  State<DynamicTextField> createState() => _DynamicTextFieldState();
}

class _DynamicTextFieldState extends State<DynamicTextField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    final initialValue =
        widget.controller.getValue<String>(widget.config.id) ?? '';
    _textController = TextEditingController(text: initialValue);

    // Listen to controller changes to update text field
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final value = widget.controller.getValue<String>(widget.config.id) ?? '';
    if (_textController.text != value) {
      _textController.text = value;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final error = widget.controller.getFieldError(widget.config.id);

        return TextField(
          controller: _textController,
          decoration: InputDecoration(
            labelText: widget.config.label,
            hintText: widget.config.hintText,
            errorText: error,
            prefixIcon:
                widget.config.prefixIcon != null
                    ? Icon(widget.config.prefixIcon)
                    : null,
            suffixIcon:
                widget.config.suffixIcon != null
                    ? Icon(widget.config.suffixIcon)
                    : null,
            border: const OutlineInputBorder(),
          ),
          keyboardType: widget.config.keyboardType,
          obscureText: widget.config.obscureText,
          maxLength: widget.config.maxLength,
          maxLines: widget.config.obscureText ? 1 : widget.config.maxLines,
          onChanged: (value) {
            widget.controller.setValue(widget.config.id, value);
          },
        );
      },
    );
  }
}
