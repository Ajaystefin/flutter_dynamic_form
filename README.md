# flutter_dynamic_form

A flexible, extensible Flutter package for building dynamic forms from configuration. Supports TextField, RadioButton, DatePicker, and custom field types.

## Features

✅ **Built-in Field Types**: TextField, RadioButton, DatePicker  
✅ **Extensible Architecture**: Add custom field types without modifying the package  
✅ **Validation System**: Built-in validators (required, email, minLength, pattern) + custom validators  
✅ **Form Controller**: Reactive state management with ChangeNotifier  
✅ **Type-Safe**: Full null-safety support  
✅ **Customizable**: Custom field rendering and styling

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_dynamic_form: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formConfig = FormConfig(
      fields: [
        TextFieldConfig(
          id: 'name',
          label: 'Full Name',
          isRequired: true,
          validators: [FieldValidator.required('Name is required')],
        ),
        RadioFieldConfig(
          id: 'gender',
          label: 'Gender',
          options: [
            RadioOption(value: 'male', label: 'Male'),
            RadioOption(value: 'female', label: 'Female'),
          ],
        ),
        DateFieldConfig(
          id: 'dob',
          label: 'Date of Birth',
          maxDate: DateTime.now(),
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dynamic Form')),
        body: DynamicFormBuilder(
          config: formConfig,
          onSubmit: (values) {
            print('Form submitted: $values');
          },
        ),
      ),
    );
  }
}
```

## Field Types

### TextField

```dart
TextFieldConfig(
  id: 'email',
  label: 'Email Address',
  isRequired: true,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icons.email,
  validators: [
    FieldValidator.required('Email is required'),
    FieldValidator.email('Invalid email format'),
  ],
)
```

### RadioButton

```dart
RadioFieldConfig(
  id: 'gender',
  label: 'Gender',
  options: [
    RadioOption(value: 'male', label: 'Male'),
    RadioOption(value: 'female', label: 'Female'),
    RadioOption(value: 'other', label: 'Other'),
  ],
  direction: Axis.vertical, // or Axis.horizontal
)
```

### DatePicker

```dart
DateFieldConfig(
  id: 'dateOfBirth',
  label: 'Date of Birth',
  minDate: DateTime(1900),
  maxDate: DateTime.now(),
  displayFormat: DateFormat('dd/MM/yyyy'),
)
```

## Validation

### Built-in Validators

```dart
// Required field
FieldValidator.required('This field is required')

// Email validation
FieldValidator.email('Please enter a valid email')

// Minimum length
FieldValidator.minLength(8, 'Password must be at least 8 characters')

// Pattern/Regex
FieldValidator.pattern(RegExp(r'^\d{10}$'), 'Phone must be 10 digits')
```

### Custom Validators

```dart
class CustomValidator implements FieldValidator {
  @override
  String? validate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'This field is required';
    }
    // Your custom validation logic
    return null; // null means validation passed
  }
}
```

## Form Controller

### Using the Controller

```dart
final controller = DynamicFormController(config: formConfig);

// Get field value
String? name = controller.getValue<String>('name');

// Set field value
controller.setValue('name', 'John Doe');

// Validate form
ValidationResult result = controller.validate();
if (result.isValid) {
  // Form is valid
}

// Get field error
String? error = controller.getFieldError('email');

// Submit form
controller.submit((values) {
  print('Form values: $values');
});

// Reset form
controller.reset();
```

## Custom Field Types

You can extend the package with your own field types:

### 1. Create Field Configuration

```dart
class SliderFieldConfig extends DynamicFormField {
  final double min;
  final double max;

  const SliderFieldConfig({
    required super.id,
    required super.label,
    required this.min,
    required this.max,
    super.isRequired,
    super.initialValue,
    super.validators,
  });

  @override
  FieldType get fieldType => FieldType.custom('slider');
}
```

### 2. Create Field Widget

```dart
class CustomSliderWidget extends StatelessWidget {
  final SliderFieldConfig config;
  final DynamicFormController controller;

  const CustomSliderWidget({
    required this.config,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final value = controller.getValue<double>(config.id) ?? config.min;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(config.label),
            Slider(
              value: value,
              min: config.min,
              max: config.max,
              onChanged: (v) => controller.setValue(config.id, v),
            ),
          ],
        );
      },
    );
  }
}
```

### 3. Register Custom Field

```dart
void main() {
  FieldWidgetFactory.register<SliderFieldConfig>(
    (field, controller) => CustomSliderWidget(
      config: field,
      controller: controller,
    ),
  );
  runApp(MyApp());
}
```

### 4. Use in Form

```dart
FormConfig(
  fields: [
    TextFieldConfig(id: 'name', label: 'Name'),
    SliderFieldConfig(id: 'age', label: 'Age', min: 0, max: 100),
  ],
)
```

## Form Response

When a form is submitted, you receive a `Map<String, dynamic>`:

```dart
{
  'fullName': 'John Doe',
  'email': 'john@example.com',
  'gender': 'male',
  'dateOfBirth': DateTime(1990, 5, 15),
}
```

## Example App

Check out the [example](example/) directory for a complete working example demonstrating:

- All built-in field types
- Validation
- Form submission
- Custom field types

To run the example:

```bash
cd example
flutter run
```

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
