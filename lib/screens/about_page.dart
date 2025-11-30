import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _launchDonationURL(BuildContext context) async {
    final Uri url = Uri.parse(
        'https://praisethelordbd-ministry.blogspot.com/2025/06/blog-post.html'); // আপনার লিঙ্ক এখানে দিন
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary);
    final subtitleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(height: 1.5, fontSize: 16);

    return Scaffold(
      appBar: AppBar(title: const Text('আমাদের পরিচর্যা')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text('Praise the Lord BD', style: titleStyle)),
            const SizedBox(height: 16),
            _buildSection(
                title: 'আমাদের লক্ষ্য (Our Vision)',
                content:
                    '"Praise the Lord BD" শুধুমাত্র একটি মোবাইল অ্যাপ নয়, এটি একটি জীবন্ত পরিচর্যা। আমাদের মূল লক্ষ্য হলো প্রযুক্তির মাধ্যমে বাংলাভাষী খ্রীষ্ট বিশ্বাসী ভাই-বোনদেরকে ঈশ্বরের আরও নিকটবর্তী করা এবং একটি শক্তিশালী বিশ্বাসী সমাজ গড়ে তোলা।',
                titleStyle: subtitleStyle,
                contentStyle: bodyStyle),
            _buildDivider(),
            _buildSection(
                title: 'এই পরিচর্যার অংশ হোন',
                content:
                    'এই অ্যাপ এবং আমাদের সকল পরিচর্যা সম্পূর্ণরূপে ঈশ্বরের অনুগ্রহে এবং আপনাদের মতো ভাই-বোনদের প্রার্থনা ও উদার সহযোগিতার উপর নির্ভরশীল। আপনার সামান্য আর্থিক সহায়তা এই পরিচর্যাকে টিকিয়ে রাখতে এবং এর ভবিষ্যৎ পরিকল্পনা (যেমন: সার্ভার খরচ, অ্যাপ উন্নয়ন, নতুন ফিচার যোগ করা) বাস্তবায়ন করতে সাহায্য করবে।',
                titleStyle: subtitleStyle,
                contentStyle: bodyStyle),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.favorite_outline, color: Colors.white),
                label: const Text('পরিচর্যায় সহায়তা করুন',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () => _launchDonationURL(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            const SizedBox(height: 20),
            _buildDivider(),
            _buildSection(
                title: 'আমাদের বিশ্বাস (Statement of Faith)',
                content:
                    'আমরা বিশ্বাস করি যে, সমগ্র বাইবেল ঈশ্বরের শ্বাসপ্রাপ্ত, নির্ভুল ও জীবন্ত বাক্য এবং পরিত্রাণ কেবলমাত্র যীশু খ্রীষ্টের উপর বিশ্বাসের দ্বারাই লাভ করা যায়। আমরা পিতা, পুত্র ও পবিত্র আত্মার ত্রি-এক ঈশ্বরে বিশ্বাসী।',
                titleStyle: subtitleStyle,
                contentStyle: bodyStyle),
            const SizedBox(height: 24),
            Center(
                child: Text(
                    'সমস্ত গৌরব, প্রশংসা ও সম্মান যুগে যুগে কেবল তাঁরই হোক। আমেন।',
                    textAlign: TextAlign.center,
                    style: bodyStyle?.copyWith(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required String content,
      TextStyle? titleStyle,
      TextStyle? contentStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 8),
        Text(content, style: contentStyle, textAlign: TextAlign.justify),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Divider(thickness: 1, color: Colors.grey));
  }
}
