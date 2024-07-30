import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Info'),
        actions: [
          IconButton(
            icon: Icon(
              _isAuthenticated ? Icons.lock_open : Icons.lock,
            ),
            onPressed: () async {
              await _toggleAuthentication();
            },
          ),
        ],
      ),
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Future<void> _toggleAuthentication() async {
    if (!_isAuthenticated) {
      final bool canAuthenticateWithBiometrics =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (canAuthenticateWithBiometrics) {
        try {
          final bool didAuthenticate = await _auth.authenticate(
            localizedReason: 'Please authenticate to show account balance',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
          );
          setState(() {
            _isAuthenticated = didAuthenticate;
          });
        } catch (e) {
          print(e);
        }
      }
    } else {
      // Log out or reset authentication
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: _toggleAuthentication,
      child: Icon(
        _isAuthenticated ? Icons.lock_open : Icons.lock,
      ),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Account Balance",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isAuthenticated)
                  const Text(
                    "\$ 25,632",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (!_isAuthenticated)
                  const Text(
                    "******",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          if (_isAuthenticated)
            Expanded(
              child: ListView(
                children: [
                  _buildInfoTile('Total Investments', '\$ 150,000'),
                  _buildInfoTile(
                      'Total Transaction Limit', '\$ 10,000 per month'),
                  _buildInfoTile('Annual Tax Return', '\$ 5,000'),
                  _buildInfoTile('Other Info', 'Details here...'),
                  // Add more tiles as needed
                ],
              ),
            ),
          if (!_isAuthenticated)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Authenticate to view detailed account information.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      leading: Icon(Icons.account_balance_wallet), // Optional leading icon
      trailing: Icon(Icons.arrow_forward_ios), // Optional trailing icon
      onTap: () {
        // Handle tap event, e.g., navigate to detail page
      },
    );
  }
}
