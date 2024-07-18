import 'package:dailyraga/fn_raga_fetch.dart';
import 'package:flutter/material.dart';

class RagaDetailScreen extends StatefulWidget {
  const RagaDetailScreen({super.key, required this.raga, required this.url});
  final String raga;
  final String url;

  @override
  State<RagaDetailScreen> createState() => _RagaDetailScreenState();
}

class _RagaDetailScreenState extends State<RagaDetailScreen> {
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
          onPressed: () => () {},
          child: const Text('Try again!'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Raga ${widget.raga}"),
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
      ),
      body: Center(
          child: FutureBuilder(
        future: fetchRagaDetails(widget.url),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return internetError(snapshot.error.toString());
              } else {
                var (ragaTable, ragaParas) = snapshot.data;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: ragaTable
                              .map<Widget>((row) => ListTile(
                                    title: Text(row['param'] ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                    subtitle: Text(row['val'] ?? ''),
                                  ))
                              .toList(),
                        ),
                      ),
                      ...ragaParas.map((para) => Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(para),
                          ))
                    ]),
                  ),
                );
              }
          }
        },
      )),
    );
  }
}
