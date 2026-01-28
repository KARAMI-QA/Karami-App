class ChatSubscriptions {
  static const String messageReceived = '''
    subscription MessageReceived(\$userToken: String!) {
      messageReceived(userToken: \$userToken) {
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
        chat {
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
        read_by {
          user_id
          read_at
        }
      }
    }
  ''';
}
