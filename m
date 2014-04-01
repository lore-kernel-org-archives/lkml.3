Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaDAH6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:58:05 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:51640 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaDAH6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:58:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.14
Date: Tue,  1 Apr 2014 09:57:58 +0200
Message-Id: <1396339078-22125-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.14[1] compared to v3.13[2].

Summarized:
  - build errors: +4/-32
  - build warnings: +103/-82

JFYI, when comparing v3.14[1]  to v3.14-rc8[3], the summaries are:
  - build errors: +2/-10
  - build warnings: +29/-22

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.14.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7320/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7082/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7303/ (all 119 configs)


*** ERRORS ***

4 regressions:
  + /scratch/kisskb/src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1312
  + error: No rule to make target include/config/auto.conf:  => N/A
  + error: initramfs.c: undefined reference to `__stack_chk_guard':  => .init.text+0x1067)
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8:  => (.text+0x9c2)

32 improvements:
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'dmac_resource.end'): 87:2 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'dmac_resource.start'): 86:2 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[0].end'): 69:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[0].start'): 68:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[1].end'): 74:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'epbr_resources[1].start'): 73:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[0].end'): 50:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[0].start'): 49:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[1].end'): 55:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'femi_resources[1].start'): 54:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[0].end'): 100:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[0].start'): 99:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[1].end'): 105:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: (near initialization for 'pbr_resources[1].start'): 104:3 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: braced-group within expression allowed only inside a function: 30:12, 73:12, 31:10, 99:12, 68:12, 36:10, 86:11, 54:12, 74:10, 55:10, 104:12, 49:12, 69:10, 87:9, 105:10, 35:12, 50:10, 100:10 => 
  - /scratch/kisskb/src/arch/sh/drivers/superhyway/ops-sh4-202.c: error: initializer element is not constant: 74:3, 86:2, 55:3, 105:3, 73:3, 68:3, 100:3, 104:3, 99:3, 87:2, 50:3, 69:3, 49:3, 54:3 => 
  - /scratch/kisskb/src/arch/sh/kernel/kgdb.c: error: 'SIGTRAP' undeclared (first use in this function): 310:27 => 
  - /scratch/kisskb/src/arch/sh/kernel/kgdb.c: error: dereferencing pointer to incomplete type: 243:22, 242:23 => 
  - /scratch/kisskb/src/arch/sh/kernel/kgdb.c: error: implicit declaration of function 'task_stack_page' [-Werror=implicit-function-declaration]: 225:32 => 
  - /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function): 99:17 => 
  - /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]: 192:2 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]: 164:3 => 
  - /scratch/kisskb/src/drivers/staging/speakup/speakup_dtlk.c: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]: 362:2 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]: 363:1 => 
  - /scratch/kisskb/src/include/linux/omap-dma.h: error: expected identifier before numeric constant: 171:8 => 
  - /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - <stdin>: error: -mcall-aixdesc must be big endian: 1:0 => 
  - error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.printk' defined in .text.unlikely section in kernel/built-in.o: (.text+0x1ffa5f4), (.text+0x1ffa634), (.text+0x1ff8e2c), (.text+0x1ffa674), (.text+0x1ffa5b0), (.text+0x1ff8c90), (.text+0x1ff99d8), (.text+0x1ffa6b4), (.text+0x1ffa6f8) => 
  - error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff997c) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b8c: (.text+0x986) => 


*** WARNINGS ***

103 regressions:
  + /scratch/kisskb/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]:  => 63:2
  + /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]:  => 39:0
  + /scratch/kisskb/src/drivers/base/topology.c: warning: unused variable 'cpu' [-Wunused-variable]:  => 86:1, 83:1
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]:  => 511:17
  + /scratch/kisskb/src/drivers/gpio/gpio-bt8xx.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 243:17
  + /scratch/kisskb/src/drivers/gpio/gpio-intel-mid.c: warning: 'intel_gpio_runtime_idle' defined but not used [-Wunused-function]:  => 395:12
  + /scratch/kisskb/src/drivers/gpio/gpio-sch311x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 286:18
  + /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio':  => 204
  + /scratch/kisskb/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 697:1
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 542:3, 551:3
  + /scratch/kisskb/src/drivers/md/bcache/bset.c: warning: format '%li' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat]:  => 27:10
  + /scratch/kisskb/src/drivers/md/md.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]:  => 1351:3, 1056:3
  + /scratch/kisskb/src/drivers/media/media-entity.c: warning: 'media_entity_pipeline_start' uses dynamic stack allocation [enabled by default]:  => 322:1
  + /scratch/kisskb/src/drivers/media/usb/pwc/pwc-if.c: warning: label 'err_video_unreg' defined but not used [-Wunused-label]:  => 1105:1
  + /scratch/kisskb/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 164:17, 181:17
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_resume' defined but not used [-Wunused-function]:  => 2040:12
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_suspend' defined but not used [-Wunused-function]:  => 2023:12
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 303:11, 307:11
  + /scratch/kisskb/src/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 467:46
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ef10.c: warning: 'efx_ef10_free_vis' uses dynamic stack allocation [enabled by default]:  => 295:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: '_efx_mcdi_rpc_finish' uses dynamic stack allocation [enabled by default]:  => 617:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_complete_async' uses dynamic stack allocation [enabled by default]:  => 468:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/mcdi.c: warning: 'efx_mcdi_read_assertion' uses dynamic stack allocation [enabled by default]:  => 1425:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_disable' uses dynamic stack allocation [enabled by default]:  => 614:1
  + /scratch/kisskb/src/drivers/net/ethernet/sfc/ptp.c: warning: 'efx_ptp_enable' uses dynamic stack allocation [enabled by default]:  => 591:1
  + /scratch/kisskb/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_resume' defined but not used [-Wunused-function]:  => 300:12
  + /scratch/kisskb/src/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: warning: 'stmmac_pltfr_suspend' defined but not used [-Wunused-function]:  => 286:12
  + /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_resume' defined but not used [-Wunused-function]:  => 2060:12
  + /scratch/kisskb/src/drivers/platform/x86/acer-wmi.c: warning: 'acer_suspend' defined but not used [-Wunused-function]:  => 2038:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]:  => 4375:17
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_conf.h: warning: "IO_FIELD" redefined [enabled by default]  LD [M]  net/sunrpc/sunrpc.o:  => 165:0
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 961:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 658:1
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1615:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1615:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: right shift count >= width of type [enabled by default]:  => 1615:6
  + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 773:18
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]:  => 670:17
  + /scratch/kisskb/src/drivers/video/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /scratch/kisskb/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 809:11
  + /scratch/kisskb/src/drivers/video/intelfb/intelfbdrv.c: warning: passing argument 3 of 'get_opt_bool' from incompatible pointer type [enabled by default]:  => 367:3, 361:3, 357:3, 363:3, 365:3
  + /scratch/kisskb/src/drivers/video/intelfb/intelfbhw.c: warning: 'm1' may be used uninitialized in this function [-Wuninitialized]:  => 1015:2
  + /scratch/kisskb/src/drivers/video/intelfb/intelfbhw.c: warning: 'm2' may be used uninitialized in this function [-Wuninitialized]:  => 1015:2
  + /scratch/kisskb/src/drivers/video/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/video/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set [-Wcpp]:  => 64:2
  + /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: #warning sisfb will not work! [-Wcpp]:  => 65:2
  + /scratch/kisskb/src/drivers/video/sis/sis_main.c: warning: 'sisfb_post_map_vram' defined but not used [-Wunused-function]:  => 4131:13
  + /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /scratch/kisskb/src/drivers/video/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /scratch/kisskb/src/fs/autofs4/inode.c: warning: 'pgrp' may be used uninitialized in this function:  => 213
  + /scratch/kisskb/src/fs/btrfs/hash.c: warning: 'btrfs_crc32c' uses dynamic stack allocation [enabled by default]:  => 50:1
  + /scratch/kisskb/src/fs/ceph/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 75:7
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: '__next_free_blkoff' uses dynamic stack allocation [enabled by default]:  => 683:1
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: 'add_discard_addrs' uses dynamic stack allocation [enabled by default]:  => 318:1
  + /scratch/kisskb/src/fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 625:1
  + /scratch/kisskb/src/fs/ncpfs/ncp_fs_sb.h: warning: 'packed' attribute ignored for field of type '__u32' [-Wattributes]  CC [M]  net/sunrpc/auth_unix.o:  => 124:4
  + /scratch/kisskb/src/fs/posix_acl.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 34:1
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'vf' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/kernel/trace/ftrace.c: warning: 'control_ops_free' defined but not used [-Wunused-function]:  => 240:13
  + /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.11' uses dynamic stack allocation [enabled by default]:  => 744:1
  + /scratch/kisskb/src/mm/percpu.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]:  => 1693:3
  + /scratch/kisskb/src/net/ceph/osdmap.c: warning: 'crush_do_rule_ary' uses dynamic stack allocation [enabled by default]:  => 1153:1
  + /scratch/kisskb/src/net/core/neighbour.c: warning: 'p_name' may be used uninitialized in this function [-Wuninitialized]:  => 3094:10
  + /scratch/kisskb/src/net/sunrpc/xprtrdma/verbs.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1774:1
  + /scratch/kisskb/src/scripts/kconfig/menu.c: warning: 'jump' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 587:18
  + /scratch/kisskb/src/sound/soc/codecs/wm8993.c: warning: unused variable 'wm8993' [-Wunused-variable]:  => 1562:22
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: right shift count >= width of type [enabled by default]:  => 972:3
  + <stdin>: warning: #warning syscall sched_getattr not implemented [-Wcpp]:  => 1229:2
  + <stdin>: warning: #warning syscall sched_getattr not implemented:  => 1229:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented [-Wcpp]:  => 1226:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented:  => 1226:2
  + warning: (BRIDGE_NF_EBTABLES) selects NETFILTER_XTABLES which has unmet direct dependencies (NET && INET && NETFILTER):  => N/A
  + warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM):  => N/A
  + warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME):  => N/A
  + warning: drivers/built-in.o(.data+0x1034): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb08): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc64): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2b4db0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x54668): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d8c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3f6a4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x40008): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x400a8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40204): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4030c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4036c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x403cc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4042c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x405d4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

82 improvements:
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence: 89 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence: 208 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence: 373, 376 => 376
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence: 349, 347 => 
  - /scratch/kisskb/src/arch/x86/kvm/../../../virt/kvm/vfio.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 104:22 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-mcp23s08.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 643:10 => 
  - /scratch/kisskb/src/drivers/gpu/drm/gma500/backlight.c: warning: 'do_gma_backlight_set' defined but not used [-Wunused-function]: 29:13 => 
  - /scratch/kisskb/src/drivers/gpu/drm/i915/i915_debugfs.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 2393:2 => 
  - /scratch/kisskb/src/drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 79:25 => 
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'mask' may be used uninitialized in this function [-Wuninitialized]: 121:41, 197:47 => 120:41
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]: 121:17, 197:23 => 120:17
  - /scratch/kisskb/src/drivers/leds/leds-mc13783.c: warning: 'shift' may be used uninitialized in this function [-Wuninitialized]: 198:22, 121:57 => 120:57
  - /scratch/kisskb/src/drivers/leds/leds-pwm.c: warning: unused variable 'node' [-Wunused-variable]: 88:22 => 
  - /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]: 416:18 => 
  - /scratch/kisskb/src/drivers/mfd/max8997.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 182:10 => 
  - /scratch/kisskb/src/drivers/mfd/max8998.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 178:10 => 
  - /scratch/kisskb/src/drivers/mfd/tps65217.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 173:13 => 
  - /scratch/kisskb/src/drivers/mfd/wm8994-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 639:19 => 
  - /scratch/kisskb/src/drivers/mtd/devices/docg3.c: warning: unused variable 'base' [-Wunused-variable]: 2122:16 => 
  - /scratch/kisskb/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - /scratch/kisskb/src/drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20 => 
  - /scratch/kisskb/src/drivers/net/ethernet/broadcom/cnic.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 1521:2, 1479:2, 1506:2, 1491:2 => 
  - /scratch/kisskb/src/drivers/net/ethernet/hp/hp100.c: warning: 'cleanup_dev' defined but not used [-Wunused-function]: 2825:13 => 
  - /scratch/kisskb/src/drivers/net/ethernet/sfc/tx.c: warning: label 'finish_packet' defined but not used [-Wunused-label]: 432:1 => 
  - /scratch/kisskb/src/drivers/net/ethernet/smsc/smc91x.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 1898:7 => 
  - /scratch/kisskb/src/drivers/regulator/ab3100.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 649:4 => 
  - /scratch/kisskb/src/drivers/regulator/tps62360-regulator.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 363:13 => 
  - /scratch/kisskb/src/drivers/rtc/rtc-s5m.c: warning: 's5m_rtc_resume' defined but not used [-Wunused-function]: 642:12 => 
  - /scratch/kisskb/src/drivers/rtc/rtc-s5m.c: warning: 's5m_rtc_suspend' defined but not used [-Wunused-function]: 653:12 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_chip_reset' defined but not used [-Wunused-function]: 8341:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_configure_bugs' defined but not used [-Wunused-function]: 8895:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: 'aic7xxx_load_seeprom' defined but not used [-Wunused-function]: 8496:1 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]: 8517:5, 7901:5 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]: 7898:5, 8510:5 => 
  - /scratch/kisskb/src/drivers/scsi/aic7xxx_old.c: warning: unused variable 'sxfrctl1' [-Wunused-variable]: 8983:17 => 
  - /scratch/kisskb/src/drivers/scsi/bnx2i/bnx2i_iscsi.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 551:2 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_resume' defined but not used [-Wunused-function]: 35:12 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_suspend' defined but not used [-Wunused-function]: 19:12 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 112:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 658:1 => 
  - /scratch/kisskb/src/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c: warning: 'msgsz' may be used uninitialized in this function [-Wuninitialized]: 632:54 => 
  - /scratch/kisskb/src/drivers/staging/lustre/lustre/llite/file.c: warning: 'count' may be used uninitialized in this function [-Wuninitialized]: 987:9, 1046:9 => 
  - /scratch/kisskb/src/drivers/staging/rtl8192e/rtllib_softmac.c: warning: value computed is not used [-Wunused-value]: 924:3 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: 'ehv_bc_console_init' defined but not used [-Wunused-function]: 335:19 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: data definition has no type or storage class [enabled by default]: 363:1 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: parameter names (without types) in function declaration [enabled by default]: 363:1 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_resume' defined but not used [-Wunused-function]: 413:12 => 
  - /scratch/kisskb/src/drivers/tty/serial/8250/8250_dw.c: warning: 'dw8250_suspend' defined but not used [-Wunused-function]: 404:12 => 
  - /scratch/kisskb/src/drivers/tty/serial/sh-sci.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 560:23 => 
  - /scratch/kisskb/src/fs/compat_binfmt_elf.c: warning: 'cputime_to_compat_timeval' defined but not used [-Wunused-function]: 58:13 => 
  - /scratch/kisskb/src/fs/sysfs/file.c: warning: unused variable 'kobj' [-Wunused-variable]: 610:18 => 
  - /scratch/kisskb/src/include/linux/posix_acl.h: warning: control reaches end of non-void function [-Wreturn-type]: 108:1 => 
  - /scratch/kisskb/src/kernel/trace/ring_buffer.c: warning: unused variable 'local_clock_stable' [-Wunused-variable]: 2559:8 => 
  - /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.10' uses dynamic stack allocation [enabled by default]: 744:1 => 
  - /scratch/kisskb/src/net/netfilter/ipvs/ip_vs_sync.c: warning: unused variable 'ret' [-Wunused-variable]: 1640:8 => 
  - /scratch/kisskb/src/sound/soc/dwc/designware_i2s.c: warning: "CCR" redefined [enabled by default]: 31:0 => 
  - modpost: WARNING: modpost: Found 4 section mismatch(es).: N/A => 
  - warning: (PPC_CELL_NATIVE && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: drivers/built-in.o(.data+0xa08): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xaa8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xc04): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xd0c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: drivers/built-in.o(.data+0xfd4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d78): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x3ebdc): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/usb/gadget/g_audio.o(.text.unlikely+0x114): Section mismatch in reference from the function audio_bind_config() to the function .init.text:afunc_bind(): N/A => 
  - warning: vmlinux.o(.data+0x404c8): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40568): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x406c4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x407cc): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4082c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4088c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x408ec): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40a94): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
