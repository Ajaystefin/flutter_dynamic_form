# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.1

- Rename package to `adaptive_form`.

## [1.0.0] - 2026-02-03

### Added

- Initial release of flutter_dynamic_form package
- Core field types: TextField, RadioButton, DatePicker
- Extensible architecture with registry pattern for custom field types
- Validation system with built-in validators:
  - RequiredValidator
  - EmailValidator
  - MinLengthValidator
  - PatternValidator
- DynamicFormController with ChangeNotifier for reactive state management
- DynamicFormBuilder widget for rendering forms
- Comprehensive documentation and example app
- Full null-safety support
- Unit tests for core functionality

### Features

- Build dynamic forms from configuration
- Type-safe field value management
- Customizable field rendering
- Form validation with detailed error messages
- Submit callback with form values
- Reset and clear form functionality
