import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _animationsInitialized = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _animationsInitialized = true;
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 768;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(screenWidth, isDesktop),
                _buildHeroSection(screenWidth, screenHeight, isDesktop, isTablet),
                _buildFeaturesSection(screenWidth, isDesktop),
                _buildCTASection(screenWidth, isDesktop),
                _buildFooter(screenWidth, isDesktop),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'ShopFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isDesktop) ...[
            Row(
              children: [
                _buildNavItem('Home'),
                _buildNavItem('Products'),
                _buildNavItem('About'),
                _buildNavItem('Contact'),
                const SizedBox(width: 20),
                _buildLoginButton(),
              ],
            ),
          ] 
        ],
      ),
    );
  }

  Widget _buildNavItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(double screenWidth, double screenHeight, bool isDesktop, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: isDesktop ? 40 : 60,
      ),
      child: _animationsInitialized
          ? FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    if (isDesktop) ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _buildHeroContent(screenWidth, isDesktop),
                          ),
                          const SizedBox(width: 60),
                          Expanded(
                            flex: 1,
                            child: _buildHeroImage(),
                          ),
                        ],
                      ),
                    ] else ...[
                      _buildHeroContent(screenWidth, isDesktop),
                    
                    ],
                  ],
                ),
              ),
            )
          : Column(
              children: [
                if (isDesktop) ...[
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildHeroContent(screenWidth, isDesktop),
                      ),
                      const SizedBox(width: 60),
                      Expanded(
                        flex: 1,
                        child: _buildHeroImage(),
                      ),
                    ],
                  ),
                ] else ...[
                  _buildHeroContent(screenWidth, isDesktop),
                  const SizedBox(height: 40),
                  _buildHeroImage(),
                ],
              ],
            ),
    );
  }

  Widget _buildHeroContent(double screenWidth, bool isDesktop) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'Discover Amazing Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: isDesktop ? 48 : 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          'Shop the latest trends with incredible deals and fast delivery. Your perfect shopping experience awaits.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: isDesktop ? 18 : 16,
            height: 1.6,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            _buildPrimaryButton('Shop Now', Icons.shopping_cart),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.shopping_bag,
              size: 120,
              color: Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFff6b6b), Color(0xFFff8e8e)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFff6b6b).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(double screenWidth, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 80,
      ),
      child: Column(
        children: [
          Text(
            'Why Choose ShopFlow?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 36 : 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          isDesktop
              ? Row(
                  children: [
                    Expanded(child: _buildFeatureCard(Icons.flash_on, 'Fast Delivery', 'Get your orders delivered within 24 hours')),
                    const SizedBox(width: 30),
                    Expanded(child: _buildFeatureCard(Icons.security, 'Secure Payment', 'Your transactions are protected with bank-level security')),
                    const SizedBox(width: 30),
                    Expanded(child: _buildFeatureCard(Icons.support_agent, '24/7 Support', 'Our team is always here to help you')),
                  ],
                )
              : Column(
                  children: [
                    _buildFeatureCard(Icons.flash_on, 'Fast Delivery', 'Get your orders delivered within 24 hours'),
                    const SizedBox(height: 30),
                    _buildFeatureCard(Icons.security, 'Secure Payment', 'Your transactions are protected with bank-level security'),
                    const SizedBox(height: 30),
                    _buildFeatureCard(Icons.support_agent, '24/7 Support', 'Our team is always here to help you'),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFff6b6b), Color(0xFFff8e8e)],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(double screenWidth, bool isDesktop) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFff6b6b), Color(0xFFff8e8e)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFff6b6b).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ready to Start Shopping?',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 32 : 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join thousands of happy customers and discover amazing deals today!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isDesktop ? 18 : 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: () {
                  Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Color(0xFFff6b6b),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(double screenWidth, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          if (isDesktop) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ShopFlow',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your trusted shopping companion',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildFooterColumn('Shop', ['Products', 'Categories', 'Deals', 'New Arrivals']),
                    const SizedBox(width: 80),
                    _buildFooterColumn('Support', ['Help Center', 'Contact Us', 'Shipping', 'Returns']),
                    const SizedBox(width: 80),
                    _buildFooterColumn('Company', ['About Us', 'Careers', 'Press', 'Blog']),
                  ],
                ),
              ],
            ),
          ] else ...[
            const Text(
              'ShopFlow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your trusted shopping companion',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 40),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 20),
          Text(
            '© 2024 ShopFlow. All rights reserved.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            )),
      ],
    );
  }
}