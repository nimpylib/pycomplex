## only test some parts, main parts will be tested under pylib
import std/unittest

import pycomplex

import std/unittest
import std/math except divmod
proc assertFloatsAreIdentical(x, y: float) =
  template `<->`(a, b: bool): bool = not (a xor b)
  check (x.isnan <-> y.isnan) or
      x == y and (x != 0.0 or copySign(1.0, x) == copySign(1.0, y))

template check(c: PyComplex; r, i) =
  let nc = c
  assertFloatsAreIdentical nc.real, r
  assertFloatsAreIdentical nc.imag, i

suite "complex.__init__(str)":
  test "from str":
      check(complex("1"), 1.0, 0.0)
      check(complex("1j"), 0.0, 1.0)
      check(complex("-1"), -1.0, 0.0)
      check(complex("+1"), 1.0, 0.0)
      check(complex("1+2j"), 1.0, 2.0)
      check(complex("(1+2j)"), 1.0, 2.0)
      check(complex("(1.5+4.25j)"), 1.5, 4.25)
      check(complex("4.25+1J"), 4.25, 1.0)
      check(complex(" ( +4.25-6J )"), 4.25, -6.0)
      check(complex(" ( +4.25-J )"), 4.25, -1.0)
      check(complex(" ( +4.25+j )"), 4.25, 1.0)
      check(complex("J"), 0.0, 1.0)
      check(complex("( j )"), 0.0, 1.0)
      check(complex("+J"), 0.0, 1.0)
      check(complex("( -j)"), 0.0, -1.0)
      check(complex("1-1j"), 1.0, -1.0)
      check(complex("1J"), 0.0, 1.0)

      check(complex("1e-500"), 0.0, 0.0)
      check(complex("-1e-500j"), 0.0, -0.0)
      check(complex("1e-500+1e-500j"), 0.0, 0.0)
      check(complex("-1e-500+1e-500j"), -0.0, 0.0)
      check(complex("1e-500-1e-500j"), 0.0, -0.0)
      check(complex("-1e-500-1e-500j"), -0.0, -0.0)

      # SF bug 543840:  complex(string) accepts strings with \0
      # Fixed in 2.3.
      expect ValueError: discard complex("1+1j\0j")
      expect ValueError: discard complex("")
      expect ValueError: discard complex("\0")
      expect ValueError: discard complex("3\x009")
      expect ValueError: discard complex("1+")
      expect ValueError: discard complex("1+1j+1j")
      expect ValueError: discard complex("--")
      expect ValueError: discard complex("(1+2j")
      expect ValueError: discard complex("1+2j)")
      expect ValueError: discard complex("1+(2j)")
      expect ValueError: discard complex("(1+2j)123")
      expect ValueError: discard complex("x")
      expect ValueError: discard complex("1j+2")
      expect ValueError: discard complex("1e1ej")
      expect ValueError: discard complex("1e++1ej")
      expect ValueError: discard complex(")1+2j(")


suite "complex":
  test "init":
    let z = complex(3.0, -4.0)
    check z.imag == -4.0
    check(complex(imag=1.5), 0.0, 1.5)
    check(complex(real=4.25, imag=1.5), 4.25, 1.5)
    check(complex(4.25, imag=1.5), 4.25, 1.5)
  test "literals":
    check 1-3.j == complex(1, -3)
    checkpoint "at compile-time"
    const c = -3-1.j
    check c.real == -3
    check c.imag == -1
  test "str":
    let z = complex(3.0, -4.0)
    check $z == "(3-4j)"
  test "op":
    let z = complex(3.0, -4.0)
    check z.conjugate() == complex(3.0, 4.0)
    check abs(z) == 5.0

suite "complex.__repr__":
  test "(N+nanj)":
    # there's once a bug str(complex(1, NaN)) == "(1nanj)"
  
    for i in countup(1, 4):
      check repr(complex(float(i), NaN)) == ("(" & $i & "+nanj)")
  test "real == 0.0":
    check repr(complex(0.0, NaN))  ==  "nanj"
    check repr(complex(-0.0, NaN)) == "(-0+nanj)"


