import 'package:chat_app/src/repo/repository.dart';
import 'package:rocket_chat_dart/models/models.dart';
import 'package:rocket_chat_dart/realtime/client.dart';

class MessageListModel {
  final String roomId;

  final List<MessageModel> messages;

  MessageListModel({this.roomId, this.messages});

  factory MessageListModel.fromJson(Map<String, dynamic> json) {
    List msg = json['messages'];
    var messages = msg.map((item) => MessageModel.fromJson(item));
    return MessageListModel(roomId: json['id'], messages: messages.toList());
  }

  factory MessageListModel.fromMessage(String roomId, List<Message> msgs) {
    return MessageListModel(roomId: roomId, messages: List<MessageModel>());
  }

  factory MessageListModel.fromUpdateEvent(UpdateEvent ev) {
    List<MessageModel> lst = List<MessageModel>();
    ev.doc['args']
        .forEach((element) => {lst.add(MessageModel.fromJson(element))});
    return MessageListModel(roomId: ev.doc['eventName'], messages: lst);
  }
}

class MessageModel {
  final String id;
  final User sender;
  final String text;
  final bool me;

  MessageModel({this.id, this.sender, this.text, this.me});

  factory MessageModel.fromJson(dynamic json) {
    User sender = User.fromJson(json['u']);

    final bool isMyMsg = (sender.name == Repository.myUser);

    return MessageModel(
        id: json['_id'], text: json['msg'], me: isMyMsg, sender: sender);
  }

  factory MessageModel.fromJson2(dynamic json) {
    User sender = User.fromJson(json['sender']);
    return MessageModel(
        id: json['id'], text: json['text'], me: json['me'], sender: sender);
  }

  factory MessageModel.fromUpdate(UpdateEvent ev) {
    return ev.doc['args'];
  }

  factory MessageModel.fromMessage(Message message) {
    final bool isMyMsg = (message.user.name == Repository.myUser);

    return MessageModel(
        text: message.msg, me: isMyMsg, id: message.id, sender: message.user);
  }
}
