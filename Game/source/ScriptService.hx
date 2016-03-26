package;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;

/**
 * ...
 * @author ...
 */
class ScriptService
{
	private static var parser:Parser;
	private static var interp:Interp;
	
	public static function init() 
	{
		parser = new Parser();
		interp = new Interp();
		
		interp.variables.set("test", "yolo");
	}
	
	public static function parse(script:String):Expr
	{
		return parser.parseString(script);
	}
	
	public static function execute(expr:Expr):Dynamic
	{
		return interp.execute(expr);
	}
}