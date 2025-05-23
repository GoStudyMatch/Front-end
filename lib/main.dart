/// 스터디 파트너 앱의 메인 파일
/// 
/// 이 파일은 앱의 진입점이며, 라우팅 설정과 테마 설정을 포함합니다.
/// Go Router를 사용하여 화면 간 네비게이션을 관리합니다.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/notification_settings_screen.dart';
import 'screens/map_screen.dart';
import 'screens/follow_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_room_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/study_search_screen.dart';
import 'screens/study_detail_screen.dart';
import 'screens/user_info_screen.dart';

/// 앱의 진입점
void main() {
  runApp(const MyApp());
}

/// 앱의 라우팅 설정
/// 
/// 각 화면에 대한 경로와 화면 빌더를 정의합니다.
/// 초기 경로는 로그인 화면('/login')으로 설정됩니다.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const StudySearchScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/chat/study/:id',
      builder: (context, state) => ChatRoomScreen(
        roomId: state.pathParameters['id']!,
        type: 'study',
        title: '스터디 채팅방',
      ),
    ),
    GoRoute(
      path: '/chat/personal/:id',
      builder: (context, state) => ChatRoomScreen(
        roomId: state.pathParameters['id']!,
        type: 'personal',
        title: '개인 채팅방',
      ),
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
      path: '/follow',
      builder: (context, state) => const FollowScreen(),
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
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지를 찾을 수 없습니다: ${state.uri.path}'),
    ),
  ),
);

/// 앱의 루트 위젯
/// 
/// MaterialApp.router를 사용하여 라우팅을 설정하고,
/// 앱의 테마를 정의합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '스터디 파트너',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
