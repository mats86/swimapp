class Signup {
  Login login;
  Booking booking;
  Parent parent;
  SwimStudent swimStudent;

  Signup(
    this.login,
    this.booking,
    this.parent,
    this.swimStudent,
  )

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'booking': booking,
      'parent': parent,
      'swimStudent': swimStudent
    };
  }

}
class Login {
  int loginID;
  String user;
  String pass;

  Login(this.loginID, this.user, this.pass);

  Map<String, dynamic> toJson() {
    return {'loginID': loginID, 'user': user, 'pass': pass};
  }
}

class Booking {
  int bookingID;
  int swimCourseID;
  List<int> swimPoolID;
  int parentID;
  int studentID;
  int dateID;
  String signupDate;
  String paymentStatus;
  String ebConfirmation;
  String teacherConfirmation;
  String ebCoursFrom;
  String criteriaStatus;
  String extension;

  Booking(
    this.bookingID,
    this.swimCourseID,
    this.swimPoolID,
    this.parentID,
    this.studentID,
    this.dateID,
    this.signupDate,
    this.paymentStatus,
    this.ebConfirmation,
    this.teacherConfirmation,
    this.ebCoursFrom,
    this.criteriaStatus,
    this.extension,
  );

  Map<String, dynamic> toJson() {
    return {
      'bookingID': bookingID,
      'swimCourseID': swimCourseID,
      'swimPoolID': swimPoolID,
      'parentID': parentID,
      'studentID': studentID,
      'dateID': dateID,
      'signupDate': signupDate,
      'paymentStatus': paymentStatus,
      'ebConfirmation': ebConfirmation,
      'teacherConfirmation': teacherConfirmation,
      'ebCoursFrom': ebCoursFrom,
      'criteriaStatus': criteriaStatus,
      'extension': extension,
    };
  }
}

class Parent {
  int parentID;
  int loginID;
  List<int> studentID;
  String parentStatus;
  String parentFirstname;
  String parentLastname;
  String parentPhoneNumber;
  String parentWhatsapp;
  String parentEmail;
  String parentBalance;

  Parent(
      this.parentID,
      this.loginID,
      this.studentID,
      this.parentStatus,
      this.parentFirstname,
      this.parentLastname,
      this.parentPhoneNumber,
      this.parentWhatsapp,
      this.parentEmail,
      this.parentBalance);

  Map<String, dynamic> toJson() {
    return {
      'parentID': parentID,
      'loginID': loginID,
      'studentID': studentID,
      'parentStatus': parentStatus,
      'parentFirstname': parentFirstname,
      'parentLastname': parentLastname,
      'parentPhoneNumber': parentPhoneNumber,
      'parentWhatsapp': parentWhatsapp,
      'parentEmail': parentEmail,
      'parentBalance': parentBalance,
    };
  }
}

class SwimStudent {
  int studentID;
  String certificate;
  String status;
  String firstname;
  String lastname;
  String phoneNumber;
  String email;
  String parent;
  String property;
  String notes;

  SwimStudent(
      this.studentID,
      this.certificate,
      this.status,
      this.firstname,
      this.lastname,
      this.phoneNumber,
      this.email,
      this.parent,
      this.property,
      this.notes);

  Map<String, dynamic> toJson() {
    return {
      'studentID': studentID,
      'certificate': certificate,
      'status': status,
      'firstname': firstname,
      'lastname': lastname,
      'phoneNumber': phoneNumber,
      'email': email,
      'parent': parent,
      'property': property,
      'notes': notes
    };
  }
}

class SwimCourse {
  final int courseID;
  final String courseName;
  final String coursePrice;
  final String? courseDescription;
  final int courseHasFixedDates;
  final String courseRange;
  final String courseDuration;
  bool isCourseVisible = false;

  SwimCourse(
    this.courseID,
    this.courseName,
    this.coursePrice,
    this.courseDescription,
    this.courseHasFixedDates,
    this.courseRange,
    this.courseDuration,
  );

  Map<String, dynamic> toJson() {
    return {
      'CourseID': courseID,
      'courseName': courseName,
      'coursePrice': coursePrice,
      'courseDescription': courseDescription,
      'courseHasFixedDates': courseHasFixedDates,
      'courseRange': courseRange,
      'courseDuration': courseDuration,
      'isCourseVisible': isCourseVisible
    };
  }
}

class OpenTime {
  late String day;
  late String openTime;
  late String closeTime;

  OpenTime(this.day, this.openTime, this.closeTime);

  OpenTime.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
  }

  Map toJson() => {
        'day': day,
        'openTime': openTime,
        'closeTime': closeTime,
      };
}

class SwimPool {
  final int schwimmbadID;
  final String name;
  final String address;
  final String phoneNumber;
  final String openingTime;

  SwimPool(this.schwimmbadID, this.name, this.address, this.phoneNumber,
      this.openingTime);

  Map<String, dynamic> toJson() {
    return {
      'schwimmbadID': schwimmbadID,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'openingTime': openingTime,
    };
  }
}

class SwimPools {
  final int schwimmbadID;
  final String name;
  final String address;
  final String phoneNumber;
  final List<OpenTime> openingTime;
  bool isSelected = false;

  SwimPools(this.schwimmbadID, this.name, this.address, this.phoneNumber,
      this.openingTime);

  Map<String, dynamic> toJson() {
    return {
      'schwimmbadID': schwimmbadID,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'openingTime': openingTime,
      'isSelected': isSelected,
    };
  }
}

class Summary {
  String firstName = '';
  String lastName = '';
  String birthday = '';
  String saisonDropdownValue = '';
  String courseSelectedItem = '';
  List<String> swimPools = [];
  String titleValue = '';
  String firstNameParents = '';
  String lastNameParents = '';
  String address = '';
  String email = '';
  String phoneNumber = '';
// Fügen Sie hier weitere Felder hinzu, um die Zusammenfassung zu vervollständigen.
}
