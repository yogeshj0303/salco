import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selco_app/screens/dashboard_screen.dart';
import 'package:selco_app/screens/main_screen.dart';
import 'package:selco_app/screens/technician%20screens/technician_login_screen.dart';
import 'package:selco_app/utils/glass_morphism.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import '../services/shared_prefs_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  final _sharedPrefsService = SharedPrefsService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final isLoggedIn = await _sharedPrefsService.isLoggedIn();
      if (isLoggedIn) {
        final userData = await _sharedPrefsService.getUserData();
        print('Auto Login - User Data: $userData');
        
        if (userData != null) {
          // Check if user is a technician
          if (userData['isTechnician'] == true) {
            // If technician, navigate to technician login screen
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TechnicianLoginScreen()),
                (route) => false,
              );
              return;
            }
          } else {
            // For non-technician users, proceed to main screen
            if (mounted) {
              _navigateToMainScreen();
            }
          }
        } else {
          // If user data is null, clear login state
          await _sharedPrefsService.clearUserData();
        }
      }
    } catch (e) {
      print('Auto Login Error: $e');
      // If any error occurs, clear the data
      await _sharedPrefsService.clearUserData();
    }
  }

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
          child: Center(
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
        const SizedBox(height: 20),
        _buildSwitchToTechnicianLogin(),
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
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
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

  Widget _buildSwitchToTechnicianLogin() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Are you a technician?',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TechnicianLoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Login here',
              style: TextStyle(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        final response = await _apiService.login(
          _emailController.text,
          _passwordController.text,
          isTechnician: false,
        );

        if (response['status'] == 'success' && response['user'] != null) {
          final userData = response['user'];
          
          // Check if user is a technician
          if (userData['designation'] == 'Technician') {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please use technician login'),
                  backgroundColor: Colors.red,
                ),
              );
              setState(() => _isLoading = false);
              return;
            }
          }

          // Save user data with isTechnician flag based on designation
          await _sharedPrefsService.saveUserData({
            ...userData,
            'isTechnician': userData['designation'] == 'Technician',
          });
          
          // Print saved data
          final savedData = await _sharedPrefsService.getUserData();
          print('Saved User Data: $savedData');
          
          if (mounted) {
            _navigateToMainScreen();
          }
        } else {
          throw Exception(response['message'] ?? 'Login failed');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _navigateToMainScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }
}
