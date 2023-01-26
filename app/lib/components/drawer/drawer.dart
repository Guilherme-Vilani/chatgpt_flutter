import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.amber,
                width: 1,
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Image.asset(
                filterQuality: FilterQuality.high,
                "assets/images/lampada3.png",
                fit: BoxFit.cover,
                // width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
            child: ListTile(
              leading: Image.asset("assets/images/github1.png"),
              title: Text("Link para o projeto no GitHub"),
              onTap: () async {
                const url =
                    'https://github.com/Guilherme-Vilani/chatgpt_flutter';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
