import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../mikan_routes.dart';
import '../../../shared/internal/consts.dart';
import '../../../shared/internal/hive.dart';
import '../../widgets/restart.dart';
import '../../widgets/sliver_pinned_header.dart';

class SelectMirror extends StatelessWidget {
  const SelectMirror({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMirrorUrl = MyHive.getMirrorUrl();
    final notifier = ValueNotifier(selectedMirrorUrl);
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                const SliverPinnedAppBar(title: '镜像地址'),
                ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (context, selected, child) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final url = MikanUrls.baseUrls[index];
                        return RadioListTile<String>(
                          title: Text(url + (url.endsWith('.me') ? '' : ' (中国大陆)')),
                          value: url,
                          // ignore: deprecated_member_use
                          groupValue: selected,
                          // ignore: deprecated_member_use
                          onChanged: (value) {
                            notifier.value = value!;
                          },
                        );
                      }, childCount: MikanUrls.baseUrls.length),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.colorScheme.surfaceContainerHighest)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('取消'),
                  ),
                ),
                const Gap(12),
                Expanded(
                  flex: 3,
                  child: ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (context, selected, child) {
                      return ElevatedButton(
                        onPressed: selectedMirrorUrl == selected
                            ? null
                            : () {
                                MikanUrls.baseUrl = selected;
                                MyHive.setMirrorUrl(selected);
                                Navigator.popUntil(context, (route) => Routes.index.name == route.settings.name);
                                Restart.restartApp(context);
                              },
                        child: const Text('设置并重启'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
