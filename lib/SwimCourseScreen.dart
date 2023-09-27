import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddSwimCourseScreen.dart';
import 'AppConfig.dart';
import 'logic/models/models.dart';

List<SwimCourse> swimCourse = [];

class SwimCourseScreen extends StatefulWidget {
  const SwimCourseScreen({Key? key}) : super(key: key);

  @override
  State<SwimCourseScreen> createState() => _SwimCourseScreenState();
}

class _SwimCourseScreenState extends State<SwimCourseScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getSwimCourses();
    super.initState();
  }

  Future<void> getSwimCourses() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.serverUrl}/getSwimCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // 'Access-Control-Allow-Origin': '*'
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['swim_courses'];

        setState(() {
          swimCourse = List<SwimCourse>.from(data.map((item) => SwimCourse(
                item['KursID'],
                item['Name'],
                item['Preis'],
                item['Beschreibung'],
                item['HatFixtermine'],
                item['Altersgruppe'],
                item['KursDauer'],
              )));
        });

        // Refresh the UI with fetched data
      } else {
        // Handle other status codes or errors
        print('Error while fetching data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error while fetching data: $e');
    }
  }

  Future<void> _refresh() async {
    // Funktion zum Aktualisieren der Daten hier aufrufen, z.B., getSwimPools()
    await getSwimCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schwimmkurse',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: swimCourse.length,
          itemBuilder: (context, index) {
            // final swimCourse = swimCourse[index];
            return Dismissible(
              key: Key(swimCourse[index].courseID.toString()),
              background: Container(
                color: Colors.red, // Hintergrundfarbe beim Löschen
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.orange, // Hintergrundfarbe beim Bearbeiten
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  // Hier können Sie den Löschvorgang implementieren.
                  swimCourse.removeAt(index);
                  return true; // Zurückgeben true, um den Kurs zu löschen.
                } else if (direction == DismissDirection.startToEnd) {
                  // Hier können Sie den Bearbeitungsvorgang implementieren.
                  // Zum Beispiel: Navigator.push(...) für eine Bearbeitungsseite.
                  return false; // Zurückgeben false, um den Kurs nicht zu löschen.
                }
                return false; // Standardmäßig keinen Vorgang durchführen.
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  child: ExpansionTile(
                    title: Text(
                      swimCourse[index].courseName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      swimCourse[index].coursePrice,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          swimCourse[index].courseDescription == null
                              ? ''
                              : swimCourse[index].courseDescription!,
                          // swimCourse[index].courseDescription!,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddSwimCourseScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
