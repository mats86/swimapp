import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AddSwimPoolScreen.dart';
import 'logic/models/models.dart';

List<SwimPool> swimPools = [];
List<OpenTime> openTimes = [];

class SwimPoolScreen extends StatefulWidget {
  const SwimPoolScreen({super.key});

  @override
  State<SwimPoolScreen> createState() => _SwimPoolScreenState();
}

class _SwimPoolScreenState extends State<SwimPoolScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getSwimPools();
    super.initState();
  }

  Future<void> getSwimPools() async {
    const String serverUrl =
        'https://healthy-reason-398307.ey.r.appspot.com'; // Replace with your server URL

    try {
      final response = await http.get(
        Uri.parse('$serverUrl/getSwimPools'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['swim_pools'];

        setState(() {
          swimPools = List<SwimPool>.from(data.map((item) => SwimPool(
                item['SchwimmbadID'],
                item['Name'],
                item['Adresse'],
                item['Telefonnummer'],
                item['Oeffnungszeiten'],
              )));

          final List<dynamic> openTimeData =
              jsonDecode(swimPools[0].openingTime);
          openTimes = [];
          for (int i = 0; i < openTimeData.length; i++) {
            openTimes.add(OpenTime(
              openTimeData[i]['day'],
              openTimeData[i]['openTime'],
              openTimeData[i]['closeTime'],
            ));
          }
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

  Future<bool> deleteSwimPool(int swimPoolID) async {
    const serverUrl =
        'http://10.0.2.2:5000'; // Ersetzen Sie dies durch Ihre Server-URL
    final response = await http.delete(
      Uri.parse('$serverUrl/deleteSwimPool/$swimPoolID'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Schwimmbad erfolgreich gelöscht.');
      return true; // Erfolg
    } else {
      print('Fehler beim Löschen des Schwimmbades: ${response.statusCode}');
      return false; // Fehler
    }
  }

  Future<void> _refresh() async {
    // Funktion zum Aktualisieren der Daten hier aufrufen, z.B., getSwimPools()
    await getSwimPools();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schwimmbäder'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: swimPools.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(swimPools[index]
                  .schwimmbadID
                  .toString()), // Eindeutiger Schlüssel für das Listen-element
              direction: DismissDirection
                  .horizontal, // Nur horizontale Wisch bewegungen erlauben
              background: Container(
                color: Colors.red, // Hintergrundfarbe für das Löschen
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                color: Colors.blue, // Hintergrundfarbe für das Bearbeiten
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Löschen bestätigen'),
                        content:
                            const Text('Möchten Sie dieses Element löschen?'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              final bool deleted = await deleteSwimPool(
                                  swimPools[index].schwimmbadID);

                              if (deleted) {
                                // Hier das Element aus der Liste entfernen
                                setState(() {
                                  swimPools.removeAt(index);
                                });
                              }

                              if (!context.mounted) return;
                              Navigator.of(context).pop(
                                  deleted); // Benutzer hat "Ja" ausgewählt und schließt den Dialog sofort
                            },
                            child: const Text('Ja'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Benutzer hat "Nein" ausgewählt
                            },
                            child: const Text('Nein'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (direction == DismissDirection.endToStart) {
                  final bool editConfirmed = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Bearbeiten bestätigen'),
                        content: const Text(
                            'Möchten Sie dieses Element bearbeiten?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Benutzer hat "Nein" ausgewählt
                            },
                            child: const Text('Nein'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // Benutzer hat "Ja" ausgewählt
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddSwimPoolScreen(
                                      swimPool: swimPools[index]),
                                ),
                              );
                            },
                            child: const Text('Ja'),
                          ),
                        ],
                      );
                    },
                  );
                  if (editConfirmed) {
                    // Hier das Element aus der Liste entfernen
                    setState(() {
                      swimPools.removeAt(index);
                    });
                  }
                  return false;
                } else if (direction == DismissDirection.startToEnd) {
                  // Aktion zum Löschen des Elements ausführen
                  return false;
                } else {
                  return false;
                }
              },

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: ExpansionTile(
                    title: Text(swimPools[index].name),
                    subtitle: Text(swimPools[index].address),
                    children: [
                      for (int i = 0; i < openTimes.length; i++)
                        Text(
                            '${openTimes[i].day}: ${openTimes[i].openTime} - ${openTimes[i].closeTime}'),
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
                  builder: (context) => const AddSwimPoolScreen()));
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
