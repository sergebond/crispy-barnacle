PROJECT = crispy
PROJECT_DESCRIPTION = New project
PROJECT_VERSION = 0.1.0

# Whitespace to be used when creating files from templates.
SP = 2

# deps
DEPS = cowboy jiffy lager

# deps urls

dep_cowboy = git git@github.com:ninenines/cowboy.git 1.1.x
dep_jiffy = git git@github.com:davisp/jiffy.git
dep_lager = git git@github.com:erlang-lager/lager.git

# Compiler options.
ERLC_OPTS ?= -W1
ERLC_OPTS += +'{parse_transform, lager_transform}' +'{lager_truncation_size, 1024}'



include erlang.mk
