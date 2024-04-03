import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:translator/translator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String insult = "";
  final translator = GoogleTranslator();
  TextEditingController controller = TextEditingController();
  String? translatedInsult;
  bool isLoading = false;
  List<String> favorites = [];

  Future<void> _fetchJoke() async {
    final client = http.Client();
    setState(() {
      isLoading = true;
    });
    const url = 'https://evilinsult.com/generate_insult.php?lang=en&type=json';

    final response = await client.get(
      Uri.parse(
        url,
      ),
      headers: {
        'Accept': 'application/json',
      },
    );
    final jsonResponse = jsonDecode(response.body);
    setState(() {
      insult = jsonResponse['insult'];
      isLoading = false;
    });

    client.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Evil Insults",
          style: TextStyle(color: Color.fromARGB(255, 255, 0, 0), fontSize: 30),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              insult.isNotEmpty
                  ? Text(
                      insult,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      "Press the button to fetch an insult",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
              if (isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _fetchJoke,
                child: const Text("Fetch Evil Insult"),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text("Do you like it?"),
              FilledButton(
                onPressed: () {
                  setState(() {
                    favorites.add(insult);
                  });
                },
                child: const Text("Save Evil Insult"),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Tranlate to:"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                    onPressed: () {
                      GoogleTranslator()
                          .translate(insult, to: 'es')
                          .then((spainValue) {
                        setState(() {
                          translatedInsult = spainValue.text;
                        });
                      });
                    },
                    child: const Text("SPA"),
                  ),
                  FilledButton(
                    onPressed: () {
                      GoogleTranslator()
                          .translate(insult, to: 'de')
                          .then((germanValue) {
                        setState(() {
                          translatedInsult = germanValue.text;
                        });
                      });
                    },
                    child: const Text("GER"),
                  ),
                  FilledButton(
                    onPressed: () {
                      GoogleTranslator()
                          .translate(insult, to: 'it')
                          .then((italianValue) {
                        setState(() {
                          translatedInsult = italianValue.text;
                        });
                      });
                    },
                    child: const Text("ITA"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "translation",
                  ),
                  controller: TextEditingController(
                    text: translatedInsult ?? '',
                  ),
                  readOnly: true,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/favorites');
          }
        },
      ),
    );
  }
}
