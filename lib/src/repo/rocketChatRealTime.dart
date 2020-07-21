import 'package:rocket_chat_dart/realtime/client.dart';

class RocketChatRealTime {
  static Client client = Client(
      'test-1',
      Uri(
        scheme: 'http',
        host: '185.119.56.78',
        port: 80,
      ),
      true);
}
