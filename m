Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIBJVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:21:11 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:42479 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaIBJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:21:06 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.17-rc3
Date: Tue,  2 Sep 2014 11:21:06 +0200
Message-Id: <1409649666-12855-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.17-rc3[1] compared to v3.16[2].

Summarized:
  - build errors: +17/-39
  - build warnings: +131/-73

JFYI, when comparing v3.17-rc3[1]  to v3.17-rc2[3], the summaries are:
  - build errors: +10/-22
  - build warnings: +49/-48

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.17-rc3.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/7824/ (all 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7732/ (all 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/7808/ (all 119 configs)


*** ERRORS ***

17 regressions:
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: 'cached_to_uncached' undeclared (first use in this function):  => 99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit declaration of function 'cpu_context' [-Werror=implicit-function-declaration]:  => 192:2
  + /scratch/kisskb/src/drivers/edac/ppc4xx_edac.c: error: request for member 'dimm' in something not a structure or union:  => 977:45
  + /scratch/kisskb/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD' undeclared (first use in this function):  => 378
  + /scratch/kisskb/src/fs/hostfs/hostfs_user.c: error: (Each undeclared identifier is reported only once:  => 378
  + /scratch/kisskb/src/fs/hostfs/hostfs_user.c: error: for each function it appears in.):  => 378
  + error: No rule to make target /etc/sound/trxpro.hex:  => N/A
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__dev_kfree_skb_irq' defined in .text section in net/built-in.o:  => (.text+0x1ff9c68)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.add_timer' defined in .text section in kernel/built-in.o:  => (.text+0x1ff9e68)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.alloc_etherdev_mqs' defined in .text section in net/built-in.o:  => (.text+0x1ffa274)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.debug_dma_sync_single_for_device' defined in .text section in lib/built-in.o:  => (.text+0x1ff950c)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.memcpy' defined in .text section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff9434)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.netif_rx' defined in .text section in net/built-in.o:  => (.text+0x1ff9670)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.pci_iounmap' defined in .text section in lib/built-in.o:  => (.text+0x1ffac10)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.register_netdev' defined in .text section in net/built-in.o:  => (.text+0x1ffa9bc)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_14' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ffac60)
  + error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o:  => (.text+0x1ff88b4)

30 improvements:
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
  - error: stmmac_hwtstamp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9944), (.text+0x1ff9580) => 
  - error: stmmac_hwtstamp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_26' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa0bc), (.text+0x1ff994c), (.text+0x1ff9d4c) => 
  - error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_lock_irqsave' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ffa5d8), (.text+0x1ffa520) => 
  - error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa59c) => 
  - error: stmmac_ptp.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_27' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ffa5a4), (.text+0x1ffa4ec) => 
  - error: tpm_ibmvtpm.c: undefined reference to `.__vio_register_driver': .init.text+0x6950) => 
  - error: tpm_ibmvtpm.c: undefined reference to `.plpar_hcall_norets': .text+0xedde0), .text+0xedae4), .text+0xeda70), .text+0xedc1c), .text+0xedb9c) => 
  - error: tpm_ibmvtpm.c: undefined reference to `.vio_unregister_driver': .exit.text+0x1920) => 


*** WARNINGS ***

131 regressions:
  + /scratch/kisskb/src/arch/powerpc/kvm/book3s_pr.c: warning: 'last_sc' may be used uninitialized in this function [-Wuninitialized]:  => 1098:31
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 347, 349
  + /scratch/kisskb/src/arch/sh/math-emu/math.c: warning: statement with no effect [-Wunused-value]  CC      mm/vmscan.o:  => 335:1
  + /scratch/kisskb/src/arch/x86/kernel/apm_32.c: warning: 'cx' may be used uninitialized in this function [-Wuninitialized]:  => 1831:4
  + /scratch/kisskb/src/arch/x86/kernel/apm_32.c: warning: 'dx' may be used uninitialized in this function [-Wuninitialized]:  => 1839:5
  + /scratch/kisskb/src/arch/x86/kernel/cpu/perf_event_amd_ibs.c: warning: 'config' may be used uninitialized in this function [-Wuninitialized]:  => 268:11
  + /scratch/kisskb/src/arch/x86/kernel/ksysfs.c: warning: 'size' may be used uninitialized in this function [-Wuninitialized]:  => 227:17
  + /scratch/kisskb/src/drivers/base/memory.c: warning: 'section_nr' may be used uninitialized in this function [-Wuninitialized]:  => 597:25
  + /scratch/kisskb/src/drivers/base/regmap/regmap.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 2118:6
  + /scratch/kisskb/src/drivers/char/tpm/tpm_atmel.c: warning: 'base' may be used uninitialized in this function [-Wuninitialized]:  => 204:3
  + /scratch/kisskb/src/drivers/edac/ppc4xx_edac.c: warning: initialization from incompatible pointer type [enabled by default]:  => 924:28
  + /scratch/kisskb/src/drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used uninitialized in this function [-Wuninitialized]:  => 471:4
  + /scratch/kisskb/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: 'hdrlen' may be used uninitialized in this function [-Wuninitialized]:  => 349:23
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'clock2' may be used uninitialized in this function [-Wuninitialized]:  => 2572:3
  + /scratch/kisskb/src/drivers/gpu/drm/drm_edid.c: warning: 'hdmi_len' may be used uninitialized in this function [-Wuninitialized]:  => 2997:30
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/device/ctrl.c: warning: overflow in implicit constant conversion [-Woverflow]:  => 62:3
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 146:2
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 146:2
  + /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/subdev/clock/gk20a.c: warning: right shift count >= width of type [enabled by default]:  => 146:2
  + /scratch/kisskb/src/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c: warning: 'res' may be used uninitialized in this function [-Wuninitialized]:  => 456:2
  + /scratch/kisskb/src/drivers/hid/hid-picolcd_debugfs.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]:  => 312:10
  + /scratch/kisskb/src/drivers/hid/usbhid/hid-core.c: warning: 'field' may be used uninitialized in this function [-Wuninitialized]:  => 815:16
  + /scratch/kisskb/src/drivers/i2c/busses/i2c-diolan-u2c.c: warning: 'byte' may be used uninitialized in this function [-Wuninitialized]:  => 393:18
  + /scratch/kisskb/src/drivers/media/v4l2-core/videobuf2-dma-contig.c: warning: 'pfn' may be used uninitialized in this function [-Wuninitialized]:  => 549:2
  + /scratch/kisskb/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_resume' defined but not used [-Wunused-function]:  => 127:12
  + /scratch/kisskb/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_suspend' defined but not used [-Wunused-function]:  => 118:12
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'num_sec_devs' may be used uninitialized in this function [-Wuninitialized]:  => 393:6
  + /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'sec_devs' may be used uninitialized in this function [-Wuninitialized]:  => 393:6
  + /scratch/kisskb/src/drivers/misc/bmp085.c: warning: 'pressure' may be used uninitialized in this function [-Wuninitialized]:  => 363:3
  + /scratch/kisskb/src/drivers/misc/ioc4.c: warning: 'start' may be used uninitialized in this function [-Wuninitialized]:  => 194:16
  + /scratch/kisskb/src/drivers/mtd/chips/cfi_cmdset_0002.c: warning: the frame size of 1300 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1658:1
  + /scratch/kisskb/src/drivers/mtd/devices/phram.c: warning: 'name' may be used uninitialized in this function [-Wuninitialized]:  => 114:16
  + /scratch/kisskb/src/drivers/mtd/nand/nand_base.c: warning: 'busw' may be used uninitialized in this function [-Wuninitialized]:  => 3698:9
  + /scratch/kisskb/src/drivers/mtd/spi-nor/spi-nor.c: warning: 'plat_id' may be used uninitialized in this function [-Wuninitialized]:  => 956:19
  + /scratch/kisskb/src/drivers/net/ethernet/broadcom/genet/bcmgenet.c: warning: 'bcmgenet_wol_resume' defined but not used [-Wunused-function]:  => 1962:12
  + /scratch/kisskb/src/drivers/net/ethernet/i825xx/sun3_82586.c: warning: array subscript is above array bounds [-Warray-bounds]:  => 993:89
  + /scratch/kisskb/src/drivers/net/ethernet/octeon/octeon_mgmt.c: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]:  => 295:4
  + /scratch/kisskb/src/drivers/net/phy/amd-xgbe-phy.c: warning: 'status' may be used uninitialized in this function [-Wuninitialized]:  => 422:2
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/debugfs.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]:  => 89:4
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/debugfs.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]:  => 89:4
  + /scratch/kisskb/src/drivers/net/wireless/ath/wil6210/debugfs.c: warning: right shift count >= width of type [enabled by default]:  => 89:4
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'chg_end_current' may be used uninitialized in this function [-Wuninitialized]:  => 266:4
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:6
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'level_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:22
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_lower' may be used uninitialized in this function [-Wuninitialized]:  => 325:37
  + /scratch/kisskb/src/drivers/power/da9052-battery.c: warning: 'vbat_upper' may be used uninitialized in this function [-Wuninitialized]:  => 324:59
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'raw' may be used uninitialized in this function [-Wuninitialized]:  => 144:20, 200:21, 172:12, 184:21, 213:17, 115:16, 160:21
  + /scratch/kisskb/src/drivers/power/ds2782_battery.c: warning: 'sense_res_raw' may be used uninitialized in this function [-Wuninitialized]:  => 137:19
  + /scratch/kisskb/src/drivers/pwm/core.c: warning: 'period' may be used uninitialized in this function:  => 609
  + /scratch/kisskb/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function [-Wuninitialized]:  => 676:18
  + /scratch/kisskb/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function:  => 610
  + /scratch/kisskb/src/drivers/rtc/rtc-rx8025.c: warning: 'adj' may be used uninitialized in this function [-Wuninitialized]:  => 506:2
  + /scratch/kisskb/src/drivers/scsi/cxgbi/libcxgbi.c: warning: 'cxgbi_device_find_by_mac' defined but not used [-Wunused-function]:  => 233:29
  + /scratch/kisskb/src/drivers/staging/android/sync_debug.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]:  => 100:3
  + /scratch/kisskb/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 5 has type 'u64' [-Wformat]:  => 749:2, 1151:5
  + /scratch/kisskb/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 7 has type 'u64' [-Wformat]:  => 1142:4
  + /scratch/kisskb/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'u64' [-Wformat]:  => 520:2
  + /scratch/kisskb/src/drivers/tty/ehv_bytechan.c: warning: unused variable 'sprop' [-Wunused-variable]:  => 115:14
  + /scratch/kisskb/src/drivers/uio/uio.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]:  => 844:2
  + /scratch/kisskb/src/drivers/usb/core/hcd.c: warning: 'bufp' may be used uninitialized in this function [-Wuninitialized]:  => 686:3
  + /scratch/kisskb/src/drivers/usb/gadget/function/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]:  => 421:1
  + /scratch/kisskb/src/drivers/usb/gadget/function/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]:  => 2324:47
  + /scratch/kisskb/src/drivers/usb/gadget/function/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]:  => 1249:20, 1249:15, 1249:7, 1249:31, 1155:5, 1160:12, 1197:13
  + /scratch/kisskb/src/drivers/usb/host/max3421-hcd.c: warning: 'ep' may be used uninitialized in this function [-Wuninitialized]:  => 1953:1
  + /scratch/kisskb/src/drivers/usb/host/max3421-hcd.c: warning: 'max3421_ep' may be used uninitialized in this function [-Wuninitialized]:  => 782:26
  + /scratch/kisskb/src/drivers/usb/host/max3421-hcd.c: warning: 'max3421_hcd' may be used uninitialized in this function [-Wuninitialized]:  => 1899:3
  + /scratch/kisskb/src/drivers/w1/slaves/w1_therm.c: warning: 'verdict' may be used uninitialized in this function [-Wuninitialized]:  => 271:2
  + /scratch/kisskb/src/fs/autofs4/waitq.c: warning: 'wq' may be used uninitialized in this function [-Wuninitialized]:  => 460:5
  + /scratch/kisskb/src/fs/btrfs/extent-tree.c: warning: array subscript is below array bounds [-Warray-bounds]:  => 7570:18, 7571:17
  + /scratch/kisskb/src/fs/cifs/sess.c: warning: 'sess_auth_kerberos' defined but not used [-Wunused-function]:  => 1108:1
  + /scratch/kisskb/src/fs/cifs/sess.c: warning: 'sess_auth_kerberos' defined but not used:  => 1109
  + /scratch/kisskb/src/fs/cifs/sess.c: warning: 'sess_auth_lanman' defined but not used [-Wunused-function]:  => 750:1
  + /scratch/kisskb/src/fs/cifs/sess.c: warning: 'sess_auth_lanman' defined but not used:  => 751
  + /scratch/kisskb/src/fs/nfsd/nfs4state.c: warning: 'old_deny_bmap' may be used uninitialized in this function [-Wuninitialized]:  => 3732:24
  + /scratch/kisskb/src/include/linux/cgroup.h: warning: 'root' may be used uninitialized in this function [-Wuninitialized]:  => 158:11
  + /scratch/kisskb/src/include/linux/dmaengine.h: warning: 'rxdesc' may be used uninitialized in this function [-Wuninitialized]:  => 796:2
  + /scratch/kisskb/src/include/linux/dmaengine.h: warning: 'txdesc' may be used uninitialized in this function [-Wuninitialized]:  => 796:2
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.file' may be used uninitialized in this function [-Wuninitialized]:  => 39:7
  + /scratch/kisskb/src/include/linux/file.h: warning: 'output.flags' may be used uninitialized in this function [-Wuninitialized]:  => 38:2
  + /scratch/kisskb/src/include/linux/hid.h: warning: 'report' may be used uninitialized in this function [-Wuninitialized]:  => 984:34
  + /scratch/kisskb/src/include/linux/percpu-refcount.h: warning: 'pcpu_count' may be used uninitialized in this function [-Wuninitialized]:  => 126:1, 183:1, 206:1
  + /scratch/kisskb/src/include/linux/pwm.h: warning: 'period' may be used uninitialized in this function [-Wuninitialized]:  => 98:15
  + /scratch/kisskb/src/include/linux/slab.h: warning: 'count' may be used uninitialized in this function [-Wuninitialized]:  => 561:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'dst_ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/spinlock.h: warning: 'ptl' may be used uninitialized in this function [-Wuninitialized]:  => 343:2
  + /scratch/kisskb/src/include/linux/time.h: warning: 'busy_until.tv_sec' may be used uninitialized in this function [-Wuninitialized]:  => 28:2
  + /scratch/kisskb/src/include/math-emu/double.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 59:5
  + /scratch/kisskb/src/include/math-emu/single.h: warning: "__LITTLE_ENDIAN" is not defined [-Wundef]:  => 50:5
  + /scratch/kisskb/src/ipc/sem.c: warning: 'ulp' may be used uninitialized in this function [-Wuninitialized]:  => 1733:11
  + /scratch/kisskb/src/ipc/sem.c: warning: 'undo_list' may be used uninitialized in this function [-Wuninitialized]:  => 2028:13
  + /scratch/kisskb/src/kernel/acct.c: warning: unused variable 'ns' [-Wunused-variable]:  => 475:24
  + /scratch/kisskb/src/kernel/acct.c: warning: unused variable 'ns':  => 475
  + /scratch/kisskb/src/kernel/kprobes.c: warning: 'probed_mod' may be used uninitialized in this function [-Wuninitialized]:  => 1530:2
  + /scratch/kisskb/src/kernel/profile.c: warning: 'profile_cpu_callback' defined but not used [-Wunused-function]:  => 330:12
  + /scratch/kisskb/src/kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but not used [-Wunused-function]:  => 266:13
  + /scratch/kisskb/src/kernel/profile.c: warning: 'profile_flip_buffers' defined but not used [-Wunused-function]:  => 243:13
  + /scratch/kisskb/src/kernel/user_namespace.c: warning: 'first' may be used uninitialized in this function [-Wuninitialized]:  => 211:6, 188:6, 165:6
  + /scratch/kisskb/src/lib/lz4/lz4hc_compress.c: warning: 'delta' may be used uninitialized in this function [-Wuninitialized]:  => 174:20
  + /scratch/kisskb/src/mm/memblock.c: warning: 'r' may be used uninitialized in this function [-Wuninitialized]:  => 1002:15
  + /scratch/kisskb/src/mm/memcontrol.c: warning: 'usage' may be used uninitialized in this function [-Wuninitialized]:  => 4803:6, 4715:6
  + /scratch/kisskb/src/mm/memcontrol.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 4114:1
  + /scratch/kisskb/src/sound/drivers/serial-u16550.c: warning: 'uart' may be used uninitialized in this function [-Wuninitialized]:  => 963:27
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'aif_rx_state' may be used uninitialized in this function [-Wuninitialized]:  => 1372:21
  + /scratch/kisskb/src/sound/soc/codecs/arizona.c: warning: 'aif_tx_state' may be used uninitialized in this function [-Wuninitialized]:  => 1369:27
  + /scratch/kisskb/src/sound/soc/codecs/mc13783.c: warning: 'np' may be used uninitialized in this function [-Wuninitialized]:  => 787:13
  + /scratch/kisskb/src/sound/soc/codecs/rt286.c: warning: 'rt286_index_sync' defined but not used [-Wunused-function]:  => 273:13
  + /scratch/kisskb/src/sound/soc/codecs/tas2552.c: warning: 'tas2552_sw_shutdown' defined but not used [-Wunused-function]:  => 81:13
  + /scratch/kisskb/src/sound/soc/s6000/s6000-i2s.c: warning: unused variable 'mmio' [-Wunused-variable]:  => 577:16
  + <stdin>: warning: #warning syscall getrandom not implemented [-Wcpp]:  => 1241:2
  + <stdin>: warning: #warning syscall getrandom not implemented:  => 1241:2
  + <stdin>: warning: #warning syscall memfd_create not implemented [-Wcpp]:  => 1244:2
  + <stdin>: warning: #warning syscall memfd_create not implemented:  => 1244:2
  + <stdin>: warning: #warning syscall seccomp not implemented [-Wcpp]:  => 1238:2
  + <stdin>: warning: #warning syscall seccomp not implemented:  => 1238:2
  + arch/powerpc/configs/mpc85xx_defconfig: warning: override: reassigning to symbol RTC_DRV_DS1307:  => 216
  + warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM):  => N/A
  + warning: drivers/built-in.o(.text+0x2dfbc4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x569d8): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d58): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x42bf4): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence:  => N/A
  + warning: vmlinux.o(.data+0x40d50): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x40df0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x40f54): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x41064): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x410c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41124): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4118c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x4135c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

73 improvements:
  - /scratch/kisskb/src/arch/ia64/sn/kernel/bte.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 125:22, 117:22 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      kernel/user.o: 380 => 
  - /scratch/kisskb/src/arch/sh/kernel/cpu/sh4/../sh3/../../entry-common.S: Warning: overflow in branch to syscall_exit_work; converted into longer instruction sequence  CC      security/keys/permission.o: 383 => 
  - /scratch/kisskb/src/arch/sparc/include/asm/atomic_32.h: warning: conflicting types for 'atomic_set' [enabled by default]: 27:6 => 
  - /scratch/kisskb/src/arch/x86/kernel/cpu/mcheck/mce-inject.c: warning: 'mce_irq_ipi' defined but not used [-Wunused-function]: 97:13 => 
  - /scratch/kisskb/src/drivers/char/random.c: warning: 'arch_random_refill' uses dynamic stack allocation [enabled by default]: 1341:1 => 
  - /scratch/kisskb/src/drivers/gpio/gpio-sch311x.c: warning: ignoring return value of 'gpiochip_remove', declared with attribute warn_unused_result [-Wunused-result]: 286:18 => 
  - /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_resume' defined but not used [-Wunused-function]: 117:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/bochs/bochs_drv.c: warning: 'bochs_pm_suspend' defined but not used [-Wunused-function]: 100:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_resume' defined but not used [-Wunused-function]: 96:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/cirrus/cirrus_drv.c: warning: 'cirrus_pm_suspend' defined but not used [-Wunused-function]: 79:12 => 
  - /scratch/kisskb/src/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 77:6 => 
  - /scratch/kisskb/src/drivers/iio/adc/exynos_adc.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 112:9 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/mcs5000_ts.c: warning: 'mcs5000_ts_resume' defined but not used [-Wunused-function]: 262:12 => 
  - /scratch/kisskb/src/drivers/input/touchscreen/mcs5000_ts.c: warning: 'mcs5000_ts_suspend' defined but not used [-Wunused-function]: 252:12 => 
  - /scratch/kisskb/src/drivers/mfd/arizona-core.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 505:10 => 
  - /scratch/kisskb/src/drivers/mfd/sec-core.c: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]: 350:5 => 
  - /scratch/kisskb/src/drivers/mfd/stmpe-i2c.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 88:13 => 
  - /scratch/kisskb/src/drivers/mfd/tps65910.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 404:14 => 
  - /scratch/kisskb/src/drivers/net/ethernet/xilinx/ll_temac_main.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 78:7 => 
  - /scratch/kisskb/src/drivers/net/wireless/libertas/if_cs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 878:15 => 
  - /scratch/kisskb/src/drivers/net/wireless/mac80211_hwsim.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 692:20 => 
  - /scratch/kisskb/src/drivers/net/wireless/mwifiex/cmdevt.c: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type '__kernel_suseconds_t' [-Wformat]: 202:2, 463:3, 916:4, 835:2 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/orinoco_cs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 153:6 => 
  - /scratch/kisskb/src/drivers/net/wireless/orinoco/spectrum_cs.c: warning: assignment makes pointer from integer without a cast [enabled by default]: 216:6 => 
  - /scratch/kisskb/src/drivers/scsi/bfa/bfa_fcpim.c: warning: left shift count >= width of type [enabled by default]: 2509:4, 2497:4 => 
  - /scratch/kisskb/src/drivers/scsi/bfa/bfa_fcpim.c: warning: right shift count >= width of type [enabled by default]: 2509:4, 2497:4 => 
  - /scratch/kisskb/src/drivers/scsi/hpsa.c: warning: 'driver_support' is used uninitialized in this function [-Wuninitialized]: 6373:17 => 
  - /scratch/kisskb/src/drivers/scsi/scsi_tgt_if.c: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast [enabled by default]: 289:10 => 
  - /scratch/kisskb/src/drivers/spi/spi-atmel.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 1021:13, 1256:19 => 
  - /scratch/kisskb/src/drivers/spi/spi-fsl-lib.c: warning: unused variable 'ret' [-Wunused-variable]: 195:6 => 
  - /scratch/kisskb/src/drivers/spi/spi-rspi.c: warning: unused variable 'ret' [-Wunused-variable]: 633:6 => 
  - /scratch/kisskb/src/drivers/staging/android/sync.c: warning: format '%ld' expects argument of type 'long int', but argument 4 has type '__kernel_suseconds_t' [-Wformat]: 874:3 => 
  - /scratch/kisskb/src/drivers/staging/comedi/drivers/ni_mio_common.c: warning: 'sample' may be used uninitialized in this function [-Wuninitialized]: 5715:11 => 
  - /scratch/kisskb/src/drivers/staging/usbip/stub_dev.c: warning: 'stub_table' defined but not used [-Wunused-variable]: 33:29 => 
  - /scratch/kisskb/src/drivers/staging/wlags49_h2/hcf.c: warning: unused variable 'io_port' [-Wunused-variable]: 3636:22 => 
  - /scratch/kisskb/src/drivers/staging/wlags49_h25/../wlags49_h2/hcf.c: warning: unused variable 'io_port' [-Wunused-variable]: 3636:22 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: '__ffs_ep0_read_events' uses dynamic stack allocation [enabled by default]: 420:1 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]: 2119:47 => 
  - /scratch/kisskb/src/drivers/usb/gadget/f_ncm.c: warning: 'tmp' may be used uninitialized in this function [-Wuninitialized]: 1060:14, 1080:6, 1039:4, 993:5, 1007:28, 1060:30, 1080:19 => 
  - /scratch/kisskb/src/drivers/usb/host/oxu210hp-hcd.c: warning: unused variable 'base' [-Wunused-variable]: 3904:8 => 
  - /scratch/kisskb/src/drivers/usb/misc/usb3503.c: warning: 'err' may be used uninitialized in this function [-Wuninitialized]: 195:11 => 
  - /scratch/kisskb/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]: 566:10, 441:16, 622:11, 596:32 => 
  - /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]: 1634:4 => 
  - /scratch/kisskb/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]: 1635:4 => 
  - /scratch/kisskb/src/drivers/video/fbdev/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 734:23 => 
  - /scratch/kisskb/src/include/asm-generic/io.h: warning: passing argument 2 of '__raw_writel' makes pointer from integer without a cast [enabled by default]  CC [M]  drivers/media/usb/dvb-usb/pctv452e.o: 154:2 => 
  - /scratch/kisskb/src/include/linux/typecheck.h: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 11:18 => 
  - /scratch/kisskb/src/mm/memcontrol.c: warning: 'val' may be used uninitialized in this function [-Wuninitialized]: 4891:2 => 
  - /scratch/kisskb/src/mm/memory.c: warning: #warning Unfortunate NUMA and NUMA Balancing config, growing page-frame for last_cpupid. [-Wcpp]: 75:2 => 
  - /scratch/kisskb/src/sound/oss/ad1848.c: warning: 'id_table' defined but not used [-Wunused-variable]: 2863:32 => 
  - /scratch/kisskb/src/sound/soc/codecs/adau1977.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 971:3 => 
  - /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_resume' defined but not used [-Wunused-function]: 2432:12 => 
  - /scratch/kisskb/src/sound/soc/codecs/max98090.c: warning: 'max98090_suspend' defined but not used [-Wunused-function]: 2449:12 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: comparison of distinct pointer types lacks a cast [enabled by default]: 593:3 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: passing argument 1 of '__div64_32' from incompatible pointer type [enabled by default]: 593:3 => 
  - /scratch/kisskb/src/sound/soc/fsl/fsl_ssi.c: warning: right shift count >= width of type [enabled by default]: 593:3 => 
  - /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]: 70:13 => 
  - /scratch/kisskb/src/sound/soc/fsl/imx-audmux.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]: 162:7 => 
  - warning: (IMA) selects TCG_IBMVTPM which has unmet direct dependencies (TCG_TPM && PPC_PSERIES): N/A => 
  - warning: (VIDEO_EM28XX_V4L2) selects VIDEO_MT9V011 which has unmet direct dependencies (MEDIA_SUPPORT && I2C && VIDEO_V4L2 && MEDIA_CAMERA_SUPPORT): N/A => 
  - warning: drivers/built-in.o(.text+0x2cd8e0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x51910): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d54): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x42b14): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
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
