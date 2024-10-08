//===-- lib/Semantics/check-call.h ------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Constraint checking for procedure references

#ifndef FORTRAN_SEMANTICS_CHECK_CALL_H_
#define FORTRAN_SEMANTICS_CHECK_CALL_H_

#include "flang/Evaluate/call.h"

namespace Fortran::parser {
class Messages;
class ContextualMessages;
} // namespace Fortran::parser
namespace Fortran::evaluate::characteristics {
struct Procedure;
}
namespace Fortran::evaluate {
class FoldingContext;
}

namespace Fortran::semantics {
class Scope;
class SemanticsContext;

// Argument treatingExternalAsImplicit should be true when the called procedure
// does not actually have an explicit interface at the call site, but
// its characteristics are known because it is a subroutine or function
// defined at the top level in the same source file.  Returns false if
// messages were created, true if all is well.
bool CheckArguments(const evaluate::characteristics::Procedure &,
    evaluate::ActualArguments &, SemanticsContext &, const Scope &,
    bool treatingExternalAsImplicit, bool ignoreImplicitVsExplicit,
    const evaluate::SpecificIntrinsic *intrinsic);

bool CheckPPCIntrinsic(const Symbol &generic, const Symbol &specific,
    const evaluate::ActualArguments &actuals,
    evaluate::FoldingContext &context);
bool CheckWindowsIntrinsic(
    const Symbol &intrinsic, evaluate::FoldingContext &context);
bool CheckArgumentIsConstantExprInRange(
    const evaluate::ActualArguments &actuals, int index, int lowerBound,
    int upperBound, parser::ContextualMessages &messages);

// Checks actual arguments for the purpose of resolving a generic interface.
bool CheckInterfaceForGeneric(const evaluate::characteristics::Procedure &,
    evaluate::ActualArguments &, SemanticsContext &,
    bool allowActualArgumentConversions = false);
} // namespace Fortran::semantics
#endif
