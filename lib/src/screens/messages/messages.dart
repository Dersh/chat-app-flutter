import 'package:chat_app/src/constants/colors.dart';
import 'package:chat_app/src/repo/repository.dart';
import 'package:chat_app/src/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rocket_chat_dart/models/models.dart';

class MessageScreen extends StatelessWidget {
  final Channel chatDetails;
  final messageController = TextEditingController();
  VoidCallback _refetch;

  MessageScreen({@required this.chatDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE_COLOR,
      appBar: appBarComponent(context),
      body: body(context),
    );
  }

  Widget appBarComponent(context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return PreferredSize(
      preferredSize: Size.square(kToolbarHeight),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: dark ? DARK_PURPLE_COLOR : theme.cardColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: PURPLE_COLOR.withOpacity(.24),
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 90,
              width: 90,
              padding: EdgeInsets.only(top: 10, right: 15),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: !dark ? PURPLE_COLOR : null,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              decoration: BoxDecoration(
                color: PURPLE_COLOR.withOpacity(.1),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  chatDetails.name,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: !dark ? PURPLE_COLOR : null),
                ),
              ),
            ),
            Container(
                width: 90,
                height: 90,
                padding: EdgeInsets.only(top: 15),
                child: null //deleteChatMutationComponent(context))
                )
          ],
        ),
      ),
    );
  }

  Widget body(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      color: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          messageQueryComponent(context),
          createMessageInputComponent(context)
        ],
      ),
    );
  }

  Widget messageQueryComponent(context) {
    final appState = Provider.of<AppState>(context);

    return Text('not implemented');
//    return Query(
//      options: QueryOptions(
//        documentNode: null,
//        fetchPolicy: FetchPolicy.cacheAndNetwork,
//        pollInterval: 3,
//        variables: {'chatId': chatDetails.id},
//        context: {
//          'headers': <String, String>{
//            'Authorization': 'Bearer ${appState.token}',
//          },
//        },
//      ),
//      builder: (result, {refetch, fetchMore}) {
//        _refetch = refetch;
//        if (result.data != null &&
//            !result.loading &&
//            result.data['getMessages'] != null) {
//          var messages = MessageListModel.fromJson(
//            result.data['getMessages']['chat'],
//          );
//          return messageListComponent(messages.messages);
//        }
//        return Expanded(child: Container());
//      },
//    );
  }

  Future<Widget> messageListComponent(List<Message> messages) async {
    final bool group =
        (await Repository.client.channelMembers(roomId: chatDetails.id))
                .length >
            2;

    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: messages.length,
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) =>
            messageItemComponent(messages[i], context, group),
      ),
    );
  }

  Widget messageItemComponent(Message message, context, bool group) {
    final bool isMyMsg = (message.user.name == Repository.myUser);

    double marginL = isMyMsg ? 25 : 15;
    double marginR = isMyMsg ? 15 : 25;
    final mWidth = MediaQuery.of(context).size.width;
    final width = message.msg.length > mWidth / 7 ? mWidth / 1.3 : null;

    return Row(
      mainAxisAlignment: (message.user.name == Repository.myUser)
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(marginL, 10, marginR, 10),
          decoration: BoxDecoration(
            color: isMyMsg ? PURPLE_COLOR : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (group && !isMyMsg) ...[
                  Text(
                    "${message.user.name}",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  Container(margin: EdgeInsets.only(top: 5))
                ],
                Text(
                  message.msg,
                  style: TextStyle(
                    color: isMyMsg ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget createMessageInputComponent(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 1, 5, 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TextField(
              controller: messageController,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Tap to send a message",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          //createMessageMutationComponent(context)
        ],
      ),
    );
  }

  Widget sendButton() {
    return Text('not implemented');
//      result.loading
//        ? Container(
//            width: 25,
//            height: 25,
//            margin: EdgeInsets.only(right: 15),
//            child: CircularProgressIndicator(
//              backgroundColor: PURPLE_COLOR,
//            ))
//        : IconButton(
//            color: PURPLE_COLOR,
//            icon: Icon(OMIcons.send),
//            onPressed: () {
//              var text = messageController.text.trim();
//              if (text != '')
//                runMutation({'chatId': chatDetails.id, 'text': text});
//              messageController.clear();
//            },
//          );
  }
}
