import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shop/api_notificacion/firebase_api.dart';
import 'package:shop/models/CarritoModel.dart';
import 'package:shop/pages/auth/auth_page.dart';
import 'package:shop/pages/pedido_page.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CarritoModel>(
      create: (context) => CarritoModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        navigatorKey: navigatorKey,
        routes: {
          '/pedido_page': (context) => const PedidoPage(),
        },
      ),
    );
  }
}
