import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_screen_controller.dart';
import '../services/openai/api_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class HomeScreen extends GetView<HomeScreenController> {
  var controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: appbarBackgroundColor,
          title: const Text(
            appTitle,
            style: TextStyle(color: bodyTextColor),
          )),
      body: Obx(() => DashChat(
            currentUser: controller.user,
            messageOptions: const MessageOptions(
              currentUserContainerColor: Colors.black,
              containerColor: primaryColor,
              textColor: bodyTextColor,
            ),
            onSend: (ChatMessage prompt) async {
              String? errorMessage = await OpenaiApiService().request(prompt);
              if (errorMessage != null && errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(errorMessage)));
              }
            },
            messages: controller.messages.value,
            typingUsers: controller.typingUsers.value,
          )),
    );
  }
}
