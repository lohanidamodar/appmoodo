/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../model/mood.dart';

class MoodsChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MoodsChart(this.seriesList, {this.animate});

  factory MoodsChart.withData(final List<Mood> moods) {
    return MoodsChart(
      _createMoodsData(moods),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  static List<charts.Series<MoodData, DateTime>> _createMoodsData(
      List<Mood> moods) {
    final data = List<MoodData>.from(
      moods.map(
        (mood) => MoodData(mood.date, mood.mood),
      ),
    );

    return [
      new charts.Series<MoodData, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MoodData sales, _) => sales.time,
        measureFn: (MoodData sales, _) => sales.mood,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class MoodData {
  final DateTime time;
  final int mood;

  MoodData(this.time, this.mood);
}
