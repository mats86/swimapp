import 'package:flutter/material.dart';
import 'CustomerDashboard.dart';
import 'CustomerList.dart';
import 'SignUpScreen.dart';
import 'SwimCourseScreen.dart';
import 'SwimPoolScreen.dart';
import 'logic/models/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  bool get useLightMode {
    switch (_themeMode) {
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: MyHomePage(
        title: 'Schwimmschule Allgäu',
        useLightMode: useLightMode,
        handleBrightnessChange: (useLightMode) {
          setState(() {
            _themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.handleBrightnessChange,
    required this.useLightMode,
  }) : super(key: key);

  final String title;
  final bool useLightMode;
  final void Function(bool useLightMode) handleBrightnessChange;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget _buildElevatedButton(String text, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(220, 40),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/images/cropped-Logo-Wassermenschen.png"),
        ),
        actions: <Widget>[
          _BrightnessButton(
            handleBrightnessChange: widget.handleBrightnessChange,
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/WM-Head-BG.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildElevatedButton('Schwimmkurs buchen', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              }),
              const SizedBox(
                height: 8.0,
              ),
              _buildElevatedButton('Schwimmbäder', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SwimPoolScreen(),
                  ),
                );
              }),
              const SizedBox(
                height: 8.0,
              ),
              _buildElevatedButton('Kurse', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SwimCourseScreen(),
                  ),
                );
              }),
              const SizedBox(
                height: 8.0,
              ),
              _buildElevatedButton('Login', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerDashboard(),
                  ),
                );
              }),
              const SizedBox(
                height: 8.0,
              ),
              _buildElevatedButton('Kunde', () {
                final List<Customer> customers = [
                  Customer('Kunde 1', 'Aktiv'),
                  Customer('Kunde 2', 'Inaktiv'),
                  Customer('Kunde 3', ''),
                  Customer('Kunde 4', ''),
                  Customer('Kunde 5', ''),
                ];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerList(customers),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BrightnessButton extends StatelessWidget {
  const _BrightnessButton({
    required this.handleBrightnessChange,
    this.showTooltipBelow = true,
  });

  final Function handleBrightnessChange;
  final bool showTooltipBelow;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      preferBelow: showTooltipBelow,
      message: 'Toggle brightness',
      child: IconButton(
        icon: isBright
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
        onPressed: () => handleBrightnessChange(!isBright),
      ),
    );
  }
}
