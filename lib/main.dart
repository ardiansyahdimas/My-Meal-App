import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:my_meal_app/hive/user.dart';
import 'package:my_meal_app/pages/home_page.dart';
import 'package:my_meal_app/pages/welcome_page.dart';
import 'package:my_meal_app/providers/my_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'hive/hive_app_helper.dart';

Future<void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox(HiveAppHelper.hiveBoxName);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: ThemeData(
          fontFamily: 'MavenPro',
          colorScheme: ColorScheme.fromSeed(seedColor: mealColor),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: HiveAppHelper().isLogedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            } else {
              if (snapshot.hasData && snapshot.data == true) {
                return const HomePage();
              } else {
                return const WelcomePage();
              }
            }
          },
        ),
      )
    );
  }
}
