// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

// Project imports:
import '../fhir_primitives.dart';

@immutable
class FhirUri implements FhirPrimitiveBase {
  const FhirUri._(this._valueString, this._valueUri, this._isValid);

  factory FhirUri(dynamic inValue) {
    if (inValue is Uri) {
      return FhirUri._(inValue.toString(), inValue, true);
    } else if (inValue is String) {
      final Uri? tempUri = Uri.tryParse(inValue);
      return FhirUri._(inValue, tempUri, tempUri != null);
    }
    throw CannotBeConstructed<FhirUri>(
        'FhirUri cannot be constructed from $inValue.');
  }

  factory FhirUri.fromJson(dynamic json) => FhirUri(json);

  factory FhirUri.fromYaml(dynamic yaml) => yaml is String
      ? FhirUri.fromJson(jsonDecode(jsonEncode(loadYaml(yaml))))
      : yaml is YamlMap
          ? FhirUri.fromJson(jsonDecode(jsonEncode(yaml)))
          : throw YamlFormatException<FhirUri>(
              'FormatException: "$json" is not a valid Yaml string or YamlMap.');

  final String _valueString;
  final Uri? _valueUri;
  final bool _isValid;

  bool get isValid => _isValid;
  @override
  int get hashCode => _valueString.hashCode;
  Uri? get value => _valueUri;

  @override
  String toString() => _valueString;
  String toJson() => _valueString;
  String toYaml() => _valueString;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FhirUri && other.value == _valueUri ||
      other is Uri && other == _valueUri ||
      other is String && other == _valueString;
}
