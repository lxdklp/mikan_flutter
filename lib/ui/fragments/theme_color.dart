import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../internal/dynamic_color.dart';
import '../../internal/hive.dart';
import '../../internal/lifecycle.dart';
import '../../widget/particle.dart';
import '../../widget/sliver_pinned_header.dart';

class ThemeColorPanel extends StatefulWidget {
  const ThemeColorPanel({super.key});

  @override
  State<ThemeColorPanel> createState() => _ThemeColorPanelState();
}

class _ThemeColorPanelState extends LifecycleAppState<ThemeColorPanel> {
  ColorSchemePair? _colorSchemePair;

  @override
  void initState() {
    super.initState();
    _tryGetDynamicColor();
  }

  void _tryGetDynamicColor() {
    getDynamicColorScheme().then((value) {
      _colorSchemePair = value;
      if (MyHive.dynamicColorEnabled() && value == null) {
        MyHive.enableDynamicColor(false);
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void onResume() {
    _tryGetDynamicColor();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverPinnedAppBar(title: '选择主题色'),
          if (_colorSchemePair != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  height: 50.0,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('跟随系统', style: theme.textTheme.titleMedium)),
                      ValueListenableBuilder(
                        valueListenable: MyHive.settings.listenable(keys: [SettingsHiveKey.dynamicColor]),
                        builder: (context, _, child) {
                          final v = MyHive.dynamicColorEnabled();
                          return Switch(
                            onChanged: (v) {
                              MyHive.enableDynamicColor(v);
                              if (v) {
                                final effectColor = theme.brightness == Brightness.light
                                    ? _colorSchemePair!.light.primary
                                    : _colorSchemePair!.dark.primary;
                                Future.delayed(const Duration(milliseconds: 160), () {
                                  if (mounted) {
                                    ParticleEffect.show(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      color: effectColor,
                                    );
                                  }
                                });
                              }
                              setState(() {});
                            },
                            value: v,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (_colorSchemePair == null || !MyHive.dynamicColorEnabled())
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: ValueListenableBuilder(
                  valueListenable: MyHive.settings.listenable(keys: [SettingsHiveKey.colorSeed]),
                  builder: (context, _, child) {
                    final color = Color(MyHive.getColorSeed());
                    return ColorPicker(
                      color: color,
                      padding: EdgeInsets.zero,
                      pickerTypeLabels: const {ColorPickerType.both: '主色调', ColorPickerType.wheel: '自定义'},
                      pickersEnabled: const <ColorPickerType, bool>{
                        ColorPickerType.both: true,
                        ColorPickerType.primary: false,
                        ColorPickerType.accent: false,
                        ColorPickerType.bw: false,
                        ColorPickerType.custom: true,
                        ColorPickerType.wheel: true,
                      },
                      enableShadesSelection: false,
                      pickerTypeTextStyle: theme.textTheme.labelLarge,
                      onColorChanged: (v) {
                        if (v == color) {
                          return;
                        }
                        MyHive.setColorSeed(v);
                        Future.delayed(const Duration(milliseconds: 160), () {
                          if (mounted) {
                            ParticleEffect.show(
                              // ignore: use_build_context_synchronously
                              context,
                              color: v,
                            );
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
