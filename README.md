# fhir_primitives
Small package containing the FHIR Primitives as they are the same in all Dart Packages.

## Base
- This package does also include the Base class, the abstract class from which all other FHIR objects are extended or implemented

## Working with Primitive Classes
Primitive values are [these](https://www.hl7.org/fhir/datatypes.html):

    - base64binary
    - boolean
    - canonical
    - code
    - dateTime
    - date
    - decimal
    - id
    - instant
    - integer
    - integer64 (although this is officially only part of R5)
    - markdown
    - oid
    - positiveInt
    - time
    - unsignedInt
    - uri
    - url
    - uuid
    - xhtml

- The issue is that most of these do not match exactly with the Dart definitions of primitives. So I've made them into classes, which has a couple of useful things (and one or two annoying ones). In order to make something like an integer, you have to write it like this: ```FhirInteger(128)``` or ```FhirInteger('128)```. Yes, a little annoying, but it prevents inappropriate formatting, especially for things like dates that are a lot trickier. You can, however, check equality without this. For instance, ```FhirInteger(128) == 128``` will evaluate to true.
- Every class is structured similarly
    - There is at least one general constructor, as well as a ```fromJson()```
    - As part of the constructor, the value is verified, usually against the Regex from the FHIR website
    - As we always want you to be able to retrieve your data, using the ```toJson()``` will always return the data you entered, even if it is not valid according to the Regex
    - Each class has a getter called ```.value```, this will return the value of the class in a Dart format if available (double for decimal, int for unsignedInt, etc) AND if it's a valid value.
    - Example: 
    ```Dart
    final id1 = FhirId('12345');
    final id2 = FhirId('123_45');
    print(id1.value); // 12345
    print(id2.value); // null - because this is not a valid id according to the regex
    ```


### Numbers
- You can only pass numbers (double or int) as a value for a FHIR number
- Double, Integer, Integer64, PositiveInt, and UnsignedInt will ONLY allow actual numbers.

### Dates and Times
As I was saying, dates are trickier. [XKCD Agrees!](https://xkcd.com/2867/). Part of the problem is that I allow multiple types to be passed into a constructor, a String, a dart DateTime, or another type of FhirDateTimeBase (```FhirDate```, ```FhirDateTime```, and ```FhirInstant```). There are also multiple constructors, the unnamed constructor, fromJson, fromYaml, and fromUnits. Then there are also multiple ways to get the output, toJson, toYaml, toString, and then members including valueString, valueDateTime, and input. I'm trying to clarify what gives what.

#### valueString and toString()
- These will give you the same value. That value will be an OPINIONATED String version of whatever the input is, appropriate for the Class. 
- If FhirDate is given '2020-01-01T00:00:00.000Z' as the input, this will return '2020-01-01'
- If FhirInstant is given '2020-01-01T00:00:00.11111-04:00' as the input, this will return '2020-01-01T00:00:00.111-04:00'

#### input, toJson(), toYaml()
- In order to provide the user with expected input and output, especially with serialization (even if formatted incorrectly), toJson() and toYaml() will also produce the input IN STRING FORM. I did this because a Dart DateTime class is not viable json. The input will always return the actual object that was used, regardless of what kidn of object it is.

#### value, valueDateTime, valueDateTimeString, toIso8601String()
- These are all based around the Dart DateTime class. Again, in order to try and stay true to user input, and because we can be more flexible than the FHIR official spec, if you enter more units than are appropriate, this will still allow you to store them. 
- If FhirDate is given '2020-01-01T00:00:00.11111Z' as the input, it will store 111 milliseconds, and 11 microseconds, and UTC as part of the DateTime.
- value and valueDateTime will provide the same value.
- valueDateTimeString will provide valueDateTime.toString()
- toIso8601String() will provide valueDateTime.toIso8601String()

#### fromString
- As long as it is a valid string for that class


#### FhirDate

- final dateyyyyDateTime = FhirDate(yyyyDateTime);
- final dateyyyyDateTimeFromString = FhirDate(yyyyDateTimeFromString);
- final dateyyyyFromString = FhirDate.fromString(yyyy);
- final dateyyyyFromDateTime =
      FhirDate.fromDateTime(yyyyDateTime, DateTimePrecision.yyyy);
- final dateyyyyFromJson = FhirDate.fromJson(yyyy);
- final dateyyyyDateTimeFromJson = FhirDate.fromJson(yyyyDateTime);
- final dateyyyyDateTimeFromStringFromJson =
      FhirDate.fromJson(yyyyDateTimeFromString);
- final dateyyyyFromUnits = FhirDate.fromUnits(year: 2012);
- final dateyyyyFromYaml = FhirDate.fromYaml(yyyy);

- You're allowed to use values of 2020, 2020-06, or 2020-06-01 (written of course ```FhirDate('2020-06-01')```). For ```FhirInstant and FhirDateTime``` you're also allowed to specify hours, minutes, seconds, milliseconds. For ```FhirInstant``` at least hour, minute and second is required. Yes, it's very annoying. There are also some restrictions like ```FhirInstant``` can only have 3 decimal places for seconds, but FhirDateTime can have more. Anyway, I've tackled them the best I can. Here are 2 examples with the output of various methods based on class:

* Top is Input "2020-12-13T11:20:00.721470+10:00"
* Bottom is Input "2020-12-13

| Method | FhirDateTime | FhirDate | FhirInstant |
|-|-|-|-|
|valueString<br>value<br>valueDateTime<br>iso8601String<br>toString()<br>toStringWithTimeZone()<br>toJson()<br>toYaml()<br>|2020-12-13T01:20:00.721470Z<br>2020-12-13 01:20:00.721470Z<br>2020-12-13 01:20:00.721470Z<br>2020-12-13T01:20:00.721470Z<br>2020-12-13T01:20:00.721Z<br>2020-12-13T01:20:00.721Z<br>2020-12-13T11:20:00.721470+10:00<br>2020-12-13T11:20:00.721470+10:00<br>|2020-12-13<br>2020-12-13 01:20:00.721470Z<br>2020-12-13 01:20:00.721470Z<br>2020-12-13T01:20:00.721470Z<br>2020-12-13<br>2020-12-13<br>2020-12-13T11:20:00.721470+10:00<br>2020-12-13T11:20:00.721470+10:00<br>|2020-12-13T01:20:00.721470Z<br>2020-12-13 01:20:00.721470Z<br>2020-12-13 01:20:00.721470Z<br>2020-12-13T01:20:00.721470Z<br>2020-12-13T01:20:00.721Z<br>2020-12-13T01:20:00.721Z<br>2020-12-13T11:20:00.721470+10:00<br>2020-12-13T11:20:00.721470+10:00<br>|
|valueString<br>value<br>valueDateTime<br>iso8601String<br>toString()<br>toStringWithTimeZone()<br>toJson()<br>toYaml()<br>|2020-12-13<br>2020-12-13 00:00:00.000<br>2020-12-13 00:00:00.000<br>2020-12-13T00:00:00.000<br>2020-12-13<br>2020-12-13<br>2020-12-13<br>2020-12-13<br>|2020-12-13<br>null<br>null<br>null<br><br><br>2020-12-13<br>2020-12-13<br>|2020-12-13<br>2020-12-13 00:00:00.000<br>2020-12-13 00:00:00.000<br>2020-12-13T00:00:00.000<br>2020-12-13<br>2020-12-13<br>2020-12-13<br>2020-12-13<br>|

* NOTE: An important take away point. There is a field called input. This stores the exact object you pass to the FhirDateTimeBase when you create the object. So if you need it, it's there. For the toJson() and toYaml() methods, it takes this value and runs toString() on it directly. This way you'll still get a (possibly improperly formatted) String to serialize. Otherwise, you might get a dart DateTime in your serialization, and that's not always valid depending on what you're doing.

UPDATE: [Hooray for user input!](https://github.com/fhir-fli/fhir/issues/13#issuecomment-771186955). Working with primitives has been nagging at me for a while now, and this gave me the impetus to try and fix it. It MOSTLY shouldn't effect anyone's code. It's still going to serialize/deserialize in the same way. Now, however, you can do this:

```dart
final obs = Observation(
      code: CodeableConcept(), effectiveDateTime: FhirDateTime('2020-01-01'));
print(obs.effectiveDateTime == DateTime(2020, 1, 1)); // true
```

Note that this only works in one direction because the classes override the ```==``` operator. This means that if you try

```dart
print(DateTime(2020, 1, 1) == obs.effectiveDateTime); // false
```

It will be false, because it will use the DateTime ```==``` instead.
