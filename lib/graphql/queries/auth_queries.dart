class AuthQueries {
  static const String userGetOne = '''
    query userGetOne(\$userToken: String!) {
      userGetOne(userToken: \$userToken) {
        id
        name
        first_name
        middle_name
        last_name
        email
        phone
        image
        email_verified_at
        phone_verified_at
        device_type
        first_time_password_change
        is_verified
        is_employee
        is_super
        status
        created_by
        updated_by
        deleted_by
        deleted_at
        created_at
        updated_at
      }
    }
  ''';

  static const String userValidateToken = '''
    query userValidateToken(\$userToken: String!) {
      userValidateToken(userToken: \$userToken)
    }
  ''';
}
