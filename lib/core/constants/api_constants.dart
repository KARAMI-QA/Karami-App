class ApiConstants {
  // Use your computer's IP address
  static const String baseUrl = 'http://192.168.0.71:3013';
  static const String graphqlEndpoint = '$baseUrl/gql-point';
  static const String wsEndpoint = 'ws://192.168.0.71:3013/gql-point';

  // static const String baseUrl = 'http://localhost:3013';
  // static const String graphqlEndpoint = '$baseUrl/gql-point';
  // static const String wsEndpoint = 'ws://localhost:3013/gql-point';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const orginalBaseUrlForImage =
      'https://hrm.karami.qa/uploads/employees/';
}
