import 'package:flutter/material.dart';
import '../models/app_colors.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final bool hasSwitch;
  final Function(bool)? onToggle;

  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.hasSwitch,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: hasSwitch && onToggle != null 
            ? () => onToggle!(!isActive)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              const SizedBox(height: 16),
              _buildTitle(),
              const SizedBox(height: 8),
              _buildStatusIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isActive
              ? [AppColors.primary, AppColors.secondary]
              : [Colors.grey[300]!, Colors.grey[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatusIndicator() {
    if (hasSwitch) {
      return Transform.scale(
        scale: 1.2,
        child: Switch(
          value: isActive,
          onChanged: onToggle,
          activeColor: AppColors.primary,
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green[50] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            color: isActive ? AppColors.success : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }
}