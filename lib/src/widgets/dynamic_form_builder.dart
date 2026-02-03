import 'package:flutter/material.dart';
import '../models/form_config.dart';
import '../models/dynamic_form_field.dart';
import '../controller/dynamic_form_controller.dart';
import 'field_widget_factory.dart';

/// Main widget for rendering a dynamic form.
///
/// This widget takes a [FormConfig] and renders all fields using the
/// appropriate field widgets. It can optionally manage its own controller
/// or use an externally provided one.
///
/// Example:
/// ```dart
/// DynamicFormBuilder(
///   config: formConfig,
///   onSubmit: (values) {
///     print('Form submitted: $values');
///   },
/// )
/// ```
class DynamicFormBuilder extends StatefulWidget {
  /// The form configuration defining the fields to render.
  final FormConfig config;

  /// Optional external form controller.
  ///
  /// If not provided, the widget will create and manage its own controller.
  final DynamicFormController? controller;

  /// Callback invoked when the form is submitted and validation passes.
  final void Function(Map<String, dynamic> values)? onSubmit;

  /// Optional builder for customizing field rendering.
  ///
  /// This allows you to wrap each field widget with custom UI elements.
  final Widget Function(
    BuildContext context,
    Widget field,
    DynamicFormField config,
  )?
  fieldBuilder;

  /// Spacing between fields.
  final double fieldSpacing;

  /// Padding around the entire form.
  final EdgeInsets? padding;

  /// Whether to show a submit button.
  final bool showSubmitButton;

  /// Custom submit button widget.
  ///
  /// If null and [showSubmitButton] is true, a default button will be shown.
  final Widget? submitButton;

  const DynamicFormBuilder({
    super.key,
    required this.config,
    this.controller,
    this.onSubmit,
    this.fieldBuilder,
    this.fieldSpacing = 16.0,
    this.padding,
    this.showSubmitButton = true,
    this.submitButton,
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  late final DynamicFormController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = DynamicFormController(config: widget.config);
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleSubmit() {
    if (widget.onSubmit != null) {
      _controller.submit(widget.onSubmit!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields =
        widget.config.fields.map((fieldConfig) {
          final fieldWidget = FieldWidgetFactory.build(
            fieldConfig,
            _controller,
          );

          return widget.fieldBuilder != null
              ? widget.fieldBuilder!(context, fieldWidget, fieldConfig)
              : fieldWidget;
        }).toList();

    final children = <Widget>[];

    // Add fields with spacing
    for (var i = 0; i < fields.length; i++) {
      children.add(fields[i]);
      if (i < fields.length - 1) {
        children.add(SizedBox(height: widget.fieldSpacing));
      }
    }

    // Add submit button if configured
    if (widget.showSubmitButton) {
      children.add(SizedBox(height: widget.fieldSpacing * 1.5));
      children.add(
        widget.submitButton ??
            _DefaultSubmitButton(
              onPressed: _handleSubmit,
              text: widget.config.submitButtonText ?? 'Submit',
            ),
      );
    }

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Default submit button widget.
class _DefaultSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const _DefaultSubmitButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Text(text),
    );
  }
}
