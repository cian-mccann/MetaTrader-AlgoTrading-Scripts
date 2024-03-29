#property copyright "Cian McCann"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

void OnStart()
{
   Print("Place Order (Buy) (1%) (7.5 Point Stop) script called.");
   if (StringCompare(ChartSymbol(0),  "SPX500(€)", false) == 0) {
      
      double stopLossLevel = (Ask-7.5);
      double differenceInPoints = 7.5;
      double accountBalance = AccountBalance();
      double euroAmountToRisk = accountBalance*0.01;
      double euroPerPoint = euroAmountToRisk/differenceInPoints;
      double actualAmountToBeRisked = NormalizeDouble(euroAmountToRisk/differenceInPoints, 1) * differenceInPoints;
      
      OrderSend (Symbol(), OP_BUY, NormalizeDouble(euroPerPoint,1), Ask, 3, stopLossLevel, 0, NULL, 0, 0, CLR_NONE);
      
      Print ("Trade on SPX500(€) attempted by Place Order (Buy) (1%) (7.5 Point Stop) script.");
      Print ("Stop loss distance in points = " + DoubleToStr(differenceInPoints, 2));
      Print ("Account balance = " + accountBalance);
      Print ("1% of account = " + euroAmountToRisk + " (" + NormalizeDouble(actualAmountToBeRisked,2) + " actual)");
      Print ("Amount per point used (Volume) = " + NormalizeDouble(euroPerPoint,2) + " (" + NormalizeDouble(euroPerPoint,1) + " actual)");
      
      if (GetLastError() == 0) {
         Print("Order placed successfully.");
         Print("Place Order (Buy) (1%) (7.5 Point Stop) complete.");
      } else {
         Print("Error occured placing order. Error code = " + + GetLastError());
      }
         
   }  else {
      Print("This chart is not supported.");
      Print("Place Order (Buy) (1%) (7.5 Point Stop) complete.");
   }
}