; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+f,+d,+zvfh,+zfbfmin,+zvfbfmin -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,ZVFH,RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+f,+d,+zvfh,+zfbfmin,+zvfbfmin -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,ZVFH,RV64
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+f,+d,+zfhmin,+zvfhmin,+zfbfmin,+zvfbfmin -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,ZVFHMIN,RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+f,+d,+zfhmin,+zvfhmin,+zfbfmin,+zvfbfmin -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,ZVFHMIN,RV64

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define <2 x i8> @vslide1down_2xi8(<2 x i8> %v, i8 %b) {
; CHECK-LABEL: vslide1down_2xi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <2 x i8> poison, i8 %b, i64 0
  %v1 = shufflevector <2 x i8> %v, <2 x i8> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x i8> %v1
}

define <4 x i8> @vslide1down_4xi8(<4 x i8> %v, i8 %b) {
; CHECK-LABEL: vslide1down_4xi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x i8> poison, i8 %b, i64 0
  %v1 = shufflevector <4 x i8> %v, <4 x i8> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x i8> %v1
}

define <4 x i8> @vslide1down_4xi8_swapped(<4 x i8> %v, i8 %b) {
; CHECK-LABEL: vslide1down_4xi8_swapped:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x i8> poison, i8 %b, i64 0
  %v1 = shufflevector <4 x i8> %vb, <4 x i8> %v, <4 x i32> <i32 5, i32 6, i32 7, i32 0>
  ret <4 x i8> %v1
}

define <2 x i16> @vslide1down_2xi16(<2 x i16> %v, i16 %b) {
; CHECK-LABEL: vslide1down_2xi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <2 x i16> poison, i16 %b, i64 0
  %v1 = shufflevector <2 x i16> %v, <2 x i16> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x i16> %v1
}

define <4 x i16> @vslide1down_4xi16(<4 x i16> %v, i16 %b) {
; CHECK-LABEL: vslide1down_4xi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x i16> poison, i16 %b, i64 0
  %v1 = shufflevector <4 x i16> %v, <4 x i16> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x i16> %v1
}

define <2 x i32> @vslide1down_2xi32(<2 x i32> %v, i32 %b) {
; CHECK-LABEL: vslide1down_2xi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <2 x i32> poison, i32 %b, i64 0
  %v1 = shufflevector <2 x i32> %v, <2 x i32> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x i32> %v1
}

define <4 x i32> @vslide1down_4xi32(<4 x i32> %v, i32 %b) {
; CHECK-LABEL: vslide1down_4xi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x i32> poison, i32 %b, i64 0
  %v1 = shufflevector <4 x i32> %v, <4 x i32> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x i32> %v1
}

define <2 x i64> @vslide1down_2xi64(<2 x i64> %v, i64 %b) {
; RV32-LABEL: vslide1down_2xi64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV32-NEXT:    vlse64.v v9, (a0), zero
; RV32-NEXT:    vslidedown.vi v8, v8, 1
; RV32-NEXT:    vslideup.vi v8, v9, 1
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    .cfi_def_cfa_offset 0
; RV32-NEXT:    ret
;
; RV64-LABEL: vslide1down_2xi64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-NEXT:    vslide1down.vx v8, v8, a0
; RV64-NEXT:    ret
  %vb = insertelement <2 x i64> poison, i64 %b, i64 0
  %v1 = shufflevector <2 x i64> %v, <2 x i64> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x i64> %v1
}

define <4 x i64> @vslide1down_4xi64(<4 x i64> %v, i64 %b) {
; RV32-LABEL: vslide1down_4xi64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    .cfi_def_cfa_offset 16
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    sw a1, 12(sp)
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV32-NEXT:    vlse64.v v10, (a0), zero
; RV32-NEXT:    vslidedown.vi v8, v8, 1
; RV32-NEXT:    vslideup.vi v8, v10, 3
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    .cfi_def_cfa_offset 0
; RV32-NEXT:    ret
;
; RV64-LABEL: vslide1down_4xi64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-NEXT:    vslide1down.vx v8, v8, a0
; RV64-NEXT:    ret
  %vb = insertelement <4 x i64> poison, i64 %b, i64 0
  %v1 = shufflevector <4 x i64> %v, <4 x i64> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x i64> %v1
}

define <2 x bfloat> @vslide1down_2xbf16(<2 x bfloat> %v, bfloat %b) {
; CHECK-LABEL: vslide1down_2xbf16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmv.x.h a0, fa0
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <2 x bfloat> poison, bfloat %b, i64 0
  %v1 = shufflevector <2 x bfloat> %v, <2 x bfloat> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x bfloat> %v1
}

