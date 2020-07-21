import 'package:rocket_chat_dart/rest/client.dart';

class Repository {
  static Client client = Client(
      Uri(
        scheme: 'http',
        host: '185.119.56.78',
        port: 80,
      ),
      true);

  static String myUser;
}
