import 'dart:math' as math;

import 'package:easy_refresh/easy_refresh.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';

double kCustomHeaderFactorFactor(double overscrollFraction) =>
    2.0 * math.pow(1 - overscrollFraction, 2);

class CustomRefreshHeader extends Header {
  const CustomRefreshHeader({
    super.triggerOffset = 80.0,
    super.clamping = false,
    super.position = IndicatorPosition.above,
    super.processedDuration = const Duration(seconds: 1),
    super.hapticFeedback = true,
    super.frictionFactor = kCustomHeaderFactorFactor,
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _CustomRefreshHeaderWidget(state: state);
  }
}

class _CustomRefreshHeaderWidget extends StatelessWidget {
  const _CustomRefreshHeaderWidget({required this.state});

  final IndicatorState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: state.offset,
      child: switch (state.mode) {
        IndicatorMode.inactive => const SizedBox.shrink(),
        IndicatorMode.drag => Center(
            child: Opacity(
              opacity: state.offset / state.triggerOffset,
              child: Transform.rotate(
                angle: (state.offset / state.triggerOffset) * math.pi,
                child: const Icon(Icons.arrow_downward, size: 24.0),
              ),
            ),
          ),
        IndicatorMode.armed => const SizedBox.shrink(),
        IndicatorMode.ready => const SizedBox.shrink(),
        IndicatorMode.processing => const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: ExpressiveLoadingIndicator(),
            ),
          ),
        IndicatorMode.processed => const Icon(Icons.done, size: 24.0),
        IndicatorMode.secondaryArmed => const SizedBox.shrink(),
        IndicatorMode.secondaryReady => const SizedBox.shrink(),
        IndicatorMode.secondaryOpen => const SizedBox.shrink(),
        IndicatorMode.secondaryClosing => const SizedBox.shrink(),
        IndicatorMode.done => const SizedBox.shrink(),
      },
    );
  }
}
