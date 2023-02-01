  {
    inputs = { flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ; nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;} ;
    outputs =
      { flake-utils , nixpkgs , self } :
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
		      let
		        pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
			in
		          {
		            happy1 = tester : tester ( testee : builtins.head ( builtins.attrNames ( testee implementation test ) ) ) true "devShell" ;
		            happy2 = tester : tester ( testee : builtins.attrNames ( testee implementation test ) ) true [ "devShell" ] ;
		          } ;
	      }
	  ) ;
  }