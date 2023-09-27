import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'InputField.dart';
import 'AppConfig.dart';
import 'logic/models/models.dart';

class AddSwimCourseScreen extends StatefulWidget {
  const AddSwimCourseScreen({super.key});

  @override
  State<AddSwimCourseScreen> createState() => _AddSwimCourseScreenState();
}

List<String> courseHasFixedDatesOptions = ['Nein', 'Ja'];

class _AddSwimCourseScreenState extends State<AddSwimCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController courseName = TextEditingController();
  TextEditingController coursePrise = TextEditingController();
  TextEditingController courseDescription = TextEditingController();
  TextEditingController courseHasFixedDates = TextEditingController();
  TextEditingController courseAeRangeMin = TextEditingController();
  TextEditingController courseAeRangeMax = TextEditingController();
  TextEditingController courseFixedDates = TextEditingController();
  TextEditingController courseDuration = TextEditingController();

  bool isNewCourse = true;
  int courseID = 0;

  String currentOption = courseHasFixedDatesOptions[0];
  int courseHasFixDatesValue = 0;
  bool isFixedDatesVisible = false;

  Future<void> addSwimCourse() async {
    final SwimCourse swimCourse = SwimCourse(
      courseID,
      courseName.text,
      coursePrise.text,
      courseDescription.text,
      isFixedDatesVisible ? 1 : 0,
      '${courseAeRangeMin.text}_${courseAeRangeMax.text}',
      courseDuration.text,
    );

    final body = jsonEncode(swimCourse);

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.serverUrl}/addCourse'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        print('Kurs erfolgreich hinzugefügt.');
      } else {
        print('Fehler beim Hinzufügen des Kurs: ${response.statusCode}');
      }
    } catch (e) {
      print('Fehler beim Hinzufügen des Kurs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neuen Schwimmkurs hinzufügen')),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InputField(
                    controller: courseName,
                    labelText: "Kurs Name",
                    // validatorText: '',
                  ),
                  InputField(
                    controller: coursePrise,
                    labelText: "Kurs Price",
                    // validatorText: '',
                  ),
                  InputField(
                    controller: courseDescription,
                    labelText: "Kurs Beschreibung",
                    // validatorText: '',
                    // maxLines: null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: courseAeRangeMin,
                          labelText: "Min Alter",
                          // validatorText: '',
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: InputField(
                          controller: courseAeRangeMax,
                          labelText: "Max Alter",
                          // validatorText: '',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    // width: 400,
                    child: InputDecorator(
                      decoration: InputDecoration(
                          labelText: 'Hat diese Kurs Fixetermine?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(courseHasFixedDatesOptions[0]),
                                  leading: Radio(
                                    value: courseHasFixedDatesOptions[0],
                                    groupValue: currentOption,
                                    onChanged: (value) {
                                      setState(() {
                                        currentOption = value!;
                                        isFixedDatesVisible = false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(courseHasFixedDatesOptions[1]),
                                  leading: Radio(
                                    value: courseHasFixedDatesOptions[1],
                                    groupValue: currentOption,
                                    onChanged: (value) {
                                      setState(() {
                                        currentOption = value.toString();
                                        isFixedDatesVisible = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: isFixedDatesVisible,
                              child: InputField(
                                controller: courseFixedDates,
                                labelText: "Max Alter",
                                // validatorText: '',
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    controller: courseDuration,
                    labelText: "Kurs Dauer",
                    // validatorText: '',
                  ),
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
          )),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          isNewCourse ? await addSwimCourse() : await addSwimCourse();

          if (!context.mounted) return;
          // Navigator.pop(context);
        }
      },
      child: isNewCourse
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
