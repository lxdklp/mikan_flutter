import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Extension to add valueOrNull getter to AsyncValue
extension AsyncValueExtensions<T> on AsyncValue<T> {
  /// Returns the value if available, null otherwise
  T? get valueOrNull {
    return switch (this) {
      AsyncValue(hasValue: true) => value,
      _ => null,
    };
  }
}
