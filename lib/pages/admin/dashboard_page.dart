import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import '../../ui/widgets/my_appbar_widget.dart';
class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<ChartData> chartData = [
    ChartData('David', 25),
    ChartData('Steve', 38),
    ChartData('Jack', 34),
    ChartData('Others', 40)
  ];
  List<ChartData2> data = [
    ChartData2('CHN', 12),
    ChartData2('GER', 15),
    ChartData2('RUS', 30),
    ChartData2('BRZ', 6.4),
    ChartData2('IND', 14),
    ChartData2('DD', 12),
    ChartData2('FF', 15),
    ChartData2('XS', 30),
    ChartData2('CC', 6.4),
    ChartData2('CC', 14)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: MyAppBarWidget(
          text: "Reportes",
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300.0,
            child: SfCircularChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              title: ChartTitle(
                text: "Productos más vendidos",
              ),
              legend: Legend(
                isVisible: true,
                title: LegendTitle(
                    text: "Productos"
                ),
              ),
              series: [
                PieSeries<ChartData, String>(
                  dataSource: chartData,
                  pointColorMapper: (ChartData data, _) => data.color,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  // explode: true,
                  // explodeIndex: 1
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 5),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<ChartData2, String>>[
                ColumnSeries<ChartData2, String>(
                  dataSource: data,
                  xValueMapper: (ChartData2 data, _) => data.x,
                  yValueMapper: (ChartData2 data, _) => data.y,
                  name: 'Gold',
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, {this.color});

  final String x;
  final double y;
  final Color? color;
}
class ChartData2 {
  ChartData2(this.x, this.y);

  final String x;
  final double y;
}