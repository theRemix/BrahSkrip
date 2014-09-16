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
          'var $name = "$val";';
      case ASSIGN(name, val): '$name = "$val";';
      case PRINT(val): 'Sys.println("$val");';
      case IF(condition): 'if($condition){';
      case ELSE_IF(condition): '}else if($condition){';
      case ELSE: "}else{";
      case ENDIF: "}";
      case UNKNOWN: "";
    }
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