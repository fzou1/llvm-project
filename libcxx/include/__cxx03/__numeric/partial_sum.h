// -*- C++ -*-
//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___CXX03___NUMERIC_PARTIAL_SUM_H
#define _LIBCPP___CXX03___NUMERIC_PARTIAL_SUM_H

#include <__cxx03/__config>
#include <__cxx03/__iterator/iterator_traits.h>
#include <__cxx03/__utility/move.h>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#  pragma GCC system_header
#endif

_LIBCPP_PUSH_MACROS
#include <__cxx03/__undef_macros>

_LIBCPP_BEGIN_NAMESPACE_STD

template <class _InputIterator, class _OutputIterator>
_LIBCPP_HIDE_FROM_ABI _OutputIterator
partial_sum(_InputIterator __first, _InputIterator __last, _OutputIterator __result) {
  if (__first != __last) {
    typename iterator_traits<_InputIterator>::value_type __t(*__first);
    *__result = __t;
    for (++__first, (void)++__result; __first != __last; ++__first, (void)++__result) {
      __t       = __t + *__first;
      *__result = __t;
    }
  }
  return __result;
}

template <class _InputIterator, class _OutputIterator, class _BinaryOperation>
_LIBCPP_HIDE_FROM_ABI _OutputIterator
partial_sum(_InputIterator __first, _InputIterator __last, _OutputIterator __result, _BinaryOperation __binary_op) {
  if (__first != __last) {
    typename iterator_traits<_InputIterator>::value_type __t(*__first);
    *__result = __t;
    for (++__first, (void)++__result; __first != __last; ++__first, (void)++__result) {
      __t       = __binary_op(__t, *__first);
      *__result = __t;
    }
  }
  return __result;
}

_LIBCPP_END_NAMESPACE_STD

_LIBCPP_POP_MACROS

#endif // _LIBCPP___CXX03___NUMERIC_PARTIAL_SUM_H
