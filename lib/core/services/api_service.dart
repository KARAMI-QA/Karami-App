import 'dart:async';

import 'package:graphql/client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:karami_app/core/constants/api_constants.dart';
import 'package:karami_app/core/utils/storage.dart';
import 'package:gql/language.dart';

class ApiService {
  static Future<GraphQLClient> createClient() async {
    final token = await Storage.getToken();
    print('🔑 Token available: ${token != null}');

    // Create HTTP Link
    final httpLink = HttpLink(
      ApiConstants.graphqlEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    // Create WebSocket Link that works with Apollo Server 4+
    final wsLink = await _createWebSocketLink(token);

    // Split links
    final link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      httpLink,
    );

    return GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );
  }

  static Future<_GraphQLTransportWSLink> _createWebSocketLink(
      String? token) async {
    print('🔌 Creating WebSocket link to: ${ApiConstants.wsEndpoint}');

    // Create a custom WebSocket channel with graphql-transport-ws protocol
    late WebSocketChannel channel;

    if (token != null) {
      print('🔌 Using token for WebSocket connection');
      channel = IOWebSocketChannel.connect(
        ApiConstants.wsEndpoint,
        protocols: ['graphql-transport-ws'],
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } else {
      print('⚠️ No token for WebSocket connection');
      channel = IOWebSocketChannel.connect(
        ApiConstants.wsEndpoint,
        protocols: ['graphql-transport-ws'],
      );
    }

    // Return a custom WebSocketLink that handles graphql-transport-ws protocol
    return _GraphQLTransportWSLink(
      channel: channel,
      token: token,
    );
  }
}

// Custom WebSocketLink that properly implements graphql-transport-ws protocol
// Custom WebSocketLink that properly implements graphql-transport-ws protocol
class _GraphQLTransportWSLink extends Link {
  final WebSocketChannel channel;
  final String? token;
  bool _initialized = false;
  final Map<String, StreamController<Response>> _activeSubscriptions = {};
  int _nextRequestId = 1;

  _GraphQLTransportWSLink({
    required this.channel,
    this.token,
  }) {
    _initialize();
    _listenToChannel();
  }

  void _initialize() {
    print('🔄 Initializing GraphQL transport WebSocket...');

    // Send connection_init message as per graphql-transport-ws protocol
    final initMessage = {
      'type': 'connection_init',
      'payload': token != null ? {'Authorization': 'Bearer $token'} : {},
    };

    channel.sink.add(json.encode(initMessage));
    print('📤 Sent connection_init');
  }

  void _listenToChannel() {
    channel.stream.listen(
      (data) {
        _handleMessage(data);
      },
      onError: (error) {
        print('❌ WebSocket error: $error');
      },
      onDone: () {
        print('✅ WebSocket connection closed');
      },
    );
  }

  void _handleMessage(String data) {
    try {
      final message = json.decode(data);
      final type = message['type'];
      final id = message['id']?.toString();

      print('📥 Received message type: $type, id: $id');

      switch (type) {
        case 'connection_ack':
          print('✅ Server acknowledged connection');
          _initialized = true;
          break;

        case 'next':
        case 'data':
          if (id != null && _activeSubscriptions.containsKey(id)) {
            final controller = _activeSubscriptions[id]!;
            final response = Response(
              data: message['payload']['data'],
              errors: _parseErrors(message['payload']['errors']),
              context: Context(),
              response: {},
            );
            print('📤 Adding data to subscription stream: $id');
            controller.add(response);
          } else {
            print('⚠️ Received data for unknown subscription id: $id');
          }
          break;

        case 'error':
          if (id != null && _activeSubscriptions.containsKey(id)) {
            final controller = _activeSubscriptions[id]!;
            final error = GraphQLError(
              message: message['payload']?.toString() ?? 'Subscription error',
            );
            controller.addError(error);
            print('❌ Error in subscription: $id');
          }
          break;

        case 'complete':
          if (id != null && _activeSubscriptions.containsKey(id)) {
            final controller = _activeSubscriptions[id]!;
            controller.close();
            _activeSubscriptions.remove(id);
            print('✅ Subscription $id completed by server');
          }
          break;

        default:
          print('ℹ️ Unknown message type: $type');
      }
    } catch (e) {
      print('❌ Error parsing WebSocket message: $e, data: $data');
    }
  }

