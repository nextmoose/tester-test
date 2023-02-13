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
                    pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                    in
                      {
                        happy = tester : tester ( implementation : check implementation { } ) true { devShell = pkgs.mkShell { buildInputs = [ ( pkgs.writeShellScriptBin "check" "" ) ] ; } ; } ;
                        sad = tester : tester ( implementation : check implementation null ) false false ;
                        float = tester : tester ( implementation : check implementation 0.0 ) false false ;
                      } ;
              }
          ) ;
  }