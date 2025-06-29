import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:foodly_restaurant/common/common_appbar.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/hooks/fetchRestaurantOrders.dart';
import 'package:foodly_restaurant/models/ready_orders.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SalesData extends HookWidget {
  SalesData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchPicked("Delivered");
    List<ReadyOrders>? orders = hookResult.data;
    final isLoading = hookResult.isLoading;

    // State to track selected chart type
    final selectedChartType = useState<String>("Daily");

    if (isLoading) {
      return Scaffold(
        appBar: CommonAppBar(titleText: "Sales data"),
        body: const Center(child: CircularProgressIndicator(color: kPrimary,)),
      );
    }
    if(orders!.isEmpty){
      return Scaffold(
        appBar: CommonAppBar(titleText: "You don't have sales"),
        body: const Center(child: CircularProgressIndicator(color: kPrimary,)),
      );
    }

    List<DailySalesData> data;
    if (selectedChartType.value == "Daily") {
      data = prepareDailyData(orders);
    } else if (selectedChartType.value == "Monthly") {
      data = prepareMonthlyData(orders);
    } else {
      data = prepareYearlyData(orders);
    }

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: CommonAppBar(
          titleText: "Sales data",
          appBarActions: [
            DropdownButton<String>(
              dropdownColor: kSecondary,
              value: selectedChartType.value,
              items: <String>['Daily', 'Monthly', 'Yearly']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: kOffWhite),
                ),
              ))
                  .toList(),
              onChanged: (String? newValue) {
                selectedChartType.value = newValue!;
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  title: AxisTitle(
                    text: selectedChartType.value == "Daily"
                        ? "---Daily"
                        : selectedChartType.value == "Monthly"
                        ? "---Months"
                        : "---Years",
                  ),
                  dateFormat: selectedChartType.value == "Daily"
                      ? DateFormat('yyyy-MM-dd')
                      : selectedChartType.value == "Monthly"
                      ? DateFormat('yyyy-MM')
                      : DateFormat('yyyy'),
                  // Change format based on selection
                  majorGridLines: const MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: selectedChartType.value == "Daily"
                      ? DateTimeIntervalType.days
                      : selectedChartType.value == "Monthly"
                      ? DateTimeIntervalType.months
                      : DateTimeIntervalType.years,
                  // Change interval type based on selection
                  interval: 1, // Set interval to 1 day, month, or year
                ),
                title: ChartTitle(
                    text: selectedChartType.value == "Daily"
                        ? 'Daily Sales Analysis'
                        : selectedChartType.value == "Monthly"
                        ? 'Monthly Sales Analysis'
                        : 'Yearly Sales Analysis'),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<DailySalesData, DateTime>>[
                  LineSeries<DailySalesData, DateTime>(
                    dataSource: data,
                    xValueMapper: (DailySalesData sales, _) => sales.date,
                    yValueMapper: (DailySalesData sales, _) => sales.sales,
                    name: 'Sales',
                    xAxisName: "Time",
                    yAxisName: "Amount",
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            Container(
              child: const TabBar(
                tabs: [
                  Tab(text: "Daily"),
                  Tab(text: "Monthly"),
                  Tab(text: "Yearly"),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: TabBarView(
                children: [
                  Center(child: Text("Daily sales data information")),
                  Center(child: Text("Monthly sales data information")),
                  Center(child: Text("Yearly sales data information")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailySalesData {
  DailySalesData(this.date, this.sales);

  final DateTime date;
  final double sales;
}

List<DailySalesData> prepareDailyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(
          order.orderDate!.year, order.orderDate!.month, order.orderDate!.day);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

List<DailySalesData> prepareMonthlyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(order.orderDate!.year, order.orderDate!.month);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}

List<DailySalesData> prepareYearlyData(List<ReadyOrders> orders) {
  final Map<DateTime, double> salesMap = {};

  try {
    for (var order in orders) {
      final orderDate = DateTime(order.orderDate!.year);
      for (var item in order.orderItems) {
        salesMap[orderDate] = (salesMap[orderDate] ?? 0) + (item.price);
      }
    }
  } catch (e) {
    print(e.toString());
  }

  final sortedEntries = salesMap.entries
      .map((entry) => DailySalesData(entry.key, entry.value))
      .toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  return sortedEntries;
}
