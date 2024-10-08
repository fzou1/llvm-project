//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
// UNSUPPORTED: c++03, c++11, c++14, c++17

// <chrono>
// class year_month_day_last;

// constexpr year_month_day_last& operator+=(const years& d) noexcept;
// constexpr year_month_day_last& operator-=(const years& d) noexcept;

#include <chrono>
#include <cassert>
#include <type_traits>
#include <utility>

#include "test_macros.h"

using year                = std::chrono::year;
using month               = std::chrono::month;
using month_day_last      = std::chrono::month_day_last;
using year_month_day_last = std::chrono::year_month_day_last;
using years               = std::chrono::years;

constexpr bool test() {
  for (int i = 1000; i <= 1010; ++i) {
    month_day_last mdl{month{2}};
    year_month_day_last ymdl(year{i}, mdl);
    assert(static_cast<int>((ymdl += years{2}).year()) == i + 2);
    assert(ymdl.month_day_last() == mdl);
    assert(static_cast<int>((ymdl).year()) == i + 2);
    assert(ymdl.month_day_last() == mdl);
    assert(static_cast<int>((ymdl -= years{1}).year()) == i + 1);
    assert(ymdl.month_day_last() == mdl);
    assert(static_cast<int>((ymdl).year()) == i + 1);
    assert(ymdl.month_day_last() == mdl);
  }

  return true;
}

int main(int, char**) {
  ASSERT_NOEXCEPT(std::declval<year_month_day_last&>() += std::declval<years>());
  ASSERT_NOEXCEPT(std::declval<year_month_day_last&>() -= std::declval<years>());

  ASSERT_SAME_TYPE(year_month_day_last&, decltype(std::declval<year_month_day_last&>() += std::declval<years>()));
  ASSERT_SAME_TYPE(year_month_day_last&, decltype(std::declval<year_month_day_last&>() -= std::declval<years>()));

  test();
  static_assert(test());

  return 0;
}
