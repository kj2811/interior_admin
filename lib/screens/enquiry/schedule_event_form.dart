import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleEventForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const ScheduleEventForm({required this.onSubmit, super.key});

  @override
  State<ScheduleEventForm> createState() => _ScheduleEventFormState();
}

class _ScheduleEventFormState extends State<ScheduleEventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  Future<void> _pickDateTime(
      BuildContext context, bool isStart, bool isDate) async {
    if (isDate) {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (pickedDate != null) {
        setState(() {
          if (isStart) {
            _startDate = pickedDate;
          } else {
            _endDate = pickedDate;
          }
        });
      }
    } else {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          if (isStart) {
            _startTime = pickedTime;
          } else {
            _endTime = pickedTime;
          }
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _startTime != null &&
        _endDate != null &&
        _endTime != null) {
      final startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      final endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      widget.onSubmit({
        'title': _titleController.text.trim(),
        'name': _nameController.text.trim(),
        'contact': _contactController.text.trim(),
        'description': _descriptionController.text.trim(),
        'startDate': startDateTime.toIso8601String(),
        'endDate': endDateTime.toIso8601String(),
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('hh:mm a');

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Contact number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Date'),
                      subtitle: Text(
                        _startDate != null
                            ? dateFormatter.format(_startDate!)
                            : 'Select Date',
                      ),
                      leading: const Icon(Icons.calendar_today),
                      onTap: () => _pickDateTime(context, true, true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(
                        _startTime != null
                            ? _startTime!.format(context)
                            : 'Select Time',
                      ),
                      leading: const Icon(Icons.access_time),
                      onTap: () => _pickDateTime(context, true, false),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('End Date'),
                      subtitle: Text(
                        _endDate != null
                            ? dateFormatter.format(_endDate!)
                            : 'Select Date',
                      ),
                      leading: const Icon(Icons.calendar_today),
                      onTap: () => _pickDateTime(context, false, true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(
                        _endTime != null
                            ? _endTime!.format(context)
                            : 'Select Time',
                      ),
                      leading: const Icon(Icons.access_time),
                      onTap: () => _pickDateTime(context, false, false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
