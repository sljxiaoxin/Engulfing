//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015, yjx |
//|                                              http://www.yjx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"

class CEngulfing
{  
   private:
      string symbol;
      string engulf;
      
   public:
      
      CEngulfing(string _symbol){
         symbol = _symbol;
         engulf = "none";
      };
      void Tick();
      string GetSymbol();
      string GetEngulf();
      double GetPip();
};

void CEngulfing::Tick(){
   engulf = "none";
   double high_prev = iHigh(symbol,0,2);
   double low_prev = iLow(symbol,0,2);
   double high_cur = iHigh(symbol,0,1);
   double low_cur = iLow(symbol,0,1);
   double open_prev = iOpen(symbol,0,2);
   double open_cur = iOpen(symbol,0,1);
   double close_prev = iClose(symbol,0,2);
   double close_cur = iClose(symbol,0,1);
   if(
      high_cur > high_prev &&
      low_cur < low_prev &&
      close_cur > close_prev && 
      open_prev > close_prev &&
      open_cur < close_cur && 
      close_cur > open_prev
   )
     {
         engulf = "up";
         if(close_cur - open_cur>21*GetPip()){
            engulf = "upCheck";
         }
     }

   if(
      high_cur > high_prev &&
      low_cur < low_prev &&
      close_cur < close_prev && 
      open_prev < close_prev &&
      open_cur > close_cur && 
      close_cur < open_prev
   )
     {
         engulf = "down";
         if(open_cur - close_cur>21*GetPip()){
            engulf = "downCheck";
         }
     }

}

string CEngulfing::GetSymbol(){
   return symbol;
}

string CEngulfing::GetEngulf(){
   return engulf;
}

double CEngulfing::GetPip(){
   double m_Pip;
   if(Digits==2 || Digits==4){
      m_Pip = Point;
   }else if(Digits==3 || Digits==5){
      m_Pip = 10*Point;
   }else if(Digits==6){
      m_Pip = 100*Point;
   }else{
      m_Pip = Point;
   }
   return m_Pip;
}