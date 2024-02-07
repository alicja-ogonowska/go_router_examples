import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/',
              routes: [
                GoRoute(
                  path: 'details/:id',
                  builder: (context, state) => DetailsScreen(
                    id: state.pathParameters['id']!,
                    additionalInfo: state.uri.queryParameters['additionalInfo'],
                  ),
                )
              ],
              builder: (context, state) => const MainScreen())
        ], navigatorKey: shellNavigatorHomeKey),
        StatefulShellBranch(routes: [
          GoRoute(
              path: '/profile',
              routes: [
                GoRoute(
                  path: 'details/:id',
                  builder: (context, state) => DetailsScreen(
                    id: state.pathParameters['id']!,
                    additionalInfo: state.uri.queryParameters['additionalInfo'],
                  ),
                )
              ],
              builder: (context, state) => const ProfileScreen())
        ], navigatorKey: shellNavigatorProfileKey),
      ],
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomBar(navigationShell: navigationShell);
      },
    )
  ],
);

class ScaffoldWithBottomBar extends StatefulWidget {
  const ScaffoldWithBottomBar({Key? key, required this.navigationShell})
      : super(key: key);
  final StatefulNavigationShell navigationShell;

  @override
  State<StatefulWidget> createState() {
    return _ScaffoldWithBottomBarState();
  }
}

class _ScaffoldWithBottomBarState extends State<ScaffoldWithBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: _changeTab,
        currentIndex: widget.navigationShell.currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _changeTab(int value) {
    widget.navigationShell.goBranch(value,
        initialLocation: value == widget.navigationShell.currentIndex);
  }
}

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
    return Center(
      child: GestureDetector(
        onTap: () {
          context.go('/details/1');
        },
        child: const Text(
          "Go to details of element 1",
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ID: $id'),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: const Text('Go back'),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          context.go('/profile/details/2');
        },
        child: const Text('Go to details of element 2'),
      ),
    );
  }
}
