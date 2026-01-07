import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../mikan_api.dart';
import '../../../../../shared/models/bangumi.dart';
import '../../../../../shared/models/record_item.dart';
import '../../../../../shared/models/season.dart';

part 'subscribed_provider.g.dart';

@riverpod
Future<List<Bangumi>> subscribedBangumis(Ref ref, Season? season) async {
  if (season == null) {
    return [];
  }
  return MikanApi.mySubscribedSeasonBangumi(season.year, season.season);
}

@riverpod
Future<List<RecordItem>> recentRecords(Ref ref) async {
  return MikanApi.day(2);
}

@riverpod
Map<String, List<RecordItem>> rssRecords(Ref ref) {
  final recordsAsync = ref.watch(recentRecordsProvider);

  return recordsAsync.when(
    data: (records) => groupBy(records, (it) => it.id!),
    loading: () => {},
    error: (_, __) => {},
  );
}
