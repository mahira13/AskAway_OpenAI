import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controller/home_screen_controller.dart';
import '../../utils/app_strings.dart';
import 'api_key.dart';
import '../../models/openai/openai_request_model.dart';
import '../../models/openai/openai_response_model.dart';

class OpenaiApiService {
  HomeScreenController homeScreenController = Get.find();
  static final Uri openaiUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${OpenaiApiKey.openaiApiKey}',
  };

  Future<String?> request(ChatMessage prompt) async {
    homeScreenController.messages.insert(0, prompt);
    homeScreenController.typingUsers.add(homeScreenController.gptChatUser);

    try {
      OpenaiRequestModel request = OpenaiRequestModel(
          model: "gpt-3.5-turbo",
          maxTokens: 150,
          messages: [Message(role: "system", content: prompt.text)]);

      http.Response response = await http.post(
        openaiUri,
        headers: headers,
        body: request.toJson(),
      );
      if (response.statusCode == 200) {
        OpenaiResponseModel chatResponse =
            OpenaiResponseModel.fromResponse(response);

        for (var element in chatResponse.choices!) {
          if (element.message != null) {
            homeScreenController.messages.insert(
                0,
                ChatMessage(
                    user: homeScreenController.gptChatUser,
                    createdAt: DateTime.now(),
                    text: element.message!.content ?? ""));
          }
        }

        homeScreenController.typingUsers
            .remove(homeScreenController.gptChatUser);
      } else {
        homeScreenController.typingUsers
            .remove(homeScreenController.gptChatUser);
        homeScreenController.snackbarMessage.value = errorMessage;
        return homeScreenController.snackbarMessage.value;
        // throw Exception('Error in API');
      }
    } catch (e) {
      homeScreenController.snackbarMessage.value = e.toString();
      return homeScreenController.snackbarMessage.value;
    }
    return null;
  }
}
