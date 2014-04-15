Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaDOLhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:37:06 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:34572 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaDOLg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:36:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.15-rc1
Date: Tue, 15 Apr 2014 13:36:56 +0200
Message-Id: <1397561816-9289-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.15-rc1[1] compared to v3.14[2].

Summarized:
  - build errors: +30/-3
  - build warnings: +106/-98

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.15-rc1.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7375/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)


*** ERRORS ***

30 regressions:
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_ANDCOND' undeclared (first use in this function):  => 178:17, 100:16
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_AVPN' undeclared (first use in this function):  => 213:16, 99:16, 177:17
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_BULK_REMOVE' undeclared (first use in this function):  => 268:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_CEDE' undeclared (first use in this function):  => 272:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_CPPR' undeclared (first use in this function):  => 279:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_ENTER' undeclared (first use in this function):  => 262:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_EOI' undeclared (first use in this function):  => 280:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_EXACT' undeclared (first use in this function):  => 56:6
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_IPI' undeclared (first use in this function):  => 281:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_IPOLL' undeclared (first use in this function):  => 282:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_NOT_FOUND' undeclared (first use in this function):  => 211:8, 97:8
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PARAMETER' undeclared (first use in this function):  => 155:10
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PROTECT' undeclared (first use in this function):  => 266:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PTEG_FULL' undeclared (first use in this function):  => 55:8
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_PUT_TCE' undeclared (first use in this function):  => 270:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_REMOVE' undeclared (first use in this function):  => 264:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_RTAS' undeclared (first use in this function):  => 287:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_SUCCESS' undeclared (first use in this function):  => 108:8, 229:8, 141:12, 75:8
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_TOO_HARD' undeclared (first use in this function):  => 246:12
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_XIRR' undeclared (first use in this function):  => 278:7
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr_papr.c: error: 'H_XIRR_X' undeclared (first use in this function):  => 283:7
  + /scratch/kisskb/src/drivers/cpufreq/powernv-cpufreq.c: error: implicit declaration of function 'cpu_sibling_mask' [-Werror=implicit-function-declaration]:  => 241:2
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_direction_output' [-Werror=implicit-function-declaration]:  => 1102:4
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_free' [-Werror=implicit-function-declaration]:  => 1130:3
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_request' [-Werror=implicit-function-declaration]:  => 1097:4
  + /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: error: implicit declaration of function 'gpio_set_value' [-Werror=implicit-function-declaration]:  => 169:3
  + /scratch/kisskb/src/include/linux/kvm_host.h: error: array subscript is above array bounds [-Werror=array-bounds]:  => 436:19
  + error: "__invalidate_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A
  + error: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

