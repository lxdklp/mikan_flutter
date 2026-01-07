import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../mikan_api.dart';
import '../../../../../shared/models/bangumi_row.dart';
import '../../../../../shared/models/season.dart' as model;

part 'season_provider.g.dart';

class SeasonData {
  const SeasonData({required this.season, required this.bangumiRows});

  final model.Season season;
  final List<BangumiRow> bangumiRows;
}

@riverpod
Future<SeasonData> season(Ref ref, model.Season seasonParam) async {
  final bangumiRows = await MikanApi.season(seasonParam.year, seasonParam.season);
  return SeasonData(season: seasonParam, bangumiRows: bangumiRows);
}
