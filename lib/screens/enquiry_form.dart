import 'package:flutter/material.dart';
import '../constants/colors.dart';

class EnquiryForm extends StatefulWidget {
  const EnquiryForm({super.key});

  @override
  State<EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _ownerMobileController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _contactPersonController.dispose();
    _ownerMobileController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryTeal,
        centerTitle: true,
        title: const Text(
          'New Enquiry',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // // Modern curved header
          // Container(
          //   height: 16,
          //   decoration: BoxDecoration(
          //     color: AppColors.primaryTeal,
          //     borderRadius: const BorderRadius.vertical(
          //       bottom: Radius.circular(32),
          //     ),
          //   ),
          // ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormSection('Client Information', [
                        _buildCompactField(
                          controller: _nameController,
                          label: 'Company/Client Name',
                          icon: Icons.business,
                          validator:
                              (v) => v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        _buildCompactField(
                          controller: _addressController,
                          label: 'Address',
                          icon: Icons.location_on,
                          maxLines: 2,
                        ),
                      ]),
                      _buildFormSection('Contact Details', [
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactField(
                                controller: _phoneController,
                                label: 'Phone',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactField(
                                controller: _ownerMobileController,
                                label: 'Mobile',
                                icon: Icons.phone_android,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        _buildCompactField(
                          controller: _contactPersonController,
                          label: 'Contact Person',
                          icon: Icons.person,
                        ),
                      ]),
                      _buildFormSection('Additional Details', [
                        _buildCompactField(
                          controller: _reviewController,
                          label: 'Notes',
                          icon: Icons.note,
                          maxLines: 3,
                        ),
                      ]),
                      const SizedBox(height: 24),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCompactField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int? maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: AppColors.primaryTeal),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryTeal,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: maxLines! > 1 ? 16 : 12,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            letterSpacing: 0.3,
          ),
          floatingLabelStyle: const TextStyle(
            color: AppColors.primaryTeal,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontSize: 14, letterSpacing: 0.3),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryTeal,
            AppColors.primaryTeal.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitEnquiry,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          'Submit Enquiry',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _submitEnquiry() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Create enquiry model and send to API
      final enquiryData = {
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'contactPerson': _contactPersonController.text,
        'ownerMobile': _ownerMobileController.text,
        'review': _reviewController.text,
      };

      // Show success message and return to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enquiry submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }
}
