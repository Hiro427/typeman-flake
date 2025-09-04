## Warning 

Gui mode is not working, will work on that.


### Add to flake 

#### inputs

`typeman.url = "github:Hiro427/typeman-flake";`

#### outputs (example)
```
  outputs = { self, stylix, nixpkgs, home-manager, spicetify-nix, catppuccin
    , zen-browser, vicinae, typeman, ... }@inputs: {

    #flake stuff
    }
```

#### Add to configuration.nix 

```
{ config, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # your other packages...
    inputs.typeman.packages.${system}.default
  ];
}
```
