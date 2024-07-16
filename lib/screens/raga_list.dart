import 'package:dailyraga/fn_raga_fetch.dart';
import 'package:dailyraga/screens/screens.dart';
import 'package:flutter/material.dart';

class RagaListScreen extends StatefulWidget {
  const RagaListScreen({super.key});

  @override
  State<RagaListScreen> createState() => _RagaListScreenState();
}

class _RagaListScreenState extends State<RagaListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Raga List"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: FutureBuilder(
        future: fetchAllRagas(),
        builder: (BuildContext ctx,
            AsyncSnapshot<List<Map<String, String>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                      itemBuilder: (BuildContext ctx, int i) {
                        return ListTile(
                          title: Text(snapshot.data![i]["name"]!),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RagaDetailScreen(
                                    raga: snapshot.data![i]["name"]!,
                                    url: snapshot.data![i]["url"]!),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (BuildContext _, int __) =>
                          const Divider(indent: 20, endIndent: 20),
                      itemCount: snapshot.data!.length),
                );
              }
          }
        },
      ),
    );
  }
}
