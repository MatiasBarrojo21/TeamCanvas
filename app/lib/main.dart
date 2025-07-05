import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:teamcanvas/screens/home_screen.dart';
import 'package:teamcanvas/screens/login_screen.dart';
import 'package:teamcanvas/screens/board_screen.dart';
import 'package:teamcanvas/screens/profile_screen.dart';
import 'package:teamcanvas/services/auth_service.dart';
import 'package:teamcanvas/services/firestore_service.dart';
import 'package:teamcanvas/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeamCanvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/board': (context) => const BoardScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
