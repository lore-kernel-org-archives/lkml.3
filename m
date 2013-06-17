Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3FQTPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:15:34 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33437 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3FQTP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:15:29 -0400
Date: Mon, 17 Jun 2013 21:15:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.10-rc6
Message-ID: <alpine.DEB.2.00.1306172114580.17108@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.10-rc6[1] compared to v3.9[2].

Summarized:
  - build errors: +37/-37
  - build warnings: +159/-428

JFYI, when comparing v3.10-rc6 to v3.10-rc5[3], the summaries are:
  - build errors: +16/-36
  - build warnings: +71/-393

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.10-rc6.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6325/ (86 out of 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6143/ (117 out of 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/6308/ (all 120 configs)


*** ERRORS ***

37 regressions:
  + arch/h8300/kernel/entry.S: Error: invalid operands:  => 204, 210, 307, 230, 218, 377, 358, 383, 247
  + arch/h8300/kernel/entry.S: Error: junk at end of line, first unrecognized character is `(':  => 159, 161, 165, 160, 167, 158, 163, 166, 162, 164, 195
  + arch/h8300/kernel/syscalls.S: Error: junk at end of line, first unrecognized character is `(':  => 127, 32, 276, 90, 206, 118, 71, 102, 331, 55, 84, 233, 259, 194, 57, 220, 316, 163, 89, 175, 31, 35, 208, 93, 292, 325, 29, 291, 199, 114, 226, 58, 211, 153, 101, 73, 76, 311, 62, 67, 241, 198, 139, 129, 327, 320, 280, 273, 236, 249, 218, 202, 168, 184, 135, 145, 49, 178, 24, 285, 140, 124, 104, 131, 181, 234, 314, 307, 154, 23, 96, 159, 326, 160, 47, 98, 335, 37, 43, 270, 195, 21, 288, 193, 119, 324, 180, 244, 162, 246, 240, 74, 334, 61, 230, 299, 115, 103, 201, 113, 152, 189, 295, 266, 91, 107, 87, 174, 77, 214, 221, 39, 64, 97, 41, 52, 312, 302, 229, 45, 260, 237, 309, 188, 68, 315, 116, 136, 144, 100, 300, 222, 25, 286, 120, 83, 305, 308, 254, 177, 217, 328, 239, 122, 143, 281, 269, 205, 158, 22, 42, 46, 235, 301, 6, 36, 213, 183, 94, 51, 317, 296, 265, 169, 132, 171, 200, 18, 125, 329, 44, 27, 161, 190, 272, 298, 95, 313, 20, 109, 231, 243, 151, 148, 287, 78, 294, 106, 275, 157, 65, 197, 203, 261, 138, 81, 137, 60, 321, 284, 86, 247, 204, 289, 165, 17, 186, 82, 110, 147, 333, 228, 323, 268, 69, 112, 319, 172, 191, 224, 187, 223, 282, 262, 79, 121, 212, 126, 238, 251, 253, 279, 176, 209, 216, 256, 117, 170, 33, 63, 80, 26, 227, 336, 99, 72, 179, 255, 264, 297, 182, 108, 277, 92, 232, 225, 330, 142, 207, 263, 167, 48, 133, 290, 123, 149, 304, 50, 210, 258, 173, 56, 66, 19, 293, 54, 274, 306, 70, 322, 166, 88, 141, 30, 128, 252, 28, 310, 283, 134, 40, 75, 156, 303, 192, 250, 59, 215, 278, 150, 271, 130, 155, 53, 245, 267, 219, 318, 105, 257, 85, 185, 332, 248, 111, 146, 38, 34, 164, 196, 242
  + arch/h8300/lib/abs.S: Error: junk at end of line, first unrecognized character is `(':  => 12
  + arch/h8300/lib/memcpy.S: Error: junk at end of line, first unrecognized character is `(':  => 13
  + arch/h8300/lib/memset.S: Error: junk at end of line, first unrecognized character is `(':  => 13
  + arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: invalid operands:  => 68, 62
  + arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: junk at end of line, first unrecognized character is `(':  => 27, 25, 28, 26
  + arch/mn10300/include/asm/irqflags.h: error: implicit declaration of function 'raw_smp_processor_id' [-Werror=implicit-function-declaration]:  => 71:2
  + arch/powerpc/include/asm/mmu-hash64.h: error: control reaches end of non-void function [-Werror=return-type]:  => 180:1
  + arch/powerpc/kvm/book3s_hv.c: error: 'vcpus_to_update[need_vpa_update]' may be used uninitialized in this function [-Werror=uninitialized]:  => 1187:22
  + arch/powerpc/mm/hash_native_64.c: error: 'a_size' may be used uninitialized in this function [-Werror=uninitialized]:  => 530:10
  + arch/powerpc/platforms/cell/beat_iommu.c: error: 'dma_base' may be used uninitialized in this function [-Werror=uninitialized]:  => 69:11
  + arch/powerpc/platforms/cell/beat_iommu.c: error: 'dma_size' may be used uninitialized in this function [-Werror=uninitialized]:  => 68:2
  + arch/powerpc/platforms/cell/beat_iommu.c: error: 'io_page_size' may be used uninitialized in this function [-Werror=uninitialized]:  => 68:54
  + arch/powerpc/platforms/cell/beat_wrapper.h: error: 'io_space_id' may be used uninitialized in this function [-Werror=uninitialized]:  => 249:2
  + arch/powerpc/platforms/cell/beat_wrapper.h: error: 'ioid' may be used uninitialized in this function [-Werror=uninitialized]:  => 249:2
  + drivers/usb/gadget/mv_u3d_core.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 70:2
  + drivers/usb/gadget/mv_u3d_core.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 72:2
  + drivers/usb/phy/phy-rcar-usb.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 83:4
  + drivers/usb/phy/phy-rcar-usb.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 75:3
  + error: "__sync_fetch_and_and_4" [drivers/staging/line6/line6usb.ko] undefined!:  => N/A
  + error: "__sync_fetch_and_or_4" [drivers/staging/line6/line6usb.ko] undefined!:  => N/A
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa684)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffaf80)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa4fc)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffaa34)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffb14c)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffaa2c), (.text+0x1ffa89c)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_28' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa68c), (.text+0x1ffa8a4)
  + error: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9e8c)
  + include/linux/smp.h: error: implicit declaration of function 'local_irq_restore' [-Werror=implicit-function-declaration]:  => 150:2
  + include/linux/smp.h: error: implicit declaration of function 'local_irq_save' [-Werror=implicit-function-declaration]:  => 148:2
  + kernel/cpu/idle.c: error: implicit declaration of function 'check_pgt_cache' [-Werror=implicit-function-declaration]:  => 72:4
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'led_cdevs':  => 214:2, 278:2
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'leddev_list_lock':  => 213:2, 280:2, 277:2, 216:2
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'name':  => 74:16, 83:16, 101:19, 92:19, 237:16

