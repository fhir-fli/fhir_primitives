import 'package:meta/meta.dart';

/// [Base] Base definition for all FHIR resources.
@immutable
abstract class Base {
  String get fhirType;

  /// Returns a JSON representation of the FHIR primitive.
  dynamic toJson();

  /// Returns a YAML representation of the FHIR primitive.
  dynamic toYaml();
}
