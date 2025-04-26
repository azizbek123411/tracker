import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/repo/models/expanse_model.dart';

class StatsWidget extends StatelessWidget {
  final List<ExpanseModel> expanses;
  const StatsWidget({super.key, required this.expanses});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final Map<String, double> dailyTotals = {
      "Mon": 0,
      "Tue": 0,
      "Wed": 0,
      "Thu": 0,
      "Fri": 0,
      "Sat": 0,
      "Sun": 0,
    };

    for (var e in expanses) {
      if (e.date.isAfter(
        now.subtract(
          Duration(days: 7),
        ),
      )) {
        final weekday = _weekdayLabel(e.date.weekday);
        dailyTotals[weekday] = dailyTotals[weekday]! + e.amount;
      }
    }

    return Padding(
      padding:EdgeInsets.all(20), 
      child:BarChart(        
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value,meta){
                  final days=['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                  return Text(days[value.toInt()]);
                },
                reservedSize: 30,

              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
            ),
            
          ),
          barGroups: List.generate(7, (index){
            final label=_weekdayLabel(index+1);
            final value=dailyTotals[label]??0;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  
                  toY: value,
                  color: Colors.purpleAccent,
                  width: 16,
                ),
              ],
            );
          })
        ),
      ),
    );
  }



  String _weekdayLabel(int weekday){
    switch(weekday){
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';

    }
  }
}
