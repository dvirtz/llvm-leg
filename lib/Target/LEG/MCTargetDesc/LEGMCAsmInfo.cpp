//===-- LEGMCAsmInfo.cpp - LEG asm properties -------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "LEGMCAsmInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/CommandLine.h"
using namespace llvm;

enum class LEGAsmTypeTy { LEG1, LEG2 };

static cl::opt<LEGAsmTypeTy> LEGAsmType(
    "leg-asm-type", cl::desc("Choose style of code to emit from LEG backend:"),
    cl::values(clEnumValN(LEGAsmTypeTy::LEG1, "leg1", "Emit LEG1 assembly"),
               clEnumValN(LEGAsmTypeTy::LEG2, "leg2", "Emit LEG2 assembly"),
               clEnumValEnd));

void LEGMCAsmInfo::anchor() {}

LEGMCAsmInfo::LEGMCAsmInfo(const Triple &TT) {
  SupportsDebugInformation = true;
  Data16bitsDirective = "\t.short\t";
  Data32bitsDirective = "\t.long\t";
  Data64bitsDirective = 0;
  ZeroDirective = "\t.space\t";
  CommentString = "#";

  AssemblerDialect = static_cast<unsigned>(LEGAsmType.getValue());

  AscizDirective = ".asciiz";

  HiddenVisibilityAttr = MCSA_Invalid;
  HiddenDeclarationVisibilityAttr = MCSA_Invalid;
  ProtectedVisibilityAttr = MCSA_Invalid;
}
