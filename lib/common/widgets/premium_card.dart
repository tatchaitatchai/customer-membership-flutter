import 'package:flutter/material.dart';
import '../../app/theme.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final LinearGradient? gradient;
  final Border? border;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient ?? PointsMeTheme.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: border ?? Border.all(color: PointsMeTheme.dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GoldGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GoldGradientCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2000), Color(0xFF1A1500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PointsMeTheme.primaryGold.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: PointsMeTheme.primaryGold.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
