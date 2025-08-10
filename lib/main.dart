import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ilussia_tarot/app_config.dart';
import 'firebase_options.dart'; // generado por flutterfire configure
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId: AppConfig.googleServerClientId,//'318316028823-lfah2772d4q5q6ql6u4edp9ugb4na5ul.apps.googleusercontent.com',
  );
  
  runApp(const MyApp());
}
