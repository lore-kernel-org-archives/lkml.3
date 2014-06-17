Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbaFQPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:16:17 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:51295 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933246AbaFQPQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:16:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.16-rc1
Date: Tue, 17 Jun 2014 17:16:03 +0200
Message-Id: <1403018163-25307-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.16-rc1[1] compared to v3.15-rc8[2].

Summarized:
  - build errors: +85/-6
  - build warnings: +381/-70

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.16-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7575/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7532/ (all 119 configs)


*** ERRORS ***

85 regressions:
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_ADD_K' undeclared (first use in this function):  => 930:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_ADD_X' undeclared (first use in this function):  => 935:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_AND_K' undeclared (first use in this function):  => 1030:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_AND_X' undeclared (first use in this function):  => 1035:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_DIV_K' undeclared (first use in this function):  => 963:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_DIV_X' undeclared (first use in this function):  => 987:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_LSH_K' undeclared (first use in this function):  => 1041:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_LSH_X' undeclared (first use in this function):  => 1046:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_MOD_K' undeclared (first use in this function):  => 976:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_MOD_X' undeclared (first use in this function):  => 997:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_MUL_K' undeclared (first use in this function):  => 950:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_MUL_X' undeclared (first use in this function):  => 957:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_NEG' undeclared (first use in this function):  => 1062:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_OR_K' undeclared (first use in this function):  => 1007:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_OR_X' undeclared (first use in this function):  => 1012:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_RSH_K' undeclared (first use in this function):  => 1052:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_RSH_X' undeclared (first use in this function):  => 1057:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_SUB_K' undeclared (first use in this function):  => 940:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_SUB_X' undeclared (first use in this function):  => 945:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_XOR_K' undeclared (first use in this function):  => 1018:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ALU_XOR_X' undeclared (first use in this function):  => 1024:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_ALU_XOR_X' undeclared (first use in this function):  => 1023:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_CPU' undeclared (first use in this function):  => 563:7, 1259:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_IFINDEX' undeclared (first use in this function):  => 564:7, 1268:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_MARK' undeclared (first use in this function):  => 565:7, 1282:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_PKTTYPE' undeclared (first use in this function):  => 1306:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_PROTOCOL' undeclared (first use in this function):  => 566:7, 1234:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_QUEUE' undeclared (first use in this function):  => 570:7, 1315:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_RXHASH' undeclared (first use in this function):  => 567:7, 1288:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_VLAN_TAG' undeclared (first use in this function):  => 568:7, 1294:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ANC_VLAN_TAG_PRESENT' undeclared (first use in this function):  => 1295:8, 569:7
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JA' undeclared (first use in this function):  => 1067:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JEQ_K' undeclared (first use in this function):  => 1072:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JEQ_X' undeclared (first use in this function):  => 1076:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JGE_K' undeclared (first use in this function):  => 1081:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JGE_X' undeclared (first use in this function):  => 1085:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JGT_K' undeclared (first use in this function):  => 1090:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JGT_X' undeclared (first use in this function):  => 1094:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JSET_K' undeclared (first use in this function):  => 1170:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_JMP_JSET_X' undeclared (first use in this function):  => 1184:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LDX_B_MSH' undeclared (first use in this function):  => 887:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LDX_IMM' undeclared (first use in this function):  => 871:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LDX_MEM' undeclared (first use in this function):  => 876:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LDX_W_LEN' undeclared (first use in this function):  => 881:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_B_ABS' undeclared (first use in this function):  => 820:8, 562:7
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_B_IND' undeclared (first use in this function):  => 863:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_H_ABS' undeclared (first use in this function):  => 561:7, 816:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_H_IND' undeclared (first use in this function):  => 859:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_IMM' undeclared (first use in this function):  => 795:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_MEM' undeclared (first use in this function):  => 807:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_W_ABS' undeclared (first use in this function):  => 560:7, 812:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_W_IND' undeclared (first use in this function):  => 855:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_LD_W_LEN' undeclared (first use in this function):  => 559:7, 800:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_MISC_TAX' undeclared (first use in this function):  => 1222:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_MISC_TXA' undeclared (first use in this function):  => 1227:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_RET_A' undeclared (first use in this function):  => 1197:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_RET_K' undeclared (first use in this function):  => 1207:8, 712:21
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_ST' undeclared (first use in this function):  => 920:8
  + /scratch/kisskb/src/arch/mips/net/bpf_jit.c: error: 'BPF_S_STX' undeclared (first use in this function):  => 925:8
  + /scratch/kisskb/src/arch/powerpc/kernel/cacheinfo.c: error: 'size_kb' may be used uninitialized in this function [-Werror=uninitialized]:  => 525:2
  + /scratch/kisskb/src/arch/sh/kernel/smp.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 368:5
  + /scratch/kisskb/src/arch/sh/kernel/smp.c: error: lvalue required as left operand of assignment:  => 405:24, 368:24, 448:32
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2
  + /scratch/kisskb/src/drivers/of/platform.c: error: 'struct pdev_archdata' has no member named 'dma_mask':  => 170:16
  + /scratch/kisskb/src/drivers/tty/serial/nwpserial.c: error: implicit declaration of function 'udelay' [-Werror=implicit-function-declaration]:  => 53:3
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add' [-Werror=implicit-function-declaration]:  => 176:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add_negative' [-Werror=implicit-function-declaration]:  => 211:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add_return' [-Werror=implicit-function-declaration]:  => 218:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec' [-Werror=implicit-function-declaration]:  => 169:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec_and_test' [-Werror=implicit-function-declaration]:  => 197:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec_return' [-Werror=implicit-function-declaration]:  => 239:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc' [-Werror=implicit-function-declaration]:  => 162:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc_and_test' [-Werror=implicit-function-declaration]:  => 204:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc_return' [-Werror=implicit-function-declaration]:  => 232:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_set' [-Werror=implicit-function-declaration]:  => 155:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub' [-Werror=implicit-function-declaration]:  => 183:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub_and_test' [-Werror=implicit-function-declaration]:  => 190:2
  + /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub_return' [-Werror=implicit-function-declaration]:  => 225:2
  + /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function '__atomic_add_unless' [-Werror=implicit-function-declaration]:  => 53:2
  + /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function 'atomic_cmpxchg' [-Werror=implicit-function-declaration]:  => 89:3
  + /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function 'atomic_read' [-Werror=implicit-function-declaration]:  => 136:2
  + /scratch/kisskb/src/sound/soc/fsl/fsl_dma.c: error: invalid use of undefined type 'struct ccsr_ssi':  => 926:34, 927:34
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: filter.c: undefined reference to `__fpscr_values':  => .text+0x3166c), .text+0x32000), .text+0x31860), .text+0x31d8c), .text+0x324b0)

6 improvements:
  - /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error: implicit declaration of function 'get_hard_smp_processor_id' [-Werror=implicit-function-declaration]: 179:4 => 
  - /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - <stdin>: error: -mcall-aixdesc must be big endian: 1:0 => 
  - error: "flush_cache_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!: N/A => 


*** WARNINGS ***

381 regressions:
  + /scratch/kisskb/src/arch/mips/include/asm/page.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]:  => 206:2
  + /scratch/kisskb/src/arch/powerpc/boot/addnote.c: warning: right shift count >= width of type [enabled by default]:  => 188:3, 211:3, 206:3, 183:3
  + /scratch/kisskb/src/arch/powerpc/include/asm/io.h: warning: 'hc_copy' may be used uninitialized in this function [-Wuninitialized]:  => 190:1
  + /scratch/kisskb/src/arch/powerpc/include/asm/io.h: warning: 'qwStartTSF.u.dwHighDword' may be used uninitialized in this function [-Wuninitialized]:  => 190:1
  + /scratch/kisskb/src/arch/powerpc/include/asm/io.h: warning: 'qwStartTSF.u.dwLowDword' may be used uninitialized in this function [-Wuninitialized]:  => 190:1
  + /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2160 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 566:1
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      kernel/user.o:  => 380
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4a/setup-sh7786.c: warning: 'tmu3_device' defined but not used [-Wunused-variable]:  => 251:31
  + /scratch/kisskb/src/arch/sparc/include/asm/atomic_32.h: warning: conflicting types for 'atomic_set' [enabled by default]:  => 27:13
  + /scratch/kisskb/src/arch/sparc/include/asm/processor.h: warning: "nop" redefined [enabled by default]:  => 9:0
  + /scratch/kisskb/src/arch/x86/include/asm/bitops.h: warning: 'bh' may be used uninitialized in this function [-Wuninitialized]:  => 311:8
  + /scratch/kisskb/src/arch/x86/include/asm/io.h: warning: 'hc_copy' may be used uninitialized in this function [-Wuninitialized]:  => 64:1
  + /scratch/kisskb/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]:  => 960:13
  + /scratch/kisskb/src/arch/x86/kernel/dumpstack_64.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 203:4
  + /scratch/kisskb/src/arch/x86/kernel/ksysfs.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]:  => 227:17
  + /scratch/kisskb/src/arch/x86/kernel/traps.c: warning: 'prev_state' may be used uninitialized in this function [-Wuninitialized]:  => 372:16, 510:16
  + /scratch/kisskb/src/arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 217:16
  + /scratch/kisskb/src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 83:2
  + /scratch/kisskb/src/block/bsg.c: warning: 'rw' may be used uninitialized in this function [-Wuninitialized]:  => 272:5
  + /scratch/kisskb/src/crypto/async_tx/async_tx.c: warning: 'chan' may be used uninitialized in this function [-Wuninitialized]:  => 258:18
  + /scratch/kisskb/src/drivers/ata/libata-core.c: warning: 'native_sectors' may be used uninitialized in this function [-Wuninitialized]:  => 1270:13
  + /scratch/kisskb/src/drivers/ata/libata-scsi.c: warning: 'dev' may be used uninitialized in this function [-Wuninitialized]:  => 3724:3
  + /scratch/kisskb/src/drivers/ata/libata-scsi.c: warning: 'last_failed_dev' may be used uninitialized in this function [-Wuninitialized]:  => 3724:3
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 595:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap-mmio.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 86:1
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2105:6
  + /scratch/kisskb/src/drivers/block/DAC960.c: warning: 'ControllerNumber' may be used uninitialized in this function [-Wuninitialized]:  => 6649:2
  + /scratch/kisskb/src/drivers/block/drbd/drbd_receiver.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]:  => 4248:21, 112:8
  + /scratch/kisskb/src/drivers/block/drbd/drbd_worker.c: warning: 'digest_size' may be used uninitialized in this function [-Wuninitialized]:  => 1134:16
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 562:18 => 587:3, 590:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]: 562:18 => 587:3, 590:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]: 559:17 => 587:3, 587:17
  + /scratch/kisskb/src/drivers/block/virtio_blk.c: warning: 'blk_size' may be used uninitialized in this function [-Wuninitialized]:  => 644:31
  + /scratch/kisskb/src/drivers/block/virtio_blk.c: warning: 'v' may be used uninitialized in this function [-Wuninitialized]:  => 635:29
  + /scratch/kisskb/src/drivers/block/virtio_blk.c: warning: 'writeback' may be used uninitialized in this function [-Wuninitialized]:  => 428:2
  + /scratch/kisskb/src/drivers/char/raw.c: warning: 'dev' may be used uninitialized in this function [-Wuninitialized]:  => 231:20
  + /scratch/kisskb/src/drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]:  => 204:3
  + /scratch/kisskb/src/drivers/firewire/core-device.c: warning: 'changed' may be used uninitialized in this function [-Wuninitialized]:  => 1151:2
  + /scratch/kisskb/src/drivers/gpio/gpio-bcm-kona.c: warning: 'res' may be used uninitialized in this function [-Wuninitialized]:  => 298:12
  + /scratch/kisskb/src/drivers/gpio/gpio-intel-mid.c: warning: 'intel_gpio_runtime_idle' defined but not used [-Wunused-function]:  => 391:12
  + /scratch/kisskb/src/drivers/gpio/gpio-mcp23s08.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 872:9
  + /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]:  => 194:13
  + /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]:  => 177:13
  + /scratch/kisskb/src/drivers/gpu/drm/ast/ast_mode.c: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]:  => 763:2
  + /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 471:4
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]:  => 2572:3
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 2997:30
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_gem_userptr.c: warning: 'mmu' may be used uninitialized in this function [-Wuninitialized]:  => 321:11
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/perfmon/base.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 140:11
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/i2c/nv94.c: warning: 'stat' may be used uninitialized in this function [-Wuninitialized]:  => 185:31
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/rv770_dpm.c: warning: 'postdiv_yclk' may be used uninitialized in this function [-Wuninitialized]:  => 431:23
  + /scratch/kisskb/src/drivers/gpu/vga/vgaarb.c: warning: 'devfn' may be used uninitialized in this function [-Wuninitialized]:  => 1082:9, 1085:5
  + /scratch/kisskb/src/drivers/hid/hid-picolcd_debugfs.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:10
  + /scratch/kisskb/src/drivers/hid/hid-rmi.c: warning: 'rmi_post_reset' defined but not used [-Wunused-function]:  => 431:12
  + /scratch/kisskb/src/drivers/hid/hid-rmi.c: warning: 'rmi_post_resume' defined but not used [-Wunused-function]:  => 436:12
  + /scratch/kisskb/src/drivers/hid/usbhid/hid-core.c: warning: 'field' may be used uninitialized in this function [-Wuninitialized]:  => 814:16
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]:  => 393:18
  + /scratch/kisskb/src/drivers/iio/imu/adis16480.c: warning: 'freq' may be used uninitialized in this function [-Wuninitialized]:  => 301:16
  + /scratch/kisskb/src/drivers/infiniband/core/cma.c: warning: 'sid_ps' may be used uninitialized in this function [-Wuninitialized]:  => 2465:18
  + /scratch/kisskb/src/drivers/infiniband/core/iwpm_util.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 581:2
  + /scratch/kisskb/src/drivers/infiniband/core/ucma.c: warning: 'qp_type' may be used uninitialized in this function [-Wuninitialized]:  => 394:29
  + /scratch/kisskb/src/drivers/infiniband/hw/amso1100/c2_alloc.c: warning: 'mqsp' may be used uninitialized in this function [-Wuninitialized]:  => 112:30
  + /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: 'hw_cqe' may be used uninitialized in this function [-Wuninitialized]: 303:21, 307:33 => 304:21, 475:2, 308:33, 387:23
  + /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: 'rd_cqe' may be used uninitialized in this function [-Wuninitialized]:  => 688:26
  + /scratch/kisskb/src/drivers/infiniband/hw/ipath/ipath_driver.c: warning: 'pnum' may be used uninitialized in this function [-Wuninitialized]:  => 1653:13
  + /scratch/kisskb/src/drivers/input/keyboard/st-keyscan.c: warning: 'keyscan_resume' defined but not used [-Wunused-function]:  => 235:12
  + /scratch/kisskb/src/drivers/input/keyboard/st-keyscan.c: warning: 'keyscan_suspend' defined but not used [-Wunused-function]:  => 218:12
  + /scratch/kisskb/src/drivers/leds/leds-max8997.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 92:7
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.11' uses dynamic stack allocation [enabled by default]:  => 572:1
  + /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.10' uses dynamic stack allocation [enabled by default]:  => 714:1
  + /scratch/kisskb/src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1351:3, 1056:3
  + /scratch/kisskb/src/drivers/media/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function [-Wuninitialized]:  => 608:26
  + /scratch/kisskb/src/drivers/media/v4l2-core/videobuf2-dma-contig.c: warning: 'pfn' may be used uninitialized in this function [-Wuninitialized]:  => 546:2
  + /scratch/kisskb/src/drivers/mfd/da903x.c: warning: 'chip_id' may be used uninitialized in this function [-Wuninitialized]:  => 262:2, 339:2
  + /scratch/kisskb/src/drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 230:11, 208:11, 186:11
  + /scratch/kisskb/src/drivers/mfd/stmpe-i2c.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 88:13
  + /scratch/kisskb/src/drivers/misc/bh1770glc.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 236:29
  + /scratch/kisskb/src/drivers/misc/mic/host/mic_fops.c: warning: 'pa' may be used uninitialized in this function [-Wuninitialized]:  => 210:24
  + /scratch/kisskb/src/drivers/misc/mic/host/mic_virtio.c: warning: 'devp' may be used uninitialized in this function [-Wuninitialized]:  => 492:8
  + /scratch/kisskb/src/drivers/misc/vmw_vmci/vmci_context.h: warning: 'src_priv_flags' may be used uninitialized in this function [-Wuninitialized]:  => 131:14
  + /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'arg' may be used uninitialized in this function [-Wuninitialized]:  => 1060:6
  + /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'from' may be used uninitialized in this function [-Wuninitialized]:  => 1060:6
  + /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'nr' may be used uninitialized in this function [-Wuninitialized]:  => 1060:6
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 417:1, 972:1
  + /scratch/kisskb/src/drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 265:8
  + /scratch/kisskb/src/drivers/mtd/inftlmount.c: warning: 'check_free_sectors.isra.0.constprop.1' uses dynamic stack allocation [enabled by default]:  => 361:1
  + /scratch/kisskb/src/drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 52:2
  + /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: warning: 'busw' may be used uninitialized in this function [-Wuninitialized]:  => 3689:3
  + /scratch/kisskb/src/drivers/mtd/nftlmount.c: warning: 'check_free_sectors.isra.0' uses dynamic stack allocation [enabled by default]:  => 294:1
  + /scratch/kisskb/src/drivers/mtd/sm_ftl.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 1091:2
  + /scratch/kisskb/src/drivers/mtd/spi-nor/spi-nor.c: warning: 'plat_id' may be used uninitialized in this function [-Wuninitialized]:  => 907:19
  + /scratch/kisskb/src/drivers/mtd/ubi/block.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 625:2
  + /scratch/kisskb/src/drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + /scratch/kisskb/src/drivers/net/bonding/bond_3ad.c: warning: 'new_aggregator' may be used uninitialized in this function [-Wuninitialized]:  => 1951:4
  + /scratch/kisskb/src/drivers/net/bonding/bond_netlink.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 212:3
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c: warning: 'reg_elem' may be used uninitialized in this function [-Wuninitialized]:  => 1641:19
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb/cxgb2.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 248:6
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/ael1002.c: warning: 'stat1' may be used uninitialized in this function [-Wuninitialized]:  => 850:30, 192:21
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/ael1002.c: warning: 'stat2' may be used uninitialized in this function [-Wuninitialized]:  => 192:38, 850:46
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1421:6, 1380:2
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/vsc8211.c: warning: 'adv' may be used uninitialized in this function [-Wuninitialized]:  => 186:4, 260:9
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb3/vsc8211.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 147:3, 223:3
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx4/mcg.c: warning: 'hash' may be used uninitialized in this function [-Wuninitialized]:  => 631:9
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c: warning: 'smac_index' may be used uninitialized in this function [-Wuninitialized]:  => 1781:18
  + /scratch/kisskb/src/drivers/net/ethernet/tile/tilegx.c: warning: unused variable 'i' [-Wunused-variable]:  => 2194:6
  + /scratch/kisskb/src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 78:7
  + /scratch/kisskb/src/drivers/net/tun.c: warning: 'copylen' may be used uninitialized in this function [-Wuninitialized]:  => 1084:21
  + /scratch/kisskb/src/drivers/net/tun.c: warning: 'linear' may be used uninitialized in this function [-Wuninitialized]:  => 995:2
  + /scratch/kisskb/src/drivers/net/virtio_net.c: warning: 'max_queue_pairs' may be used uninitialized in this function [-Wuninitialized]:  => 1640:8
  + /scratch/kisskb/src/drivers/net/virtio_net.c: warning: 'v' may be used uninitialized in this function [-Wuninitialized]:  => 1372:4
  + /scratch/kisskb/src/drivers/net/wireless/ath/ath6kl/cfg80211.c: warning: 'mcs' may be used uninitialized in this function [-Wuninitialized]:  => 1825:22
  + /scratch/kisskb/src/drivers/net/wireless/ath/ath6kl/cfg80211.c: warning: 'sgi' may be used uninitialized in this function [-Wuninitialized]:  => 1821:3
  + /scratch/kisskb/src/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: warning: 'str_mask' may be used uninitialized in this function [-Wuninitialized]:  => 3644:19
  + /scratch/kisskb/src/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: warning: 'str_shift' may be used uninitialized in this function [-Wuninitialized]:  => 3645:21
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'atqa' may be used uninitialized in this function [-Wuninitialized]:  => 488:21
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 490:10, 490:4
  + /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'sak' may be used uninitialized in this function [-Wuninitialized]:  => 489:20, 484:31
  + /scratch/kisskb/src/drivers/nfc/trf7970a.c: warning: 'trf7970a_init' defined but not used [-Wunused-function]:  => 754:12
  + /scratch/kisskb/src/drivers/of/platform.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 85:16
  + /scratch/kisskb/src/drivers/platform/x86/samsung-laptop.c: warning: 'loca' may be used uninitialized in this function [-Wuninitialized]:  => 1368:2
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'en_term' may be used uninitialized in this function [-Wuninitialized]:  => 624:7, 624:27
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'force_20pct' may be used uninitialized in this function [-Wuninitialized]:  => 617:7, 617:27
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:6
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:22
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:37
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:59
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 160:21, 184:21, 213:17, 115:16, 172:12, 200:21, 144:20
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 137:19
  + /scratch/kisskb/src/drivers/power/lp8788-charger.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 501:6
  + /scratch/kisskb/src/drivers/regulator/max8925-regulator.c: warning: 'regulator_idx' may be used uninitialized in this function [-Wuninitialized]:  => 309:2
  + /scratch/kisskb/src/drivers/regulator/s2mpa01.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 207:27
  + /scratch/kisskb/src/drivers/regulator/s2mps11.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 222:27
  + /scratch/kisskb/src/drivers/regulator/tps6586x-regulator.c: warning: 'num' may be used uninitialized in this function [-Wuninitialized]:  => 354:3
  + /scratch/kisskb/src/drivers/regulator/tps80031-regulator.c: warning: 'smps_mult' may be used uninitialized in this function [-Wuninitialized]:  => 653:33
  + /scratch/kisskb/src/drivers/regulator/tps80031-regulator.c: warning: 'smps_offset' may be used uninitialized in this function [-Wuninitialized]:  => 652:34
  + /scratch/kisskb/src/drivers/regulator/wm8350-regulator.c: warning: 'setting' may be used uninitialized in this function [-Wuninitialized]:  => 133:19
  + /scratch/kisskb/src/drivers/rtc/rtc-rx8025.c: warning: 'adj' may be used uninitialized in this function [-Wuninitialized]:  => 506:16
  + /scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'adv_scsiqp' may be used uninitialized in this function [-Wuninitialized]:  => 8826:2
  + /scratch/kisskb/src/drivers/scsi/advansys.c: warning: 'next_qp' may be used uninitialized in this function [-Wuninitialized]:  => 8544:3
  + /scratch/kisskb/src/drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used uninitialized in this function [-Wuninitialized]: 597:21 => 273:25, 597:21
  + /scratch/kisskb/src/drivers/scsi/fcoe/fcoe.c: warning: 'ctlr' may be used uninitialized in this function [-Wuninitialized]:  => 2047:7
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'asc' may be used uninitialized in this function [-Wuninitialized]:  => 1811:4
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'ascq' may be used uninitialized in this function [-Wuninitialized]:  => 1811:4
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]: 6628:5 => 6655:2, 6655:5
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'sense_key' may be used uninitialized in this function [-Wuninitialized]:  => 1788:4
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_attr.c: warning: 'creg_val' may be used uninitialized in this function [-Wuninitialized]:  => 1520:12
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_bsg.c: warning: 'creg_val' may be used uninitialized in this function [-Wuninitialized]:  => 1576:12, 504:12, 739:12
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]:  => 4931:11
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_els.c: warning: 'ha_copy' may be used uninitialized in this function [-Wuninitialized]:  => 96:2
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]:  => 4930:13
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_init.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 542:9
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_scsi.c: warning: 'ref_tag' may be used uninitialized in this function [-Wuninitialized]:  => 3151:3
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_scsi.c: warning: 'start_ref_tag' may be used uninitialized in this function [-Wuninitialized]:  => 3151:3
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'control' may be used uninitialized in this function [-Wuninitialized]:  => 10997:14, 10984:31
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'creg_val' may be used uninitialized in this function [-Wuninitialized]:  => 10470:12
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'eqidx' may be used uninitialized in this function [-Wuninitialized]:  => 6776:28
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'ha_copy' may be used uninitialized in this function [-Wuninitialized]:  => 10634:2, 3817:2, 7178:21, 3957:23, 10914:12, 11209:9
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'hc_copy' may be used uninitialized in this function [-Wuninitialized]:  => 10938:9, 11313:8
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'resp_data' may be used uninitialized in this function [-Wuninitialized]:  => 3834:3
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 3690:18, 4257:17, 3922:9
  + /scratch/kisskb/src/drivers/scsi/lpfc/lpfc_sli.c: warning: 'word0' may be used uninitialized in this function [-Wuninitialized]:  => 7177:30
  + /scratch/kisskb/src/drivers/scsi/mvsas/mv_sas.c: warning: 'tag' may be used uninitialized in this function [-Wuninitialized]:  => 1558:40, 1613:40
  + /scratch/kisskb/src/drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in this function [-Wuninitialized]:  => 4612:2
  + /scratch/kisskb/src/drivers/scsi/pm8001/pm8001_sas.c: warning: 'ccb_tag' may be used uninitialized in this function [-Wuninitialized]:  => 819:7, 814:9
  + /scratch/kisskb/src/drivers/scsi/pm8001/pm80xx_hwi.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 1113:3, 951:6
  + /scratch/kisskb/src/drivers/scsi/sg.c: warning: 'sdp' may be used uninitialized in this function [-Wuninitialized]:  => 841:3, 430:12
  + /scratch/kisskb/src/drivers/spi/spi-rspi.c: warning: unused variable 'ret' [-Wunused-variable]:  => 633:6
  + /scratch/kisskb/src/drivers/staging/android/binder.c: warning: 'cmd_name' may be used uninitialized in this function [-Wuninitialized]:  => 2278:5
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_660x_clock' may be used uninitialized in this function [-Wuninitialized]:  => 244:17
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_660x_gate_select' may be used uninitialized in this function [-Wuninitialized]:  => 249:22
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_m_series_clock' may be used uninitialized in this function [-Wuninitialized]:  => 244:17
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio.c: warning: 'ni_m_series_gate_select' may be used uninitialized in this function [-Wuninitialized]:  => 249:22
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_tio_internal.h: warning: 'ni_660x_second_gate_select' may be used uninitialized in this function [-Wuninitialized]:  => 164:29
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/pcl816.c: warning: 'last_chan' may be used uninitialized in this function [-Wuninitialized]:  => 228:6
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/pcl818.c: warning: 'last_chan' may be used uninitialized in this function [-Wuninitialized]: 412:6 => 412:6, 441:25
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 582:1
  + /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 582:1
  + /scratch/kisskb/src/drivers/staging/lustre/lnet/lnet/acceptor.c: warning: 'secure' may be used uninitialized in this function [-Wuninitialized]:  => 468:16
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/lov/lov_pack.c: warning: 'lmm_magic' may be used uninitialized in this function [-Wuninitialized]:  => 467:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/../include/lustre_log.h: warning: 'lop' may be used uninitialized in this function [-Wuninitialized]:  => 476:2, 494:2, 512:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/llog.c: warning: 'lop' may be used uninitialized in this function [-Wuninitialized]:  => 605:10, 684:10, 582:2, 652:10, 179:2, 627:10, 882:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/mea.c: warning: 'idx' may be used uninitialized in this function [-Wuninitialized]:  => 73:3
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/obd_config.c: warning: 'var' may be used uninitialized in this function [-Wuninitialized]:  => 1332:4
  + /scratch/kisskb/src/drivers/staging/ozwpan/ozhcd.c: warning: 'urbl' may be used uninitialized in this function [-Wuninitialized]:  => 619:19
  + /scratch/kisskb/src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: 'aid' may be used uninitialized in this function [-Wuninitialized]:  => 2240:19
  + /scratch/kisskb/src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: 'challenge' may be used uninitialized in this function [-Wuninitialized]:  => 2352:27
  + /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 2 has type 'sk_buff_data_t' [-Wformat]:  => 885:5
  + /scratch/kisskb/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 3 has type 'sk_buff_data_t' [-Wformat]:  => 885:5
  + /scratch/kisskb/src/drivers/staging/rts5208/sd.c: warning: 'rsp_len' may be used uninitialized in this function [-Wuninitialized]:  => 3956:9, 3557:7
  + /scratch/kisskb/src/drivers/staging/rts5208/sd.c: warning: 'rsp_type' may be used uninitialized in this function [-Wuninitialized]:  => 3956:9, 3956:25
  + /scratch/kisskb/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]:  => 411:3
  + /scratch/kisskb/src/drivers/staging/xillybus/xillybus_core.c: warning: 'idt_handle.entries' may be used uninitialized in this function [-Wuninitialized]:  => 2239:5
  + /scratch/kisskb/src/drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1718:18, 1721:18, 1716:2 => 1718:18, 1676:2, 1721:18, 1716:2, 1719:11
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 349:9
  + /scratch/kisskb/src/drivers/usb/core/hcd.c: warning: 'bufp' may be used uninitialized in this function [-Wuninitialized]:  => 686:10
  + /scratch/kisskb/src/drivers/usb/misc/usb3503.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 195:11
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[0]' may be used uninitialized in this function [-Wuninitialized]:  => 464:40
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[10]' may be used uninitialized in this function [-Wuninitialized]:  => 471:31
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[11]' may be used uninitialized in this function [-Wuninitialized]:  => 472:31
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[12]' may be used uninitialized in this function [-Wuninitialized]:  => 473:30
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[13]' may be used uninitialized in this function [-Wuninitialized]:  => 475:50
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[14]' may be used uninitialized in this function [-Wuninitialized]:  => 476:33
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[15]' may be used uninitialized in this function [-Wuninitialized]:  => 477:33
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[1]' may be used uninitialized in this function [-Wuninitialized]:  => 464:24
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[2]' may be used uninitialized in this function [-Wuninitialized]:  => 465:40
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[3]' may be used uninitialized in this function [-Wuninitialized]:  => 465:24
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[4]' may be used uninitialized in this function [-Wuninitialized]:  => 466:28
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[5]' may be used uninitialized in this function [-Wuninitialized]:  => 467:30
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[6]' may be used uninitialized in this function [-Wuninitialized]:  => 468:30
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[7]' may be used uninitialized in this function [-Wuninitialized]:  => 469:43
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[8]' may be used uninitialized in this function [-Wuninitialized]:  => 469:27
  + /scratch/kisskb/src/drivers/usb/storage/realtek_cr.c: warning: 'buf[9]' may be used uninitialized in this function [-Wuninitialized]:  => 470:30
  + /scratch/kisskb/src/drivers/usb/storage/sddr09.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 1113:2
  + /scratch/kisskb/src/drivers/usb/wusbcore/devconnect.c: warning: 'port' may be used uninitialized in this function [-Wuninitialized]:  => 329:17
  + /scratch/kisskb/src/drivers/uwb/i1480/dfu/phy.c: warning: 'phy_stat' may be used uninitialized in this function [-Wuninitialized]:  => 190:3
  + /scratch/kisskb/src/drivers/video/backlight/ams369fg06.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 340:2, 334:2, 363:2
  + /scratch/kisskb/src/drivers/video/backlight/ld9040.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 575:2
  + /scratch/kisskb/src/drivers/video/fbdev/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /scratch/kisskb/src/drivers/video/fbdev/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /scratch/kisskb/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + /scratch/kisskb/src/drivers/video/fbdev/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + /scratch/kisskb/src/drivers/video/fbdev/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4131:13
  + /scratch/kisskb/src/drivers/vme/bridges/vme_ca91cx42.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 471:14
  + /scratch/kisskb/src/drivers/w1/slaves/w1_therm.c: warning: 'verdict' may be used uninitialized in this function [-Wuninitialized]:  => 271:2
  + /scratch/kisskb/src/fs/btrfs/ctree.c: warning: 'pslot' may be used uninitialized in this function [-Wuninitialized]:  => 2185:24, 1981:24
  + /scratch/kisskb/src/fs/btrfs/extent_io.c: warning: 'tree' may be used uninitialized in this function [-Wuninitialized]:  => 2580:32
  + /scratch/kisskb/src/fs/btrfs/free-space-cache.c: warning: 'next_zero' may be used uninitialized in this function [-Wuninitialized]:  => 2468:5
  + /scratch/kisskb/src/fs/btrfs/free-space-cache.c: warning: 'start' may be used uninitialized in this function [-Wuninitialized]:  => 987:7
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1347:23
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1343:38
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1348:18
  + /scratch/kisskb/src/fs/btrfs/send.c: warning: 'found_key.offset' may be used uninitialized in this function [-Wuninitialized]:  => 1717:7
  + /scratch/kisskb/src/fs/btrfs/send.c: warning: 'found_key.type' may be used uninitialized in this function [-Wuninitialized]:  => 1694:2
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 150:25
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 149:21
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function [-Wuninitialized]:  => 920:9, 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'from' may be used uninitialized in this function:  => 913
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function [-Wuninitialized]:  => 1011:12
  + /scratch/kisskb/src/fs/direct-io.c: warning: 'to' may be used uninitialized in this function:  => 913
  + /scratch/kisskb/src/fs/ext4/extents.c: warning: 'abut_ex' may be used uninitialized in this function [-Wuninitialized]:  => 3516:21
  + /scratch/kisskb/src/fs/ext4/super.c: warning: 'first_not_zeroed' may be used uninitialized in this function [-Wuninitialized]:  => 4148:6
  + /scratch/kisskb/src/fs/f2fs/gc.c: warning: 'nofs' may be used uninitialized in this function [-Wuninitialized]:  => 614:16
  + /scratch/kisskb/src/fs/f2fs/node.c: warning: 'restore_node_summary' uses dynamic stack allocation [enabled by default]:  => 1743:1
  + /scratch/kisskb/src/fs/f2fs/super.c: warning: 'raw_super' may be used uninitialized in this function [-Wuninitialized]:  => 943:21
  + /scratch/kisskb/src/fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in this function [-Wuninitialized]:  => 645:12
  + /scratch/kisskb/src/fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]:  => 214:2
  + /scratch/kisskb/src/fs/freevxfs/vxfs_lookup.c: warning: 'pp' may be used uninitialized in this function [-Wuninitialized]:  => 185:3
  + /scratch/kisskb/src/fs/gfs2/incore.h: warning: 'rs' may be used uninitialized in this function [-Wuninitialized]:  => 119:6
  + /scratch/kisskb/src/fs/hpfs/alloc.c: warning: 'sec' may be used uninitialized in this function [-Wuninitialized]:  => 202:7
  + /scratch/kisskb/src/fs/hpfs/file.c: warning: 'n_secs' may be used uninitialized in this function [-Wuninitialized]:  => 84:3
  + /scratch/kisskb/src/fs/jffs2/scan.c: warning: 'sumlen' may be used uninitialized in this function [-Wuninitialized]:  => 536:4
  + /scratch/kisskb/src/fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]:  => 1854:41
  + /scratch/kisskb/src/fs/nfs/filelayout/filelayout.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 85:1
  + /scratch/kisskb/src/fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 664:17, 850:7, 909:21, 646:8
  + /scratch/kisskb/src/fs/nilfs2/super.c: warning: 'blocknr' may be used uninitialized in this function [-Wuninitialized]:  => 373:2
  + /scratch/kisskb/src/fs/ntfs/dir.c: warning: 'bmp_vi' may be used uninitialized in this function [-Wuninitialized]:  => 1430:7
  + /scratch/kisskb/src/fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this function [-Wuninitialized]:  => 115:24
  + /scratch/kisskb/src/fs/reiserfs/bitmap.c: warning: 'next' may be used uninitialized in this function [-Wuninitialized]:  => 269:9
  + /scratch/kisskb/src/fs/splice.c: warning: 'ret' may be used uninitialized in this function:  => 954
  + /scratch/kisskb/src/fs/xfs/./xfs_trace.h: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 6 has type 'xfs_fsblock_t' [-Wformat]:  => 712:1
  + /scratch/kisskb/src/fs/xfs/xfs_acl.c: warning: 'ea_name' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/watchdog/watchdog_core.o:  => 155:23
  + /scratch/kisskb/src/fs/xfs/xfs_alloc.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 2146:8
  + /scratch/kisskb/src/fs/xfs/xfs_bmap.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 5055:8, 1515:7, 1570:7
  + /scratch/kisskb/src/fs/xfs/xfs_log_recover.c: warning: 'uuid' may be used uninitialized in this function [-Wuninitialized]:  => 2059:3
  + /scratch/kisskb/src/fs/xfs/xfs_rtalloc.c: warning: 'nrblocks' may be used uninitialized in this function [-Wuninitialized]:  => 1045:4
  + /scratch/kisskb/src/include/linux/context_tracking.h: warning: 'prev_state' may be used uninitialized in this function [-Wuninitialized]:  => 46:3
  + /scratch/kisskb/src/include/linux/etherdevice.h: warning: '*((void *)&tmp_mac+2)' may be used uninitialized in this function [-Wuninitialized]:  => 237:7
  + /scratch/kisskb/src/include/linux/etherdevice.h: warning: '*((void *)&tmp_mac+4)' may be used uninitialized in this function [-Wuninitialized]:  => 238:7, 231:20
  + /scratch/kisskb/src/include/linux/etherdevice.h: warning: 'tmp_mac' may be used uninitialized in this function [-Wuninitialized]:  => 236:7, 230:14
  + /scratch/kisskb/src/include/linux/file.h: warning: '*((void *)&output+8)' may be used uninitialized in this function [-Wuninitialized]:  => 38:2
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 39:7
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.flags' may be used uninitialized in this function [-Wuninitialized]:  => 38:2
  + /scratch/kisskb/src/include/linux/hid.h: warning: 'report' may be used uninitialized in this function [-Wuninitialized]:  => 978:34
  + /scratch/kisskb/src/include/linux/list.h: warning: 'idev' may be used uninitialized in this function [-Wuninitialized]:  => 188:13
  + /scratch/kisskb/src/include/linux/list_nulls.h: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 35:2
  + /scratch/kisskb/src/include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]  LD      net/packet/built-in.o:  => 278:6
  + /scratch/kisskb/src/include/linux/netfilter.h: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 182:6
  + /scratch/kisskb/src/include/linux/pci.h: warning: 'ctrl_pos2' may be used uninitialized in this function [-Wuninitialized]:  => 880:2
  + /scratch/kisskb/src/include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 54:2
  + /scratch/kisskb/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]:  => 115:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/typecheck.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 11:18
  + /scratch/kisskb/src/ipc/mqueue.c: warning: 'msg_ptr' may be used uninitialized in this function [-Wuninitialized]:  => 1165:3
  + /scratch/kisskb/src/ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 2028:13
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 1609:13 => 1036:9, 1772:13
  + /scratch/kisskb/src/kernel/futex.c: warning: 'entry' may be used uninitialized in this function [-Wuninitialized]:  => 2920:3
  + /scratch/kisskb/src/kernel/futex.c: warning: 'pending' may be used uninitialized in this function [-Wuninitialized]:  => 2937:2
  + /scratch/kisskb/src/kernel/futex.c: warning: 'pip' may be used uninitialized in this function [-Wuninitialized]:  => 2938:21
  + /scratch/kisskb/src/kernel/kprobes.c: warning: 'probed_mod' may be used uninitialized in this function [-Wuninitialized]:  => 1530:2
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 739:2
  + /scratch/kisskb/src/kernel/trace/trace_irqsoff.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 152:12
  + /scratch/kisskb/src/kernel/trace/trace_irqsoff.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 150:16
  + /scratch/kisskb/src/kernel/trace/trace_sched_wakeup.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 130:12
  + /scratch/kisskb/src/kernel/trace/trace_sched_wakeup.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]:  => 127:16
  + /scratch/kisskb/src/kernel/user_namespace.c: warning: 'first' may be used uninitialized in this function [-Wuninitialized]:  => 188:6, 211:6, 165:6
  + /scratch/kisskb/src/lib/assoc_array.c: warning: 'j' may be used uninitialized in this function [-Wuninitialized]:  => 645:2
  + /scratch/kisskb/src/lib/cpumask.c: warning: the address of 'cpu_all_bits' will always evaluate as 'true' [-Waddress]:  => 194:6
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 73:2, 70:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 56:2, 49:4, 45:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 116:2, 113:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + /scratch/kisskb/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 668:14
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 1003:15
  + /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]:  => 2391:1
  + /scratch/kisskb/src/mm/slub.c: warning: 'get_partial_node.isra.35' uses dynamic stack allocation [enabled by default]:  => 1656:1
  + /scratch/kisskb/src/mm/slub.c: warning: 'unfreeze_partials.isra.33' uses dynamic stack allocation [enabled by default]:  => 2016:1
  + /scratch/kisskb/src/net/bluetooth/6lowpan.c: warning: 'iphc0' may be used uninitialized in this function [-Wuninitialized]:  => 217:2
  + /scratch/kisskb/src/net/bluetooth/6lowpan.c: warning: 'iphc1' may be used uninitialized in this function [-Wuninitialized]:  => 217:2
  + /scratch/kisskb/src/net/bluetooth/l2cap_sock.c: warning: 'nsk' may be used uninitialized in this function [-Wuninitialized]:  => 347:2
  + /scratch/kisskb/src/net/bluetooth/sco.c: warning: 'ch' may be used uninitialized in this function [-Wuninitialized]:  => 607:2
  + /scratch/kisskb/src/net/bridge/netfilter/nft_meta_bridge.c: warning: 'p' may be used uninitialized in this function [-Wuninitialized]:  => 43:31
  + /scratch/kisskb/src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1344:6
  + /scratch/kisskb/src/net/ieee802154/6lowpan_iphc.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]:  => 396:19
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function [-Wuninitialized]:  => 183:16
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + /scratch/kisskb/src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 927:3
  + /scratch/kisskb/src/net/ipv4/udp.c: warning: 'sk' may be used uninitialized in this function [-Wuninitialized]:  => 1936:8
  + /scratch/kisskb/src/net/ipv6/mcast.c: warning: 'max_delay' may be used uninitialized in this function [-Wuninitialized]:  => 1381:24
  + /scratch/kisskb/src/net/mac802154/llsec.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 654:1
  + /scratch/kisskb/src/net/netlink/genetlink.c: warning: 'first_id' may be used uninitialized in this function [-Wuninitialized]:  => 256:23
  + /scratch/kisskb/src/net/nfc/llcp_core.c: warning: 'sn_len' may be used uninitialized in this function [-Wuninitialized]:  => 804:12
  + /scratch/kisskb/src/net/openvswitch/datapath.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 499:2
  + /scratch/kisskb/src/net/rds/rdma.c: warning: 'iov_size' may be used uninitialized in this function [-Wuninitialized]:  => 697:15
  + /scratch/kisskb/src/net/sched/sch_choke.c: warning: 'idx' may be used uninitialized in this function [-Wuninitialized]:  => 127:2
  + /scratch/kisskb/src/net/sched/sch_qfq.c: warning: 'cl' may be used uninitialized in this function [-Wuninitialized]:  => 998:22
  + /scratch/kisskb/src/net/sched/sch_sfb.c: warning: 'salt' may be used uninitialized in this function [-Wuninitialized]:  => 313:12
  + /scratch/kisskb/src/net/wireless/radiotap.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]:  => 294:10
  + /scratch/kisskb/src/net/wireless/rdev-ops.h: warning: 'rdev' may be used uninitialized in this function [-Wuninitialized]:  => 472:29
  + /scratch/kisskb/src/security/integrity/iint.c: warning: 'iint' may be used uninitialized in this function [-Wuninitialized]:  => 35:31
  + /scratch/kisskb/src/security/selinux/ss/avtab.c: warning: 'buf16[0u]' may be used uninitialized in this function [-Wuninitialized]:  => 423:2
  + /scratch/kisskb/src/security/selinux/ss/avtab.c: warning: 'buf16[1u]' may be used uninitialized in this function [-Wuninitialized]:  => 419:18
  + /scratch/kisskb/src/security/selinux/ss/avtab.c: warning: 'buf16[2u]' may be used uninitialized in this function [-Wuninitialized]:  => 420:19
  + /scratch/kisskb/src/security/selinux/ss/avtab.c: warning: 'buf16[3u]' may be used uninitialized in this function [-Wuninitialized]:  => 421:16
  + /scratch/kisskb/src/security/selinux/ss/avtab.c: warning: 'buf[0]' may be used uninitialized in this function [-Wuninitialized]:  => 483:2
  + /scratch/kisskb/src/security/selinux/ss/conditional.c: warning: 'buf' may be used uninitialized in this function [-Wuninitialized]:  => 409:18
  + /scratch/kisskb/src/security/selinux/ss/conditional.c: warning: 'buf[0]' may be used uninitialized in this function [-Wuninitialized]:  => 474:2, 236:19, 351:12
  + /scratch/kisskb/src/security/selinux/ss/conditional.c: warning: 'buf[1]' may be used uninitialized in this function [-Wuninitialized]:  => 391:2, 215:2
  + /scratch/kisskb/src/security/selinux/ss/conditional.c: warning: 'buf[2]' may be used uninitialized in this function [-Wuninitialized]:  => 249:17
  + /scratch/kisskb/src/security/selinux/ss/ebitmap.c: warning: 'buf[0]' may be used uninitialized in this function [-Wuninitialized]:  => 409:10
  + /scratch/kisskb/src/security/selinux/ss/ebitmap.c: warning: 'buf[1]' may be used uninitialized in this function [-Wuninitialized]:  => 392:13
  + /scratch/kisskb/src/security/selinux/ss/ebitmap.c: warning: 'buf[2]' may be used uninitialized in this function [-Wuninitialized]:  => 366:5
  + /scratch/kisskb/src/security/selinux/ss/ebitmap.c: warning: 'startbit' may be used uninitialized in this function [-Wuninitialized]:  => 451:21
  + /scratch/kisskb/src/security/selinux/ss/policydb.c: warning: 'buf' may be used uninitialized in this function [-Wuninitialized]:  => 2284:5
  + /scratch/kisskb/src/security/selinux/ss/policydb.c: warning: 'buf[0]' may be used uninitialized in this function [-Wuninitialized]:  => 1055:10, 1154:17, 1671:17, 1533:11, 1108:17, 1193:11, 1623:17, 2022:12
  + /scratch/kisskb/src/security/selinux/ss/policydb.c: warning: 'buf[1]' may be used uninitialized in this function [-Wuninitialized]:  => 1888:19, 1101:18, 1056:10, 1141:18, 1664:18, 1617:20, 1989:13
  + /scratch/kisskb/src/security/selinux/ss/policydb.c: warning: 'buf[2]' may be used uninitialized in this function [-Wuninitialized]:  => 1665:20, 1146:30, 1990:14, 1057:10
  + /scratch/kisskb/src/security/selinux/ss/policydb.c: warning: 'buf[3]' may be used uninitialized in this function [-Wuninitialized]:  => 1992:16, 1123:12
  + /scratch/kisskb/src/sound/core/oss/pcm_oss.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 2595:3
  + /scratch/kisskb/src/sound/drivers/mpu401/mpu401_uart.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 290:6, 312:6
  + /scratch/kisskb/src/sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function [-Wuninitialized]:  => 963:27
  + /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_resume' defined but not used [-Wunused-function]:  => 2432:12
  + /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_suspend' defined but not used [-Wunused-function]:  => 2449:12
  + /scratch/kisskb/src/sound/soc/codecs/wm8804.c: warning: 'pll_div.freqmode' may be used uninitialized in this function [-Wuninitialized]:  => 409:26
  + /scratch/kisskb/src/sound/soc/codecs/wm8804.c: warning: 'pll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 412:48
  + /scratch/kisskb/src/sound/soc/codecs/wm8804.c: warning: 'pll_div.mclkdiv' may be used uninitialized in this function [-Wuninitialized]:  => 409:45
  + /scratch/kisskb/src/sound/soc/codecs/wm8804.c: warning: 'pll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 406:19
  + /scratch/kisskb/src/sound/soc/codecs/wm8804.c: warning: 'pll_div.prescale' may be used uninitialized in this function [-Wuninitialized]:  => 406:39
  + /scratch/kisskb/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 337:7
  + /scratch/kisskb/src/sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3122:6
  + warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (VIDEO_PVRUSB2 && VIDEO_TLG2300 && VIDEO_USBVISION && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164 && VIDEO_GO7007) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER):  => N/A
  + warning: drivers/built-in.o(.text+0x2ccff4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x518e0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x427ac): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: size of symbol `sys_geteuid16' changed from 8 in kernel/sys_ni.o to 76 in kernel/uid16.o:  => N/A
  + warning: vmlinux.o(.data+0x41910): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x419b0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41b14): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41c24): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41c84): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41ce4): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41d4c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41f1c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

