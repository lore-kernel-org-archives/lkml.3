Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab3E1HJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:09:28 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:50239 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3E1HJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:09:25 -0400
Date: Tue, 28 May 2013 09:09:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.10-rc3
Message-ID: <alpine.DEB.2.00.1305280908430.28098@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.10-rc3[1] compared to v3.9[2].

Summarized:
  - build errors: +32/-23
  - build warnings: +234/-164

JFYI, when comparing v3.10-rc3 to v3.10-rc2[3], the summaries are:
  - build errors: +15/-10
  - build warnings: +158/-115

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.10-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6268/ (all 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6143/ (117 out of 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/6246/ (all 120 configs)


*** ERRORS ***

32 regressions:
  + arch/h8300/kernel/entry.S: Error: invalid operands:  => 204, 210, 307, 230, 218, 377, 358, 383, 247
  + arch/h8300/kernel/entry.S: Error: junk at end of line, first unrecognized character is `(':  => 159, 161, 165, 160, 167, 158, 163, 166, 162, 164, 195
  + arch/h8300/kernel/syscalls.S: Error: junk at end of line, first unrecognized character is `(':  => 127, 32, 276, 90, 206, 118, 71, 102, 331, 55, 84, 233, 259, 194, 57, 220, 316, 163, 89, 175, 31, 35, 208, 93, 292, 325, 29, 291, 199, 114, 226, 58, 211, 153, 101, 73, 76, 311, 62, 67, 241, 198, 139, 129, 327, 320, 280, 273, 236, 249, 218, 202, 168, 184, 135, 145, 49, 178, 24, 285, 140, 124, 104, 131, 181, 234, 314, 307, 154, 23, 96, 159, 326, 160, 47, 98, 335, 37, 43, 270, 195, 21, 288, 193, 119, 324, 180, 244, 162, 246, 240, 74, 334, 61, 230, 299, 115, 103, 201, 113, 152, 189, 295, 266, 91, 107, 87, 174, 77, 214, 221, 39, 64, 97, 41, 52, 312, 302, 229, 45, 260, 237, 309, 188, 68, 315, 116, 136, 144, 100, 300, 222, 25, 286, 120, 83, 305, 308, 254, 177, 217, 328, 239, 122, 143, 281, 269, 205, 158, 22, 42, 46, 235, 301, 6, 36, 213, 183, 94, 51, 317, 296, 265, 169, 132, 171, 200, 18, 125, 329, 44, 27, 161, 190, 272, 298, 95, 313, 20, 109, 231, 243, 151, 148, 287, 78, 294, 106, 275, 157, 65, 197, 203, 261, 138, 81, 137, 60, 321, 284, 86, 247, 204, 289, 165, 17, 186, 82, 110, 147, 333, 228, 323, 268, 69, 112, 319, 172, 191, 224, 187, 223, 282, 262, 79, 121, 212, 126, 238, 251, 253, 279, 176, 209, 216, 256, 117, 170, 33, 63, 80, 26, 227, 336, 99, 72, 179, 255, 264, 297, 182, 108, 277, 92, 232, 225, 330, 142, 207, 263, 48, 133, 290, 123, 149, 304, 50, 210, 258, 173, 56, 66, 19, 293, 54, 274, 306, 70, 322, 166, 88, 141, 30, 128, 252, 28, 310, 283, 134, 40, 75, 156, 303, 192, 250, 59, 215, 278, 150, 271, 130, 155, 53, 245, 267, 219, 318, 105, 257, 85, 185, 332, 248, 111, 146, 38, 34, 164, 196, 242
  + arch/h8300/lib/abs.S: Error: junk at end of line, first unrecognized character is `(':  => 12
  + arch/h8300/lib/memcpy.S: Error: junk at end of line, first unrecognized character is `(':  => 13
  + arch/h8300/lib/memset.S: Error: junk at end of line, first unrecognized character is `(':  => 13
  + arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: invalid operands:  => 68, 62
  + arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: junk at end of line, first unrecognized character is `(':  => 27, 25, 28, 26
  + drivers/usb/gadget/mv_u3d_core.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 70:2
  + drivers/usb/gadget/mv_u3d_core.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 72:2
  + drivers/usb/phy/phy-rcar-usb.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 83:4
  + drivers/usb/phy/phy-rcar-usb.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 75:3
  + error: "__sync_fetch_and_and_4" [drivers/staging/line6/line6usb.ko] undefined!:  => N/A
  + error: "__sync_fetch_and_or_4" [drivers/staging/line6/line6usb.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/i2c/busses/i2c-designware-pci.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/input/touchscreen/st1232.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/mfd/si476x-core.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/net/ethernet/marvell/mvmdio.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/staging/dwc2/dwc2.ko] undefined!:  => N/A
  + error: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!:  => N/A
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.mutex_lock_nested' defined in .sched.text section in kernel/built-in.o:  => (.text+0x1ffaf48)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.udelay' defined in .text section in arch/powerpc/kernel/built-in.o:  => (.text+0x1ff9e18), (.text+0x1ff9f90)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffab44), (.text+0x1ffaf0c)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa688), (.text+0x1ffa3a0)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffaac4), (.text+0x1ffab4c)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9a38)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+ae0:  => (.text+0x8de)
  + kernel/cpu/idle.c: error: implicit declaration of function 'check_pgt_cache' [-Werror=implicit-function-declaration]:  => 72:4
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'led_cdevs':  => 214:2, 278:2
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'leddev_list_lock':  => 213:2, 280:2, 277:2, 216:2
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'name':  => 74:16, 83:16, 101:19, 92:19, 237:16

23 improvements:
  - arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'inhibit_secondary_onlining' [-Werror=implicit-function-declaration]: 1855:2 => 
  - arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'uninhibit_secondary_onlining' [-Werror=implicit-function-declaration]: 1862:2 => 
  - drivers/usb/chipidea/core.c: error: implicit declaration of function 'ioread8' [-Werror=implicit-function-declaration]: 184:2 => 
  - drivers/usb/phy/rcar-phy.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]: 83:4 => 
  - drivers/usb/phy/rcar-phy.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]: 75:3 => 
  - error: "_spill_registers" [arch/xtensa/oprofile/oprofile.ko] undefined!: N/A => 
  - error: "common_exception_return" [arch/xtensa/oprofile/oprofile.ko] undefined!: N/A => 
  - error: "kernel_text_address" [arch/xtensa/oprofile/oprofile.ko] undefined!: N/A => 
  - error: hw.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._mcount' defined in .text section in arch/powerpc/kernel/entry_64.o: (.text+0x1ffe908), (.text+0x1ffe4d8), (.text+0x1ffea54), (.text+0x1ffd02c) => 
  - error: hw.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_31' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffea3c) => 
  - error: hw.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffc9fc) => 
  - error: hw.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffb86c) => 
  - error: hw.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_31' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffe8fc) => 
  - error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa884), (.text+0x1ffa17c) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+adc: (.text+0x8de) => 
  - lib/mpi/generic_mpih-mul1.c: error: inconsistent operand constraints in an 'asm': 50:3 => 
  - lib/mpi/generic_mpih-mul2.c: error: inconsistent operand constraints in an 'asm': 49:3 => 
  - lib/mpi/generic_mpih-mul3.c: error: inconsistent operand constraints in an 'asm': 49:3 => 
  - lib/mpi/mpih-div.c: error: inconsistent operand constraints in an 'asm': 205:6, 142:6 => 
  - net/mac80211/ieee80211_i.h: error: field 'trig' has incomplete type: 826:21 => 
  - net/mac80211/led.c: error: dereferencing pointer to incomplete type: 74:16, 83:16, 101:19, 92:19 => 
  - net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' : 90:36, 72:33, 99:36, 81:33 => 
  - sound/oss/soundcard.c: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function): 69:31 => 


