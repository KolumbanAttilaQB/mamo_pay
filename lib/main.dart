import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/firebase_options.dart';
import 'package:mamopay_clone/presentation/dashboard/view/dashboard_screen.dart';
import 'package:mamopay_clone/presentation/onboarding/view/onboarding_screen.dart';
import 'package:mamopay_clone/utils/bloc_observer.dart';

Future<void> main() async {
  Bloc.observer = const AppBlocObserver();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'MamoPay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  FirebaseAuth.instance.currentUser != null ? const DashboardScreen() : const OnboardingScreen(),
    );
  }

}
