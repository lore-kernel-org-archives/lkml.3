Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaKLJp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:45:58 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:44225 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKLJpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:45:54 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: Build regressions/improvements in v3.18-rc4
Date: Wed, 12 Nov 2014 10:46:06 +0100
Message-Id: <1415785566-12758-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v3.18-rc4[1] compared to v3.17[2].

Summarized:
  - build errors: +2/-14
  - build warnings: +82/-72

JFYI, when comparing v3.18-rc4[1]  to v3.18-rc3[3], the summaries are:
  - build errors: +5/-6
  - build warnings: +36/-34

Note that there may be false regressions, as some logs are incomplete.
Still, they're build errors/warnings.

As I haven't mastered kup yet, there's no verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.18-rc4.summary.gz

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/8061/ (120 out of 119 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/7938/ (118 out of 119 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/8044/ (120 out of 119 configs)


*** ERRORS ***

2 regressions:
  + /home/kisskb/slave/src/net/bridge/netfilter/nft_reject_bridge.c: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]:  => 240:3
  + error: No rule to make target /etc/sound/dsp001.ld:  => N/A

14 improvements:
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_check_functionality' [-Werror=implicit-function-declaration]: 117:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_master_send' [-Werror=implicit-function-declaration]: 96:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_byte_data' [-Werror=implicit-function-declaration]: 28:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_read_word_data' [-Werror=implicit-function-declaration]: 64:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_byte_data' [-Werror=implicit-function-declaration]: 46:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_smbus_write_word_data' [-Werror=implicit-function-declaration]: 82:2 => 
  - /home/kisskb/slave/src/drivers/base/regmap/regmap-i2c.c: error: implicit declaration of function 'i2c_transfer' [-Werror=implicit-function-declaration]: 130:2 => 
  - /home/kisskb/slave/src/drivers/extcon/extcon-sm5502.c: error: implicit declaration of function 'i2c_add_driver' [-Werror=implicit-function-declaration]: 718:2 => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.__dev_kfree_skb_any' defined in .text section in net/built-in.o: (.text+0x1ff8e58) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `._raw_spin_unlock_irqrestore' defined in .spinlock.text section in kernel/built-in.o: (.text+0x1ff9820), (.text+0x1ff9af0) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.bitrev32' defined in .text section in lib/built-in.o: (.text+0x1ff9598) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `.strlcpy' defined in .text section in lib/lib.a(string.o): (.text+0x1ff8bd0), (.text+0x1ff8b6c), (.text+0x1ff8b90) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_restgpr0_21' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff9b0c) => 
  - error: fealnx.c: relocation truncated to fit: R_PPC64_REL24 against symbol `_savegpr0_30' defined in .text.save.restore section in arch/powerpc/lib/built-in.o: (.text+0x1ff8a94), (.text+0x1ff8ae4) => 


*** WARNINGS ***

82 regressions:
  + /home/kisskb/slave/src/arch/mips/include/uapi/asm/unistd.h: warning: "__NR_memfd_create" redefined [enabled by default]:  => 1048:0
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to __restore_all; converted into longer instruction sequence:  => 89
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_call; converted into longer instruction sequence:  => 208
  + /home/kisskb/slave/src/arch/sh/kernel/cpu/sh3/../../entry-common.S: Warning: overflow in branch to syscall_trace_entry; converted into longer instruction sequence:  => 349, 347
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 6 has type 'dma_addr_t' [-Wformat]:  => 2175:2
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 8 has type 'dma_addr_t' [-Wformat]:  => 1607:3, 926:3
  + /home/kisskb/slave/src/drivers/block/skd_main.c: warning: format '%llx' expects argument of type 'long long unsigned int', but argument 9 has type 'dma_addr_t' [-Wformat]:  => 2240:3
  + /home/kisskb/slave/src/drivers/gpio/gpio-intel-mid.c: warning: 'intel_gpio_runtime_idle' defined but not used [-Wunused-function]:  => 348:12
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_crtc.c: warning: control reaches end of non-void function [-Wreturn-type]: 838:1 => 749:1, 945:1, 1272:1
  + /home/kisskb/slave/src/drivers/gpu/drm/drm_dp_mst_topology.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 1812:1
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'M' may be used uninitialized in this function [-Wuninitialized]:  => 117:5
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'N' may be used uninitialized in this function [-Wuninitialized]:  => 118:15
  + /home/kisskb/slave/src/drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c: warning: 'P' may be used uninitialized in this function [-Wuninitialized]:  => 118:3
  + /home/kisskb/slave/src/drivers/idle/i7300_idle.c: warning: 'got_ctl' may be used uninitialized in this function [-Wuninitialized]:  => 423:2
  + /home/kisskb/slave/src/drivers/infiniband/ulp/iser/iser_verbs.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1171:33, 1203:14, 1172:31, 1198:14
  + /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'high_plane' may be used uninitialized in this function [-Wuninitialized]:  => 371:31, 359:13
  + /home/kisskb/slave/src/drivers/media/platform/exynos-gsc/gsc-core.c: warning: 'low_plane' may be used uninitialized in this function [-Wuninitialized]:  => 359:30
  + /home/kisskb/slave/src/drivers/media/rc/st_rc.c: warning: 'st_rc_resume' defined but not used [-Wunused-function]:  => 359:12
  + /home/kisskb/slave/src/drivers/media/rc/st_rc.c: warning: 'st_rc_suspend' defined but not used [-Wunused-function]:  => 338:12
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1456 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 1835:1
  + /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2256 bytes is larger than 2048 bytes [-Wframe-larger-than=]:  => 651:1
  + /home/kisskb/slave/src/drivers/mtd/maps/solutionengine.c: warning: assignment makes pointer from integer without a cast [enabled by default]:  => 52:25, 54:25
  + /home/kisskb/slave/src/drivers/mtd/nand/sh_flctl.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 181:17, 164:17
  + /home/kisskb/slave/src/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c: warning: 'data' may be used uninitialized in this function [-Wuninitialized]:  => 243:34
  + /home/kisskb/slave/src/drivers/net/wireless/ath/wil6210/fw_inc.c: warning: 'hdr_sz' may be used uninitialized in this function [-Wuninitialized]:  => 447:4
  + /home/kisskb/slave/src/drivers/net/wireless/b43legacy/b43legacy.h: warning: 'packed' attribute ignored for field of type 'union <anonymous>' [-Wattributes]  CC      drivers/net/wireless/libertas_tf/if_usb.o:  => 381:2
  + /home/kisskb/slave/src/drivers/net/wireless/cw1200/scan.c: warning: value computed is not used [-Wunused-value]:  => 332:2
  + /home/kisskb/slave/src/drivers/net/wireless/cw1200/sta.c: warning: value computed is not used [-Wunused-value]:  => 143:2
  + /home/kisskb/slave/src/drivers/s390/kvm/virtio_ccw.c: warning: unused variable 'drv' [-Wunused-variable]:  => 891:24
  + /home/kisskb/slave/src/drivers/scsi/advansys.c: warning: #warning this driver is still not properly converted to the DMA API [-Wcpp]  CC      net/ipv4/netfilter/ipt_CLUSTERIP.o:  => 71:2
  + /home/kisskb/slave/src/drivers/scsi/dpt_i2o.c: warning: 'dptids' defined but not used [-Wunused-variable]  CC      drivers/scsi/megaraid.o:  => 183:29
  + /home/kisskb/slave/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt' may be used uninitialized in this function [-Wuninitialized]:  => 1504:9
  + /home/kisskb/slave/src/drivers/scsi/qla2xxx/qla_target.c: warning: 'cnt_in' may be used uninitialized in this function [-Wuninitialized]:  => 1504:9
  + /home/kisskb/slave/src/drivers/staging/comedi/drivers/dmm32at.c: warning: statement with no effect [-Wunused-value]:  => 562:3
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_alloc_fail_rate' defined but not used [-Wunused-function]:  => 231:12
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_max_dirty_pages_in_mb' defined but not used [-Wunused-function]:  => 189:12
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_mem_max' defined but not used [-Wunused-function]:  => 141:12
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_memory_alloc' defined but not used [-Wunused-function]:  => 93:12
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_pages_alloc' defined but not used [-Wunused-function]:  => 117:12
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_pages_max' defined but not used [-Wunused-function]:  => 165:12
  + /home/kisskb/slave/src/drivers/staging/lustre/lustre/obdclass/linux/linux-sysctl.c: warning: 'proc_set_timeout' defined but not used [-Wunused-function]:  => 82:12
  + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_SERIAL_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]:  => 24:2
  + /home/kisskb/slave/src/drivers/usb/gadget/udc/udc-xilinx.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 2135:2
  + /home/kisskb/slave/src/drivers/usb/musb/ux500_dma.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 211:51
  + /home/kisskb/slave/src/drivers/usb/renesas_usbhs/common.c: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]:  => 469:25
  + /home/kisskb/slave/src/drivers/video/backlight/adp8860_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 569:10, 625:11
  + /home/kisskb/slave/src/drivers/video/backlight/adp8870_bl.c: warning: 'reg_val' may be used uninitialized in this function [-Wuninitialized]:  => 811:11
  + /home/kisskb/slave/src/drivers/video/fbdev/arkfb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1019:23
  + /home/kisskb/slave/src/drivers/video/fbdev/ocfb.c: warning: passing argument 3 of 'dma_alloc_attrs' from incompatible pointer type [enabled by default]:  => 335:2
  + /home/kisskb/slave/src/drivers/video/fbdev/s3fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 1185:23
  + /home/kisskb/slave/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga1_entry' [-Wunused-variable]:  => 1634:4
  + /home/kisskb/slave/src/drivers/video/fbdev/via/viafbdev.c: warning: unused variable 'iga2_entry' [-Wunused-variable]:  => 1635:4
  + /home/kisskb/slave/src/drivers/video/fbdev/vt8623fb.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 734:23
  + /home/kisskb/slave/src/fs/btrfs/extent_io.c: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]:  => 2166:13
  + /home/kisskb/slave/src/fs/isofs/inode.c: warning: 'isofs_hash_common' defined but not used [-Wunused-function]:  => 177:1
  + /home/kisskb/slave/src/fs/mpage.c: warning: the frame size of 1088 bytes is larger than 1024 bytes [-Wframe-larger-than=]:  => 310:1
  + /home/kisskb/slave/src/kernel/debug/debug_core.c: warning: value computed is not used [-Wunused-value]:  => 504:4, 519:5
  + /home/kisskb/slave/src/mm/slub.c: warning: '__slab_alloc.constprop.43' uses dynamic stack allocation [enabled by default]:  => 2363:1
  + /home/kisskb/slave/src/net/bridge/br_netfilter.c: warning: label 'err1' defined but not used [-Wunused-label]:  => 995:1
  + /home/kisskb/slave/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function [-Wuninitialized]:  => 2736:15
  + /home/kisskb/slave/src/net/core/dev.c: warning: 'tail' may be used uninitialized in this function:  => 2720:39, 2720
  + /home/kisskb/slave/src/net/mac80211/mlme.c: warning: 'pwr_level_cisco' may be used uninitialized in this function [-Wuninitialized]:  => 1289:3, 1298:24
  + /home/kisskb/slave/src/scripts/kconfig/menu.c: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]:  => 590:18
  + /home/kisskb/slave/src/sound/soc/codecs/cs35l32.c: warning: 'val' is used uninitialized in this function [-Wuninitialized]:  => 314:2
  + <stdin>: warning: #warning syscall bpf not implemented [-Wcpp]:  => 1247:2
  + <stdin>: warning: #warning syscall bpf not implemented:  => 1247:2
  + warning: (SPU_FS) selects MEMORY_HOTPLUG which has unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 || SUPERH || S390)):  => N/A
  + warning: (VIDEO_TIMBERDALE) selects TIMB_DMA which has unmet direct dependencies (DMADEVICES && MFD_TIMBERDALE):  => N/A
  + warning: 1 bad relocations:  => N/A
  + warning: drivers/built-in.o(.text+0x2e7c20): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/built-in.o(.text+0x56e1c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x1d38): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/built-in.o(.text+0x43c6c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: drivers/net/cris/built-in.o(.text+0x1340): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init():  => N/A
  + warning: vmlinux.o(.data+0x413d0): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe():  => N/A
  + warning: vmlinux.o(.data+0x41470): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe():  => N/A
  + warning: vmlinux.o(.data+0x415d4): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe():  => N/A
  + warning: vmlinux.o(.data+0x416e4): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x41744): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x417a4): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip():  => N/A
  + warning: vmlinux.o(.data+0x4180c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe():  => N/A
  + warning: vmlinux.o(.data+0x419dc): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe():  => N/A

72 improvements:
  - .config: warning: override: reassigning to symbol ENABLE_MUST_CHECK: 7885 => 
  - .config: warning: override: reassigning to symbol PROFILE_ALL_BRANCHES: 7883 => 
  - /home/kisskb/slave/src/arch/arm/kernel/return_address.c: warning: #warning "TODO: return_address should use unwind tables" [-Wcpp]: 63:2 => 
  - /home/kisskb/slave/src/arch/x86/kernel/cpu/common.c: warning: 'syscall32_cpu_init' defined but not used [-Wunused-function]: 968:13 => 
  - /home/kisskb/slave/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_restore_reg_conf' defined but not used [-Wunused-function]: 194:13 => 
  - /home/kisskb/slave/src/drivers/gpio/gpio-pch.c: warning: 'pch_gpio_save_reg_conf' defined but not used [-Wunused-function]: 177:13 => 
  - /home/kisskb/slave/src/drivers/memstick/host/r592.c: warning: 'r592_clear_interrupts' defined but not used [-Wunused-function]: 192:13 => 
  - /home/kisskb/slave/src/drivers/mfd/88pm860x-i2c.c: warning: 'write_device' uses dynamic stack allocation [enabled by default]: 141:1 => 
  - /home/kisskb/slave/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_resume' defined but not used [-Wunused-function]: 127:12 => 
  - /home/kisskb/slave/src/drivers/mfd/intel_soc_pmic_core.c: warning: 'intel_soc_pmic_suspend' defined but not used [-Wunused-function]: 118:12 => 
  - /home/kisskb/slave/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_bulk_write' uses dynamic stack allocation [enabled by default]: 108:1 => 
  - /home/kisskb/slave/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_reg_write' uses dynamic stack allocation [enabled by default]: 80:1 => 
  - /home/kisskb/slave/src/drivers/mfd/max8925-i2c.c: warning: 'max8925_set_bits' uses dynamic stack allocation [enabled by default]: 128:1 => 
  - /home/kisskb/slave/src/drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1452 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 1835:1 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/amd/nmclan_cs.c: warning: 'pcmcia_request_exclusive_irq' is deprecated (declared at /home/kisskb/slave/src/include/pcmcia/ds.h:213) [-Wdeprecated-declarations]: 624:3 => 
  - /home/kisskb/slave/src/drivers/net/ethernet/broadcom/genet/bcmgenet.c: warning: 'bcmgenet_wol_resume' defined but not used [-Wunused-function]: 2020:12 => 
  - /home/kisskb/slave/src/drivers/nfc/trf7970a.c: warning: 'trf7970a_init' defined but not used [-Wunused-function]: 754:12 => 
  - /home/kisskb/slave/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_init' defined but not used [-Wunused-function]: 697:12 => 
  - /home/kisskb/slave/src/drivers/power/bq27x00_battery.c: warning: 'bq27x00_powersupply_unregister' defined but not used [-Wunused-function]: 728:13 => 
  - /home/kisskb/slave/src/drivers/pwm/core.c: warning: 'period' may be used uninitialized in this function: 609 => 
  - /home/kisskb/slave/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function [-Wuninitialized]: 676:18 => 
  - /home/kisskb/slave/src/drivers/pwm/core.c: warning: 'polarity' may be used uninitialized in this function: 610 => 
  - /home/kisskb/slave/src/drivers/scsi/cxgbi/libcxgbi.c: warning: 'cxgbi_device_find_by_mac' defined but not used [-Wunused-function]: 278:29 => 
  - /home/kisskb/slave/src/drivers/scsi/dpt_i2o.c: warning: 'dptids' defined but not used [-Wunused-variable]: 183:29 => 
  - /home/kisskb/slave/src/drivers/spi/spi-omap-100k.c: warning: "READ" redefined [enabled by default]: 74:0 => 
  - /home/kisskb/slave/src/drivers/spi/spi-omap-100k.c: warning: "WRITE" redefined [enabled by default]: 73:0 => 
  - /home/kisskb/slave/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 572:1 => 
  - /home/kisskb/slave/src/drivers/staging/dgnc/dgnc_tty.c: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 572:1 => 
  - /home/kisskb/slave/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 2 has type 'sk_buff_data_t' [-Wformat]: 885:5 => 
  - /home/kisskb/slave/src/drivers/staging/rtl8192ee/pci.c: warning: format '%d' expects argument of type 'int', but argument 3 has type 'sk_buff_data_t' [-Wformat]: 885:5 => 
  - /home/kisskb/slave/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 5 has type 'u64' [-Wformat]: 1151:5, 749:2 => 
  - /home/kisskb/slave/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%d' expects argument of type 'int', but argument 7 has type 'u64' [-Wformat]: 1142:4 => 
  - /home/kisskb/slave/src/drivers/staging/unisys/virthba/virthba.c: warning: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'u64' [-Wformat]: 520:2 => 
  - /home/kisskb/slave/src/drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 1068 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 792:1 => 
  - /home/kisskb/slave/src/drivers/staging/wlan-ng/prism2fw.c: warning: the frame size of 1072 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 792:1 => 
  - /home/kisskb/slave/src/drivers/tty/serial/8250/8250_hp300.c: warning: #warning CONFIG_8250 defined but neither CONFIG_HPDCA nor CONFIG_HPAPCI defined, are you sure? [-Wcpp]: 24:2 => 
  - /home/kisskb/slave/src/drivers/usb/gadget/function/f_fs.c: warning: 'rem_type1' may be used uninitialized in this function [-Wuninitialized]: 2356:47 => 
  - /home/kisskb/slave/src/drivers/usb/storage/realtek_cr.c: warning: 'config_autodelink_before_power_down' defined but not used [-Wunused-function]: 629:12 => 
  - /home/kisskb/slave/src/drivers/usb/storage/realtek_cr.c: warning: 'fw5895_init' defined but not used [-Wunused-function]: 699:13 => 
  - /home/kisskb/slave/src/fs/mpage.c: warning: the frame size of 1112 bytes is larger than 1024 bytes [-Wframe-larger-than=]: 308:1 => 
  - /home/kisskb/slave/src/include/linux/mtd/cfi.h: warning: 'r.x[0]' may be used uninitialized in this function [-Wuninitialized]  CC      drivers/sh/pm_runtime.o: 489:3 => 
  - /home/kisskb/slave/src/include/linux/pwm.h: warning: 'period' may be used uninitialized in this function [-Wuninitialized]: 98:15 => 
  - /home/kisskb/slave/src/kernel/acct.c: warning: unused variable 'ns' [-Wunused-variable]: 475:24 => 
  - /home/kisskb/slave/src/kernel/acct.c: warning: unused variable 'ns': 475 => 
  - /home/kisskb/slave/src/kernel/sched/core.c: warning: statement with no effect [-Wunused-value]: 2342:2 => 
  - /home/kisskb/slave/src/kernel/sched/core.c: warning: value computed is not used [-Wunused-value]: 2225:2 => 
  - /home/kisskb/slave/src/mm/slab_common.c: warning: 's' may be used uninitialized in this function [-Wuninitialized]: 204:21 => 
  - /home/kisskb/slave/src/mm/slub.c: warning: '__slab_alloc.constprop.44' uses dynamic stack allocation [enabled by default]: 2361:1 => 
  - /home/kisskb/slave/src/sound/soc/codecs/mc13783.c: warning: 'np' may be used uninitialized in this function [-Wuninitialized]: 787:13 => 
  - /home/kisskb/slave/src/sound/soc/codecs/rt286.c: warning: 'rt286_index_sync' defined but not used [-Wunused-function]: 272:13 => 
  - /home/kisskb/slave/src/sound/soc/codecs/tas2552.c: warning: 'tas2552_sw_shutdown' defined but not used [-Wunused-function]: 81:13 => 
  - /home/kisskb/slave/src/sound/soc/fsl/fsl_sai.c: warning: large integer implicitly truncated to unsigned type [-Woverflow]: 337:7 => 
  - /home/kisskb/slave/src/sound/soc/s6000/s6000-i2s.c: warning: unused variable 'mmio' [-Wunused-variable]: 577:16 => 
  - arch/powerpc/configs/mpc85xx_defconfig: warning: override: reassigning to symbol RTC_DRV_DS1307: 216 => 
  - warning: (PPC_CELLEB) selects HAS_TXX9_SERIAL which has unmet direct dependencies (TTY && HAS_IOMEM): N/A => 
  - warning: (PPC_CELL_NATIVE && 440GX && 460EX && 460SX && APM821xx) selects IBM_EMAC_TAH which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && AKEBONO && 440EPX && 440GRX && 440GX && 440SPe && 460EX && 460SX && APM821xx && 405EX) selects IBM_EMAC_EMAC4 which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && BLUESTONE && CANYONLANDS && GLACIER && EIGER && 440EPX && 440GRX && 440GX && 460SX && 405EX) selects IBM_EMAC_RGMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: (PPC_CELL_NATIVE && CANYONLANDS && GLACIER && 440EP && 440EPX && 440GRX && 440GP && 440GX && 460SX && 405GP) selects IBM_EMAC_ZMII which has unmet direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_IBM): N/A => 
  - warning: drivers/built-in.o(.text+0x2dfdc0): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/built-in.o(.text+0x56a30): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x1d58): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/built-in.o(.text+0x42c9c): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: drivers/net/cris/built-in.o(.text+0x1360): Section mismatch in reference from the function etrax_init_module() to the function .init.text:etrax_ethernet_init(): N/A => 
  - warning: vmlinux.o(.data+0x40d50): Section mismatch in reference from the variable lba_driver to the function .init.text:lba_driver_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40df0): Section mismatch in reference from the variable ccio_driver to the function .init.text:ccio_probe(): N/A => 
  - warning: vmlinux.o(.data+0x40f54): Section mismatch in reference from the variable dino_driver to the function .init.text:dino_probe(): N/A => 
  - warning: vmlinux.o(.data+0x41064): Section mismatch in reference from the variable lasi_driver to the function .init.text:lasi_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x410c4): Section mismatch in reference from the variable asp_driver to the function .init.text:asp_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x41124): Section mismatch in reference from the variable wax_driver to the function .init.text:wax_init_chip(): N/A => 
  - warning: vmlinux.o(.data+0x4118c): Section mismatch in reference from the variable eisa_driver to the function .init.text:eisa_probe(): N/A => 
  - warning: vmlinux.o(.data+0x4135c): Section mismatch in reference from the variable superio_driver to the function .init.text:superio_probe(): N/A => 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