37 improvements:
  - arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'inhibit_secondary_onlining' [-Werror=implicit-function-declaration]: 1855:2 => 
  - arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'uninhibit_secondary_onlining' [-Werror=implicit-function-declaration]: 1862:2 => 
  - arch/um/drivers/cow_user.c: error: implicit declaration of function 'be32toh': 303 => 
  - arch/um/drivers/cow_user.c: error: implicit declaration of function 'be64toh': 330 => 
  - arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe32': 216 => 
  - arch/um/drivers/cow_user.c: error: implicit declaration of function 'htobe64': 249 => 
  - arch/um/os-Linux/skas/process.c: error: 'PTRACE_GETSIGINFO' undeclared (first use in this function): 412 => 
  - arch/um/os-Linux/skas/process.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 560, 321 => 
  - arch/um/os-Linux/skas/process.c: error: (Each undeclared identifier is reported only once: 321 => 
  - arch/um/os-Linux/skas/process.c: error: for each function it appears in.): 321 => 
  - arch/um/os-Linux/start_up.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function): 246, 304 => 
  - arch/um/os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function): 303, 245 => 
  - arch/um/os-Linux/start_up.c: error: (Each undeclared identifier is reported only once: 245 => 
  - arch/um/os-Linux/start_up.c: error: for each function it appears in.): 245 => 
  - drivers/net/ethernet/3com/3c59x.c: error: implicit declaration of function 'pci_iomap' [-Werror=implicit-function-declaration]: 1026:2 => 
  - drivers/net/ethernet/3com/3c59x.c: error: implicit declaration of function 'pci_iounmap' [-Werror=implicit-function-declaration]: 1038:3 => 
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

159 regressions:
  + .config: warning: override: SPARSEMEM_MANUAL changes choice state:  => 305
  + .config: warning: override: TINY_PREEMPT_RCU changes choice state:  => 132
  + arch/powerpc/include/asm/lv1call.h: warning: 'counter0415_mask' may be used uninitialized in this function [-Wuninitialized]:  => 345:1
  + arch/powerpc/include/asm/lv1call.h: warning: 'counter2637_mask' may be used uninitialized in this function [-Wuninitialized]:  => 345:1
  + arch/tile/kernel/process.c: warning: unused variable 'tsk' [-Wunused-variable]:  => 572:22
  + block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 65:2
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 1755:9, 1497:6
  + drivers/block/hd.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 332:2, 331:2, 330:2, 328:2, 327:2, 329:2, 333:2
  + drivers/block/paride/ppc6lnx.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 217:2, 146:2, 537:5, 147:2, 266:4, 201:2, 131:18, 142:3, 162:2, 145:2, 575:6, 430:15, 560:4, 235:4, 329:11, 144:2
  + drivers/block/rbd.c: warning: 'pages' may be used uninitialized in this function [-Wuninitialized]:  => 2231:10
  + drivers/block/rbd.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1153:12
  + drivers/gpio/gpio-mcp23s08.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 622:10
  + drivers/hwmon/sch56xx-common.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 148:2
  + drivers/hwmon/smsc47b397.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 121:2
  + drivers/iio/adc/exynos_adc.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 111:9
  + drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 79:25
  + drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' defined but not used [-Wunused-function]:  => 210:13
  + drivers/isdn/icn/icn.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 89:3
  + drivers/media/firewire/firedtv-avc.c: warning: 'pos' may be used uninitialized in this function [-Wuninitialized]:  => 608:26
  + drivers/media/rc/fintek-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 80:2, 54:2, 81:2, 55:8, 45:2, 87:2, 46:2
  + drivers/media/rc/nuvoton-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 52:2, 91:2, 45:2, 81:2, 92:2, 74:2, 46:2, 53:9, 75:2
  + drivers/message/fusion/mptbase.c: warning: 'seq_mpt_print_ioc_summary' defined but not used [-Wunused-function]:  => 6884:13
  + drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 233:5 => 233:2, 233:5
  + drivers/mfd/wm8994-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 762:19
  + drivers/misc/altera-stapl/altera-lpt.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 40:9, 34:2
  + drivers/misc/hpilo.c: warning: 'devnum' may be used uninitialized in this function [-Wuninitialized]:  => 847:20
  + drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in this function [-Wuninitialized]: 384:2 => 384:2, 384:16
  + drivers/mmc/host/tmio_mmc_pio.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 798:19
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 858:1
  + drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1964 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1797:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1448 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1536 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1816 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 975:1
  + drivers/mtd/chips/jedec_probe.c: warning: the frame size of 1052 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 2242:1
  + drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 53:2
  + drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + drivers/net/ethernet/8390/wd.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 287:4, 294:4
  + drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:213) [-Wdeprecated-declarations]:  => 625:3
  + drivers/net/ethernet/emulex/benet/be_main.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 2849:2
  + drivers/net/ethernet/emulex/benet/be_main.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 2591:46
  + drivers/net/ethernet/intel/e1000e/ich8lan.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 898:4
  + drivers/net/ethernet/mellanox/mlx4/mcg.c: warning: 'hash' may be used uninitialized in this function [-Wuninitialized]:  => 620:9
  + drivers/nubus/proc.c: warning: #warning Need to set some I/O handlers here [-Wcpp]:  => 64:2
  + drivers/power/twl4030_charger.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 192:20
  + drivers/regulator/ab3100.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 650:4
  + drivers/rtc/rtc-sh.c: warning: 'sh_rtc_set_irq_wake' defined but not used [-Wunused-function]:  => 780:13
  + drivers/scsi/NCR5380.h: warning: 'NCR5380_write_info' declared 'static' but never defined [-Wunused-function]:  => 319:27
  + drivers/scsi/fcoe/fcoe.c: warning: 'ctlr' may be used uninitialized in this function [-Wuninitialized]:  => 2045:15
  + drivers/scsi/hpsa.c: warning: 'asc' may be used uninitialized in this function [-Wuninitialized]:  => 1264:13
  + drivers/scsi/hpsa.c: warning: 'ascq' may be used uninitialized in this function [-Wuninitialized]:  => 1254:5
  + drivers/scsi/hpsa.c: warning: 'sense_key' may be used uninitialized in this function [-Wuninitialized]:  => 1262:4
  + drivers/scsi/imm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 245:2, 301:3, 471:2, 339:15, 459:2, 303:3, 465:2, 461:2, 468:2, 492:2, 561:2, 484:2, 463:2
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'cmd' may be used uninitialized in this function [-Wuninitialized]:  => 4899:11
  + drivers/scsi/lpfc/lpfc_els.c: warning: 'length' may be used uninitialized in this function [-Wuninitialized]:  => 4898:13
  + drivers/scsi/lpfc/lpfc_sli.c: warning: 'ha_copy' may be used uninitialized in this function [-Wuninitialized]:  => 10228:2
  + drivers/scsi/pm8001/pm8001_init.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 424:4
  + drivers/scsi/pm8001/pm80xx_hwi.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 729:6
  + drivers/scsi/ppa.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 244:3, 378:2, 256:15, 398:2, 438:2, 435:2
  + drivers/scsi/scsi_debug.c: warning: 'csum' may be used uninitialized in this function [-Wuninitialized]: 1756:6 => 1756:6, 1756:3
  + drivers/staging/android/sync.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 865:3
  + drivers/staging/comedi/drivers/ni_labpc.c: warning: unused variable 'dma_chan' [-Wunused-variable]:  => 1717:15
  + drivers/staging/speakup/kobjects.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 667:39
  + drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 612:18
  + drivers/tty/rocket_int.h: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 67:9, 45:2, 72:9, 53:2
  + drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_resume' defined but not used [-Wunused-function]:  => 326:12
  + drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_suspend' defined but not used [-Wunused-function]:  => 317:12
  + drivers/tty/serial/pch_uart.c: warning: 'wait_for_xmitr' defined but not used [-Wunused-function]:  => 1499:13
  + drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 342:9
  + drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used [-Wunused-variable]:  => 534:13
  + drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used [-Wunused-variable]:  => 535:13
  + drivers/video/aty/atyfb_base.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 437:11
  + fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 3823:6 => 3851:2, 3852:6
  + fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1387:23
  + fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1338:6 => 1350:6, 1202:6
  + fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1383:38
  + fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1388:18
  + fs/btrfs/qgroup.c: warning: 'seq' may be used uninitialized in this function [-Wuninitialized]:  => 1427:6
  + fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 320:1
  + fs/mpage.c: warning: the frame size of 1140 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + fs/mpage.c: warning: the frame size of 1148 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + include/linux/rculist.h: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 39:2
  + ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 1767:26
  + kernel/auditfilter.c: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]:  => 426:3
  + kernel/sched/core.c: warning: (near initialization for 'default_topology[0].mask') [enabled by default]:  => 6104:2
  + kernel/sched/core.c: warning: initialization from incompatible pointer type [enabled by default]:  => 6104:2
  + kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]:  => 2558:8
  + lib/kstrtox.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]  CC      lib/string.o:  => 346:1
  + mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 303:6
  + mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]:  => 1988:6
  + modpost: WARNING: modpost: Found 8 section mismatch(es).:  => N/A
  + net/bluetooth/hidp/core.c: warning: 'session' may be used uninitialized in this function [-Wuninitialized]:  => 1298:18
  + net/ceph/messenger.c: warning: 'new_piece' may be used uninitialized in this function [-Wuninitialized]:  => 1144:2
  + net/rfkill/rfkill-regulator.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 43:20
  + net/sched/sch_htb.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 421:4
  + sound/pci/pcxhr/pcxhr_core.c: warning: 'new_sample_count' may be used uninitialized in this function [-Wuninitialized]:  => 1192:4
  + sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3214:6
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
  + warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD):  => N/A
  + warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS):  => N/A
  + warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: (PPC_MPC512x && PPC_PS3 && PPC_CELLEB && 440EPX) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_OHCI_HCD):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet direct dependencies (USB_SUPPORT && USB && USB_OHCI_HCD):  => N/A
  + warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC):  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22fb2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33095:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22fb2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33098:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x2301e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33095:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x2301e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33098:  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x1730c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: arch/powerpc/platforms/built-in.o(.text+0x1734c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
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
  + warning: mm/built-in.o(.meminit.text+0x11c8): Section mismatch in reference from the function .free_area_init_core.isra.67.constprop.68() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.data+0x3fa84): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fb24): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fc7c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fd80): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3fde0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3fe40): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3feac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40050): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.meminit.text+0x15bc): Section mismatch in reference from the function .free_area_init_core.isra.38() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x150d47a): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x150d48a): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x2ec90): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2ecd2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33095:  => N/A
  + warning: vmlinux.o(.text+0x2ed3e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33095:  => N/A
  + warning: vmlinux.o(.text+0x2edb0): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2edf2): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33098:  => N/A
  + warning: vmlinux.o(.text+0x2ee5e): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33098:  => N/A
  + warning: vmlinux.o(.text+0x37238): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x37358): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x58260): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x5988c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x685d0): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x69c10): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x9a34c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0x9c48c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0xa4628): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xa6768): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A

