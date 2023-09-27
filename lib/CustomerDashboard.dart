import 'package:flutter/material.dart';

class Choice {
  final String title;
  final Icon icon;

  Choice(this.title, this.icon);
}

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool showFab = true; // Zustandsvariable für die Anzeige des FAB

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(
        _updateFabVisibility); // Listener für Änderungen im TabController hinzufügen
  }

  void _updateFabVisibility() {
    // Überprüfen, ob die erste oder dritte Registerkarte ausgewählt ist
    setState(() {
      showFab = _tabController.index == 0 || _tabController.index == 2;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_updateFabVisibility); // Listener entfernen
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Choice> tabs = [
      Choice('Active', const Icon(Icons.add)),
      Choice(
          'Inactive',
          const Icon(
            Icons.done,
            color: Colors.green,
          )),
      Choice('Inactive', const Icon(Icons.image)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kunden-Dashboard'),
      ),
      body: Column(
        children: [
          // Header-Bereich mit Profilbild
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kundenname'),
                CircleAvatar(
                  // backgroundImage: AssetImage('assets/profile_image.jpg'),
                  radius: 30.0,
                ),
              ],
            ),
          ),
          // Tab-Bar oder Navigationsleiste
          TabBar(
              controller: _tabController,
              tabs: tabs
                  .map((tab) => Tab(
                        // text: tab.title,
                        icon: tab.icon,
                      ))
                  .toList()),
          // Inhalt der ausgewählten Registerkarte
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Gebuchte Kurse anzeigen
                ListView.builder(
                  itemCount: gebuchteKurse.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      courseName: gebuchteKurse[index].name,
                      date: gebuchteKurse[index].date,
                      time: gebuchteKurse[index].time,
                      location: gebuchteKurse[index].location,
                    );
                  },
                ),
                // Abgeschlossene Kurse anzeigen
                ListView.builder(
                  itemCount: abgeschlosseneKurse.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      courseName: abgeschlosseneKurse[index].name,
                      date: abgeschlosseneKurse[index].date,
                      time: abgeschlosseneKurse[index].time,
                      location: abgeschlosseneKurse[index].location,
                    );
                  },
                ),
                // Kundeninformationen anzeigen
                const CustomerInfo(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              onPressed: () {
                // Aktion, die bei Klick auf den FAB ausgeführt werden soll
              },
              child: const Icon(Icons.add),
            )
          : null, // FAB ausblenden, wenn nicht auf Tab 1 oder Tab 3
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final String date;
  final String time;
  final String location;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.date,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(courseName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datum: $date'),
            Text('Uhrzeit: $time'),
            Text('Ort: $location'),
          ],
        ),
      ),
    );
  }
}

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 32.0, top: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kundeninformationen',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              Text('Name: ${customerInfo.name}'),
              Text('E-Mail: ${customerInfo.email}'),
              Text('Kontakt: ${customerInfo.contactNumber}'),
              // Hier kannst du weitere Informationen hinzufügen
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: gebuchteKurse.length,
            itemBuilder: (context, index) {
              return CourseCard(
                courseName: gebuchteKurse[index].name,
                date: gebuchteKurse[index].date,
                time: gebuchteKurse[index].time,
                location: gebuchteKurse[index].location,
              );
            },
          ),
        ),
      ],
    );
  }
}

// Dummy-Werte für gebuchte Kurse
List<Course> gebuchteKurse = [
  Course(
      name: 'Kurs 1', date: '01.09.2023', time: '10:00 Uhr', location: 'Ort 1'),
  Course(
      name: 'Kurs 2', date: '03.09.2023', time: '14:30 Uhr', location: 'Ort 2'),
  Course(
      name: 'Kurs 3', date: '05.09.2023', time: '09:15 Uhr', location: 'Ort 3'),
];

// Dummy-Werte für abgeschlossene Kurse
List<Course> abgeschlosseneKurse = [
  Course(
      name: 'Kurs A', date: '20.08.2023', time: '13:45 Uhr', location: 'Ort X'),
  Course(
      name: 'Kurs B', date: '25.08.2023', time: '16:30 Uhr', location: 'Ort Y'),
];

// Dummy-Werte für Kundeninformationen
class CustomerInfoT {
  final String name;
  final String email;
  final String contactNumber;

  CustomerInfoT({
    required this.name,
    required this.email,
    required this.contactNumber,
  });
}

CustomerInfoT customerInfo = CustomerInfoT(
  name: 'Max Mustermann',
  email: 'max.mustermann@example.com',
  contactNumber: '+49 123456789',
);

class Course {
  final String name;
  final String date;
  final String time;
  final String location;

  Course({
    required this.name,
    required this.date,
    required this.time,
    required this.location,
  });
}
