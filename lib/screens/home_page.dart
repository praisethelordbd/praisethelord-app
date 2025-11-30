import 'package:flutter/material.dart';
import 'package:praisethelord/helpers/update_helper.dart'; // নতুন Helper ইম্পোর্ট করা হয়েছে
import 'package:praisethelord/screens/song_list_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/navigation_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // অ্যাপ চালু হওয়ার পর ১ সেকেন্ড অপেক্ষা করে সাইলেন্টলি আপডেট চেক করবে
    // এটি নিশ্চিত করে যে হোম পেজটি প্রথমে লোড হয়েছে
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) { // নিশ্চিত করা হচ্ছে যে উইজেটটি এখনও স্ক্রিনে আছে
        UpdateHelper.checkForUpdate(context); // Helper-কে কল করা হচ্ছে
      }
    });
  }
  
  // URL লঞ্চ করার জন্য একটি মাত্র Helper ফাংশন
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open the link: $url')));
      }
    }
  }

  // ডোনেশন ডায়ালগ দেখানোর জন্য ফাংশন
  void _showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Row(children: [
            Icon(Icons.favorite_outline, color: Colors.red),
            SizedBox(width: 10),
            Expanded(child: Text('এই পরিচর্যার অংশ হোন'))
          ]),
          content: const SingleChildScrollView(
            child: Text(
              'এই অ্যাপ এবং আমাদের সকল পরিচর্যা সম্পূর্ণরূপে ঈশ্বরের অনুগ্রহে এবং আপনাদের মতো ভাই-বোনদের প্রার্থনা ও উদার সহযোগিতার উপর নির্ভরশীল। আমাদের কোনো বাণিজ্যিক উদ্দেশ্য নেই। আপনার সামান্য আর্থিক সহায়তা এই পরিচর্যাকে টিকিয়ে রাখতে এবং এর ভবিষ্যৎ পরিকল্পনা (যেমন: সার্ভার খরচ, অ্যাপ উন্নয়ন, নতুন ফিচার যোগ করা এবং অন্যান্য সেবামূলক কাজ) বাস্তবায়ন করতে সাহায্য করবে।',
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.5),
            ),
          ),
          actions: <Widget>[
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8.0,
              children: [
                TextButton(
                  child: const Text('বন্ধ করুন'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment, size: 18),
                  label: const Text('পরিচর্যায় সহায়তা করুন'),
                  onPressed: () {
                    _launchURL('https://praisethelordbd-ministry.blogspot.com/');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Praise the LORD"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.volunteer_activism_outlined),
            tooltip: 'Donate',
            onPressed: () => _showDonationDialog(context),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      drawer: const AppNavigationDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/a.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/logo.png', height: 150),
                const SizedBox(height: 30),
                const Text(
                  'খ্রীষ্টের বাক্যকে তোমাদের অন্তরে পরিপূর্ণভাবে বাস করতে দাও। ঈশ্বরের দেওয়া জ্ঞানে একে অন্যকে শিক্ষা ও পরামর্শ দাও এবং অন্তরে কৃতজ্ঞতার সংগে ঈশ্বরের উদ্দেশে গীতসংহিতার গান এবং আত্মিক ও প্রশংসার গান কর।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SongListPage()),
                  ),
                  child: Container(
                    height: 60,
                    width: 250,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/button.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Songs List',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(blurRadius: 5.0, color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}