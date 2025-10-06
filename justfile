# path: justfile
default: dev

alias d := dev
alias b := build
alias t := test

set shell := ['bash', '-cu']

dev:
./scripts/dev.sh

build:
./scripts/build.sh

test args="":
./scripts/test.sh {{args}}

migrate args="":
./scripts/migrate.sh {{args}}

seed:
./scripts/seed.sh
