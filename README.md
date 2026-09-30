[01]: https://sr.ht/~subsetpark/bagatto
[02]: https://bagatto.co/manual
[03]: https://freebsd.free.org/ports
[04]: https://janet-lang.org
[05]: https://www.freshports.org/devel/janet-lsp
[06]: https://man.freebsd.org/cgi/man.cgi?query=jpm&sektion=1

[10]: https://reviews.freebsd.org/D60165


# FreeBSD port for bagatto

This is not the actual [code][01], or [manual][02]. This is just a drop in
[port][03]:

```
# cd /usr/ports/www
# git clone https://github.com/dmarker/bagatto.port bagatto
# cd bagatto
# make install clean
```

## WARNING:
Until [D60165][10] lands in the ports tree and packages are made from it you
can't use `bagatto`. The fix has been upstreamed its just not in a version of
[Janet][04] available in pkg/port yet!

## Why?

Its actually me testing how I can streamline [Janet][04] [ports][03]. Because I
think [Janet][04] is uniquely well suited for this. I do already maintain
[devel/janet-lsp][05], but that example was all github and no sub-trees.

This is actually a better example in some ways as it has to pull code from
multiple sources and has a git sub-tree to deal with. All common things you
might encounter while working with [Janet][04] projects.

The `post-extract`, `do-build`, `do-test` should all work for any Janet project
as is. `do-install` is unique to each project. This one is trivial because its
making a single `declare-executable`, where [devel/janet-lsp][05] has more work
since it has a `declare-archive` and `declare-binscript`.

I like that [jpm(1)][06] allows us to do this offline work using `install`. I
like that in the end I get to sort out the hashes and ordering. I'm definitely
in the camp of not wanting a dependency solver. This is just enough help exactly
where and how I need it to port something.

## Tricks

In the Makefile I set: ```PATCH_WRKSRC=    ${WRKDIR}```

This allows you to create patches (via `make makepatch` even) for any of the
source code that is part of the project, not just the main project. I don't need
that for this port, but its nice to know you could do so if necessary.
