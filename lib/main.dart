import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/map_screen.dart';
import 'screens/todo_screen.dart';
import 'screens/follow_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_room_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/study_search_screen.dart';
import 'screens/study_detail_screen.dart';
import 'screens/user_info_screen.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      builder: (context, state) => const ProfileEditScreen(),
    ),
    GoRoute(
      path: '/notifications/settings',
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/todo',
      builder: (context, state) => const TodoScreen(),
    ),
    GoRoute(
      path: '/follow',
      builder: (context, state) => const FollowScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(email: 'user@email.com'),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/chat/:roomId',
      builder: (context, state) => ChatRoomScreen(
        roomId: state.pathParameters['roomId']!,
      ),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/study/search',
      builder: (context, state) => const StudySearchScreen(),
    ),
    GoRoute(
      path: '/study/detail/:id',
      builder: (context, state) => StudyDetailScreen(
        studyName: '스터디 ${state.pathParameters['id']}',
        schedule: '매주 월, 수, 금',
        memberCount: 10,
        description: '스터디 설명입니다.',
      ),
    ),
    GoRoute(
      path: '/user/info',
      builder: (context, state) => const UserInfoScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '스터디 파트너',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      routerConfig: _router,
    );
  }
}
