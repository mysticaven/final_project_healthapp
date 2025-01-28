// File: profile_page.dart
// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastStrokeDateController =
      TextEditingController();

// Add this method in the _ProfilePageState class
  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // State variables
  String? _affectedSide;
  String? _severityLevel;
  String? _strokeType;
  double _mobilityLevel = 5;
  Map<String, bool> _riskFactors = {
    'Hypertension': false,
    'Diabetes': false,
    'Atrial Fibrillation': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stroke Patient Profile'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildSectionHeader('Stroke Details'),
                const SizedBox(height: 16),

                // Stroke Type
                _buildDropdownField(
                  label: "Type of Stroke",
                  items: const ['Ischemic', 'Hemorrhagic', 'Unknown'],
                  validator: (value) => value == null ? 'Required field' : null,
                  onChanged: (value) => setState(() => _strokeType = value),
                ),
                const SizedBox(height: 16),

                // Affected Upper Limbs
                _buildDropdownField(
                  label: "Affected Upper Limb(s)",
                  items: const ['Left', 'Right', 'Both'],
                  validator: (value) => value == null ? 'Required field' : null,
                  onChanged: (value) => setState(() => _affectedSide = value),
                ),
                const SizedBox(height: 16),

                // Severity Level
                _buildDropdownField(
                  label: "Severity Level",
                  items: const ['Mild', 'Moderate', 'Severe'],
                  validator: (value) => value == null ? 'Required field' : null,
                  onChanged: (value) => setState(() => _severityLevel = value),
                ),
                const SizedBox(height: 16),

                // Upper Limb Mobility Slider
                _buildSliderField(
                  label: 'Upper Limb Mobility (1-10)',
                  currentValue: _mobilityLevel,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) => setState(() => _mobilityLevel = value),
                ),
                const SizedBox(height: 24),

                // ... rest of the form fields remain the same ...
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated slider field with state management
  Widget _buildSliderField({
    required String label,
    required double min,
    required double max,
    required int divisions,
    required double currentValue,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Slider(
          value: currentValue,
          min: min,
          max: max,
          divisions: divisions,
          label: currentValue.toStringAsFixed(0),
          onChanged: onChanged,
        ),
        Text(
          'Current Level: ${currentValue.toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.indigo[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Updated checkbox field with state management
  // ignore: unused_element
  Widget _buildCheckboxField({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Updated dropdown field with callback
  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required FormFieldValidator<String?> validator,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
          onChanged: onChanged,
        ),
      ],
    );
  }

// ... rest of the helper methods remain similar ...
}
