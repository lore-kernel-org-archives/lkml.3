Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCFLRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:17:44 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:57779 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaCFLRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:17:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.14-rc5
Date: Thu,  6 Mar 2014 12:17:36 +0100
Message-Id: <1394104657-8495-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.14-rc5[1] compared to v3.13[2].

Summarized:
  - build errors: +6/-29
  - build warnings: +243/-80

JFYI, when comparing v3.14-rc5[1]  to v3.14-rc4[3], the summaries are:
  - build errors: +2/-3
  - build warnings: +121/-76

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.14-rc5.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7236/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7082/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7212/ (all 119 configs)


*** ERRORS ***

6 regressions:
  + /scratch/kisskb/src/arch/powerpc/kernel/exceptions-64s.S: Error: attempt to move .org backwards:  => 1312
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: error: 'ffsusb_func' undeclared (first use in this function):  => 2693:1
  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: No rule to make target include/config/auto.conf:  => N/A
  + error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+bc8:  => (.text+0x9c2)

29 improvements:
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
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/das6402.c: error: implicit declaration of function 'outw_p' [-Werror=implicit-function-declaration]: 164:3 => 
  - /scratch/kisskb/src/drivers/staging/speakup/speakup_dtlk.c: error: implicit declaration of function 'inw_p' [-Werror=implicit-function-declaration]: 362:2 => 
  - /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]: 363:1 => 
  - /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc must be big endian: 1:0 => 
  - <stdin>: error: -mcall-aixdesc must be big endian: 1:0 => 
  - error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.printk' defined in .text.unlikely section in kernel/built-in.o: (.text+0x1ffa5f4), (.text+0x1ffa634), (.text+0x1ff8e2c), (.text+0x1ffa674), (.text+0x1ffa5b0), (.text+0x1ff8c90), (.text+0x1ff99d8), (.text+0x1ffa6b4), (.text+0x1ffa6f8) => 
  - error: nsc-ircc.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_25' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff997c) => 
  - error: vsprintf.c: relocation truncated to fit: R_AVR32_9UW_PCREL against `.text'+b8c: (.text+0x986) => 


*** WARNINGS ***

243 regressions:
  + /scratch/kisskb/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]:  => 63:2
  + /scratch/kisskb/src/arch/cris/include/arch-v10/arch/system.h: warning: "nop" redefined [enabled by default]:  => 39:0
  + /scratch/kisskb/src/arch/mips/include/asm/compat.h: warning: 'rtdev' may be used uninitialized in this function [-Wuninitialized]  CC      kernel/irq/irqdesc.o:  => 208:24
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event_amd_ibs.c: warning: 'config' may be used uninitialized in this function [-Wuninitialized]:  => 268:11
  + /scratch/kisskb/src/arch/x86/kernel/vsyscall_64.c: warning: 'syscall_nr' may be used uninitialized in this function [-Wuninitialized]:  => 261:16
  + /scratch/kisskb/src/block/blk-merge.c: warning: 'bbio' may be used uninitialized in this function [-Wuninitialized]:  => 74:2
  + /scratch/kisskb/src/block/bsg.c: warning: 'rw' may be used uninitialized in this function [-Wuninitialized]:  => 280:2
  + /scratch/kisskb/src/crypto/async_tx/async_tx.c: warning: 'chan' may be used uninitialized in this function [-Wuninitialized]:  => 258:18
  + /scratch/kisskb/src/drivers/ata/libata-scsi.c: warning: 'dev' may be used uninitialized in this function [-Wuninitialized]:  => 3720:3
  + /scratch/kisskb/src/drivers/ata/libata-scsi.c: warning: 'last_failed_dev' may be used uninitialized in this function [-Wuninitialized]:  => 3720:3
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 607:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2181:9, 1799:6
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_len' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_offset' may be used uninitialized in this function [-Wuninitialized]:  => 514:18
  + /scratch/kisskb/src/drivers/block/nvme-core.c: warning: 'bvprv.bv_page' may be used uninitialized in this function [-Wuninitialized]:  => 511:17
  + /scratch/kisskb/src/drivers/block/rbd.c: warning: 'image_id' may be used uninitialized in this function [-Wuninitialized]:  => 4733:27
  + /scratch/kisskb/src/drivers/block/virtio_blk.c: warning: 'blk_size' may be used uninitialized in this function [-Wuninitialized]:  => 619:31
  + /scratch/kisskb/src/drivers/block/virtio_blk.c: warning: 'v' may be used uninitialized in this function [-Wuninitialized]:  => 610:29
  + /scratch/kisskb/src/drivers/block/virtio_blk.c: warning: 'writeback' may be used uninitialized in this function [-Wuninitialized]:  => 416:2
  + /scratch/kisskb/src/drivers/char/raw.c: warning: 'dev' may be used uninitialized in this function [-Wuninitialized]:  => 231:20
  + /scratch/kisskb/src/drivers/gpio/gpio-sch311x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]:  => 286:18
  + /scratch/kisskb/src/drivers/gpio/gpio-wm831x.c: warning: 'powerdomain' may be used uninitialized in this function [-Wuninitialized]:  => 217:13
  + /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio' [-Wunused-variable]:  => 204:12
  + /scratch/kisskb/src/drivers/gpio/gpiolib.c: warning: unused variable 'gpio':  => 204
  + /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 471:4
  + /scratch/kisskb/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 697:1
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]:  => 2534:3
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 2956:30
  + /scratch/kisskb/src/drivers/gpu/drm/radeon/radeon_ttm.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 938:22
  + /scratch/kisskb/src/drivers/gpu/drm/udl/udl_modeset.c: warning: 'reg' may be used uninitialized in this function [-Wuninitialized]:  => 28:9
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]:  => 393:18
  + /scratch/kisskb/src/drivers/md/bcache/alloc.c: warning: 'bucket' may be used uninitialized in this function [-Wuninitialized]:  => 373:4
  + /scratch/kisskb/src/drivers/md/bcache/bset.c: warning: format '%li' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat]:  => 27:10
  + /scratch/kisskb/src/drivers/md/dm-ioctl.c: warning: 'ioctl_flags' may be used uninitialized in this function [-Wuninitialized]:  => 1845:2
  + /scratch/kisskb/src/drivers/md/persistent-data/dm-array.c: warning: 'ab' may be used uninitialized in this function [-Wuninitialized]:  => 350:13
  + /scratch/kisskb/src/drivers/md/persistent-data/dm-space-map-common.c: warning: 'position' may be used uninitialized in this function [-Wuninitialized]:  => 380:41
  + /scratch/kisskb/src/drivers/md/raid5.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]: 1189:2 => 1189:2, 1193:8
  + /scratch/kisskb/src/drivers/media/media-entity.c: warning: 'media_entity_pipeline_start' uses dynamic stack allocation [enabled by default]:  => 322:1
  + /scratch/kisskb/src/drivers/media/v4l2-core/videobuf2-core.c: warning: 'buffer' may be used uninitialized in this function [-Wuninitialized]:  => 2034:5
  + /scratch/kisskb/src/drivers/media/v4l2-core/videobuf2-core.c: warning: 'plane' may be used uninitialized in this function [-Wuninitialized]:  => 2048:8
  + /scratch/kisskb/src/drivers/mfd/da903x.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 185:2, 229:2, 207:2, 230:11, 186:11, 208:11
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 323:5 => 295:5, 295:2
  + /scratch/kisskb/src/drivers/misc/bh1770glc.c: warning: 'mode' may be used uninitialized in this function [-Wuninitialized]:  => 236:29
  + /scratch/kisskb/src/drivers/misc/vmw_balloon.c: warning: 'hv_status' may be used uninitialized in this function [-Wuninitialized]:  => 437:4
  + /scratch/kisskb/src/drivers/misc/vmw_balloon.c: warning: 'target' may be used uninitialized in this function [-Wuninitialized]:  => 672:8
  + /scratch/kisskb/src/drivers/mtd/maps/latch-addr-flash.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]:  => 53:2
  + /scratch/kisskb/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 164:17, 181:17
  + /scratch/kisskb/src/drivers/mtd/sm_ftl.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 1094:2
  + /scratch/kisskb/src/drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 407:9
  + /scratch/kisskb/src/drivers/net/bonding/bond_3ad.c: warning: 'new_aggregator' may be used uninitialized in this function [-Wuninitialized]:  => 1950:4
  + /scratch/kisskb/src/drivers/net/bonding/bond_netlink.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 212:3
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_resume' defined but not used [-Wunused-function]:  => 2030:12
  + /scratch/kisskb/src/drivers/net/ethernet/cadence/macb.c: warning: 'macb_suspend' defined but not used [-Wunused-function]:  => 2013:12
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
  + /scratch/kisskb/src/drivers/net/macvtap.c: warning: 'linear' may be used uninitialized in this function [-Wuninitialized]:  => 532:2
  + /scratch/kisskb/src/drivers/net/plip/plip.c: warning: 'lbuf' may be used uninitialized in this function [-Wuninitialized]:  => 825:4
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'en_term' may be used uninitialized in this function [-Wuninitialized]:  => 624:27
  + /scratch/kisskb/src/drivers/power/bq24190_charger.c: warning: 'force_20pct' may be used uninitialized in this function [-Wuninitialized]:  => 617:27
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]:  => 693:12
  + /scratch/kisskb/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]:  => 724:13
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 213:17, 184:21, 200:21, 160:21, 144:20, 172:12, 115:16
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 137:19
  + /scratch/kisskb/src/drivers/regulator/s2mps11.c: warning: 'ramp_shift' may be used uninitialized in this function [-Wuninitialized]:  => 208:27
  + /scratch/kisskb/src/drivers/regulator/tps80031-regulator.c: warning: 'smps_mult' may be used uninitialized in this function [-Wuninitialized]:  => 653:33
  + /scratch/kisskb/src/drivers/regulator/tps80031-regulator.c: warning: 'smps_offset' may be used uninitialized in this function [-Wuninitialized]:  => 652:34
  + /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]:  => 4375:17
  + /scratch/kisskb/src/drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in this function [-Wuninitialized]:  => 4612:2
  + /scratch/kisskb/src/drivers/scsi/sg.c: warning: 'sdp' may be used uninitialized in this function [-Wuninitialized]:  => 841:3, 430:12
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 7 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: format '%x' expects argument of type 'unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 1246:3
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 961:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 112:1 => 164:1, 103:1
  + /scratch/kisskb/src/drivers/staging/dgap/dgap_tty.c: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 658:1
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 1615:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 1615:6
  + /scratch/kisskb/src/drivers/staging/iio/adc/mxs-lradc.c: warning: right shift count >= width of type [enabled by default]:  => 1615:6
  + /scratch/kisskb/src/drivers/staging/lustre/lnet/lnet/acceptor.c: warning: 'secure' may be used uninitialized in this function [-Wuninitialized]:  => 467:16
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/lov/../include/lustre_log.h: warning: 'lop' may be used uninitialized in this function [-Wuninitialized]:  => 539:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/lov/lov_pack.c: warning: 'lmm_magic' may be used uninitialized in this function [-Wuninitialized]:  => 466:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/../include/lustre_log.h: warning: 'lop' may be used uninitialized in this function [-Wuninitialized]:  => 504:2, 522:2, 486:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/llog.c: warning: 'lop' may be used uninitialized in this function [-Wuninitialized]:  => 179:2, 627:10, 652:10, 684:10, 882:2, 605:10, 582:2
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/mea.c: warning: 'idx' may be used uninitialized in this function [-Wuninitialized]:  => 73:3
  + /scratch/kisskb/src/drivers/staging/lustre/lustre/obdclass/obd_config.c: warning: 'var' may be used uninitialized in this function [-Wuninitialized]:  => 1288:4
  + /scratch/kisskb/src/drivers/staging/wlags49_h25/../wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_off' which is not static [enabled by default]:  => 1035:2
  + /scratch/kisskb/src/drivers/staging/wlags49_h25/../wlags49_h2/wl_internal.h: warning: '______f' is static but declared in inline function 'wl_act_int_on' which is not static [enabled by default]:  => 1023:2
  + /scratch/kisskb/src/drivers/target/target_core_alua.c: warning: 'alua_ascq' may be used uninitialized in this function [-Wuninitialized]:  => 773:18
  + /scratch/kisskb/src/drivers/tty/n_gsm.c: warning: unused variable 'buf' [-Wunused-variable]:  => 2279:7
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 269:6
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'data_len' may be used uninitialized in this function [-Wuninitialized]:  => 670:17
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'kernel_ffsusb_func' defined but not used [-Wunused-variable]:  => 2693:1
  + /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 2693:1
  + /scratch/kisskb/src/drivers/usb/serial/mos7720.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 1302:3, 1334:3
  + /scratch/kisskb/src/drivers/video/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /scratch/kisskb/src/drivers/w1/slaves/w1_therm.c: warning: 'verdict' may be used uninitialized in this function [-Wuninitialized]:  => 255:2
  + /scratch/kisskb/src/fs/autofs4/inode.c: warning: 'pgrp' may be used uninitialized in this function:  => 213
  + /scratch/kisskb/src/fs/btrfs/ctree.h: warning: 'ref_root' may be used uninitialized in this function [-Wuninitialized]: 4012:6 => 4073:6, 4072:2
  + /scratch/kisskb/src/fs/btrfs/hash.c: warning: 'btrfs_crc32c' uses dynamic stack allocation [enabled by default]:  => 50:1
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'disk_num_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1326:23
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in this function [-Wuninitialized]: 1271:6 => 1150:6, 1291:6
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'extent_offset' may be used uninitialized in this function [-Wuninitialized]:  => 1322:38
  + /scratch/kisskb/src/fs/btrfs/inode.c: warning: 'ram_bytes' may be used uninitialized in this function [-Wuninitialized]:  => 1327:18
  + /scratch/kisskb/src/fs/btrfs/qgroup.c: warning: 'sgn' may be used uninitialized in this function [-Wuninitialized]: 1270:20, 1462:6 => 1447:6, 1268:20, 1455:6
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'eb' may be used uninitialized in this function [-Wuninitialized]:  => 150:25
  + /scratch/kisskb/src/fs/btrfs/uuid-tree.c: warning: 'offset' may be used uninitialized in this function [-Wuninitialized]:  => 149:21
  + /scratch/kisskb/src/fs/ceph/acl.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 75:7, 75:24
  + /scratch/kisskb/src/fs/ext4/extents.c: warning: 'abut_ex' may be used uninitialized in this function [-Wuninitialized]:  => 3472:21
  + /scratch/kisskb/src/fs/ext4/inode.c: warning: 'retval' may be used uninitialized in this function [-Wuninitialized]: 581:5 => 581:5, 581:2
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: '__next_free_blkoff' uses dynamic stack allocation [enabled by default]:  => 683:1
  + /scratch/kisskb/src/fs/f2fs/segment.c: warning: 'add_discard_addrs' uses dynamic stack allocation [enabled by default]:  => 318:1
  + /scratch/kisskb/src/fs/gfs2/incore.h: warning: 'rs' may be used uninitialized in this function [-Wuninitialized]:  => 119:6
  + /scratch/kisskb/src/fs/hfsplus/unicode.c: warning: 'dsize' may be used uninitialized in this function [-Wuninitialized]:  => 298:5
  + /scratch/kisskb/src/fs/hpfs/alloc.c: warning: 'sec' may be used uninitialized in this function [-Wuninitialized]:  => 202:7
  + /scratch/kisskb/src/fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used [-Wunused-label]:  => 625:1
  + /scratch/kisskb/src/fs/ncpfs/dir.c: warning: unused variable 'sb' [-Wunused-variable]:  => 134:23
  + /scratch/kisskb/src/fs/nfs/blocklayout/blocklayout.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 1111:6
  + /scratch/kisskb/src/fs/nfsd/export.c: warning: 'an_int' may be used uninitialized in this function [-Wuninitialized]:  => 532:15
  + /scratch/kisskb/src/fs/nfsd/nfsctl.c: warning: 'bsize' may be used uninitialized in this function [-Wuninitialized]:  => 869:3
  + /scratch/kisskb/src/fs/nfsd/nfsctl.c: warning: 'newthreads' may be used uninitialized in this function [-Wuninitialized]:  => 436:6
  + /scratch/kisskb/src/fs/nilfs2/recovery.c: warning: 'sum' may be used uninitialized in this function [-Wuninitialized]:  => 909:21, 664:17
  + /scratch/kisskb/src/fs/nilfs2/super.c: warning: 'blocknr' may be used uninitialized in this function [-Wuninitialized]:  => 373:2
  + /scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be used uninitialized in this function [-Wuninitialized]: 214:32 => 139:2, 139:32
  + /scratch/kisskb/src/fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used uninitialized in this function [-Wuninitialized]: 214:17 => 139:2, 139:17
  + /scratch/kisskb/src/fs/ntfs/dir.c: warning: 'bmp_vi' may be used uninitialized in this function [-Wuninitialized]:  => 1430:7
  + /scratch/kisskb/src/fs/ocfs2/suballoc.c: warning: 'bg_bh' may be used uninitialized in this function [-Wuninitialized]:  => 492:2
  + /scratch/kisskb/src/fs/ocfs2/xattr.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2976:2
  + /scratch/kisskb/src/fs/posix_acl.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 34:1
  + /scratch/kisskb/src/fs/reiserfs/bitmap.c: warning: 'next' may be used uninitialized in this function [-Wuninitialized]:  => 236:9
  + /scratch/kisskb/src/fs/xfs/xfs_alloc.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 2153:8
  + /scratch/kisskb/src/fs/xfs/xfs_bmap.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 5024:8, 1570:7, 1515:7
  + /scratch/kisskb/src/fs/xfs/xfs_log_recover.c: warning: 'uuid' may be used uninitialized in this function [-Wuninitialized]:  => 2059:3
  + /scratch/kisskb/src/fs/xfs/xfs_qm_syscalls.c: warning: 'error' may be used uninitialized in this function [-Wuninitialized]:  => 281:7
  + /scratch/kisskb/src/fs/xfs/xfs_rtalloc.c: warning: 'nrblocks' may be used uninitialized in this function [-Wuninitialized]:  => 1045:4
  + /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of '__raw_writew' makes pointer from integer without a cast [enabled by default]  CC      lib/zlib_deflate/deflate.o:  => 221:4
  + /scratch/kisskb/src/include/linux/file.h: warning: '*((void *)&output+8)' may be used uninitialized in this function [-Wuninitialized]:  => 36:2
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 37:7
  + /scratch/kisskb/src/include/linux/list.h: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 643:11
  + /scratch/kisskb/src/include/linux/list_nulls.h: warning: 'node' may be used uninitialized in this function [-Wuninitialized]:  => 35:2
  + /scratch/kisskb/src/include/linux/netfilter.h: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 182:6
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'vf' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/sunrpc/cache.h: warning: 'rv' may be used uninitialized in this function [-Wuninitialized]:  => 295:2
  + /scratch/kisskb/src/ipc/sem.c: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 1671:5
  + /scratch/kisskb/src/ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 2018:26
  + /scratch/kisskb/src/kernel/trace/ftrace.c: warning: 'control_ops_free' defined but not used [-Wunused-function]:  => 240:13
  + /scratch/kisskb/src/kernel/trace/trace_events.c: warning: 'flags' may be used uninitialized in this function [-Wuninitialized]:  => 709:2
  + /scratch/kisskb/src/lib/debugobjects.c: warning: 'obj_states' defined but not used [-Wunused-variable]:  => 73:20
  + /scratch/kisskb/src/lib/debugobjects.c: warning: unused variable 'hint' [-Wunused-variable]:  => 254:9
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: 'delta' may be used uninitialized in this function [-Wuninitialized]:  => 174:20
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add' which is not static [enabled by default]:  => 70:2, 73:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_add_1' which is not static [enabled by default]:  => 45:2, 49:4, 56:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub' which is not static [enabled by default]:  => 113:2, 116:2
  + /scratch/kisskb/src/lib/mpi/mpi-inline.h: warning: '______f' is static but declared in inline function 'mpihelp_sub_1' which is not static [enabled by default]:  => 92:4, 99:2, 88:2
  + /scratch/kisskb/src/lib/swiotlb.c: warning: 'dev_addr' may be used uninitialized in this function [-Wuninitialized]:  => 668:14
  + /scratch/kisskb/src/lib/vsprintf.c: warning: 'resource_string.isra.11' uses dynamic stack allocation [enabled by default]:  => 744:1
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 944:15
  + /scratch/kisskb/src/mm/percpu.c: warning: format '%lx' expects argument of type 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]:  => 1693:3
  + /scratch/kisskb/src/mm/swapfile.c: warning: 'nr_extents' may be used uninitialized in this function [-Wuninitialized]:  => 2269:6
  + /scratch/kisskb/src/net/ceph/osdmap.c: warning: 'crush_do_rule_ary' uses dynamic stack allocation [enabled by default]:  => 1153:1
  + /scratch/kisskb/src/net/core/neighbour.c: warning: 'p_name' may be used uninitialized in this function [-Wuninitialized]:  => 3094:10
  + /scratch/kisskb/src/net/core/skbuff.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 1340:6
  + /scratch/kisskb/src/net/ipv4/inet_connection_sock.c: warning: 'head' may be used uninitialized in this function [-Wuninitialized]:  => 209:2
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'faddr' may be used uninitialized in this function [-Wuninitialized]:  => 183:16
  + /scratch/kisskb/src/net/ipv4/ip_options.c: warning: 'nexthop' may be used uninitialized in this function [-Wuninitialized]:  => 656:16
  + /scratch/kisskb/src/net/ipv4/ip_output.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 299:2
  + /scratch/kisskb/src/net/ipv4/ipconfig.c: warning: 'ic_proto_used' defined but not used [-Wunused-variable]:  => 153:12
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'code' may be used uninitialized in this function [-Wuninitialized]: 450:63, 533:37 => 457:63, 541:9, 540:37
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'icmph' may be used uninitialized in this function [-Wuninitialized]: 487:48, 487:35, 494:29 => 494:2, 501:29, 494:48, 494:35
  + /scratch/kisskb/src/net/ipv4/ping.c: warning: 'type' may be used uninitialized in this function [-Wuninitialized]: 490:2, 664:21, 451:29, 506:3, 545:42 => 497:2, 671:21, 458:29, 513:3, 552:42, 671:2
  + /scratch/kisskb/src/net/ipv4/tcp.c: warning: 'copy' may be used uninitialized in this function [-Wuninitialized]:  => 927:3
  + /scratch/kisskb/src/net/ipv4/udp.c: warning: 'sk' may be used uninitialized in this function [-Wuninitialized]:  => 1904:8
  + /scratch/kisskb/src/net/ipv4/xfrm4_output.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 94:2
  + /scratch/kisskb/src/net/nfc/llcp_core.c: warning: 'sn_len' may be used uninitialized in this function [-Wuninitialized]:  => 801:12
  + /scratch/kisskb/src/net/openvswitch/datapath.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 401:6
  + /scratch/kisskb/src/net/rds/rdma.c: warning: 'iov_size' may be used uninitialized in this function [-Wuninitialized]:  => 697:15
  + /scratch/kisskb/src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 473:3
  + /scratch/kisskb/src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 456:31
  + /scratch/kisskb/src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'tmpobj.data' may be used uninitialized in this function [-Wuninitialized]:  => 124:2
  + /scratch/kisskb/src/net/sunrpc/auth_gss/svcauth_gss.c: warning: 'tmpobj.len' may be used uninitialized in this function [-Wuninitialized]:  => 124:22
  + /scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'gid' may be used uninitialized in this function [-Wuninitialized]:  => 517:19
  + /scratch/kisskb/src/net/sunrpc/svcauth_unix.c: warning: 'id' may be used uninitialized in this function [-Wuninitialized]:  => 495:17
  + /scratch/kisskb/src/scripts/kconfig/menu.c: warning: 'jump' may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 587:18
  + /scratch/kisskb/src/sound/drivers/mpu401/mpu401_uart.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:6, 290:6
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'bclk' may be used uninitialized in this function [-Wuninitialized]:  => 1218:26
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'ratio' may be used uninitialized in this function [-Wuninitialized]:  => 1455:34
  + /scratch/kisskb/src/sound/soc/codecs/da7210.c: warning: 'pll_div1' may be used uninitialized in this function [-Wuninitialized]:  => 1023:15
  + /scratch/kisskb/src/sound/soc/codecs/da7210.c: warning: 'pll_div2' may be used uninitialized in this function [-Wuninitialized]:  => 1024:15
  + /scratch/kisskb/src/sound/soc/codecs/da7210.c: warning: 'pll_div3' may be used uninitialized in this function [-Wuninitialized]:  => 1025:21
  + /scratch/kisskb/src/sound/soc/codecs/da9055.c: warning: 'pll_frac_bot' may be used uninitialized in this function [-Wuninitialized]:  => 1317:15
  + /scratch/kisskb/src/sound/soc/codecs/da9055.c: warning: 'pll_frac_top' may be used uninitialized in this function [-Wuninitialized]:  => 1316:15
  + /scratch/kisskb/src/sound/soc/codecs/da9055.c: warning: 'pll_integer' may be used uninitialized in this function [-Wuninitialized]:  => 1318:15
  + /scratch/kisskb/src/sound/soc/codecs/wm2200.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 1925:32
  + /scratch/kisskb/src/sound/soc/codecs/wm5100.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 1735:32
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.div' may be used uninitialized in this function [-Wuninitialized]:  => 1060:28
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.k' may be used uninitialized in this function [-Wuninitialized]:  => 1064:15
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.n' may be used uninitialized in this function [-Wuninitialized]:  => 1063:13
  + /scratch/kisskb/src/sound/soc/codecs/wm8350.c: warning: 'fll_div.ratio' may be used uninitialized in this function [-Wuninitialized]:  => 1069:54
  + /scratch/kisskb/src/sound/soc/codecs/wm8962.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 2794:32
  + /scratch/kisskb/src/sound/soc/codecs/wm8978.c: warning: 'diff' may be used uninitialized in this function [-Wuninitialized]: 814:5 => 814:2, 814:5
  + /scratch/kisskb/src/sound/soc/codecs/wm8993.c: warning: unused variable 'wm8993' [-Wunused-variable]:  => 1562:22
  + /scratch/kisskb/src/sound/soc/codecs/wm8996.c: warning: 'fratio' may be used uninitialized in this function [-Wuninitialized]:  => 1986:32
  + /scratch/kisskb/src/sound/soc/codecs/wm9081.c: warning: 'new_sysclk' may be used uninitialized in this function [-Wuninitialized]:  => 704:23
  + /scratch/kisskb/src/sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used uninitialized in this function [-Wuninitialized]:  => 325:11
  + /scratch/kisskb/src/sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used uninitialized in this function [-Wuninitialized]:  => 324:11
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: right shift count >= width of type [enabled by default]:  => 972:3
  + /scratch/kisskb/src/sound/soc/soc-dapm.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 3381:6
  + <stdin>: warning: #warning syscall sched_getattr not implemented [-Wcpp]:  => 1229:2
  + <stdin>: warning: #warning syscall sched_getattr not implemented:  => 1229:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented [-Wcpp]:  => 1226:2
  + <stdin>: warning: #warning syscall sched_setattr not implemented:  => 1226:2
  + warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet direct dependencies (!CPU_LITTLE_ENDIAN):  => N/A
  + warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS):  => N/A
  + warning: (USB_OTG_FSM && FSL_USB2_OTG && USB_MV_OTG) selects USB_OTG which has unmet direct dependencies (USB_SUPPORT && USB && PM_RUNTIME):  => N/A
  + warning: drivers/built-in.o(.data+0x1034): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xa68): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xb08): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xc64): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: drivers/built-in.o(.data+0xd6c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xdcc): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe2c): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: drivers/built-in.o(.data+0xe8c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: drivers/built-in.o(.text+0x2b4728): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d8c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x3f174): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x40008): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x400a8): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40204): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x4030c): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4036c): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x403cc): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4042c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x405d4): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

80 improvements:
  - /scratch/kisskb/src/arch/sh/boards/mach-se/770x/setup.c: warning: (near initialization for 'sh_eth0_device.dev.platform_data') [enabled by default]: 134:3 => 
  - /scratch/kisskb/src/arch/sh/boards/mach-se/770x/setup.c: warning: (near initialization for 'sh_eth1_device.dev.platform_data') [enabled by default]: 157:3 => 
  - /scratch/kisskb/src/arch/sh/boards/mach-se/770x/setup.c: warning: initialization makes pointer from integer without a cast [enabled by default]: 157:3, 134:3 => 
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
  - /scratch/kisskb/src/drivers/mfd/max8997.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 182:10 => 
  - /scratch/kisskb/src/drivers/mfd/max8998.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 178:10 => 
  - /scratch/kisskb/src/drivers/mfd/tps65217.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 173:13 => 
  - /scratch/kisskb/src/drivers/mfd/wm8994-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 639:19 => 
  - /scratch/kisskb/src/drivers/mtd/devices/docg3.c: warning: unused variable 'base' [-Wunused-variable]: 2122:16 => 
  - /scratch/kisskb/src/drivers/mtd/lpddr/lpddr_cmds.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 422:15, 130:11 => 
  - /scratch/kisskb/src/drivers/mtd/lpddr/qinfo_probe.c: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]: 147:15, 96:11, 102:2, 145:20 => 
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
  - /scratch/kisskb/src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_resume' defined but not used [-Wunused-function]: 35:12 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_pm.c: warning: 'scsi_dev_type_suspend' defined but not used [-Wunused-function]: 19:12 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_driver.c: warning: the frame size of 1036 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 975:1 => 
  - /scratch/kisskb/src/drivers/staging/dgap/dgap_fep5.c: warning: the frame size of 1044 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 112:1 => 
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
