//===-- SPIRVGroupOps.td - MLIR SPIR-V (Sub)Group Ops ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains group and subgroup ops for the SPIR-V dialect. It
// corresponds to "3.32.21. Group and Subgroup Instructions" of the SPIR-V
// specification.
//
//===----------------------------------------------------------------------===//

#ifndef SPIRV_GROUP_OPS
#define SPIRV_GROUP_OPS

// -----

def SPV_GroupBroadcastOp : SPV_Op<"GroupBroadcast",
  [NoSideEffect, AllTypesMatch<["value", "result"]>]> {
  let summary = [{
    Return the Value of the invocation identified by the local id LocalId to
    all invocations in the group.
  }];

  let description = [{
    All invocations of this module within Execution must reach this point of
    execution.

    Behavior is undefined if this instruction is used in control flow that
    is non-uniform within Execution.

    Result Type  must be a scalar or vector of floating-point type, integer
    type, or Boolean type.

    Execution must be Workgroup or Subgroup Scope.

     The type of Value must be the same as Result Type.

    LocalId must be an integer datatype. It can be a scalar, or a vector
    with 2 components or a vector with 3 components. LocalId must be the
    same for all invocations in the group.

    <!-- End of AutoGen section -->

    ```
    scope ::= `"Workgroup"` | `"Subgroup"`
    integer-float-scalar-vector-type ::= integer-type | float-type |
                               `vector<` integer-literal `x` integer-type `>` |
                               `vector<` integer-literal `x` float-type `>`
    localid-type ::= integer-type |
                   `vector<` integer-literal `x` integer-type `>`
    group-broadcast-op ::= ssa-id `=` `spv.GroupBroadcast` scope ssa_use,
                   ssa_use `:` integer-float-scalar-vector-type `,` localid-type
    ```mlir

    #### Example:

    ```
    %scalar_value = ... : f32
    %vector_value = ... : vector<4xf32>
    %scalar_localid = ... : i32
    %vector_localid = ... : vector<3xi32>
    %0 = spv.GroupBroadcast "Subgroup" %scalar_value, %scalar_localid : f32, i32
    %1 = spv.GroupBroadcast "Workgroup" %vector_value, %vector_localid :
      vector<4xf32>, vector<3xi32>
    ```
  }];

  let availability = [
    MinVersion<SPV_V_1_0>,
    MaxVersion<SPV_V_1_5>,
    Extension<[]>,
    Capability<[SPV_C_Groups]>
  ];

  let arguments = (ins
    SPV_ScopeAttr:$execution_scope,
    SPV_Type:$value,
    SPV_ScalarOrVectorOf<SPV_Integer>:$localid
  );

  let results = (outs
    SPV_Type:$result
  );

  let assemblyFormat = [{
    $execution_scope operands attr-dict `:` type($value) `,` type($localid)
  }];

}

// -----

def SPV_SubgroupBallotKHROp : SPV_Op<"SubgroupBallotKHR", []> {
  let summary = "See extension SPV_KHR_shader_ballot";

  let description = [{
    Computes a bitfield value combining the Predicate value from all invocations
    in the current Subgroup that execute the same dynamic instance of this
    instruction. The bit is set to one if the corresponding invocation is active
    and the predicate is evaluated to true; otherwise, it is set to zero.

    Predicate must be a Boolean type.

    Result Type must be a 4 component vector of 32 bit integer types.

    Result is a set of bitfields where the first invocation is represented in bit
    0 of the first vector component and the last (up to SubgroupSize) is the
    higher bit number of the last bitmask needed to represent all bits of the
    subgroup invocations.

    <!-- End of AutoGen section -->

    ```
    subgroup-ballot-op ::= ssa-id `=` `spv.SubgroupBallotKHR`
                                ssa-use `:` `vector` `<` 4 `x` `i32` `>`
    ```

    #### Example:

    ```mlir
    %0 = spv.SubgroupBallotKHR %predicate : vector<4xi32>
    ```
  }];

  let availability = [
    MinVersion<SPV_V_1_0>,
    MaxVersion<SPV_V_1_5>,
    Extension<[SPV_KHR_shader_ballot]>,
    Capability<[SPV_C_SubgroupBallotKHR]>
  ];

  let arguments = (ins
    SPV_Bool:$predicate
  );

  let results = (outs
    SPV_Int32Vec4:$result
  );

  let verifier = [{ return success(); }];

  let assemblyFormat = "$predicate attr-dict `:` type($result)";
}

// -----

#endif // SPIRV_GROUP_OPS
