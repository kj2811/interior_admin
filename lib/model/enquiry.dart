class Enquiry {
  final String id;
  final String customerName;
  final String contactNumber;
  final String email;
  final String enquiryType;
  final String description;
  final DateTime dateTime;

  Enquiry({
    required this.id,
    required this.customerName,
    required this.contactNumber,
    required this.email,
    required this.enquiryType,
    required this.description,
    required this.dateTime,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['id'],
      customerName: json['customerName'],
      contactNumber: json['contactNumber'],
      email: json['email'],
      enquiryType: json['enquiryType'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'contactNumber': contactNumber,
      'email': email,
      'enquiryType': enquiryType,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
