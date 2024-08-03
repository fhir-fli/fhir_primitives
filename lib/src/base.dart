import 'package:meta/meta.dart';

@immutable
abstract class FhirBase {
  // Remove the const constructor because we are initializing non-constant fields
  FhirBase();

  // User appended data items - allow users to add extra information to the class
  final Map<String, dynamic> _userData = <String, dynamic>{};

  // Round tracking xml comments for testing convenience
  final List<String> _formatCommentsPre = <String>[];
  final List<String> _formatCommentsPost = <String>[];

  String get fhirType;

  /// Returns a JSON representation of the FHIR primitive.
  dynamic toJson();

  /// Returns a YAML representation of the FHIR primitive.
  dynamic toYaml();

  String toJsonString();

  // Property changed event
  final Map<String, List<void Function()>> _propertyChanged =
      <String, List<void Function()>>{};

  // Annotations
  final List<dynamic> _annotations = <dynamic>[];

  // User Data Methods
  dynamic getUserData(String name) => _userData[name];

  void setUserData(String name, dynamic value) {
    if (value != null) {
      _userData[name] = value;
    }
  }

  void clearUserData(String name) {
    _userData.remove(name);
  }

  bool hasUserData(String name) => _userData.containsKey(name);

  String? getUserString(String name) {
    final dynamic data = getUserData(name);
    return data?.toString();
  }

  int getUserInt(String name) {
    final dynamic data = getUserData(name);
    return data is int ? data : 0;
  }

  // Format Comments Methods
  List<String> get formatCommentsPre => _formatCommentsPre;

  List<String> get formatCommentsPost => _formatCommentsPost;

  bool hasFormatComment() =>
      _formatCommentsPre.isNotEmpty || _formatCommentsPost.isNotEmpty;

  // Annotations Methods
  void addAnnotation(dynamic annotation) {
    _annotations.add(annotation);
  }

  void removeAnnotations(Type type) {
    _annotations.removeWhere((dynamic element) => element.runtimeType == type);
  }

  Iterable<dynamic> annotations(Type type) {
    return _annotations.where((dynamic element) => element.runtimeType == type);
  }

  // Property Changed Methods
  void addPropertyChangedListener(String property, void Function() listener) {
    _propertyChanged
        .putIfAbsent(property, () => <void Function()>[])
        .add(listener);
  }

  void removePropertyChangedListener(
      String property, void Function() listener) {
    _propertyChanged[property]?.remove(listener);
  }

  void notifyPropertyChanged(String property) {
    if (_propertyChanged.containsKey(property)) {
      for (final void Function() listener in _propertyChanged[property]!) {
        listener();
      }
    }
  }

  // Deep Copy and Comparison Methods
  FhirBase deepCopy() {
    final FhirBase copy = clone();
    if (_annotations.isNotEmpty) {
      copy._annotations.addAll(_annotations);
    }
    return copy;
  }

  bool isExactly(FhirBase other) => other.runtimeType == runtimeType;

  bool matches(FhirBase other) => other.runtimeType == runtimeType;

  // Abstract Methods to be implemented by subclasses
  FhirBase clone();

  // Child Elements Methods
  List<FhirBase> get children => <FhirBase>[];

  Map<String, FhirBase> get namedChildren => <String, FhirBase>{};

  bool tryGetValue(String key, dynamic value) => false;

  // Validation Methods
  List<String> validate() => <String>[];

  // FHIR Type Methods
  String get typeName => 'Base';

  // Additional utility methods
  bool get isPrimitive => false;

  String? primitiveValue() => null;

  bool isEmpty() => _userData.isEmpty && _annotations.isEmpty;

  @override
  String toString() => typeName;
}
