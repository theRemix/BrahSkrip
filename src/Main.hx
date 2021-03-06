/*

  No args will compile 'main.scrip' to 'main.brah'

  brah test
  compiles 'test.scrip' to 'test.brah'

  brah main laddat
  transpiles to 'main.js'

  brah main now
  transpiles to 'main.js' and runs with node

*/

import sys.FileSystem;

class Main
{
  public function new()
  {
    var args = Sys.args();
    
    switch (args.length) {
      case 0:
        compile('main.scrip');
      case 1:
        compile(args[0]);
      case 2:
        if(args[1] == 'laddat'){
          transpile(args[0]);
        }else if(args[1] == 'now'){
          transpile(args[0]);
          // run node
        }
    }
  }

  private inline function compile(scrip_name:String):Void
  {
    if( !StringTools.endsWith(scrip_name, '.scrip') ) scrip_name += '.scrip';
    if(FileSystem.exists(scrip_name)){

      BrahCompiler.compile( scrip_name.substr(0, scrip_name.length - 6), sys.io.File.getContent(scrip_name) );

    }else error('${scrip_name} does not exist!');
  }

  private inline function transpile(scrip_name:String):Void
  {
    trace('transpiling ${scrip_name}');
  }

  public static inline function compiler_log(message:String):Void
  {
    Sys.println('[COMPILER] $message');
  }
  public static inline function debug(message:String):Void
  {
    Sys.println('[DEBUGGAH] $message');
  }
  public static inline function error(message:String):Void
  {
    Sys.println('FAKA! $message');
  }

  static public function main()
  {
    var app = new Main();
  }
}