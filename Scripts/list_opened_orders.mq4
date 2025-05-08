void ListOpenedOrdersWithRisk() {
   double accountBalance = AccountBalance();
   int totalOrders = OrdersTotal();
   string sp = "                                      ";
   string orderInfo = "";

   orderInfo += sp + "Balance: " + string(accountBalance) + "\n";
   orderInfo += sp + "List of Open Orders:\n";

   for (int i = 0; i < totalOrders; i++) {
       if (OrderSelect(i, SELECT_BY_POS) == true) {
           if (OrderType() <= OP_SELL) {
               double entryPrice = OrderOpenPrice();
               double stopLossPrice = OrderStopLoss();
               double takeProfitPrice = OrderTakeProfit();
               double lotSize = OrderLots();
               string symbol = OrderSymbol();

               // Get the correct point value for the symbol
               double pointValue = MarketInfo(symbol, MODE_POINT);

               // Calculate risk and reward in account currency
               double riskValue = MathAbs(entryPrice - stopLossPrice) * pointValue * lotSize;
               double rewardValue = MathAbs(entryPrice - takeProfitPrice) * pointValue * lotSize;

               // Calculate risk percentage
               double riskPercentage = riskValue / accountBalance;

               // Print order information with risk and reward
               string message = "Order " + OrderTicket() + ": Symbol = " + symbol + ", Type = " + (OrderType() == OP_BUY ? "Buy" : "Sell") + ", Lots = " + lotSize + ", Open Price = " + entryPrice + ", Stop Loss = " + stopLossPrice + ", Take Profit = " + takeProfitPrice + ", Risk = " + riskPercentage + "% - " + DoubleToStr(riskValue, Digits) + " " + AccountCurrency() + ", Reward: " + DoubleToStr(rewardValue, Digits) + " " + AccountCurrency();
               orderInfo += "                                        " + message + "\n";
               Print(message);
           }
       }
   }

   // Display order information as a comment on the chart
   ChartSetString(0, CHART_COMMENT, orderInfo);
}

void OnInit() {

}

void OnStart() {
   ListOpenedOrdersWithRisk();
}
  
int OnDeinit() {
   Print(__FUNCTION__," Deinitialization reason code = ",reason);
}