import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interior_admin/services/auth_service.dart';
import 'package:interior_admin/screens/manager_screen.dart';
import 'package:interior_admin/screens/employee_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final user = await _authService.validateUser(
            _emailController.text.trim(), _passwordController.text.trim());

        if (user != null) {
          await _navigateToRoleSpecificScreen(user.roleId);
        } else {
          setState(() {
            _errorMessage = 'Invalid email or password';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToRoleSpecificScreen(String roleId) async {
    Widget destinationScreen;
    switch (roleId) {
      case 'manager':
        print("entered");
        destinationScreen = const ManagerScreen();
        break;
      case 'employee':
        print("enter emp");
        destinationScreen = const EmployeeScreen();
        break;
      default:
        setState(() {
          _errorMessage = 'Unauthorized access';
          _isLoading = false;
        });
        return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => destinationScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return _buildResponsiveLayout(constraints);
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BoxConstraints constraints) {
    final screenWidth = constraints.maxWidth;
    final screenHeight = constraints.maxHeight;
    final isPortrait = screenHeight > screenWidth;
    final isWideScreen = screenWidth > 600;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Responsive Background Image
            _buildResponsiveBackgroundImage(isPortrait, isWideScreen),

            // Login Form
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical:
                        isPortrait ? screenHeight * 0.05 : screenHeight * 0.1,
                  ),
                  child: _buildLoginCard(isWideScreen),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponsiveBackgroundImage(bool isPortrait, bool isWideScreen) {
    return Image.asset(
      'assets/images/login.png',
      fit: isPortrait ? BoxFit.fitWidth : BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      alignment: isPortrait ? Alignment.topCenter : Alignment.center,
    );
  }

  Widget _buildLoginCard(bool isWideScreen) {
    return Container(
      width: isWideScreen ? 400 : double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLoginHeader(),
          const SizedBox(height: 24),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildLoginButton(),
          const SizedBox(height: 16),
          if (_errorMessage != null) _buildErrorMessage(),
          const SizedBox(height: 16),
          _buildForgotPasswordButton(),
        ],
      ),
    );
  }

  Widget _buildLoginHeader() {
    return Text(
      'Login',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        if (value.trim().length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator.adaptive()
          : const Text('Login',
              style: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      _errorMessage!,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Forgot Password feature coming soon')),
        );
      },
      child: const Text('Forgot Password?'),
    );
  }
}
