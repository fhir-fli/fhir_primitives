// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

// Project imports:
import '../fhir_primitives.dart';

@immutable
class FhirCanonical implements FhirPrimitiveBase {
  const FhirCanonical._(this._valueString, this._valueCanonical, this._isValid);

  factory FhirCanonical(dynamic inValue) {
    if (inValue is Uri) {
      return FhirCanonical._(inValue.toString(), inValue, true);
    } else if (inValue is String) {
      if (RegExp(r'^\S*$').hasMatch(inValue)) {
        final Uri? tempUri = Uri.tryParse(inValue);
        return FhirCanonical._(inValue, tempUri, tempUri != null);
      }
      return FhirCanonical._(inValue, null, false);
    }

    throw CannotBeConstructed<FhirCanonical>(
        'Canonical cannot be constructed from $inValue.');
  }

  factory FhirCanonical.fromJson(dynamic json) => FhirCanonical(json);

  factory FhirCanonical.fromYaml(dynamic yaml) => yaml is String
      ? FhirCanonical.fromJson(jsonDecode(jsonEncode(loadYaml(yaml))))
      : yaml is YamlMap
          ? FhirCanonical.fromJson(jsonDecode(jsonEncode(yaml)))
          : throw YamlFormatException<FhirCanonical>(
              'FormatException: "$json" is not a valid Yaml string or YamlMap.');

  final String _valueString;
  final Uri? _valueCanonical;
  final bool _isValid;

  bool get isValid => _isValid;
  @override
  int get hashCode => _valueString.hashCode;
  Uri? get value => _valueCanonical;

  @override
  String toString() => _valueString;
  String toJson() => _valueString;
  String toYaml() => _valueString;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FhirCanonical && other.value == _valueCanonical) ||
      (other is String && other == _valueString);
}
