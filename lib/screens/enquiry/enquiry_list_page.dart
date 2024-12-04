import 'package:flutter/material.dart';

class EnquiryListPage extends StatelessWidget {
  final List<Map<String, dynamic>> enquiries;

  const EnquiryListPage({required this.enquiries, super.key});

  @override
  Widget build(BuildContext context) {
    final sortedEnquiries = [...enquiries];
    sortedEnquiries.sort((a, b) => DateTime.parse(a['startDate'])
        .compareTo(DateTime.parse(b['startDate'])));

    return Scaffold(
      appBar: AppBar(title: const Text("Enquiry List")),
      body: ListView.builder(
        itemCount: sortedEnquiries.length,
        itemBuilder: (context, index) {
          final enquiry = sortedEnquiries[index];
          return ListTile(
            title: Text(enquiry['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact: ${enquiry['contact']}"),
                Text(
                    "Start Date: ${DateTime.parse(enquiry['startDate']).toLocal()}"),
                if (enquiry['endDate'] != null)
                  Text(
                      "End Date: ${DateTime.parse(enquiry['endDate']).toLocal()}"),
                Text("Description: ${enquiry['description']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
