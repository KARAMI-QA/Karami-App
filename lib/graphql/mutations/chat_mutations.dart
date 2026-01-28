class ChatMutations {
  static const String chatSendMessage = '''
    mutation chatSendMessage(\$userToken: String!, \$input: SendMessageInput!) {
      chatSendMessage(userToken: \$userToken, input: \$input) {
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
    }
  ''';

  static const String chatMarkAsDelivered = '''
    mutation chatMarkAsDelivered(\$userToken: String!, \$chatId: ID!) {
      chatMarkAsDelivered(userToken: \$userToken, chatId: \$chatId)
    }
  ''';

  static const String chatMarkAsSeen = '''
    mutation chatMarkAsSeen(\$userToken: String!, \$messageId: ID!) {
      chatMarkAsSeen(userToken: \$userToken, messageId: \$messageId)
    }
  ''';

  static const String chatCreateDirectChat = '''
    mutation chatCreateDirectChat(\$userToken: String!, \$otherUserId: ID!) {
      chatCreateDirectChat(userToken: \$userToken, otherUserId: \$otherUserId) {
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

  static const String chatCreateGroup = '''
    mutation chatCreateGroup(\$userToken: String!, \$input: CreateGroupInput!) {
      chatCreateGroup(userToken: \$userToken, input: \$input) {
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

  static const String chatAddParticipant = '''
    mutation chatAddParticipant(
      \$userToken: String!, 
      \$chatId: ID!, 
      \$userId: ID!
    ) {
      chatAddParticipant(
        userToken: \$userToken, 
        chatId: \$chatId, 
        userId: \$userId
      )
    }
  ''';

  static const String chatRemoveParticipant = '''
    mutation chatRemoveParticipant(
      \$userToken: String!, 
      \$chatId: ID!, 
      \$userId: ID!
    ) {
      chatRemoveParticipant(
        userToken: \$userToken, 
        chatId: \$chatId, 
        userId: \$userId
      )
    }
  ''';

  static const String chatLeaveGroup = '''
    mutation chatLeaveGroup(\$userToken: String!, \$chatId: ID!) {
      chatLeaveGroup(userToken: \$userToken, chatId: \$chatId)
    }
  ''';

  static const String chatUpdateName = '''
    mutation chatUpdateName(
      \$userToken: String!, 
      \$chatId: ID!, 
      \$name: String!
    ) {
      chatUpdateName(userToken: \$userToken, chatId: \$chatId, name: \$name) {
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

  static const String chatDeleteChat = '''
    mutation chatDeleteChat(\$userToken: String!, \$chatId: ID!) {
      chatDeleteChat(userToken: \$userToken, chatId: \$chatId)
    }
  ''';
}
