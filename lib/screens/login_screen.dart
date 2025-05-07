import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selco_app/screens/dashboard_screen.dart';
import 'package:selco_app/screens/main_screen.dart';
import 'package:selco_app/utils/glass_morphism.dart';
import '../constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.backgroundGrey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryTeal.withOpacity(0.1),
              AppColors.backgroundGrey,
              Colors.white.withOpacity(0.2),
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GlassMorphism(
                start: 0.1,
                end: 0.2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildLoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form _buildLoginForm() => Form(
    key: _formKey,
    child: Column(
      children: [
        const SizedBox(height: 20),
        _buildLogo(),
        const SizedBox(height: 40),
        _buildWelcomeText(),
        const SizedBox(height: 50),
        _buildEmailField(),
        const SizedBox(height: 20),
        _buildPasswordField(),
        const SizedBox(height: 20),
        _buildForgotPasswordButton(),
        const SizedBox(height: 30),
        _buildLoginButton(),
      ],
    ),
  );

  Widget _buildLogo() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryTeal.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 5,
          offset: const Offset(0, 5),
        ),
        const BoxShadow(
          color: Colors.white,
          blurRadius: 20,
          spreadRadius: 5,
          offset: Offset(0, -5),
        ),
      ],
    ),
    child: Image.asset('assets/images/logo.png', width: 100, height: 100),
  );

  Widget _buildWelcomeText() {
    return Column(
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryTeal,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return _buildTextFormField(
      controller: _emailController,
      label: 'Email',
      hint: 'Enter your email',
      icon: Icons.email,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextFormField(
      controller: _passwordController,
      label: 'Password',
      hint: 'Enter your password',
      icon: Icons.lock,
      isPassword: true,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        decoration: _inputDecoration(label, hint, icon, isPassword),
        validator: validator,
      ),
    );
  }

  InputDecoration _inputDecoration(
    String label,
    String hint,
    IconData icon,
    bool isPassword,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
      ),
      prefixIcon: Icon(icon, color: AppColors.primaryTeal),
      suffixIcon: isPassword ? _buildPasswordVisibilityToggle() : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
    );
  }

  Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility : Icons.visibility_off,
        color: AppColors.primaryTeal,
      ),
      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Implement forgot password
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppColors.primaryTeal,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryTeal,
            AppColors.primaryTeal.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement actual login logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }
}
