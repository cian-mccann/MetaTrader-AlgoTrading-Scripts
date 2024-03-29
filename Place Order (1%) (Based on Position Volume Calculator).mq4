#property copyright "Cian McCann"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

void OnStart()
{
   Print("Place Order 1% script called.");
 
   double stopLossLevel = ObjectGetDouble(0,"Stop Level",OBJPROP_PRICE,0);
   
   if (stopLossLevel != 0.0 && StringCompare(ChartIndicatorName(0,0,0),  "Position Volume Calculator", false) == 0) {
      Print("Stop Loss level found and Position Volume Calculator indicator found.");
      
      double differenceInPoints;
      string tradeType;
      string chartSymbol = ChartSymbol(0);
      if (stopLossLevel < Ask) {
         if (StringCompare(chartSymbol,  "USOIL(€)", false) == 0) {
            differenceInPoints = (Ask-stopLossLevel)*100;
            tradeType = "Long trade on " + chartSymbol;
         } else if (StringCompare(chartSymbol,  "SPX500(€)", false) == 0) {
            differenceInPoints = (Ask-stopLossLevel);
            tradeType = "Long trade on " + chartSymbol;
         } else if (StringCompare(chartSymbol,  "GBPUSD(€)", false) == 0) {
            differenceInPoints = (Ask-stopLossLevel)*10000;
            tradeType = "Long trade on " + chartSymbol;
         } else if (StringCompare(chartSymbol,  "GBPJPY(€)", false) == 0) {
            differenceInPoints = (Ask-stopLossLevel)*100;
            tradeType = "Long trade on " + chartSymbol;
         } else {
            Print("Closing Position Volume Calculator indicator, this chart is not supported.");
            ChartIndicatorDelete(0,0,"Position Volume Calculator");
         }
      } else {
         if (StringCompare(chartSymbol,  "USOIL(€)", false) == 0) {
            differenceInPoints = (stopLossLevel-Bid)*100;
            tradeType = "Short trade on " + chartSymbol;
         } else if (StringCompare(chartSymbol,  "SPX500(€)", false) == 0) {
            differenceInPoints = (stopLossLevel-Bid);
            tradeType = "Short trade on " + chartSymbol;
         } else if (StringCompare(chartSymbol,  "GBPUSD(€)", false) == 0) {
            differenceInPoints = (stopLossLevel-Bid)*10000;
            tradeType = "Short trade on " + chartSymbol;
         } else if (StringCompare(chartSymbol,  "GBPJPY(€)", false) == 0) {
            differenceInPoints = (stopLossLevel-Bid)*100;
            tradeType = "Short trade on " + chartSymbol;
         } else {
            Print("Closing Position Volume Calculator indicator, this chart is not supported.");
            ChartIndicatorDelete(0,0,"Position Volume Calculator");
         }
      }
      
      double accountBalance = AccountBalance();
      
      double euroAmountToRisk = accountBalance*0.01;
      
      double euroPerPoint = euroAmountToRisk/differenceInPoints;
      
      double actualAmountToBeRisked = NormalizeDouble(euroAmountToRisk/differenceInPoints, 1) * differenceInPoints;
      
      Print (tradeType);
      Print ("Stop loss distance in points = " + DoubleToStr(differenceInPoints, 2));
      Print ("Account balance = " + accountBalance);
      Print ("1% of account = " + euroAmountToRisk + " (" + NormalizeDouble(actualAmountToBeRisked,2) + " actual)");
      Print ("Amount per point to use (Volume) = " + NormalizeDouble(euroPerPoint,2) + " (" + NormalizeDouble(euroPerPoint,1) + " actual)");
         
      if (stopLossLevel < Ask) {
         //Long Trade
         Print("Place Order script placing long trade.");
         OrderSend (Symbol(), OP_BUY, NormalizeDouble(euroPerPoint,1), Ask, 3, stopLossLevel, 0, NULL, 0, 0, CLR_NONE);
      } else {
         //Short Trade
         Print("Place Order script placing short trade.");
         OrderSend (Symbol(), OP_SELL, NormalizeDouble(euroPerPoint,1), Bid, 3, stopLossLevel, 0, NULL, 0, 0, CLR_NONE);
      }
      
      Print("Error code (If any): " + GetLastError());
      Print("Place Order script complete.");
      //ChartIndicatorDelete(0,0,"Position Volume Calculator");
   } else {
      Print("Stop Loss level and/or Position Volume Calculator indicator not found.");
      Print("Place Order script complete.");
   }
}