import 'package:app_cresst/features/auth_user/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'core/state/app_controller.dart';
import 'features/auth_user/presentation/onboarding_screen.dart';
import 'features/points/presentation/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('userBox');
  await Hive.openBox('activityBox');

  runApp(const AppCresst());
}

class AppCresst extends StatefulWidget {
  const AppCresst({super.key});

  @override
  State<AppCresst> createState() => _AppCresstState();
}

class _AppCresstState extends State<AppCresst> {
  final AppController appController = AppController();

  @override
  void dispose() {
    appController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appController,
      builder: (context, _) {
        final Widget telaInicial = appController.currentUser == null
            ? OnboardingScreen(appController: appController)
            : DashboardScreen(appController: appController);
        return MaterialApp(
          title: 'App Cresst',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFE17F28),
            ),
            useMaterial3: true,
          ),
          home: appController.currentUser == null
              ? LoginScreen(appController: appController)
              : DashboardScreen(appController: appController),
        );
      },
    );
  }
}
