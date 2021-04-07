import 'package:appmoodo/model/mood.dart';
import 'package:appmoodo/res/app_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodsChart extends StatelessWidget {
  final List<Mood> moods;
  final List<FlSpot> _data = [];
  MoodsChart({Key key, this.moods}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: _prepareData(),
            )
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            ),
            touchCallback: (LineTouchResponse touchResponse) {},
            handleBuiltInTouches: true,
          ),
          maxY: 5.0,
          minY: 1.0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff72719b),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              margin: 10,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              interval: 1.0,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff75729e),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (value) {
                if (value.toInt() <= 5)
                  return AppConstants.moodMojis[value.toInt() - 1];
                return '';
              },
              margin: 8,
              reservedSize: 30,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(
                color: Color(0xff4e4965),
                width: 4,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              right: BorderSide(
                color: Colors.transparent,
              ),
              top: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          backgroundColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day, 0);
  }

  List<FlSpot> _prepareData() {
    final Map<DateTime, List<Mood>> gmoods = {};
    moods.forEach((mood) {
      final date = _normalize(mood.date);
      if (gmoods[date] == null) gmoods[date] = [];
      gmoods[date].add(mood);
    });

    gmoods.keys.forEach((date) {
      var sum = 0;
      gmoods[date].forEach((element) {
        sum += element.mood;
      });
      _data.add(
          FlSpot(date.day.toDouble(), (sum ~/ gmoods[date].length).toDouble()));
    });
    return _data;
  }
}
