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
              color: Colors.white,
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
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          print(listaPerguntasRespostas[index].toString());
                          if (som) {
                            flutterTts.speak(listaPerguntasRespostas[index]
                                    ["resposta"]
                                .toString());
                          }
                        },
                        onDoubleTap: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: listaPerguntasRespostas[index].toString(),
                            ),
                          );

                          snackBar(
                            context,
                            title: 'Texto copiado para área de transferência',
                            behavior: SnackBarBehavior.floating,
                            textColor: Colors.blue,
                            backgroundColor: Colors.white,
                            elevation: 10,
                            // snackBarAction:
                            //     SnackBarAction(label: "teste", onPressed: (() {})),
                            margin: EdgeInsets.all(16),
                            duration: 2.seconds,
                          );
                        },

                        // se a gente apagar esse container e colocar o aligment no contianer de baico ele nao vai respentar o width
                        child: Container(
                          alignment: listaPerguntasRespostas[index]
                                      ["alignment"] ==
                                  "right"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          margin: const EdgeInsets.only(bottom: 10),
                          // color: Colors.red,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.7,
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
                              listaPerguntasRespostas[index]["resposta"]
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        alignment: listaPerguntasRespostas[index]
                                    ["alignment"] ==
                                "right"
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: listaPerguntasRespostas[index].toString(),
                              ),
                            );

                            snackBar(
                              context,
                              title: 'Texto copiado para área de transferência',
                              behavior: SnackBarBehavior.floating,
                              textColor: Colors.blue,
                              backgroundColor: Colors.white,
                              elevation: 10,
                              // snackBarAction:
                              //     SnackBarAction(label: "teste", onPressed: (() {})),
                              margin: EdgeInsets.all(16),
                              duration: 2.seconds,
                            );
                          },
                          icon: Icon(Icons.copy),
                        ),
                      )
                    ],
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
                                          enviaMensagem(
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
                                  : () {
                                      enviaMensagem(mensagemController.text);
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
      enviaMensagem(mensagemFalada);
    }
  }

  void enviaMensagem(String mensagem) async {
    await flutterTts.setVoice({"name": "Luciana", "locale": "pt-BR"});

    setState(() {
      dynamic objeto = {
        "alignment": "right",
        "resposta": mensagem,
      };

      listaPerguntasRespostas.add(objeto);
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
          dynamic objeto = {
            "alignment": "left",
            "resposta": resposta,
          };
          setState(() {
            listaPerguntasRespostas.add(objeto);
          });
          if (som) {
            await speak(resposta);
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