define <4 x bfloat> @vslide1down_4xbf16(<4 x bfloat> %v, bfloat %b) {
; CHECK-LABEL: vslide1down_4xbf16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmv.x.h a0, fa0
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x bfloat> poison, bfloat %b, i64 0
  %v1 = shufflevector <4 x bfloat> %v, <4 x bfloat> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x bfloat> %v1
}

define <2 x half> @vslide1down_2xf16(<2 x half> %v, half %b) {
; ZVFH-LABEL: vslide1down_2xf16:
; ZVFH:       # %bb.0:
; ZVFH-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; ZVFH-NEXT:    vfslide1down.vf v8, v8, fa0
; ZVFH-NEXT:    ret
;
; ZVFHMIN-LABEL: vslide1down_2xf16:
; ZVFHMIN:       # %bb.0:
; ZVFHMIN-NEXT:    fmv.x.h a0, fa0
; ZVFHMIN-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; ZVFHMIN-NEXT:    vslide1down.vx v8, v8, a0
; ZVFHMIN-NEXT:    ret
  %vb = insertelement <2 x half> poison, half %b, i64 0
  %v1 = shufflevector <2 x half> %v, <2 x half> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x half> %v1
}

define <4 x half> @vslide1down_4xf16(<4 x half> %v, half %b) {
; ZVFH-LABEL: vslide1down_4xf16:
; ZVFH:       # %bb.0:
; ZVFH-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; ZVFH-NEXT:    vfslide1down.vf v8, v8, fa0
; ZVFH-NEXT:    ret
;
; ZVFHMIN-LABEL: vslide1down_4xf16:
; ZVFHMIN:       # %bb.0:
; ZVFHMIN-NEXT:    fmv.x.h a0, fa0
; ZVFHMIN-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; ZVFHMIN-NEXT:    vslide1down.vx v8, v8, a0
; ZVFHMIN-NEXT:    ret
  %vb = insertelement <4 x half> poison, half %b, i64 0
  %v1 = shufflevector <4 x half> %v, <4 x half> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x half> %v1
}

define <2 x float> @vslide1down_2xf32(<2 x float> %v, float %b) {
; CHECK-LABEL: vslide1down_2xf32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vfslide1down.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %vb = insertelement <2 x float> poison, float %b, i64 0
  %v1 = shufflevector <2 x float> %v, <2 x float> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x float> %v1
}

define <4 x float> @vslide1down_4xf32(<4 x float> %v, float %b) {
; CHECK-LABEL: vslide1down_4xf32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vfslide1down.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x float> poison, float %b, i64 0
  %v1 = shufflevector <4 x float> %v, <4 x float> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x float> %v1
}

define <2 x double> @vslide1down_2xf64(<2 x double> %v, double %b) {
; CHECK-LABEL: vslide1down_2xf64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vfslide1down.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %vb = insertelement <2 x double> poison, double %b, i64 0
  %v1 = shufflevector <2 x double> %v, <2 x double> %vb, <2 x i32> <i32 1, i32 2>
  ret <2 x double> %v1
}

define <4 x double> @vslide1down_4xf64(<4 x double> %v, double %b) {
; CHECK-LABEL: vslide1down_4xf64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-NEXT:    vfslide1down.vf v8, v8, fa0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x double> poison, double %b, i64 0
  %v1 = shufflevector <4 x double> %v, <4 x double> %vb, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  ret <4 x double> %v1
}

define <4 x i8> @vslide1down_4xi8_with_splat(<4 x i8> %v, i8 %b) {
; CHECK-LABEL: vslide1down_4xi8_with_splat:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vslide1down.vx v8, v8, a0
; CHECK-NEXT:    ret
  %vb = insertelement <4 x i8> poison, i8 %b, i64 0
  %v1 = shufflevector <4 x i8> %vb, <4 x i8> poison, <4 x i32> zeroinitializer
  %v2 = shufflevector <4 x i8> %v1, <4 x i8> %v, <4 x i32> <i32 5, i32 6, i32 7, i32 1>
  ret <4 x i8> %v2
}

define <2 x double> @vslide1down_v2f64_inverted(<2 x double> %v, double %b) {
; CHECK-LABEL: vslide1down_v2f64_inverted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vrgather.vi v9, v8, 0
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %v1 = shufflevector <2 x double> %v, <2 x double> poison, <2 x i32> <i32 0, i32 0>
  %v2 = insertelement <2 x double> %v1, double %b, i64 1
  ret <2 x double> %v2
}

define <4 x i8> @vslide1down_4xi8_inverted(<4 x i8> %v, i8 %b) {
; CHECK-LABEL: vslide1down_4xi8_inverted:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, tu, ma
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v1 = shufflevector <4 x i8> %v, <4 x i8> poison, <4 x i32> <i32 undef, i32 0, i32 1, i32 2>
  %v2 = insertelement <4 x i8> %v1, i8 %b, i64 1
  ret <4 x i8> %v2
}
