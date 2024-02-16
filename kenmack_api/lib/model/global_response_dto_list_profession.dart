//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.12

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GlobalResponseDtoListProfession {
  /// Returns a new [GlobalResponseDtoListProfession] instance.
  GlobalResponseDtoListProfession({
    this.message,
    this.status,
    this.data = const [],
    this.success,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? status;

  List<Profession> data;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? success;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GlobalResponseDtoListProfession &&
    other.message == message &&
    other.status == status &&
    _deepEquality.equals(other.data, data) &&
    other.success == success;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (message == null ? 0 : message!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (data.hashCode) +
    (success == null ? 0 : success!.hashCode);

  @override
  String toString() => 'GlobalResponseDtoListProfession[message=$message, status=$status, data=$data, success=$success]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
      json[r'data'] = this.data;
    if (this.success != null) {
      json[r'success'] = this.success;
    } else {
      json[r'success'] = null;
    }
    return json;
  }

  /// Returns a new [GlobalResponseDtoListProfession] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GlobalResponseDtoListProfession? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GlobalResponseDtoListProfession[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GlobalResponseDtoListProfession[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GlobalResponseDtoListProfession(
        message: mapValueOfType<String>(json, r'message'),
        status: mapValueOfType<int>(json, r'status'),
        data: Profession.listFromJson(json[r'data']),
        success: mapValueOfType<bool>(json, r'success'),
      );
    }
    return null;
  }

  static List<GlobalResponseDtoListProfession> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GlobalResponseDtoListProfession>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GlobalResponseDtoListProfession.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GlobalResponseDtoListProfession> mapFromJson(dynamic json) {
    final map = <String, GlobalResponseDtoListProfession>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GlobalResponseDtoListProfession.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GlobalResponseDtoListProfession-objects as value to a dart map
  static Map<String, List<GlobalResponseDtoListProfession>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GlobalResponseDtoListProfession>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GlobalResponseDtoListProfession.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

