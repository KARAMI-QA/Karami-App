class UserQueries {
  static const String userGetActiveEmployees = '''
    query UserGetActiveEmployees(\$userToken: String!, \$pagination: PaginationInput) {
      userGetActiveEmployees(userToken: \$userToken, pagination: \$pagination) {
        pagination {
          currentPage
          perPage
          totalItems
          totalPages
          hasNextPage
          hasPreviousPage
        }
        users {
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
          device_token
          device_type
          first_time_password_change
          remember_token
          otp
          reset_activation
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
    }
  ''';

  static const String userSearch = '''
    query UserSearch(\$userToken: String!, \$searchTerm: String!) {
      userSearch(userToken: \$userToken, searchTerm: \$searchTerm) {
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
        device_token
        device_type
        first_time_password_change
        remember_token
        otp
        reset_activation
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
}
