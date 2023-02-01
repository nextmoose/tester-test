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
		            happy1 = tester : tester "6be2b381-e0e6-4041-9de1-4627c573874d" ( testee : builtins.head ( builtins.attrNames ( testee implementation test ) ) ) true "devShell" ;
		            happy2 = tester : tester "a85d55b4-1c6d-4591-8e5f-2d34c14183a9" ( testee : builtins.attrNames ( testee implementation test ) ) true [ "devShell" ] ;
		            happy3 = tester : tester "b7f9625b-02c0-4b98-9b4b-0fefdd7d1640" ( testee : builtins.head ( testee implementation test ) ) true ( pkgs.mkShell { } ) ;
		          } ;
	      }
	  ) ;
  }