//== LEGInstPrinter.h - Convert LEG MCInst to assembly syntax -*- C++ -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file contains the declaration of the LEGInstPrinter class,
/// which is used to print LEG MCInst to a .s file.
///
//===----------------------------------------------------------------------===//

#ifndef LEGINSTPRINTER_H
#define LEGINSTPRINTER_H
#include "llvm/MC/MCInstPrinter.h"

namespace llvm {

class TargetMachine;

class LEGInstPrinter : public MCInstPrinter {
public:
  LEGInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                 const MCRegisterInfo &MRI)
    : MCInstPrinter(MAI, MII, MRI)
  {}

  virtual void printInstruction(const MCInst *MI, raw_ostream &O) = 0;
  virtual const char *getRegisterName(unsigned RegNo) = 0;

  virtual void printRegName(raw_ostream &OS, unsigned RegNo) const override;
  virtual void printInst(const MCInst *MI, raw_ostream &OS, StringRef Annot,
                         const MCSubtargetInfo &STI) override;

protected:
  void printCondCode(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printAddrModeMemSrc(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  void printMemOperand(const MCInst *MI, int opNum, raw_ostream &O);
};

class LEG1InstPrinter : public LEGInstPrinter
{
public:
  using LEGInstPrinter::LEGInstPrinter;
  virtual void printInstruction(const MCInst *MI, raw_ostream &O) override;
  virtual const char *getRegisterName(unsigned RegNo) override;
};

class LEG2InstPrinter : public LEGInstPrinter
{
public:
  using LEGInstPrinter::LEGInstPrinter;
  virtual void printInstruction(const MCInst *MI, raw_ostream &O) override;
  virtual const char *getRegisterName(unsigned RegNo) override;
};
} // end namespace llvm

#endif
