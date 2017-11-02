//===-- LEG.td - Describe the LEG Target Machine -------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This is the top level entry point for the LEG target.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces which we are implementing
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Descriptions
//===----------------------------------------------------------------------===//

include "LEGSchedule.td"
include "LEGRegisterInfo.td"
include "LEGInstrInfo.td"
include "LEGCallingConv.td"

def LEGInstrInfo : InstrInfo;

//===----------------------------------------------------------------------===//
// LEG processors supported.
//===----------------------------------------------------------------------===//

class Proc<string Name, SchedMachineModel Model, list<SubtargetFeature> Features>
    : ProcessorModel<Name, Model, Features>;

foreach i = 1-2 in {
  def : Proc<"leg"#i, !cast<SchedMachineModel>("LEG"#i#"SchedModel"), []>;
}

//===----------------------------------------------------------------------===//
// Declare the target which we are implementing
//===----------------------------------------------------------------------===//
foreach i = 1-2 in {
  let Variant = !add(i,-1), AsmWriterClassName=i#"InstPrinter" in {
    def LEG#i#AsmWriter : AsmWriter;
  }
}

def LEG : Target {
  let InstructionSet = LEGInstrInfo;
  let AssemblyWriters = [LEG1AsmWriter, LEG2AsmWriter];
}
