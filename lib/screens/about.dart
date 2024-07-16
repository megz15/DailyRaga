import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("About DailyRaga"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "DailyRaga is a simple app to show a random raga with its key attributes upon opening. The primary motivation was that I wanted to find and take on new ragas, and get suggestions on what raga to play when I would play the sarod.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network("https://i.imgur.com/L08nSl9.png",
                    width: 150,
                    height: 150, loadingBuilder: (BuildContext context,
                        Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 150,
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const Text("... and that's me :)"),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () =>
                      launchUrl(Uri.parse("https://swaranjali.vercel.app/")),
                  child: const Text("Visit Swaranjali Web!"),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () => launchUrl(
                      Uri.parse("https://swaranjali.vercel.app/naadgen")),
                  child: const Text("Try out NaadGen!"),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () =>
                      launchUrl(Uri.parse("https://github.com/megz15/")),
                  child: const Text("Check out my GitHub"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
