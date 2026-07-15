OPAM Package for Topiary
========================

This repository provides an [OPAM] package for [Topiary]. In particular, issues
with Topiary itself should be reported [there][topiary-github-issues] while
issues with Topiary's packaging in OPAM should be reported [here][issues].

[opam]: https://opam.ocaml.org/
[topiary]: https://topiary.tweag.io/
[topiary-github-issues]: https://github.com/tweag/topiary/issues
[issues]: https://github.com/tweag/topiary-opam/issues

Context
-------

Topiary is written in Rust and is therefore not an OCaml project _per se_.
However, as it allows formatting OCaml (among other languages), it does belong
to its ecosystem and, therefore, it makes sense to package it via OPAM.

This is actually not so complicated. OPAM “is a source-based package manager for
OCaml”, which prevents using it to distribute precompiled binaries, but it is
actually OCaml agnostic, meaning it is possible to call `cargo build` in an OPAM
package.

The difficulty is then that such a package depends on the presence of Rust on
the system in the right version. Additionally, Cargo tends to download Rust
dependencies when building which cannot possibly happen in the OPAM sandbox. One
way around this is to provide another repository containing Topiary and all its
dependencies as well as what is necessary to get the OPAM package working. This
is where you are.

Credits are due to all the participants of [this OCaml discuss thread] for their
encouragements and their ideas and to the people behind [`tezos-rust-libs`] on
which this package is based.

[this OCaml discuss thread]: https://discuss.ocaml.org/t/two-questions-about-what-is-appropriate-to-package-with-opam/12030/
[`tezos-rust-libs`]: https://gitlab.com/tezos/tezos-rust-libs/-/tree/master

Availability
------------

The compilation of Topiary depends on the presence of Rust on the system in a
recent enough version. Currently, Rust 1.83.0 is required. [Our continuous
integration] keeps track of several distributions whose Rust version is listed
here for convenience:

[our continuous integration]: ./.github/workflow/ci.yml

| Distribution    | Rust Version
|-----------------|--------------
| Alpine          | [![][alpine_edge]][rust] [![][alpine_3_18]][rust] [![][alpine_3_17]][rust] [![][alpine_3_16]][rust]
| Archlinux       | [![][arch]][rust]
| CentOS          | [![][centos_stream_9]][rust] [![][centos_stream_8]][rust]
| Debian          | [![][debian_unstable]][rust] [![][debian_testing]][rust] [![][debian_12]][rust] [![][debian_11]][rust]
| Fedora          | [![][fedora_rawhide]][rust] [![][fedora_38]][rust] [![][fedora_37]][rust] [![][fedora_36]][rust]
| openSUSE        | [![][opensuse_tumbleweed]][rust] [![][opensuse_leap_15_5]][rust] [![][opensuse_leap_15_4]][rust]
| Ubuntu          | [![][ubuntu_24_10]][rust] [![][ubuntu_24_04]][rust] [![][ubuntu_23_04]][rust]

[alpine_edge]: https://repology.org/badge/version-for-repo/alpine_edge/rust.svg?header=Edge&minversion=1.83.0
[alpine_3_18]: https://repology.org/badge/version-for-repo/alpine_3_18/rust.svg?header=3.18&minversion=1.83.0
[alpine_3_17]: https://repology.org/badge/version-for-repo/alpine_3_17/rust.svg?header=3.17&minversion=1.83.0
[alpine_3_16]: https://repology.org/badge/version-for-repo/alpine_3_16/rust.svg?header=3.16&minversion=1.83.0

[arch]: https://repology.org/badge/version-for-repo/arch/rust.svg?header=&minversion=1.83.0

[centos_stream_8]: https://repology.org/badge/version-for-repo/centos_stream_8/rust.svg?header=Stream%208&minversion=1.83.0
[centos_stream_9]: https://repology.org/badge/version-for-repo/centos_stream_9/rust.svg?header=Stream%209&minversion=1.83.0

[debian_11]: https://repology.org/badge/version-for-repo/debian_11/rust.svg?header=11&minversion=1.83.0
[debian_12]: https://repology.org/badge/version-for-repo/debian_12/rust.svg?header=12&minversion=1.83.0
[debian_testing]: https://repology.org/badge/version-for-repo/debian_13/rust.svg?header=Testing&minversion=1.83.0
[debian_unstable]: https://repology.org/badge/version-for-repo/debian_unstable/rust.svg?header=Unstable&minversion=1.83.0

