import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          name: 'details',
          path: 'details/:id',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: DetailsScreen(
                  id: state.pathParameters['id']!,
                  additionalInfo: state.uri.queryParameters['additionalInfo']),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.linear).animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
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
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/details/1');
              },
              child: const Text(
                "Go to details of element 1",
              ),
            ),
            GestureDetector(
              onTap: () {
                context.go(Uri(path: '/details/2', queryParameters: {
                  'additionalInfo': 'I hope you are not too tired!'
                }).toString());
              },
              child: const Text(
                "Go to details of element 2",
              ),
            ),
            GestureDetector(
              onTap: () {
                context.goNamed(
                  'details',
                  pathParameters: {'id': '3'},
                  queryParameters: {'additionalInfo': 'This also works!'},
                );
              },
              child: const Text(
                "Go to details of element 3",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.id, this.additionalInfo});

  final String id;
  final String? additionalInfo;

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
            Text('ID: $id'),
            Text('Additional info: $additionalInfo'),
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
