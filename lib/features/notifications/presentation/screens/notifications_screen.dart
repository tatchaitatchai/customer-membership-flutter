import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: PointsMeTheme.darkGradient,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'แจ้งเตือน',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: PointsMeTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'อ่านทั้งหมด',
                      style: TextStyle(
                        fontSize: 13,
                        color: PointsMeTheme.primaryGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Notifications list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationItem(
                    icon: Icons.star,
                    iconColor: PointsMeTheme.primaryGold,
                    title: 'ได้รับ +35 แต้ม',
                    subtitle: 'จากการซื้อที่ The Coffee House - สาขาสยาม',
                    time: '2 ชั่วโมงที่แล้ว',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    icon: Icons.star,
                    iconColor: PointsMeTheme.primaryGold,
                    title: 'ได้รับ +52 แต้ม',
                    subtitle: 'จากการซื้อที่ The Coffee House - สาขาลาดพร้าว',
                    time: '2 วันที่แล้ว',
                    isUnread: true,
                  ),
                  _buildNotificationItem(
                    icon: Icons.trending_up,
                    iconColor: PointsMeTheme.successColor,
                    title: 'เลื่อนขั้นเป็น Gold!',
                    subtitle: 'ยินดีด้วย! คุณได้เลื่อนขั้นเป็นสมาชิกระดับ Gold พร้อมรับสิทธิพิเศษมากมาย',
                    time: '5 วันที่แล้ว',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    icon: Icons.star,
                    iconColor: PointsMeTheme.primaryGold,
                    title: 'ได้รับ +18 แต้ม',
                    subtitle: 'จากการซื้อที่ The Coffee House - สาขาสยาม',
                    time: '5 วันที่แล้ว',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    icon: Icons.card_giftcard,
                    iconColor: PointsMeTheme.warningColor,
                    title: 'โปรโมชั่นพิเศษ!',
                    subtitle: 'รับแต้ม x2 สำหรับทุกการซื้อในวันนี้ ถึง 28 ก.พ. 2026',
                    time: '1 สัปดาห์ที่แล้ว',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    icon: Icons.star,
                    iconColor: PointsMeTheme.primaryGold,
                    title: 'ได้รับ +89 แต้ม',
                    subtitle: 'จากการซื้อที่ The Coffee House - สาขาเซ็นทรัล',
                    time: '1 สัปดาห์ที่แล้ว',
                    isUnread: false,
                  ),
                  _buildNotificationItem(
                    icon: Icons.celebration,
                    iconColor: PointsMeTheme.rankBronze,
                    title: 'ยินดีต้อนรับ!',
                    subtitle: 'คุณได้สมัครสมาชิก Points ME เรียบร้อยแล้ว เริ่มสะสมแต้มกันเลย!',
                    time: '2 สัปดาห์ที่แล้ว',
                    isUnread: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? PointsMeTheme.darkCardLight : PointsMeTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? PointsMeTheme.primaryGold.withOpacity(0.2)
              : PointsMeTheme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                          color: PointsMeTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: PointsMeTheme.primaryGold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: PointsMeTheme.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: PointsMeTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
