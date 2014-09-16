using BrahLines;
class BrahCompiler
{
  
  // private var kines:Array<String>;
  // private var dakines:Array<String>;
  private var out:List<BrahDirective>;

  public function new(main_src:String)
  {
    // dakines = new Array<String>();
    out = new List<BrahDirective>();

    var lines = main_src.split('\n');
    var line:String;
    var line_num = 0;
    
    while(lines.length > 0){
      line = lines.shift();
      line_num++;

      if(line.isMultiline()){
        var multiline = new Array<BrahDirective>();
        while( lines.length > 0 && !line.isMultilineEnd(multiline[0]) ){
          multiline.push({
            type : line.bdType(),
            line : line,
            line_number : line_num
          });
          line = lines.shift();
          line_num++;
        }
        parseMultiline(multiline);
      }else{
        parseLine(line, line_num);
      }
    }

    trace(out);

  }

  private inline function parseLine(line:String, line_num:Int):Void
  {
    out.add({
      type : line.bdType(),
      line : line,
      line_number : line_num
    });
  }

  private inline function parseMultiline(multiline:Array<BrahDirective>):Void
  {
    
  }  

  public static inline function compile(main_src:String):Void
  {
    var bc = new BrahCompiler(main_src);
  }
}