*** WARNINGS ***

234 regressions:
  + ./scratch/kisskb/src/drivers/input/joystick/analog.c: warning: #warning Precise timer not defined for this architecture. [-Wcpp]:  => 171:2
  + .config: warning: override: SLOB changes choice state:  => 184
  + arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for HOTPLUG_PCI_ACPI:  => 35
  + arch/microblaze/include/asm/cacheflush.h: warning: 'addr' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 108:8
  + arch/microblaze/include/asm/io.h: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 126:26
  + arch/microblaze/kernel/cpu/cache.c: warning: 'temp' is used uninitialized in this function [-Wuninitialized]:  => 148:2
  + arch/sh/math-emu/math.c: warning: right shift count is negative [enabled by default]  CC      kernel/printk.o:  => 108:1
  + arch/tile/kernel/process.c: warning: unused variable 'tsk' [-Wunused-variable]:  => 572:22
  + arch/x86/kernel/cpu/perf_event.c: warning: 'reg_fail' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + arch/x86/kernel/cpu/perf_event.c: warning: 'val_fail' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 261:16
  + block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 65:2
  + block/blk-throttle.c: warning: value computed is not used [-Wunused-value]  LD [M]  sound/core/oss/snd-mixer-oss.o:  => 1030:2
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 1755:9, 1497:6
  + drivers/block/hd.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 332:2, 331:2, 330:2, 328:2, 327:2, 329:2, 333:2
  + drivers/block/paride/ppc6lnx.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 217:2, 146:2, 537:5, 147:2, 266:4, 201:2, 131:18, 142:3, 162:2, 145:2, 575:6, 430:15, 560:4, 235:4, 329:11, 144:2
  + drivers/block/rbd.c: warning: 'pages' may be used uninitialized in this function [-Wuninitialized]:  => 2230:10
  + drivers/block/rbd.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1152:12
  + drivers/dma/of-dma.c: warning: 'nbcells' may be used uninitialized in this function [-Wuninitialized]:  => 83:15
  + drivers/gpio/gpio-mcp23s08.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 622:10
  + drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 467:4
  + drivers/gpu/drm/i915/i915_gem_context.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 247:30
  + drivers/gpu/drm/i915/i915_gem_gtt.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]:  => 52:9
  + drivers/gpu/drm/i915/i915_gem_gtt.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 315:2
  + drivers/gpu/drm/i915/i915_sysfs.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]:  => 363:17
  + drivers/gpu/drm/i915/intel_ddi.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 79:1
  + drivers/gpu/drm/i915/intel_ddi.c: warning: unused variable 'intel_crtc' [-Wunused-variable]:  => 741:21
  + drivers/gpu/drm/i915/intel_display.c: warning: 'alignment' may be used uninitialized in this function [-Wuninitialized]:  => 2023:6
  + drivers/gpu/drm/i915/intel_display.c: warning: 'state_string' defined but not used [-Wunused-function]:  => 1046:20
  + drivers/gpu/drm/i915/intel_display.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 5411:1
  + drivers/gpu/drm/qxl/qxl_ioctl.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 154:4, 195:8
  + drivers/gpu/drm/radeon/ni.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 664:11
  + drivers/gpu/drm/radeon/ni.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 668:3
  + drivers/gpu/drm/radeon/ni.c: warning: 'me_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 644:2
  + drivers/gpu/drm/radeon/ni.c: warning: 'pfp_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 632:2
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 651:10
  + drivers/gpu/drm/radeon/ni.c: warning: 'rlc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 655:2
  + drivers/gpu/drm/radeon/r600.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 2213:10
  + drivers/gpu/drm/radeon/r600.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 2236:10
  + drivers/gpu/drm/radeon/r600_cp.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 353:10
  + drivers/gpu/drm/radeon/si.c: warning: 'chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1431:10
  + drivers/gpu/drm/radeon/si.c: warning: 'mc_req_size' may be used uninitialized in this function [-Wuninitialized]:  => 1435:2
  + drivers/gpu/drm/radeon/si.c: warning: 'rlc_chip_name' may be used uninitialized in this function [-Wuninitialized]:  => 1420:10
  + drivers/hwmon/sch56xx-common.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 148:2
  + drivers/hwmon/smsc47b397.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 121:2
  + drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in this function [-Wuninitialized]: 296:2 => 296:2, 135:2
  + drivers/iio/adc/exynos_adc.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 111:9
  + drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 79:25
  + drivers/infiniband/hw/ocrdma/ocrdma_main.c: warning: 'ocrdma_del_sgid' defined but not used [-Wunused-function]:  => 119:13
  + drivers/infiniband/ulp/srp/ib_srp.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]:  => 886:2
  + drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' defined but not used [-Wunused-function]:  => 210:13
  + drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' uses dynamic stack allocation [enabled by default]:  => 234:1
  + drivers/isdn/icn/icn.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 89:3
  + drivers/md/bcache/super.c: warning: (near initialization for 'bcache_ops.release') [enabled by default]:  => 653:2
  + drivers/md/bcache/super.c: warning: initialization from incompatible pointer type [enabled by default]:  => 653:2
  + drivers/md/bcache/sysfs.c: warning: '__bch_cache_show' uses dynamic stack allocation [enabled by default]:  => 730:1
  + drivers/media/dvb-frontends/af9033.c: warning: 'af9033_wr_reg_val_tab' uses dynamic stack allocation [enabled by default]:  => 188:1
  + drivers/media/rc/fintek-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 80:2, 54:2, 81:2, 55:8, 45:2, 87:2, 46:2
  + drivers/media/rc/nuvoton-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 52:2, 91:2, 45:2, 81:2, 92:2, 74:2, 46:2, 53:9, 75:2
  + drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 233:5 => 233:2, 233:5
  + drivers/mfd/wm8994-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 762:19
  + drivers/misc/altera-stapl/altera-lpt.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 40:9, 34:2
  + drivers/misc/hpilo.c: warning: 'devnum' may be used uninitialized in this function [-Wuninitialized]:  => 847:20
  + drivers/mmc/host/tmio_mmc_pio.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 798:19
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1448 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 53:2
  + drivers/mtd/sm_ftl.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 1094:2
  + drivers/net/ethernet/8390/wd.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 287:4, 294:4
  + drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:213) [-Wdeprecated-declarations]:  => 625:3
  + drivers/net/ethernet/chelsio/cxgb4/sge.c: warning: 'buf_size' may be used uninitialized in this function [-Wuninitialized]:  => 472:18, 499:17, 1824:11
  + drivers/net/ethernet/emulex/benet/be_main.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 2898:3
  + drivers/net/ethernet/intel/e1000e/ich8lan.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 898:4
  + drivers/net/ethernet/mellanox/mlx4/mcg.c: warning: 'hash' may be used uninitialized in this function [-Wuninitialized]:  => 620:9
  + drivers/net/ethernet/neterion/s2io.c: warning: 'ip' may be used uninitialized in this function [-Wuninitialized]:  => 8320:19
  + drivers/net/ethernet/neterion/s2io.c: warning: 'tcp' may be used uninitialized in this function [-Wuninitialized]:  => 8384:18
  + drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'val32' may be used uninitialized in this function [-Wuninitialized]:  => 4594:18
  + drivers/net/ethernet/sfc/filter.c: warning: 'data3' may be used uninitialized in this function [-Wuninitialized]:  => 531:2
  + drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast [enabled by default]  CC      fs/fat/nfs.o:  => 598:2
  + drivers/nubus/proc.c: warning: #warning Need to set some I/O handlers here [-Wcpp]:  => 64:2
  + drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16
  + drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 133:2
  + drivers/power/twl4030_charger.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 192:20
  + drivers/regulator/ab3100.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 650:4
  + drivers/regulator/s5m8767.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 211:29
  + drivers/rtc/rtc-sh.c: warning: 'sh_rtc_set_irq_wake' defined but not used [-Wunused-function]:  => 780:13
  + drivers/scsi/NCR5380.h: warning: 'NCR5380_write_info' declared 'static' but never defined [-Wunused-function]:  => 319:27
  + drivers/scsi/fcoe/fcoe.c: warning: 'ctlr' may be used uninitialized in this function [-Wuninitialized]:  => 2045:15
  + drivers/scsi/hpsa.c: warning: 'asc' may be used uninitialized in this function [-Wuninitialized]:  => 1264:13
  + drivers/scsi/hpsa.c: warning: 'ascq' may be used uninitialized in this function [-Wuninitialized]:  => 1264:13
  + drivers/scsi/hpsa.c: warning: 'sense_key' may be used uninitialized in this function [-Wuninitialized]:  => 1262:4
  + drivers/scsi/imm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 245:2, 301:3, 471:2, 339:15, 459:2, 303:3, 465:2, 461:2, 468:2, 492:2, 561:2, 484:2, 463:2
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]:  => 4899:11
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]:  => 4898:13
  + drivers/scsi/pm8001/pm8001_init.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 424:4
  + drivers/scsi/pm8001/pm80xx_hwi.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 891:3
  + drivers/scsi/ppa.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 244:3, 378:2, 256:15, 398:2, 438:2, 435:2
  + drivers/scsi/scsi_debug.c: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 1756:6 => 1756:6, 1756:3
  + drivers/spi/spi-pxa2xx.c: warning: return makes pointer from integer without a cast [enabled by default]:  => 1094:3
  + drivers/staging/android/sync.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 865:3
  + drivers/staging/comedi/drivers/ni_labpc.c: warning: unused variable 'dma_chan' [-Wunused-variable]:  => 1717:15
  + drivers/staging/speakup/kobjects.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 667:39
  + drivers/staging/vt6655/device_main.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 3254:1
  + drivers/staging/vt6655/iwctl.c: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 758:1
  + drivers/target/iscsi/iscsi_target.c: warning: 'iscsit_send_datain' uses dynamic stack allocation [enabled by default]:  => 2726:1
  + drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 612:18
  + drivers/tty/rocket_int.h: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 67:9, 45:2, 72:9, 53:2
  + drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_resume' defined but not used [-Wunused-function]:  => 326:12
  + drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_suspend' defined but not used [-Wunused-function]:  => 317:12
  + drivers/tty/serial/pch_uart.c: warning: 'wait_for_xmitr' defined but not used [-Wunused-function]:  => 1499:13
  + drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 266:6
  + drivers/usb/core/hcd-pci.c: warning: 'ehci_wait_for_companions' defined but not used [-Wunused-function]:  => 149:13
  + drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 213:51
  + drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used [-Wunused-variable]:  => 534:13
  + drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used [-Wunused-variable]:  => 535:13
  + drivers/video/aty/atyfb_base.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 437:11
  + drivers/video/ps3fb.c: warning: suggest parentheses around '+' inside '<<' [-Wparentheses]:  => 712:2
  + fs/btrfs/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]: 56:7 => 56:25, 56:7
  + fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 3823:6 => 3851:2, 3852:6
  + fs/btrfs/disk-io.c: warning: 'btrfs_check_super_csum' uses dynamic stack allocation [enabled by default]:  => 400:1
  + fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1387:23
  + fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1338:6 => 1350:6, 1202:6
  + fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1383:38
  + fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1388:18
  + fs/btrfs/qgroup.c: warning: 'seq' may be used uninitialized in this function [-Wuninitialized]:  => 1427:6
  + fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1263:21, 1153:28 => 1324:21, 1271:20, 1474:6
  + fs/cifs/connect.c: warning: 'ses' may be used uninitialized in this function [-Wuninitialized]:  => 3428:20
  + fs/cifs/connect.c: warning: 'tcon' may be used uninitialized in this function [-Wuninitialized]:  => 3426:17
  + fs/cifs/connect.c: warning: 'xid' may be used uninitialized in this function [-Wuninitialized]:  => 3430:3
  + fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in this function [-Wuninitialized]:  => 337:20
  + fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 625:1
  + fs/locks.c: warning: 'lock' may be used uninitialized in this function [-Wuninitialized]:  => 1663:17
  + fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 320:1
  + fs/mpage.c: warning: the frame size of 1140 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + fs/nfsd/export.c: warning: 'listsize' may be used uninitialized in this function [-Wuninitialized]:  => 449:48
  + fs/nfsd/export.c: warning: 'migrated' may be used uninitialized in this function [-Wuninitialized]:  => 431:18
  + fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + fs/omfs/file.c: warning: 'remain' may be used uninitialized in this function [-Wuninitialized]:  => 257:4
  + include/linux/err.h: warning: 'edid' may be used uninitialized in this function [-Wuninitialized]:  => 39:17
  + include/linux/of_net.h: warning: type qualifiers ignored on function return type:  => 16
  + include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + kernel/auditfilter.c: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]:  => 426:3
  + kernel/sched/core.c: warning: (near initialization for 'default_topology[0].mask') [enabled by default]:  => 6104:2
  + kernel/sched/core.c: warning: initialization from incompatible pointer type [enabled by default]:  => 6104:2
  + kernel/seccomp.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 100:17
  + kernel/time/ntp.c: warning: unused variable 'flags' [-Wunused-variable]:  => 877:16
  + lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 658:14
  + mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 735:15
  + mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 303:6
  + modpost: WARNING: modpost: Found 8 section mismatch(es).:  => N/A
  + net/bluetooth/hidp/core.c: warning: 'session' may be used uninitialized in this function [-Wuninitialized]:  => 1298:18
  + net/ceph/messenger.c: warning: 'new_piece' may be used uninitialized in this function [-Wuninitialized]:  => 1144:2
  + net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 218:2
  + net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + net/mac80211/tx.c: warning: 'chanctx_conf' may be used uninitialized in this function [-Wuninitialized]: 1828:27 => 1774:27, 1766:3
  + net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + net/rfkill/rfkill-regulator.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 43:20
  + net/rxrpc/ar-connection.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 587:16
  + net/sunrpc/auth_gss/svcauth_gss.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 459:31
  + sound/pci/pcxhr/pcxhr_core.c: warning: 'new_sample_count' may be used uninitialized in this function [-Wuninitialized]:  => 1192:4
  + warning: (ARM_GIC && ARM_VIC && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
  + warning: (DRM_RADEON && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD):  => N/A
  + warning: (PPC_MPC512x && PPC_PS3 && PPC_CELLEB && 440EPX) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_OHCI_HCD):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB && USB_OHCI_HCD):  => N/A
  + warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC):  => N/A
  + warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (HAVE_KVM):  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x10476): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.31898:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x1048a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.31898:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22de2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33090:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22de2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33093:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22e4e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33090:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22e4e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33093:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x1730c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x1734c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x51d4): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x51d4): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/powernv/built-in.o(.text+0x693c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: drivers/built-in.o(.text+0x32b1e2): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/built-in.o(.text+0x32b1f2): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/input/serio/hp_sdc.o(.data+0xc): Section mismatch in reference from the variable hp_sdc_driver to the function .init.text:hp_sdc_init_hppa():  => N/A
  + warning: drivers/net/ethernet/3com/3c509.o(.data+0x19c): Section mismatch in reference from the variable el3_eisa_driver to the function .init.text:el3_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/3com/3c59x.o(.data+0xd8): Section mismatch in reference from the variable vortex_eisa_driver to the function .init.text:vortex_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/dec/tulip/de4x5.o(.data+0xcc): Section mismatch in reference from the variable de4x5_eisa_driver to the function .init.text:de4x5_eisa_probe():  => N/A
  + warning: drivers/net/ethernet/hp/hp100.o(.data+0x74): Section mismatch in reference from the variable hp100_eisa_driver to the function .init.text:hp100_eisa_probe():  => N/A
  + warning: drivers/scsi/lasi700.o(.data+0x24): Section mismatch in reference from the variable lasi700_driver to the function .init.text:lasi700_probe():  => N/A
  + warning: drivers/scsi/sim710.o(.data+0x50): Section mismatch in reference from the variable sim710_eisa_driver to the function .init.text:sim710_eisa_probe():  => N/A
  + warning: drivers/tty/serial/8250/8250_gsc.o(.data+0x2c): Section mismatch in reference from the variable lasi_driver to the function .init.text:serial_init_chip():  => N/A
  + warning: drivers/tty/serial/8250/8250_gsc.o(.data+0x7c): Section mismatch in reference from the variable serial_driver to the function .init.text:serial_init_chip():  => N/A
  + warning: drivers/tty/serial/mux.o(.data+0x34): Section mismatch in reference from the variable builtin_serial_mux_driver to the function .init.text:mux_probe():  => N/A
  + warning: drivers/tty/serial/mux.o(.data+0x84): Section mismatch in reference from the variable serial_mux_driver to the function .init.text:mux_probe():  => N/A
  + warning: drivers/video/built-in.o(.text+0x29b6d6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: drivers/video/built-in.o(.text+0x29b6e6): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: mm/built-in.o(.meminit.text+0x11ac): Section mismatch in reference from the function .free_area_init_core.isra.38() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: mm/built-in.o(.meminit.text+0xeb4): Section mismatch in reference from the function .free_area_init_core.isra.58() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.data+0x3fa84): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fb24): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fc7c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fd80): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3fde0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3fe40): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3feac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40050): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.meminit.text+0x15bc): Section mismatch in reference from the function .free_area_init_core.isra.38() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.meminit.text+0xeb4): Section mismatch in reference from the function .free_area_init_core.isra.58() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x150ac76): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x150ac86): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x1ad488): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x1b15bc): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x1b21c): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x1b256): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.31898:  => N/A
  + warning: vmlinux.o(.text+0x1b26a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.31898:  => N/A
  + warning: vmlinux.o(.text+0x2eb40): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2eb82): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33090:  => N/A
  + warning: vmlinux.o(.text+0x2ebee): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33090:  => N/A
  + warning: vmlinux.o(.text+0x2ec60): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2eca2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33093:  => N/A
  + warning: vmlinux.o(.text+0x2ed0e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33093:  => N/A
  + warning: vmlinux.o(.text+0x37114): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x37234): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x3eec): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x43cb4): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0x4a2f): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x58110): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x5973c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x68530): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x69b50): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x9668): Section mismatch in reference from the function .start_secondary_prolog() to the function .cpuinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x967c): Section mismatch in reference from the function .start_secondary_resume() to the function .cpuinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x9a2ac): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0x9c36c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0xa4588): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xa6648): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A

