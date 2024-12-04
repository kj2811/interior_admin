import 'package:flutter/material.dart';
import 'package:interior_admin/screens/enquiry/enquiry_list_page.dart';
import 'package:interior_admin/screens/enquiry/schedule_event_form.dart';
import 'package:interior_admin/utils/file_utils.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  List<Map<String, dynamic>> enquiries = [];

  @override
  void initState() {
    super.initState();
    _loadEnquiries();
  }

  Future<void> _loadEnquiries() async {
    try {
      final loadedEnquiries = await FileUtils.readEnquiries();
      setState(() {
        enquiries = loadedEnquiries;
      });
    } catch (e) {
      print('Error loading enquiries: $e');
    }
  }

  Future<void> _saveEnquiry(Map<String, dynamic> enquiry) async {
    try {
      await FileUtils.saveEnquiry(enquiry);
      setState(() {
        enquiries.add(enquiry);
      });
    } catch (e) {
      print('Error saving enquiry: $e');
    }
  }

  void _showScheduleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return ScheduleEventForm(onSubmit: (enquiry) => _saveEnquiry(enquiry));
      },
    );
  }

  void _showEnquiryList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnquiryListPage(enquiries: enquiries),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => _showEnquiryList(context),
            tooltip: 'Show Enquiries',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome, Manager!', style: TextStyle(fontSize: 18)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleModal(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Enquiry',
      ),
    );
  }
}
