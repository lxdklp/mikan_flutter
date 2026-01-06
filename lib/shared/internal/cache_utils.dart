import 'dart:async';

import '../../shared/internal/hive.dart';

/// Utility functions for cache management
/// Not a Riverpod provider - these are simple utility functions
class CacheUtils {
  CacheUtils._();

  /// Get formatted cache size string
  /// Returns a Future that completes with the size string like "12.5 MB"
  static Future<String> getFormattedCacheSize() {
    return MyHive.getFormatCacheSize();
  }
}
