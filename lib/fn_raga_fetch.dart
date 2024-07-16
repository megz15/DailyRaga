import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

Future<List<String>> fetchAllRagas() async {
  final response =
      await http.get(Uri.parse("https://tanarang.com/raag-index/"));

  if (response.statusCode == 200) {
    var raga = parse(response.body)
        .querySelectorAll("td.has-text-align-center")
        .map((td) => td.querySelector("a")!.text)
        .toList();

    return (raga);
  } else {
    throw Exception('Failed to load ragas');
  }
}

Future<Map<String, String>> fetchRandomRaga() async {
  // return {
  //   "name": "Bhoopali",
  //   "url": "/wordpress/raag-bhoopali/",
  // };

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
  // return (
  //   [
  //     {
  //       "param": "Swar",
  //       "val": "Gandhar and Nishad Komal. Rest all Shuddha Swaras."
  //     },
  //     {"param": "Jati", "val": "Sampurna - Sampurna"},
  //     {"param": "Thaat", "val": "Kafi"},
  //     {"param": "Vadi - Samvadi", "val": "Pancham - Shadj"},
  //     {"param": "Time", "val": "2nd Prahar of the Night (9PM to 12AM)"},
  //     {"param": "Vishranti Sthan", "val": "S P - S' P R;"},
  //     {"param": "Mukhya Ang", "val": "g R ; m P ; m P D P ; D n S' ; n D P;"},
  //     {"param": "Aaroh - Avroh", "val": "S R g m P D n S'; - S' n D P m g R S;"}
  //   ],
  //   [
  //     "",
  //     "Raag Bhoopali is a tranquil soft melody that fills up a new life force in the environment with the dominant Gandhar strengthened by the Swayambhu Gandhar from the Kharja of the Taanpura. It belongs to Kalyan Thaat and is also known as Raag Bhoop.",
  //     "In Raag Bhoopali, one should be very careful not to use Dhaivat as a resting note and not give much prominence to Dhaivat, otherwise Raag Deshkar will come into existence which has the same set of Notes as Raag Bhoopali. While taking a Meend from Shadj to Dhaivat or from Pancham to Gandhar, one should be very careful about not using Nishad and Madhyam respectively as a Kan-Swar, otherwise Raag Shuddha Kalyan will come into existence. Gandhar-Dhaivat Sangati is very important in Bhoopali and Rishabh is the Nyas Swar. ",
  //     "Raag Bhoopali is popular as Raag Mohan in Carnatic Music. It is a Poorvang Pradhan Raag and is mostly sung in Madhya and Mandra octaves. It creates a deep and soothing atmosphere. The following illustrative combinations clearly bring out the melodic format:",
  //     "S ; S ,D S R G ; R G S R ,D S ; S R G P ; P G R G ; R P G ; G S R ; R ,D S ; G R G ; P G ; P D P P ; D P ; G P R G R S ,D S ; S R G R G P D S’ ; P D P S’ ; S’ S’ ; R’ S’ D S’ ; D S’ R’ G’ R’ S’ ; D S’ D P G R G ; P R G R S ; R ,D S ; ",
  //     ""
  //   ]
  // );

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

    parsedParas.removeWhere((item) => item.isEmpty);

    return (parsedTable, parsedParas);
  } else {
    throw Exception('Failed to load raga data');
  }
}
