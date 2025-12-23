import 'package:flutter/material.dart';

import '../../internal/extension.dart';
import '../../internal/image_provider.dart';
import '../../model/record_item.dart';
import '../../widget/icon_button.dart';
import '../../widget/ripple_tap.dart';
import '../../widget/transition_container.dart';
import '../pages/bangumi.dart';
import '../pages/record.dart';

@immutable
class RssRecordItem extends StatelessWidget {
  const RssRecordItem({super.key, required this.index, required this.record});

  final int index;
  final RecordItem record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tags = record.tags;
    final cover = Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: CacheImage(record.cover), fit: BoxFit.cover),
      ),
      foregroundDecoration: BoxDecoration(color: theme.colorScheme.surface.withValues(alpha: 0.87)),
    );
    final tagStyle = theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.onTertiaryContainer);
    final sizeStyle = theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.onSecondaryContainer);
    return TransitionContainer(
      builder: (context, open) {
        return RippleTap(
          onTap: open,
          child: Stack(
            children: [
              Positioned.fill(child: cover),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TransitionContainer(
                    builder: (context, open) {
                      return RippleTap(
                        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                        onTap: open,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Tooltip(
                                      message: record.name,
                                      child: Text(
                                        record.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                    Text(
                                      record.publishAt,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              TMSMenuButton(torrent: record.torrent, magnet: record.magnet, share: record.share),
                            ],
                          ),
                        ),
                      );
                    },
                    next: BangumiPage(bangumiId: record.id!, cover: record.cover, name: record.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(record.title, style: theme.textTheme.bodySmall),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: [
                        if (record.size.isNotBlank)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                            ),
                            child: Text(record.size, style: sizeStyle),
                          ),
                        if (!tags.isNullOrEmpty)
                          for (final tag in tags)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiaryContainer,
                                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                              ),
                              child: Text(tag, style: tagStyle),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      next: RecordPage(record: record),
    );
  }
}
