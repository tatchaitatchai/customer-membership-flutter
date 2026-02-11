import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme.dart';

class PointsMeApp extends ConsumerWidget {
  const PointsMeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Points ME',
      debugShowCheckedModeBanner: false,
      theme: PointsMeTheme.darkTheme,
      routerConfig: router,
    );
  }
}
