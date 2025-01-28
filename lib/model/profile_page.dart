import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastStrokeDateController = TextEditingController();

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
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[800],
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stroke Patient Profile'),
          backgroundColor: Colors.grey[900],
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                // Risk Factors
                _buildSectionHeader('Risk Factors'),
                const SizedBox(height: 16),
                ..._riskFactors.keys.map((factor) {
                  return CheckboxListTile(
                    title: Text(factor, style: const TextStyle(color: Colors.white)),
                    value: _riskFactors[factor],
                    onChanged: (value) {
                      setState(() {
                        _riskFactors[factor] = value!;
                      });
                    },
                    activeColor: Colors.blue,
                  );
                }).toList(),
                const SizedBox(height: 24),

                // Last Stroke Date
                _buildSectionHeader('Last Stroke Date'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastStrokeDateController,
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _selectDate,
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _saveProfile,
          child: const Icon(Icons.save),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
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
          activeColor: Colors.blue,
          inactiveColor: Colors.grey[600],
        ),
        Text(
          'Current Level: ${currentValue.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
          onChanged: onChanged,
          dropdownColor: Colors.grey[800],
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _lastStrokeDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Save logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}