  {
    inputs = { flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ; } ;
    outputs =
      { flake-utils , self } :
        flake-utils.lib.eachDefaultSystem
	  (
	    system :
	      {
	        lib =
		  let
		    implementation =
		      {
		        lib =
			  {
		            "${ system }" = null ;
			  } ;
		      } ;
		      test = implementation ;
		    in
		      {
		        happy = tester : tester "6be2b381-e0e6-4041-9de1-4627c573874d" ( testee : builtins.concatStringsSep "" ( builtins.attrNames ( testee implementation test ) ) ) true "devShell" ;
		      } ;
	      }
	  ) ;
  }