3 improvements:
  - error: No rule to make target include/config/auto.conf: N/A => 
  - error: initramfs.c: undefined reference to `__stack_chk_guard': .init.text+0x1067) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8: (.text+0x9c2) => 


*** WARNINGS ***

106 regressions:
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 376 => 383, 380
  + /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: 'ieee_fpe_handler' defined but not used [-Wunused-function]:  => 505:12
  + /scratch/kisskb/src/arch/x86/crypto/sha1_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 50:1
  + /scratch/kisskb/src/arch/x86/crypto/sha256_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 56:1
  + /scratch/kisskb/src/arch/x86/crypto/sha512_ssse3_glue.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 55:1
  + /scratch/kisskb/src/arch/x86/kernel/machine_kexec_32.c: warning: 'externally_visible' attribute have effect only on public objects [-Wattributes]:  => 191:12
  + /scratch/kisskb/src/arch/x86/kernel/syscall_32.c: warning: 'externally_visible' attribute ignored [-Wattributes]:  => 14:1
  + /scratch/kisskb/src/drivers/char/random.c: warning: 'arch_random_refill' uses dynamic stack allocation [enabled by default]:  => 1326:1
  + /scratch/kisskb/src/drivers/cpufreq/powernv-cpufreq.c: warning: passing argument 1 of 'smp_call_function_any' makes pointer from integer without a cast [enabled by default]:  => 242:4
  + /scratch/kisskb/src/drivers/gpu/drm/i915/i915_cmd_parser.c: warning: format '%td' expects argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int' [-Wformat]:  => 405:4
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 3577:47
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/r100.c: warning: 'disp_drain_rate.full' may be used uninitialized in this function [-Wuninitialized]:  => 3576:42
  + /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/cq.c: warning: 'hw_cqe' may be used uninitialized in this function [-Wuninitialized]:  => 309:21
  + /scratch/kisskb/src/drivers/infiniband/hw/ehca/ehca_mrmw.c: warning: 'prev_pgaddr' may be used uninitialized in this function [-Wuninitialized]:  => 1907:6
  + /scratch/kisskb/src/drivers/input/keyboard/tca8418_keypad.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 172:9
  + /scratch/kisskb/src/drivers/input/misc/max8997_haptic.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 185:19
  + /scratch/kisskb/src/drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6884:13
  + /scratch/kisskb/src/drivers/net/ethernet/chelsio/cxgb4/sge.c: warning: 'buf_size' may be used uninitialized in this function [-Wuninitialized]:  => 1854:11, 509:17, 482:18
  + /scratch/kisskb/src/drivers/net/wireless/rsi/rsi_91x_core.c: warning: 'ii' may be used uninitialized in this function [-Wuninitialized]:  => 109:23
  + /scratch/kisskb/src/drivers/net/wireless/ti/wlcore/spi.c: warning: the frame size of 1168 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 317:1
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 2 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/of/fdt.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 3 has type 'phys_addr_t' [-Wformat]:  => 1006:2
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'rc' may be used uninitialized in this function [-Wuninitialized]:  => 6628:5
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'trans_support' may be used uninitialized in this function [-Wuninitialized]:  => 7467:20
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread16' discards 'const' qualifier from pointer target type [enabled by default]:  => 46:2
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread32' discards 'const' qualifier from pointer target type [enabled by default]:  => 51:2
  + /scratch/kisskb/src/drivers/sh/clk/cpg.c: warning: passing argument 1 of 'ioread8' discards 'const' qualifier from pointer target type [enabled by default]:  => 41:2
  + /scratch/kisskb/src/drivers/spi/spi-fsl-lib.c: warning: unused variable 'ret' [-Wunused-variable]:  => 201:6
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: warning: statement with no effect [-Wunused-value]:  => 369:2, 430:2
  + /scratch/kisskb/src/drivers/staging/comedi/drivers/pcl818.c: warning: 'last_chan' may be used uninitialized in this function [-Wuninitialized]:  => 412:6
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 1563:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]:  => 6258:2, 6232:2, 6310:2, 6284:2
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]:  => 6004:7, 5964:7, 5984:7, 6024:7
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1653:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap.h: warning: "IO_FIELD" redefined [enabled by default]:  => 447:0
  + /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'invalid_cmd_field' defined but not used [-Wunused-variable]:  => 651:11
  + /scratch/kisskb/src/drivers/staging/rts5139/rts51x_transport.c: warning: 'media_not_present' defined but not used [-Wunused-variable]:  => 649:11
  + /scratch/kisskb/src/drivers/staging/silicom/bpctl_mod.c: warning: 'bp_proc_create' defined but not used [-Wunused-function]:  => 6786:12
  + /scratch/kisskb/src/drivers/staging/usbip/stub_dev.c: warning: 'stub_table' defined but not used [-Wunused-variable]:  => 33:29
  + /scratch/kisskb/src/drivers/tty/serial/crisv10.c: warning: 'ser_interrupt' defined but not used [-Wunused-function]  CC      drivers/tty/vt/vt_ioctl.o:  => 2506:1
  + /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 441:16, 622:11, 566:10, 596:32
  + /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 809:11 => 561:16, 807:11, 781:32
  + /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]:  => 58:13
  + /scratch/kisskb/src/fs/ext4/extents_status.c: warning: integer constant is too large for 'long' type:  => 813
  + /scratch/kisskb/src/fs/f2fs/checkpoint.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 89:1
  + /scratch/kisskb/src/fs/f2fs/super.c: warning: 'raw_super' may be used uninitialized in this function [-Wuninitialized]:  => 919:21
  + /scratch/kisskb/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]:  => 134:23
  + /scratch/kisskb/src/include/drm/drm_fixed.h: warning: 'crit_point_ff.full' may be used uninitialized in this function [-Wuninitialized]:  => 64:13
  + /scratch/kisskb/src/include/linux/ceph/osdmap.h: warning: control reaches end of non-void function [-Wreturn-type]  CC [M]  drivers/hwmon/ad7414.o:  => 54:1
  + /scratch/kisskb/src/include/linux/ceph/osdmap.h: warning: control reaches end of non-void function [-Wreturn-type]:  => 54:1
  + /scratch/kisskb/src/include/linux/pagemap.h: warning: 'blk_addr' may be used uninitialized in this function [-Wuninitialized]:  => 287:2
  + /scratch/kisskb/src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + /scratch/kisskb/src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + /scratch/kisskb/src/include/net/ipv6.h: warning: '*((void *)&daddr+8)' may be used uninitialized in this function [-Wuninitialized]:  => 419:38
  + /scratch/kisskb/src/include/net/ipv6.h: warning: '*((void *)&saddr+8)' may be used uninitialized in this function [-Wuninitialized]:  => 419:38
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 1609:13
  + /scratch/kisskb/src/kernel/cgroup.c: warning: 'root' may be used uninitialized in this function:  => 1486
  + /scratch/kisskb/src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 334:12
  + /scratch/kisskb/src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 270:13
  + /scratch/kisskb/src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 247:13
  + /scratch/kisskb/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]:  => 203:21
  + /scratch/kisskb/src/net/ipv4/ipconfig.c: warning: 'ic_proto_used' defined but not used [-Wunused-variable]:  => 153:12
  + /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm' uses dynamic stack allocation [enabled by default]:  => 194:1
  + /scratch/kisskb/src/sound/soc/codecs/adau1977.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 971:3
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_resume' defined but not used [-Wunused-function]:  => 545:12
  + /scratch/kisskb/src/sound/soc/codecs/pcm512x.c: warning: 'pcm512x_suspend' defined but not used [-Wunused-function]:  => 520:12
  + warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)):  => N/A
  + warning: (IXP4XX_ETH && PTP_1588_CLOCK) selects NET_PTP_CLASSIFY which has unmet direct dependencies (NET):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: drivers/built-in.o(.data+0x107c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa70): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb10): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc74): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd84): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xde4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe44): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xeac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2c30a4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x513fc): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d54): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3fe50): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1360): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x170): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x210): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x374): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x484): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x4e4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x544): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x5ac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/parisc/built-in.o(.data+0x77c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41490): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x41530): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x41694): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x417a4): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41804): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41864): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x418cc): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x41a9c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

98 improvements:
  - /scratch/kisskb/src/arch/powerpc/net/bpf_jit_comp.c: warning: the frame size of 2064 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 573:1 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_resume' defined but not used [-Wunused-function]: 2550:12 => 
  - /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'nvme_suspend' defined but not used [-Wunused-function]: 2541:12 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-intel-mid.c: warning: 'intel_gpio_runtime_idle' defined but not used [-Wunused-function]: 395:12 => 
  - /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio': 204 => 
  - /scratch/kisskb/src/drivers/i2c/busses/i2c-designware-pcidrv.c: warning: 'i2c_dw_pci_runtime_idle' defined but not used [-Wunused-function]: 188:12 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]: 120:41 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]: 120:57 => 
  - /scratch/kisskb/src/drivers/md/bcache/bset.c: warning: format '%li' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat]: 27:10 => 
  - /scratch/kisskb/src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1351:3, 1056:3 => 
  - /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]: 1105:1 => 
  - /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 190:10 => 
  - /scratch/kisskb/src/drivers/net/wireless/iwlwifi/mvm/nvm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 471:6 => 
  - /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_resume' defined but not used [-Wunused-function]: 2060:12 => 
  - /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_suspend' defined but not used [-Wunused-function]: 2038:12 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]: 1246:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]: 1246:3 => 
  - /scratch/kisskb/src/drivers/spi/spi-bfin5xx.c: warning: 'cr_width' may be used uninitialized in this function [-Wuninitialized]: 698:6 => 
  - /scratch/kisskb/src/drivers/spi/spi-gpio.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 253:8 => 
  - /scratch/kisskb/src/drivers/staging/cxt1e1/functions.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 268:21 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_conf.h: warning: "IO_FIELD" redefined [enabled by default]  LD [M]  net/sunrpc/sunrpc.o: 165:0 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_conf.h: warning: "IO_FIELD" redefined [enabled by default]: 165:0 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 961:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 164:1, 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 164:1, 103:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'tcflag_t' [-Wformat]: 494:2, 519:2, 569:2, 544:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_sysfs.c: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'tcflag_t' [-Wformat]: 292:4, 258:4, 275:4, 241:4 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 570:2 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1048 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/line6/midi.c: warning: 'line6_midi_transmit' uses dynamic stack allocation [enabled by default]: 76:1 => 
  - /scratch/kisskb/src/drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'sm7xx_vga_setup' defined but not used [-Wunused-function]: 117:19 => 
  - /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]: 773:18 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]: 670:17 => 
  - /scratch/kisskb/src/drivers/video/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1019:23 => 
  - /scratch/kisskb/src/drivers/video/intelfb/intelfbdrv.c: warning: passing argument 3 of 'get_opt_bool' from incompatible pointer type [enabled by default]: 367:3, 361:3, 357:3, 363:3, 365:3 => 
  - /scratch/kisskb/src/drivers/video/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function [-Wuninitialized]: 1015:2 => 
  - /scratch/kisskb/src/drivers/video/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function [-Wuninitialized]: 1015:2 => 
  - /scratch/kisskb/src/drivers/video/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1185:23 => 
  - /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]: 64:2 => 
  - /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]: 65:2 => 
  - /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]: 4131:13 => 
  - /scratch/kisskb/src/drivers/watchdog/shwdt.c: warning: unused variable 'wdt' [-Wunused-variable]: 296:17 => 
  - /scratch/kisskb/src/fs/btrfs/send.c: warning: 'cb' may be used uninitialized in this function [-Wuninitialized]: 3644:7 => 
  - /scratch/kisskb/src/fs/btrfs/send.c: warning: 'root' may be used uninitialized in this function [-Wuninitialized]: 3629:7 => 
  - /scratch/kisskb/src/fs/file.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 434:23 => 
  - /scratch/kisskb/src/fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]: 625:1 => 
  - /scratch/kisskb/src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]  CC [M]  net/sunrpc/auth_unix.o: 124:4 => 
  - /scratch/kisskb/src/include/linux/rbtree.h: warning: 'parent' may be used uninitialized in this function [-Wuninitialized]: 82:28 => 
  - /scratch/kisskb/src/kernel/sched/core.c: warning: control reaches end of non-void function: 2613 => 
  - /scratch/kisskb/src/kernel/trace/ftrace.c: warning: 'control_ops_free' defined but not used [-Wunused-function]: 240:13 => 
  - /scratch/kisskb/src/mm/bootmem.c: warning: control reaches end of non-void function: 379 => 
  - /scratch/kisskb/src/net/ceph/osdmap.c: warning: 'crush_do_rule_ary' uses dynamic stack allocation [enabled by default]: 1153:1 => 
  - /scratch/kisskb/src/net/core/dev.c: warning: unused variable 'null_features' [-Wunused-variable]: 2223:33 => 
  - /scratch/kisskb/src/net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1774:1 => 
  - /scratch/kisskb/src/security/integrity/ima/ima_crypto.c: warning: 'ima_calc_field_array_hash_tfm.isra.0' uses dynamic stack allocation [enabled by default]: 181:1 => 
  - /scratch/kisskb/src/sound/soc/codecs/wm8993.c: warning: unused variable 'wm8993' [-Wunused-variable]: 1562:22 => 
  - arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for ACPI_CONTAINER: 33 => 
  - arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for HOTPLUG_PCI_ACPI: 35 => 
  - warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER): N/A => 
  - warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)): N/A => 
  - warning: drivers/built-in.o(.data+0x1034): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xa68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xb08): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xc64): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.text+0x2b4db0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x54668): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d8c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x3f6a4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x1378): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x168): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x208): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x364): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x46c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x4cc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x52c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x58c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/parisc/built-in.o(.data+0x734): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40008): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x400a8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40204): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x4030c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4036c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x403cc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4042c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x405d4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
