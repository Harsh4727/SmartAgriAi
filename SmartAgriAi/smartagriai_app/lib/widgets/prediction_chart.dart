import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PredictionChart extends StatelessWidget {

  final Map<String,int> data;

  PredictionChart({required this.data});

  @override
  Widget build(BuildContext context) {

    List<BarChartGroupData> bars = [];

    int i = 0;

    data.forEach((crop,count){

      bars.add(

        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.green,
              width: 18,
            )
          ],
        ),

      );

      i++;

    });

    return SizedBox(

      height: 250,

      child: BarChart(

        BarChartData(
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(show: false),

          barGroups: bars,

        ),

      ),

    );

  }

}