// Find date
// 1987/1/1
int fYear = 1999;
int fMonth = 1;
int fDay = 1; 

struct stats {
  string open;
  string high;
  string low;
  string close;
  string rsi;
  string stoch89;
  string stoch144;
};

const string symbol = Symbol();
const int period    = Period();

int totalBars = iBars(symbol, period);

stats details = { "", "", "", "", "", "", "" };

stats fileNames = {
   "open",
   "high",
   "low",
   "close",
   "rsi",
   "stoch89",
   "stoch144"
};

bool DeleteFileIfExists(string FileName) {
   if(FileIsExist(FileName)) {
      return FileDelete(FileName); 
   } else {
      return true; // File doesn't exist, no need to delete
   }
}

void OnInit() {
   datetime firstBarDate=iTime(Symbol(),0, totalBars - 1);
   Print("[First bar]: ", TimeToStr(firstBarDate));
   // [First bar]: 1971.01.04 00:00

   DeleteFileIfExists(fileNames.open     + "_" + symbol + "_" + period + ".csv");
   DeleteFileIfExists(fileNames.high     + "_" + symbol + "_" + period + ".csv");
   DeleteFileIfExists(fileNames.low      + "_" + symbol + "_" + period + ".csv");
   DeleteFileIfExists(fileNames.close    + "_" + symbol + "_" + period + ".csv");
   DeleteFileIfExists(fileNames.rsi      + "_" + symbol + "_" + period + ".csv");
   DeleteFileIfExists(fileNames.stoch89  + "_" + symbol + "_" + period + ".csv");
   DeleteFileIfExists(fileNames.stoch144 + "_" + symbol + "_" + period + ".csv");
   
}

void saveDataToFile(string fileName, string dataToAppend) {
   int filehandle=FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV,";");
   if(filehandle!=INVALID_HANDLE) {
      FileSeek(filehandle,0,SEEK_END);
      FileWriteString(filehandle, dataToAppend);
      FileFlush(filehandle);
      FileClose(filehandle);
   } else {
      int error = GetLastError();
      PrintFormat("Error opening file: %s, Error Code: %d", fileName, error);
   }
}

void saveData() {
   saveDataToFile(fileNames.open     + "_" + symbol + "_" + period + ".csv", details.open);
   saveDataToFile(fileNames.high     + "_" + symbol + "_" + period + ".csv", details.high);
   saveDataToFile(fileNames.low      + "_" + symbol + "_" + period + ".csv", details.low);
   saveDataToFile(fileNames.close    + "_" + symbol + "_" + period + ".csv", details.close);
   saveDataToFile(fileNames.rsi      + "_" + symbol + "_" + period + ".csv", details.rsi);
   saveDataToFile(fileNames.stoch89  + "_" + symbol + "_" + period + ".csv", details.stoch89);
   saveDataToFile(fileNames.stoch144 + "_" + symbol + "_" + period + ".csv", details.stoch144);
   
   details.open     = "";
   details.high     = "";
   details.low      = "";
   details.close    = "";
   details.rsi      = "";
   details.stoch89  = "";
   details.stoch144 = "";
}

void OnStart() {
   string sp       = ";";
   string nl       = "\n";
   
   int inc         = 10000; // OHLC
   
   int saveCounter = 0;
   int saveLimit   = 10000;
   
   for(int i=totalBars; i > 0; i--) {
      MqlDateTime cDate;
      TimeToStruct(iTime(NULL, 0, i),cDate);
      if(
         cDate.year >= fYear
      ) {
         
         if(saveCounter >= saveLimit) {
            saveData();
            saveCounter = 0;
         }
         
         saveCounter += 1;
         // Save date in format "2024/12/02 01:50:00"
         
         string currentDate = 
              string(cDate.year) + "/" + string(cDate.mon) + "/" + string(cDate.day) + " " 
            + string(cDate.hour) + ":" + string(cDate.min) + ":" + string(cDate.sec);
         string dayOfWeek   = string(cDate.day_of_week);
         
         details.open     += currentDate + sp + string(iOpen(symbol, period, i));
         details.high     += currentDate + sp + string(iHigh(symbol, period, i));
         details.low      += currentDate + sp + string(iLow(symbol, period, i));
         details.close    += currentDate + sp + string(iClose(symbol, period, i));
         details.rsi      += currentDate + sp + string(iRSI(symbol, period, 14, PRICE_CLOSE, i));
         details.stoch89  += currentDate + sp + string(iStochastic(symbol, period, 89, 1, 1, MODE_SMA, 0, MODE_MAIN, i));
         details.stoch144 += currentDate + sp + string(iStochastic(symbol, period, 144, 1, 1, MODE_SMA, 1, MODE_MAIN, i));
         
         if(i > 1) { 
            details.open     += nl; 
            details.high     += nl; 
            details.low      += nl; 
            details.close    += nl; 
            details.rsi      += nl; 
            details.stoch89  += nl; 
            details.stoch144 += nl; 
         }
      }
   }
   saveData();
}
  
void OnDeinit(const int reason) {
   Print(__FUNCTION__," Deinitialization reason code = ",reason);
}