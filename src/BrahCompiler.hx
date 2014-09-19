using BrahLines;
class BrahCompiler
{

  public var scrip_name:String;  
  // private var kines:Array<String>;
  public static var variables:Map<String,Dynamic>;
  public static var dakines:Array<Dakine>;
  public var out:List<BrahDirective>;

  public function new(scrip_name:String, main_src:String)
  {
    this.scrip_name = scrip_name;
    dakines = new Array<Dakine>();
    variables = new Map<String,Dynamic>();
    out = new List<BrahDirective>();

    var lines = main_src.split('\n');
    var line:String;
    var line_num = 0;
    var bd:BrahDirective;
    
    while(lines.length > 0){
      line = lines.shift();
      line_num++;
      
      parseLine(line, line_num);
    }

  }

  private inline function parseLine(line:String, line_num:Int):Void
  {
    var bd = {
      type : line.bdType(),
      line : line,
      line_number : line_num
    };
    out.add(bd);
    storeVars(bd);
  }

  // only store if VARIABLE
  private inline function storeVars(bd:BrahDirective):Void
  {
    switch (bd.type) {
      case VARIABLE(name,value):
        variables.set(name, value);
        dakines.push({
          position : bd.line_number,
          name : name
        });
      default: null;
    }
  }

  public static inline function compile(scrip_name:String, main_src:String):Void
  {
    var bc = new BrahCompiler(scrip_name, main_src);

    // temp dir
    var proc = new sys.io.Process( "mktemp" , ["-d", "-t", "brahscrip"] );
    var temp_path = proc.stdout.readLine();
    proc.close();

    // create sauce
    var main_class = scrip_name.titleize();
    var main_file_name = main_class + ".hx";
    var main_class_content = createClassFile(main_class, bc.out);
    sys.io.File.saveContent('${temp_path}/${main_file_name}', main_class_content);

    // compile
    proc = new sys.io.Process( "haxe" , ["-cp", temp_path, "-main", main_class, "-cpp", '${temp_path}/bin']);

    try{
      while( true )
      {
        Main.compiler_log(proc.stdout.readLine());
        Main.error(proc.stderr.readLine());
      }
    }catch( ex:haxe.io.Eof ){}
    var status = proc.exitCode();
    proc.close();

    // clean up
// #if debug
    Main.debug('Temp files saved to: $temp_path');
// #else
//     proc = new sys.io.Process( "rm" , ["-Rf", temp_path]);
// #end

    if(status == 0){
      sys.FileSystem.rename( '${temp_path}/bin/${main_class}', '${scrip_name}.brah' );
      Main.compiler_log('All Pau, compiled binary saved to: ${scrip_name}.brah');
    }else{
      Main.error('Too many errors brah, try fix!');
    }
  }
  private static inline function createClassFile(name:String, out:List<BrahDirective>):String
  {
    var content = new StringBuf();
    
    content.add('class $name{');
      content.add('public static function main(){');
        for(bd in out){
          content.add(bd.toHx());
          content.add('\n');
        }
      content.add('}');
    content.add('}');

    return content.toString();
  }
}