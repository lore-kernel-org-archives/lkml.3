Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaIVJND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:13:03 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:47063 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbaIVJMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:12:55 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.17-rc6
Date: Mon, 22 Sep 2014 11:12:52 +0200
Message-Id: <1411377172-16037-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.17-rc6[1] compared to v3.16[2].

Summarized:
  - build errors: +0/-46
  - build warnings: +45/-523

JFYI, when comparing v3.17-rc6[1]  to v3.17-rc5[3], the summaries are:
  - build errors: +0/-34
  - build warnings: +5/-478

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.17-rc6.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7891/ (45 out of 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7732/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7872/ (all 119 configs)


*** ERRORS ***

46 improvements:
  - /scratch/kisskb/src/arch/um/drivers/cow_user.c: error: implicit declaration of function 'be32toh': 303 => 
  - /scratch/kisskb/src/arch/um/drivers/cow_user.c: error: implicit declaration of function 'be64toh': 330 => 
  - /scratch/kisskb/src/arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe32': 216 => 
  - /scratch/kisskb/src/arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe64': 249 => 
  - /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: 'TMPFS_MAGIC' undeclared (first use in this function): 31 => 
  - /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: (Each undeclared identifier is reported only once: 31 => 
  - /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: for each function it appears in.): 31 => 
  - /scratch/kisskb/src/arch/um/os-Linux/mem.c: error: linux/magic.h: No such file or directory: 16:25 => 
  - /scratch/kisskb/src/arch/um/os-Linux/skas/process.c: error: 'PTRACE_GETSIGINFO' undeclared (first use in this function): 412 => 
  - /scratch/kisskb/src/arch/um/os-Linux/skas/process.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 321, 560 => 
  - /scratch/kisskb/src/arch/um/os-Linux/skas/process.c: error: (Each undeclared identifier is reported only once: 321 => 
  - /scratch/kisskb/src/arch/um/os-Linux/skas/process.c: error: for each function it appears in.): 321 => 
  - /scratch/kisskb/src/arch/um/os-Linux/start_up.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 304, 246 => 
  - /scratch/kisskb/src/arch/um/os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function): 245, 303 => 
  - /scratch/kisskb/src/arch/um/os-Linux/start_up.c: error: (Each undeclared identifier is reported only once: 245 => 
  - /scratch/kisskb/src/arch/um/os-Linux/start_up.c: error: for each function it appears in.): 245 => 
  - /scratch/kisskb/src/drivers/net/wireless/libertas/if_cs.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]: 878:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/libertas/if_cs.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]: 826:3 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/orinoco_cs.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]: 153:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/orinoco_cs.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]: 205:3 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/spectrum_cs.c: error: implicit declaration of function 'ioport_map' [-Werror=implicit-function-declaration]: 216:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/spectrum_cs.c: error: implicit declaration of function 'ioport_unmap' [-Werror=implicit-function-declaration]: 273:3 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add' [-Werror=implicit-function-declaration]: 176:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add_negative' [-Werror=implicit-function-declaration]: 211:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_add_return' [-Werror=implicit-function-declaration]: 218:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec' [-Werror=implicit-function-declaration]: 169:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec_and_test' [-Werror=implicit-function-declaration]: 197:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_dec_return' [-Werror=implicit-function-declaration]: 239:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc' [-Werror=implicit-function-declaration]: 162:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc_and_test' [-Werror=implicit-function-declaration]: 204:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_inc_return' [-Werror=implicit-function-declaration]: 232:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_set' [-Werror=implicit-function-declaration]: 155:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub' [-Werror=implicit-function-declaration]: 183:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub_and_test' [-Werror=implicit-function-declaration]: 190:2 => 
  - /scratch/kisskb/src/include/asm-generic/atomic-long.h: error: implicit declaration of function 'atomic_sub_return' [-Werror=implicit-function-declaration]: 225:2 => 
  - /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function '__atomic_add_unless' [-Werror=implicit-function-declaration]: 53:2 => 
  - /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function 'atomic_cmpxchg' [-Werror=implicit-function-declaration]: 89:3 => 
  - /scratch/kisskb/src/include/linux/atomic.h: error: implicit declaration of function 'atomic_read' [-Werror=implicit-function-declaration]: 136:2 => 
  - error: stmmac_hwtstamp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9580), (.text+0x1ff9944) => 
  - error: stmmac_hwtstamp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa0bc), (.text+0x1ff9d4c), (.text+0x1ff994c) => 
  - error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_lock_irqsave' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ffa520), (.text+0x1ffa5d8) => 
  - error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa59c) => 
  - error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa4ec), (.text+0x1ffa5a4) => 
  - error: tpm_ibmvtpm.c: undefined reference to `.__vio_register_driver': .init.text+0x6950) => 
  - error: tpm_ibmvtpm.c: undefined reference to `.plpar_hcall_norets': .text+0xeda70), .text+0xedae4), .text+0xedde0), .text+0xedb9c), .text+0xedc1c) => 
  - error: tpm_ibmvtpm.c: undefined reference to `.vio_unregister_driver': .exit.text+0x1920) => 


*** WARNINGS ***

45 regressions:
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/device/ctrl.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 62:3
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 146:2
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 146:2
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c: warning: right shift count >= width of type [enabled by default]:  => 146:2
  + /scratch/kisskb/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_resume' defined but not used [-Wunused-function]:  => 127:12
  + /scratch/kisskb/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_suspend' defined but not used [-Wunused-function]:  => 118:12
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'num_sec_devs' may be used uninitialized in this function [-Wuninitialized]:  => 393:6
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'sec_devs' may be used uninitialized in this function [-Wuninitialized]:  => 393:6
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: the frame size of 1300 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1662:1
  + /scratch/kisskb/src/drivers/net/ethernet/i825xx/sun3_82586.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 993:89
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/debugfs.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 89:4
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/debugfs.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 89:4
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/debugfs.c: warning: right shift count >= width of type [enabled by default]:  => 89:4
  + /scratch/kisskb/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function [-Wuninitialized]:  => 676:18
  + /scratch/kisskb/src/drivers/staging/android/sync_debug.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 100:3
  + /scratch/kisskb/src/drivers/usb/gadget/function/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]:  => 2356:47
  + /scratch/kisskb/src/drivers/usb/gadget/function/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]:  => 1249:15, 1160:12, 1197:13, 1155:5, 1249:31
  + /scratch/kisskb/src/fs/cifs/netmisc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 941:22, 937:23
  + /scratch/kisskb/src/fs/nfsd/nfs4state.c: warning: 'old_deny_bmap' may be used uninitialized in this function [-Wuninitialized]:  => 3732:24
  + /scratch/kisskb/src/include/linux/cgroup.h: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 158:11
  + /scratch/kisskb/src/include/linux/dmaengine.h: warning: 'rxdesc' may be used uninitialized in this function [-Wuninitialized]:  => 796:2
  + /scratch/kisskb/src/include/linux/dmaengine.h: warning: 'txdesc' may be used uninitialized in this function [-Wuninitialized]:  => 796:2
  + /scratch/kisskb/src/include/linux/pwm.h: warning: 'period' may be used uninitialized in this function [-Wuninitialized]:  => 98:15
  + /scratch/kisskb/src/kernel/acct.c: warning: unused variable 'ns' [-Wunused-variable]:  => 475:24
  + /scratch/kisskb/src/kernel/sched/core.c: warning: statement with no effect [-Wunused-value]:  => 2342:2
  + /scratch/kisskb/src/kernel/sched/core.c: warning: value computed is not used [-Wunused-value]:  => 2225:2
  + /scratch/kisskb/src/mm/memcontrol.c: warning: 'usage' may be used uninitialized in this function [-Wuninitialized]:  => 4850:6, 4762:6
  + /scratch/kisskb/src/mm/memcontrol.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 4164:1
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'aif_rx_state' may be used uninitialized in this function [-Wuninitialized]:  => 1372:21
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'aif_tx_state' may be used uninitialized in this function [-Wuninitialized]:  => 1369:27
  + /scratch/kisskb/src/sound/soc/codecs/rt286.c: warning: 'rt286_index_sync' defined but not used [-Wunused-function]:  => 273:13
  + /scratch/kisskb/src/sound/soc/codecs/tas2552.c: warning: 'tas2552_sw_shutdown' defined but not used [-Wunused-function]:  => 81:13
  + /scratch/kisskb/src/sound/soc/s6000/s6000-i2s.c: warning: unused variable 'mmio' [-Wunused-variable]:  => 577:16
  + <stdin>: warning: #warning syscall getrandom not implemented [-Wcpp]:  => 1241:2
  + <stdin>: warning: #warning syscall memfd_create not implemented [-Wcpp]:  => 1244:2
  + <stdin>: warning: #warning syscall seccomp not implemented [-Wcpp]:  => 1238:2
  + warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => N/A
  + warning: vmlinux.o(.data+0x40d50): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40df0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40f54): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41064): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x410c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41124): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4118c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x4135c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

523 improvements:
  - .config: warning: override: reassigning to symbol ENABLE_MUST_CHECK: 7808 => 
  - .config: warning: override: reassigning to symbol PROFILE_ALL_BRANCHES: 7806 => 
  - /scratch/kisskb/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]: 63:2 => 
  - /scratch/kisskb/src/arch/blackfin/include/asm/bfin_serial.h: warning: "get_lsr_cache" redefined [enabled by default]: 383:0 => 
  - /scratch/kisskb/src/arch/blackfin/include/asm/bfin_serial.h: warning: "port_membase" redefined [enabled by default]: 270:0 => 
  - /scratch/kisskb/src/arch/blackfin/include/asm/bfin_serial.h: warning: "put_lsr_cache" redefined [enabled by default]: 384:0 => 
  - /scratch/kisskb/src/arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'uint64_t' [-Wformat]: 350:11, 286:10, 368:10 => 
  - /scratch/kisskb/src/arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'uint64_t' [-Wformat]: 350:11, 368:10 => 
  - /scratch/kisskb/src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'memcpy' discards 'volatile' qualifier from pointer target type [enabled by default]: 1344:6, 1354:6 => 
  - /scratch/kisskb/src/arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1 of 'virt_to_phys' discards 'const' qualifier from pointer target type [enabled by default]: 1225:2 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/drivers/axisflashmap.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 520:2, 394:3 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/drivers/axisflashmap.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 583:8 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'uint64_t' [-Wformat]: 333:10 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 122:2 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/kernel/fasttimer.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 353:2 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/mach-fs/pinmux.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 97:2, 225:2 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/mm/intmem.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 123:14, 116:14 => 
  - /scratch/kisskb/src/arch/cris/arch-v32/mm/intmem.c: warning: initialization from incompatible pointer type [enabled by default]: 149:1 => 
  - /scratch/kisskb/src/arch/cris/mm/fault.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 230:3 => 
  - /scratch/kisskb/src/arch/frv/mb93090-mb00/pci-frv.c: warning: ignoring return value of 'pci_assign_resource', declared with attribute warn_unused_result [-Wunused-result]: 184:24, 176:24 => 
  - /scratch/kisskb/src/arch/ia64/kernel/unaligned.c: warning: 'u.l' may be used uninitialized in this function [-Wuninitialized]: 1382:16 => 
  - /scratch/kisskb/src/arch/ia64/sn/kernel/bte.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 117:22, 125:22 => 
  - /scratch/kisskb/src/arch/ia64/sn/kernel/sn2/sn2_smp.c: warning: the frame size of 2176 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 319:1 => 
  - /scratch/kisskb/src/arch/m32r/boot/compressed/m32r_sio.c: warning: conflicting types for built-in function 'putc' [enabled by default]: 11:13 => 
  - /scratch/kisskb/src/arch/m32r/platforms/m32700ut/setup.c: warning: 'm32700ut_lcdpld_irq_type' defined but not used [-Wunused-variable]: 249:24 => 
  - /scratch/kisskb/src/arch/mips/include/asm/compat.h: warning: 'cp' may be used uninitialized in this function [-Wuninitialized]: 208:24 => 
  - /scratch/kisskb/src/arch/mn10300/mm/dma-alloc.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]: 29:2 => 
  - /scratch/kisskb/src/arch/powerpc/boot/addnote.c: warning: right shift count >= width of type [enabled by default]: 183:3, 211:3, 206:3, 188:3 => 
  - /scratch/kisskb/src/arch/powerpc/boot/mpc8xx.c: warning: variable 'div' set but not used [-Wunused-but-set-variable]: 27:26 => 
  - /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2176 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 570:1 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      kernel/user.o: 380 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      security/keys/permission.o: 383 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4a/setup-sh7786.c: warning: 'tmu3_device' defined but not used [-Wunused-variable]: 251:31 => 
  - /scratch/kisskb/src/arch/sparc/include/asm/atomic_32.h: warning: conflicting types for 'atomic_set' [enabled by default]: 27:6 => 
  - /scratch/kisskb/src/arch/sparc/include/asm/cacheflush_32.h: warning: 'struct page' declared inside parameter list [enabled by default]: 39:37 => 
  - /scratch/kisskb/src/arch/sparc/include/asm/cacheflush_32.h: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]: 39:37 => 
  - /scratch/kisskb/src/arch/sparc/include/asm/processor.h: warning: "nop" redefined [enabled by default]: 9:0 => 
  - /scratch/kisskb/src/arch/tile/lib/cacheflush.c: warning: ignoring #pragma unroll  [-Wunknown-pragmas]: 146:0 => 
  - /scratch/kisskb/src/arch/um/kernel/ptrace.c: warning: ignoring return value of 'tracehook_report_syscall_entry', declared with attribute warn_unused_result: 178 => 
  - /scratch/kisskb/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]: 960:13 => 
  - /scratch/kisskb/src/arch/x86/kernel/cpu/mcheck/mce-inject.c: warning: 'mce_irq_ipi' defined but not used [-Wunused-function]: 97:13 => 
  - /scratch/kisskb/src/crypto/algif_hash.c: warning: 'hash_accept' uses dynamic stack allocation [enabled by default]: 217:1 => 
  - /scratch/kisskb/src/crypto/async_tx/async_pq.c: warning: 'async_gen_syndrome' uses dynamic stack allocation [enabled by default]: 254:1 => 
  - /scratch/kisskb/src/crypto/async_tx/async_pq.c: warning: 'async_syndrome_val' uses dynamic stack allocation [enabled by default]: 417:1 => 
  - /scratch/kisskb/src/crypto/async_tx/raid6test.c: warning: 'raid6_dual_recov.constprop.3' uses dynamic stack allocation [enabled by default]: 128:1 => 
  - /scratch/kisskb/src/crypto/cbc.c: warning: 'crypto_cbc_decrypt_inplace.isra.3' uses dynamic stack allocation [enabled by default]: 167:1 => 
  - /scratch/kisskb/src/crypto/cipher.c: warning: 'cipher_crypt_unaligned' uses dynamic stack allocation [enabled by default]: 76:1 => 
  - /scratch/kisskb/src/crypto/ctr.c: warning: 'crypto_ctr_crypt_final' uses dynamic stack allocation [enabled by default]: 72:1 => 
  - /scratch/kisskb/src/crypto/ctr.c: warning: 'crypto_ctr_crypt_inplace' uses dynamic stack allocation [enabled by default]: 125:1 => 
  - /scratch/kisskb/src/crypto/cts.c: warning: 'cts_cbc_decrypt' uses dynamic stack allocation [enabled by default]: 217:1 => 
  - /scratch/kisskb/src/crypto/cts.c: warning: 'cts_cbc_encrypt' uses dynamic stack allocation [enabled by default]: 123:1 => 
  - /scratch/kisskb/src/crypto/hmac.c: warning: 'hmac_setkey' uses dynamic stack allocation [enabled by default]: 90:1 => 
  - /scratch/kisskb/src/crypto/pcbc.c: warning: 'crypto_pcbc_decrypt_inplace.isra.2' uses dynamic stack allocation [enabled by default]: 175:1 => 
  - /scratch/kisskb/src/crypto/pcbc.c: warning: 'crypto_pcbc_encrypt_inplace.isra.3' uses dynamic stack allocation [enabled by default]: 95:1 => 
  - /scratch/kisskb/src/crypto/shash.c: warning: 'shash_final_unaligned' uses dynamic stack allocation [enabled by default]: 132:1 => 
  - /scratch/kisskb/src/crypto/shash.c: warning: 'shash_update_unaligned' uses dynamic stack allocation [enabled by default]: 96:1 => 
  - /scratch/kisskb/src/crypto/xcbc.c: warning: 'crypto_xcbc_digest_setkey' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - /scratch/kisskb/src/drivers/block/hd.c: warning: statement with no effect [-Wunused-value]: 467:2 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]: 590:18 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]: 590:18 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]: 587:17 => 
  - /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat]: 2175:2 => 
  - /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]: 1607:3, 926:3 => 
  - /scratch/kisskb/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]: 2240:3 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: 'arch_random_refill' uses dynamic stack allocation [enabled by default]: 1341:1 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 1420:11 => 
  - /scratch/kisskb/src/drivers/dma/dmatest.c: warning: 'dmatest_func' uses dynamic stack allocation [enabled by default]: 716:1 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]: 194:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]: 177:13 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-sch311x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 286:18 => 
  - /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_resume' defined but not used [-Wunused-function]: 117:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_suspend' defined but not used [-Wunused-function]: 100:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_resume' defined but not used [-Wunused-function]: 96:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_suspend' defined but not used [-Wunused-function]: 79:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]: 804:1 => 
  - /scratch/kisskb/src/drivers/gpu/drm/drm_lock.c: warning: passing argument 1 of '__cmpxchg' discards 'volatile' qualifier from pointer target type [enabled by default]: 354:5, 236:3, 269:3, 307:3, 193:3 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i2c/tda998x_drv.c: warning: 'reg_write_range' uses dynamic stack allocation [enabled by default]: 442:1 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_gem_userptr.c: warning: 'mmu' may be used uninitialized in this function [-Wuninitialized]: 321:11 => 
  - /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 77:6 => 
  - /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]: 117:5 => 
  - /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]: 118:15 => 
  - /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]: 118:3 => 
  - /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]: 3558:47 => 
  - /scratch/kisskb/src/drivers/hwmon/dme1737.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]: 2766:6 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]: 551:3, 542:3 => 
  - /scratch/kisskb/src/drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]: 296:2 => 
  - /scratch/kisskb/src/drivers/ide/ide-io-std.c: warning: statement with no effect [-Wunused-value]: 186:4, 201:3 => 
  - /scratch/kisskb/src/drivers/iio/adc/exynos_adc.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 112:9 => 
  - /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: 'hw_cqe' may be used uninitialized in this function [-Wuninitialized]: 308:33, 304:21 => 308:33
  - /scratch/kisskb/src/drivers/infiniband/hw/ehca/ehca_mrmw.c: warning: 'hret' may be used uninitialized in this function [-Wuninitialized]: 2430:5, 2433:3 => 
  - /scratch/kisskb/src/drivers/infiniband/hw/ehca/ehca_mrmw.c: warning: 'prev_pgaddr' may be used uninitialized in this function [-Wuninitialized]: 1907:6 => 
  - /scratch/kisskb/src/drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' uses dynamic stack allocation [enabled by default]: 307:1 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/cyttsp4_core.c: warning: 'cyttsp4_get_mt_touches' uses dynamic stack allocation [enabled by default]: 936:1 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/mcs5000_ts.c: warning: 'mcs5000_ts_resume' defined but not used [-Wunused-function]: 262:12 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/mcs5000_ts.c: warning: 'mcs5000_ts_suspend' defined but not used [-Wunused-function]: 252:12 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/avm_a1p.c: warning: statement with no effect [-Wunused-value]: 84:2, 120:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/avm_pci.c: warning: statement with no effect [-Wunused-value]: 101:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/diva.c: warning: statement with no effect [-Wunused-value]: 95:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/elsa.c: warning: statement with no effect [-Wunused-value]: 155:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/gazel.c: warning: statement with no effect [-Wunused-value]: 91:2, 60:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/niccy.c: warning: statement with no effect [-Wunused-value]: 59:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/sedlbauer.c: warning: statement with no effect [-Wunused-value]: 133:2 => 
  - /scratch/kisskb/src/drivers/isdn/hisax/teles3.c: warning: statement with no effect [-Wunused-value]: 44:2 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.11' uses dynamic stack allocation [enabled by default]: 572:1 => 
  - /scratch/kisskb/src/drivers/md/dm-crypt.c: warning: 'crypt_iv_tcw_whitening.isra.10' uses dynamic stack allocation [enabled by default]: 714:1 => 
  - /scratch/kisskb/src/drivers/md/dm-raid1.c: warning: 'do_write' uses dynamic stack allocation [enabled by default]: 655:1 => 
  - /scratch/kisskb/src/drivers/md/dm-raid1.c: warning: 'mirror_flush' uses dynamic stack allocation [enabled by default]: 284:1 => 
  - /scratch/kisskb/src/drivers/md/dm-raid1.c: warning: 'mirror_status' uses dynamic stack allocation [enabled by default]: 1391:1 => 
  - /scratch/kisskb/src/drivers/md/dm-stripe.c: warning: 'stripe_status' uses dynamic stack allocation [enabled by default]: 348:1 => 
  - /scratch/kisskb/src/drivers/md/raid10.c: warning: 'handle_reshape_read_error' uses dynamic stack allocation [enabled by default]: 4635:1 => 
  - /scratch/kisskb/src/drivers/md/raid10.c: warning: 'raid10_mergeable_bvec' uses dynamic stack allocation [enabled by default]: 762:1 => 
  - /scratch/kisskb/src/drivers/media/media-entity.c: warning: 'media_entity_pipeline_start' uses dynamic stack allocation [enabled by default]: 322:1 => 
  - /scratch/kisskb/src/drivers/message/i2o/i2o_config.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 893:19, 953:10 => 
  - /scratch/kisskb/src/drivers/mfd/88pm860x-i2c.c: warning: 'write_device' uses dynamic stack allocation [enabled by default]: 140:1 => 
  - /scratch/kisskb/src/drivers/mfd/arizona-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 505:10 => 
  - /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_bulk_write' uses dynamic stack allocation [enabled by default]: 108:1 => 
  - /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_reg_write' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - /scratch/kisskb/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_set_bits' uses dynamic stack allocation [enabled by default]: 128:1 => 
  - /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 350:5 => 
  - /scratch/kisskb/src/drivers/mfd/stmpe-i2c.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 88:13 => 
  - /scratch/kisskb/src/drivers/mfd/tps65910.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 404:14 => 
  - /scratch/kisskb/src/drivers/misc/tifm_7xx1.c: warning: 'tifm_7xx1_resume' uses dynamic stack allocation [enabled by default]: 297:1 => 
  - /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'arg' may be used uninitialized in this function: 1032 => 
  - /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'from' may be used uninitialized in this function: 1032 => 
  - /scratch/kisskb/src/drivers/mmc/card/block.c: warning: 'nr' may be used uninitialized in this function: 1032 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1738:9 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1440 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1835:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1484 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1835:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_is_locked' defined but not used: 2383 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_lock' defined but not used: 2278 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_unlock' defined but not used: 2285 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1505:9, 1444:7, 740:2, 1879:7 => 1777:7, 2216:7, 774:2
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1224 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 417:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1, 417:1 => 417:1
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1472 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 972:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1728 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 651:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1764 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 651:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2256 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 651:1 => 
  - /scratch/kisskb/src/drivers/mtd/chips/jedec_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1907:2, 1894:24 => 
  - /scratch/kisskb/src/drivers/mtd/inftlmount.c: warning: 'check_free_sectors.isra.0.constprop.1' uses dynamic stack allocation [enabled by default]: 361:1 => 
  - /scratch/kisskb/src/drivers/mtd/nand/denali.c: warning: 'find_valid_banks' uses dynamic stack allocation [enabled by default]: 436:1 => 
  - /scratch/kisskb/src/drivers/mtd/nand/nandsim.c: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'long unsigned int' [-Wformat]: 774:2 => 
  - /scratch/kisskb/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 164:17, 181:17 => 
  - /scratch/kisskb/src/drivers/mtd/nftlmount.c: warning: 'check_free_sectors.isra.0' uses dynamic stack allocation [enabled by default]: 294:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/dec/tulip/tulip_core.c: warning: #warning Processor architecture undefined! [-Wcpp]: 101:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/dec/tulip/winbond-840.c: warning: #warning Processor architecture undefined [-Wcpp]: 910:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/ibm/ehea/ehea_main.c: warning: 'ehea_module_device_table' defined but not used [-Wunused-variable]: 106:28 => 
  - /scratch/kisskb/src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'igb_resume' defined but not used [-Wunused-function]: 7483:12 => 
  - /scratch/kisskb/src/drivers/net/ethernet/intel/igb/igb_main.c: warning: 'wake' may be used uninitialized in this function [-Wuninitialized]: 7579:19 => 
  - /scratch/kisskb/src/drivers/net/ethernet/marvell/sky2.c: warning: control reaches end of non-void function [-Wreturn-type]: 3137:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'vxge_hw_device_hw_info_get' uses dynamic stack allocation [enabled by default]: 1089:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/neterion/vxge/vxge-main.c: warning: 'adaptive_coalesce_rx_interrupts' defined but not used [-Wunused-function]: 2150:13 => 
  - /scratch/kisskb/src/drivers/net/ethernet/neterion/vxge/vxge-main.c: warning: 'adaptive_coalesce_tx_interrupts' defined but not used [-Wunused-function]: 2122:13 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/ef10.c: warning: 'efx_ef10_free_vis' uses dynamic stack allocation [enabled by default]: 295:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: '_efx_mcdi_rpc_finish' uses dynamic stack allocation [enabled by default]: 614:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_complete_async' uses dynamic stack allocation [enabled by default]: 463:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_print_fwver' uses dynamic stack allocation [enabled by default]: 1138:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_read_assertion' uses dynamic stack allocation [enabled by default]: 1447:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_disable' uses dynamic stack allocation [enabled by default]: 612:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_enable' uses dynamic stack allocation [enabled by default]: 589:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 633:22 => 
  - /scratch/kisskb/src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 78:7 => 
  - /scratch/kisskb/src/drivers/net/fddi/skfp/h/skfbi.h: warning: "PCI_IOBASE" redefined [enabled by default]: 151:0 => 
  - /scratch/kisskb/src/drivers/net/hamradio/baycom_ser_fdx.c: warning: statement with no effect [-Wunused-value]: 397:2, 396:2, 312:4, 308:4 => 
  - /scratch/kisskb/src/drivers/net/hamradio/baycom_ser_hdx.c: warning: statement with no effect [-Wunused-value]: 397:4, 455:2, 393:4, 414:4, 456:2 => 
  - /scratch/kisskb/src/drivers/net/hamradio/yam.c: warning: statement with no effect [-Wunused-value]: 314:2, 490:2, 907:3, 315:2, 526:2, 525:2, 491:2 => 
  - /scratch/kisskb/src/drivers/net/usb/hso.c: warning: format '%d' expects argument of type 'int', but argument 4 has type 'tcflag_t' [-Wformat]: 1401:3 => 
  - /scratch/kisskb/src/drivers/net/usb/hso.c: warning: format '%d' expects argument of type 'int', but argument 5 has type 'tcflag_t' [-Wformat]: 1401:3 => 
  - /scratch/kisskb/src/drivers/net/usb/rtl8150.c: warning: "RSR" redefined [enabled by default]: 30:0 => 
  - /scratch/kisskb/src/drivers/net/usb/sr9700.h: warning: "RSR" redefined [enabled by default]: 65:0 => 
  - /scratch/kisskb/src/drivers/net/wireless/ath/carl9170/fwcmd.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[]' [-Wattributes]: 123:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/b43/b43.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]: 641:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/b43/xmit.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]: 290:3, 88:3, 64:3, 283:3, 77:3 => 
  - /scratch/kisskb/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]: 381:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]: 331:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]: 143:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/cw1200/wsm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 380:6 => 
  - /scratch/kisskb/src/drivers/net/wireless/iwlegacy/3945-mac.c: warning: 'phys_addr' may be used uninitialized in this function [-Wuninitialized]: 620:33 => 
  - /scratch/kisskb/src/drivers/net/wireless/iwlegacy/4965-mac.c: warning: 'phys_addr' may be used uninitialized in this function [-Wuninitialized]: 1857:33 => 
  - /scratch/kisskb/src/drivers/net/wireless/libertas/if_cs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 878:15 => 
  - /scratch/kisskb/src/drivers/net/wireless/mac80211_hwsim.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 692:20 => 
  - /scratch/kisskb/src/drivers/net/wireless/mwifiex/cmdevt.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]: 835:2, 202:2, 916:4, 463:3 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/orinoco_cs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 153:6 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/spectrum_cs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 216:6 => 
  - /scratch/kisskb/src/drivers/net/wireless/p54/lmac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>[3]' [-Wattributes]: 377:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 315:1 => 
  - /scratch/kisskb/src/drivers/nfc/st21nfca/st21nfca.c: warning: 'sak' may be used uninitialized in this function [-Wuninitialized]: 489:20, 484:31 => 635:20
  - /scratch/kisskb/src/drivers/pci/pci-driver.c: warning: 'pci_restore_standard_config' defined but not used [-Wunused-function]: 480:12 => 
  - /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'f_reg' may be used uninitialized in this function [-Wuninitialized]: 1280:2 => 
  - /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'ss_reg' may be used uninitialized in this function [-Wuninitialized]: 1280:2 => 
  - /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 693:12 => 
  - /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 724:13 => 
  - /scratch/kisskb/src/drivers/regulator/tps6586x-regulator.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 423:8 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx/aic79xx_core.c: warning: 'ahd_loadseq' uses dynamic stack allocation [enabled by default]: 9509:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx/aic7xxx_core.c: warning: 'ahc_loadseq' uses dynamic stack allocation [enabled by default]: 6957:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used uninitialized in this function [-Wuninitialized]: 597:21 => 
  - /scratch/kisskb/src/drivers/scsi/bfa/bfa_fcpim.c: warning: left shift count >= width of type [enabled by default]: 2497:4, 2509:4 => 
  - /scratch/kisskb/src/drivers/scsi/bfa/bfa_fcpim.c: warning: right shift count >= width of type [enabled by default]: 2497:4, 2509:4 => 
  - /scratch/kisskb/src/drivers/scsi/dpt_i2o.c: warning: 'adpt_i2o_passthru' uses dynamic stack allocation [enabled by default]: 1897:1 => 
  - /scratch/kisskb/src/drivers/scsi/dpt_i2o.c: warning: 'dptids' defined but not used [-Wunused-variable]: 183:29 => 
  - /scratch/kisskb/src/drivers/scsi/fdomain.c: warning: 'fdomain_pci_tbl' defined but not used [-Wunused-variable]: 1774:29 => 
  - /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]: 6373:17 => 
  - /scratch/kisskb/src/drivers/scsi/initio.c: warning: 'i91u_pci_devices' defined but not used [-Wunused-variable]: 131:29 => 
  - /scratch/kisskb/src/drivers/scsi/osd/osd_initiator.c: warning: 'osd_req_decode_sense_full' uses dynamic stack allocation [enabled by default]: 1947:1 => 
  - /scratch/kisskb/src/drivers/scsi/osst.h: warning: 'packed' attribute ignored for field of type 'u32' [-Wattributes]: 96:2 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_tgt_if.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 289:10 => 
  - /scratch/kisskb/src/drivers/scsi/sym53c8xx_2/sym_defs.h: warning: "WSR" redefined [enabled by default]: 109:0 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 1021:13, 1256:19 => 
  - /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: warning: 'cr_width' may be used uninitialized in this function [-Wuninitialized]: 695:6 => 
  - /scratch/kisskb/src/drivers/spi/spi-fsl-lib.c: warning: unused variable 'ret' [-Wunused-variable]: 195:6 => 
  - /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "READ" redefined [enabled by default]: 74:0 => 
  - /scratch/kisskb/src/drivers/spi/spi-omap-100k.c: warning: "WRITE" redefined [enabled by default]: 73:0 => 
  - /scratch/kisskb/src/drivers/spi/spi-rspi.c: warning: unused variable 'ret' [-Wunused-variable]: 633:6 => 
  - /scratch/kisskb/src/drivers/staging/android/binder.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]: 713:24 => 
  - /scratch/kisskb/src/drivers/staging/android/binder.c: warning: 'buffer_size' may be used uninitialized in this function [-Wuninitialized]: 713:37 => 
  - /scratch/kisskb/src/drivers/staging/android/sync.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 874:3 => 
  - /scratch/kisskb/src/drivers/staging/bcm/CmHost.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1563:3, 1502:3, 1545:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/aio_aio12_8.c: warning: statement with no effect [-Wunused-value]: 135:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/das08.c: warning: statement with no effect [-Wunused-value]: 351:3, 356:3, 233:2, 232:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/das16m1.c: warning: statement with no effect [-Wunused-value]: 446:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: warning: statement with no effect [-Wunused-value]: 369:2, 430:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2801.c: warning: statement with no effect [-Wunused-value]: 342:2, 343:2, 340:2, 341:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/dt2814.c: warning: statement with no effect [-Wunused-value]: 233:3, 232:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/fl512.c: warning: statement with no effect [-Wunused-value]: 106:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_at_ao.c: warning: statement with no effect [-Wunused-value]: 330:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_mio_common.c: warning: 'sample' may be used uninitialized in this function [-Wuninitialized]: 5715:11 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/pcmda12.c: warning: statement with no effect [-Wunused-value]: 110:3, 128:2, 89:4 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/rti800.c: warning: statement with no effect [-Wunused-value]: 175:2, 289:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/s526.c: warning: statement with no effect [-Wunused-value]: 363:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]: 6128:2, 6154:2, 6102:2, 6076:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 5868:7, 5808:7, 5848:7, 5828:7 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap.h: warning: "IO_FIELD" redefined [enabled by default]: 444:0 => 
  - /scratch/kisskb/src/drivers/staging/dgnc/dgnc_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]: 557:2, 582:2, 607:2, 532:2 => 
  - /scratch/kisskb/src/drivers/staging/dgnc/dgnc_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 275:4, 292:4, 309:4, 326:4 => 
  - /scratch/kisskb/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 582:1 => 
  - /scratch/kisskb/src/drivers/staging/gdm724x/gdm_lte.c: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]: 194:3 => 
  - /scratch/kisskb/src/drivers/staging/speakup/serialio.c: warning: statement with no effect [-Wunused-value]: 119:2, 118:2, 117:2, 116:2 => 
  - /scratch/kisskb/src/drivers/staging/usbip/stub_dev.c: warning: 'stub_table' defined but not used [-Wunused-variable]: 33:29 => 
  - /scratch/kisskb/src/drivers/staging/vt6655/device_main.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 3107:1 => 
  - /scratch/kisskb/src/drivers/staging/vt6656/mac.h: warning: 'packed' attribute ignored for field of type 'struct <anonymous>' [-Wattributes]: 411:3 => 
  - /scratch/kisskb/src/drivers/staging/wlags49_h2/hcf.c: warning: unused variable 'io_port' [-Wunused-variable]: 3636:22 => 
  - /scratch/kisskb/src/drivers/staging/wlags49_h25/../wlags49_h2/hcf.c: warning: unused variable 'io_port' [-Wunused-variable]: 3636:22 => 
  - /scratch/kisskb/src/drivers/target/iscsi/iscsi_target.c: warning: 'iscsit_send_datain' uses dynamic stack allocation [enabled by default]: 2757:1 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1716:2, 1718:18, 1721:18 => 1716:18, 1711:2
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_core.c: warning: statement with no effect [-Wunused-value]: 2189:3, 1233:3, 2213:3 => 
  - /scratch/kisskb/src/drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]: 2506:1 => 
  - /scratch/kisskb/src/drivers/tty/serial/ifx6x60.c: warning: 'more' may be used uninitialized in this function [-Wuninitialized]: 715:8 => 
  - /scratch/kisskb/src/drivers/tty/serial/sunzilog.c: warning: 'sunzilog_putchar' defined but not used [-Wunused-function]: 1123:13 => 
  - /scratch/kisskb/src/drivers/usb/core/hcd-pci.c: warning: 'ehci_wait_for_companions' defined but not used [-Wunused-function]: 149:13 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]: 420:1 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]: 2119:47 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]: 1060:14, 1039:4, 1080:19, 1060:30, 993:5, 1007:28, 1080:6 => 
  - /scratch/kisskb/src/drivers/usb/host/isp1362.h: warning: statement with no effect [-Wunused-value]: 706:3 => 
  - /scratch/kisskb/src/drivers/usb/host/oxu210hp-hcd.c: warning: unused variable 'base' [-Wunused-variable]: 3904:8 => 
  - /scratch/kisskb/src/drivers/usb/misc/usb3503.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 195:11 => 
  - /scratch/kisskb/src/drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 211:51 => 
  - /scratch/kisskb/src/drivers/usb/serial/cp210x.c: warning: passing argument 2 of 'cp210x_get_termios_port' from incompatible pointer type [enabled by default]: 483:4 => 
  - /scratch/kisskb/src/drivers/usb/serial/io_edgeport.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 1461:2, 1460:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/io_edgeport.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'tcflag_t' [-Wformat]: 1461:2, 1460:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/io_ti.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 2254:2, 2252:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/io_ti.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'tcflag_t' [-Wformat]: 2254:2, 2252:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/mos7720.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 1698:2, 1695:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/mos7720.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]: 1695:2, 1698:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/mos7840.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 1960:2, 1958:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/mos7840.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'long unsigned int' [-Wformat]: 1958:2, 1960:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/ti_usb_3410_5052.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 716:2, 715:2 => 
  - /scratch/kisskb/src/drivers/usb/serial/ti_usb_3410_5052.c: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'tcflag_t' [-Wformat]: 716:2, 715:2 => 
  - /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 596:32, 566:10, 441:16, 622:11 => 
  - /scratch/kisskb/src/drivers/video/fbdev/goldfishfb.c: warning: 'fbpaddr' may be used uninitialized in this function [-Wuninitialized]: 256:24 => 
  - /scratch/kisskb/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]: 335:2 => 
  - /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]: 1634:4 => 
  - /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]: 1635:4 => 
  - /scratch/kisskb/src/drivers/video/fbdev/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 734:23 => 
  - /scratch/kisskb/src/fs/afs/internal.h: warning: 'packed' attribute ignored for field of type 'enum <anonymous>' [-Wattributes]: 164:2 => 
  - /scratch/kisskb/src/fs/aio.c: warning: 'nr_segs' may be used uninitialized in this function: 1309 => 
  - /scratch/kisskb/src/fs/btrfs/disk-io.c: warning: 'btrfs_check_super_csum' uses dynamic stack allocation [enabled by default]: 419:1 => 
  - /scratch/kisskb/src/fs/btrfs/hash.c: warning: 'btrfs_crc32c' uses dynamic stack allocation [enabled by default]: 50:1 => 
  - /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'cow_start' may be used uninitialized in this function [-Wuninitialized]: 1405:7 => 
  - /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'cur_offset' may be used uninitialized in this function [-Wuninitialized]: 1278:16, 1417:31 => 1298:16
  - /scratch/kisskb/src/fs/btrfs/raid56.c: warning: 'finish_rmw' uses dynamic stack allocation [enabled by default]: 1265:1 => 
  - /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]: 58:13 => 
  - /scratch/kisskb/src/fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_implict_list' [-Wattributes]: 252:3 => 
  - /scratch/kisskb/src/fs/exofs/common.h: warning: 'packed' attribute ignored for field of type 'struct exofs_layout_sliding_window' [-Wattributes]: 243:3 => 
  - /scratch/kisskb/src/fs/f2fs/node.c: warning: 'restore_node_summary' uses dynamic stack allocation [enabled by default]: 1745:1 => 
  - /scratch/kisskb/src/fs/f2fs/segment.c: warning: '__next_free_blkoff' uses dynamic stack allocation [enabled by default]: 797:1 => 
  - /scratch/kisskb/src/fs/f2fs/segment.c: warning: 'add_discard_addrs' uses dynamic stack allocation [enabled by default]: 432:1 => 
  - /scratch/kisskb/src/fs/isofs/compress.c: warning: 'zisofs_readpage' uses dynamic stack allocation [enabled by default]: 360:1 => 
  - /scratch/kisskb/src/fs/isofs/compress.c: warning: 'zisofs_uncompress_block' uses dynamic stack allocation [enabled by default]: 193:1 => 
  - /scratch/kisskb/src/fs/jffs2/erase.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'size_t' [-Wformat]: 471:5, 402:4 => 
  - /scratch/kisskb/src/fs/jffs2/erase.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 357:4 => 
  - /scratch/kisskb/src/fs/jffs2/gc.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 1015:4, 934:5 => 
  - /scratch/kisskb/src/fs/jffs2/gc.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]: 683:3 => 
  - /scratch/kisskb/src/fs/jffs2/nodemgmt.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 788:3, 765:3 => 
  - /scratch/kisskb/src/fs/jffs2/read.c: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]: 47:3 => 
  - /scratch/kisskb/src/fs/jffs2/readinode.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]: 1203:3, 92:4 => 
  - /scratch/kisskb/src/fs/jffs2/readinode.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]: 69:3 => 
  - /scratch/kisskb/src/fs/jffs2/readinode.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]: 947:3, 1032:4 => 
  - /scratch/kisskb/src/fs/jffs2/scan.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 121:3, 128:3 => 
  - /scratch/kisskb/src/fs/jffs2/scan.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 105:3 => 
  - /scratch/kisskb/src/fs/jffs2/scan.c: warning: format '%zx' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]: 300:3 => 
  - /scratch/kisskb/src/fs/jffs2/wbuf.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 2 has type 'size_t' [-Wformat]: 645:3 => 
  - /scratch/kisskb/src/fs/jffs2/wbuf.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 1115:3, 1090:3, 1048:3 => 
  - /scratch/kisskb/src/fs/jffs2/wbuf.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'size_t' [-Wformat]: 1090:3, 1048:3, 1115:3 => 
  - /scratch/kisskb/src/fs/jffs2/wbuf.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 971:4 => 
  - /scratch/kisskb/src/fs/jffs2/write.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 5 has type 'size_t' [-Wformat]: 113:3, 271:3 => 
  - /scratch/kisskb/src/fs/libfs.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 846:9 => 
  - /scratch/kisskb/src/fs/mpage.c: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 308:1 => 
  - /scratch/kisskb/src/fs/mpage.c: warning: the frame size of 1140 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 652:1 => 
  - /scratch/kisskb/src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u16' [-Wattributes]: 125:4, 128:4, 124:4, 126:4, 127:4 => 
  - /scratch/kisskb/src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]: 122:4, 123:4 => 
  - /scratch/kisskb/src/fs/nfs/super.c: warning: 'nfs_show_stats' uses dynamic stack allocation [enabled by default]: 891:1 => 
  - /scratch/kisskb/src/fs/ntfs/aops.c: warning: 'ntfs_write_mst_block' uses dynamic stack allocation [enabled by default]: 1329:1 => 
  - /scratch/kisskb/src/fs/ntfs/compress.c: warning: 'ntfs_decompress' uses dynamic stack allocation [enabled by default]: 445:1 => 
  - /scratch/kisskb/src/fs/ntfs/mft.c: warning: 'ntfs_sync_mft_mirror' uses dynamic stack allocation [enabled by default]: 636:1 => 
  - /scratch/kisskb/src/fs/ntfs/mft.c: warning: 'write_mft_record_nolock' uses dynamic stack allocation [enabled by default]: 844:1 => 
  - /scratch/kisskb/src/fs/pstore/ram_core.c: warning: 'persistent_ram_decode_rs8' uses dynamic stack allocation [enabled by default]: 153:1 => 
  - /scratch/kisskb/src/fs/pstore/ram_core.c: warning: 'persistent_ram_encode_rs8' uses dynamic stack allocation [enabled by default]: 141:1 => 
  - /scratch/kisskb/src/fs/reiserfs/inode.c: warning: 'reiserfs_new_directory' uses dynamic stack allocation [enabled by default]: 1861:1 => 
  - /scratch/kisskb/src/fs/splice.c: warning: 'ret' may be used uninitialized in this function: 954 => 
  - /scratch/kisskb/src/fs/udf/super.c: warning: 'map' may be used uninitialized in this function [-Wuninitialized]: 1322:9 => 
  - /scratch/kisskb/src/fs/xfs/xfs_inode_item.c: warning: 'xfs_iflush_done' uses dynamic stack allocation [enabled by default]: 693:1 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of '__raw_readb' makes pointer from integer without a cast [enabled by default]: 170:4, 129:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of '__raw_readl' makes pointer from integer without a cast [enabled by default]: 196:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [enabled by default]: 183:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'readl' makes pointer from integer without a cast [enabled by default]: 139:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'readw' makes pointer from integer without a cast [enabled by default]: 134:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u16' makes pointer from integer without a cast [enabled by default]: 183:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u32' makes pointer from integer without a cast [enabled by default]: 196:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u8' makes pointer from integer without a cast [enabled by default]: 129:2, 170:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast [enabled by default]: 144:2, 209:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast [enabled by default]  CC [M]  drivers/media/usb/dvb-usb/pctv452e.o: 154:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast [enabled by default]: 233:4, 154:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of '__raw_writew' makes pointer from integer without a cast [enabled by default]: 149:2, 221:4 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u16' makes pointer from integer without a cast [enabled by default]: 221:4, 149:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u32' makes pointer from integer without a cast [enabled by default]: 233:4, 154:2 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u8' makes pointer from integer without a cast [enabled by default]: 144:2, 209:4 => 
  - /scratch/kisskb/src/include/linux/mfd/da9052/da9052.h: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 151:6, 174:6 => 
  - /scratch/kisskb/src/include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 349:2, 279:4, 397:11, 324:17, 367:14, 414:2, 332:11, 290:22, 278:6 => 279:4, 397:11, 367:14, 278:6, 332:11
  - /scratch/kisskb/src/include/linux/scatterlist.h: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]: 115:2 => 
  - /scratch/kisskb/src/include/linux/spinlock.h: warning: 'vf' may be used uninitialized in this function [-Wuninitialized]: 343:2 => 
  - /scratch/kisskb/src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type '__fs32' [-Wattributes]: 168:2, 144:2, 181:2, 100:2, 114:2, 142:2, 180:2, 30:2, 42:2, 112:2, 43:2, 130:2 => 
  - /scratch/kisskb/src/include/linux/sysv_fs.h: warning: 'packed' attribute ignored for field of type 'sysv_zone_t[64]' [-Wattributes]: 171:2 => 
  - /scratch/kisskb/src/include/linux/typecheck.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 11:18 => 
  - /scratch/kisskb/src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type '__be16' [-Wattributes]: 30:2, 32:2 => 
  - /scratch/kisskb/src/include/net/ipx.h: warning: 'packed' attribute ignored for field of type 'struct ipx_address' [-Wattributes]: 41:9, 42:9 => 
  - /scratch/kisskb/src/include/sound/control.h: warning: 'master_vol' may be used uninitialized in this function [-Wuninitialized]: 207:2 => 
  - /scratch/kisskb/src/include/sound/control.h: warning: 'speaker_vol' may be used uninitialized in this function [-Wuninitialized]: 207:2 => 
  - /scratch/kisskb/src/ipc/msgutil.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 155:9, 101:10, 54:9, 94:9, 162:10, 66:10 => 
  - /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 1804:13, 1036:9 => 1863:13
  - /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function: 1653 => 
  - /scratch/kisskb/src/kernel/debug/debug_core.c: warning: value computed is not used [-Wunused-value]: 504:4, 519:5 => 
  - /scratch/kisskb/src/kernel/relay.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 2 has type 'size_t' [-Wformat]: 833:10 => 
  - /scratch/kisskb/src/kernel/relay.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 833:10 => 
  - /scratch/kisskb/src/kernel/sched/core.c: warning: (near initialization for 'default_topology[0].mask') [enabled by default]: 6116:2 => 
  - /scratch/kisskb/src/kernel/sched/core.c: warning: initialization from incompatible pointer type [enabled by default]: 6116:2 => 
  - /scratch/kisskb/src/kernel/sched/core.c: warning: unsupported argument to '__builtin_return_address' [enabled by default]: 2547:10, 2549:11 => 
  - /scratch/kisskb/src/kernel/sched/fair.c: warning: 'update_cfs_rq_blocked_load' declared inline after being called: 286 => 
  - /scratch/kisskb/src/kernel/sched/fair.c: warning: previous declaration of 'update_cfs_rq_blocked_load' was here: 286 => 
  - /scratch/kisskb/src/kernel/time/timer_stats.c: warning: 'timer_stats_update_stats' uses dynamic stack allocation [enabled by default]: 268:1 => 
  - /scratch/kisskb/src/lib/bch.c: warning: 'build_deg2_base' uses dynamic stack allocation [enabled by default]: 1149:1 => 
  - /scratch/kisskb/src/lib/bch.c: warning: 'encode_bch' uses dynamic stack allocation [enabled by default]: 253:1 => 
  - /scratch/kisskb/src/lib/bch.c: warning: 'solve_linear_system.isra.7.constprop.10' uses dynamic stack allocation [enabled by default]: 502:1 => 
  - /scratch/kisskb/src/lib/btree.c: warning: 'btree_get_prev' uses dynamic stack allocation [enabled by default]: 360:1 => 
  - /scratch/kisskb/src/lib/btree.c: warning: 'btree_merge' uses dynamic stack allocation [enabled by default]: 673:1 => 
  - /scratch/kisskb/src/lib/crc32.c: warning: passing argument 4 of 'crc32_be_generic' from incompatible pointer type: 345 => 
  - /scratch/kisskb/src/lib/crc32.c: warning: passing argument 4 of 'crc32_le_generic' from incompatible pointer type: 270, 265 => 
  - /scratch/kisskb/src/lib/iomap.c: warning: statement with no effect [-Wunused-value]: 201:2, 197:2, 205:2 => 
  - /scratch/kisskb/src/lib/kstrtox.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 347:1, 345:1, 341:1, 338:1, 344:1, 339:1, 340:1, 342:1, 343:1, 346:1 => 
  - /scratch/kisskb/src/lib/libcrc32c.c: warning: 'crc32c' uses dynamic stack allocation [enabled by default]: 58:1 => 
  - /scratch/kisskb/src/lib/reed_solomon/reed_solomon.c: warning: 'decode_rs16' uses dynamic stack allocation [enabled by default]: 373:1 => 
  - /scratch/kisskb/src/lib/reed_solomon/reed_solomon.c: warning: 'decode_rs8' uses dynamic stack allocation [enabled by default]: 329:1 => 
  - /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.11' uses dynamic stack allocation [enabled by default]: 748:1 => 
  - /scratch/kisskb/src/mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]: 98:6 => 
  - /scratch/kisskb/src/mm/dmapool.c: warning: format '%Zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]: 98:6 => 
  - /scratch/kisskb/src/mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 5572:35, 5462:19, 5590:32 => 4734:19, 4845:35
  - /scratch/kisskb/src/mm/memcontrol.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 4891:2 => 
  - /scratch/kisskb/src/mm/memory.c: warning: #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid. [-Wcpp]: 75:2 => 
  - /scratch/kisskb/src/mm/percpu-km.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 105:10 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]: 1709:3 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 1719:2, 826:3 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]: 826:3, 1135:9 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 4 has type 'unsigned int' [-Wformat]: 727:3, 1135:9, 1719:2 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 5 has type 'unsigned int' [-Wformat]: 1135:9, 727:3, 1719:2 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 6 has type 'unsigned int' [-Wformat]: 1719:2, 1135:9 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 7 has type 'unsigned int' [-Wformat]: 1719:2, 1135:9 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zu' expects argument of type 'size_t', but argument 8 has type 'unsigned int' [-Wformat]: 1135:9 => 
  - /scratch/kisskb/src/mm/percpu.c: warning: format '%zx' expects argument of type 'size_t', but argument 2 has type 'unsigned int' [-Wformat]: 1709:3 => 
  - /scratch/kisskb/src/mm/pgtable-generic.c: warning: unused variable 'mm' [-Wunused-variable]: 113:20 => 
  - /scratch/kisskb/src/mm/slab.c: warning: passing argument 2 of '__cache_free' discards qualifiers from pointer target type: 3744 => 
  - /scratch/kisskb/src/mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]: 417:6 => 
  - /scratch/kisskb/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]: 2391:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: '__slab_free' uses dynamic stack allocation [enabled by default]: 2654:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'deactivate_slab' uses dynamic stack allocation [enabled by default]: 1948:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'get_partial_node.isra.35' uses dynamic stack allocation [enabled by default]: 1656:1 => 
  - /scratch/kisskb/src/mm/slub.c: warning: 'unfreeze_partials.isra.33' uses dynamic stack allocation [enabled by default]: 2016:1 => 
  - /scratch/kisskb/src/net/bluetooth/hidp/core.c: warning: 'session' may be used uninitialized in this function [-Wuninitialized]: 1351:18 => 
  - /scratch/kisskb/src/net/bridge/netfilter/ebtables.c: warning: 'compat_copy_everything_to_user' uses dynamic stack allocation [enabled by default]: 1840:1 => 
  - /scratch/kisskb/src/net/core/dev_ioctl.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 268:10, 148:11 => 
  - /scratch/kisskb/src/net/core/pktgen.c: warning: 'pktgen_if_write' uses dynamic stack allocation [enabled by default]: 1715:1 => 
  - /scratch/kisskb/src/net/core/rtnetlink.c: warning: 'rtnl_newlink' uses dynamic stack allocation [enabled by default]: 2082:1 => 
  - /scratch/kisskb/src/net/core/sysctl_net_core.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 155:9 => 
  - /scratch/kisskb/src/net/ipv4/ping.c: warning: 'family' may be used uninitialized in this function [-Wuninitialized]: 464:2, 464:17, 567:49 => 464:17
  - /scratch/kisskb/src/net/ipv4/ping.c: warning: 'icmph' may be used uninitialized in this function [-Wuninitialized]: 508:29, 501:48, 501:35 => 501:48, 508:29
  - /scratch/kisskb/src/net/ipv4/ping.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]: 504:2, 465:29, 520:3, 678:21, 559:42 => 504:2, 520:3, 678:21, 559:42
  - /scratch/kisskb/src/net/ipv6/xfrm6_state.c: warning: '__xfrm6_sort' uses dynamic stack allocation [enabled by default]: 83:1 => 
  - /scratch/kisskb/src/net/llc/llc_sap.c: warning: 'llc_sap_mcast' uses dynamic stack allocation [enabled by default]: 418:1 => 
  - /scratch/kisskb/src/net/netfilter/nfnetlink.c: warning: 'nfnetlink_rcv_batch' uses dynamic stack allocation [enabled by default]: 366:1 => 
  - /scratch/kisskb/src/net/netfilter/nfnetlink.c: warning: 'nfnetlink_rcv_msg' uses dynamic stack allocation [enabled by default]: 223:1 => 
  - /scratch/kisskb/src/net/netfilter/nfnetlink_cttimeout.c: warning: 'ctnl_timeout_parse_policy' uses dynamic stack allocation [enabled by default]: 68:1 => 
  - /scratch/kisskb/src/net/rds/connection.c: warning: 'rds_for_each_conn_info' uses dynamic stack allocation [enabled by default]: 473:1 => 
  - /scratch/kisskb/src/net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 200:1 => 
  - /scratch/kisskb/src/net/rds/message.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 260:5 => 
  - /scratch/kisskb/src/net/rxrpc/rxkad.c: warning: 'rxkad_prime_packet_security' uses dynamic stack allocation [enabled by default]: 148:1 => 
  - /scratch/kisskb/src/net/sunrpc/svc.c: warning: format '%Zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 1237:4 => 
  - /scratch/kisskb/src/net/unix/af_unix.c: warning: 'path.dentry' may be used uninitialized in this function: 902 => 
  - /scratch/kisskb/src/net/unix/af_unix.c: warning: 'path.mnt' may be used uninitialized in this function: 902 => 
  - /scratch/kisskb/src/security/apparmor/crypto.c: warning: 'aa_calc_profile_hash' uses dynamic stack allocation [enabled by default]: 72:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_api.c: warning: 'ima_audit_measurement' uses dynamic stack allocation [enabled by default]: 327:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_boot_aggregate_tfm' uses dynamic stack allocation [enabled by default]: 283:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm' uses dynamic stack allocation [enabled by default]: 224:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_file_hash_tfm' uses dynamic stack allocation [enabled by default]: 157:1 => 
  - /scratch/kisskb/src/sound/core/oss/pcm_oss.c: warning: 'snd_pcm_oss_sync' uses dynamic stack allocation [enabled by default]: 1697:1 => 
  - /scratch/kisskb/src/sound/core/pcm_native.c: warning: 'snd_pcm_hw_refine' uses dynamic stack allocation [enabled by default]: 333:1 => 
  - /scratch/kisskb/src/sound/drivers/serial-u16550.c: warning: statement with no effect [-Wunused-value]: 462:2, 307:2, 461:2, 463:2, 501:2 => 
  - /scratch/kisskb/src/sound/oss/ad1848.c: warning: 'id_table' defined but not used [-Wunused-variable]: 2863:32 => 
  - /scratch/kisskb/src/sound/soc/codecs/adau1977.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 971:3 => 
  - /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_resume' defined but not used [-Wunused-function]: 2432:12 => 
  - /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_suspend' defined but not used [-Wunused-function]: 2449:12 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 337:7 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 593:3 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]: 593:3 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: right shift count >= width of type [enabled by default]: 593:3 => 
  - /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 70:13 => 
  - /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 162:7 => 
  - /scratch/kisskb/src/sound/soc/soc-core.c: warning: 'format_register_str' uses dynamic stack allocation [enabled by default]: 133:1 => 
  - <stdin>: warning: #warning syscall clock_adjtime not implemented [-Wcpp]: 1205:2 => 
  - <stdin>: warning: #warning syscall clock_adjtime not implemented: 1205:2 => 
  - <stdin>: warning: #warning syscall dup3 not implemented [-Wcpp]: 1166:2 => 
  - <stdin>: warning: #warning syscall dup3 not implemented: 1166:2 => 
  - <stdin>: warning: #warning syscall epoll_create1 not implemented [-Wcpp]: 1163:2 => 
  - <stdin>: warning: #warning syscall epoll_create1 not implemented: 1163:2 => 
  - <stdin>: warning: #warning syscall eventfd2 not implemented [-Wcpp]: 1160:2 => 
  - <stdin>: warning: #warning syscall eventfd2 not implemented: 1160:2 => 
  - <stdin>: warning: #warning syscall fallocate not implemented: 1148:2 => 
  - <stdin>: warning: #warning syscall fanotify_init not implemented [-Wcpp]: 1190:2 => 
  - <stdin>: warning: #warning syscall fanotify_init not implemented: 1190:2 => 
  - <stdin>: warning: #warning syscall fanotify_mark not implemented [-Wcpp]: 1193:2 => 
  - <stdin>: warning: #warning syscall fanotify_mark not implemented: 1193:2 => 
  - <stdin>: warning: #warning syscall finit_module not implemented [-Wcpp]: 1226:2 => 
  - <stdin>: warning: #warning syscall finit_module not implemented: 1226:2 => 
  - <stdin>: warning: #warning syscall inotify_init1 not implemented [-Wcpp]: 1172:2 => 
  - <stdin>: warning: #warning syscall inotify_init1 not implemented: 1172:2 => 
  - <stdin>: warning: #warning syscall kcmp not implemented [-Wcpp]: 1223:2 => 
  - <stdin>: warning: #warning syscall kcmp not implemented: 1223:2 => 
  - <stdin>: warning: #warning syscall name_to_handle_at not implemented [-Wcpp]: 1199:2 => 
  - <stdin>: warning: #warning syscall name_to_handle_at not implemented: 1199:2 => 
  - <stdin>: warning: #warning syscall open_by_handle_at not implemented [-Wcpp]: 1202:2 => 
  - <stdin>: warning: #warning syscall open_by_handle_at not implemented: 1202:2 => 
  - <stdin>: warning: #warning syscall perf_event_open not implemented [-Wcpp]: 1184:2 => 
  - <stdin>: warning: #warning syscall perf_event_open not implemented: 1184:2 => 
  - <stdin>: warning: #warning syscall pipe2 not implemented [-Wcpp]: 1169:2 => 
  - <stdin>: warning: #warning syscall pipe2 not implemented: 1169:2 => 
  - <stdin>: warning: #warning syscall pread64 not implemented: 728:2 => 
  - <stdin>: warning: #warning syscall preadv not implemented [-Wcpp]: 1175:2 => 
  - <stdin>: warning: #warning syscall preadv not implemented: 1175:2 => 
  - <stdin>: warning: #warning syscall prlimit64 not implemented [-Wcpp]: 1196:2 => 
  - <stdin>: warning: #warning syscall prlimit64 not implemented: 1196:2 => 
  - <stdin>: warning: #warning syscall process_vm_readv not implemented [-Wcpp]: 1217:2 => 
  - <stdin>: warning: #warning syscall process_vm_readv not implemented: 1217:2 => 
  - <stdin>: warning: #warning syscall process_vm_writev not implemented [-Wcpp]: 1220:2 => 
  - <stdin>: warning: #warning syscall process_vm_writev not implemented: 1220:2 => 
  - <stdin>: warning: #warning syscall pwrite64 not implemented: 731:2 => 
  - <stdin>: warning: #warning syscall pwritev not implemented [-Wcpp]: 1178:2 => 
  - <stdin>: warning: #warning syscall pwritev not implemented: 1178:2 => 
  - <stdin>: warning: #warning syscall recvmmsg not implemented: 1187:2 => 
  - <stdin>: warning: #warning syscall renameat2 not implemented: 1235:2 => 
  - <stdin>: warning: #warning syscall rt_tgsigqueueinfo not implemented [-Wcpp]: 1181:2 => 
  - <stdin>: warning: #warning syscall rt_tgsigqueueinfo not implemented: 1181:2 => 
  - <stdin>: warning: #warning syscall sched_getattr not implemented: 1232:2 => 
  - <stdin>: warning: #warning syscall sched_setattr not implemented: 1229:2 => 
  - <stdin>: warning: #warning syscall sendmmsg not implemented: 1211:2 => 
  - <stdin>: warning: #warning syscall signalfd4 not implemented [-Wcpp]: 1157:2 => 
  - <stdin>: warning: #warning syscall signalfd4 not implemented: 1157:2 => 
  - <stdin>: warning: #warning syscall syncfs not implemented [-Wcpp]: 1208:2 => 
  - <stdin>: warning: #warning syscall syncfs not implemented: 1208:2 => 
  - <stdin>: warning: #warning syscall timerfd_create not implemented [-Wcpp]: 1142:2 => 
  - <stdin>: warning: #warning syscall timerfd_create not implemented: 1142:2 => 
  - <stdin>: warning: #warning syscall timerfd_gettime not implemented [-Wcpp]: 1154:2 => 
  - <stdin>: warning: #warning syscall timerfd_gettime not implemented: 1154:2 => 
  - <stdin>: warning: #warning syscall timerfd_settime not implemented [-Wcpp]: 1151:2 => 
  - <stdin>: warning: #warning syscall timerfd_settime not implemented: 1151:2 => 
  - modpost: WARNING: modpost: Found 1 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 2 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 3 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 7 section mismatch(es).: N/A => 
  - warning: "cause_of_death" [arch/cris/arch-v10/kernel/built-in] is COMMON symbol: N/A => 
  - warning: "cause_of_death" [vmlinux] is COMMON symbol: N/A => 
  - warning: "saved_config" [vmlinux] is COMMON symbol: N/A => 
  - warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 && DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP || PM_RUNTIME): N/A => 
  - warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES): N/A => 
  - warning: (MPC836x_RDK && MTD_NAND_FSL_ELBC && MTD_NAND_FSL_UPM) selects FSL_LBC which has unmet direct dependencies (FSL_SOC): N/A => 
  - warning: (VIDEO_EM28XX_V4L2) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT): N/A => 
  - warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x1e0): Section mismatch in reference from the variable sercons to the function .init.text:console_setup(): N/A => 
  - warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x218): Section mismatch in reference from the variable sercons0 to the function .init.text:console_setup(): N/A => 
  - warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x250): Section mismatch in reference from the variable sercons1 to the function .init.text:console_setup(): N/A => 
  - warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x288): Section mismatch in reference from the variable sercons2 to the function .init.text:console_setup(): N/A => 
  - warning: arch/cris/arch-v10/kernel/built-in.o(.data+0x2c0): Section mismatch in reference from the variable sercons3 to the function .init.text:console_setup(): N/A => 
  - warning: drivers/built-in.o(.text+0x2cd8e0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x51910): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d54): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x42b14): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x1360): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: vmlinux.o(.data+0x41970): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41a10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41b74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41c84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41ce4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41d44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41dac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41f7c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
