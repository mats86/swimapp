import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'InputField.dart';
import 'SwimPoolScreen.dart';
import 'InputCustomOpeningTime.dart';
import 'logic/models/models.dart';

class AddSwimPoolScreen extends StatefulWidget {
  final SwimPool? swimPool;
  const AddSwimPoolScreen({Key? key, this.swimPool}) : super(key: key);

  @override
  State<AddSwimPoolScreen> createState() => _AddSwimPoolScreenState();
}

class _AddSwimPoolScreenState extends State<AddSwimPoolScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController swimPoolName = TextEditingController();
  final TextEditingController swimPoolStreet = TextEditingController();
  final TextEditingController swimPoolStreetNr = TextEditingController();
  final TextEditingController swimPoolZipCode = TextEditingController();
  final TextEditingController swimPoolCity = TextEditingController();
  final TextEditingController swimPoolPhoneNumber = TextEditingController();

  bool isNewSwimPool = true;
  int schwimmbadID = 0;

  final List<TextEditingController> swimPoolOpeningHours =
      List<TextEditingController>.generate(
    14,
    (index) => TextEditingController(),
  );

  final List<String> weekdays = [
    'Montag',
    'Dienstag',
    'Mittwoch',
    'Donnerstag',
    'Freitag',
    'Samstag',
    'Sonntag'
  ];

  Future<void> addSwimPool() async {
    const String serverUrl =
        'http://10.0.2.2:5000'; // Ersetzen Sie dies durch die URL Ihres Servers
    final String address = '${swimPoolStreet.text} '
        '${swimPoolStreetNr.text}, '
        '${swimPoolZipCode.text} '
        '${swimPoolCity.text}';
    final List<OpenTime> openingTimes = weekdays.asMap().entries.map((entry) {
      final int i = entry.key;
      return OpenTime(
        entry.value,
        swimPoolOpeningHours[i * 2].text,
        swimPoolOpeningHours[i * 2 + 1].text,
      );
    }).toList();

    final SwimPool swimPool = SwimPool(
      schwimmbadID,
      swimPoolName.text,
      address,
      swimPoolPhoneNumber.text,
      jsonEncode(openingTimes),
    );

    final body = jsonEncode(swimPool);

    try {
      final response = await http.post(
        Uri.parse('$serverUrl/addSwimPool'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('Schwimmbad erfolgreich hinzugefügt.');
      } else {
        print('Fehler beim Hinzufügen des Schwimmbads: ${response.statusCode}');
      }
    } catch (e) {
      print('Fehler beim Hinzufügen des Schwimmbads: $e');
    }
  }

  Future<void> updateSwimPool() async {
    const String serverUrl =
        'http://10.0.2.2:5000'; // Ersetzen Sie dies durch die URL Ihres Servers

    final String address = '${swimPoolStreet.text} '
        '${swimPoolStreetNr.text}, '
        '${swimPoolZipCode.text} '
        '${swimPoolCity.text}';

    final List<OpenTime> openingTimes = weekdays.asMap().entries.map((entry) {
      final int i = entry.key;
      return OpenTime(
        entry.value,
        swimPoolOpeningHours[i * 2].text,
        swimPoolOpeningHours[i * 2 + 1].text,
      );
    }).toList();

    final SwimPool updatedPool = SwimPool(
      schwimmbadID,
      swimPoolName.text,
      address,
      swimPoolPhoneNumber.text,
      jsonEncode(openingTimes),
    );

    final body = jsonEncode(updatedPool);

    try {
      final response = await http.put(
        Uri.parse(
            '$serverUrl/updateSwimPool/$schwimmbadID'), // Hier verwenden wir die Schwimmbad-ID für die Aktualisierung
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('Schwimmbad erfolgreich aktualisiert.');
      } else {
        print(
            'Fehler beim Aktualisieren des Schwimmbads: ${response.statusCode}');
      }
    } catch (e) {
      print('Fehler beim Aktualisieren des Schwimmbads: $e');
    }
  }

  Future<void> deleteSwimPool() async {
    const serverUrl =
        'http://10.0.2.2:5000'; // Ersetzen Sie dies durch Ihre Server-URL
    final response = await http.delete(
      Uri.parse('$serverUrl/deleteSwimPool/$schwimmbadID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Schwimmbad erfolgreich gelöscht.');
      // Führen Sie hier die Aktualisierung Ihrer UI oder Datenquelle durch, um das gelöschte Schwimmbad zu entfernen.
    } else {
      print('Fehler beim Löschen des Schwimmbads: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.swimPool != null) {
      isNewSwimPool = false;
      schwimmbadID = widget.swimPool!.schwimmbadID;
      // Verwenden Sie einen regulären Ausdruck, um die Teile des Strings zu extrahieren
      RegExp regex = RegExp(r'^(.+)\s(\d+),\s(\d+)\s(.+)$');
      Match? match = regex.firstMatch(widget.swimPool!.address);

      String street = "";
      String streetNr = "";
      String zipCode = "";
      String city = "";

      if (match != null) {
        // Extrahieren Sie die Teile aus dem regulären Ausdruck und speichern Sie sie in Variablen
        street = match.group(1)!;
        streetNr = match.group(2)!;
        zipCode = match.group(3)!;
        city = match.group(4)!;
      } else {
        print("Keine Übereinstimmung gefunden.");
      }

      swimPoolName.text = widget.swimPool!.name;
      swimPoolStreet.text = street;
      swimPoolStreetNr.text = streetNr;
      swimPoolZipCode.text = zipCode;
      swimPoolCity.text = city;
      swimPoolPhoneNumber.text = widget.swimPool!.phoneNumber;
      final List<dynamic> openTimeData = jsonDecode(swimPools[0].openingTime);
      for (int i = 0; i < openTimeData.length; i++) {
        swimPoolOpeningHours[i * 2].text = openTimeData[i]['openTime'];
        swimPoolOpeningHours[i * 2 + 1].text = openTimeData[i]['closeTime'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> openingTimeWidgets = weekdays.map((day) {
      final int index = weekdays.indexOf(day);
      return InputCustomOpeningTime(
        controllerFrom: swimPoolOpeningHours[index * 2],
        controllerTo: swimPoolOpeningHours[index * 2 + 1],
        dayLabelText: day,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Neues Schwimmbad hinzufügen')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                InputField(
                  controller: swimPoolName,
                  labelText: "Schwimmbad Name",
                  // validatorText: "Schwimmbad Name",
                ),
                InputField(
                  controller: swimPoolStreet,
                  labelText: "Straße",
                  // validatorText: "Straße",
                ),
                InputField(
                  controller: swimPoolStreetNr,
                  labelText: "Straße Nummer",
                  // validatorText: "Straße Nummer",
                ),
                InputField(
                  controller: swimPoolZipCode,
                  labelText: "PLZ",
                  // validatorText: "PLZ",
                ),
                InputField(
                  controller: swimPoolCity,
                  labelText: "Stadt",
                  // validatorText: "Stadt",
                ),
                InputField(
                  controller: swimPoolPhoneNumber,
                  labelText: "Telefonnummer",
                  // validatorText: "Telefonnummer",
                ),
                ...openingTimeWidgets,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: previousButton(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: nextButton(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          isNewSwimPool ? await addSwimPool() : await updateSwimPool();

          if (!context.mounted) return;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SwimPoolScreen()));
        }
      },
      child: isNewSwimPool
          ? const Text('Neues Schwimmbad hinzufügen')
          : const Text('Schwimmbad aktualisieren'),
    );
  }

  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Abbrechen'),
    );
  }
}
