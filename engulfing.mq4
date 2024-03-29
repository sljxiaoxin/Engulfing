//+------------------------------------------------------------------+
//
//+------------------------------------------------------------------+
#property copyright "xiaoxin003"
#property link      "yangjx009@139.com"
#property version   "1.0"
#property strict

#include "CStrategy.mqh";
 
extern int       Input_MagicNumber  = 20191103;  
extern string    LabelUE             = "Email Settings:";
extern bool      UseEmail            = true;  
extern double    Input_Lots         = 0.1;
extern int       Input_intTP        = 0;
extern int       Input_intSL        = 0;
extern string    Input_symbols      = "USDJPY;USDCAD;USDCHF;GBPUSD;NZDUSD;GBPJPY;EURJPY;AUDCAD;AUDCHF;AUDJPY;CADJPY;CHFJPY;EURCAD";
      

CStrategy* oCStrategy;

int testIdx = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//---
   Print("begin");
   if(oCStrategy == NULL){
      oCStrategy = new CStrategy(Input_MagicNumber,UseEmail,Input_symbols);
   }
   oCStrategy.Init(Input_Lots,Input_intTP,Input_intSL);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Print("deinit");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
{
   testIdx+=1;
   if(testIdx == 20){
      string t=TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS);
      if(UseEmail)
      SendMail("Engulfing","["+t+"] ea opened ok!!!!");
   }
   oCStrategy.Tick();
   subPrintDetails();
}


void subPrintDetails()
{
   //
   string sComment   = "";
   string sp         = "----------------------------------------\n";
   string NL         = "\n";

   sComment = sp;
   sComment = sComment + "Trend = " + oCStrategy.getTrend() + NL; 
   sComment = sComment + sp;
   sComment = sComment + sp;
   //sComment = sComment + "Lots=" + DoubleToStr(Lots,2) + NL;
   Comment(sComment);
}


