import 'package:dailyraga/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:dailyraga/fn_raga_fetch.dart';

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

  Widget internetError(String err) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
              'Error: ${err.contains("errno = 7") ? "Can't reach the host!\nAre you connected to the internet?" : err}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )),
        ),
        ElevatedButton(
          onPressed: () => fetchRaga(),
          child: const Text('Try again'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RagaListScreen()),
                );
              },
              icon: const Icon(Icons.view_list)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.star_rounded)),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
              icon: const Icon(Icons.help)),
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: fetchRandomRaga(),
            builder: (BuildContext ctx,
                AsyncSnapshot<Map<String, String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    return internetError(snapshot.error.toString());
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "Raga ${snapshot.data!["name"]!}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => fetchRaga(),
                                  child: const Text('Fetch New Raga'),
                                )
                              ],
                            ),
                            FutureBuilder(
                              future: fetchRagaDetails(snapshot.data!["url"]!),
                              builder:
                                  (BuildContext ctx, AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  default:
                                    if (snapshot.hasError) {
                                      return internetError(
                                          snapshot.error.toString());
                                    } else {
                                      var (ragaTable, ragaParas) =
                                          snapshot.data;

                                      return Column(children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 0, 16, 0),
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: ragaTable
                                                .map<Widget>((row) => ListTile(
                                                      title: Text(
                                                          row['param'] ?? '',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      subtitle: Text(
                                                          row['val'] ?? ''),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                        ...ragaParas.map((para) => Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16),
                                              child: Text(para),
                                            ))
                                      ]);
                                    }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              }
            }),
      ),
    );
  }
}
