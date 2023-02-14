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
                        happy =
                          let
                            lambda = tester : tester ( implementation : check implementation { } ) true { devShell = pkgs.mkShell { buildInputs = [ ( pkgs.writeShellScriptBin "check" "" ) ] ; } ; } ;
                            in
                              {
                                empty =
                                  {
                                    list = tester : tester ( implementation : check implementation [ ] ) true { devShell = pkgs.mkShell { buildInputs = [ ( pkgs.writeShellScriptBin "check" "" ) ] ; } ; } ;
                                    set = tester : tester ( implementation : check implementation { } ) true { devShell = pkgs.mkShell { buildInputs = [ ( pkgs.writeShellScriptBin "check" "" ) ] ; } ; } ;
                                  } ;
                                singleton =
                                  {
                                  } ;
                              } ;
                          } ;
                        sad =
                          {
                            bool = tester : tester ( implementation : check implementation true ) false false ;
                            double = tester : tester ( implementation : check implementation 0.0 ) false false ;
                            int = tester : tester ( implementation : check implementation 0 ) false false ;
                            null = tester : tester ( implementation : check implementation null ) false false ;
                            path = tester : tester ( implementation : check implementation ./flake.nix ) false false ;
                            string = tester : tester ( implementation : check implementation "" ) false false ;
                          } ;
                      } ;
              }
          ) ;
  }