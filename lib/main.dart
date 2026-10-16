import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Profile Card',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Digit terakhir NIM 20240801044 -> d = 4
  static const double cardPadding = 20; // 16 + 4
  static const double cardRadius = 12; // 8 + 4
  static const double buttonHeight = 44; // 40 + 4
  static const double buttonRadius = 8; // 4 + 4
  static const double avatarSize = 48; // 40 + (2 x 4)
  static const double nameNimGap = 12; // 8 + 4

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar diameter 48 -> radius 24
                  const SizedBox(
                    width: avatarSize,
                    height: avatarSize,
                    child: CircleAvatar(
                      radius: avatarSize / 2,
                      child: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Rafi Adriyan Ramadhan'),
                  const SizedBox(height: nameNimGap),
                  const Text('20240801044'),
                  const SizedBox(height: 16),
                  const Text('Teknik Informatika, Universitas Esa Unggul'),
                  const SizedBox(height: 16),
                  const Text(
                    'Mahasiswa Teknik Informatika yang tertarik pada web '
                    'development, keamanan informasi, dan pengembangan '
                    'aplikasi mobile.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const AppButton(
                    label: 'Kunjungi GitHub Saya',
                    icon: Icons.code,
                    url: 'https://github.com/fira-aho',
                    height: buttonHeight,
                    borderRadius: buttonRadius,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
