import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class OpenaiApiKey {
  static String openaiApiKey = "YOUR_API_KEY";
  static OpenAI openAI = OpenAI.instance.build(
      token:openaiApiKey,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 20)),
      enableLog: true);
static String assistantId= 'asst_EkDQAzxkse5cxey5feX9grhJ';
}
