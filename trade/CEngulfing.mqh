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
      double m_Pip;
      datetime CheckTime; 
   public:
      
      CEngulfing(string _symbol){
         symbol = _symbol;
         engulf = "none";
         GetPip();
      };
      void Tick();
      string GetSymbol();
      string GetEngulf();
      double GetPip();
      void Draw();
      void SendEmail(string symbol, string signal);
};

void CEngulfing::Tick(){
   if(CheckTime != iTime(symbol,0,0)){
      CheckTime = iTime(symbol,0,0);
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
         if(close_cur - open_cur>21*m_Pip){
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
         if(open_cur - close_cur>21*m_Pip){
            //Print(open_cur,"#",close_cur,"#",GetPip(),"#");
            engulf = "downCheck";
         }
     }
     if(engulf != "none"){
         Draw();
     }
   }

   

}

string CEngulfing::GetSymbol(){
   return symbol;
}

string CEngulfing::GetEngulf(){
   return engulf;
}


void CEngulfing::Draw(){
   if(engulf == "up"){
      if(symbol == Symbol())CDrawArrow::ArrowUp(TimeCurrent(),Low[1]-10*m_Pip);
      SendEmail(symbol, "up");
   }
   if(engulf == "upCheck"){
      if(symbol == Symbol())CDrawArrow::ArrowStop(TimeCurrent(),Low[1]-10*m_Pip);
      SendEmail(symbol, "upCheck");
   }
   if(engulf == "down"){
      if(symbol == Symbol())CDrawArrow::ArrowDown(TimeCurrent(),High[1]+10*m_Pip);
      SendEmail(symbol, "down");
   }
   if(engulf == "downCheck"){
      if(symbol == Symbol())CDrawArrow::ArrowStop(TimeCurrent(),High[1]+10*m_Pip);
      SendEmail(symbol, "downCheck");
   }
}


double CEngulfing::GetPip(){
   
   double vpoint  = MarketInfo(symbol,MODE_POINT);
   int    vdigits = (int)MarketInfo(symbol,MODE_DIGITS);
   if(vdigits==2 || vdigits==4){
      m_Pip = vpoint;
   }else if(vdigits==3 || vdigits==5){
      m_Pip = 10*vpoint;
   }else if(vdigits==6){
      m_Pip = 100*vpoint;
   }else{
      m_Pip = vpoint;
   }
   return m_Pip;
}

void CEngulfing::SendEmail(string symbol, string signal){
   string t=TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
   Print("Engulfing","["+t+"]"+symbol+" has triggered ["+signal+"] signal.");
   if(UseEmail)
   SendMail("Engulfing","["+t+"]"+symbol+" has triggered ["+signal+"] signal.");
}