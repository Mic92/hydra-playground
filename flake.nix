{
  description = "Trivial jobset to exercise the staging cache zstd upload path";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      # Unique marker so the output path does not already exist in the cache,
      # forcing the queue runner to upload a fresh NAR + .ls listing.
      marker = "zstd-test-20260624-134717";
    in
    {
      hydraJobs.zstd-listing.x86_64-linux = pkgs.runCommand "staging-${marker}" { } ''
        mkdir -p $out/share/sub/dir
        echo "${marker}" > $out/share/marker.txt
        echo hi > $out/share/sub/dir/nested.txt
        ln -s marker.txt $out/share/link.txt
      '';
    };
}
