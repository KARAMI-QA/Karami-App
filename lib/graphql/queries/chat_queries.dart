class ChatQueries {
  static const String chatGetOne = '''
    query chatGetOne(\$userToken: String!, \$chatId: ID!) {
      chatGetOne(userToken: \$userToken, chatId: \$chatId) {
        id
        name
        type
        is_active
        last_message_id
        last_message_at
        created_by
        deleted_at
        created_at
        updated_at
        participants
        last_message
        unread_count
        other_participant
      }
    }
  ''';

  static const String chatGetUserChats = '''
  query chatGetUserChats(\$userToken: String!) {
    chatGetUserChats(userToken: \$userToken) {
      id
      name
      type
      is_active
      last_message_id
      last_message_at
      created_by
      deleted_at
      created_at
      updated_at
      participants {
        id
        name
        email
        image
        is_online
      }
      last_message {
        id
        content
        media_url
        media_type
        sender_id
        sender_name
        created_at
      }
      unread_count
      other_participant {
        id
        name
        email
        image
        is_online
      }
    }
  }
''';

  // static const String chatGetMessages = '''
  //   query chatGetMessages(
  //     \$userToken: String!,
  //     \$chatId: ID!,
  //     \$limit: Int = 50,
  //     \$offset: Int = 0
  //   ) {
  //     chatGetMessages(
  //       userToken: \$userToken,
  //       chatId: \$chatId,
  //       limit: \$limit,
  //       offset: \$offset
  //     ) {
  //       messages {
  //         id
  //         chat_id
  //         sender_id
  //         content
  //         media_url
  //         media_type
  //         status
  //         created_at
  //         updated_at
  //         sender
  //         read_by
  //       }
  //       hasMore
  //       totalCount
  //     }
  //   }
  // ''';

  static const String chatGetMessages = '''
  query chatGetMessages(
    \$userToken: String!, 
    \$chatId: ID!, 
    \$limit: Int = 50, 
    \$offset: Int = 0
  ) {
    chatGetMessages(
      userToken: \$userToken, 
      chatId: \$chatId, 
      limit: \$limit, 
      offset: \$offset
    ) {
      messages {
        id
        chat_id
        sender_id
        content
        media_url
        media_type
        status
        created_at
        updated_at
        sender {
          id
          name
          email
          image
        }
        read_by {
          user_id
          read_at
        }
      }
      hasMore
      totalCount
    }
  }
''';

  static const String chatGetUnreadCount = '''
    query chatGetUnreadCount(\$userToken: String!, \$chatId: ID!) {
      chatGetUnreadCount(userToken: \$userToken, chatId: \$chatId)
    }
  ''';

  static const String chatGenerateUploadURL = '''
    query chatGenerateUploadURL(
      \$userToken: String!, 
      \$file_name: String!, 
      \$content_type: String!
    ) {
      chatGenerateUploadURL(
        userToken: \$userToken, 
        file_name: \$file_name, 
        content_type: \$content_type
      ) {
        url
        file_name
        public_url
        signed_url_expires
      }
    }
  ''';
}
