import 'package:age_calculator/age_calculator.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'InputCustomField.dart';
import 'logic/models/models.dart';
import 'InputField.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'CustomerDetails.dart';
import 'logic/models/dataBase.dart';

List<String> saisonList = <String>['Laufender Sommer', 'Kommender Sommer'];
List<String> titleList = <String>['Herr', 'Frau', 'Divers'];

List<SwimCourse> swimCourses = [];
List<SwimPools> swimPools = [];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late Login login;
  late Booking booking;
  late Parent parent;
  late SwimStudent swimStudent;
  late Signup signup = Signup(login, booking, parent, swimStudent);
  final Summary summary = Summary();
  bool isLoading = true;
  int activeStepIndex = 0; // Initial step set to 0.
  int upperBound = 4; // upperBound MUST BE total number of icons minus 1.

  late String courseSelectedItem;
  String saisonValue = saisonList.first;
  String titleValue = titleList.first;

  bool isConfirmed = false;
  bool isCancelled = false;
  bool isGDPRConsent = false;

  TextEditingController lastName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController emailConfirm = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController phoneNumberConfirm = TextEditingController();

  TextEditingController lastNameParents = TextEditingController();
  TextEditingController firstNameParents = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController houseNumber = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  TextEditingController city = TextEditingController();

  late DateDuration _swimmerAge;
  var _initialDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Hier können Sie Ihre asynchronen Operationen durchführen
    fetchSwimCourses();
    fetchSwimPools();
  }

  Future<List<SwimCourse>> fetchSwimCourses() async {
    try {
      swimCourses = await getSwimCourses(); // Auf das Ergebnis warten
      courseSelectedItem = swimCourses.first.courseName;

      return swimCourses; // Liste von Swim-Kursen zurückgeben
    } catch (e) {
      // Hier können Sie Fehler behandeln, die in der getSwimCourses-Funktion auftreten
      // print('Error fetching swim courses: $e');
      return []; // Leere Liste zurückgeben, wenn ein Fehler auftritt
    }
  }

  Future<List<SwimPools>> fetchSwimPools() async {
    try {
      swimPools = await getSwimPools();
      // Setzen Sie isLoading auf false, um anzuzeigen, dass die Daten geladen sind
      setState(() {
        isLoading = false;
      });
      return swimPools; // Liste von Swim-Kursen zurückgeben
    } catch (e) {
      // Hier können Sie Fehler behandeln, die in der getSwimCourses-Funktion auftreten
      // print('Error fetching swim courses: $e');
      setState(() {
        isLoading = false;
      });
      return []; // Leere Liste zurückgeben, wenn ein Fehler auftritt
    }
  }

  Future<void> getMatchingCourse() async {
    // Jetzt können Sie die Liste der SwimCourses verwenden
    for (int i = 0; i < swimCourses.length; i++) {
      int minAlter, maxAlter;
      minAlter = int.parse(
          swimCourses[i].courseRange.split('_')[0].replaceAll("+", ""));
      maxAlter = int.parse(swimCourses[i].courseRange.split('_')[1]);

      if (_swimmerAge.years.clamp(minAlter, maxAlter) == _swimmerAge.years) {
        swimCourses[i].isCourseVisible = true;
        print(swimCourses[i]);
      } else {
        swimCourses[i].isCourseVisible = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Neukunden Anmeldung'),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/cropped-Logo-Wassermenschen.png"),
          )),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    IconStepper(
                      icons: const [
                        Icon(Icons.child_care),
                        Icon(Icons.flag),
                        Icon(Icons.view_timeline),
                        Icon(Icons.family_restroom),
                        Icon(Icons.summarize),
                      ],

                      // activeStep property set to activeStep variable defined above.
                      activeStep: activeStepIndex,

                      // This ensures step-tapping updates the activeStep.
                      onStepReached: (index) {
                        setState(() {
                          activeStepIndex = index;
                        });
                      },
                    ),
                    header(),
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16.0,
                            ),
                            body(),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: previousButton()),
                        const SizedBox(width: 30),
                        Expanded(child: nextButton()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Returns the next button.
  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );

          // Increment activeStep, when the next button is tapped. However, check for upper bound.
          if (activeStepIndex < upperBound) {
            setState(() {
              activeStepIndex++;
            });
            if (activeStepIndex == 1) {
              getMatchingCourse();
            } else if (activeStepIndex == 2) {
            } else if (activeStepIndex == upperBound) {
              summary.firstName = firstName.text;
              summary.lastName = lastName.text;
              summary.birthday = birthday.text;
              summary.saisonDropdownValue = saisonValue;
              summary.courseSelectedItem = courseSelectedItem;
              summary.swimPools = [];
              booking.swimPoolID = [];
              for (int i = 0; i < swimPools.length; i++) {
                if (swimPools[i].isSelected) {
                  summary.swimPools.add(swimPools[i].name);
                  booking.swimPoolID.add(swimPools[i].schwimmbadID);
                }
              }
              summary.titleValue = titleValue;
              summary.firstNameParents = firstNameParents.text;
              summary.lastNameParents = firstNameParents.text;
              summary.address = '${streetAddress.text} ${houseNumber.text}, '
                  '${zipCode.text} ${city.text}';
              summary.email = email.text;
              summary.phoneNumber = phoneNumber.text;
            } else if (activeStepIndex == upperBound) {
              // username is first latter from Firstname + '.' + lastname all in lowercase
              // "John Smith" ---> "jo.smith"
              login.user =
                  '${firstNameParents.text.substring(0, 2).toLowerCase()}'
                  '.'
                  '${lastNameParents.text.toLowerCase()}';
              // Verwenden Sie die split-Methode, um den Text nach dem Punkt zu teilen
              // von dd.MM.yyyy
              List<String> parts = birthday.text.split('.');
              // Übernehmen Sie die Teile in das gewünschte Format "ddMMyyyy"
              login.pass = "${parts[0]}${parts[1]}${parts[2]}";

              // booking.swimCourseID ---> set in Radio Methode
              // booking.swimPoolID  ---> set with summary
              //booking.parentID
              //booking.studentID
              //booking.dateID
              //booking.signupDate
              //booking.paymentStatus
              //booking.ebConfirmation
              //booking.teacherConfirmation
              //booking.ebCoursFrom
              //booking.criteriaStatus
              //booking.extension
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomerDetails(data: _customer.firstName)));
            }
          }
        }
      },
      child: activeStepIndex < upperBound
          ? const Text('Weiter')
          : const Text('Kostenpflichtig buchen'),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStepIndex > 0) {
          setState(() {
            activeStepIndex--;
          });
        } else {
          Navigator.pop(context);
        }
      },
      child:
          activeStepIndex > 0 ? const Text('Zurück') : const Text('Abrechen'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textAlign: TextAlign.center,
              headerText(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStepIndex) {
      case 0: // activeStep minus 1
        return 'Preface 1';

      case 1: // activeStep minus 1
        return 'Table of Contents 2';

      case 2: // activeStep minus 1
        return 'About the Author 3';

      case 3: // activeStep minus 1
        return 'Publisher Information 4';

      case 4: // activeStep minus 1
        return 'Reviews 5';

      default:
        return 'Error';
    }
  }

  Widget body() {
    switch (activeStepIndex) {
      case 0: // activeStep minus 1
        return stepOne();

      case 1: // activeStep minus 1
        return stepTow();

      case 2: // activeStep minus 1
        return stepThree();

      case 3: // activeStep minus 1
        return stepFour();

      case 4: // activeStep minus 1
        return stepFive();

      default:
        return const Column();
    }
  }

  Widget stepOne() {
    return Column(
      children: [
        InputCustomField(
          controller: firstName,
          labelText: "Vorname des Schwimmschülers",
          validatorText: 'firstName',
        ),
        InputField(
          controller: lastName,
          labelText: "Nachname des Schwimmschülers",
          // validatorText: 'lastName',
        ),
        TextField(
          controller: birthday,
          decoration: InputDecoration(
            label: const FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                children: [
                  Text(
                    'Geburtstag des Kindes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(3.0),
                  ),
                  Text('*',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            // errorText: errorText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          readOnly: true,
          onTap: () async {
            BottomPicker.date(
              initialDateTime: _initialDateTime,
              maxDateTime: DateTime.now(),
              title: "Bitte gib das Geburtsdatum deines Kindes ein",
              onChange: (date) {
                // print(date);
              },
              onSubmit: (date) {
                setState(() {
                  _swimmerAge = AgeCalculator.age(
                      DateTime.parse(DateFormat('yyyy-MM-dd').format(date)));
                  birthday.text = DateFormat('dd.MM.yyyy').format(date);
                  _initialDateTime = date;
                });
              },
            ).show(context);
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget stepTow() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8.0,
          ),
          InputDecorator(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                labelText:
                    'Für welche Sommer-Saison möchtest du den Kurs buchen?',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      isExpanded: true,
                      value: saisonValue,
                      items: saisonList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          saisonValue = value!;
                        });
                      }))),
          const SizedBox(
            height: 32,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Dem Alter entsprechende Kurse",
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: swimCourses.length,
            itemBuilder: (context, index) {
              return SizedBox(
                // height: 50, // Sie können die Höhe nach Bedarf festlegen oder entfernen
                child: Visibility(
                  visible: swimCourses[index].isCourseVisible,
                  child: Row(
                    children: [
                      Radio(
                        groupValue: courseSelectedItem,
                        value: swimCourses[index].courseName,
                        onChanged: (val) {
                          setState(() {
                            courseSelectedItem = val.toString();
                            booking.swimCourseID = swimCourses[index].courseID;
                          });
                        },
                      ),
                      Flexible(
                        child: Wrap(
                          children: [
                            Text(
                              '${swimCourses[index].courseName} '
                              '${swimCourses[index].coursePrice} €',
                              overflow: TextOverflow
                                  .visible, // Bei Bedarf können Sie Text Beschneidung hinzufügen
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => showCourseDescription(context, index),
                        icon: const Icon(
                          Icons.info_rounded,
                          color: Colors.blue,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "¹ Eine Kursübersicht über all unsere von uns angebotenen Kurse.",
            ),
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }

  Widget stepThree() {
    return Form(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Welche Bäder kommen für dich in Frage? *"),
              ),
              const Divider(
                thickness: 2,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: swimPools.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: swimPools[index].isSelected,
                                title: Text(swimPools[index].name),
                                onChanged: (val) {
                                  updateSwimPoolSelection(index, val!);
                                }),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () =>
                                  showCourseDescription(context, index),
                              icon: const Icon(
                                Icons.info_rounded,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          )
                        ],
                      ),
                    );
                  }),
              const SizedBox(
                height: 16.0,
              ),
              const Divider(
                thickness: 2,
              ),
              const Text('Für die Terminierung kommen wir bis zum 31. '
                  'Dezember auf dich zu.'),
            ],
          ),
        ),
      ),
    );
  }

  void updateSwimPoolSelection(int index, bool isSelected) {
    setState(() {
      swimPools[index].isSelected = isSelected;
    });
  }

  Widget stepFour() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(24.0),
                  color: const Color(0xFFE0E0E0)),
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      dropdownColor: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(24.0),
                      isExpanded: true,
                      value: titleValue,
                      items: titleList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          titleValue = value!;
                        });
                      })),
            ),
            const SizedBox(
              height: 8,
            ),
            InputField(
              controller: firstNameParents,
              labelText: "Vorname des Erziehungsberechtigten",
              // validatorText: 'firstName',
            ),
            InputField(
              controller: lastNameParents,
              labelText: "Nachname des Erziehungsberechtigten",
              // validatorText: 'lastName',
            ),
            InputField(
              controller: streetAddress,
              labelText: "Straße",
              // validatorText: 'lastName',
            ),
            InputField(
              controller: houseNumber,
              labelText: "Hausnummer",
              // validatorText: 'lastName',
            ),
            InputField(
              controller: zipCode,
              labelText: "PLZ",
              // validatorText: 'lastName',
            ),
            InputField(
              controller: city,
              labelText: "Ort",
              // validatorText: 'lastName',
            ),
            InputField(
              controller: email,
              labelText: "E-Mail",
              // validatorText: "Please enter a valid email",
              // inputTyp: "email",
            ),
            InputField(
              controller: emailConfirm,
              labelText: "E-Mail-Bestätigung",
              // validatorText: "Please enter a valid email",
              // inputTyp: "emailConfirm",
              // confirmValue: email.text
            ),
            const SizedBox(
              height: 8,
            ),
            IntlPhoneField(
              controller: phoneNumber,
              decoration: InputDecoration(
                label: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Handynummer '),
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(),
                ),
              ),
              initialCountryCode: 'DE',
              languageCode: 'DE',
              autovalidateMode: AutovalidateMode.disabled,
              cursorRadius: const Radius.circular(24.0),
              onChanged: (phoneNumber) {
                setState(() {
                  _customer.phoneNumber = phoneNumber.completeNumber;
                  _customer.whatsappNumber = phoneNumber.completeNumber;
                });
              },
            ),
            IntlPhoneField(
              controller: phoneNumberConfirm,
              decoration: InputDecoration(
                label: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Handynummer '),
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(),
                ),
              ),
              initialCountryCode: 'DE',
              languageCode: 'DE',
              autovalidateMode: AutovalidateMode.disabled,
              cursorRadius: const Radius.circular(24.0),
              invalidNumberMessage: 't',
              disableLengthCheck: true,
              onChanged: (phoneNumber) {
                setState(() {
                  _customer.phoneNumber = phoneNumber.completeNumber;
                  _customer.whatsappNumber = phoneNumber.completeNumber;
                });
              },
              validator: (value) {
                if (value?.completeNumber != phoneNumberConfirm.text) {
                  return 'tttt';
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget stepFive() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Card(
                elevation: 4, // Passen Sie die Elevation nach Bedarf an
                margin: const EdgeInsets.all(
                    8.0), // Passen Sie die Ränder nach Bedarf an
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Zusammenfassung der Eingaben:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Vorname: ${summary.firstName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nachname: ${summary.lastName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Geburtsdatum: ${summary.birthday}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Saison: ${summary.saisonDropdownValue}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Ausgewählter Kurs: ${summary.courseSelectedItem}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Ausgewählte Schwimmbäder: ${summary.swimPools.join(', ')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Title: ${summary.titleValue}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nachname: ${summary.lastNameParents}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Nachname: ${summary.firstNameParents}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Adresse: ${summary.address}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'E-Mail: ${summary.email}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Handynummer: ${summary.phoneNumber}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      // Fügen Sie hier weitere Felder hinzu, um die Zusammenfassung zu vervollständigen.
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 4, // Passen Sie die Elevation nach Bedarf an
              margin: const EdgeInsets.all(
                  8.0), // Passen Sie die Ränder nach Bedarf an
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zusätzliche Informationen:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Mit Deiner Anmeldebestätigung (Email) erhältst Du eine '
                      'Aufforderung zur Überweisung der Anzahlung von 100€. '
                      'Dieser Betrag muss innerhalb 7 Werktagen bei uns '
                      'verbucht sein. Andernfalls würden wir den Kursplatz '
                      'wieder freigeben - Deine Buchung stornieren.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Bestätigung *',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isConfirmed,
                      title: const Text('Mir ist bewusst, dass ich bis zu 30 '
                          'Minuten Anfahrt in Kauf nehmen muss.'),
                      onChanged: (bool? value) {
                        setState(() {
                          isConfirmed = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Stornierung *',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isCancelled,
                      title: const Text('Bei Stornierung nach dem 28.02. '
                          'verfällt die Anzahlung.'),
                      onChanged: (bool? value) {
                        setState(() {
                          isCancelled = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'DSGVO-Einverständnis *',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: isGDPRConsent,
                      title: const Text('Ich willige ein, dass diese Website '
                          'meine übermittelten Informationen speichert, '
                          'sodass meine Anfrage beantwortet werden kann.'),
                      onChanged: (bool? value) {
                        setState(() {
                          isGDPRConsent = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showCourseDescription(BuildContext context, int index) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Kurs Beschreibung'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Text(
                      'Kurs Name: ${swimCourses[index].courseName}',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Kurs Price: ${swimCourses[index].coursePrice} €',
                      textAlign: TextAlign.right,
                    ),
                  ],
                )),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else {
      return null;
    }
  }
}

class SwimPoolCheckbox {
  final String title, subTitle;
  bool isSelected;

  SwimPoolCheckbox(
      {required this.isSelected, required this.title, required this.subTitle});
}
