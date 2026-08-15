import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Geleceğe Mektuplar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Using the theme defined earlier

      home: authState.when(
        initial: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        authenticated: (user) => const HomeScreen(),
        unauthenticated: () => const LoginScreen(),
        error: (message) => const LoginScreen(), // Hata durumunda da login'e yönlendir
      ),
    );
  }
}
