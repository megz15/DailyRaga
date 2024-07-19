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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'DailyRaga',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' is a simple app to show a random raga with its key attributes upon opening. The primary motivation was that I wanted to find and take on new ragas, and get suggestions on what raga to play when I would play the sarod.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset("lib/assets/images/me.png",
                      width: 150, height: 150),
                ),
                const Text("... and that's me :)"),
                const SizedBox(height: 32),
                const Text(
                  "The ragas are currently sourced from Tanarang, alternate sources will be added in future releases.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      launchUrl(Uri.parse("https://tanarang.com/")),
                  child: const Text("Visit Tanarang.com"),
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "Feeling inspired? Check out my other project "),
                      TextSpan(
                        text: 'NaadGen',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' and start making your own compositions!',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => launchUrl(
                          Uri.parse("https://swaranjali.vercel.app/naadgen")),
                      child: const Text("NaadGen"),
                    ),
                    ElevatedButton(
                      onPressed: () => launchUrl(
                          Uri.parse("https://swaranjali.vercel.app/")),
                      child: const Text("Swaranjali Web"),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    IconButton(
                        onPressed: () =>
                            launchUrl(Uri.parse("https://github.com/megz15/")),
                        icon: Image.asset("lib/assets/images/github.png",
                            width: 64, height: 64)),
                    IconButton(
                        onPressed: () => launchUrl(
                            Uri.parse("https://www.instagram.com/megh.835/")),
                        icon: Image.asset("lib/assets/images/insta.png",
                            width: 64, height: 64)),
                    IconButton(
                        onPressed: () => launchUrl(
                            Uri.parse("mailto:meghraj.g16@gmail.com")),
                        icon: Image.asset("lib/assets/images/mail.png",
                            width: 64, height: 64))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
