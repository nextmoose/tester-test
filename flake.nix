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
                  {
                    pass = tester : tester ( implementation : true ) true true ;
                    fail = tester : tester ( implementation : builtins.throw "35cfd89f-1b66-4fbf-a1ed-bfd6f4e0143e" ) false false ;
                  } ;
              }
          ) ;
  }
