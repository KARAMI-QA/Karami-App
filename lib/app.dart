// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'core/theme/app_theme.dart';
// import 'core/services/auth_service.dart';
// import 'core/services/chat_service.dart'; // Import ChatService
// import 'features/auth/screens/login_screen.dart';
// import 'features/dashboard/screens/dashboard_screen.dart';

// class ChatApp extends StatelessWidget {
//   const ChatApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthService()),
//         ChangeNotifierProvider(
//             create: (_) => ChatService()), // Add ChatService here
//       ],
//       child: Consumer<AuthService>(
//         builder: (context, authService, child) {
//           return MaterialApp(
//             title: 'Karami App',
//             debugShowCheckedModeBanner: false,
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme,
//             themeMode:
//                 authService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
//             home: authService.isLoggedIn
//                 ? const DashboardScreen()
//                 : const LoginScreen(),
//             routes: {
//               '/login': (context) => const LoginScreen(),
//               '/dashboard': (context) => const DashboardScreen(),
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:karami_app/core/services/user_service.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'core/services/chat_service.dart'; // Import ChatService
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (_) => ChatService(),
        ),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          // Initialize ChatService when user logs in
          if (authService.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final chatService =
                  Provider.of<ChatService>(context, listen: false);
              chatService.initialize();
            });
          }

          return MaterialApp(
            title: 'Karami App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                authService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: authService.isLoggedIn
                ? const DashboardScreen()
                : const LoginScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/dashboard': (context) => const DashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
