import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/register_name_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/history/presentation/screens/bill_detail_screen.dart';
import '../features/rank/presentation/screens/rank_privileges_screen.dart';
import '../features/privacy/presentation/screens/privacy_policy_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/register-name', builder: (context, state) => const RegisterNameScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/bill/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BillDetailScreen(orderId: id);
        },
      ),
      GoRoute(path: '/rank-privileges', builder: (context, state) => const RankPrivilegesScreen()),
      GoRoute(path: '/privacy-policy', builder: (context, state) => const PrivacyPolicyScreen()),
    ],
  );
});
