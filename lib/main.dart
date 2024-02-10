import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing/gemini_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GeminiModel _responseModel;
  late final TextEditingController promptController;
  String responseText = '';
  String token = 'AIzaSyAgZ0d01pxPmS443PtTlL3M3er-EuodZCM';
  String url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=';

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
    promptController = TextEditingController();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343541),
      appBar: AppBar(
        title: Text(
          'GPT-3 Playground',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        backgroundColor: const Color(0xff343541),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PrompBuilder(responseText: responseText),
            _TextFormFieldBuilder(
                promptController: promptController, button: completion),
          ],
        ),
      ),
    );
  }

  completion() async {
    setState(() => responseText = 'Loading...');

    var response = await http.post(
      Uri.parse(url + token),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": promptController.text}
            ]
          }
        ]
      }),
    );

    // debugPrint(result['candidates'][0]['content']['parts'][0]['text']);
    setState(() {
      final jsonResponse = json.decode(response.body);
      _responseModel = GeminiModel.fromJson(jsonResponse);
      responseText = _responseModel.candidates[0].content.parts[0].text;
      debugPrint(responseText.toString());
    });

    //   curl \
    // -H 'Content-Type: application/json' \
    // -d '{"contents":[{"parts":[{"text":"Write a story about a magic backpack"}]}]}' \
    // -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY
  }
}

class _PrompBuilder extends StatelessWidget {
  const _PrompBuilder({
    required this.responseText,
  });

  final String responseText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.35,
      color: const Color(0xff434654),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              responseText,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextFormFieldBuilder extends StatelessWidget {
  const _TextFormFieldBuilder({
    required this.promptController,
    required this.button,
  });

  final TextEditingController promptController;
  final void Function() button;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              cursorColor: Colors.white,
              controller: promptController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff444653),
                    ),
                    borderRadius: BorderRadius.circular(5.5)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff444653),
                  ),
                ),
                filled: true,
                fillColor: const Color(0xff444653),
                hintText: 'I`m Gemini! Ask me anything!',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          Container(
            color: const Color(0xff19bc99),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: button,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
