import 'package:flutter/material.dart';
import '../common/colo_extension.dart'; // Assuming you have TColor defined here

class RoundDropdownButton extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String hintText;
  final IconData? icon; // Icon parameter, using an IconData instead of an image path

  const RoundDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.icon = Icons.person, // Default icon if none is provided
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: (newValue) {
          // Disable Teacher selection
          if (newValue != 'Teacher') {
            onChanged?.call(newValue);
          }
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(
                    icon, // Icon is added next to text
                    color: TColor.gray,
                    size: 20, // Adjust icon size as needed
                  ),
                  const SizedBox(width: 15), // Add space between the icon and the text
                  Text(
                    value,
                    style: TextStyle(color: TColor.gray, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        hint: Text(
          hintText,
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
        underline: Container(), // Remove the underline from the dropdown
        isExpanded: true, // Make it take up the full width
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_drop_down,
            color: TColor.gray,
          ),
        ),
        iconSize: 35, // You can adjust this size as needed
      ),
    );
  }
}
