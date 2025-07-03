import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Archivo generado automáticamente

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}
