import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dynamic_form/flutter_dynamic_form.dart';

void main() {
  group('DynamicFormField', () {
    test('TextFieldConfig should have correct field type', () {
      final config = TextFieldConfig(id: 'test', label: 'Test Field');
      expect(config.fieldType, equals(FieldType.text));
      expect(config.id, equals('test'));
      expect(config.label, equals('Test Field'));
    });

    test('RadioFieldConfig should have correct field type', () {
      final config = RadioFieldConfig(
        id: 'gender',
        label: 'Gender',
        options: [
          const RadioOption(value: 'male', label: 'Male'),
          const RadioOption(value: 'female', label: 'Female'),
        ],
      );
      expect(config.fieldType, equals(FieldType.radio));
      expect(config.options.length, equals(2));
    });

    test('DateFieldConfig should have correct field type', () {
      final config = DateFieldConfig(id: 'dob', label: 'Date of Birth');
      expect(config.fieldType, equals(FieldType.date));
    });
  });

  group('FieldValidator', () {
    test('RequiredValidator should validate empty values', () {
      final validator = FieldValidator.required('Required');
      expect(validator.validate(null), equals('Required'));
      expect(validator.validate(''), equals('Required'));
      expect(validator.validate('value'), isNull);
    });

    test('EmailValidator should validate email format', () {
      final validator = FieldValidator.email('Invalid email');
      expect(validator.validate('invalid'), equals('Invalid email'));
      expect(validator.validate('test@example.com'), isNull);
    });

    test('MinLengthValidator should validate minimum length', () {
      final validator = FieldValidator.minLength(5, 'Too short');
      expect(validator.validate('abc'), equals('Too short'));
      expect(validator.validate('abcdef'), isNull);
    });
  });
}
