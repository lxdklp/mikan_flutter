import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/experimental/mutation.dart';

import '../../mikan_api.dart';
import '../internal/extension.dart';

/// Mutation for tracking subscription state per bangumi
/// Usage:
/// - Watch state: ref.watch(subscribeMutation(bangumiId))
/// - Trigger: subscribeMutation(bangumiId).run(ref, () => ...)
final subscribeMutation = Mutation<String>();

/// Helper function to subscribe to a bangumi
Future<void> subscribeBangumi(WidgetRef ref, String bangumiId, bool subscribed, {String? subgroupId}) async {
  if (bangumiId.isNullOrBlank) {
    const msg = '番组id为空，忽略当前订阅';
    msg.toast();
    return;
  }

  await subscribeMutation(bangumiId).run(ref, (_) async {
    if (subscribed) {
      await MikanApi.unsubscribeBangumi(bangumiId, subtitleGroupId: subgroupId);
    } else {
      await MikanApi.subscribeBangumi(bangumiId, subtitleGroupId: subgroupId);
    }
    return bangumiId;
  });
}
