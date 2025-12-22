import 'dart:math' as math;

import 'package:easy_refresh/easy_refresh.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';

import '../internal/extension.dart';

double kMd3eHeaderFactorFactor(double overscrollFraction) =>
    2.0 * math.pow(1 - overscrollFraction, 2);

class Md3eHeader extends Header {
  const Md3eHeader({
    super.triggerOffset = 80.0,
    super.clamping = false,
    super.position = IndicatorPosition.above,
    super.processedDuration = const Duration(seconds: 1),
    super.hapticFeedback = true,
    super.frictionFactor = kMd3eHeaderFactorFactor,
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _Md3eHeaderWidget(state: state);
  }
}

class _Md3eHeaderWidget extends StatelessWidget {
  const _Md3eHeaderWidget({required this.state});

  final IndicatorState state;

  @override
  Widget build(BuildContext context) {
    const loading = ExpressiveLoadingIndicator();
    return Container(
      alignment: Alignment.center,
      height: state.offset,
      child: switch (state.mode) {
        IndicatorMode.inactive => const SizedBox.shrink(),
        IndicatorMode.drag => loading,
        IndicatorMode.armed => loading,
        IndicatorMode.ready => loading,
        IndicatorMode.processing => loading,
        IndicatorMode.processed => loading,
        IndicatorMode.secondaryArmed => const SizedBox.shrink(),
        IndicatorMode.secondaryReady => const SizedBox.shrink(),
        IndicatorMode.secondaryOpen => const SizedBox.shrink(),
        IndicatorMode.secondaryClosing => const SizedBox.shrink(),
        IndicatorMode.done => loading,
      },
    );
  }
}
