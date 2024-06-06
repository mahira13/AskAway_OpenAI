import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  final ChatUser user = ChatUser(
    id: '1',
    firstName: 'Anonymous User',
  );

  final ChatUser gptChatUser = ChatUser(
    id: '2',
    firstName: 'ChatGPT',
   
  );

  var messages = <ChatMessage>[].obs;
  var typingUsers = <ChatUser>[].obs;
  var snackbarMessage = "".obs;
  @override
  void onInit() {
    super.onInit();
  }
}