[fedora_rawhide]: https://repology.org/badge/version-for-repo/fedora_rawhide/rust.svg?header=Rawhide&minversion=1.83.0
[fedora_38]: https://repology.org/badge/version-for-repo/fedora_38/rust.svg?header=38&minversion=1.83.0
[fedora_37]: https://repology.org/badge/version-for-repo/fedora_37/rust.svg?header=37&minversion=1.83.0
[fedora_36]: https://repology.org/badge/version-for-repo/fedora_36/rust.svg?header=36&minversion=1.83.0

[opensuse_tumbleweed]: https://repology.org/badge/version-for-repo/opensuse_tumbleweed/rust.svg?header=Tumbleweed&minversion=1.83.0
[opensuse_leap_15_5]: https://repology.org/badge/version-for-repo/opensuse_leap_15_5/rust.svg?header=Leap%2015.5&minversion=1.83.0
[opensuse_leap_15_4]: https://repology.org/badge/version-for-repo/opensuse_leap_15_4/rust.svg?header=Leap%2015.4&minversion=1.83.0

[ubuntu_24_10]: https://repology.org/badge/version-for-repo/ubuntu_24_10/rust.svg?header=23.10&minversion=1.83.0
[ubuntu_24_04]: https://repology.org/badge/version-for-repo/ubuntu_24_04/rust.svg?header=23.04&minversion=1.83.0
[ubuntu_23_04]: https://repology.org/badge/version-for-repo/ubuntu_23_04/rust.svg?header=22.04&minversion=1.83.0

[rust]: https://repology.org/project/rust/versions

How this works
--------------

This repository is made of the following building blocks:

