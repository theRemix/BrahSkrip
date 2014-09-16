enum BrahDirectiveType {
  VARIABLE(name:String, ?val:Dynamic); // and ASSIGN
  ASSIGN(name:String, val:Dynamic);
  PRINT(val:Dynamic);
  IF(condition:String);
  ELSE_IF(condition:String);
  ELSE;
  ENDIF;
  UNKNOWN;
}