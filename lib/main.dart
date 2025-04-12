import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store/app.dart';
import 'package:t_store/data/repositories/authentication/authentication_repository.dart';
import 'package:t_store/features/shop/controllers/products/favorites_controller.dart';
import 'package:t_store/firebase_options.dart';
import 'package:t_store/utils/local_storage/storange_utility.dart';


Future<void> main() async {

  ///widgets binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();



  /// await splash until other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// initialize firebase and authentication repository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
          (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  //load all material design/localization/themes/bindings
  runApp(const App());
}








