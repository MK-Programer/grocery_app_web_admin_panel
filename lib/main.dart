import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';
import 'controllers/menu_controller.dart';
import 'inner_screens/add_products.dart';
import 'providers/dark_theme_provider.dart';
import 'screens/main_screen.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCUzp_9ylq1ao5bbLbMtpRf20CEcTzDUSQ",
      authDomain: "grocery---flutter-course-704ed.firebaseapp.com",
      projectId: "grocery---flutter-course-704ed",
      storageBucket: "grocery---flutter-course-704ed.appspot.com",
      messagingSenderId: "49291810820",
      appId: "1:49291810820:web:f473b06a33fd7b920e3d51",
      measurementId: "G-M63DFX1C5L",
    ),
  );
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('App is being initialized'),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('An error has been occured ${snapshot.error}'),
                ),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MenuController(),
            ),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            ),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Grocery',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
                routes: {
                  UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