  List<GraphQLError>? _parseErrors(dynamic errors) {
    if (errors == null) return null;

    try {
      return List<GraphQLError>.from(
        (errors as List).map(
          (error) => GraphQLError(
            message: error['message']?.toString() ?? 'Unknown error',
          ),
        ),
      );
    } catch (e) {
      print('❌ Error parsing GraphQL errors: $e');
      return null;
    }
  }

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    if (!request.isSubscription) {
      if (forward != null) {
        yield* forward(request);
      }
      return;
    }

    // Wait for connection to be initialized
    while (!_initialized) {
      print('⏳ Waiting for WebSocket initialization...');
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final requestId = (_nextRequestId++).toString();
    final controller = StreamController<Response>();

    // Store the controller for this subscription
    _activeSubscriptions[requestId] = controller;

    try {
      // Convert DocumentNode to string
      final queryString = printNode(request.operation.document);

      print('📤 Starting subscription: $requestId');
      print('📤 Query length: ${queryString.length} chars');

      // Send start message for subscription
      final startMessage = {
        'id': requestId,
        'type': 'subscribe',
        'payload': {
          'query': queryString,
          'variables': request.variables,
          'operationName': request.operation.operationName,
        },
      };

      channel.sink.add(json.encode(startMessage));
      print('✅ Subscription $requestId started');

      // Yield from the controller stream
      yield* controller.stream;
    } catch (e) {
      print('❌ Error starting subscription: $e');

      // Clean up if there's an error
      controller.addError(e);
      controller.close();
      _activeSubscriptions.remove(requestId);

      rethrow;
    } finally {
      // Clean up when the stream is done
      controller.stream.listen(
        null,
        onDone: () {
          print('🛑 Subscription $requestId stream closed by client');
          // Send complete message to server
          final completeMessage = {
            'id': requestId,
            'type': 'complete',
          };
          channel.sink.add(json.encode(completeMessage));

          // Clean up
          if (_activeSubscriptions.containsKey(requestId)) {
            _activeSubscriptions.remove(requestId);
          }
        },
      );
    }
  }

  // Fallback method if printNode doesn't work
  String _extractQueryStringFallback(dynamic document) {
    try {
      // Method 1: Try to access as Map
      if (document is Map<String, dynamic>) {
        return _reconstructQueryFromAST(document);
      }

      // Method 2: Use toString and try to extract
      final str = document.toString();

      // Look for the actual query in the string
      final regex1 = RegExp(r"gql\(r?'''([\s\S]*?)'''\)");
      final match1 = regex1.firstMatch(str);
      if (match1 != null) {
        return match1.group(1)!;
      }

      // Pattern for single-line string
      final regex2 = RegExp(r"gql\('([\s\S]*?)'\)");
      final match2 = regex2.firstMatch(str);
      if (match2 != null) {
        return match2.group(1)!;
      }

      // Look for subscription keyword
      final regex3 = RegExp(r'subscription[\s\S]*?\}');
      final match3 = regex3.firstMatch(str);
      if (match3 != null) {
        return match3.group(0)!;
      }

      return str;
    } catch (e) {
      print('❌ Error in fallback: $e');
      return 'subscription { operationFinished { name endDate } }';
    }
  }

  String _reconstructQueryFromAST(Map<String, dynamic> ast) {
    try {
      final definitions = ast['definitions'] as List?;
      if (definitions == null || definitions.isEmpty) {
        return 'subscription { test }';
      }

      final definition = definitions.first;
      final operation = definition['operation'] ?? 'subscription';
      final selectionSet = definition['selectionSet'];

      if (selectionSet == null) {
        return '$operation { test }';
      }

      final selections = selectionSet['selections'] as List?;
      if (selections == null || selections.isEmpty) {
        return '$operation { test }';
      }

      final field = selections.first;
      final fieldName = field['name']['value'] ?? 'test';

      return '$operation { $fieldName }';
    } catch (e) {
      return 'subscription { operationFinished { name endDate } }';
    }
  }

  @override
  Future<void> dispose() async {
    // Close all active subscriptions
    for (final controller in _activeSubscriptions.values) {
      controller.close();
    }
    _activeSubscriptions.clear();

    await channel.sink.close();
    print('🛑 WebSocket connection disposed');
  }
}

// Helper function for min
int min(int a, int b) => a < b ? a : b;
