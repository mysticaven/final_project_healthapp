import 'package:fitness_dashboard_ui/util/responsive.dart';
import 'package:fitness_dashboard_ui/widgets/activity_details_card.dart';
import 'package:fitness_dashboard_ui/widgets/bar_graph_widget.dart';
import 'package:fitness_dashboard_ui/widgets/header_widget.dart';
import 'package:fitness_dashboard_ui/widgets/line_chart_card.dart';
import 'package:fitness_dashboard_ui/widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 18),
            const HeaderWidget(),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivityDetailsPage()),
                );
              },
              child: const ActivityDetailsCard(),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LineChartPage()),
                );
              },
              child: const LineChartCard(),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BarGraphPage()),
                );
              },
              child: const BarGraphCard(),
            ),
            const SizedBox(height: 18),
            if (Responsive.isTablet(context))
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SummaryPage()),
                  );
                },
                child: const SummaryWidget(),
              ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages for navigation
class ActivityDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Center(
        child: Text('Activity Details Page'),
      ),
    );
  }
}

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart'),
      ),
      body: Center(
        child: Text('Line Chart Page'),
      ),
    );
  }
}

class BarGraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Graph'),
      ),
      body: Center(
        child: Text('Bar Graph Page'),
      ),
    );
  }
}

class SummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Center(
        child: Text('Summary Page'),
      ),
    );
  }
}