428 improvements:
  - .config: warning: override: HIGHMEM4G changes choice state: 358 => 
  - <stdin>: warning: #warning syscall clock_adjtime not implemented: 1202:2 => 
  - <stdin>: warning: #warning syscall dup3 not implemented: 1163:2 => 
  - <stdin>: warning: #warning syscall epoll_create1 not implemented: 1160:2 => 
  - <stdin>: warning: #warning syscall eventfd2 not implemented: 1157:2 => 
  - <stdin>: warning: #warning syscall fallocate not implemented: 1145:2 => 
  - <stdin>: warning: #warning syscall fanotify_init not implemented: 1187:2 => 
  - <stdin>: warning: #warning syscall fanotify_mark not implemented: 1190:2 => 
  - <stdin>: warning: #warning syscall finit_module not implemented: 1223:2 => 
  - <stdin>: warning: #warning syscall inotify_init1 not implemented: 1169:2 => 
  - <stdin>: warning: #warning syscall kcmp not implemented: 1220:2 => 
  - <stdin>: warning: #warning syscall name_to_handle_at not implemented: 1196:2 => 
  - <stdin>: warning: #warning syscall open_by_handle_at not implemented: 1199:2 => 
  - <stdin>: warning: #warning syscall perf_event_open not implemented: 1181:2 => 
  - <stdin>: warning: #warning syscall pipe2 not implemented: 1166:2 => 
  - <stdin>: warning: #warning syscall pread64 not implemented: 725:2 => 
  - <stdin>: warning: #warning syscall preadv not implemented: 1172:2 => 
  - <stdin>: warning: #warning syscall prlimit64 not implemented: 1193:2 => 
  - <stdin>: warning: #warning syscall process_vm_readv not implemented: 1214:2 => 
  - <stdin>: warning: #warning syscall process_vm_writev not implemented: 1217:2 => 
  - <stdin>: warning: #warning syscall pwrite64 not implemented: 728:2 => 
  - <stdin>: warning: #warning syscall pwritev not implemented: 1175:2 => 
  - <stdin>: warning: #warning syscall recvmmsg not implemented: 1184:2 => 
  - <stdin>: warning: #warning syscall rt_tgsigqueueinfo not implemented: 1178:2 => 
  - <stdin>: warning: #warning syscall sendmmsg not implemented: 1208:2 => 
  - <stdin>: warning: #warning syscall signalfd4 not implemented: 1154:2 => 
  - <stdin>: warning: #warning syscall syncfs not implemented: 1205:2 => 
  - <stdin>: warning: #warning syscall timerfd_create not implemented: 1139:2 => 
  - <stdin>: warning: #warning syscall timerfd_gettime not implemented: 1151:2 => 
  - <stdin>: warning: #warning syscall timerfd_settime not implemented: 1148:2 => 
  - arch/avr32/include/asm/param.h: warning: "HZ" redefined  CC [M]  net/bridge/br_notify.o: 6:1 => 
  - arch/avr32/include/asm/param.h: warning: "HZ" redefined: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning:   LD      drivers/mtd/onenand/built-in.o: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition  AS      arch/avr32/lib/__avr32_lsl64.o: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition  CC      lib/string.o: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definition: 6:1 => 
  - arch/avr32/include/uapi/asm/param.h: warning: this is the location of the previous definitionIn file included from /scratch/kisskb/src/include/uapi/linux/param.h:4,: 6:1 => 
  - arch/avr32/kernel/process.c: warning: assignment makes integer from pointer without a cast: 310 => 
  - arch/cris/arch-v32/drivers/axisflashmap.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 396:3, 522:2 => 
  - arch/cris/arch-v32/drivers/axisflashmap.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 585:8 => 
  - arch/cris/arch-v32/drivers/axisflashmap.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'uint64_t' [-Wformat]: 335:10 => 
  - arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 122:2 => 
  - arch/cris/arch-v32/kernel/fasttimer.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 352:2 => 
  - arch/cris/arch-v32/mach-fs/pinmux.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]: 225:2, 97:2 => 
  - arch/cris/arch-v32/mm/intmem.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 116:14, 123:14 => 
  - arch/cris/arch-v32/mm/intmem.c: warning: initialization from incompatible pointer type [enabled by default]: 149:1 => 
  - arch/cris/include/arch-v10/arch/swab.h: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]: 16:2 => 
  - arch/cris/include/arch-v10/arch/swab.h: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]: 16:2 => 
  - arch/cris/include/asm/atomic.h: warning: 'cli' may be used uninitialized in this function [-Wuninitialized]: 83:4 => 
  - arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for ACPI_CONTAINER: 33 => 
  - arch/ia64/kernel/unaligned.c: warning: 'u.l' may be used uninitialized in this function [-Wuninitialized]: 1382:16 => 
  - arch/ia64/sn/kernel/bte.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 117:22, 125:22 => 
  - arch/ia64/sn/kernel/sn2/sn2_smp.c: warning: the frame size of 2176 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 319:1 => 
  - arch/s390/include/asm/uaccess.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]: 313:26 => 
  - arch/sh/include/uapi/asm/swab.h: warning: 'cur_cnid' may be used uninitialized in this function [-Wuninitialized]: 14:2 => 
  - arch/sh/include/uapi/asm/swab.h: warning: 'search_cnid' may be used uninitialized in this function [-Wuninitialized]: 14:2 => 
  - arch/sh/kernel/cpu/sh4a/clock-sh7780.c: warning: 'cpg_clk_init' is deprecated (declared at /scratch/kisskb/src/arch/sh/include/asm/clock.h:11) [-Wdeprecated-declarations]/scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c: In function 'cpg_clk_init':: 110:2 => 
  - arch/um/kernel/ptrace.c: warning: ignoring return value of 'tracehook_report_syscall_entry', declared with attribute warn_unused_result: 178 => 
  - arch/x86/include/asm/uaccess_32.h: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]: 211:26 => 
  - arch/x86/kernel/quirks.c: warning: 'd' may be used uninitialized in this function [-Wuninitialized]: 364:4 => 
  - arch/x86/kernel/quirks.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 407:21 => 
  - arch/xtensa/kernel/pci.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'resource_size_t' [-Wformat]: 82:11 => 
  - arch/xtensa/kernel/pci.c: warning: unused variable 'i' [-Wunused-variable]: 177:22 => 
  - block/blk-throttle.c: warning: value computed is not used [-Wunused-value]: 1029:2, 1030:2, 839:2 => 
  - crypto/algif_hash.c: warning: 'hash_accept' uses dynamic stack allocation [enabled by default]: 216:1 => 
  - crypto/async_tx/async_pq.c: warning: 'async_syndrome_val' uses dynamic stack allocation [enabled by default]: 393:1 => 
  - crypto/async_tx/async_pq.c: warning: 'do_async_gen_syndrome.constprop.9' uses dynamic stack allocation [enabled by default]: 143:1 => 
  - crypto/async_tx/raid6test.c: warning: 'raid6_dual_recov.constprop.3' uses dynamic stack allocation [enabled by default]: 133:1 => 
  - crypto/cbc.c: warning: 'crypto_cbc_decrypt_inplace.isra.3' uses dynamic stack allocation [enabled by default]: 167:1 => 
  - crypto/cipher.c: warning: 'cipher_crypt_unaligned' uses dynamic stack allocation [enabled by default]: 76:1 => 
  - crypto/ctr.c: warning: 'crypto_ctr_crypt_final' uses dynamic stack allocation [enabled by default]: 72:1 => 
  - crypto/ctr.c: warning: 'crypto_ctr_crypt_inplace' uses dynamic stack allocation [enabled by default]: 125:1 => 
  - crypto/cts.c: warning: 'cts_cbc_decrypt' uses dynamic stack allocation [enabled by default]: 217:1 => 
  - crypto/cts.c: warning: 'cts_cbc_encrypt' uses dynamic stack allocation [enabled by default]: 123:1 => 
  - crypto/hmac.c: warning: 'hmac_setkey' uses dynamic stack allocation [enabled by default]: 90:1 => 
  - crypto/pcbc.c: warning: 'crypto_pcbc_decrypt_inplace.isra.2' uses dynamic stack allocation [enabled by default]: 175:1 => 
  - crypto/pcbc.c: warning: 'crypto_pcbc_encrypt_inplace.isra.3' uses dynamic stack allocation [enabled by default]: 95:1 => 
  - crypto/shash.c: warning: 'shash_final_unaligned' uses dynamic stack allocation [enabled by default]: 131:1 => 
  - crypto/shash.c: warning: 'shash_update_unaligned' uses dynamic stack allocation [enabled by default]: 95:1 => 
  - crypto/xcbc.c: warning: 'crypto_xcbc_digest_setkey' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - drivers/ata/pata_pdc2027x.c: warning: 'pdc2027x_reinit_one' declared 'static' but never defined [-Wunused-function]: 66:12 => 
  - drivers/dma/dmatest.c: warning: 'dmatest_func' uses dynamic stack allocation [enabled by default]: 549:1 => 
  - drivers/dma/timb_dma.c: warning: 'td_remove' defined but not used [-Wunused-function]: 801:12 => 
  - drivers/gpu/drm/drm_lock.c: warning: passing argument 1 of '__cmpxchg' discards 'volatile' qualifier from pointer target type [enabled by default]: 310:3, 196:3, 272:3, 239:3, 357:5 => 
  - drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 85:3, 110:4 => 
  - drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 309:2 => 
  - drivers/gpu/drm/gma500/backlight.c: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]: 29:13 => 
  - drivers/gpu/drm/gma500/psb_irq.c: warning: control reaches end of non-void function [-Wreturn-type]: 47:1, 83:1, 59:1 => 
  - drivers/gpu/drm/i915/intel_ddi.c: warning: 'port' may be used uninitialized in this function [-Wuninitialized]: 1178:2 => 
  - drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 67:6 => 
  - drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]: 144:5 => 
  - drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]: 145:15 => 
  - drivers/gpu/drm/nouveau/nv50_pm.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]: 145:3 => 
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
  - drivers/md/dm-crypt.c: warning: 'crypt_iv_lmk_one.isra.8' uses dynamic stack allocation [enabled by default]: 573:1 => 
  - drivers/md/dm-raid1.c: warning: 'do_write' uses dynamic stack allocation [enabled by default]: 655:1 => 
  - drivers/md/dm-raid1.c: warning: 'mirror_flush' uses dynamic stack allocation [enabled by default]: 284:1 => 
  - drivers/md/dm-raid1.c: warning: 'mirror_status' uses dynamic stack allocation [enabled by default]: 1389:1 => 
  - drivers/md/dm-stripe.c: warning: 'stripe_status' uses dynamic stack allocation [enabled by default]: 343:1 => 
  - drivers/md/raid10.c: warning: 'handle_reshape_read_error' uses dynamic stack allocation [enabled by default]: 4613:1 => 
  - drivers/md/raid10.c: warning: 'raid10_mergeable_bvec' uses dynamic stack allocation [enabled by default]: 754:1 => 
  - drivers/media/dvb-frontends/af9013.c: warning: 'af9013_wr_regs_i2c' uses dynamic stack allocation [enabled by default]: 77:1 => 
  - drivers/media/dvb-frontends/af9033.c: warning: 'af9033_wr_regs' uses dynamic stack allocation [enabled by default]: 68:1 => 
  - drivers/media/dvb-frontends/bcm3510.c: warning: 'bcm3510_do_hab_cmd' uses dynamic stack allocation [enabled by default]: 230:1 => 
  - drivers/media/dvb-frontends/cxd2820r_core.c: warning: 'cxd2820r_rd_regs_i2c.isra.1' uses dynamic stack allocation [enabled by default]: 84:1 => 
  - drivers/media/dvb-frontends/cxd2820r_core.c: warning: 'cxd2820r_wr_regs_i2c.isra.0' uses dynamic stack allocation [enabled by default]: 51:1 => 
  - drivers/media/dvb-frontends/itd1000.c: warning: 'itd1000_write_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 69:1 => 
  - drivers/media/dvb-frontends/mt312.c: warning: 'mt312_write' uses dynamic stack allocation [enabled by default]: 126:1 => 
  - drivers/media/dvb-frontends/nxt200x.c: warning: 'nxt200x_writebytes' uses dynamic stack allocation [enabled by default]: 111:1 => 
  - drivers/media/dvb-frontends/rtl2830.c: warning: 'rtl2830_wr' uses dynamic stack allocation [enabled by default]: 56:1 => 
  - drivers/media/dvb-frontends/rtl2832.c: warning: 'rtl2832_wr' uses dynamic stack allocation [enabled by default]: 187:1 => 
  - drivers/media/dvb-frontends/s5h1420.c: warning: 's5h1420_tuner_i2c_tuner_xfer' uses dynamic stack allocation [enabled by default]: 851:1 => 
  - drivers/media/dvb-frontends/stb0899_drv.c: warning: 'stb0899_write_regs' uses dynamic stack allocation [enabled by default]: 540:1 => 
  - drivers/media/dvb-frontends/stb6100.c: warning: 'stb6100_write_reg_range.constprop.3' uses dynamic stack allocation [enabled by default]: 216:1 => 
  - drivers/media/dvb-frontends/stv0367.c: warning: 'stv0367_writeregs.constprop.4' uses dynamic stack allocation [enabled by default]: 791:1 => 
  - drivers/media/dvb-frontends/stv090x.c: warning: 'stv090x_write_regs.constprop.6' uses dynamic stack allocation [enabled by default]: 750:1 => 
  - drivers/media/dvb-frontends/stv6110.c: warning: 'stv6110_write_regs' uses dynamic stack allocation [enabled by default]: 98:1 => 
  - drivers/media/dvb-frontends/stv6110x.c: warning: 'stv6110x_write_regs' uses dynamic stack allocation [enabled by default]: 85:1 => 
  - drivers/media/dvb-frontends/tda10071.c: warning: 'tda10071_rd_regs' uses dynamic stack allocation [enabled by default]: 84:1 => 
  - drivers/media/dvb-frontends/tda10071.c: warning: 'tda10071_wr_regs' uses dynamic stack allocation [enabled by default]: 52:1 => 
  - drivers/media/dvb-frontends/tda18271c2dd.c: warning: 'WriteRegs' uses dynamic stack allocation [enabled by default]: 147:1 => 
  - drivers/media/dvb-frontends/zl10039.c: warning: 'zl10039_write' uses dynamic stack allocation [enabled by default]: 119:1 => 
  - drivers/media/pci/cx23885/cimax2.c: warning: 'netup_write_i2c' uses dynamic stack allocation [enabled by default]: 149:1 => 
  - drivers/media/pci/cx25821/cx25821-audio-upstream.c: warning: 'cx25821_get_audio_data.isra.4' uses dynamic stack allocation [enabled by default]: 337:1 => 
  - drivers/media/pci/cx25821/cx25821-audio-upstream.c: warning: 'cx25821_openfile_audio.isra.2' uses dynamic stack allocation [enabled by default]: 433:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: warning: 'cx25821_get_frame_ch2.isra.6' uses dynamic stack allocation [enabled by default]: 348:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c: warning: 'cx25821_openfile_ch2.isra.4' uses dynamic stack allocation [enabled by default]: 445:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream.c: warning: 'cx25821_get_frame.isra.6' uses dynamic stack allocation [enabled by default]: 392:1 => 
  - drivers/media/pci/cx25821/cx25821-video-upstream.c: warning: 'cx25821_openfile.isra.4' uses dynamic stack allocation [enabled by default]: 489:1 => 
  - drivers/media/pci/ttpci/av7110_hw.c: warning: 'av7110_fw_cmd' uses dynamic stack allocation [enabled by default]: 510:1 => 
  - drivers/media/radio/si470x/radio-si470x-i2c.c: warning: 'si470x_i2c_resume' defined but not used [-Wunused-function]: 487:12 => 
  - drivers/media/radio/si470x/radio-si470x-i2c.c: warning: 'si470x_i2c_suspend' defined but not used [-Wunused-function]: 470:12 => 
  - drivers/media/tuners/e4000.c: warning: 'e4000_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 81:1 => 
  - drivers/media/tuners/e4000.c: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]: 49:1 => 
  - drivers/media/tuners/fc2580.c: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 98:1 => 
  - drivers/media/tuners/fc2580.c: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]: 66:1 => 
  - drivers/media/tuners/tda18212.c: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 90:1 => 
  - drivers/media/tuners/tda18212.c: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]: 57:1 => 
  - drivers/media/tuners/tda18218.c: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]: 92:1 => 
  - drivers/media/tuners/tda18218.c: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]: 60:1 => 
  - drivers/media/tuners/tuner-xc2028.c: warning: 'load_firmware' uses dynamic stack allocation [enabled by default]: 651:1 => 
  - drivers/media/usb/dvb-usb-v2/af9015.c: warning: 'af9015_eeprom_hash' uses dynamic stack allocation [enabled by default]: 430:1 => 
  - drivers/media/usb/dvb-usb-v2/af9035.c: warning: 'af9035_i2c_master_xfer' uses dynamic stack allocation [enabled by default]: 281:1 => 
  - drivers/media/usb/dvb-usb-v2/af9035.c: warning: 'af9035_wr_regs' uses dynamic stack allocation [enabled by default]: 136:1 => 
  - drivers/media/usb/dvb-usb-v2/mxl111sf.c: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - drivers/media/usb/dvb-usb/cxusb.c: warning: 'cxusb_ctrl_msg' uses dynamic stack allocation [enabled by default]: 69:1 => 
  - drivers/media/usb/dvb-usb/cxusb.c: warning: 'cxusb_i2c_xfer' uses dynamic stack allocation [enabled by default]: 209:1 => 
  - drivers/media/usb/dvb-usb/dibusb-common.c: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]: 122:1 => 
  - drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw2102_earda_i2c_transfer' uses dynamic stack allocation [enabled by default]: 365:1 => 
  - drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw2104_i2c_transfer' uses dynamic stack allocation [enabled by default]: 446:1 => 
  - drivers/media/usb/dvb-usb/dw2102.c: warning: 'dw3101_i2c_transfer' uses dynamic stack allocation [enabled by default]: 509:1 => 
  - drivers/media/usb/dvb-usb/dw2102.c: warning: 's6x0_i2c_transfer' uses dynamic stack allocation [enabled by default]: 618:1 => 
  - drivers/message/i2o/i2o_config.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 943:10, 888:19 => 
  - drivers/mfd/syscon.c: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'resource_size_t' [-Wformat]: 136:2 => 
  - drivers/mfd/syscon.c: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]: 136:2 => 
  - drivers/mfd/wm8994-core.c: warning: 'patch_regs' may be used uninitialized in this function [-Wuninitialized]: 595:7 => 
  - drivers/misc/apds990x.c: warning: 'apds990x_resume' defined but not used [-Wunused-function]: 1217:12 => 
  - drivers/misc/apds990x.c: warning: 'apds990x_suspend' defined but not used [-Wunused-function]: 1208:12 => 
  - drivers/misc/bh1770glc.c: warning: 'bh1770_resume' defined but not used [-Wunused-function]: 1324:12 => 
  - drivers/misc/bh1770glc.c: warning: 'bh1770_suspend' defined but not used [-Wunused-function]: 1314:12 => 
  - drivers/misc/bh1780gli.c: warning: 'bh1780_resume' defined but not used [-Wunused-function]: 222:12 => 
  - drivers/misc/bh1780gli.c: warning: 'bh1780_suspend' defined but not used [-Wunused-function]: 200:12 => 
  - drivers/misc/tifm_7xx1.c: warning: 'tifm_7xx1_resume' uses dynamic stack allocation [enabled by default]: 297:1 => 
  - drivers/mmc/card/block.c: warning: 'arg' may be used uninitialized in this function: 899 => 
  - drivers/mmc/card/block.c: warning: 'from' may be used uninitialized in this function: 899 => 
  - drivers/mmc/card/block.c: warning: 'nr' may be used uninitialized in this function: 899 => 
  - drivers/mtd/chips/cfi_cmdset_0001.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1700:9 => 
  - drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1440 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1797:1 => 
  - drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_is_locked' defined but not used: 2388 => 
  - drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_lock' defined but not used: 2283 => 
  - drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'cfi_ppb_unlock' defined but not used: 2290 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1152 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 420:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1360 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1392 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1444 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 420:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 654:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1728 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 654:1 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2256 bytes is larger than 2048 bytes [-Wframe-larger-than=]: 654:1 => 
  - drivers/mtd/inftlmount.c: warning: 'check_free_sectors.constprop.0' uses dynamic stack allocation [enabled by default]: 362:1 => 
  - drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20, 127:2 => 
  - drivers/mtd/nand/denali.c: warning: 'find_valid_banks' uses dynamic stack allocation [enabled by default]: 437:1 => 
  - drivers/mtd/nftlmount.c: warning: 'check_free_sectors' uses dynamic stack allocation [enabled by default]: 294:1 => 
  - drivers/net/ethernet/3com/3c59x.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 1026:9, 1028:10, 1326:18 => 
  - drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201) [-Wdeprecated-declarations]: 625:3 => 
  - drivers/net/ethernet/dec/tulip/tulip_core.c: warning: #warning Processor architecture undefined! [-Wcpp]: 101:2 => 
  - drivers/net/ethernet/dec/tulip/winbond-840.c: warning: #warning Processor architecture undefined [-Wcpp]: 911:2 => 
  - drivers/net/ethernet/i825xx/sun3_82586.c: warning: array subscript is above array bounds [-Warray-bounds]: 993:89 => 
  - drivers/net/ethernet/intel/igb/igb_main.c: warning: 'igb_resume' defined but not used [-Wunused-function]: 7043:12 => 
  - drivers/net/ethernet/intel/igb/igb_main.c: warning: 'wake' may be used uninitialized in this function [-Wuninitialized]: 7138:19 => 
  - drivers/net/ethernet/marvell/sky2.c: warning: control reaches end of non-void function [-Wreturn-type]: 3130:1 => 
  - drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'vxge_hw_device_hw_info_get' uses dynamic stack allocation [enabled by default]: 1090:1 => 
  - drivers/net/ethernet/ti/tlan.c: warning: label 'err_out' defined but not used [-Wunused-label]: 616:1 => 
  - drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_resume' defined but not used [-Wunused-function]: 773:12 => 
  - drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_suspend' defined but not used [-Wunused-function]: 758:12 => 
  - drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_resume' defined but not used [-Wunused-function]: 685:12 => 
  - drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_suspend' defined but not used [-Wunused-function]: 670:12 => 
  - drivers/net/fddi/skfp/h/skfbi.h: warning: "PCI_IOBASE" redefined [enabled by default]: 151:0 => 
  - drivers/net/usb/rtl8150.c: warning: "RSR" redefined [enabled by default]: 31:0 => 
  - drivers/net/wan/farsync.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1408:10 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'desc' may be used uninitialized in this function [-Wuninitialized]: 1145:9 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'desc2' may be used uninitialized in this function [-Wuninitialized]: 1143:9 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_resume' defined but not used [-Wunused-function]: 205:12 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_suspend' defined but not used [-Wunused-function]: 170:12 => 
  - drivers/pci/msi.c: warning: unused variable 'i' [-Wunused-variable]: 340:7 => 
  - drivers/pci/pci-driver.c: warning: 'pci_restore_standard_config' defined but not used [-Wunused-function]: 407:12 => 
  - drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 693:12 => 
  - drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 724:13 => 
  - drivers/rtc/rtc-88pm80x.c: warning: 'pm80x_rtc_resume' defined but not used [-Wunused-function]: 243:12 => 
  - drivers/rtc/rtc-88pm80x.c: warning: 'pm80x_rtc_suspend' defined but not used [-Wunused-function]: 238:12 => 
  - drivers/rtc/rtc-ds1374.c: warning: 'ds1374_resume' defined but not used [-Wunused-function]: 422:12 => 
  - drivers/rtc/rtc-ds1374.c: warning: 'ds1374_suspend' defined but not used [-Wunused-function]: 413:12 => 
  - drivers/scsi/aic7xxx/aic79xx_core.c: warning: 'ahd_loadseq' uses dynamic stack allocation [enabled by default]: 9509:1 => 
  - drivers/scsi/aic7xxx/aic7xxx_core.c: warning: 'ahc_loadseq' uses dynamic stack allocation [enabled by default]: 6957:1 => 
  - drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used uninitialized in this function [-Wuninitialized]: 597:21 => 
  - drivers/scsi/dpt_i2o.c: warning: 'adpt_i2o_passthru' uses dynamic stack allocation [enabled by default]: 1984:1 => 
  - drivers/scsi/dpt_i2o.c: warning: 'dptids' defined but not used [-Wunused-variable]: 183:29 => 
  - drivers/scsi/mvsas/mv_sas.c: warning: comparison between 'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]: 1165:39, 1162:34 => 
  - drivers/scsi/osd/osd_initiator.c: warning: 'osd_req_decode_sense_full' uses dynamic stack allocation [enabled by default]: 1947:1 => 
  - drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_resume' defined but not used [-Wunused-function]: 35:12 => 
  - drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_suspend' defined but not used [-Wunused-function]: 19:12 => 
  - drivers/scsi/sym53c8xx_2/sym_defs.h: warning: "WSR" redefined [enabled by default]: 109:0 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_resume' defined but not used [-Wunused-function]: 1328:12 => 
  - drivers/spi/spi-pxa2xx.c: warning: 'pxa2xx_spi_suspend' defined but not used [-Wunused-function]: 1313:12 => 
  - drivers/ssb/driver_mipscore.c: warning: unused variable 'irq_name' [-Wunused-variable]: 178:21 => 
  - drivers/staging/ft1000/ft1000-usb/ft1000_debug.c: warning: 'msgsz' may be used uninitialized in this function [-Wuninitialized]: 623:55 => 
  - drivers/staging/line6/midi.c: warning: 'line6_midi_transmit' uses dynamic stack allocation [enabled by default]: 76:1 => 
  - drivers/staging/media/lirc/lirc_zilog.c: warning: 'read' uses dynamic stack allocation [enabled by default]: 967:1 => 
  - drivers/staging/rtl8712/rtl871x_ioctl_linux.c: warning: 'addr' may be used uninitialized in this function [-Wuninitialized]: 1888:15, 1870:9 => 
  - drivers/staging/slicoss/slicoss.c: warning: operation on 'rspq->pageindex' may be undefined [-Wsequence-point]: 1418:19 => 
  - drivers/staging/vt6655/iwctl.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 787:1 => 
  - drivers/staging/zcache/zcache-main.c: warning: 'cli' may be used uninitialized in this function [-Wuninitialized]: 1598:13, 1598:3 => 
  - drivers/target/iscsi/iscsi_target.c: warning: 'iscsit_send_data_in' uses dynamic stack allocation [enabled by default]: 2596:1 => 
  - drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]: 2274:7 => 
  - drivers/tty/pty.c: warning: 'pty_unix98_shutdown' defined but not used [-Wunused-function]: 409:13 => 
  - drivers/tty/rocket.c: warning: 'rmSpeakerReset' defined but not used [-Wunused-function]: 3140:13 => 
  - drivers/tty/rocket.c: warning: 'sPCIInitController' defined but not used [-Wunused-function]: 2599:12 => 
  - drivers/tty/serial/8250/8250_core.c: warning: 'i' may be used uninitialized in this function [-Wuninitialized]: 1712:2, 1714:18, 1717:18 => 1712:2, 1717:18
  - drivers/usb/gadget/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]: 579:1 => 
  - drivers/usb/gadget/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]: 1057:30, 1004:28, 1077:6, 1057:14, 1077:19, 990:5, 1036:4 => 1004:28, 1077:6, 1077:19, 990:5, 1036:4
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
  - fs/btrfs/inode.c: warning: 'cur_offset' may be used uninitialized in this function [-Wuninitialized]: 1447:31, 1319:16 => 1331:16
  - fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1263:21, 1153:28 => 1474:6
  - fs/btrfs/raid56.c: warning: 'finish_rmw' uses dynamic stack allocation [enabled by default]: 1266:1 => 
  - fs/btrfs/tree-log.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 3309:40 => 
  - fs/isofs/compress.c: warning: 'zisofs_readpage' uses dynamic stack allocation [enabled by default]: 360:1 => 
  - fs/isofs/compress.c: warning: 'zisofs_uncompress_block' uses dynamic stack allocation [enabled by default]: 193:1 => 
  - fs/nfs/super.c: warning: 'nfs_show_stats' uses dynamic stack allocation [enabled by default]: 887:1 => 
  - fs/nfs/unlink.c: warning: 'nfs_sillyrename' uses dynamic stack allocation [enabled by default]: 563:1 => 
  - fs/ntfs/aops.c: warning: 'ntfs_write_mst_block' uses dynamic stack allocation [enabled by default]: 1329:1 => 
  - fs/ntfs/compress.c: warning: 'ntfs_decompress' uses dynamic stack allocation [enabled by default]: 445:1 => 
  - fs/ntfs/mft.c: warning: 'ntfs_sync_mft_mirror' uses dynamic stack allocation [enabled by default]: 636:1 => 
  - fs/ntfs/mft.c: warning: 'write_mft_record_nolock' uses dynamic stack allocation [enabled by default]: 844:1 => 
  - fs/proc/vmcore.c: warning: initialization from incompatible pointer type [enabled by default]: 544:4 => 
  - fs/pstore/ram_core.c: warning: 'persistent_ram_decode_rs8' uses dynamic stack allocation [enabled by default]: 104:1 => 
  - fs/pstore/ram_core.c: warning: 'persistent_ram_encode_rs8' uses dynamic stack allocation [enabled by default]: 92:1 => 
  - fs/reiserfs/inode.c: warning: 'reiserfs_new_directory' uses dynamic stack allocation [enabled by default]: 1715:1 => 
  - fs/udf/super.c: warning: 'map' may be used uninitialized in this function [-Wuninitialized]: 1259:9 => 
  - fs/xfs/xfs_inode_item.c: warning: 'xfs_iflush_done' uses dynamic stack allocation [enabled by default]: 780:1 => 
  - include/asm-generic/io.h: warning: passing argument 1 of '__raw_readb' makes pointer from integer without a cast [enabled by default]: 170:4, 129:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of '__raw_readl' makes pointer from integer without a cast [enabled by default]: 196:4 => 
  - include/asm-generic/io.h: warning: passing argument 1 of '__raw_readw' makes pointer from integer without a cast [enabled by default]: 183:4 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'readl' makes pointer from integer without a cast [enabled by default]: 139:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'readw' makes pointer from integer without a cast [enabled by default]: 134:2 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u16' makes pointer from integer without a cast [enabled by default]: 183:4 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u32' makes pointer from integer without a cast [enabled by default]: 196:4 => 
  - include/asm-generic/io.h: warning: passing argument 1 of 'zpci_read_u8' makes pointer from integer without a cast [enabled by default]: 170:4, 129:2 => 
  - include/asm-generic/io.h: warning: passing argument 2 of '__raw_writeb' makes pointer from integer without a cast [enabled by default]: 144:2, 209:4 => 
  - include/asm-generic/io.h: warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast [enabled by default]: 233:4, 154:2 => 
  - include/asm-generic/io.h: warning: passing argument 2 of '__raw_writew' makes pointer from integer without a cast [enabled by default]: 221:4, 149:2 => 
  - include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u16' makes pointer from integer without a cast [enabled by default]: 221:4, 149:2 => 
  - include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u32' makes pointer from integer without a cast [enabled by default]: 233:4, 154:2 => 
  - include/asm-generic/io.h: warning: passing argument 2 of 'zpci_write_u8' makes pointer from integer without a cast [enabled by default]: 144:2, 209:4 => 
  - include/linux/err.h: warning: 'dst_di' may be used uninitialized in this function [-Wuninitialized]: 39:17 => 
  - include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 279:4, 349:2, 332:11, 324:17, 278:6, 397:11, 367:14, 290:22, 414:2 => 279:4, 349:2, 332:11, 278:6, 397:11, 367:14, 414:2
  - include/linux/thermal.h: warning: 'thermal_generate_netlink_event' defined but not used [-Wunused-function]: 254:12 => 
  - kernel/debug/debug_core.c: warning: value computed is not used [-Wunused-value]: 511:5, 496:4 => 
  - kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]: 334:22 => 
  - kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]: 270:13 => 
  - kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]: 247:13 => 
  - kernel/rcutiny.c: warning: unused variable 'idle': 69, 130 => 
  - kernel/rcutree.c: warning: unused variable 'idle' [-Wunused-variable]: 345:23, 501:23 => 
  - kernel/sched/core.c: warning: control reaches end of non-void function: 2836 => 
  - kernel/sched/fair.c: warning: 'update_cfs_rq_blocked_load' declared inline after being called: 266 => 
  - kernel/sched/fair.c: warning: previous declaration of 'update_cfs_rq_blocked_load' was here: 266 => 
  - kernel/seccomp.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 453:15 => 
  - kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]: 112:1 => 
  - kernel/time/timer_stats.c: warning: 'timer_stats_update_stats' uses dynamic stack allocation [enabled by default]: 268:1 => 
  - lib/bch.c: warning: 'build_deg2_base' uses dynamic stack allocation [enabled by default]: 1149:1 => 
  - lib/bch.c: warning: 'encode_bch' uses dynamic stack allocation [enabled by default]: 253:1 => 
  - lib/bch.c: warning: 'solve_linear_system.isra.7.constprop.10' uses dynamic stack allocation [enabled by default]: 502:1 => 
  - lib/btree.c: warning: 'btree_get_prev' uses dynamic stack allocation [enabled by default]: 359:1 => 
  - lib/btree.c: warning: 'btree_merge' uses dynamic stack allocation [enabled by default]: 672:1 => 
  - lib/crc32.c: warning: passing argument 4 of 'crc32_be_generic' from incompatible pointer type: 258 => 
  - lib/crc32.c: warning: passing argument 4 of 'crc32_le_generic' from incompatible pointer type: 191, 196 => 
  - lib/libcrc32c.c: warning: 'crc32c' uses dynamic stack allocation [enabled by default]: 58:1 => 
  - lib/mpi/longlong.h: warning: function declaration isn't a prototype [-Wstrict-prototypes]: 346:1 => 
  - lib/reed_solomon/reed_solomon.c: warning: 'decode_rs16' uses dynamic stack allocation [enabled by default]: 373:1 => 
  - lib/reed_solomon/reed_solomon.c: warning: 'decode_rs8' uses dynamic stack allocation [enabled by default]: 329:1 => 
  - lib/vsprintf.c: warning: 'resource_string.isra.9' uses dynamic stack allocation [enabled by default]: 660:1 => 
  - mm/bootmem.c: warning: control reaches end of non-void function: 386 => 
  - mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in this function [-Wuninitialized]: 5618:35, 5518:19, 5636:32, 5515:16 => 5736:35, 5636:19, 5754:32
  - mm/slab.c: warning: passing argument 2 of '__cache_free' discards qualifiers from pointer target type: 3933 => 
  - mm/slab_common.c: warning: format '%zd' expects argument of type 'signed size_t', but argument 3 has type 'size_t' [-Wformat]: 303:6 => 
  - mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]: 2309:1 => 
  - mm/slub.c: warning: '__slab_free' uses dynamic stack allocation [enabled by default]: 2568:1 => 
  - mm/slub.c: warning: 'deactivate_slab' uses dynamic stack allocation [enabled by default]: 1872:1 => 
  - mm/slub.c: warning: 'get_partial_node.isra.34' uses dynamic stack allocation [enabled by default]: 1579:1 => 
  - mm/slub.c: warning: 'unfreeze_partials.isra.32' uses dynamic stack allocation [enabled by default]: 1938:1 => 
  - modpost: WARNING: modpost: Found 11 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 13 section mismatch(es).: N/A => 
  - modpost: WARNING: modpost: Found 6 section mismatch(es).: N/A => 
  - net/bridge/netfilter/ebtables.c: warning: 'compat_copy_everything_to_user' uses dynamic stack allocation [enabled by default]: 1841:1 => 
  - net/core/pktgen.c: warning: 'pktgen_if_write' uses dynamic stack allocation [enabled by default]: 1684:1 => 
  - net/core/rtnetlink.c: warning: 'rtnl_newlink' uses dynamic stack allocation [enabled by default]: 1867:1 => 
  - net/ipv6/xfrm6_state.c: warning: '__xfrm6_sort' uses dynamic stack allocation [enabled by default]: 83:1 => 
  - net/llc/llc_sap.c: warning: 'llc_sap_mcast' uses dynamic stack allocation [enabled by default]: 418:1 => 
  - net/netfilter/nfnetlink.c: warning: 'nfnetlink_rcv_msg' uses dynamic stack allocation [enabled by default]: 211:1 => 
  - net/netfilter/nfnetlink_cttimeout.c: warning: 'ctnl_timeout_parse_policy' uses dynamic stack allocation [enabled by default]: 69:1 => 
  - net/rds/connection.c: warning: 'rds_for_each_conn_info' uses dynamic stack allocation [enabled by default]: 467:1 => 
  - net/rds/message.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 260:5 => 
  - net/rxrpc/rxkad.c: warning: 'rxkad_prime_packet_security' uses dynamic stack allocation [enabled by default]: 148:1 => 
  - net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1774:1 => 
  - net/unix/af_unix.c: warning: 'path.dentry' may be used uninitialized in this function: 892 => 
  - net/unix/af_unix.c: warning: 'path.mnt' may be used uninitialized in this function: 892 => 
  - security/integrity/ima/ima_crypto.c: warning: 'ima_calc_boot_aggregate' uses dynamic stack allocation [enabled by default]: 148:1 => 
  - security/integrity/ima/ima_crypto.c: warning: 'ima_calc_buffer_hash' uses dynamic stack allocation [enabled by default]: 109:1 => 
  - security/integrity/ima/ima_crypto.c: warning: 'ima_calc_file_hash' uses dynamic stack allocation [enabled by default]: 93:1 => 
  - sound/core/oss/pcm_oss.c: warning: 'snd_pcm_oss_sync' uses dynamic stack allocation [enabled by default]: 1701:1 => 
  - sound/core/pcm_native.c: warning: 'snd_pcm_hw_refine' uses dynamic stack allocation [enabled by default]: 333:1 => 
  - sound/isa/es18xx.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 2196:6 => 
  - sound/isa/gus/interwave.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 811:6 => 
  - sound/isa/sb/emu8000_patch.c: warning: 'cc' may be used uninitialized in this function [-Wuninitialized]: 91:5, 98:7 => 
  - sound/isa/sb/sb16.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 527:6 => 
  - sound/mips/hal2.c: warning: 'l' may be used uninitialized in this function [-Wuninitialized]: 223:35 => 
  - sound/mips/hal2.c: warning: 'new' may be used uninitialized in this function [-Wuninitialized]: 260:2 => 
  - sound/mips/hal2.c: warning: 'old' may be used uninitialized in this function [-Wuninitialized]: 260:2 => 
  - sound/mips/hal2.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]: 224:35 => 
  - sound/oss/dmabuf.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 139:2 => 
  - sound/oss/soundcard.c: warning: 'dma_alloc_map' defined but not used [-Wunused-variable]: 69:17 => 
  - sound/pci/lx6464es/lx6464es.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 456:3 => 
  - sound/pci/lx6464es/lx_core.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 1194:2 => 
  - sound/soc/atmel/atmel-pcm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 52:2 => 
  - sound/soc/codecs/adau1373.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 940:3 => 
  - sound/soc/soc-core.c: warning: 'format_register_str' uses dynamic stack allocation [enabled by default]: 122:1 => 
  - warning: "cause_of_death" [vmlinux] is COMMON symbol: N/A => 
  - warning: (COMPAT) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (DRM_RADEON && DRM_I915 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT): N/A => 
  - warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
  - warning: (IA64) selects PM which has unmet direct dependencies (PM_SLEEP || PM_RUNTIME): N/A => 
  - warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300 || METAG) || ARCH_WANT_FRAME_POINTERS): N/A => 
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
  - warning: vmlinux.o(.text+0x94a2): Section mismatch in reference from the variable generic_secondary_common_init to the variable .init.data:spinning_secondaries: N/A => 
  - warning: vmlinux.o(.text+0xa1784): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 
  - warning: vmlinux.o(.text+0xa4564): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
