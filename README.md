
# pycomplex

[![Test](https://github.com/nimpylib/pycomplex/actions/workflows/ci.yml/badge.svg)](https://github.com/nimpylib/pycomplex/actions/workflows/ci.yml)
[![Docs](https://github.com/nimpylib/pycomplex/actions/workflows/docs.yml/badge.svg)](https://github.com/nimpylib/pycomplex/actions/workflows/docs.yml)
<!--[![Commits](https://img.shields.io/github/last-commit/nimpylib/pycomplex?style=flat)](https://github.com/nimpylib/pycomplex/commits/)-->

---

[Docs](https://nimpylib.github.io/pycomplex/)

This library provide a new `complex` implementation.
in which complex behaves just like Python's

## Why not use `std/complex`?

### Main Reason
This library aims at behaving like `complex` in Python,

but `Complex` type in `std/complex` behaves differently in:

- repr
- hash

The main reason to make `PyComplex` in this libary a distinct type from `Complex` of `std/complex` is that
this library is also to be used
by nimpylib,

so we need its Nim API to be like Python's API

### Reasons at detail level

Python's function often be "too" complicated.

For example, in Python, pow for complex (`complex.__pow__`)
is far away from just adopting the definition of Power of Complex Number.

As CPython's comment said, they're not satisfied with the precision
of that algorithm in boundary cases, etc..

So CPython's `pow` does more than Nim's.

That why I port CPython's `complex.__pow__` instead of just reusing Nim's

### Triple Reason

In addition, `std/complex` lacks many useful routinues like
`parsePyComplex` (parse complex from string)

> You can use `toNimComplex` to convert back to Nim's std Complex

### Other Notiable Difference
None of procedures in `std/complex` raises Exception,
they just fail silently, returning either Infinity or NaN.

Procedures in this library raises explicitly, just as Python does.

And to make it better, Nim's Effect System make it easy
to track the kind of exceptions each functions may raise.
