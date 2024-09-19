// ignore_for_file: always_specify_types, prefer_const_declarations

import 'package:fhir_primitives/fhir_primitives.dart';
import 'package:test/test.dart';

void main() {
  final offset =
      timeZoneOffsetToString(DateTime(2020).timeZoneOffset.inHours.toDouble());
  test('fdtyearstring', () {
    expect(FhirDateTime('2020').toString(), '2020');
    expect(FhirDateTime('2020').precision, FhirDateTimePrecision.yyyy);
    expect(FhirDateTime('2020').value, DateTime(2020));
  });
  test('fdtyearmonthstring', () {
    expect(FhirDateTime('2020-12').toString(), '2020-12');
    expect(FhirDateTime('2020-12').precision, FhirDateTimePrecision.yyyy_MM);
    expect(FhirDateTime('2020-12').value, DateTime(2020, 12));
    expect(() => FhirDateTime('2020-Bla'), returnsNormally);
    expect(FhirDateTime('2020-Bla').isValid, false);
    expect(FhirDateTime('2020-Bla').value, DateTime(2020));
  });
  test('fdtdatetime', () {
    expect(FhirDateTime('2018').isValid, true);
    expect(FhirDateTime('1973-06').isValid, true);
    expect(FhirDateTime('1905-08-23').isValid, true);
    expect(FhirDateTime('2015-02-07T13:28:17-05:00').isValid, true);
    expect(FhirDateTime('2017-01-01T00:00:00.000Z').isValid, true);
    expect(FhirDateTime(DateTime.now()).precision,
        FhirDateTimePrecision.yyyy_MM_dd_T_HH_mm_ss_SSSZZ);
    expect(FhirDateTime(DateTime.now()).isValid, true);
    expect(FhirDateTime(DateTime(2000)).toString(),
        '2000-01-01T00:00:00.000$offset');
    expect(
        FhirDateTime(FhirDate('2020')).precision, FhirDateTimePrecision.yyyy);
    expect(FhirDateTime(FhirDate('2020-10')).precision,
        FhirDateTimePrecision.yyyy_MM);
    expect(FhirDateTime(FhirDate('2020-10-01')).precision,
        FhirDateTimePrecision.yyyy_MM_dd);
    final zuluTime = FhirDateTime(DateTime.utc(1973)).toString();
    expect(zuluTime.contains('Z'), true);
    final localDateTime = DateTime.parse('2015-02-07T13:28:17');
    final localDateTimeString = FhirDateTime(localDateTime).toString();

    /// If there's no timzeone in the input, we shouldn't have any in the output
    expect(
        localDateTimeString.contains(RegExp(r'[\+|-][0-2][0-9]:[0-6][0-9]$')),
        true);
  });

  test('dateyearstring', () {
    expect(FhirDate('2020').toString(), '2020');
    expect(FhirDate('2020').precision, FhirDateTimePrecision.yyyy);
    expect(FhirDate('2020').value, DateTime(2020));
  });
  test('dateyearmonthstring', () {
    expect(FhirDate('2020-12').toString(), '2020-12');
    expect(FhirDate('2020-12').precision, FhirDateTimePrecision.yyyy_MM);
    expect(FhirDate('2020-12').value, DateTime(2020, 12));
    expect(() => FhirDate('2020-Bla'), returnsNormally);
    expect(FhirDate('2020-Bla').isValid, false);
    expect(FhirDate('2020-Bla').value, DateTime(2020));
  });
  test('date', () {
    expect(
        FhirDate(DateTime.now()).precision, FhirDateTimePrecision.yyyy_MM_dd);
    expect(FhirDate(DateTime.now()).isValid, true);
    expect(FhirDate(DateTime(2000, 10)).toString(), '2000-10-01');
  });

  test('instant', () {
    expect(FhirInstant('2015-02-07T13:28:17.239+02:00').isValid, true);
    expect(FhirInstant('2017-01-01T00:00:00Z').isValid, true);
    expect(FhirInstant('2020-12').toJson(), '2020-12');
    expect(FhirInstant('2020-12').isValid, false);
    expect(FhirInstant('2020-12').value, DateTime(2020, 12));
    expect(FhirInstant(DateTime.now()).isValid, true);
    expect(() => FhirInstant('2020-Bla'), returnsNormally);
    expect(FhirInstant('2020-Bla').isValid, false);
    expect(FhirInstant('2020-Bla').value, DateTime(2020));
  });

  test('Base64Binary', () {
    expect(FhirBase64Binary('2020').toString(), '2020');
    expect(FhirBase64Binary('2020').value, '2020');
    expect(FhirBase64Binary('').value, '');
    expect(FhirBase64Binary('_').toString(), '_');
    expect(FhirBase64Binary('_').value, null);
    expect(FhirBase64Binary('AAA').isValid, false);
    expect(FhirBase64Binary('AAAA').isValid, true);
  });

  test('Boolean', () {
    expect(FhirBoolean(true).toString(), 'true');
    expect(FhirBoolean(true).value, true);
    expect(FhirBoolean(true).toJson(), true);
    expect(FhirBoolean('true').toString(), 'true');
    expect(FhirBoolean('true').value, true);
    expect(FhirBoolean('true').toJson(), 'true');
    expect(FhirBoolean('nope').toString(), 'nope');
    expect(FhirBoolean('nope').value, null);
    expect(FhirBoolean('nope').isValid, false);
    expect(FhirBoolean('nope').toJson(), 'nope');
  });

  test('Canonical', () {
    expect(FhirCanonical('Patient/123456').toString(), 'Patient/123456');
    expect(FhirCanonical('Patient/123456').toJson(), 'Patient/123456');
    expect(FhirCanonical('Patient/123456').value, Uri.parse('Patient/123456'));
    expect(FhirCanonical('http://Patient.com/123456').toString(),
        'http://Patient.com/123456');
    expect(FhirCanonical('http://Patient.com/123456').toJson(),
        'http://Patient.com/123456');
    expect(FhirCanonical('http://Patient.com/123456').value,
        Uri.parse('http://Patient.com/123456'));
    expect(FhirCanonical('___').toString(), '___');
    expect(FhirCanonical('  ').value, null);
    expect(FhirCanonical('___').toJson(), '___');
  });
  test('Code', () {
    expect(FhirCode('Patient/123456').toString(), 'Patient/123456');
    expect(FhirCode('Patient/123456').toJson(), 'Patient/123456');
    expect(FhirCode('Patient/123456').value, 'Patient/123456');
    expect(FhirCode('http://Patient.com/123456').toString(),
        'http://Patient.com/123456');
    expect(FhirCode('http://Patient.com/123456').toJson(),
        'http://Patient.com/123456');
    expect(FhirCode('http://Patient.com/123456').value,
        'http://Patient.com/123456');
    expect(FhirCode('___').toString(), '___');
    expect(FhirCode('___').toJson(), '___');
    expect(FhirCode('').value, null);
  });

  test('Decimal', () {
    expect(FhirDecimal(1.0).toString(), '1.0');
    expect(FhirDecimal(1.0).toJson(), 1.0);
    expect(FhirDecimal(1.0).value, 1.0);
    expect(FhirDecimal(1).toString(), '1');
    expect(FhirDecimal(1).toJson(), 1);
    expect(FhirDecimal(1).value, 1.0);

    /// Because Decimals aren't allowed to take in strings
    // expect(Decimal('1.0').toString(), '1.0');
    // expect(Decimal('1.0').toJson(), '1.0');
    // expect(Decimal('1.0').value, 1.0);
    // expect(Decimal('1').toString(), '1');
    // expect(Decimal('1').toJson(), '1');
    // expect(Decimal('1').value, 1.0);
  });

  test('FhirUri', () {
    expect(FhirUri('Patient/12345').toString(), 'Patient/12345');
    expect(FhirUri('Patient/12345').toJson(), 'Patient/12345');
    expect(FhirUri('Patient/12345').value, Uri.parse('Patient/12345'));
    expect(FhirUri('http://Patient.com/12345').toString(),
        'http://Patient.com/12345');
    expect(FhirUri('http://Patient.com/12345').toJson(),
        'http://Patient.com/12345');
    expect(FhirUri('http://Patient.com/12345').value,
        Uri.parse('http://Patient.com/12345'));
    expect(FhirUri('_').toString(), '_');
    expect(FhirUri('_').toJson(), '_');
    expect(FhirUri('  ""@^|`:/#?&@%+~ ').value, null);
  });

  test('FhirUrl', () {
    expect(FhirUrl('Patient/12345').toString(), 'Patient/12345');
    expect(FhirUrl('Patient/12345').toJson(), 'Patient/12345');
    expect(FhirUrl('Patient/12345').value, Uri.parse('Patient/12345'));
    expect(FhirUrl('http://Patient.com/12345').toString(),
        'http://Patient.com/12345');
    expect(FhirUrl('http://Patient.com/12345').toJson(),
        'http://Patient.com/12345');
    expect(FhirUrl('http://Patient.com/12345').value,
        Uri.parse('http://Patient.com/12345'));
    expect(FhirUrl('_').toString(), '_');
    expect(FhirUrl('_').toJson(), '_');
    expect(FhirUrl('  ""@^|`:/#?&@%+~ ').value, null);
  });

  test('Id', () {
    expect(FhirId('Patient/12345').toString(), 'Patient/12345');
    expect(FhirId('Patient/12345').toJson(), 'Patient/12345');
    expect(FhirId('Patient/12345').value, null);
    expect(FhirId('Patient-12345').toString(), 'Patient-12345');
    expect(FhirId('Patient-12345').toJson(), 'Patient-12345');
    expect(FhirId('Patient-12345').value, 'Patient-12345');
    const id1String =
        '1111111111222222222233333333334444444444555555555566666666667777';
    const id2String =
        '11111111112222222222333333333344444444445555555555666666666677777';
    expect(FhirId(id1String).toString(), id1String);
    expect(FhirId(id1String).toJson(), id1String);
    expect(FhirId(id1String).value, id1String);
    expect(FhirId(id2String).toString(), id2String);
    expect(FhirId(id2String).toJson(), id2String);
    expect(FhirId(id2String).value, null);
    expect(FhirId(id1String).toString().length + 1,
        FhirId(id2String).toString().length);
    expect(FhirId(id1String).toString().length, 64);
    expect(FhirId(id2String).toString().length, 65);
  });

  test('Integer', () {
    expect(FhirInteger(1).toString(), '1');
    expect(FhirInteger(1).toJson(), 1);
    expect(FhirInteger(1).value, 1);
  });
}
