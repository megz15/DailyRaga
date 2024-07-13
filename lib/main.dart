import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<Map<String, String>> fetchRandomRaga() async {
  // return {"name": "Bhoopali", "url": "/wordpress/raag-bhoopali/"};

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

Future<(List<Map<String, String>>, List<String>)> fetchRagaDetails(
    String url) async {
  // return [
  //   {
  //     "param": "Swar",
  //     "val": "Gandhar and Nishad Komal. Rest all Shuddha Swaras."
  //   },
  //   {"param": "Jati", "val": "Sampurna - Sampurna"},
  //   {"param": "Thaat", "val": "Kafi"},
  //   {"param": "Vadi - Samvadi", "val": "Pancham - Shadj"},
  //   {"param": "Time", "val": "2nd Prahar of the Night (9PM to 12AM)"},
  //   {"param": "Vishranti Sthan", "val": "S P - S' P R;"},
  //   {"param": "Mukhya Ang", "val": "g R ; m P ; m P D P ; D n S' ; n D P;"},
  //   {"param": "Aaroh - Avroh", "val": "S R g m P D n S'; - S' n D P m g R S;"}
  // ];

  List<Map<String, String>> parsedTable = [];
  List<String> parsedParas = [];

  final response = await http.get(
      Uri.parse(url.startsWith("https") ? url : "https://tanarang.com$url"));

  if (response.statusCode == 200) {
    var ragaDetails = parse(response.body);

    var ragaTable = ragaDetails.querySelector("tbody")!.querySelectorAll("tr");

    for (var ragaDetail in ragaTable) {
      var ragaDetailList = ragaDetail.querySelectorAll("td");
      parsedTable.add({
        "param": ragaDetailList[0].querySelector("a")!.text,
        "val": ragaDetailList[1].text
      });
    }

    var h4 = ragaDetails.querySelector("h4");
    var paraIndex = h4!.parent!.children.indexOf(h4) - 1;

    parsedParas = ragaDetails
        .querySelectorAll("p")
        .sublist(0, paraIndex)
        .map((p) => p.text)
        .toList();

    return (parsedTable, parsedParas);
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
  Map<String, String>? ragaData;

  @override
  void initState() {
    super.initState();
    fetchRaga();
  }

  Future<void> fetchRaga() async {
    ragaData = await fetchRandomRaga();
    setState(() {});
  }

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
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("Raga ${snapshot.data!["name"]!}"),
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
                                    var (ragaTable, ragaParas) = snapshot.data;

                                    return Column(
                                      children: <Widget>[
                                            DataTable(
                                              columns: const [
                                                DataColumn(
                                                    label: Text('Parameter')),
                                                DataColumn(
                                                    label: Text('Value')),
                                              ],
                                              rows:
                                                  ragaTable.map<DataRow>((row) {
                                                return DataRow(cells: [
                                                  DataCell(
                                                      Text(row['param'] ?? '')),
                                                  DataCell(
                                                      Text(row['val'] ?? '')),
                                                ]);
                                              }).toList(),
                                            ),
                                          ] +
                                          <Text>[
                                            for (var para in ragaParas)
                                              Text(para)
                                          ],
                                    );
                                  }
                              }
                            },
                          ),
                          ElevatedButton(
                              onPressed: () => fetchRaga(),
                              child: const Text('Fetch Random Raga'))
                        ],
                      ),
                    );
                  }
              }
            }),
      ),
    );
  }
}
