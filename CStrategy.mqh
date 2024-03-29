//+------------------------------------------------------------------+
//|                                                   |
//|                                 Copyright 2015    |
//|                                              yangjx009@139.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018."
#property link      "http://www.yjx.com"




#include "util\CDrawLine.mqh";
#include "util\CDrawRect.mqh";
#include "util\CDrawArrow.mqh";

#include "trade\CTrade.mqh";
#include "trade\CEngulfing.mqh";

class CStrategy
{  
   private:
     bool     UseEmail;
     datetime CheckTime; 
     double   Lots;
     int      Tp;
     int      Sl;
     string   Result[];
     CEngulfing* oEngulfing[];
     
     CTrade* oCTrade;
     string   Tf; //当前时间框架
     
     void Update();
     void GetTrend();
     void OnTrendChange(); //trend change callback
     
     
   public:
      
      CStrategy(int Magic, bool _UseEmail, string symbols){
         UseEmail = _UseEmail;
         ushort u_sep=StringGetCharacter(";",0);
         int k=StringSplit(symbols,u_sep,Result);
         ArrayResize(oEngulfing, k+1);
         oEngulfing[0] = new CEngulfing(Symbol());
         for(int i=0;i<k;i++)
         {
            PrintFormat("symbols[%d]=%s",i,Result[i]);
            oEngulfing[i+1] = new CEngulfing(Result[i]);
         }
         oCTrade        = new CTrade(Magic);
         //Print("testing");
                
      };
      
      void Init(double _lots, int _tp, int _sl);
      void Tick();
      void Draw();
      void Entry();
      void Exit();
      string getTrend();
      void SendEmail(string symbol, string signal);
      string GetCurrentPeriod();
      
};

void CStrategy::Init(double _lots, int _tp, int _sl)
{
   Tf = GetCurrentPeriod();
   Lots = _lots;
   Tp = _tp;
   Sl = _sl;
}

void CStrategy::Tick(void)
{  
   int k = ArraySize(oEngulfing);
   for(int i=0;i<k;i++){
      //Print("testing x");
      oEngulfing[i].Tick();
   }
}

void CStrategy::Draw(){
   //Print("testing y");
   int k = ArraySize(oEngulfing);
   for(int i=0;i<k;i++){
      Print("current symbol :",oEngulfing[i].GetSymbol()," ；Engulf :",oEngulfing[i].GetEngulf());
      if(oEngulfing[i].GetEngulf() == "up"){
         if(i == 0)CDrawArrow::ArrowUp(TimeCurrent(),Low[1]-10*oCTrade.GetPip());
         SendEmail(oEngulfing[i].GetSymbol(), "up");
      }
      if(oEngulfing[i].GetEngulf() == "upCheck"){
         if(i == 0)CDrawArrow::ArrowStop(TimeCurrent(),Low[1]-10*oCTrade.GetPip());
         SendEmail(oEngulfing[i].GetSymbol(), "upCheck");
      }
      if(oEngulfing[i].GetEngulf() == "down"){
         if(i == 0)CDrawArrow::ArrowDown(TimeCurrent(),High[1]+10*oCTrade.GetPip());
         SendEmail(oEngulfing[i].GetSymbol(), "down");
      }
      if(oEngulfing[i].GetEngulf() == "downCheck"){
         if(i == 0)CDrawArrow::ArrowStop(TimeCurrent(),High[1]+10*oCTrade.GetPip());
         SendEmail(oEngulfing[i].GetSymbol(), "downCheck");
      }
   }
}



void CStrategy::Update()
{
   
}

string CStrategy::getTrend()
{
   return "none";//oCTrend.GetTrend();
}

void CStrategy::GetTrend()
{

   
}


void CStrategy::OnTrendChange()
{
   
}


void CStrategy::Exit()
{
   
}

void CStrategy::Entry()
{
   
   
}

void CStrategy::SendEmail(string symbol, string signal){
   
   string t=TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
   Print("Engulfing","["+t+"]"+symbol+" has triggered ["+signal+"] signal. TF is "+Tf);
   if(UseEmail)
   SendMail("Engulfing","["+t+"]"+symbol+" has triggered ["+signal+"] signal. TF is "+Tf);
}

string CStrategy::GetCurrentPeriod(){
   if(PERIOD_CURRENT == PERIOD_M5){
      return "M5";
   }else if(PERIOD_CURRENT == PERIOD_M15){
      return "M15";
   }else if(PERIOD_CURRENT == PERIOD_M30){
      return "M30";
   }else if(PERIOD_CURRENT == PERIOD_H1){
      return "H1";
   }else if(PERIOD_CURRENT == PERIOD_H4){
      return "H4";
   }else if(PERIOD_CURRENT == PERIOD_D1){
      return "D1";
   }else if(PERIOD_CURRENT == PERIOD_W1){
      return "W1";
   }else{
      return "Other";
   }
}