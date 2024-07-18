import 'package:dailyraga/fn_raga_fetch.dart';
import 'package:dailyraga/screens/screens.dart';
import 'package:flutter/material.dart';

class RagaListScreen extends StatefulWidget {
  const RagaListScreen({super.key});

  @override
  State<RagaListScreen> createState() => _RagaListScreenState();
}

class _RagaListScreenState extends State<RagaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _ragas = [];
  List<Map<String, String>> _filteredRagas = [];

  @override
  void initState() {
    super.initState();
    _fetchRagas();
    _searchController.addListener(_filterRagas);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRagas);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRagas() async {
    late List<Map<String, String>> ragas;
    try {
      ragas = await fetchAllRagas();
    } catch (err) {
      // Handle error
      ragas = [
        {"Error": err.toString()}
      ];
    }
    setState(() {
      _ragas = ragas;
      _filteredRagas = ragas;
    });
  }

  void _filterRagas() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRagas = _ragas
          .where((raga) => raga["name"]!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Raga List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              leading: const Icon(Icons.search),
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _ragas.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _ragas[0].containsKey("Error")
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(32),
                                child: Text(
                                  'Error: ${_ragas[0]["Error"]!.contains("errno = 7") ? "Can't reach the host!\nAre you connected to the internet?" : _ragas[0]["Error"]!}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: _fetchRagas,
                                  child: const Text("Try again!"))
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemBuilder: (BuildContext ctx, int i) {
                            return ListTile(
                              title: Text(_filteredRagas[i]["name"]!),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RagaDetailScreen(
                                        raga: _filteredRagas[i]["name"]!,
                                        url: _filteredRagas[i]["url"]!),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (BuildContext _, int __) =>
                              const Divider(indent: 20, endIndent: 20),
                          itemCount: _filteredRagas.length,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
