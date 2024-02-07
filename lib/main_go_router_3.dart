import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    if (state.matchedLocation == '/details' &&
        !context.read<AppSettings>().detailsEnabled) {
      return '/';
    } else {
      return null;
    }
  },
  routes: [
    GoRoute(path: '/home', redirect: (context, state) => '/'),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) => const DetailsScreen(),
        ),
      ],
    ),
  ],
);

class AppSettings extends ChangeNotifier {
  bool detailsEnabled = false;

  void toggleDetailsEnabled(bool value) {
    detailsEnabled = value;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppSettings>(
      create: (_) => AppSettings(),
      child: MaterialApp.router(
        title: 'My app',
        routerConfig: router,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkBlue,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
        leading: Consumer<AppSettings>(builder: (context, appSettings, _) {
          return Switch(
            value: appSettings.detailsEnabled,
            onChanged: (value) => appSettings.toggleDetailsEnabled(value),
          );
        }),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.go('/details');
          },
          child: const Text(
            "Go to details",
          ),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Text(
                "Go back",
              ),
            ),
            GestureDetector(
              onTap: () {
                context.go('/holidays');
              },
              child: const Text(
                "Go who knows where...",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
