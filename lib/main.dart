import 'package:distribuidora_app/presentation/providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDxf2aHgB_VMTR4GA08sw9p4389gNG_dgw",
        authDomain: "distribuidora-ca933.firebaseapp.com",
        projectId: "distribuidora-ca933",
        storageBucket: "distribuidora-ca933.firebasestorage.app",
        messagingSenderId: "631579313177",
        appId: "1:631579313177:web:21f516d6c6d572336e9688",
        measurementId: "G-1VWSMYRJ3M"),
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: "Distribuidora",
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}
