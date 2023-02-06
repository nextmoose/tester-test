  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
        utils.url = "github:nextmoose/utils" ;
      } ;
    outputs =
      { flake-utils , nixpkgs , self , utils } :
        flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                lib =
                  let
		    bad =
		      {
		        test =
			  {
			    lib =
			      {
			        "${ system }" = null ;
			      } ;
			  } ;
		      } ;
		    good =
		      {
                        implementation =
                          {
                            lib =
                              {
                                "${ system }" = null ;
                              } ;
                          } ;
                        test =
                          {
                            lib =
                              {
                                "${ system }" = [ ] ;
                              } ;
                          } ;
		      } ;
                    script =
                      ''
                        if [ "" == "${ _utils.bash-variable "1" }" ]
                        then
                          ${ pkgs.coreutils }/bin/echo PASSED &&
                          exit 0
                        else
                          ${ pkgs.coreutils }/bin/echo FAILED &&
                          ${ pkgs.coreutils }/bin/echo FAILURE== &&
                          exit 64
                        fi
                      '' ;
                    pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                    _utils = builtins.getAttr system utils.lib ;
                    in
                      let
                        in
                          [
                            ( tester : tester ( testee : testee good.implementation good.test ) true { devShell = pkgs.mkShell { buildInputs = [ ( pkgs.writeShellScriptBin "check" script ) ] ; } ; } )
                            ( tester : tester ( testee : testee good.implementation bad.test ) false null )
                          ] ;
              }
          ) ;
  }