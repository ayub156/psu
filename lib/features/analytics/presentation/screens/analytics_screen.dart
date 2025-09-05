import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/models/attendance.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  Map<String, dynamic>? _analytics;
  List<Attendance> _recentAttendance = [];
  bool _isLoading = false;
  String _selectedPeriod = 'This Week';

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final user = SupabaseService.getCurrentUser();
    if (user != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final analytics = await SupabaseService.getAttendanceAnalytics(user.id);
        final attendance = await SupabaseService.getAttendanceRecords(user.id);
        
        setState(() {
          _analytics = analytics;
          _recentAttendance = attendance.take(10).toList();
        });
      } catch (e) {
        setState(() {
          _analytics = {
            'total': 0,
            'present': 0,
            'absent': 0,
            'attendanceRate': 0.0,
          };
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Period Selector
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time Period',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedPeriod,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Today', child: Text('Today')),
                              DropdownMenuItem(value: 'This Week', child: Text('This Week')),
                              DropdownMenuItem(value: 'This Month', child: Text('This Month')),
                              DropdownMenuItem(value: 'All Time', child: Text('All Time')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedPeriod = value!;
                              });
                              _loadAnalytics();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Overview Cards
                  if (_analytics != null) ...[
                    _buildOverviewCards(),
                    const SizedBox(height: 24),
                  ],

                  // Attendance Chart
                  _buildAttendanceChart(),
                  const SizedBox(height: 24),

                  // Recent Activity
                  _buildRecentActivity(),
                  const SizedBox(height: 24),

                  // Performance Metrics
                  _buildPerformanceMetrics(),
                ],
              ),
            ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _AnalyticsCard(
                title: 'Total Records',
                value: _analytics!['total'].toString(),
                icon: Icons.assessment,
                color: AppTheme.primaryColor,
                subtitle: 'Attendance records',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnalyticsCard(
                title: 'Present',
                value: _analytics!['present'].toString(),
                icon: Icons.check_circle,
                color: AppTheme.successColor,
                subtitle: 'Students present',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AnalyticsCard(
                title: 'Absent',
                value: _analytics!['absent'].toString(),
                icon: Icons.cancel,
                color: AppTheme.errorColor,
                subtitle: 'Students absent',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _AnalyticsCard(
                title: 'Attendance Rate',
                value: '${_analytics!['attendanceRate'].toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: Colors.orange,
                subtitle: 'Overall rate',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceChart() {
    if (_analytics == null || _analytics!['total'] == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.bar_chart,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No attendance data yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start marking attendance to see analytics',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final total = _analytics!['total'] as int;
    final present = _analytics!['present'] as int;
    final absent = _analytics!['absent'] as int;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ChartBar(
                    label: 'Present',
                    value: present,
                    total: total,
                    color: AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ChartBar(
                    label: 'Absent',
                    value: absent,
                    total: total,
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ChartLegend(
                  label: 'Present',
                  count: present,
                  percentage: total > 0 ? (present / total * 100).roundToDouble() : 0.0,
                  color: AppTheme.successColor,
                ),
                _ChartLegend(
                  label: 'Absent',
                  count: absent,
                  percentage: total > 0 ? (absent / total * 100).roundToDouble() : 0.0,
                  color: AppTheme.errorColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/activity'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_recentAttendance.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No recent activity',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _recentAttendance.map((record) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: record.status == AttendanceStatus.present
                          ? AppTheme.successColor.withValues(alpha: 0.1)
                          : AppTheme.errorColor.withValues(alpha: 0.1),
                      child: Icon(
                        record.status == AttendanceStatus.present
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: record.status == AttendanceStatus.present
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      record.studentName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${record.status.displayName} • ${_formatDateTime(record.timestamp)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _MetricRow(
              label: 'Average Attendance Rate',
              value: '${_analytics?['attendanceRate']?.toStringAsFixed(1) ?? '0.0'}%',
              icon: Icons.trending_up,
              color: AppTheme.successColor,
            ),
            const SizedBox(height: 8),
            _MetricRow(
              label: 'Total Students Tracked',
              value: _analytics?['total']?.toString() ?? '0',
              icon: Icons.people,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            const _MetricRow(
              label: 'Most Active Day',
              value: 'Monday',
              icon: Icons.calendar_today,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            const _MetricRow(
              label: 'Best Performing Course',
              value: 'CS101',
              icon: Icons.book,
              color: AppTheme.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (recordDate == today) {
      return 'Today at ${DateFormat('HH:mm').format(dateTime)}';
    } else if (recordDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('MMM dd, HH:mm').format(dateTime);
    }
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.7),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _ChartBar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? value / total : 0.0;
    
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: (120 * percentage).clamp(0.0, 120.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final String label;
  final int count;
  final double percentage;
  final Color color;

  const _ChartLegend({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$count (${percentage.toStringAsFixed(1)}%)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
