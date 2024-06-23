import 'dart:io';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/openai/api_key.dart';

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

  String? uploadedFileId;

  String? threadId;
  late List<Widget> listWidgets = [
    IconButton(
        icon: const Icon(Icons.attach_file),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (result != null) {
            File file = File(result.files.single.path!);
            messages.insert(
                0,
                ChatMessage(
                    user: user,
                    createdAt: DateTime.now(),
                    text: "Your file is uploading..."));
            final request = UploadFile(
                file: FileInfo(file.path, 'file-name.pdf',),
                purpose: 'assistants');
            final response = await OpenaiApiKey.openAI.file.uploadFile(request);
            uploadedFileId = response.id;

            await OpenaiApiKey.openAI.assistant.createFile(
              assistantId: OpenaiApiKey.assistantId,
              fileId: response.id,
            );
            messages[0] = ChatMessage(
                user: user,
                createdAt: DateTime.now(),
                text:
                    "You uploaded a file. Now you can ask questions based on the file");

            // Get.showSnackbar(
            //   const GetSnackBar(
            //     title: "File Uploaded !",
            //     message: "You can now ask questions based on your file",
            //   ),
            // );
          } else {
            // User canceled the picker
          }
        }),
  ];
}
