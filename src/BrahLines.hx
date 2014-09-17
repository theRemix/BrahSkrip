using BrahLines;
class BrahLines
{

  public static inline function bdType(line:String):BrahDirectiveType
  {
    line = StringTools.trim(line);

    // VARIABLE(name:String);
    if( StringTools.startsWith( line, '${Syntax.VARIABLE} ' )){
      var pair = StringTools.trim(line.substr(Syntax.VARIABLE.length)).split( Syntax.ASSIGN );
      var name = StringTools.trim(pair[0]);

      if(pair.length > 1){
        var val = StringTools.trim(pair[1]);
        // VARIABLE(name:String, ?val:Dynamic); and ASSIGN
        return VARIABLE( name, val );
      }else{
        return VARIABLE( name );
      }
    }else

    // ASSIGN(val:Dynamic);
    if( line.split( Syntax.ASSIGN ).length > 1 ){
      var pair = line.split( Syntax.ASSIGN );
      return ASSIGN(
        StringTools.trim( pair[0] ),
        StringTools.trim( pair[1] )
      );
    }else

    // PRINT(val:Dynamic);
    if( StringTools.startsWith( line, Syntax.PRINT ) ){
      return PRINT( line.substr(Syntax.PRINT.length) );
    }else

    // IF(condition:String);
    if( StringTools.endsWith( line, Syntax.IF ) ){
      return IF( line.substr(0, line.length - Syntax.IF.length ) );
    }else

    // ELSE; ELSE_IF(condition:String);
    if( StringTools.startsWith( line, Syntax.ELSE ) ){

      if( StringTools.endsWith( line, Syntax.IF ) ){
        // ELSE_IF(condition:String);
        return ELSE_IF( line.substr( Syntax.ELSE.length, line.length - Syntax.ELSE.length - Syntax.IF.length ) );
      }else{
        // ELSE;
        return ELSE;
      }

    }else

    // ENDIF
    if( line == Syntax.END ){
      return ENDIF;
    }else
    // nothing
    {
      return UNKNOWN;
    }
  }

  public static inline function toHx(bd:BrahDirective):String
  {
    return switch (bd.type) {
      case VARIABLE(name, val):
        if(val == null)
          'var $name;';
        else
          'var $name = ${eval(val)};';
      case ASSIGN(name, val): '$name = "$val";';
      case PRINT(val): 'Sys.println(${string_eval(val)});';
      case IF(condition): 'if($condition){';
      case ELSE_IF(condition): '}else if($condition){';
      case ELSE: "}else{";
      case ENDIF: "}";
      case UNKNOWN: "";
    }
  }

  /*
    if val is multiword, eval each word, concat each string and add each number or variable

    if val is a variable, use variable name
    else
      if its a number
        return the number
      else
        quote val and return
  */
  public static inline function eval(val:Dynamic):String
  {
    var vals = Std.string(val).split(" ");
    if( vals.length > 1 ){

      // might not need to do it before hand
      for(v in 0...vals.length){
        vals[v] = eval(vals[v]);
      }

      return Lambda.fold(vals, function (b:String, a:String):String
      {
        if( a.evalsLiteralString() ){ // a is literal
          if( b.evalsLiteralString() ){ // combine
            return a.substr(0, a.length-1) + " " + b.substr(1);
          }else{ // b is number or variable
            return a + ' + " " + ' + b;
          }
        }else{
          return a + ' + " " + ' + b;
        }

      }, '""');
    }
    if(BrahCompiler.variables.exists( StringTools.trim( Std.string(val) ))){
      return Std.string(val);
    }else{
      if( Std.parseFloat(val) == val ){
        return Std.string( Std.parseFloat(val) );
      }else if( Std.parseInt(val) == val ){
        return Std.string( Std.parseInt(val) );
      }else{ // String;
        return '"${ Std.string( val ) }"';
      }
    }
  }

  /*
    like eval, except only for Sys.println
    always returns strings
  */
  private static inline function string_eval(val:Dynamic):String
  {
    var vals = Std.string(val).split(" ");
    if( vals.length > 1 ){

      // might not need to do it before hand
      for(v in 0...vals.length){
        vals[v] = eval(vals[v]);
      }

      return Lambda.fold(vals, function (b:String, a:String):String
      {
        if( a.evalsLiteralString() ){ // a is literal
          if( b.evalsLiteralString() ){ // combine
            return a.substr(0, a.length-1) + " " + b.substr(1);
          }else{ // b is number or variable
            return a + ' + " " + Std.string(' + b + ')';
          }
        }else{
          return 'Std.string(' + a + ') + " " + ' + b;
        }

      }, '""');
    }
    if(BrahCompiler.variables.exists( StringTools.trim( Std.string(val) ))){
      return Std.string(val);
    }else{
      if( Std.parseFloat(val) == val ){
        return Std.string( Std.parseFloat(val) );
      }else if( Std.parseInt(val) == val ){
        return Std.string( Std.parseInt(val) );
      }else{ // String;
        return '"${ Std.string( val ) }"';
      }
    }
  }

  public static inline function evalsLiteralString(a:String):Bool
  {
    return StringTools.startsWith(a, '"') && StringTools.endsWith(a, '"');
  }

  public static inline function isMultiline(line:String):Bool
  {
    // if conditional
    if( StringTools.endsWith( StringTools.rtrim(line), Syntax.IF) ){
      return true;
    }

    return false;
  }

  public static inline function isMultilineEnd(line:String, first_line:BrahDirective):Bool
  {
    // if conditional
    if( StringTools.endsWith( StringTools.rtrim(first_line.line), Syntax.IF) 
      && StringTools.trim(line) == Syntax.END ){
        return true;
    }

    return false;
  }

  public static inline function titleize(name:String):String
  {
    return name.charAt(0).toUpperCase() + name.substr(1);
  }
}