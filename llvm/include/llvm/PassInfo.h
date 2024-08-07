//===- llvm/PassInfo.h - Pass Info class ------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines and implements the PassInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_PASSINFO_H
#define LLVM_PASSINFO_H

#include "llvm/ADT/StringRef.h"
#include <cassert>
#include <vector>

namespace llvm {

class Pass;

//===---------------------------------------------------------------------------
/// PassInfo class - An instance of this class exists for every pass known by
/// the system, and can be obtained from a live Pass by calling its
/// getPassInfo() method.  These objects are set up by the RegisterPass<>
/// template.
///
class PassInfo {
public:
  using NormalCtor_t = Pass* (*)();

private:
  StringRef PassName;     // Nice name for Pass
  StringRef PassArgument; // Command Line argument to run this pass
  const void *PassID;
  const bool IsCFGOnlyPass = false;      // Pass only looks at the CFG.
  const bool IsAnalysis;                 // True if an analysis pass.
  NormalCtor_t NormalCtor = nullptr;

public:
  /// PassInfo ctor - Do not call this directly, this should only be invoked
  /// through RegisterPass.
  PassInfo(StringRef name, StringRef arg, const void *pi, NormalCtor_t normal,
           bool isCFGOnly, bool is_analysis)
      : PassName(name), PassArgument(arg), PassID(pi), IsCFGOnlyPass(isCFGOnly),
        IsAnalysis(is_analysis), NormalCtor(normal) {}

  PassInfo(const PassInfo &) = delete;
  PassInfo &operator=(const PassInfo &) = delete;

  /// getPassName - Return the friendly name for the pass, never returns null
  StringRef getPassName() const { return PassName; }

  /// getPassArgument - Return the command line option that may be passed to
  /// 'opt' that will cause this pass to be run.  This will return null if there
  /// is no argument.
  StringRef getPassArgument() const { return PassArgument; }

  /// getTypeInfo - Return the id object for the pass...
  /// TODO : Rename
  const void *getTypeInfo() const { return PassID; }

  /// Return true if this PassID implements the specified ID pointer.
  bool isPassID(const void *IDPtr) const { return PassID == IDPtr; }

  bool isAnalysis() const { return IsAnalysis; }

  /// isCFGOnlyPass - return true if this pass only looks at the CFG for the
  /// function.
  bool isCFGOnlyPass() const { return IsCFGOnlyPass; }

  /// getNormalCtor - Return a pointer to a function, that when called, creates
  /// an instance of the pass and returns it.  This pointer may be null if there
  /// is no default constructor for the pass.
  NormalCtor_t getNormalCtor() const {
    return NormalCtor;
  }
  void setNormalCtor(NormalCtor_t Ctor) {
    NormalCtor = Ctor;
  }

  /// createPass() - Use this method to create an instance of this pass.
  Pass *createPass() const {
    assert(NormalCtor &&
           "Cannot call createPass on PassInfo without default ctor!");
    return NormalCtor();
  }
};

} // end namespace llvm

#endif // LLVM_PASSINFO_H
