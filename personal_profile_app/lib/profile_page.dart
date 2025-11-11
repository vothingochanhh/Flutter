import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ProfilePage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('lib/assets/avt_profile.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              'Yen Nhi Nguyen',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'Flutter Developer | Student',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Widget được yêu cầu: Card & ListTile
            _buildInfoCard(context),
            const SizedBox(height: 16),
            _buildSkillsCard(context),
            const SizedBox(height: 16),
            _buildSocialsCard(context),
          ],
        ),
      ),
    );
  }

  // --- Giao diện cho màn hình rộng (Tablet) ---
  Widget _buildWideLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần bên trái: Avatar và Tên
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Yen Nhi Nguyen',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text(
                    'Flutter Developer | Student',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 32),
            // Phần bên phải: Các Card thông tin
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildInfoCard(context),
                  const SizedBox(height: 16),
                  _buildSkillsCard(context),
                  const SizedBox(height: 16),
                  _buildSocialsCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Các Widget con (Tái sử dụng cho cả 2 layout) ---

  // Thẻ thông tin cá nhân
  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('yennhing.work@gmail.com'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.green),
              title: Text('+84 123 456 789'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.red),
              title: Text('Da Nang, Vietnam'),
            ),
          ],
        ),
      ),
    );
  }

  // Thẻ kỹ năng
  Widget _buildSkillsCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Skills', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              // Tự động xuống dòng khi hết chỗ
              spacing: 8.0,
              runSpacing: 4.0,
              children: const [
                Chip(label: Text('Flutter')),
                Chip(label: Text('Dart')),
                Chip(label: Text('Firebase')),
                Chip(label: Text('UI/UX Design')),
                Chip(label: Text('Git')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Thẻ mạng xã hội
  Widget _buildSocialsCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.code), // Thay bằng logo GitHub
              title: const Text('GitHub'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL('https://github.com/nhingyen'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.person_search,
              ), // Thay bằng logo LinkedIn
              title: const Text('LinkedIn'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _launchURL('https://linkedin.com/in/yennhing'),
            ),
          ],
        ),
      ),
    );
  }
}
