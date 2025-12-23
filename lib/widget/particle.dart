import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final _random = math.Random();

class ParticleController extends ChangeNotifier
    implements ValueListenable<List<Particle>> {
  ParticleController({
    this.maxSize = 10.0,
    this.minSize = 6.0,
    this.maxPercentOfDistance = 0.96,
    this.minPercentOfDistance = 0.64,
    this.maxNumberOfParticle = 64,
    this.minNumberOfParticle = 48,
    this.maxSpeedOfRotate = 16.0,
    this.minSpeedOfRotate = 1.0,
    this.duration = const Duration(milliseconds: 2000),
  });

  final double maxSize;

  final double minSize;
  final double maxPercentOfDistance;

  final double minPercentOfDistance;

  final int maxNumberOfParticle;

  final int minNumberOfParticle;

  final double maxSpeedOfRotate;
  final double minSpeedOfRotate;
  final Duration duration;

  List<Particle> _particles = [];

  void play(Color color) {
    _particles = List.generate(
      (_random.nextDouble() * (maxNumberOfParticle - minNumberOfParticle))
              .toInt() +
          minNumberOfParticle,
      (index) => Particle(
        size: _random.nextDouble() * (maxSize - minSize) + minSize,
        color: color,
        percentOfDistance:
            _random.nextDouble() *
                (maxPercentOfDistance - minPercentOfDistance) +
            minPercentOfDistance,
        shape: ParticleShape.from(_random.nextDouble()),
        speedOfRotate:
            _random.nextDouble() * (maxSpeedOfRotate - minSpeedOfRotate) +
            minSpeedOfRotate,
      ),
    );
    notifyListeners();
  }

  @override
  List<Particle> get value => _particles;
}

class ParticleWrapper extends StatefulWidget {
  const ParticleWrapper({
    super.key,
    required this.controller,
    required this.child,
  });

  final ParticleController controller;

  final Widget child;

  @override
  ParticleWrapperState createState() => ParticleWrapperState();
}

class ParticleWrapperState extends State<ParticleWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.controller.duration,
    );
    widget.controller.addListener(() {
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, v, child) {
        return CustomPaint(
          foregroundPainter: ParticlePainter(
            particles: v,
            animation: _controller.view,
            curve: Curves.fastLinearToSlowEaseIn,
          ),
          child: widget.child,
        );
      },
    );
  }
}

enum ParticleShape {
  circle,
  square,
  rectangle,
  triangle;

  factory ParticleShape.from(double v) {
    if (v < 0.05) {
      return ParticleShape.circle;
    } else if (v < 0.1) {
      return ParticleShape.rectangle;
    } else if (v < 0.15) {
      return ParticleShape.triangle;
    } else {
      return ParticleShape.square;
    }
  }
}

class Particle {
  Particle({
    required this.size,
    required this.color,
    required this.percentOfDistance,
    required this.speedOfRotate,
    required this.shape,
  });

  final double size;
  final Color color;
  final double percentOfDistance;
  final double speedOfRotate;
  final ParticleShape shape;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Particle &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          color == other.color &&
          percentOfDistance == other.percentOfDistance &&
          speedOfRotate == other.speedOfRotate &&
          shape == other.shape;

  @override
  int get hashCode =>
      size.hashCode ^
      color.hashCode ^
      percentOfDistance.hashCode ^
      speedOfRotate.hashCode ^
      shape.hashCode;
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.curve,
  }) : super(repaint: animation);
  final List<Particle> particles;
  final Animation<double> animation;
  final Curve curve;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = curve.transform(animation.value);

    if (progress >= 1.0) {
      return;
    }

    final gap = size.width / (particles.length + 1);

    final normalPaint = Paint()..style = PaintingStyle.fill;
    final rectanglePaint = Paint()..style = PaintingStyle.fill;

    const sinValue = -1.0;

    final alpha = progress < 0.999 ? 1.0 : (1 - progress) / 0.001;

    if (alpha <= 0.0) {
      return;
    }
    
    for (int i = 0; i < particles.length; ++i) {
      final particle = particles[i];

      if (particle.shape == ParticleShape.rectangle) {
        final rectAlpha = progress > 0.75
            ? (progress < 0.999 ? 1.0 : (1 - progress) / 0.001)
            : progress / 0.75;

        if (rectAlpha <= 0.0) {
          continue;
        }

        final height = size.height * particle.percentOfDistance;
        final tx = gap * (i + 1);
        final ty = size.height + progress * height * sinValue;

        rectanglePaint.color = particle.color.withValues(alpha: rectAlpha);

        final rect = Rect.fromCenter(
          center:
              Offset(tx, ty + height / 2 * (1 - progress) + particle.size / 2),
          width: particle.size,
          height: math.max(particle.size, height / 2 - height / 2 * progress),
        );
        canvas.drawRect(rect, rectanglePaint);
      } else {
        final height = size.height * particle.percentOfDistance;
        final tx = gap * (i + 1);
        final ty = size.height + progress * height * sinValue;

        final particleColor = particle.color.withValues(alpha: alpha);

        if (particle.shape == ParticleShape.circle) {
          normalPaint.color = particleColor;
          canvas.drawCircle(
            Offset(tx, ty + particle.size / 2),
            particle.size / 2,
            normalPaint,
          );
        } else {
          canvas.save();
          canvas.translate(tx, ty + particle.size / 2);

          final rotationAngle = 2 * math.pi * progress * particle.speedOfRotate;
          canvas.rotate(rotationAngle);

          final halfSize = particle.size / 2;

          if (particle.shape == ParticleShape.square) {
            final rect = Rect.fromLTRB(
              -halfSize,
              -halfSize,
              halfSize,
              halfSize,
            );
            normalPaint.color = particleColor;
            canvas.drawRect(rect, normalPaint);
          } else if (particle.shape == ParticleShape.triangle) {
            final path = Path()
              ..moveTo(0, -halfSize)
              ..lineTo(-halfSize, halfSize)
              ..lineTo(halfSize, halfSize)
              ..close();
            normalPaint.color = particleColor;
            canvas.drawPath(path, normalPaint);
          }

          canvas.restore();
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.animation.value != animation.value;
  }
}
