# fhir_primitives
Small package containing the FHIR Primitives as they are the same in all Dart Packages.

- This package allows validation of FHIR primitives. 
- The only exception is String, where we don't have a primitive class. 
- Supported Primitive Values
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
- These can all be found officially on the [HL7 website](https://www.hl7.org/fhir/datatypes.html#primitive)
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

## DateTimes
- So these are especially difficult to deal with (as anyone who has managed dateTimes can tell you)
- We have attempted to stick to the FHIR specification as closely as possible. This includes matching precisions when using greater or left than (this is mostly important for things like CQL and FHIRPath)

## Base
- This package does also include the Base class, the abstract class from which all other FHIR objects are extended or implemented