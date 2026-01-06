import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../mikan_api.dart';
import '../../../../../shared/models/season_gallery.dart';
import '../../../../../shared/models/subgroup.dart';

part 'subgroup_provider.g.dart';

@riverpod
Future<List<SeasonGallery>> subgroupGalleries(Ref ref, Subgroup subgroup) async {
  final id = subgroup.id;
  if (id == null) {
    return [];
  }
  return MikanApi.subgroup(id);
}
