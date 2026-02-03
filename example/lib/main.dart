import 'package:flutter/material.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

void main() {
  // Register custom field types here if needed
  // Example: FieldWidgetFactory.register<SliderFieldConfig>(...);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Form Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DynamicFormExample(),
    );
  }
}

class DynamicFormExample extends StatefulWidget {
  const DynamicFormExample({super.key});

  @override
  State<DynamicFormExample> createState() => _DynamicFormExampleState();
}

class _DynamicFormExampleState extends State<DynamicFormExample> {
  late final DynamicFormController _controller;
  Map<String, dynamic>? _submittedValues;

  @override
  void initState() {
    super.initState();
    _controller = DynamicFormController(config: _createFormConfig());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FormConfig _createFormConfig() {
    return FormConfig(
      fields: [
        TextFieldConfig(
          id: 'fullName',
          label: 'Full Name',
          isRequired: true,
          prefixIcon: Icons.person,
          validators: [
            FieldValidator.required('Name is required'),
            FieldValidator.minLength(3, 'Name must be at least 3 characters'),
          ],
        ),
        TextFieldConfig(
          id: 'email',
          label: 'Email Address',
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          validators: [
            FieldValidator.required('Email is required'),
            FieldValidator.email('Please enter a valid email'),
          ],
        ),
        TextFieldConfig(
          id: 'phone',
          label: 'Phone Number',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
          validators: [
            FieldValidator.pattern(
              RegExp(r'^\d{10}$'),
              'Phone must be 10 digits',
            ),
          ],
        ),
        RadioFieldConfig(
          id: 'gender',
          label: 'Gender',
          isRequired: true,
          options: const [
            RadioOption(value: 'male', label: 'Male'),
            RadioOption(value: 'female', label: 'Female'),
            RadioOption(value: 'other', label: 'Other'),
          ],
          validators: [FieldValidator.required('Please select your gender')],
        ),
        DateFieldConfig(
          id: 'dateOfBirth',
          label: 'Date of Birth',
          isRequired: true,
          maxDate: DateTime.now(),
          minDate: DateTime(1900),
          validators: [FieldValidator.required('Date of birth is required')],
        ),
        TextFieldConfig(
          id: 'bio',
          label: 'Bio',
          maxLines: 4,
          maxLength: 200,
          hintText: 'Tell us about yourself...',
        ),
      ],
      submitButtonText: 'Submit Form',
    );
  }

  void _handleSubmit(Map<String, dynamic> values) {
    setState(() {
      _submittedValues = values;
    });

    // Show success dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Form Submitted'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Form submitted successfully!'),
                const SizedBox(height: 16),
                Text('Name: ${values['fullName']}'),
                Text('Email: ${values['email']}'),
                if (values['phone'] != null &&
                    values['phone'].toString().isNotEmpty)
                  Text('Phone: ${values['phone']}'),
                Text('Gender: ${values['gender']}'),
                Text('DOB: ${values['dateOfBirth']}'),
                if (values['bio'] != null &&
                    values['bio'].toString().isNotEmpty)
                  Text('Bio: ${values['bio']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DynamicFormBuilder(
              config: _createFormConfig(),
              controller: _controller,
              onSubmit: _handleSubmit,
            ),
            if (_submittedValues != null) ...[
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Submitted Values:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_submittedValues.toString()),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reset();
          setState(() {
            _submittedValues = null;
          });
        },
        tooltip: 'Reset Form',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
