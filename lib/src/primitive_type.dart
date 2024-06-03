import 'package:meta/meta.dart';

import 'primitive_types.dart';

@immutable
abstract class PrimitiveType extends FhirBase {
  /// Returns the primitive value of the FHIR type.
  dynamic get value;

  /// Returns a JSON representation of the FHIR primitive.
  @override
  dynamic toJson();

  /// Returns a YAML representation of the FHIR primitive.
  @override
  dynamic toYaml();

  /// Checks if the value is valid according to the FHIR type constraints.
  bool get isValid;

  /// Returns the string representation of the FHIR primitive.
  @override
  String toString();

  /// Checks equality with another object.
  @override
  bool operator ==(Object other);

  /// Returns the hash code of the FHIR primitive.
  @override
  int get hashCode;
}
