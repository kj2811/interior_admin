// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
// import 'package:interior_admin/model/enquiry.dart';
// import 'package:interior_admin/services/enquiry_service.dart';

// class AddEnquiryScreen extends StatefulWidget {
//   const AddEnquiryScreen({super.key});

//   @override
//   _AddEnquiryScreenState createState() => _AddEnquiryScreenState();
// }

// class _AddEnquiryScreenState extends State<AddEnquiryScreen> {
//   // Global key to manage form state and validation
//   final _formKey = GlobalKey<FormState>();

//   // Service to handle enquiry operations
//   final _enquiryService = EnquiryService();

//   // Controller for form fields to manage input
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   // Variables to store form data
//   String customerName = '';
//   String contactNumber = '';
//   String email = '';
//   String enquiryType = 'Telephonic'; // Default value
//   String description = '';

//   // List of enquiry types for dropdown
//   List<String> enquiryTypes = ['Telephonic', 'Email', 'Walk-in', 'Other'];

//   // Dispose controllers to prevent memory leaks
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _contactController.dispose();
//     _emailController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   // Validation for email
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter an email';
//     }
//     // Basic email validation regex
//     final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }

//   // Validation for phone number
//   String? _validatePhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a contact number';
//     }
//     // Basic phone number validation (10 digits)
//     final phoneRegex = RegExp(r'^[0-9]{10}$');
//     if (!phoneRegex.hasMatch(value)) {
//       return 'Please enter a valid 10-digit phone number';
//     }
//     return null;
//   }

//   // Submit form method
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       final enquiry = Enquiry(
//         id: const Uuid().v4(),
//         customerName: customerName,
//         contactNumber: contactNumber,
//         email: email,
//         enquiryType: enquiryType,
//         description: description,
//         dateTime: DateTime.now(),
//       );

//       try {
//         // Print file contents before adding
//         await _enquiryService.printFileContents();

//         // Add enquiry
//         await _enquiryService.addEnquiry(enquiry);

//         // Verify by retrieving enquiries
//         List<Enquiry> enquiries = await _enquiryService.getEnquiries();
//         print('Total enquiries after adding: ${enquiries.length}');

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Enquiry added successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );

//         Navigator.pop(context, true);
//       } catch (e) {
//         // More detailed error handling
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error adding enquiry: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );

//         // Optional: Print detailed error information
//         print('Detailed error: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // App bar
//       appBar: AppBar(
//         title: const Text('Add New Enquiry'),
//         centerTitle: true,
//       ),

//       // Body with form
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Customer Name Field
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Customer Name',
//                   prefixIcon: Icon(Icons.person),
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter customer name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => customerName = value!,
//               ),
//               const SizedBox(height: 16),

//               // Contact Number Field
//               TextFormField(
//                 controller: _contactController,
//                 decoration: const InputDecoration(
//                   labelText: 'Contact Number',
//                   prefixIcon: Icon(Icons.phone),
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: _validatePhone,
//                 onSaved: (value) => contactNumber = value!,
//               ),
//               const SizedBox(height: 16),

//               // Email Field
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: _validateEmail,
//                 onSaved: (value) => email = value!,
//               ),
//               const SizedBox(height: 16),

//               // Enquiry Type Dropdown
//               DropdownButtonFormField<String>(
//                 value: enquiryType,
//                 decoration: const InputDecoration(
//                   labelText: 'Enquiry Type',
//                   prefixIcon: Icon(Icons.category),
//                   border: OutlineInputBorder(),
//                 ),
//                 items: enquiryTypes.map((String type) {
//                   return DropdownMenuItem(
//                     value: type,
//                     child: Text(type),
//                   );
//                 }).toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     enquiryType = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Description Field
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   prefixIcon: Icon(Icons.description),
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter description';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => description = value!,
//               ),
//               const SizedBox(height: 24),

//               // Submit Button
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Submit Enquiry',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
