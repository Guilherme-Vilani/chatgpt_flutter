import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter with chatGPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter with chatGPT'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterTts flutterTts = FlutterTts();
  List listaPerguntasRespostas = [];
  String onChanged = "";
  bool som = true;
  TextEditingController mensagemController = TextEditingController();
  stt.SpeechToText? _speech;
  bool _isListening = false;
  String mensagemFalada = "";

  Future speak(String mensagem) async {
    await flutterTts.speak(mensagem);
  }

  @override
  initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          som
              ? IconButton(
                  onPressed: () async {
                    setState(() {
                      som = false;
                    });

                    await flutterTts.stop();
                    await flutterTts.setVolume(0);
                  },
                  icon: const Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    setState(() {
                      som = true;
                    });

                    await flutterTts.setVolume(1);

                    // String text = listaPerguntasRespostas[
                    //     listaPerguntasRespostas.length - 1];

                    // await flutterTts.speak(text);
                  },
                  icon: const Icon(
                    Icons.volume_off,
                    color: Colors.white,
                  ),
                ),
          IconButton(
            onPressed: () {
              setState(() {
                listaPerguntasRespostas = [];
              });

              flutterTts.stop();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listaPerguntasRespostas.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () async {
                      print(listaPerguntasRespostas[index].toString());
                      flutterTts
                          .speak(listaPerguntasRespostas[index].toString());
                    },
                    onLongPress: () async {
                      // await ClipboardManager.copyToClipBoard(
                      //     listaPerguntasRespostas[index].toString());
                      Clipboard.setData(
                        ClipboardData(
                          text: listaPerguntasRespostas[index].toString(),
                        ),
                      );
                      toast("Texto copiado para área de transferência");
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              width: 1.0, color: Color(0xFFFF000000)),
                          left: BorderSide(
                              width: 1.0, color: Color(0xFFFF000000)),
                          right: BorderSide(
                              width: 1.0, color: Color(0xFFFF000000)),
                          bottom: BorderSide(
                              width: 1.0, color: Color(0xFFFF000000)),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        listaPerguntasRespostas[index].toString(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              flex: 1,
              child: onChanged == ""
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Stack(
                            children: [
                              TextField(
                                autofocus: true,
                                controller: mensagemController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Escreva aqui',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    onChanged = value;
                                  });
                                },
                              ),
                              Positioned(
                                right: 0,
                                top: 5,
                                child: IconButton(
                                  onPressed: onChanged == ""
                                      ? null
                                      : () async {
                                          await enviaMensagem(
                                              mensagemController.text);
                                        },
                                  icon: const Icon(Icons.send),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AvatarGlow(
                          animate: _isListening,
                          glowColor: Theme.of(context).primaryColor,
                          endRadius: 25.0,
                          duration: const Duration(milliseconds: 2000),
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          repeat: true,
                          child: FloatingActionButton(
                            onPressed: _listen,
                            child: Icon(_isListening ? Icons.stop : Icons.mic),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 50),
                            // color: Colors.red,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              autofocus: true,
                              controller: mensagemController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Escreva aqui',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  onChanged = value;
                                });
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: onChanged == ""
                                  ? null
                                  : () async {
                                      await enviaMensagem(
                                          mensagemController.text);
                                    },
                              icon: const Icon(Icons.send),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech!.listen(
          localeId: "pt-BR",
          onResult: (val) => setState(() {
            mensagemFalada = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech!.stop();
      // onChanged = mensagemController.text;
      await enviaMensagem(mensagemFalada);
    }
  }

  enviaMensagem(String mensagem) async {
    await flutterTts.setVoice({"name": "Luciana", "locale": "pt-BR"});

    setState(() {
      listaPerguntasRespostas.add(mensagem);
      mensagemController.text = "";
      onChanged = "";
    });

    await flutterTts.setVolume(1);

    try {
      await http
          .post(Uri.parse(
              "http://192.168.0.100:8000/envia-mensagem?mensagem=$mensagem"))
          .then((http.Response response) async {
        String resposta = jsonDecode(utf8.decode(response.bodyBytes));

        if (resposta != "") {
          setState(() {
            listaPerguntasRespostas.add(resposta);
          });
          await speak(resposta);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
