import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<Map<String, String>> fetchRandomRaga() async {
  final response =
      await http.get(Uri.parse("https://tanarang.com/raag-index/"));

  if (response.statusCode == 200) {
    var raga =
        (parse(response.body).querySelectorAll("td.has-text-align-center")
              ..shuffle())
            .first
            .querySelector("a");

    return ({"name": raga!.text, "url": raga.attributes["href"]!});
  } else {
    throw Exception('Failed to load raga data');
  }
}

Future<Map<String, String>> fetchRagaDetails(String url) async {
  Map<String, String> parsedData = {};

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var ragaDetails =
        parse(response.body).querySelector("tbody")!.querySelectorAll("tr");

    for (var ragaDetail in ragaDetails) {
      var ragaDetailList = ragaDetail.querySelectorAll("td");
      parsedData[ragaDetailList[0].querySelector("a")!.text] =
          ragaDetailList[1].text;
    }

    return parsedData;
  } else {
    throw Exception('Failed to load raga data');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DailyRaga',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'DailyRaga'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            future: fetchRandomRaga(),
            builder: (BuildContext ctx,
                AsyncSnapshot<Map<String, String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading....');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        Text(snapshot.data!["name"]!),
                        FutureBuilder(
                            future: fetchRagaDetails(snapshot.data!["url"]!),
                            builder:
                                (BuildContext ctx, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const Text('Loading....');
                                default:
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Text(snapshot.data.toString());
                                  }
                              }
                            })
                      ],
                    );
                  }
              }
            }),
      ),
    );
  }
}