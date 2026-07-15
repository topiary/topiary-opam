## Get an OPAM image. The tag can be changed by the `--build-arg` argument to
## the `docker build` command line. It will use an Alpine distribution by
## default.
ARG tag=alpine
FROM ocaml/opam:$tag

## Copy the build context to a working directory, then pin the working directory
## and install topiary and its external dependencies.
WORKDIR /home/opam/topiary-opam
ADD . .
RUN sudo chown -R opam .
RUN opam pin add --no-action topiary.dev .
RUN opam depext --install topiary

## Create a symbolic link in a consistent place and use that as an entrypoint.
RUN opam exec -- sh -c 'ln -s $(command -v topiary) /home/opam/topiary'
ENTRYPOINT [ "/home/opam/topiary" ]
