import 'package:flutter/material.dart';
import 'package:foodly_restaurant/constants/constants.dart';

class DateRangePickerWidget extends StatefulWidget {
  final String labelText;
  final Function(DateTime, DateTime) onDateRangeSelected;
  final Color backgroundColor; // Option to customize background color

  DateRangePickerWidget({
    required this.labelText,
    required this.onDateRangeSelected,
    this.backgroundColor = Colors.white, // Default background color
  });

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      widget.onDateRangeSelected(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDateRange(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: widget.backgroundColor, // Background color
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              startDate != null && endDate != null
                  ? "${startDate!.toLocal()} - ${endDate!.toLocal()}".split(' ')[0]
                  : "Select a date range",
              style: const TextStyle(fontSize: 16, color: kOffWhite),
            ),
          ),
        ),
      ],
    );
  }
}
