//= AArch64WinCOFFObjectWriter.cpp - AArch64 Windows COFF Object Writer C++ =//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===---------------------------------------------------------------------===//

#include "AArch64MCTargetDesc.h"
#include "MCTargetDesc/AArch64FixupKinds.h"
#include "MCTargetDesc/AArch64MCAsmInfo.h"
#include "llvm/ADT/Twine.h"
#include "llvm/BinaryFormat/COFF.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCValue.h"
#include "llvm/MC/MCWinCOFFObjectWriter.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/ErrorHandling.h"
#include <cassert>

using namespace llvm;

namespace {

class AArch64WinCOFFObjectWriter : public MCWinCOFFObjectTargetWriter {
public:
  AArch64WinCOFFObjectWriter(const Triple &TheTriple)
      : MCWinCOFFObjectTargetWriter(TheTriple.isWindowsArm64EC()
                                        ? COFF::IMAGE_FILE_MACHINE_ARM64EC
                                        : COFF::IMAGE_FILE_MACHINE_ARM64) {}

  ~AArch64WinCOFFObjectWriter() override = default;

  unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsCrossSection,
                        const MCAsmBackend &MAB) const override;

  bool recordRelocation(const MCFixup &) const override;
};

} // end anonymous namespace

unsigned AArch64WinCOFFObjectWriter::getRelocType(
    MCContext &Ctx, const MCValue &Target, const MCFixup &Fixup,
    bool IsCrossSection, const MCAsmBackend &MAB) const {
  unsigned FixupKind = Fixup.getKind();
  bool PCRel = Fixup.isPCRel();
  if (IsCrossSection) {
    // IMAGE_REL_ARM64_REL64 does not exist. We treat FK_Data_8 as FK_PCRel_4 so
    // that .xword a-b can lower to IMAGE_REL_ARM64_REL32. This allows generic
    // instrumentation to not bother with the COFF limitation. A negative value
    // needs attention.
    if (PCRel || (FixupKind != FK_Data_4 && FixupKind != FK_Data_8)) {
      Ctx.reportError(Fixup.getLoc(), "Cannot represent this expression");
      return COFF::IMAGE_REL_ARM64_ADDR32;
    }
    FixupKind = FK_Data_4;
    PCRel = true;
  }

  auto Spec = Target.getSpecifier();
  const MCExpr *Expr = Fixup.getValue();

  if (auto *A64E = dyn_cast<MCSpecifierExpr>(Expr)) {
    AArch64::Specifier Spec = A64E->getSpecifier();
    switch (AArch64::getSymbolLoc(Spec)) {
    case AArch64::S_ABS:
    case AArch64::S_SECREL:
      // Supported
      break;
    default:
      Ctx.reportError(Fixup.getLoc(), "relocation specifier " +
                                          AArch64::getSpecifierName(*A64E) +
                                          " unsupported on COFF targets");
      return COFF::IMAGE_REL_ARM64_ABSOLUTE; // Dummy return value
    }
  }

  switch (FixupKind) {
  default: {
    if (auto *A64E = dyn_cast<MCSpecifierExpr>(Expr)) {
      Ctx.reportError(Fixup.getLoc(), "relocation specifier " +
                                          AArch64::getSpecifierName(*A64E) +
                                          " unsupported on COFF targets");
    } else {
      MCFixupKindInfo Info = MAB.getFixupKindInfo(Fixup.getKind());
      Ctx.reportError(Fixup.getLoc(), Twine("relocation type ") + Info.Name +
                                          " unsupported on COFF targets");
    }
    return COFF::IMAGE_REL_ARM64_ABSOLUTE; // Dummy return value
  }

  case FK_Data_4:
    if (PCRel)
      return COFF::IMAGE_REL_ARM64_REL32;
    switch (Spec) {
    default:
      return COFF::IMAGE_REL_ARM64_ADDR32;
    case MCSymbolRefExpr::VK_COFF_IMGREL32:
      return COFF::IMAGE_REL_ARM64_ADDR32NB;
    }

  case FK_Data_8:
    return COFF::IMAGE_REL_ARM64_ADDR64;

  case FK_SecRel_2:
    return COFF::IMAGE_REL_ARM64_SECTION;

  case FK_SecRel_4:
    return COFF::IMAGE_REL_ARM64_SECREL;

  case AArch64::fixup_aarch64_add_imm12:
    if (auto *A64E = dyn_cast<MCSpecifierExpr>(Expr)) {
      AArch64::Specifier Spec = A64E->getSpecifier();
      if (Spec == AArch64::S_SECREL_LO12)
        return COFF::IMAGE_REL_ARM64_SECREL_LOW12A;
      if (Spec == AArch64::S_SECREL_HI12)
        return COFF::IMAGE_REL_ARM64_SECREL_HIGH12A;
    }
    return COFF::IMAGE_REL_ARM64_PAGEOFFSET_12A;

  case AArch64::fixup_aarch64_ldst_imm12_scale1:
  case AArch64::fixup_aarch64_ldst_imm12_scale2:
  case AArch64::fixup_aarch64_ldst_imm12_scale4:
  case AArch64::fixup_aarch64_ldst_imm12_scale8:
  case AArch64::fixup_aarch64_ldst_imm12_scale16:
    if (auto *A64E = dyn_cast<MCSpecifierExpr>(Expr)) {
      AArch64::Specifier Spec = A64E->getSpecifier();
      if (Spec == AArch64::S_SECREL_LO12)
        return COFF::IMAGE_REL_ARM64_SECREL_LOW12L;
    }
    return COFF::IMAGE_REL_ARM64_PAGEOFFSET_12L;

  case AArch64::fixup_aarch64_pcrel_adr_imm21:
    return COFF::IMAGE_REL_ARM64_REL21;

  case AArch64::fixup_aarch64_pcrel_adrp_imm21:
    return COFF::IMAGE_REL_ARM64_PAGEBASE_REL21;

  case AArch64::fixup_aarch64_pcrel_branch14:
    return COFF::IMAGE_REL_ARM64_BRANCH14;

  case AArch64::fixup_aarch64_pcrel_branch19:
    return COFF::IMAGE_REL_ARM64_BRANCH19;

  case AArch64::fixup_aarch64_pcrel_branch26:
  case AArch64::fixup_aarch64_pcrel_call26:
    return COFF::IMAGE_REL_ARM64_BRANCH26;
  }
}

bool AArch64WinCOFFObjectWriter::recordRelocation(const MCFixup &Fixup) const {
  return true;
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createAArch64WinCOFFObjectWriter(const Triple &TheTriple) {
  return std::make_unique<AArch64WinCOFFObjectWriter>(TheTriple);
}
