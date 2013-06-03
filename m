Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3FCITN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:19:13 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50330 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3FCITI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:19:08 -0400
Date: Mon, 3 Jun 2013 10:19:04 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v3.10-rc4
Message-ID: <alpine.DEB.2.00.1306031018320.18831@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.10-rc4[1] compared to v3.9[2].

Summarized:
  - build errors: +36/-24
  - build warnings: +164/-160

JFYI, when comparing v3.10-rc4 to v3.10-rc3[3], the summaries are:
  - build errors: +6/-2
  - build warnings: +66/-132

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.10-rc4.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/6290/ (all 120 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/6143/ (117 out of 120 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/6268/ (all 120 configs)


*** ERRORS ***

36 regressions:
  + arch/h8300/kernel/entry.S: Error: invalid operands:  => 204, 210, 307, 230, 218, 377, 358, 383, 247
  + arch/h8300/kernel/entry.S: Error: junk at end of line, first unrecognized character is `(':  => 159, 161, 165, 160, 167, 158, 163, 166, 162, 164, 195
  + arch/h8300/kernel/syscalls.S: Error: junk at end of line, first unrecognized character is `(':  => 127, 32, 276, 90, 206, 118, 71, 102, 331, 55, 84, 233, 259, 194, 57, 220, 316, 163, 89, 175, 31, 35, 208, 93, 292, 325, 29, 291, 199, 114, 226, 58, 211, 153, 101, 73, 76, 311, 62, 67, 241, 198, 139, 129, 327, 320, 280, 273, 236, 249, 218, 202, 168, 184, 135, 145, 49, 178, 24, 285, 140, 124, 104, 131, 181, 234, 314, 307, 154, 23, 96, 159, 326, 160, 47, 98, 335, 37, 43, 270, 195, 21, 288, 193, 119, 324, 180, 244, 162, 246, 240, 74, 334, 61, 230, 299, 115, 103, 201, 113, 152, 189, 295, 266, 91, 107, 87, 174, 77, 214, 221, 39, 64, 97, 41, 52, 312, 302, 229, 45, 260, 237, 309, 188, 68, 315, 116, 136, 144, 100, 300, 222, 25, 286, 120, 83, 305, 308, 254, 177, 217, 328, 239, 122, 143, 281, 269, 205, 158, 22, 42, 46, 235, 301, 6, 36, 213, 183, 94, 51, 317, 296, 265, 169, 132, 171, 200, 18, 125, 329, 44, 27, 161, 190, 272, 298, 95, 313, 20, 109, 231, 243, 151, 148, 287, 78, 294, 106, 275, 157, 65, 197, 203, 261, 138, 81, 137, 60, 321, 284, 86, 247, 204, 289, 165, 17, 186, 82, 110, 147, 333, 228, 323, 268, 69, 112, 319, 172, 191, 224, 187, 223, 282, 262, 79, 121, 212, 126, 238, 251, 253, 279, 176, 209, 216, 256, 117, 170, 33, 63, 80, 26, 227, 336, 99, 72, 179, 255, 264, 297, 182, 108, 277, 92, 232, 225, 330, 142, 207, 263, 167, 48, 133, 290, 123, 149, 304, 50, 210, 258, 173, 56, 66, 19, 293, 54, 274, 306, 70, 322, 166, 88, 141, 30, 128, 252, 28, 310, 283, 134, 40, 75, 156, 303, 192, 250, 59, 215, 278, 150, 271, 130, 155, 53, 245, 267, 219, 318, 105, 257, 85, 185, 332, 248, 111, 146, 38, 34, 164, 196, 242
  + arch/h8300/lib/abs.S: Error: junk at end of line, first unrecognized character is `(':  => 12
  + arch/h8300/lib/memcpy.S: Error: junk at end of line, first unrecognized character is `(':  => 13
  + arch/h8300/lib/memset.S: Error: junk at end of line, first unrecognized character is `(':  => 13
  + arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: invalid operands:  => 68, 62
  + arch/h8300/platform/h8300h/generic/crt0_ram.S: Error: junk at end of line, first unrecognized character is `(':  => 27, 25, 28, 26
  + arch/powerpc/sysdev/mpic.c: error: case label does not reduce to an integer constant:  => 890:9, 898:9, 886:9, 894:9
  + arch/um/os-Linux/start_up.c: error: for each function it appears in.)  CC      arch/x86/um/bug.o:  => 245
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
  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.mutex_lock_nested' defined in .sched.text section in kernel/built-in.o:  => (.text+0x1ffafa8)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.udelay' defined in .text section in arch/powerpc/kernel/built-in.o:  => (.text+0x1ff9e78), (.text+0x1ff9ff0)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffaf6c), (.text+0x1ffaba4)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffa400), (.text+0x1ffa6e8)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_29' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffab24), (.text+0x1ffabac)
  + error: main.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9a98)
  + error: spi-rspi.c: undefined reference to `shdma_chan_filter':  => .text+0x64f28), .text+0x65108)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+ae0:  => (.text+0x8de)
  + kernel/cpu/idle.c: error: implicit declaration of function 'check_pgt_cache' [-Werror=implicit-function-declaration]:  => 72:4
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'led_cdevs':  => 214:2, 278:2
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'leddev_list_lock':  => 213:2, 280:2, 277:2, 216:2
  + net/mac80211/led.c: error: 'struct led_trigger' has no member named 'name':  => 74:16, 83:16, 101:19, 92:19, 237:16

24 improvements:
  - arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'inhibit_secondary_onlining' [-Werror=implicit-function-declaration]: 1855:2 => 
  - arch/powerpc/kvm/book3s_hv.c: error: implicit declaration of function 'uninhibit_secondary_onlining' [-Werror=implicit-function-declaration]: 1862:2 => 
  - arch/um/os-Linux/start_up.c: error: for each function it appears in.): 245 => 
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

164 regressions:
  + .config: warning: override: SLOB changes choice state:  => 182
  + .config: warning: override: SPARSEMEM_MANUAL changes choice state:  => 270
  + arch/ia64/configs/generic_defconfig: warning: symbol value 'm' invalid for HOTPLUG_PCI_ACPI:  => 35
  + arch/microblaze/include/asm/cacheflush.h: warning: 'addr' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 108:8
  + arch/tile/kernel/process.c: warning: unused variable 'tsk' [-Wunused-variable]:  => 572:22
  + drivers/block/hd.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 332:2, 331:2, 330:2, 328:2, 327:2, 329:2, 333:2
  + drivers/block/paride/ppc6lnx.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 217:2, 146:2, 537:5, 147:2, 266:4, 201:2, 131:18, 142:3, 162:2, 145:2, 575:6, 430:15, 560:4, 235:4, 329:11, 144:2
  + drivers/block/rbd.c: warning: 'pages' may be used uninitialized in this function [-Wuninitialized]:  => 2230:10
  + drivers/block/rbd.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1152:12
  + drivers/dma/of-dma.c: warning: 'nbcells' may be used uninitialized in this function [-Wuninitialized]:  => 83:15
  + drivers/gpio/gpio-mcp23s08.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 622:10
  + drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 411:15
  + drivers/hwmon/sch56xx-common.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 148:2
  + drivers/hwmon/smsc47b397.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 121:2
  + drivers/iio/adc/exynos_adc.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 111:9
  + drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 79:25
  + drivers/infiniband/hw/ocrdma/ocrdma_main.c: warning: 'ocrdma_del_sgid' defined but not used [-Wunused-function]:  => 119:13
  + drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' defined but not used [-Wunused-function]:  => 210:13
  + drivers/input/keyboard/cros_ec_keyb.c: warning: 'cros_ec_keyb_clear_keyboard' uses dynamic stack allocation [enabled by default]:  => 234:1
  + drivers/isdn/icn/icn.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 89:3
  + drivers/leds/leds-ot200.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 112:8 => 112:8, 114:6
  + drivers/md/bcache/super.c: warning: (near initialization for 'bcache_ops.release') [enabled by default]:  => 653:2
  + drivers/md/bcache/super.c: warning: initialization from incompatible pointer type [enabled by default]:  => 653:2
  + drivers/md/bcache/sysfs.c: warning: '__bch_cache_show' uses dynamic stack allocation [enabled by default]:  => 730:1
  + drivers/media/dvb-frontends/af9033.c: warning: 'af9033_wr_reg_val_tab' uses dynamic stack allocation [enabled by default]:  => 188:1
  + drivers/media/rc/fintek-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 80:2, 54:2, 81:2, 55:8, 45:2, 87:2, 46:2
  + drivers/media/rc/nuvoton-cir.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 52:2, 91:2, 45:2, 81:2, 92:2, 74:2, 46:2, 53:9, 75:2
  + drivers/mfd/wm8994-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 762:19
  + drivers/misc/altera-stapl/altera-lpt.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 40:9, 34:2
  + drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 344:3
  + drivers/mmc/host/tmio_mmc_pio.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 798:19
  + drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1448 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 420:1
  + drivers/net/ethernet/8390/wd.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 287:4, 294:4
  + drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:213) [-Wdeprecated-declarations]:  => 625:3
  + drivers/net/ethernet/intel/e1000e/ich8lan.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 898:4
  + drivers/net/ethernet/neterion/vxge/vxge-config.c: warning: 'val32' may be used uninitialized in this function [-Wuninitialized]:  => 4594:18
  + drivers/net/ethernet/tundra/tsi108_eth.c: warning: 'dump_eth_one' defined but not used [-Wunused-function]:  => 171:13
  + drivers/nubus/proc.c: warning: #warning Need to set some I/O handlers here [-Wcpp]:  => 64:2
  + drivers/power/twl4030_charger.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 192:20
  + drivers/regulator/ab3100.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 650:4
  + drivers/rtc/rtc-sh.c: warning: 'sh_rtc_set_irq_wake' defined but not used [-Wunused-function]:  => 780:13
  + drivers/scsi/NCR5380.h: warning: 'NCR5380_write_info' declared 'static' but never defined [-Wunused-function]:  => 319:27
  + drivers/scsi/imm.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 245:2, 301:3, 471:2, 339:15, 459:2, 303:3, 465:2, 461:2, 468:2, 492:2, 561:2, 484:2, 463:2
  + drivers/scsi/pm8001/pm8001_init.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 424:4
  + drivers/scsi/ppa.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 244:3, 378:2, 256:15, 398:2, 438:2, 435:2
  + drivers/spi/spi-pxa2xx.c: warning: return makes pointer from integer without a cast [enabled by default]:  => 1094:3
  + drivers/staging/android/sync.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 865:3
  + drivers/staging/comedi/drivers/ni_labpc.c: warning: unused variable 'dma_chan' [-Wunused-variable]:  => 1717:15
  + drivers/staging/rtl8192e/rtllib_softmac.c: warning: 'time' may be used uninitialized in this function [-Wuninitialized]:  => 2093:19
  + drivers/staging/sm7xxfb/sm7xxfb.c: warning: 'sm7xx_vga_setup' defined but not used [-Wunused-function]  CC [M]  drivers/media/dvb-frontends/s5h1411.o:  => 117:19
  + drivers/staging/speakup/kobjects.c: warning: 'value' may be used uninitialized in this function [-Wuninitialized]:  => 667:39
  + drivers/staging/vt6655/device_main.c: warning: the frame size of 1296 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 3254:1
  + drivers/staging/vt6655/iwctl.c: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 758:1
  + drivers/target/iscsi/iscsi_target.c: warning: 'iscsit_send_datain' uses dynamic stack allocation [enabled by default]:  => 2726:1
  + drivers/tty/rocket_int.h: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 67:9, 45:2, 72:9, 53:2
  + drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_resume' defined but not used [-Wunused-function]:  => 326:12
  + drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_suspend' defined but not used [-Wunused-function]:  => 317:12
  + drivers/tty/serial/pch_uart.c: warning: 'wait_for_xmitr' defined but not used [-Wunused-function]:  => 1499:13
  + drivers/usb/core/hcd-pci.c: warning: 'ehci_wait_for_companions' defined but not used [-Wunused-function]:  => 149:13
  + drivers/usb/gadget/net2272.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2466:5
  + drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 213:51
  + drivers/video/aty/atyfb_base.c: warning: 'ram_dram' defined but not used [-Wunused-variable]:  => 534:13
  + drivers/video/aty/atyfb_base.c: warning: 'ram_resv' defined but not used [-Wunused-variable]:  => 535:13
  + fs/btrfs/disk-io.c: warning: 'btrfs_check_super_csum' uses dynamic stack allocation [enabled by default]:  => 400:1
  + fs/btrfs/qgroup.c: warning: 'seq' may be used uninitialized in this function [-Wuninitialized]:  => 1427:6
  + fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 320:1
  + fs/mpage.c: warning: the frame size of 1140 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 651:1
  + include/linux/of_net.h: warning: type qualifiers ignored on function return type:  => 16
  + include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + include/uapi/linux/swab.h: warning: 'type' may be used uninitialized in this function [-Wuninitialized]:  => 60:2
  + kernel/auditfilter.c: warning: this decimal constant is unsigned only in ISO C90 [enabled by default]:  => 426:3
  + kernel/sched/core.c: warning: (near initialization for 'default_topology[0].mask') [enabled by default]:  => 6104:2
  + kernel/sched/core.c: warning: initialization from incompatible pointer type [enabled by default]:  => 6104:2
  + kernel/time/ntp.c: warning: unused variable 'flags' [-Wunused-variable]:  => 877:16
  + mm/slab_common.c: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'unsigned int' [-Wformat]:  => 303:6
  + modpost: WARNING: modpost: Found 8 section mismatch(es).:  => N/A
  + net/bluetooth/hidp/core.c: warning: 'session' may be used uninitialized in this function [-Wuninitialized]:  => 1298:18
  + net/ceph/messenger.c: warning: 'new_piece' may be used uninitialized in this function [-Wuninitialized]:  => 1144:2
  + net/rds/iw_rdma.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 200:1
  + net/rfkill/rfkill-regulator.c: warning: ignoring return value of 'regulator_enable', declared with attribute warn_unused_result [-Wunused-result]:  => 43:20
  + sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function [-Wuninitialized]:  => 962:27
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 2857:21
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 2854:28
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.lambda' may be used uninitialized in this function [-Wuninitialized]:  => 2861:15
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 2862:15
  + sound/soc/codecs/wm8962.c: warning: 'fll_div.theta' may be used uninitialized in this function [-Wuninitialized]:  => 2860:15
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 535:29
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 534:29
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 536:15
  + sound/soc/codecs/wm8993.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 540:20
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 2073:56
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_loop_gain' may be used uninitialized in this function [-Wuninitialized]:  => 2080:42
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 2073:28
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.fll_ref_freq' may be used uninitialized in this function [-Wuninitialized]:  => 2057:30
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.lambda' may be used uninitialized in this function [-Wuninitialized]:  => 2083:15
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 2080:19
  + sound/soc/codecs/wm8996.c: warning: 'fll_div.theta' may be used uninitialized in this function [-Wuninitialized]:  => 2076:15
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.fll_clk_ref_div' may be used uninitialized in this function [-Wuninitialized]:  => 624:34
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.fll_fratio' may be used uninitialized in this function [-Wuninitialized]:  => 615:28
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.fll_outdiv' may be used uninitialized in this function [-Wuninitialized]:  => 614:28
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 616:15
  + sound/soc/codecs/wm9081.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 620:20
  + warning: (ARM_GIC && ARM_VIC && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS):  => N/A
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
  + warning: (DRM_RADEON && DRM_I915 && DRM_GMA500 && DRM_TILCDC && FB_BACKLIGHT && USB_APPLEDISPLAY && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI && EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT):  => N/A
  + warning: (FSL_SOC) selects HAVE_CAN_FLEXCAN which has unmet direct dependencies (NET && CAN && CAN_DEV):  => N/A
  + warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB && USB_EHCI_HCD):  => N/A
  + warning: (RADIO_SI476X) selects SND_SOC_SI476X which has unmet direct dependencies (SOUND && !M68K && !UML && SND && SND_SOC):  => N/A
  + warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (HAVE_KVM):  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22f7a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33091:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22f7a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33094:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22fe6): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33091:  => N/A
  + warning: arch/powerpc/kernel/built-in.o(.text+0x22fe6): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33094:  => N/A
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
  + warning: vmlinux.o(.data+0x3fa84): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fb24): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fc7c): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x3fd80): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3fde0): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3fe40): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x3feac): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x40050): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: vmlinux.o(.meminit.text+0x15bc): Section mismatch in reference from the function .free_area_init_core.isra.38() to the function .init.text:.set_pageblock_order():  => N/A
  + warning: vmlinux.o(.text+0x150b786): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x150b796): Section mismatch in reference from the function .ps3fb_probe() to the variable .init.data:ps3fb_fix:  => N/A
  + warning: vmlinux.o(.text+0x1ad4d8): Section mismatch in reference from the function pwmchip_add() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x1b160c): Section mismatch in reference from the function pci_scan_child_bus() to the function .init.text:pcibios_fixup_bus():  => N/A
  + warning: vmlinux.o(.text+0x2ecd8): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2ed1a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33091:  => N/A
  + warning: vmlinux.o(.text+0x2ed86): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33091:  => N/A
  + warning: vmlinux.o(.text+0x2edf8): Section mismatch in reference from the function .early_setup_secondary() to the function .cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2ee3a): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33094:  => N/A
  + warning: vmlinux.o(.text+0x2eea6): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33094:  => N/A
  + warning: vmlinux.o(.text+0x37280): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x373a0): Section mismatch in reference from the function .rtas_cpu_state_change_mask() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x3eec): Section mismatch in reference from the function pgd_ctor() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x4a2f): Section mismatch in reference from the function iss_net_setup() to the function .init.text:__alloc_bootmem():  => N/A
  + warning: vmlinux.o(.text+0x5827c): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x598a8): Section mismatch in reference from the function .wake_offline_cpus() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x685f0): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x69c30): Section mismatch in reference from the function .update_cpu_topology() to the function .cpuinit.text:.vdso_getcpu_init():  => N/A
  + warning: vmlinux.o(.text+0x9a34c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0x9c48c): Section mismatch in reference from the function .pnv_pci_init_ioda2_phb() to the function .init.text:.pnv_pci_init_ioda_phb():  => N/A
  + warning: vmlinux.o(.text+0xa4628): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0xa6768): Section mismatch in reference from the function .dlpar_online_cpu() to the function .cpuinit.text:.cpu_up():  => N/A

160 improvements:
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
  - drivers/mtd/chips/cfi_cmdset_0001.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 1700:9 => 
  - drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1444 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 420:1 => 
  - drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20, 127:2 => 
  - drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /scratch/kisskb/src/include/pcmcia/ds.h:201) [-Wdeprecated-declarations]: 625:3 => 
  - drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_resume' defined but not used [-Wunused-function]: 773:12 => 
  - drivers/net/ethernet/wiznet/w5100.c: warning: 'w5100_suspend' defined but not used [-Wunused-function]: 758:12 => 
  - drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_resume' defined but not used [-Wunused-function]: 685:12 => 
  - drivers/net/ethernet/wiznet/w5300.c: warning: 'w5300_suspend' defined but not used [-Wunused-function]: 670:12 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'desc' may be used uninitialized in this function [-Wuninitialized]: 1145:9 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'desc2' may be used uninitialized in this function [-Wuninitialized]: 1143:9 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_resume' defined but not used [-Wunused-function]: 205:12 => 
  - drivers/net/wireless/mwifiex/pcie.c: warning: 'mwifiex_pcie_suspend' defined but not used [-Wunused-function]: 170:12 => 
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
  - drivers/tty/pty.c: warning: 'pty_unix98_shutdown' defined but not used [-Wunused-function]: 409:13 => 
  - drivers/tty/rocket.c: warning: 'rmSpeakerReset' defined but not used [-Wunused-function]: 3140:13 => 
  - drivers/tty/rocket.c: warning: 'sPCIInitController' defined but not used [-Wunused-function]: 2599:12 => 
  - drivers/usb/host/ehci-q.c: warning: 'unlink_empty_async_suspended' defined but not used [-Wunused-function]: 1320:13 => 
  - drivers/usb/musb/musb_core.c: warning: unused variable 'ctrl_base' [-Wunused-variable]: 2036:16 => 
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
  - include/linux/mtd/map.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 279:4, 349:2, 332:11, 324:17, 278:6, 397:11, 367:14, 290:22, 414:2 => 279:4, 349:2, 332:11, 278:6, 397:11, 367:14, 414:2
  - include/linux/thermal.h: warning: 'thermal_generate_netlink_event' defined but not used [-Wunused-function]: 254:12 => 
  - kernel/seccomp.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 453:15 => 
  - kernel/seccomp.c: warning: control reaches end of non-void function [-Wreturn-type]: 112:1 => 
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
  - warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet direct dependencies (COMPAT && BINFMT_ELF): N/A => 
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
