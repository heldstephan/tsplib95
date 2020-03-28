import pytest

from tsplib95 import bisep


@pytest.mark.parametrize('sep,mx,text,items', [
    (None, 1, 'x y\nz', ['x', 'y\nz']),
    (None, None, 'x y\nz', ['x', 'y', 'z']),
    ('-', None, 'x y-z w', ['x y', 'z w']),
])
def test_bisetp_split(sep, mx, text, items):
    d = bisep.BiSep(in_=sep)
    assert d.split(text, maxsplit=mx) == items


@pytest.mark.parametrize('sep,items,text', [
    (None, ['x', 'y\nz'], 'x y\nz'),
    (None, ['x', 'y', 'z'], 'x y z'),
    ('-', ['x y', 'z w'], 'x y-z w'),
])
def test_bisetp_join(sep, items, text):
    d = bisep.BiSep(out=sep)
    assert d.join(items) == text


@pytest.mark.parametrize('v,i,o', [
    (None, None, None),
    ('foo', 'foo', 'foo'),
    (('foo', 'bar'), 'foo', 'bar'),
])
def test_bisetp_from_value(v, i, o):
    d = bisep.from_value(v)
    assert d.i == i
    assert d.o == o
