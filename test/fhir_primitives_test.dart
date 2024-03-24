import 'annoyingly_detailed_date_test.dart';
import 'annoyingly_detailed_date_time_test.dart';
import 'annoyingly_detailed_instant_test.dart';
import 'fhir_date_test.dart';
import 'fhir_date_time_test.dart';
import 'fhir_instant_test.dart';
import 'fhir_time_test.dart';
import 'primitive_test.dart';

void main() {
  primitiveTest();
  fhirDateTest();
  fhirDateTimeTest();
  fhirInstantTest();
  fhirTimeTest();
  annoyinglyDetailedDateTimeTest();
  annoyinglyDetailedInstantTest();
  annoyinglyDetailedDateTest();
}
