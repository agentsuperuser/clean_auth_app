import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_clean_auth/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return CustomScrollView(
              slivers: [
                // Custom SliverAppBar
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: const Color(0xFF00BCD4),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF00BCD4),
                            Color(0xFF0097A7),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'Hello,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.userEntity.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout_rounded),
                        color: Colors.white,
                        tooltip: 'Logout',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),

                        // Account card
                        _SectionLabel(label: 'Account Details'),
                        const SizedBox(height: 12),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline_rounded,
                              label: 'Full Name',
                              value: state.userEntity.name,
                            ),
                            const _Divider(),
                            _InfoRow(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email Address',
                              value: state.userEntity.email,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Status card
                        _SectionLabel(label: 'Session'),
                        const SizedBox(height: 12),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.verified_user_outlined,
                              label: 'Status',
                              value: 'Authenticated',
                              valueColor: const Color(0xFF00897B),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Sign out button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(
                              Icons.logout_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEF5350),
                              side: const BorderSide(
                                  color: Color(0xFFEF5350), width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF00BCD4),
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A2B3C),
          ),
        ),
        content: const Text(
          'Are you sure you want to sign out of your account?',
          style: TextStyle(color: Color(0xFF78909C)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF78909C)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                color: Color(0xFFEF5350),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF90A4AE),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF00BCD4), size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF90A4AE),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: valueColor ?? const Color(0xFF1A2B3C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 0,
      color: Color(0xFFF0F0F0),
    );
  }
}