164 improvements:
  - .config: warning: override: HIGHMEM4G changes choice state: 358 => 
  - arch/avr32/include/asm/param.h: warning: "HZ" redefined  CC [M]  net/bridge/br_notify.o: 6:1 => 
  - arch/avr32/include/asm/param.h: warning: "HZ" redefined: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning:   LD      drivers/mtd/onenand/built-in.o: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition  AS      arch/avr32/lib/__avr32_lsl64.o: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition  CC      lib/string.o: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definitionIn file included from /scratch/kisskb/src/include/uapi/linux/param.h:4,: 6:1 => 
  - arch/cris/include/arch-v10/arch/swab.h: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]: 16:2 => 
  - arch/cris/include/arch-v10/arch/swab.h: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]: 16:2 => 
  - arch/cris/include/asm/atomic.h: warning: 'cli' may be used uninitialized in this function [-Wuninitialized]: 83:4 => 
  - arch/s390/include/asm/uaccess.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]: 313:26 => 
  - arch/sh/include/uapi/asm/swab.h: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]: 14:2 => 
  - arch/sh/include/uapi/asm/swab.h: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]: 14:2 => 
  - arch/sh/kernel/cpu/sh4a/clock-sh7780.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11) [-Wdeprecated-declarations]/scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c: In function 'cpg_clk_init':: 110:2 => 
  - arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]: 211:26 => 
  - arch/x86/kernel/quirks.c: warning: 'd' may be used uninitialized in this function [-Wuninitialized]: 364:4 => 
  - arch/x86/kernel/quirks.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 407:21 => 
  - drivers/ata/pata_pdc2027x.c: warning: 'pdc2027x_reinit_one' declared 'static' but never defined [-Wunused-function]: 66:12 => 
  - drivers/dma/timb_dma.c: warning: 'td_remove' defined but not used [-Wunused-function]: 801:12 => 
  - drivers/gpu/drm/gma500/psb_irq.c: warning: control reaches end of non-void function [-Wreturn-type]: 47:1, 83:1, 59:1 => 
  - drivers/gpu/drm/i915/intel_ddi.c: warning: 'port' may be used uninitialized in this function [-Wuninitialized]: 1178:2 => 
  - drivers/input/misc/ad714x-i2c.c: warning: 'ad714x_i2c_resume' defined but not used [-Wunused-function]: 22:12 => 
  - drivers/input/misc/ad714x-i2c.c: warning: 'ad714x_i2c_suspend' defined but not used [-Wunused-function]: 17:12 => 
  - drivers/input/misc/ad714x-spi.c: warning: 'ad714x_spi_resume' defined but not used [-Wunused-function]: 25:12 => 
  - drivers/input/misc/ad714x-spi.c: warning: 'ad714x_spi_suspend' defined but not used [-Wunused-function]: 20:12 => 
  - drivers/input/misc/adxl34x-i2c.c: warning: 'adxl34x_i2c_resume' defined but not used [-Wunused-function]: 119:12 => 
  - drivers/input/misc/adxl34x-i2c.c: warning: 'adxl34x_i2c_suspend' defined but not used [-Wunused-function]: 109:12 => 
  - drivers/input/misc/adxl34x-spi.c: warning: 'adxl34x_spi_resume' defined but not used [-Wunused-function]: 108:12 => 
  - drivers/input/misc/adxl34x-spi.c: warning: 'adxl34x_spi_suspend' defined but not used [-Wunused-function]: 98:12 => 
  - drivers/input/touchscreen/cy8ctmg110_ts.c: warning: 'cy8ctmg110_resume' defined but not used [-Wunused-function]: 309:12 => 
  - drivers/input/touchscreen/cy8ctmg110_ts.c: warning: 'cy8ctmg110_suspend' defined but not used [-Wunused-function]: 295:12 => 
  - drivers/isdn/sc/init.c: warning: return from incompatible pointer type [enabled by default]: 36:1, 37:1 => 
  - drivers/leds/leds-bd2802.c: warning: 'bd2802_resume' defined but not used [-Wunused-function]: 776:12 => 
  - drivers/leds/leds-bd2802.c: warning: 'bd2802_suspend' defined but not used [-Wunused-function]: 766:12 => 
  - drivers/media/pci/cx25821/cx25821-audio-upstream.c: warning: 'cx25821_get_audio_data.isra.4' uses dynamic stack allocation [enabled by default]: 337:1 => 
  - drivers/media/pci/cx25821/cx25821-audio-upstream.c: warning: 'cx25821_openfile_audio.isra.2' uses dynamic stack allocation [enabled by default]: 433:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: warning: 'cx25821_get_frame_ch2.isra.6' uses dynamic stack allocation [enabled by default]: 348:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: warning: 'cx25821_openfile_ch2.isra.4' uses dynamic stack allocation [enabled by default]: 445:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream.c: warning: 'cx25821_get_frame.isra.6' uses dynamic stack allocation [enabled by default]: 392:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream.c: warning: 'cx25821_openfile.isra.4' uses dynamic stack allocation [enabled by default]: 489:1 => 
  - drivers/mfd/syscon.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' [-Wformat]: 136:2 => 
  - drivers/mfd/syscon.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]: 136:2 => 
  - drivers/mfd/wm8994-core.c: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]: 595:7 => 
  - drivers/misc/apds990x.c: warning: 'apds990x_resume' defined but not used [-Wunused-function]: 1217:12 => 
  - drivers/misc/apds990x.c: warning: 'apds990x_suspend' defined but not used [-Wunused-function]: 1208:12 => 
  - drivers/misc/bh1770glc.c: warning: 'bh1770_resume' defined but not used [-Wunused-function]: 1324:12 => 
  - drivers/misc/bh1770glc.c: warning: 'bh1770_suspend' defined but not used [-Wunused-function]: 1314:12 => 
  - drivers/misc/bh1780gli.c: warning: 'bh1780_resume' defined but not used [-Wunused-function]: 222:12 => 
  - drivers/misc/bh1780gli.c: warning: 'bh1780_suspend' defined but not used [-Wunused-function]: 200:12 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1444 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 420:1 => 
  - drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20, 127:2 => 
  - drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201) [-Wdeprecated-declarations]: 625:3 => 
  - drivers/net/ethernet/smsc/smc91x.c: warning: passing argument 2 of 'outw' makes integer from pointer without a cast [enabled by default]: 390:2, 1668:2, 1265:4, 349:2, 389:2, 1250:4, 762:2, 1024:3, 1672:2, 1132:2, 838:2, 1671:2, 270:2, 597:2, 490:3, 271:2, 1025:3, 1800:2, 296:2, 396:2, 1173:2, 1648:2, 621:2, 1643:2, 493:3, 1827:2, 1175:2, 581:2, 1200:2, 1074:2, 939:2, 1640:2, 1799:2, 313:2, 821:2, 328:2, 1936:2, 1646:2, 1669:2, 805:3, 380:2, 309:2, 761:2, 753:2, 1267:4, 350:2, 1641:2, 1911:2, 1344:2, 1898:2, 1457:3, 851:2, 357:2, 833:2, 381:2, 860:2, 797:2, 1806:2, 1286:4, 329:2, 725:2, 278:2, 940:2, 310:2, 1199:2, 803:3, 345:2, 728:2, 1295:2, 783:3, 1296:2, 1455:2, 1644:2, 1289:4, 471:4, 582:2, 391:2, 1458:3, 311:2, 1227:2, 395:2, 600:2, 1674:2, 1460:2, 1682:2, 1654:2, 441:3, 1280:4, 1201:2, 785:3, 1885:2, 669:2, 356:2, 325:2, 757:2, 1347:2, 679:4, 594:2, 691:3, 418:2, 865:2, 614:2, 1683:2, 346:2, 253:2, 760:2, 1655:2, 1454:2, 254:2, 938:2, 1075:2, 347:2, 1197:2 => 1670:2, 1642:2, 390:2, 1265:4, 1130:2, 349:2, 389:2, 1804:2, 1909:2, 1666:2, 723:2, 1639:2, 1287:4, 1072:2, 1293:2, 1672:2, 795:2, 759:2, 836:2, 270:2, 1452:2, 271:2, 937:2, 1022:3, 592:2, 296:2, 726:2, 689:3, 396:2, 488:3, 1278:4, 1173:2, 1652:2, 677:4, 1294:2, 469:4, 936:2, 758:2, 667:2, 313:2, 858:2, 328:2, 1646:2, 1669:2, 380:2, 1825:2, 309:2, 1883:2, 350:2, 1641:2, 595:2, 1198:2, 357:2, 1896:2, 1455:3, 1934:2, 381:2, 1073:2, 1653:2, 329:2, 579:2, 278:2, 310:2, 1199:2, 619:2, 803:3, 345:2, 1681:2, 783:3, 849:2, 1644:2, 1456:3, 831:2, 755:2, 391:2, 1680:2, 311:2, 1023:3, 395:2, 1284:4, 1171:2, 1798:2, 580:2, 441:3, 1638:2, 1195:2, 1667:2, 801:3, 863:2, 1345:2, 1225:2, 1797:2, 1263:4, 819:2, 1453:2, 356:2, 325:2, 612:2, 1248:4, 491:3, 1458:2, 418:2, 781:3, 346:2, 253:2, 760:2, 1342:2, 254:2, 938:2, 347:2, 751:2, 1197:2
  - drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_resume' defined but not used [-Wunused-function]: 773:12 => 
  - drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_suspend' defined but not used [-Wunused-function]: 758:12 => 
  - drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_resume' defined but not used [-Wunused-function]: 685:12 => 
  - drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_suspend' defined but not used [-Wunused-function]: 670:12 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'desc' may be used uninitialized in this function [-Wuninitialized]: 1145:9 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'desc2' may be used uninitialized in this function [-Wuninitialized]: 1143:9 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_resume' defined but not used [-Wunused-function]: 205:12 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_suspend' defined but not used [-Wunused-function]: 170:12 => 
  - drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 693:12 => 
  - drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 724:13 => 
  - drivers/rtc/rtc-88pm80x.c: warning: 'pm80x_rtc_resume' defined but not used [-Wunused-function]: 243:12 => 
  - drivers/rtc/rtc-88pm80x.c: warning: 'pm80x_rtc_suspend' defined but not used [-Wunused-function]: 238:12 => 
  - drivers/rtc/rtc-ds1374.c: warning: 'ds1374_resume' defined but not used [-Wunused-function]: 422:12 => 
  - drivers/rtc/rtc-ds1374.c: warning: 'ds1374_suspend' defined but not used [-Wunused-function]: 413:12 => 
  - drivers/scsi/mvsas/mv_sas.c: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]: 1165:39, 1162:34 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_resume' defined but not used [-Wunused-function]: 1328:12 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_suspend' defined but not used [-Wunused-function]: 1313:12 => 
  - drivers/ssb/driver_mipscore.c: warning: unused variable 'irq_name' [-Wunused-variable]: 178:21 => 
  - drivers/staging/slicoss/slicoss.c: warning: operation on 'rspq->pageindex' may be undefined [-Wsequence-point]: 1418:19 => 
  - drivers/staging/vt6655/iwctl.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 787:1 => 
  - drivers/staging/zcache/zcache-main.c: warning: 'cli' may be used uninitialized in this function [-Wuninitialized]: 1598:13, 1598:3 => 
  - drivers/target/iscsi/iscsi_target.c: warning: 'iscsit_send_data_in' uses dynamic stack allocation [enabled by default]: 2596:1 => 
  - drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2274:7 => 
  - drivers/tty/pty.c: warning: 'pty_unix98_shutdown' defined but not used [-Wunused-function]: 409:13 => 
  - drivers/tty/rocket.c: warning: 'rmSpeakerReset' defined but not used [-Wunused-function]: 3140:13 => 
  - drivers/tty/rocket.c: warning: 'sPCIInitController' defined but not used [-Wunused-function]: 2599:12 => 
  - drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1712:2, 1714:18, 1717:18 => 1712:2, 1717:18
  - drivers/usb/host/ehci-q.c: warning: 'unlink_empty_async_suspended' defined but not used [-Wunused-function]: 1320:13 => 
  - drivers/usb/musb/musb_core.c: warning: unused variable 'ctrl_base' [-Wunused-variable]: 2036:16 => 
  - drivers/video/aty/aty128fb.c: warning: 'backlight' defined but not used [-Wunused-variable]: 363:12 => 
  - drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 622:11, 566:10 => 
  - drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 807:11 => 
  - drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_resume' defined but not used [-Wunused-function]: 135:12 => 
  - drivers/video/backlight/platform_lcd.c: warning: 'platform_lcd_suspend' defined but not used [-Wunused-function]: 125:12 => 
  - drivers/video/backlight/pwm_bl.c: warning: 'pwm_backlight_resume' defined but not used [-Wunused-function]: 292:12 => 
  - drivers/video/backlight/pwm_bl.c: warning: 'pwm_backlight_suspend' defined but not used [-Wunused-function]: 278:12 => 
  - drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]: 64:2 => 
  - drivers/video/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]: 65:2 => 
  - drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]: 4131:13 => 
  - drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]: 1634:4 => 
  - drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]: 1635:4 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_freeze' defined but not used [-Wunused-function]: 769:12 => 
  - drivers/virtio/virtio_pci.c: warning: 'virtio_pci_restore' defined but not used [-Wunused-function]: 789:12 => 
  - fs/bio-integrity.c: warning: control reaches end of non-void function [-Wreturn-type]: 62:1 => 
  - fs/btrfs/ctree.h: warning: array subscript is above array bounds [-Warray-bounds]: 2771:25 => 
  - fs/btrfs/file-item.c: warning: 'len' may be used uninitialized in this function [-Wuninitialized]: 173:2 => 
  - fs/btrfs/tree-log.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 3309:40 => 
  - include/linux/err.h: warning: 'dst_di' may be used uninitialized in this function [-Wuninitialized]: 39:17 => 
  - include/linux/thermal.h: warning: 'thermal_generate_netlink_event' defined but not used [-Wunused-function]: 254:12 => 
  - kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]: 334:22 => 
  - kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]: 270:13 => 
  - kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]: 247:13 => 
  - kernel/seccomp.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 453:15 => 
  - lib/mpi/longlong.h: warning: function declaration isn't a prototype [-Wstrict-prototypes]: 346:1 => 
  - mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 5618:35, 5518:19, 5636:32, 5515:16 => 5758:32, 5740:35, 5640:19
  - mm/slab_common.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 303:6 => 
  - modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 13 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 6 section mismatch(es).: N/A => 
  - sound/oss/dmabuf.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 139:2 => 
  - sound/oss/soundcard.c: warning: 'dma_alloc_map' defined but not used [-Wunused-variable]: 69:17 => 
  - sound/soc/codecs/adau1373.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 940:3 => 
  - warning: (DRM_RADEON && DRM_I915 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP && XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON || PMC_MSP || SPARC_LEON || MIPS_SEAD3)): N/A => 
  - warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD): N/A => 
  - warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD): N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x147a2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32034: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x147ba): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32034: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x2308a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32808: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x2308a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32811: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x230f6): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32808: N/A => 
  - warning: arch/powerpc/kernel/built-in.o(.text+0x230f6): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32811: N/A => 
  - warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x292): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x2a2): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x396): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: arch/powerpc/mm/built-in.o(.cpuinit.text+0x39e): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: drivers/built-in.o(.text+0x3276aa): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/built-in.o(.text+0x3276ba): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/video/built-in.o(.text+0x2996de): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: drivers/video/built-in.o(.text+0x2996ee): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: mm/built-in.o(.meminit.text+0x114c): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: mm/built-in.o(.meminit.text+0xdb8): Section mismatch in reference from the function .free_area_init_core.isra.60.constprop.61() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.cpuinit.text+0x278a): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: vmlinux.o(.cpuinit.text+0x279a): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: vmlinux.o(.cpuinit.text+0x288e): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: vmlinux.o(.cpuinit.text+0x2896): Section mismatch in reference from the function .fake_numa_create_new_node() to the variable .init.data:cmdline: N/A => 
  - warning: vmlinux.o(.meminit.text+0x15b4): Section mismatch in reference from the function .free_area_init_core.isra.37() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.meminit.text+0xdb8): Section mismatch in reference from the function .free_area_init_core.isra.60.constprop.61() to the function .init.text:.set_pageblock_order(): N/A => 
  - warning: vmlinux.o(.text+0x14ea6c): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.text+0x150a792): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: vmlinux.o(.text+0x150a7a2): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix: N/A => 
  - warning: vmlinux.o(.text+0x152a74): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus(): N/A => 
  - warning: vmlinux.o(.text+0x1f574): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x1f5c2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32034: N/A => 
  - warning: vmlinux.o(.text+0x1f5da): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32034: N/A => 
  - warning: vmlinux.o(.text+0x2ede8): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2ee2a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32808: N/A => 
  - warning: vmlinux.o(.text+0x2ee96): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32808: N/A => 
  - warning: vmlinux.o(.text+0x2ef08): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary(): N/A => 
  - warning: vmlinux.o(.text+0x2ef4a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32811: N/A => 
  - warning: vmlinux.o(.text+0x2efb6): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.32811: N/A => 
  - warning: vmlinux.o(.text+0x37244): Section mismatch in reference from the function .kexec_prepare_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x3c74): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x4677): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem(): N/A => 
  - warning: vmlinux.o(.text+0x57fe4): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x59638): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0x61380): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xa1784): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xa4564): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