- `topiary/` is a [Git submodule] pointing to [Topiary's Git][topiary-github] at
  a certain commit (in general at a certain tag). The file `.gitmodules`
  declares the submodule to Git.

- `Cargo.toml` and `Cargo.lock` define a Cargo workspace containing only
  Topiary. This allows working with Cargo to vendor dependencies without
  changing the content of the `topiary/` directory.

- `vendor/` is a directory filled automatically by Cargo and containing all the
  dependencies of Topiary, vendored. This is a way to provide all the
  dependencies at upfront and to avoid having Cargo download them during the
  installation. The file `.cargo/config.toml` contains a configuration that
  tells Cargo to look into `vendor/` instead of its usual sources.

- `make-topiary-wrapper.sh` is a Shell script creating a wrapper around Topiary
  that provides it with the right environment. In particular, Topiary needs to
  be made aware of where it can find its “language files”.

- `topiary.opam` contains the definition of the OPAM package for Topiary.

[topiary-github]: https://github.com/tweag/topiary
[git submodule]: https://git-scm.com/book/en/v2/Git-Tools-Submodules

How to develop
--------------

Make sure you have Rust and Cargo. This repository comes with a Nix flake, so
simply running:

```console
$ nix develop
```

should provide you with everything you need. Alternatively, on a `Nix` machine,
you can use:

```console
$ nix shell nixpkgs#{cargo,rustc}
```

Use OPAM's pinning mechanism to inform it of the development version of Topiary.

```console
$ opam pin add --no-action topiary.dev /path/to/this/repository
[topiary.dev] synchronised (file:///path/to/this/repository)
topiary is now pinned to git+file:///path/to/this/repository#branch-name (version dev)
```

From the root of this repository, `.` suffices; OPAM will make an absolute link
out of this. After this, you can simply rely on OPAM's usual commands and you
will get access to a new version of Topiary, `dev`:

```console
$ opam show topiary

<><> topiary: information on all versions <><><><><><><><><><><><><><><><><><><>
name         topiary
all-versions 0.1.0  0.2.0  0.2.1  0.2.2  0.2.3  dev

<><> Version-specific details <><><><><><><><><><><><><><><><><><><><><><><><><>
version     dev
pin         git+file:///path/to/this/repository#branch-name
[...]

$ opam install topiary

<><> Synchronising pinned packages ><><><><><><><><><><><><><><><><><><><><><><>
[topiary.dev] synchronised (git+file:///path/to/this/repository#branch-name)

The following actions will be performed:
  ∗ install topiary dev*

<><> Processing actions <><><><><><><><><><><><><><><><><><><><><><><><><><><><>
⬇ retrieved topiary.dev  (no changes)
∗ installed topiary.dev
Done.
```

If your working directory is not clean, you might want to add `--working-dir`
(or `-w` for short) to your commands; otherwise, OPAM only picks up on the Git
index and not the work tree. Be careful, though, as this might hide some subtle
bugs due to some files not being committed.

How to update
-------------

- Update the [Git submodule] containing Topiary. Make sure it is checked out at
  a tag of your choosing:
  ```console
  $ cd topiary
  $ git fetch
  remote: Enumerating objects: 299, done.
  [...]
  From ssh://github.com/tweag/topiary
   * [new tag] v0.1.0 -> v0.1.0
  $ git checkout v0.1.0
  HEAD is now at c4fe76c GraphViz visualisation support (#326)
  $ cd ..
  ```

- Commit this update:
  ```console
  $ git add topiary/
  $ git commit -m 'Bump submodule to v0.1.0'
  [main 3bb3a28] Bump submodule to v0.1.0
   1 file changed, 1 insertion(+), 1 deletion(-)
  ```

- Remove the previous local Cargo configuration and vendoring:
  ```console
  $ rm .cargo/config.toml
  $ rm -R vendor/
  ```
  Otherwise, the next step will yield an error, something in the lines of:
  “failed to get `<whatever>` as a dependency of package `topiary`”.

- Update the `Cargo.toml` file. This usually consists in copying the content of
  `topiary/Cargo.toml` file and prefixing all the local paths by `topiary/`. In
  particular, `workspace.members` and `workspace.default-members` need to be
  updated. Sometimes, locally vendored dependencies might need the same
  treatment, as in for instance:
  ```toml
  topiary-web-tree-sitter-sys = { version = "0.5.1", path = "./topiary/topiary-web-tree-sitter-sys" }
  ```
  Make sure that the version number in `Cargo.toml` is correct; this is trivial
  if it was copied from the `topiary/` submodule.

- Update the `Cargo.lock` file. Again, this usually consists in copying the one
  from `topiary/Cargo.lock`.

- Regenerate the `vendor/` directory:
  ```console
  $ cargo vendor
    Downloaded hermit-abi v0.1.19
    Downloaded is-terminal v0.4.7
    Downloaded instant v0.1.12
  [...]
     Vendoring indexmap v1.9.3 (~/.cargo/registry/src/github.com-1ecc6299db9ec823/indexmap-1.9.3) to vendor/indexmap
     Vendoring instant v0.1.12 (~/.cargo/registry/src/github.com-1ecc6299db9ec823/instant-0.1.12) to vendor/instant
     Vendoring io-lifetimes v1.0.10 (~/.cargo/registry/src/github.com-1ecc6299db9ec823/io-lifetimes-1.0.10) to vendor/io-lifetimes
     Vendoring is-terminal v0.4.7 (~/.cargo/registry/src/github.com-1ecc6299db9ec823/is-terminal-0.4.7) to vendor/is-terminal
  [...]
  To use vendored sources, add this to your .cargo/config.toml for this project:

  [source.crates-io]
  replace-with = "vendored-sources"

  [...]

  [source.vendored-sources]
  directory = "vendor"
  ```
  Note in particular the last lines about adding something to the local Cargo
  configuration.

- Recreate the local Cargo configuration with the content given by `cargo
  vendor`.
  ```console
  $ nano .cargo/config.toml
  ```

- Commit this update:
  ```console
  $ git add Cargo.toml Cargo.lock .cargo/
  $ git add --force vendor/
  $ git commit -m 'Update Cargo dependencies'
  [main 95d67dc] Update Cargo dependencies
   8 files changed, 125 insertions(+), 57 deletions(-)
  ```
  Note that we use `--force` when adding `vendor/` because we otherwise risk
  ignoring files due to `.gitignore` which Cargo will still expect.

- Adapt the OPAM package or the other files if necessary and commit the changes.

- Test that it looks like it works (see [How to develop](#how-to-develop)).

- Open a [new pull request] on this repository and check that the continuous
  integration is happy with the current status of things. Merge the pull request
  in question.

- Add a tag mimmicking that of Topiary (eg. `v0.1.0` for Topiary's `v0.1.0`).

- Create an archive containing all the content of this repository at that tag:
  ```console
  $ git-archive-all source-code-with-submodules.tar.xz
  ```
  This will be necessary to provide a downloadable archive that contains the
  files from all the submodules.

- Create a release for the tag in question. Link to the corresponding release in
  Topiary. Attach the archive.

- Compute the MD5 and SHA512 sums of the archive in question:
  ```console
  $ md5sum source-code-with-submodules.tar.xz
  cd825a17db25cb94fd876eef055090e4  source-code-with-submodules.tar.xz
  $ sha512sum source-code-with-submodules.tar.xz
  ae6946aaba0f784773cca71019f73aa62d9b976646ea25e451c220f45da49e6c7e4147e2dd57e3c4764a9038946c38b9de33ce5d463c46ea3f3271d5b98dd46f  source-code-with-submodules.tar.xz
  ```

- Send the new package to the [OPAM repository]. The `src` field of the `url`
  object should be:
  ```
  https://github.com/tweag/topiary-opam/releases/download/<tag>/source-code-with-submodules.tar.xz
  ```

[new pull request]: https://github.com/tweag/topiary-opam/compare
[opam repository]: https://github.com/ocaml/opam-repository