70 improvements:
  - /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]: 39:0 => 
  - /scratch/kisskb/src/arch/powerpc/kvm/book3s_64_mmu.c: warning: 'slb' may be used uninitialized in this function [-Wuninitialized]: 604:6 => 
  - /scratch/kisskb/src/arch/s390/kvm/priv.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 54:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 243:17 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]: 405:4 => 
  - /scratch/kisskb/src/drivers/input/keyboard/stmpe-keypad.c: warning: 'stmpe_keypad_irq' uses dynamic stack allocation [enabled by default]: 166:1 => 
  - /scratch/kisskb/src/drivers/input/misc/max8997_haptic.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]: 185:19 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.8' uses dynamic stack allocation [enabled by default]: 572:1 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.7' uses dynamic stack allocation [enabled by default]: 714:1 => 
  - /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_irq' uses dynamic stack allocation [enabled by default]: 890:1 => 
  - /scratch/kisskb/src/drivers/mfd/stmpe.c: warning: 'stmpe_set_altfunc' uses dynamic stack allocation [enabled by default]: 286:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]  CC [M]  drivers/media/i2c/cx25840/cx25840-ir.o: 972:1 => 
  - /scratch/kisskb/src/drivers/mtd/inftlmount.c: warning: 'check_free_sectors.constprop.0' uses dynamic stack allocation [enabled by default]: 361:1 => 
  - /scratch/kisskb/src/drivers/mtd/mtdchar.c: warning: passing argument 2 of 'access_ok' makes pointer from integer without a cast [enabled by default]: 576:4, 575:4 => 
  - /scratch/kisskb/src/drivers/mtd/nftlmount.c: warning: 'check_free_sectors' uses dynamic stack allocation [enabled by default]: 294:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c: warning: passing argument 1 of 'bnx2x_vf_pci_dealloc' from incompatible pointer type [enabled by default]: 13241:4 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: 'return' with a value, in function returning void [enabled by default]: 574:59 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: 'struct bnx2' declared inside parameter list [enabled by default]: 574:48 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]: 574:48 => 
  - /scratch/kisskb/src/drivers/net/ethernet/intel/i40e/i40e.h: warning: "prefetch" redefined [enabled by default]: 101:0 => 
  - /scratch/kisskb/src/drivers/net/wan/farsync.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1408:10 => 
  - /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]: 1006:2 => 
  - /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]: 1006:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 1563:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1653:1 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/rts51x.c: warning: 'rts51x_try_to_enter_ss' defined but not used [-Wunused-function]: 203:13 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'invalid_cmd_field' defined but not used [-Wunused-variable]: 651:11 => 
  - /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'media_not_present' defined but not used [-Wunused-variable]: 649:11 => 
  - /scratch/kisskb/src/drivers/staging/silicom/bpctl_mod.c: warning: 'bp_proc_create' defined but not used [-Wunused-function]: 6786:12 => 
  - /scratch/kisskb/src/drivers/staging/vt6655/iwctl.c: warning: the frame size of 1280 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 759:1 => 
  - /scratch/kisskb/src/drivers/staging/vt6655/iwctl.c: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 759:1 => 
  - /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_resume' defined but not used [-Wunused-function]: 214:12 => 
  - /scratch/kisskb/src/drivers/usb/host/xhci-plat.c: warning: 'xhci_plat_suspend' defined but not used [-Wunused-function]: 206:12 => 
  - /scratch/kisskb/src/drivers/video/fbdev/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function [-Wuninitialized]: 1147:13 => 
  - /scratch/kisskb/src/drivers/video/fbdev/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function [-Wuninitialized]: 1146:35 => 
  - /scratch/kisskb/src/fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 4121:6 => 
  - /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'seq' may be used uninitialized in this function [-Wuninitialized]: 1418:6 => 
  - /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1268:20, 1455:6 => 
  - /scratch/kisskb/src/fs/hfsplus/xattr.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 86:2 => 
  - /scratch/kisskb/src/fs/nfs/nfs4filelayout.c: warning: control reaches end of non-void function [-Wreturn-type]: 85:1 => 
  - /scratch/kisskb/src/kernel/power/hibernate.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 237:2 => 
  - /scratch/kisskb/src/lib/btree.c: warning: 'btree_get_prev' uses dynamic stack allocation [enabled by default]  CC [M]  drivers/input/joystick/spaceorb.o: 359:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]: 2384:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'get_partial_node.isra.34' uses dynamic stack allocation [enabled by default]: 1650:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'unfreeze_partials.isra.32' uses dynamic stack allocation [enabled by default]: 2010:1 => 
  - /scratch/kisskb/src/net/dccp/timer.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 285:2 => 
  - /scratch/kisskb/src/net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1774:1 => 
  - /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_resume' defined but not used [-Wunused-function]: 545:12 => 
  - /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_suspend' defined but not used [-Wunused-function]: 520:12 => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (INTEL_MIC_HOST && CAIF_VIRTIO && VHOST_NET && VHOST_SCSI && VHOST_NET && VHOST_SCSI) selects VHOST_RING which has unmet direct dependencies (NETDEVICES && CAIF_VIRTIO || VIRTUALIZATION): N/A => 
  - warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (!CPU_LITTLE_ENDIAN): N/A => 
  - warning: drivers/built-in.o(.text+0x2c020c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x51300): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x3fdd8): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/ethernet/3com/3c59x.o(.data+0x44): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe(): N/A => 
  - warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0x38): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41530): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x415d0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41734): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41844): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x418a4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41904): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4196c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41b3c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
