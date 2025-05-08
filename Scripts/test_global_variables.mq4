// Access test of global variables: Tools -> Global variables or F3

void OnInit() {
   GlobalVariablesDeleteAll(NULL, 0);
   
   int tot = 10;
   Print("TOTAL: " + GlobalVariablesTotal() + " " + string(tot));
      for(int i = 0; i < tot; i++) {
       string name = TimeToStr(iTime(NULL,0,i), TIME_DATE|TIME_MINUTES);
       int value = i;
       GlobalVariableSet(name, value);
   } 
}

void OnStart() {
   Print("TOTAL: " + GlobalVariablesTotal());
   for(int i = 0; i < GlobalVariablesTotal(); i++) {
      string name = GlobalVariableName(i);
      int value = GlobalVariableGet(name);
      Print(name + " " + string(value));
   }
   // Un comment line bellow to clear global variables
   //GlobalVariablesDeleteAll(NULL, 0);
}
  
void OnDeinit() {
   Print(__FUNCTION__," Deinitialization reason code = ",reason);
}