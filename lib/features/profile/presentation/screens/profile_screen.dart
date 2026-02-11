import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/premium_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Profile avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: PointsMeTheme.goldGradient,
                  boxShadow: [
                    BoxShadow(color: PointsMeTheme.primaryGold.withOpacity(0.3), blurRadius: 16, spreadRadius: 2),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'ส',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: PointsMeTheme.darkBg),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'คุณสมชาย',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
              ),

              const SizedBox(height: 4),

              Text(
                '081-234-5678',
                style: TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary, letterSpacing: 1),
              ),

              const SizedBox(height: 8),

              // Rank badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: PointsMeTheme.rankGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PointsMeTheme.rankGold.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium, color: PointsMeTheme.rankGold, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'GOLD MEMBER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: PointsMeTheme.rankGold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Member info card
              GoldGradientCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoColumn('แต้มสะสม', '1,250'),
                    Container(width: 1, height: 40, color: PointsMeTheme.dividerColor),
                    _buildInfoColumn('ยอดซื้อสะสม', '฿12,500'),
                    Container(width: 1, height: 40, color: PointsMeTheme.dividerColor),
                    _buildInfoColumn('สมาชิกตั้งแต่', 'ม.ค. 26'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Menu items
              PremiumCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.workspace_premium,
                      iconColor: PointsMeTheme.primaryGold,
                      title: 'สิทธิพิเศษแต่ละแรงค์',
                      onTap: () {
                        context.push('/rank-privileges');
                      },
                    ),
                    const Divider(color: PointsMeTheme.dividerColor, height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.edit_outlined,
                      iconColor: PointsMeTheme.textSecondary,
                      title: 'แก้ไขชื่อ',
                      onTap: () {
                        _showEditNameDialog(context);
                      },
                    ),
                    const Divider(color: PointsMeTheme.dividerColor, height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.shield_outlined,
                      iconColor: PointsMeTheme.textSecondary,
                      title: 'นโยบายความเป็นส่วนตัว',
                      onTap: () {
                        context.push('/privacy-policy');
                      },
                    ),
                    const Divider(color: PointsMeTheme.dividerColor, height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.info_outline,
                      iconColor: PointsMeTheme.textSecondary,
                      title: 'เกี่ยวกับแอป',
                      subtitle: 'เวอร์ชัน 1.0.0',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Logout
              PremiumCard(
                padding: EdgeInsets.zero,
                child: _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  iconColor: PointsMeTheme.warningColor,
                  title: 'ออกจากระบบ',
                  titleColor: PointsMeTheme.warningColor,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Delete account
              PremiumCard(
                padding: EdgeInsets.zero,
                child: _buildMenuItem(
                  context,
                  icon: Icons.delete_forever_outlined,
                  iconColor: PointsMeTheme.dangerColor,
                  title: 'ลบบัญชี',
                  titleColor: PointsMeTheme.dangerColor,
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PointsMeTheme.primaryGold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: PointsMeTheme.textMuted)),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? PointsMeTheme.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted)),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: PointsMeTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(text: 'คุณสมชาย');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PointsMeTheme.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('แก้ไขชื่อ', style: TextStyle(color: PointsMeTheme.textPrimary)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: PointsMeTheme.textPrimary),
          decoration: const InputDecoration(hintText: 'กรอกชื่อใหม่'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: PointsMeTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('บันทึก', style: TextStyle(color: PointsMeTheme.primaryGold)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PointsMeTheme.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ออกจากระบบ', style: TextStyle(color: PointsMeTheme.textPrimary)),
        content: const Text('คุณต้องการออกจากระบบหรือไม่?', style: TextStyle(color: PointsMeTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: PointsMeTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: const Text('ออกจากระบบ', style: TextStyle(color: PointsMeTheme.warningColor)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PointsMeTheme.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ลบบัญชี', style: TextStyle(color: PointsMeTheme.dangerColor)),
        content: const Text(
          'การลบบัญชีจะทำให้ข้อมูลทั้งหมดของคุณถูกลบอย่างถาวร รวมถึงแต้มสะสมและประวัติการซื้อทั้งหมด\n\nคุณแน่ใจหรือไม่?',
          style: TextStyle(color: PointsMeTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: PointsMeTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Delete account logic
            },
            child: const Text('ลบบัญชี', style: TextStyle(color: PointsMeTheme.dangerColor)),
          ),
        ],
      ),
    );
  }
}
