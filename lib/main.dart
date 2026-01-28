// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'app.dart';
// import 'core/services/api_service.dart';
// import 'core/utils/storage.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Hive for local storage
//   await Storage.init();

//   // Create GraphQL client
//   final client = ValueNotifier(
//     ApiService.getClient(),
//   );

//   runApp(
//     GraphQLProvider(
//       client: client,
//       child: const ChatApp(),
//     ),
//   );
// }

// main.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:karami_app/core/services/api_service.dart';
import 'app.dart';
import 'core/utils/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Storage.init();

  // Create client using the fixed service
  final client = await ApiService.createClient();

  runApp(
    GraphQLProvider(
      client: ValueNotifier(client),
      child: const ChatApp(),
    ),
  );
}
