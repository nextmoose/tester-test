  {
    inputs =
      {
        flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f" ;
        nixpkgs.url = "github:nixos/nixpkgs?rev=57eac89459226f3ec743ffa6bbbc1042f5836843" ;
      } ;
    outputs =
      { flake-utils , self , nixpkgs } :
        flake-utils.lib.eachDefaultSystem
          (
            system :
              {
                lib =
                  let
                    check =
                      implementation : test :
                        let
                          mock =
                            contents :
                              {
                                lib =
                                  {
                                    "${ system }" = contents ;
                                  } ;
                              } ;
                          in implementation ( mock null ) ( mock test ) ;
                    good = tester : tester ( implementation : true ) true true ;
                    pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                    in
                      {
		        happy = good ;
                      } ;
	      }
          ) ;
  }