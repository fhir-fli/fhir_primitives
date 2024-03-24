// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import '../fhir_primitives.dart';

@immutable
abstract class FhirNumber implements FhirPrimitiveBase {
  const FhirNumber(this.valueString, this.valueNumber, this.isValid);

  final String valueString;
  final num? valueNumber;
  final bool isValid;

  @override
  int get hashCode => valueString.hashCode;
  num? get value => valueNumber;

  @override
  String toString() => valueString;

  dynamic toJson() => valueNumber;
  dynamic toYaml() => valueNumber;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FhirNumber && other.valueNumber == valueNumber) ||
      (other is num && other == valueNumber);

  bool operator >(Object o) => valueNumber == null ||
          (o is! FhirNumber && o is! num) ||
          (o is FhirNumber && o.valueNumber == null)
      ? throw InvalidTypes<FhirNumber>(
          'One of the values is not valid or null\n'
          'This number is: ${toString()}, compared number is $o')
      : o is FhirNumber
          ? valueNumber! > o.valueNumber!
          : valueNumber! > (o as num);

  bool operator >=(Object o) => this == o || this > o;

  bool operator <(Object o) => valueNumber == null ||
          (o is! FhirNumber && o is! num) ||
          (o is FhirNumber && o.valueNumber == null)
      ? throw InvalidTypes<FhirNumber>(
          'One of the values is not valid or null\n'
          'This number is: ${toString()}, compared number is $o')
      : o is FhirNumber
          ? valueNumber! < o.valueNumber!
          : valueNumber! < (o as num);

  bool operator <=(Object o) => this == o || this < o;
}
