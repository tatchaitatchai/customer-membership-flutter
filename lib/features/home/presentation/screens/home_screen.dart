import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/premium_card.dart';
import '../../../history/presentation/screens/purchase_history_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [_HomeContent(), PurchaseHistoryScreen(), NotificationsScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: PointsMeTheme.darkCard,
          border: Border(top: BorderSide(color: PointsMeTheme.dividerColor.withOpacity(0.5))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'หน้าหลัก'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'ประวัติ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'แจ้งเตือน',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'โปรไฟล์'),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: PointsMeTheme.darkGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('สวัสดี,', style: TextStyle(fontSize: 14, color: PointsMeTheme.textSecondary)),
                      const SizedBox(height: 2),
                      const Text(
                        'คุณสมชาย',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: PointsMeTheme.goldGradient),
                    child: const Center(
                      child: Text(
                        'ส',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: PointsMeTheme.darkBg),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Points & Rank Card
              _buildMembershipCard(context),

              const SizedBox(height: 20),

              // Rank Progress
              _buildRankProgressCard(),

              const SizedBox(height: 20),

              // Quick Stats
              Row(
                children: [
                  Expanded(child: _buildStatCard('ยอดซื้อเดือนนี้', '฿2,450', Icons.shopping_bag_outlined)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('แต้มที่ได้รับ', '+245', Icons.star_outline)),
                ],
              ),

              const SizedBox(height: 20),

              // Recent Transactions
              _buildSectionHeader(
                'รายการล่าสุด',
                onSeeAll: () {
                  // Navigate to history tab
                },
              ),

              const SizedBox(height: 12),

              _buildTransactionItem('The Coffee House - สาขาสยาม', '฿350', '+35 แต้ม', '10 ก.พ. 2026'),
              _buildTransactionItem('The Coffee House - สาขาลาดพร้าว', '฿520', '+52 แต้ม', '8 ก.พ. 2026'),
              _buildTransactionItem('The Coffee House - สาขาสยาม', '฿180', '+18 แต้ม', '5 ก.พ. 2026'),

              const SizedBox(height: 20),

              // Rank Privileges
              _buildSectionHeader(
                'สิทธิพิเศษของคุณ',
                onSeeAll: () {
                  context.push('/rank-privileges');
                },
              ),

              const SizedBox(height: 12),

              _buildPrivilegeItem('ส่วนลด 5%', 'สำหรับทุกการสั่งซื้อ', Icons.discount_outlined),
              _buildPrivilegeItem('แต้ม x1.0', 'รับแต้มปกติทุกการซื้อ', Icons.star_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context) {
    return GoldGradientCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: PointsMeTheme.rankGold, size: 20),
                      const SizedBox(width: 6),
                      const Text(
                        'GOLD',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: PointsMeTheme.rankGold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('สมาชิกระดับโกลด์', style: TextStyle(fontSize: 12, color: PointsMeTheme.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: PointsMeTheme.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PointsMeTheme.primaryGold.withOpacity(0.3)),
                ),
                child: const Text(
                  'ID: PM-00123',
                  style: TextStyle(
                    fontSize: 11,
                    color: PointsMeTheme.primaryGold,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Points display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '1,250',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: PointsMeTheme.primaryGold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'แต้ม',
                  style: TextStyle(fontSize: 16, color: PointsMeTheme.primaryGoldLight, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Total spending
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 16, color: PointsMeTheme.textSecondary),
              const SizedBox(width: 6),
              Text('ยอดซื้อสะสม ฿12,500', style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankProgressCard() {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'เลื่อนขั้นเป็น Platinum',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: PointsMeTheme.textPrimary),
              ),
              Text(
                '1,250 / 2,000',
                style: TextStyle(fontSize: 13, color: PointsMeTheme.primaryGold, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(color: PointsMeTheme.darkSurface, borderRadius: BorderRadius.circular(6)),
                ),
                FractionallySizedBox(
                  widthFactor: 0.625, // 1250/2000
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: PointsMeTheme.goldGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text('สะสมอีก 750 แต้ม เพื่อเลื่อนขั้น', style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: PointsMeTheme.primaryGold, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: PointsMeTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: PointsMeTheme.textPrimary),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'ดูทั้งหมด',
              style: TextStyle(fontSize: 13, color: PointsMeTheme.primaryGold, fontWeight: FontWeight.w500),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionItem(String store, String amount, String points, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PointsMeTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PointsMeTheme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PointsMeTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.receipt_outlined, color: PointsMeTheme.primaryGold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: PointsMeTheme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PointsMeTheme.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                points,
                style: const TextStyle(fontSize: 12, color: PointsMeTheme.successColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivilegeItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PointsMeTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PointsMeTheme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PointsMeTheme.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: PointsMeTheme.primaryGold, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PointsMeTheme.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
