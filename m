Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3ETLEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:04:46 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55385 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab3ETLEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:04:38 -0400
Date: Mon, 20 May 2013 19:04:12 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for May 20(dvb-usb)
In-Reply-To: <20130520144940.a33c311c37824a57dd0c395e@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1305201902460.26558@M2420>
References: <20130520144940.a33c311c37824a57dd0c395e@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-410157428-1369047873=:26558"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-410157428-1369047873=:26558
Content-Type: TEXT/PLAIN; charset=US-ASCII


randconfig build error:

drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
drivers/media/usb/dvb-usb/dibusb-common.c:322: undefined reference to `dib3000mc_get_tuner_i2c_master'
drivers/media/usb/dvb-usb/dibusb-common.c:330: undefined reference to `dib3000mc_set_config'
drivers/built-in.o: In function `dibusb_dib3000mc_frontend_attach':
drivers/media/usb/dvb-usb/dibusb-common.c:271: undefined reference to `dib3000mc_pid_parse'
drivers/media/usb/dvb-usb/dibusb-common.c:272: undefined reference to `dib3000mc_pid_control'
drivers/built-in.o: In function `tfe8096p_tuner_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:2035: undefined reference to `dib8096p_get_i2c_tuner'
drivers/media/usb/dvb-usb/dib0700_devices.c:2041: undefined reference to `dib8000_set_gpio'
drivers/built-in.o: In function `dib80xx_tuner_sleep':
drivers/media/usb/dvb-usb/dib0700_devices.c:1169: undefined reference to `dib8000_set_gpio'
drivers/built-in.o: In function `dib80xx_tuner_reset':
drivers/media/usb/dvb-usb/dib0700_devices.c:1164: undefined reference to `dib8000_set_gpio'
drivers/built-in.o: In function `dib8090_get_adc_power':
drivers/media/usb/dvb-usb/dib0700_devices.c:1431: undefined reference to `dib8000_get_adc_power'
drivers/built-in.o: In function `dib8096p_agc_startup':
drivers/media/usb/dvb-usb/dib0700_devices.c:1986: undefined reference to `dib8000_set_wbd_ref'
drivers/media/usb/dvb-usb/dib0700_devices.c:1993: undefined reference to `dib8000_update_pll'
drivers/media/usb/dvb-usb/dib0700_devices.c:1994: undefined reference to `dib8000_ctrl_timf'
drivers/built-in.o: In function `tfe8096p_frontend_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:2024: undefined reference to `dib8000_i2c_enumeration'
drivers/built-in.o: In function `stk809x_frontend_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:1655: undefined reference to `dib8000_i2c_enumeration'
drivers/built-in.o: In function `stk807xpvr_frontend_attach1':
drivers/media/usb/dvb-usb/dib0700_devices.c:1323: undefined reference to `dib8000_i2c_enumeration'
drivers/built-in.o: In function `stk807xpvr_frontend_attach0':
drivers/media/usb/dvb-usb/dib0700_devices.c:1312: undefined reference to `dib8000_i2c_enumeration'
drivers/built-in.o: In function `stk807x_frontend_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:1282: undefined reference to `dib8000_i2c_enumeration'
drivers/built-in.o: In function `nim8096md_tuner_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:1666: undefined reference to `dib8000_get_slave_frontend'
drivers/media/usb/dvb-usb/dib0700_devices.c:1669: undefined reference to `dib8000_get_i2c_master'
drivers/media/usb/dvb-usb/dib0700_devices.c:1675: undefined reference to `dib8000_get_i2c_master'
drivers/built-in.o: In function `dib809x_tuner_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:1628: undefined reference to `dib8000_get_i2c_master'
drivers/built-in.o: In function `dib807x_tuner_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:1234: undefined reference to `dib8000_get_i2c_master'
drivers/built-in.o: In function `dib8096_set_param_override':
drivers/media/usb/dvb-usb/dib0700_devices.c:1554: undefined reference to `dib8000_set_gpio'
drivers/media/usb/dvb-usb/dib0700_devices.c:1571: undefined reference to `dib8000_update_pll'
drivers/media/usb/dvb-usb/dib0700_devices.c:1585: undefined reference to `dib8000_update_pll'
drivers/media/usb/dvb-usb/dib0700_devices.c:1587: undefined reference to `dib8000_ctrl_timf'
drivers/media/usb/dvb-usb/dib0700_devices.c:1592: undefined reference to `dib8000_set_wbd_ref'
drivers/media/usb/dvb-usb/dib0700_devices.c:1614: undefined reference to `dib8000_pwm_agc_reset'
drivers/media/usb/dvb-usb/dib0700_devices.c:1615: undefined reference to `dib8000_set_tune_state'
drivers/media/usb/dvb-usb/dib0700_devices.c:1557: undefined reference to `dib8000_set_gpio'
drivers/built-in.o: In function `nim8096md_frontend_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:1706: undefined reference to `dib8000_i2c_enumeration'
drivers/media/usb/dvb-usb/dib0700_devices.c:1713: undefined reference to `dib8000_set_slave_frontend'
drivers/built-in.o: In function `dib807x_set_param_override':
drivers/media/usb/dvb-usb/dib0700_devices.c:1215: undefined reference to `dib0070_wbd_offset'
drivers/media/usb/dvb-usb/dib0700_devices.c:1226: undefined reference to `dib8000_set_wbd_ref'
drivers/built-in.o: In function `dib7770_set_param_override':
drivers/media/usb/dvb-usb/dib0700_devices.c:845: undefined reference to `dib0070_wbd_offset'
drivers/built-in.o: In function `dib7070_set_param_override':
drivers/media/usb/dvb-usb/dib0700_devices.c:821: undefined reference to `dib0070_wbd_offset'
drivers/built-in.o: In function `stk80xx_pid_filter':
drivers/media/usb/dvb-usb/dib0700_devices.c:1255: undefined reference to `dib8000_pid_filter'
drivers/built-in.o: In function `stk80xx_pid_filter_ctrl':
drivers/media/usb/dvb-usb/dib0700_devices.c:1261: undefined reference to `dib8000_pid_filter_ctrl'
drivers/built-in.o: In function `bristol_tuner_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:121: undefined reference to `dib3000mc_get_tuner_i2c_master'
drivers/built-in.o: In function `bristol_frontend_attach':
drivers/media/usb/dvb-usb/dib0700_devices.c:98: undefined reference to `dib3000mc_i2c_enumeration'
drivers/built-in.o: In function `az6027_frontend_attach':
drivers/media/usb/dvb-usb/az6027.c:916: undefined reference to `stb6100_attach'
drivers/built-in.o: In function `dib01x0_pmu_update':
drivers/media/usb/dvb-usb/dib0700_devices.c:2079: undefined reference to `dibx000_i2c_set_speed'
drivers/built-in.o:(.rodata+0x24870): undefined reference to `dib8096p_tuner_sleep'
drivers/built-in.o:(.rodata+0x24874): undefined reference to `dib8096p_tuner_sleep'
drivers/built-in.o:(.data+0x3470c): undefined reference to `dib0070_ctrl_agc_filter'
drivers/built-in.o:(.data+0x34738): undefined reference to `dib0070_ctrl_agc_filter'
make: *** [vmlinux] Error 1


config file attached.


On Mon, 20 May 2013, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20130517:
> 
> The usb.current tree gained a conflict against Linus' tree.
> 
> The rr-fixes tree gained a build failure so I used the version from
> next-20130515.
> 
> The akpm tree gained conflicts against Linus' and the net-next tree.
> 
> ----------------------------------------------------------------------------
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
> final fixups (if any), it is also built with powerpc allnoconfig (32 and
> 64 bit), ppc44x_defconfig and allyesconfig (minus
> CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
> sparc64 and arm defconfig. These builds also have
> CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
> CONFIG_DEBUG_INFO disabled when necessary.
> 
> Below is a summary of the state of the merge.
> 
> We are up to 226 trees (counting Linus' and 31 trees of patches pending
> for Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
> 
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
> 
> There is a wiki covering stuff to do with linux-next at
> http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> $ git checkout master
> $ git reset --hard stable
> Merging origin/master (343cd4f Merge tag 'dm-3.10-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm)
> Merging fixes/master (0279b3c Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
> Merging kbuild-current/rc-fixes (f66ba56 package: Makefile: unbreak binrpm-pkg target)
> Merging arc-current/for-curr (81ec684 ARC: [mm] change semantics of __sync_icache_dcache() to inv d$ lines)
> Merging arm-current/fixes (6eabb33 ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value)
> Merging m68k-current/for-linus (f722406 Linux 3.10-rc1)
> Merging powerpc-merge/merge (e34166a powerpc: Set show_unhandled_signals to 1 by default)
> Merging sparc/master (de9c9f8 Merge tag 'remoteproc-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc)
> Merging net/master (ff0102e net: irda: using kzalloc() instead of kmalloc() to avoid strncpy() issue.)
> Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net)
> Merging sound-current/for-linus (e6135fe ALSA: usb-audio: proc: use found syncmaxsize to determine feedback format)
> Merging pci-current/for-linus (3f327e3 PCI: acpiphp: Re-enumerate devices when host bridge receives Bus Check)
> Merging wireless/master (6bb4880 ath9k: fix draining aggregation tid buffers)
> Merging driver-core.current/driver-core-linus (f722406 Linux 3.10-rc1)
> Merging tty.current/tty-linus (f722406 Linux 3.10-rc1)
> Merging usb.current/usb-linus (7138143 USB: ftdi_sio: Add support for Newport CONEX motor drivers)
> CONFLICT (content): Merge conflict in drivers/usb/host/ohci-nxp.c
> Merging staging.current/staging-linus (642f2ec staging: dwc2: Fix dma-enabled platform devices using a default dma_mask)
> Merging char-misc.current/char-misc-linus (221ba15 Char: lp, protect LPGETSTATUS with port_mutex)
> Merging input-current/for-linus (f0aacea Input: wacom - add a few new styli for Cintiq series)
> Merging md-current/for-linus (32f9f57 MD: ignore discard request for hard disks of hybid raid1/raid10 array)
> Merging audit-current/for-linus (c158a35 audit: no leading space in audit_log_d_path prefix)
> Merging crypto-current/master (286233e crypto: caam - fix inconsistent assoc dma mapping direction)
> Merging ide/master (bf6b438 ide: gayle: use module_platform_driver_probe())
> Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
> Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros to inline functions)
> Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
> Merging devicetree-current/devicetree/merge (ab28698 of: define struct device in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
> Merging spi-current/spi/merge (0d2d0cc spi/davinci: fix module build error)
> Merging gpio-current/gpio/merge (e97f9b5 gpio/gpio-ich: fix ichx_gpio_check_available() return what callers expect)
> Merging rr-fixes/fixes (d16ea2a virtio_console: fix uapi header)
> $ git reset --hard HEAD^
> Merging 20130515 version of rr-fixes
> Merging mfd-fixes/master (e9d7b4b mfd: db8500-prcmu: Update stored DSI PLL divider value)
> Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overflow)
> Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
> Merging arc/for-next (fd5c9c3 ARC: Trim arcregs.h)
> Merging arm/for-next (47aa03d Merge branches 'fixes', 'misc' and 'mmci' into for-next)
> Merging arm-perf/for-next/perf (ab87304 Merge branches 'perf/fixes' and 'hw-breakpoint' into for-next/perf)
> Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
> Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
> CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
> CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
> CONFLICT (add/add): Merge conflict in arch/arm/mach-zynq/platsmp.c
> CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
> CONFLICT (content): Merge conflict in arch/arm/mach-spear/spear13xx.c
> CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
> CONFLICT (content): Merge conflict in arch/arm/mach-highbank/highbank.c
> Merging arm64/upstream (3126976 arm64: debug: fix mdscr.ss check when enabling debug exceptions)
> Merging blackfin/blackfin-linus (5ae89ee bfin cache: dcplb map: add 16M dcplb map for BF60x)
> Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_restore)
> Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic file)
> Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
> Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
> Merging m68k/for-next (f722406 Linux 3.10-rc1)
> Merging m68knommu/for-next (2842e5b0 m68knommu: enable Timer on coldfire 532x)
> Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB => 128KiB)
> Merging microblaze/next (972be32 microblaze: Initialize temp variable to remove compilation warning)
> Merging mips/mips-for-linux-next (f4ef27f Merge branch '3.10-fixes' into mips-for-linux-next)
> Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
> Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parameter from do_execve() in hpux_execve())
> Merging parisc-hd/for-next (1c92ce8 parisc: use arch_spinlock_t instead of raw_spinlock_t in irqstacks)
> Merging powerpc/next (674825d Merge tag 'fixes-for-3.10-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen)
> Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
> Merging mpc5xxx/next (fdeaf0e powerpc/512x: add ifm ac14xx board)
> Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bridge device node for T4/B4)
> Merging s390/features (ba54229 s390/cio: add channel ID sysfs attribute)
> Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/serial-of' into sh-latest)
> CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
> Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
> Merging tile/master (9fc1894 arch/tile: Fix syscall return value passed to tracepoint)
> Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIMENTAL)
> Merging xtensa/for_next (b341d84 xtensa: Switch to asm-generic/linkage.h)
> Merging btrfs/next (667e7d9 Btrfs: allow superblock mismatch from older mkfs)
> Merging ceph/testing (cb53a7e rbd: drop original request earlier for existence check)
> Merging cifs/for-next (c2b93e0 cifs: only set ops for inodes in I_NEW state)
> Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
> Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
> Merging ext3/for_next (e162b2f jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset)
> Merging ext4/dev (e2555fd jbd,jbd2: fix oops in jbd2_journal_put_journal_head())
> Merging f2fs/dev (f722406 Linux 3.10-rc1)
> Merging fuse/for-next (de82b92 fuse: allocate for_background dio requests based on io->async state)
> Merging gfs2/master (315debd GFS2: fix DLM depends to fix build errors)
> Merging jfs/jfs-next (73aaa22 jfs: fix a couple races)
> Merging logfs/master (3394661 Fix the call to BUG() caused by no free segment found)
> Merging nfs/linux-next (2aed8b4 SUNRPC: Convert auth_gss pipe detection to work in namespaces)
> Merging nfsd/nfsd-next (ba4e55b nfsd4: fix compile in !CONFIG_NFSD_V4_SECURITY_LABEL case)
> Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
> Merging omfs/for-next (976d167 Linux 3.1-rc9)
> Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for block_size and block_log match)
> Merging v9fs/for-next (c1be5a5 Linux 3.9)
> Merging ubifs/linux-next (c1be5a5 Linux 3.9)
> Merging xfs/for-next (f722406 Linux 3.10-rc1)
> Merging vfs/for-next (ac3e3c5 don't bother with deferred freeing of fdtables)
> Merging pci/next (f722406 Linux 3.10-rc1)
> Merging hid/for-next (f3d6ede Merge branch 'for-3.11/multitouch' into for-next)
> Merging i2c/i2c/for-next (e9b526f i2c: suppress lockdep warning on delete_device)
> Merging jdelvare-hwmon/master (1aaf6d3 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net)
> Merging hwmon-staging/hwmon-next (d0a665e hwmon: (ds1621) Add ds1721 update interval sysfs attribute)
> Merging v4l-dvb/master (1d62caa Merge /home/v4l/v4l/patchwork)
> Merging kbuild/for-next (9639217 Merge branch 'kbuild/kbuild' into kbuild/for-next)
> Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set to 'y' not 'm')
> Merging libata/for-next (d3f0718 Merge branch 'for-3.10-fixes' into for-next)
> Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into for-next)
> Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
> Merging pm/linux-next (fe4ae24 Merge branch 'pnp-next' into linux-next)
> Merging idle/next (5c99726b Merge branch 'fspin' into next)
> Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm)
> Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fixes-next)
> CONFLICT (content): Merge conflict in drivers/base/power/qos.c
> CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
> Merging cpupowerutils/master (f166033 cpupower tools: add install target to the debug tools' makefiles)
> Merging thermal/next (9d47550 thermal: rcar: Fix typo in probe information message)
> Merging ieee1394/for-next (6fe9efb firewire: ohci: dump_stack() for PHY regs read/write failures)
> Merging ubi/linux-next (1557b9e UBI: do not abort init when ubi.mtd devices cannot be found)
> Merging dlm/next (9000831 dlm: avoid unnecessary posix unlock)
> Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce since there are no external consumers)
> Merging scsi/for-next (222ab59 [SCSI] ipr: Avoid target_destroy accessing memory after it was freed)
> Merging target-updates/for-next (04b59ba tcm_vhost: Enable VIRTIO_SCSI_F_HOTPLUG)
> Merging target-merge/for-next-merge (b8d26b3 iser-target: Add iSCSI Extensions for RDMA (iSER) target driver)
> Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
> Merging isci/all (6734092 isci: add a couple __iomem annotations)
> Merging slave-dma/next (9562f83 DMA: AT91: Get residual bytes in dma buffer)
> Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
> Merging net-next/master (3cc7587 Documentation/sysctl/net.txt: fix (attribute removal).)
> Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch table)
> Merging wireless-next/master (f722406 Linux 3.10-rc1)
> Merging bluetooth/master (26b5afc Bluetooth: Mgmt Device Found Event)
> Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.infradead.org/linux-mtd)
> Merging l2-mtd/master (fc228fa mtd: increase max OOB size to 744)
> Merging crypto/master (00db14e crypto: sahara - remove dependency on EXPERIMENTAL)
> Merging drm/drm-next (e9ced8e drm/radeon: restore nomodeset operation (v2))
> Merging drm-intel/for-linux-next (1ffc528 drm/i915: clear the stolen fb before resuming)
> Merging sound/for-next (e44007e ALSA: hda - add PCI IDs for Intel BayTrail)
> Merging sound-asoc/for-next (01e0d55 Merge remote-tracking branch 'asoc/topic/x86' into asoc-next)
> Merging modules/modules-next (d5fe85a Merge tag 'pm+acpi-3.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
> Merging virtio/virtio-next (d5fe85a Merge tag 'pm+acpi-3.10-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
> Merging input/next (d520145 Input: w90p910_keypad - remove redundant platform_set_drvdata())
> Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in core)
> Merging cgroup/for-next (e691100 Merge branch 'for-3.11' into for-next)
> Merging block/for-next (3ba25f6 Merge branch 'for-linus' into for-next)
> Merging device-mapper/master (11531a4 Fix detection of the need to resize the dm thin metadata device.)
> Merging embedded/master (4744b43 embedded: fix vc_translate operator precedence)
> Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
> Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
> Merging mmc/mmc-next (f722406 Linux 3.10-rc1)
> Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
> Merging slab/for-next (8a965b3 mm, slab_common: Fix bootstrap creation of kmalloc caches)
> Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
> Merging md/for-next (ae59b84 dm-raid: silence compiler warning on rebuilds_per_group.)
> Merging mfd/master (43d61ee MAINTAINERS: Add Lee Jones as the MFD co-maintainer)
> CONFLICT (content): Merge conflict in drivers/mfd/intel_msic.c
> Merging battery/master (237a1b0 lp8788-charger: Fix kconfig dependency)
> Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
> Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in set_par)
> Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
> Merging regulator/for-next (0eeca66 Merge remote-tracking branch 'regulator/topic/isl6271a' into regulator-next)
> Merging security/next (4726e8f security: clarify cap_inode_getsecctx description)
> Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
> Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
> Merging watchdog/master (f722406 Linux 3.10-rc1)
> Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables before creating superpage)
> Merging iommu/next (0c4513b Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/amd', 'ppc/pamu', 'core' and 'arm/tegra' into next)
> Merging vfio/next (664e938 vfio: Set container device mode)
> Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on read error)
> Merging jc_docs/docs-next (5c050fb docs: update the development process document)
> Merging trivial/for-next (071361d mm: Convert print_symbol to %pSR)
> Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
> Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
> Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescence of IMC_DDRIO device)
> Merging edac-amd/for-next (9713fae EDAC: Merge mci.mem_is_per_rank with mci.csbased)
> Merging devicetree/devicetree/next (3132f62 Merge branch 'for-next' of git://sources.calxeda.com/kernel/linux into HEAD)
> Merging dt-rh/for-next (a2b9ea7 Documentation/devicetree: make semantic of initrd-end more explicit)
> Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the default pin configuration)
> Merging spi-mb/for-next (027cc5a Merge remote-tracking branch 'spi/topic/sirf' into spi-next)
> Merging tip/auto-latest (57e87c1 Merge branch 'timers/urgent')
> Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being added)
> Merging rcu/rcu/next (4573e86 rcu: Switch to exedited grace periods for suspend as well as hibernation)
> Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc_show)
> Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singlestep exceptions)
> Merging kvm/linux-next (f722406 Linux 3.10-rc1)
> Merging kvm-arm/kvm-arm-next (b8022d7 arm: kvm: arch_timer: use symbolic constants)
> CONFLICT (content): Merge conflict in arch/arm/kvm/arm.c
> CONFLICT (content): Merge conflict in arch/arm/include/asm/kvm_host.h
> Merging kvm-ppc/kvm-ppc-next (5975a2e KVM: PPC: Book3S: Add API for in-kernel XICS emulation)
> Merging oprofile/for-next (f722406 Linux 3.10-rc1)
> Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
> Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes)
> Merging xen-two/linux-next (f722406 Linux 3.10-rc1)
> Merging xen-arm/linux-next (3cc8e40 xen/arm: rename xen_secondary_init and run it on every online cpu)
> Merging percpu/for-next (a1b2a55 percpu: add documentation on this_cpu operations)
> Merging workqueues/for-next (bbe2a23 Merge branch 'for-3.10-fixes' into for-next)
> Merging drivers-x86/linux-next (a1ec56e Add support for fan button on Ideapad Z580)
> Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into hwpoison)
> Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may go away)
> Merging regmap/for-next (3615b6e Merge remote-tracking branch 'regmap/topic/debugfs' into regmap-next)
> Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
> Merging leds/for-next (34185fe leds: lp5562: Properly setup of_device_id table)
> Merging driver-core/driver-core-next (5240d58 sysfs: kill sysfs_sb declaration in fs/sysfs/inode.c.)
> Merging tty/tty-next (f722406 Linux 3.10-rc1)
> Merging usb/usb-next (f23eb0e usb: host: uhci-platform: Remove redundant platform_set_drvdata())
> Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
> Merging staging/staging-next (518d752 staging: fixed else format in ft1000_debug.c)
> CONFLICT (content): Merge conflict in drivers/staging/nvec/nvec_kbd.c
> Merging char-misc/char-misc-next (e7d87ca misc: ep93xx_pwm: remove unnecessary platform_set_drvdata())
> Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
> CONFLICT (content): Merge conflict in drivers/block/Kconfig
> Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
> Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in bdi_position_ratio())
> Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt boot interface)
> Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
> Merging pinctrl/for-next (e5182b8 Merge branch 'devel' into for-next)
> Merging vhost/linux-next (0107b9b x86: uaccess s/might_sleep/might_fault/)
> CONFLICT (content): Merge conflict in drivers/vhost/test.c
> Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplement memblock allocation using reverse free area iterator)
> Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies for VIRTIO)
> Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
> Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple domain first_irq)
> Merging gpio/gpio/next (08ffb22 gpio: grgpio: Add irq support)
> Merging gpio-lw/for-next (352a2d5 gpio/omap: ensure gpio context is initialised)
> Merging gen-gpio/for_next (f4c5405 gpio: update gpio Chinese documentation)
> Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of sizeof in mailbox_msg_send())
> Merging arm-soc/for-next (a0cdbee Merge branch 'fixes' into for-next)
> Merging bcm2835/for-next (ee8056f Merge branch 'for-3.11/defconfig' into for-next)
> Merging cortex/for-next (6fae9cd ARM: ARMv7-M: implement read_cpuid_ext)
> Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep93xx-for-next)
> Merging imx-mxs/for-next (8fca022 Merge branch 'mxs/dt' into for-next)
> Merging ixp4xx/next (19f949f Linux 3.8)
> Merging msm/for-next (1df357a Merge branch 'msm-defconfig' into for-next)
> Merging mvebu/for-next (fe9f82d Merge branch 'mvebu/pcie' into for-next)
> Merging renesas/next (c482a65 Merge branch 'heads/soc-sh73a0' into next)
> CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/Kconfig
> CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in renesas/next and modified in HEAD. Version HEAD of drivers/leds/leds-renesas-tpu.c left in tree.
> CONFLICT (content): Merge conflict in drivers/leds/Kconfig
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-lager.c
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadillo800eva.c
> $ git rm -f drivers/leds/leds-renesas-tpu.c
> Merging samsung/for-next (f722406 Linux 3.10-rc1)
> Merging tegra/for-next (b4dd876 Merge branch 'for-3.11/defconfig' into for-next)
> Merging dma-mapping/dma-mapping-next (c1be5a5 Linux 3.9)
> Merging pwm/for-next (c71a985 MAINTAINERS: Update PWM subsystem entry)
> Merging dma-buf/for-next (b89e356 dma-buf: Add debugfs support)
> Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesystem)
> Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different machines)
> Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
> Merging clk/clk-next (fa079b9 clk: sun5i: Add compatibles for Allwinner A13)
> Merging random/dev (b980955 random: fix locking dependency with the tasklist_lock)
> Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression speedup on ARM by using unaligned access)
> Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.org/sfrench/cifs-2.6)
> Merging akpm-current/current (e0fd9af Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband)
> $ git checkout -b akpm remotes/origin/akpm/master
> Applying: drivers/block/xsysace.c: fix id with missing port-number
> Applying: rapidio: make enumeration/discovery configurable
> Applying: rapidio: add enumeration/discovery start from user space
> Applying: rapidio: documentation update for enumeration changes
> Applying: fat: fix possible overflow for fat_clusters
> Applying: wait: fix false timeouts when using wait_event_timeout()
> Applying: mm: mmu_notifier: re-fix freed page still mapped in secondary MMU
> Applying: mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix
> Applying: ocfs2: unlock rw lock if inode lock failed
> Applying: drivers/video: implement a simple framebuffer driver
> Applying: mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge
> Applying: hfs: avoid crash in hfs_bnode_create
> Applying: CPU hotplug: provide a generic helper to disable/enable CPU hotplug
> Applying: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix
> Applying: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix
> Applying: reboot: rigrate shutdown/reboot to boot cpu
> Applying: shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix
> Applying: rapidio/tsi721: fix bug in MSI interrupt handling
> Applying: mm compaction: fix of improper cache flush in migration code
> Applying: kernel/audit_tree.c:audit_add_tree_rule(): protect `rule' from kill_rules()
> Applying: ipcsem-fix-semctl-getzcnt-fix
> Applying: ipcsem-fix-semctl-getncnt-fix
> Applying: MAINTAINERS: update Hyper-V file list
> Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
> Applying: kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix
> Applying: drivers/char/random.c: fix priming of last_data
> Applying: random: fix accounting race condition with lockless irq entropy_count update
> Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
> Applying: x86: make 'mem=' option to work for efi platform
> Applying: audit: fix mq_open and mq_unlink to add the MQ root as a hidden parent audit_names record
> Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in progress
> Applying: cyber2000fb: avoid palette corruption at higher clocks
> Applying: posix_cpu_timer: consolidate expiry time type
> Applying: posix_cpu_timers: consolidate timer list cleanups
> Applying: posix_cpu_timers: consolidate expired timers check
> Applying: selftests: add basic posix timers selftests
> Applying: posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
> Applying: posix_timers: Fix racy timer delta caching on task exit
> Applying: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
> Applying: configfs: use capped length for ->store_attribute()
> Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
> Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
> Applying: lglock: update lockdep annotations to report recursive local locks
> Applying: block: restore /proc/partitions to not display non-partitionable removable devices
> Applying: watchdog: trigger all-cpu backtrace when locked up and going to panic
> Applying: clear_refs: sanitize accepted commands declaration
> Applying: clear_refs: introduce private struct for mm_walk
> Applying: pagemap: introduce pagemap_entry_t without pmshift bits
> Applying: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
> Applying: mm: soft-dirty bits for user memory changes tracking
> Applying: pagemap: prepare to reuse constant bits with page-shift
> Applying: mm/thp: use the correct function when updating access flags
> Applying: mm, memcg: don't take task_lock in task_in_mem_cgroup
> Applying: mm: remove free_area_cache
> Applying: mm: remove compressed copy from zram in-memory
> Applying: mm-remove-compressed-copy-from-zram-in-memory-fix
> Applying: mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
> Applying: include/linux/mmzone.h: cleanups
> Applying: include-linux-mmzoneh-cleanups-fix
> Applying: mm: memmap_init_zone() performance improvement
> Applying: drop_caches: add some documentation and info message
> Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() with NULL dev
> Applying: mm/dmapool.c: fix null dev in dma_pool_create()
> Applying: memcg: debugging facility to access dangling memcgs
> Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
> Applying: mm: add vm event counters for balloon pages compaction
> Applying: err.h: IS_ERR() can accept __user pointers
> Applying: dump_stack: serialize the output from dump_stack()
> Applying: dump_stack-serialize-the-output-from-dump_stack-fix
> Applying: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
> Applying: panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix
> Applying: smp: Give WARN()ing when calling smp_call_function_many()/single() in serving irq
> Applying: backlight: atmel-pwm-bl: remove unnecessary platform_set_drvdata()
> Applying: backlight: ep93xx: remove unnecessary platform_set_drvdata()
> Applying: backlight: lp8788: remove unnecessary platform_set_drvdata()
> Applying: backlight: pcf50633: remove unnecessary platform_set_drvdata()
> Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
> Applying: lib/bitmap.c: speed up bitmap_find_free_region
> Applying: lib-bitmapc-speed-up-bitmap_find_free_region-fix
> Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
> Applying: init: remove permanent string buffer from do_one_initcall()
> Applying: autofs4: allow autofs to work outside the initial PID namespace
> Applying: autofs4: translate pids to the right namespace for the daemon
> Applying: rtc: rtc-88pm80x: remove unnecessary platform_set_drvdata()
> Applying: drivers/rtc/rtc-v3020.c: remove redundant goto
> Applying: drivers/rtc/interface.c: fix checkpatch errors
> Applying: drivers/rtc/rtc-at32ap700x.c: fix checkpatch error
> Applying: drivers/rtc/rtc-at91rm9200.c: include <linux/uaccess.h>
> Applying: drivers/rtc/rtc-cmos.c: fix whitespace related errors
> Applying: drivers/rtc/rtc-davinci.c: fix whitespace warning
> Applying: drivers/rtc/rtc-ds1305.c: add missing braces around sizeof
> Applying: drivers/rtc/rtc-ds1374.c: fix spacing related issues
> Applying: drivers/rtc/rtc-ds1511.c: fix issues related to spaces and braces
> Applying: drivers/rtc/rtc-ds3234.c: fix whitespace issue
> Applying: drivers/rtc/rtc-fm3130.c: fix whitespace related issue
> Applying: drivers/rtc/rtc-m41t80.c: fix spacing related issue
> Applying: drivers/rtc/rtc-max6902.c: remove unwanted spaces
> Applying: drivers/rtc/rtc-max77686.c: remove space before semicolon
> Applying: drivers/rtc/rtc-max8997.c: remove space before semicolon
> Applying: drivers/rtc/rtc-mpc5121.c: remove space before tab
> Applying: drivers/rtc/rtc-msm6242.c: use pr_warn
> Applying: drivers/rtc/rtc-mxc.c: fix checkpatch error
> Applying: drivers/rtc/rtc-omap.c: include <linux/io.h> instead of <asm/io.h>
> Applying: drivers/rtc/rtc-pcf2123.c: remove space before tabs
> Applying: drivers/rtc/rtc-pcf8583.c: move assignment outside if condition
> Applying: drivers/rtc/rtc-rs5c313.c: include <linux/io.h> instead of <asm/io.h>
> Applying: drivers/rtc/rtc-rs5c313.c: fix spacing related issues
> Applying: drivers/rtc/rtc-v3020.c: fix spacing issues
> Applying: drivers/rtc/rtc-vr41xx.c: fix spacing issues
> Applying: drivers/rtc/rtc-x1205.c: fix checkpatch issues
> Applying: rtc: rtc-88pm860x: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-ab3100: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-ab8500: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-at32ap700x: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-at91rm9200: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-at91sam9: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-au1xxx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-bfin: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-bq4802: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-coh901331: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-da9052: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-da9055: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-davinci: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-dm355evm: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-ds1302: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-ep93xx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-jz4740: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-lp8788: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-lpc32xx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-ls1x: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-m48t59: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-max8925: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-max8998: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-mc13xxx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-msm6242: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-mxc: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-nuc900: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-pcap: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-pm8xxx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-s3c: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-sa1100: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-sh: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-spear: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-stmp3xxx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-twl: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-vr41xx: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-vt8500: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-m48t86: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-puv3: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-rp5c01: remove unnecessary platform_set_drvdata()
> Applying: rtc: rtc-tile: remove unnecessary platform_set_drvdata()
> Applying: reiserfs: fix deadlock with nfs racing on create/lookup
> Applying: fat: additions to support fat_fallocate
> Applying: fat-additions-to-support-fat_fallocate-fix
> Applying: idr: print a stack dump after ida_remove warning
> Applying: idr-print-a-stack-dump-after-ida_remove-warning-fix
> Applying: mwave: fix info leak in mwave_ioctl()
> Applying: rapidio/switches: remove tsi500 driver
> Applying: drivers/parport/share.c: use kzalloc
> Applying: drivers/w1/slaves/w1_ds2408.c: add magic sequence to disable P0 test mode
> Applying: drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix
> Applying: relay: fix timer madness
> Applying: aio: reqs_active -> reqs_available
> Applying: aio: percpu reqs_available
> Applying: generic dynamic per cpu refcounting
> Applying: aio: percpu ioctx refcount
> Applying: aio: use xchg() instead of completion_lock
> Applying: block: prep work for batch completion
> CONFLICT (content): Merge conflict in fs/btrfs/volumes.c
> CONFLICT (content): Merge conflict in fs/btrfs/inode.c
> Applying: block-prep-work-for-batch-completion-fix-2
> Applying: block-prep-work-for-batch-completion-fix-3
> Applying: block-prep-work-for-batch-completion-fix-3-fix
> Applying: block-prep-work-for-batch-completion-fix-99
> Applying: block-aio-batch-completion-for-bios-kiocbs-fix
> Applying: block, aio: batch completion for bios/kiocbs
> Applying: virtio-blk: convert to batch completion
> Applying: mtip32xx: convert to batch completion
> Applying: aio: fix kioctx not being freed after cancellation at exit time
> Applying: lib: add weak clz/ctz functions
> Applying: decompressor: add LZ4 decompressor module
> Applying: lib: add support for LZ4-compressed kernel
> Applying: kbuild: fix for updated LZ4 tool with the new streaming format
> Applying: arm: add support for LZ4-compressed kernel
> Applying: arm: Remove enforced Os flag for LZ4 decompressor
> Applying: x86: add support for LZ4-compressed kernel
> Applying: x86, doc: Add LZ4 magic number for the new compression
> Applying: lib: add lz4 compressor module
> Applying: lib-add-lz4-compressor-module-fix
> Applying: crypto: add lz4 Cryptographic API
> Applying: crypto-add-lz4-cryptographic-api-fix
> Applying: scripts/sortextable.c: fix building on non-Linux systems
> Applying: seccomp: add generic code for jitted seccomp filters.
> Applying: ARM: net: bpf_jit: make code generation less dependent on struct sk_filter.
> Applying: ARM: bpf_jit: seccomp filtering: fixup merge conflict
> Applying: ARM: net: bpf_jit: add support for jitted seccomp filters.
> Applying: bpf: add comments explaining the schedule_work() operation
> CONFLICT (content): Merge conflict in arch/x86/net/bpf_jit_comp.c
> CONFLICT (content): Merge conflict in arch/sparc/net/bpf_jit_comp.c
> Merging akpm/master (dc222b2 bpf: add comments explaining the schedule_work() operation)
> 
--8323328-410157428-1369047873=:26558
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=cfg1
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.02.1305201904120.26558@M2420>
Content-Description: 
Content-Disposition: attachment; filename=cfg1

Iw0KIyBBdXRvbWF0aWNhbGx5IGdlbmVyYXRlZCBmaWxlOyBETyBOT1QgRURJ
VC4NCiMgTGludXgveDg2IDMuMTAuMC1yYzEgS2VybmVsIENvbmZpZ3VyYXRp
b24NCiMNCiMgQ09ORklHXzY0QklUIGlzIG5vdCBzZXQNCkNPTkZJR19YODZf
MzI9eQ0KQ09ORklHX1g4Nj15DQpDT05GSUdfSU5TVFJVQ1RJT05fREVDT0RF
Uj15DQpDT05GSUdfT1VUUFVUX0ZPUk1BVD0iZWxmMzItaTM4NiINCkNPTkZJ
R19BUkNIX0RFRkNPTkZJRz0iYXJjaC94ODYvY29uZmlncy9pMzg2X2RlZmNv
bmZpZyINCkNPTkZJR19MT0NLREVQX1NVUFBPUlQ9eQ0KQ09ORklHX1NUQUNL
VFJBQ0VfU1VQUE9SVD15DQpDT05GSUdfSEFWRV9MQVRFTkNZVE9QX1NVUFBP
UlQ9eQ0KQ09ORklHX01NVT15DQpDT05GSUdfTkVFRF9ETUFfTUFQX1NUQVRF
PXkNCkNPTkZJR19ORUVEX1NHX0RNQV9MRU5HVEg9eQ0KQ09ORklHX0dFTkVS
SUNfSVNBX0RNQT15DQpDT05GSUdfR0VORVJJQ19IV0VJR0hUPXkNCkNPTkZJ
R19BUkNIX01BWV9IQVZFX1BDX0ZEQz15DQpDT05GSUdfUldTRU1fWENIR0FE
RF9BTEdPUklUSE09eQ0KQ09ORklHX0dFTkVSSUNfQ0FMSUJSQVRFX0RFTEFZ
PXkNCkNPTkZJR19BUkNIX0hBU19DUFVfUkVMQVg9eQ0KQ09ORklHX0FSQ0hf
SEFTX0NBQ0hFX0xJTkVfU0laRT15DQpDT05GSUdfQVJDSF9IQVNfQ1BVX0FV
VE9QUk9CRT15DQpDT05GSUdfSEFWRV9TRVRVUF9QRVJfQ1BVX0FSRUE9eQ0K
Q09ORklHX05FRURfUEVSX0NQVV9FTUJFRF9GSVJTVF9DSFVOSz15DQpDT05G
SUdfTkVFRF9QRVJfQ1BVX1BBR0VfRklSU1RfQ0hVTks9eQ0KQ09ORklHX0FS
Q0hfSElCRVJOQVRJT05fUE9TU0lCTEU9eQ0KQ09ORklHX0FSQ0hfU1VTUEVO
RF9QT1NTSUJMRT15DQojIENPTkZJR19aT05FX0RNQTMyIGlzIG5vdCBzZXQN
CiMgQ09ORklHX0FVRElUX0FSQ0ggaXMgbm90IHNldA0KQ09ORklHX0FSQ0hf
U1VQUE9SVFNfT1BUSU1JWkVEX0lOTElOSU5HPXkNCkNPTkZJR19BUkNIX1NV
UFBPUlRTX0RFQlVHX1BBR0VBTExPQz15DQpDT05GSUdfQVJDSF9IV0VJR0hU
X0NGTEFHUz0iLWZjYWxsLXNhdmVkLWVjeCAtZmNhbGwtc2F2ZWQtZWR4Ig0K
Q09ORklHX0FSQ0hfU1VQUE9SVFNfVVBST0JFUz15DQpDT05GSUdfREVGQ09O
RklHX0xJU1Q9Ii9saWIvbW9kdWxlcy8kVU5BTUVfUkVMRUFTRS8uY29uZmln
Ig0KQ09ORklHX0lSUV9XT1JLPXkNCkNPTkZJR19CVUlMRFRJTUVfRVhUQUJM
RV9TT1JUPXkNCg0KIw0KIyBHZW5lcmFsIHNldHVwDQojDQpDT05GSUdfQlJP
S0VOX09OX1NNUD15DQpDT05GSUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyDQpD
T05GSUdfQ1JPU1NfQ09NUElMRT0iIg0KQ09ORklHX0xPQ0FMVkVSU0lPTj0i
Ig0KQ09ORklHX0xPQ0FMVkVSU0lPTl9BVVRPPXkNCkNPTkZJR19IQVZFX0tF
Uk5FTF9HWklQPXkNCkNPTkZJR19IQVZFX0tFUk5FTF9CWklQMj15DQpDT05G
SUdfSEFWRV9LRVJORUxfTFpNQT15DQpDT05GSUdfSEFWRV9LRVJORUxfWFo9
eQ0KQ09ORklHX0hBVkVfS0VSTkVMX0xaTz15DQpDT05GSUdfSEFWRV9LRVJO
RUxfTFo0PXkNCiMgQ09ORklHX0tFUk5FTF9HWklQIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0tFUk5FTF9CWklQMiBpcyBub3Qgc2V0DQojIENPTkZJR19LRVJO
RUxfTFpNQSBpcyBub3Qgc2V0DQojIENPTkZJR19LRVJORUxfWFogaXMgbm90
IHNldA0KQ09ORklHX0tFUk5FTF9MWk89eQ0KIyBDT05GSUdfS0VSTkVMX0xa
NCBpcyBub3Qgc2V0DQpDT05GSUdfREVGQVVMVF9IT1NUTkFNRT0iKG5vbmUp
Ig0KQ09ORklHX1NZU1ZJUEM9eQ0KQ09ORklHX1BPU0lYX01RVUVVRT15DQoj
IENPTkZJR19GSEFORExFIGlzIG5vdCBzZXQNCkNPTkZJR19BVURJVD15DQpD
T05GSUdfQVVESVRTWVNDQUxMPXkNCkNPTkZJR19BVURJVF9XQVRDSD15DQpD
T05GSUdfQVVESVRfVFJFRT15DQpDT05GSUdfQVVESVRfTE9HSU5VSURfSU1N
VVRBQkxFPXkNCkNPTkZJR19IQVZFX0dFTkVSSUNfSEFSRElSUVM9eQ0KDQoj
DQojIElSUSBzdWJzeXN0ZW0NCiMNCkNPTkZJR19HRU5FUklDX0hBUkRJUlFT
PXkNCkNPTkZJR19HRU5FUklDX0lSUV9QUk9CRT15DQpDT05GSUdfR0VORVJJ
Q19JUlFfU0hPVz15DQpDT05GSUdfSVJRX0RPTUFJTj15DQojIENPTkZJR19J
UlFfRE9NQUlOX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19JUlFfRk9SQ0VE
X1RIUkVBRElORz15DQpDT05GSUdfU1BBUlNFX0lSUT15DQpDT05GSUdfQ0xP
Q0tTT1VSQ0VfV0FUQ0hET0c9eQ0KQ09ORklHX0tUSU1FX1NDQUxBUj15DQpD
T05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15DQpDT05GSUdfR0VORVJJQ19D
TE9DS0VWRU5UU19CVUlMRD15DQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5U
U19CUk9BRENBU1Q9eQ0KQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfTUlO
X0FESlVTVD15DQpDT05GSUdfR0VORVJJQ19DTU9TX1VQREFURT15DQoNCiMN
CiMgVGltZXJzIHN1YnN5c3RlbQ0KIw0KQ09ORklHX1RJQ0tfT05FU0hPVD15
DQpDT05GSUdfTk9fSFpfQ09NTU9OPXkNCiMgQ09ORklHX0haX1BFUklPRElD
IGlzIG5vdCBzZXQNCkNPTkZJR19OT19IWl9JRExFPXkNCkNPTkZJR19OT19I
Wj15DQojIENPTkZJR19ISUdIX1JFU19USU1FUlMgaXMgbm90IHNldA0KDQoj
DQojIENQVS9UYXNrIHRpbWUgYW5kIHN0YXRzIGFjY291bnRpbmcNCiMNCiMg
Q09ORklHX1RJQ0tfQ1BVX0FDQ09VTlRJTkcgaXMgbm90IHNldA0KQ09ORklH
X0lSUV9USU1FX0FDQ09VTlRJTkc9eQ0KQ09ORklHX0JTRF9QUk9DRVNTX0FD
Q1Q9eQ0KIyBDT05GSUdfQlNEX1BST0NFU1NfQUNDVF9WMyBpcyBub3Qgc2V0
DQojIENPTkZJR19UQVNLU1RBVFMgaXMgbm90IHNldA0KDQojDQojIFJDVSBT
dWJzeXN0ZW0NCiMNCkNPTkZJR19USU5ZX1JDVT15DQojIENPTkZJR19QUkVF
TVBUX1JDVSBpcyBub3Qgc2V0DQpDT05GSUdfUkNVX1NUQUxMX0NPTU1PTj15
DQojIENPTkZJR19UUkVFX1JDVV9UUkFDRSBpcyBub3Qgc2V0DQpDT05GSUdf
SUtDT05GSUc9bQ0KQ09ORklHX0xPR19CVUZfU0hJRlQ9MTcNCkNPTkZJR19I
QVZFX1VOU1RBQkxFX1NDSEVEX0NMT0NLPXkNCkNPTkZJR19BUkNIX1NVUFBP
UlRTX05VTUFfQkFMQU5DSU5HPXkNCkNPTkZJR19BUkNIX1dBTlRTX1BST1Rf
TlVNQV9QUk9UX05PTkU9eQ0KQ09ORklHX0NHUk9VUFM9eQ0KQ09ORklHX0NH
Uk9VUF9ERUJVRz15DQojIENPTkZJR19DR1JPVVBfRlJFRVpFUiBpcyBub3Qg
c2V0DQpDT05GSUdfQ0dST1VQX0RFVklDRT15DQojIENPTkZJR19DUFVTRVRT
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0NHUk9VUF9DUFVBQ0NUIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1JFU09VUkNFX0NPVU5URVJTIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0NHUk9VUF9QRVJGIGlzIG5vdCBzZXQNCkNPTkZJR19DR1JPVVBf
U0NIRUQ9eQ0KQ09ORklHX0ZBSVJfR1JPVVBfU0NIRUQ9eQ0KQ09ORklHX0NG
U19CQU5EV0lEVEg9eQ0KIyBDT05GSUdfUlRfR1JPVVBfU0NIRUQgaXMgbm90
IHNldA0KQ09ORklHX0NIRUNLUE9JTlRfUkVTVE9SRT15DQpDT05GSUdfTkFN
RVNQQUNFUz15DQpDT05GSUdfVVRTX05TPXkNCkNPTkZJR19JUENfTlM9eQ0K
IyBDT05GSUdfVVNFUl9OUyBpcyBub3Qgc2V0DQpDT05GSUdfUElEX05TPXkN
CkNPTkZJR19ORVRfTlM9eQ0KQ09ORklHX1VJREdJRF9DT05WRVJURUQ9eQ0K
IyBDT05GSUdfVUlER0lEX1NUUklDVF9UWVBFX0NIRUNLUyBpcyBub3Qgc2V0
DQpDT05GSUdfU0NIRURfQVVUT0dST1VQPXkNCkNPTkZJR19TWVNGU19ERVBS
RUNBVEVEPXkNCiMgQ09ORklHX1NZU0ZTX0RFUFJFQ0FURURfVjIgaXMgbm90
IHNldA0KIyBDT05GSUdfUkVMQVkgaXMgbm90IHNldA0KIyBDT05GSUdfQkxL
X0RFVl9JTklUUkQgaXMgbm90IHNldA0KQ09ORklHX0NDX09QVElNSVpFX0ZP
Ul9TSVpFPXkNCkNPTkZJR19BTk9OX0lOT0RFUz15DQpDT05GSUdfSEFWRV9V
SUQxNj15DQpDT05GSUdfU1lTQ1RMX0VYQ0VQVElPTl9UUkFDRT15DQpDT05G
SUdfSE9UUExVRz15DQpDT05GSUdfSEFWRV9QQ1NQS1JfUExBVEZPUk09eQ0K
Q09ORklHX0VYUEVSVD15DQojIENPTkZJR19VSUQxNiBpcyBub3Qgc2V0DQpD
T05GSUdfS0FMTFNZTVM9eQ0KQ09ORklHX0tBTExTWU1TX0FMTD15DQojIENP
TkZJR19QUklOVEsgaXMgbm90IHNldA0KIyBDT05GSUdfQlVHIGlzIG5vdCBz
ZXQNCkNPTkZJR19FTEZfQ09SRT15DQpDT05GSUdfUENTUEtSX1BMQVRGT1JN
PXkNCiMgQ09ORklHX0JBU0VfRlVMTCBpcyBub3Qgc2V0DQojIENPTkZJR19G
VVRFWCBpcyBub3Qgc2V0DQpDT05GSUdfRVBPTEw9eQ0KQ09ORklHX1NJR05B
TEZEPXkNCiMgQ09ORklHX1RJTUVSRkQgaXMgbm90IHNldA0KQ09ORklHX0VW
RU5URkQ9eQ0KQ09ORklHX1NITUVNPXkNCiMgQ09ORklHX0FJTyBpcyBub3Qg
c2V0DQpDT05GSUdfRU1CRURERUQ9eQ0KQ09ORklHX0hBVkVfUEVSRl9FVkVO
VFM9eQ0KQ09ORklHX1BFUkZfVVNFX1ZNQUxMT0M9eQ0KDQojDQojIEtlcm5l
bCBQZXJmb3JtYW5jZSBFdmVudHMgQW5kIENvdW50ZXJzDQojDQpDT05GSUdf
UEVSRl9FVkVOVFM9eQ0KQ09ORklHX0RFQlVHX1BFUkZfVVNFX1ZNQUxMT0M9
eQ0KIyBDT05GSUdfVk1fRVZFTlRfQ09VTlRFUlMgaXMgbm90IHNldA0KQ09O
RklHX1NMVUJfREVCVUc9eQ0KIyBDT05GSUdfQ09NUEFUX0JSSyBpcyBub3Qg
c2V0DQojIENPTkZJR19TTEFCIGlzIG5vdCBzZXQNCkNPTkZJR19TTFVCPXkN
CiMgQ09ORklHX1NMT0IgaXMgbm90IHNldA0KQ09ORklHX1BST0ZJTElORz15
DQpDT05GSUdfVFJBQ0VQT0lOVFM9eQ0KQ09ORklHX09QUk9GSUxFPW0NCiMg
Q09ORklHX09QUk9GSUxFX0VWRU5UX01VTFRJUExFWCBpcyBub3Qgc2V0DQpD
T05GSUdfSEFWRV9PUFJPRklMRT15DQpDT05GSUdfT1BST0ZJTEVfTk1JX1RJ
TUVSPXkNCiMgQ09ORklHX0tQUk9CRVMgaXMgbm90IHNldA0KQ09ORklHX0pV
TVBfTEFCRUw9eQ0KIyBDT05GSUdfSEFWRV82NEJJVF9BTElHTkVEX0FDQ0VT
UyBpcyBub3Qgc2V0DQpDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVE
X0FDQ0VTUz15DQpDT05GSUdfQVJDSF9VU0VfQlVJTFRJTl9CU1dBUD15DQpD
T05GSUdfSEFWRV9JT1JFTUFQX1BST1Q9eQ0KQ09ORklHX0hBVkVfS1BST0JF
Uz15DQpDT05GSUdfSEFWRV9LUkVUUFJPQkVTPXkNCkNPTkZJR19IQVZFX09Q
VFBST0JFUz15DQpDT05GSUdfSEFWRV9LUFJPQkVTX09OX0ZUUkFDRT15DQpD
T05GSUdfSEFWRV9BUkNIX1RSQUNFSE9PSz15DQpDT05GSUdfSEFWRV9ETUFf
QVRUUlM9eQ0KQ09ORklHX0hBVkVfRE1BX0NPTlRJR1VPVVM9eQ0KQ09ORklH
X0dFTkVSSUNfU01QX0lETEVfVEhSRUFEPXkNCkNPTkZJR19IQVZFX1JFR1Nf
QU5EX1NUQUNLX0FDQ0VTU19BUEk9eQ0KQ09ORklHX0hBVkVfRE1BX0FQSV9E
RUJVRz15DQpDT05GSUdfSEFWRV9IV19CUkVBS1BPSU5UPXkNCkNPTkZJR19I
QVZFX01JWEVEX0JSRUFLUE9JTlRTX1JFR1M9eQ0KQ09ORklHX0hBVkVfVVNF
Ul9SRVRVUk5fTk9USUZJRVI9eQ0KQ09ORklHX0hBVkVfUEVSRl9FVkVOVFNf
Tk1JPXkNCkNPTkZJR19IQVZFX1BFUkZfUkVHUz15DQpDT05GSUdfSEFWRV9Q
RVJGX1VTRVJfU1RBQ0tfRFVNUD15DQpDT05GSUdfSEFWRV9BUkNIX0pVTVBf
TEFCRUw9eQ0KQ09ORklHX0FSQ0hfSEFWRV9OTUlfU0FGRV9DTVBYQ0hHPXkN
CkNPTkZJR19IQVZFX0FMSUdORURfU1RSVUNUX1BBR0U9eQ0KQ09ORklHX0hB
VkVfQ01QWENIR19MT0NBTD15DQpDT05GSUdfSEFWRV9DTVBYQ0hHX0RPVUJM
RT15DQpDT05GSUdfQVJDSF9XQU5UX0lQQ19QQVJTRV9WRVJTSU9OPXkNCkNP
TkZJR19IQVZFX0FSQ0hfU0VDQ09NUF9GSUxURVI9eQ0KQ09ORklHX0hBVkVf
SVJRX1RJTUVfQUNDT1VOVElORz15DQpDT05GSUdfSEFWRV9BUkNIX1RSQU5T
UEFSRU5UX0hVR0VQQUdFPXkNCkNPTkZJR19IQVZFX0FSQ0hfU09GVF9ESVJU
WT15DQpDT05GSUdfTU9EVUxFU19VU0VfRUxGX1JFTD15DQpDT05GSUdfQ0xP
TkVfQkFDS1dBUkRTPXkNCkNPTkZJR19PTERfU0lHU1VTUEVORDM9eQ0KQ09O
RklHX09MRF9TSUdBQ1RJT049eQ0KDQojDQojIEdDT1YtYmFzZWQga2VybmVs
IHByb2ZpbGluZw0KIw0KIyBDT05GSUdfR0NPVl9LRVJORUwgaXMgbm90IHNl
dA0KQ09ORklHX0hBVkVfR0VORVJJQ19ETUFfQ09IRVJFTlQ9eQ0KQ09ORklH
X1JUX01VVEVYRVM9eQ0KQ09ORklHX0JBU0VfU01BTEw9MQ0KQ09ORklHX01P
RFVMRVM9eQ0KIyBDT05GSUdfTU9EVUxFX0ZPUkNFX0xPQUQgaXMgbm90IHNl
dA0KQ09ORklHX01PRFVMRV9VTkxPQUQ9eQ0KQ09ORklHX01PRFVMRV9GT1JD
RV9VTkxPQUQ9eQ0KQ09ORklHX01PRFZFUlNJT05TPXkNCiMgQ09ORklHX01P
RFVMRV9TUkNWRVJTSU9OX0FMTCBpcyBub3Qgc2V0DQojIENPTkZJR19NT0RV
TEVfU0lHIGlzIG5vdCBzZXQNCiMgQ09ORklHX0JMT0NLIGlzIG5vdCBzZXQN
CkNPTkZJR19VTklOTElORV9TUElOX1VOTE9DSz15DQpDT05GSUdfRlJFRVpF
Uj15DQoNCiMNCiMgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVzDQojDQoj
IENPTkZJR19aT05FX0RNQSBpcyBub3Qgc2V0DQojIENPTkZJR19TTVAgaXMg
bm90IHNldA0KQ09ORklHX1g4Nl9NUFBBUlNFPXkNCkNPTkZJR19HT0xERklT
SD15DQpDT05GSUdfWDg2X0VYVEVOREVEX1BMQVRGT1JNPXkNCkNPTkZJR19Y
ODZfR09MREZJU0g9eQ0KIyBDT05GSUdfWDg2X1dBTlRfSU5URUxfTUlEIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1g4Nl9SREMzMjFYIGlzIG5vdCBzZXQNCkNP
TkZJR19YODZfMzJfSVJJUz15DQojIENPTkZJR19TQ0hFRF9PTUlUX0ZSQU1F
X1BPSU5URVIgaXMgbm90IHNldA0KQ09ORklHX0hZUEVSVklTT1JfR1VFU1Q9
eQ0KQ09ORklHX1BBUkFWSVJUPXkNCiMgQ09ORklHX1BBUkFWSVJUX0RFQlVH
IGlzIG5vdCBzZXQNCiMgQ09ORklHX1hFTl9QUklWSUxFR0VEX0dVRVNUIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0tWTV9HVUVTVCBpcyBub3Qgc2V0DQpDT05G
SUdfTEdVRVNUX0dVRVNUPXkNCiMgQ09ORklHX1BBUkFWSVJUX1RJTUVfQUND
T1VOVElORyBpcyBub3Qgc2V0DQpDT05GSUdfTk9fQk9PVE1FTT15DQojIENP
TkZJR19NRU1URVNUIGlzIG5vdCBzZXQNCiMgQ09ORklHX000ODYgaXMgbm90
IHNldA0KIyBDT05GSUdfTTU4NiBpcyBub3Qgc2V0DQojIENPTkZJR19NNTg2
VFNDIGlzIG5vdCBzZXQNCiMgQ09ORklHX001ODZNTVggaXMgbm90IHNldA0K
Q09ORklHX002ODY9eQ0KIyBDT05GSUdfTVBFTlRJVU1JSSBpcyBub3Qgc2V0
DQojIENPTkZJR19NUEVOVElVTUlJSSBpcyBub3Qgc2V0DQojIENPTkZJR19N
UEVOVElVTU0gaXMgbm90IHNldA0KIyBDT05GSUdfTVBFTlRJVU00IGlzIG5v
dCBzZXQNCiMgQ09ORklHX01LNiBpcyBub3Qgc2V0DQojIENPTkZJR19NSzcg
aXMgbm90IHNldA0KIyBDT05GSUdfTUs4IGlzIG5vdCBzZXQNCiMgQ09ORklH
X01DUlVTT0UgaXMgbm90IHNldA0KIyBDT05GSUdfTUVGRklDRU9OIGlzIG5v
dCBzZXQNCiMgQ09ORklHX01XSU5DSElQQzYgaXMgbm90IHNldA0KIyBDT05G
SUdfTVdJTkNISVAzRCBpcyBub3Qgc2V0DQojIENPTkZJR19NRUxBTiBpcyBu
b3Qgc2V0DQojIENPTkZJR19NR0VPREVHWDEgaXMgbm90IHNldA0KIyBDT05G
SUdfTUdFT0RFX0xYIGlzIG5vdCBzZXQNCiMgQ09ORklHX01DWVJJWElJSSBp
cyBub3Qgc2V0DQojIENPTkZJR19NVklBQzNfMiBpcyBub3Qgc2V0DQojIENP
TkZJR19NVklBQzcgaXMgbm90IHNldA0KIyBDT05GSUdfTUNPUkUyIGlzIG5v
dCBzZXQNCiMgQ09ORklHX01BVE9NIGlzIG5vdCBzZXQNCiMgQ09ORklHX1g4
Nl9HRU5FUklDIGlzIG5vdCBzZXQNCkNPTkZJR19YODZfSU5URVJOT0RFX0NB
Q0hFX1NISUZUPTUNCkNPTkZJR19YODZfTDFfQ0FDSEVfU0hJRlQ9NQ0KIyBD
T05GSUdfWDg2X1BQUk9fRkVOQ0UgaXMgbm90IHNldA0KQ09ORklHX1g4Nl9V
U0VfUFBST19DSEVDS1NVTT15DQpDT05GSUdfWDg2X1RTQz15DQpDT05GSUdf
WDg2X0NNUFhDSEc2ND15DQpDT05GSUdfWDg2X0NNT1Y9eQ0KQ09ORklHX1g4
Nl9NSU5JTVVNX0NQVV9GQU1JTFk9NQ0KQ09ORklHX1g4Nl9ERUJVR0NUTE1T
Uj15DQpDT05GSUdfUFJPQ0VTU09SX1NFTEVDVD15DQpDT05GSUdfQ1BVX1NV
UF9JTlRFTD15DQpDT05GSUdfQ1BVX1NVUF9DWVJJWF8zMj15DQpDT05GSUdf
Q1BVX1NVUF9BTUQ9eQ0KQ09ORklHX0NQVV9TVVBfQ0VOVEFVUj15DQpDT05G
SUdfQ1BVX1NVUF9UUkFOU01FVEFfMzI9eQ0KIyBDT05GSUdfQ1BVX1NVUF9V
TUNfMzIgaXMgbm90IHNldA0KQ09ORklHX0hQRVRfVElNRVI9eQ0KIyBDT05G
SUdfRE1JIGlzIG5vdCBzZXQNCkNPTkZJR19OUl9DUFVTPTENCiMgQ09ORklH
X1BSRUVNUFRfTk9ORSBpcyBub3Qgc2V0DQpDT05GSUdfUFJFRU1QVF9WT0xV
TlRBUlk9eQ0KIyBDT05GSUdfUFJFRU1QVCBpcyBub3Qgc2V0DQpDT05GSUdf
UFJFRU1QVF9DT1VOVD15DQpDT05GSUdfWDg2X1VQX0FQSUM9eQ0KQ09ORklH
X1g4Nl9VUF9JT0FQSUM9eQ0KQ09ORklHX1g4Nl9MT0NBTF9BUElDPXkNCkNP
TkZJR19YODZfSU9fQVBJQz15DQpDT05GSUdfWDg2X1JFUk9VVEVfRk9SX0JS
T0tFTl9CT09UX0lSUVM9eQ0KIyBDT05GSUdfWDg2X01DRSBpcyBub3Qgc2V0
DQojIENPTkZJR19WTTg2IGlzIG5vdCBzZXQNCiMgQ09ORklHX1RPU0hJQkEg
aXMgbm90IHNldA0KQ09ORklHX0k4Sz15DQpDT05GSUdfWDg2X1JFQk9PVEZJ
WFVQUz15DQpDT05GSUdfTUlDUk9DT0RFPXkNCiMgQ09ORklHX01JQ1JPQ09E
RV9JTlRFTCBpcyBub3Qgc2V0DQojIENPTkZJR19NSUNST0NPREVfQU1EIGlz
IG5vdCBzZXQNCkNPTkZJR19NSUNST0NPREVfT0xEX0lOVEVSRkFDRT15DQpD
T05GSUdfWDg2X01TUj15DQpDT05GSUdfWDg2X0NQVUlEPW0NCiMgQ09ORklH
X05PSElHSE1FTSBpcyBub3Qgc2V0DQpDT05GSUdfSElHSE1FTTRHPXkNCiMg
Q09ORklHX0hJR0hNRU02NEcgaXMgbm90IHNldA0KIyBDT05GSUdfVk1TUExJ
VF8zRyBpcyBub3Qgc2V0DQpDT05GSUdfVk1TUExJVF8zR19PUFQ9eQ0KIyBD
T05GSUdfVk1TUExJVF8yRyBpcyBub3Qgc2V0DQojIENPTkZJR19WTVNQTElU
XzJHX09QVCBpcyBub3Qgc2V0DQojIENPTkZJR19WTVNQTElUXzFHIGlzIG5v
dCBzZXQNCkNPTkZJR19QQUdFX09GRlNFVD0weEIwMDAwMDAwDQpDT05GSUdf
SElHSE1FTT15DQpDT05GSUdfQVJDSF9GTEFUTUVNX0VOQUJMRT15DQpDT05G
SUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxFPXkNCkNPTkZJR19BUkNIX1NFTEVD
VF9NRU1PUllfTU9ERUw9eQ0KQ09ORklHX0lMTEVHQUxfUE9JTlRFUl9WQUxV
RT0wDQpDT05GSUdfU0VMRUNUX01FTU9SWV9NT0RFTD15DQpDT05GSUdfRkxB
VE1FTV9NQU5VQUw9eQ0KIyBDT05GSUdfU1BBUlNFTUVNX01BTlVBTCBpcyBu
b3Qgc2V0DQpDT05GSUdfRkxBVE1FTT15DQpDT05GSUdfRkxBVF9OT0RFX01F
TV9NQVA9eQ0KQ09ORklHX1NQQVJTRU1FTV9TVEFUSUM9eQ0KQ09ORklHX0hB
VkVfTUVNQkxPQ0s9eQ0KQ09ORklHX0hBVkVfTUVNQkxPQ0tfTk9ERV9NQVA9
eQ0KQ09ORklHX0FSQ0hfRElTQ0FSRF9NRU1CTE9DSz15DQojIENPTkZJR19I
QVZFX0JPT1RNRU1fSU5GT19OT0RFIGlzIG5vdCBzZXQNCkNPTkZJR19QQUdF
RkxBR1NfRVhURU5ERUQ9eQ0KQ09ORklHX1NQTElUX1BUTE9DS19DUFVTPTk5
OTk5OQ0KIyBDT05GSUdfQ09NUEFDVElPTiBpcyBub3Qgc2V0DQojIENPTkZJ
R19QSFlTX0FERFJfVF82NEJJVCBpcyBub3Qgc2V0DQpDT05GSUdfWk9ORV9E
TUFfRkxBRz0wDQpDT05GSUdfVklSVF9UT19CVVM9eQ0KQ09ORklHX0tTTT15
DQpDT05GSUdfREVGQVVMVF9NTUFQX01JTl9BRERSPTQwOTYNCiMgQ09ORklH
X1RSQU5TUEFSRU5UX0hVR0VQQUdFIGlzIG5vdCBzZXQNCiMgQ09ORklHX0NS
T1NTX01FTU9SWV9BVFRBQ0ggaXMgbm90IHNldA0KQ09ORklHX05FRURfUEVS
X0NQVV9LTT15DQojIENPTkZJR19DTEVBTkNBQ0hFIGlzIG5vdCBzZXQNCiMg
Q09ORklHX01FTV9TT0ZUX0RJUlRZIGlzIG5vdCBzZXQNCiMgQ09ORklHX0hJ
R0hQVEUgaXMgbm90IHNldA0KIyBDT05GSUdfWDg2X0NIRUNLX0JJT1NfQ09S
UlVQVElPTiBpcyBub3Qgc2V0DQpDT05GSUdfWDg2X1JFU0VSVkVfTE9XPTY0
DQojIENPTkZJR19NQVRIX0VNVUxBVElPTiBpcyBub3Qgc2V0DQojIENPTkZJ
R19NVFJSIGlzIG5vdCBzZXQNCiMgQ09ORklHX0FSQ0hfUkFORE9NIGlzIG5v
dCBzZXQNCkNPTkZJR19YODZfU01BUD15DQojIENPTkZJR19TRUNDT01QIGlz
IG5vdCBzZXQNCkNPTkZJR19DQ19TVEFDS1BST1RFQ1RPUj15DQojIENPTkZJ
R19IWl8xMDAgaXMgbm90IHNldA0KQ09ORklHX0haXzI1MD15DQojIENPTkZJ
R19IWl8zMDAgaXMgbm90IHNldA0KIyBDT05GSUdfSFpfMTAwMCBpcyBub3Qg
c2V0DQpDT05GSUdfSFo9MjUwDQojIENPTkZJR19TQ0hFRF9IUlRJQ0sgaXMg
bm90IHNldA0KQ09ORklHX0tFWEVDPXkNCiMgQ09ORklHX0NSQVNIX0RVTVAg
aXMgbm90IHNldA0KQ09ORklHX1BIWVNJQ0FMX1NUQVJUPTB4MTAwMDAwMA0K
IyBDT05GSUdfUkVMT0NBVEFCTEUgaXMgbm90IHNldA0KQ09ORklHX1BIWVNJ
Q0FMX0FMSUdOPTB4MTAwMDAwMA0KIyBDT05GSUdfQ09NUEFUX1ZEU08gaXMg
bm90IHNldA0KQ09ORklHX0NNRExJTkVfQk9PTD15DQpDT05GSUdfQ01ETElO
RT0iIg0KQ09ORklHX0NNRExJTkVfT1ZFUlJJREU9eQ0KQ09ORklHX0FSQ0hf
RU5BQkxFX01FTU9SWV9IT1RQTFVHPXkNCg0KIw0KIyBQb3dlciBtYW5hZ2Vt
ZW50IGFuZCBBQ1BJIG9wdGlvbnMNCiMNCkNPTkZJR19TVVNQRU5EPXkNCkNP
TkZJR19TVVNQRU5EX0ZSRUVaRVI9eQ0KQ09ORklHX1BNX1NMRUVQPXkNCiMg
Q09ORklHX1BNX0FVVE9TTEVFUCBpcyBub3Qgc2V0DQojIENPTkZJR19QTV9X
QUtFTE9DS1MgaXMgbm90IHNldA0KQ09ORklHX1BNX1JVTlRJTUU9eQ0KQ09O
RklHX1BNPXkNCiMgQ09ORklHX1BNX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJ
R19XUV9QT1dFUl9FRkZJQ0lFTlRfREVGQVVMVD15DQpDT05GSUdfU0ZJPXkN
CkNPTkZJR19YODZfQVBNX0JPT1Q9eQ0KQ09ORklHX0FQTT15DQpDT05GSUdf
QVBNX0lHTk9SRV9VU0VSX1NVU1BFTkQ9eQ0KIyBDT05GSUdfQVBNX0RPX0VO
QUJMRSBpcyBub3Qgc2V0DQojIENPTkZJR19BUE1fQ1BVX0lETEUgaXMgbm90
IHNldA0KQ09ORklHX0FQTV9ESVNQTEFZX0JMQU5LPXkNCiMgQ09ORklHX0FQ
TV9BTExPV19JTlRTIGlzIG5vdCBzZXQNCg0KIw0KIyBDUFUgRnJlcXVlbmN5
IHNjYWxpbmcNCiMNCiMgQ09ORklHX0NQVV9GUkVRIGlzIG5vdCBzZXQNCkNP
TkZJR19DUFVfSURMRT15DQojIENPTkZJR19DUFVfSURMRV9NVUxUSVBMRV9E
UklWRVJTIGlzIG5vdCBzZXQNCkNPTkZJR19DUFVfSURMRV9HT1ZfTEFEREVS
PXkNCkNPTkZJR19DUFVfSURMRV9HT1ZfTUVOVT15DQojIENPTkZJR19BUkNI
X05FRURTX0NQVV9JRExFX0NPVVBMRUQgaXMgbm90IHNldA0KQ09ORklHX0lO
VEVMX0lETEU9eQ0KDQojDQojIEJ1cyBvcHRpb25zIChQQ0kgZXRjLikNCiMN
CiMgQ09ORklHX1BDSSBpcyBub3Qgc2V0DQpDT05GSUdfSVNBX0RNQV9BUEk9
eQ0KIyBDT05GSUdfSVNBIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NDeDIwMCBp
cyBub3Qgc2V0DQojIENPTkZJR19PTFBDIGlzIG5vdCBzZXQNCiMgQ09ORklH
X0FMSVggaXMgbm90IHNldA0KQ09ORklHX05FVDU1MDE9eQ0KQ09ORklHX1BD
Q0FSRD1tDQpDT05GSUdfUENNQ0lBPW0NCkNPTkZJR19QQ01DSUFfTE9BRF9D
SVM9eQ0KDQojDQojIFBDLWNhcmQgYnJpZGdlcw0KIw0KDQojDQojIEV4ZWN1
dGFibGUgZmlsZSBmb3JtYXRzIC8gRW11bGF0aW9ucw0KIw0KQ09ORklHX0JJ
TkZNVF9FTEY9eQ0KQ09ORklHX0FSQ0hfQklORk1UX0VMRl9SQU5ET01JWkVf
UElFPXkNCkNPTkZJR19DT1JFX0RVTVBfREVGQVVMVF9FTEZfSEVBREVSUz15
DQojIENPTkZJR19CSU5GTVRfU0NSSVBUIGlzIG5vdCBzZXQNCkNPTkZJR19I
QVZFX0FPVVQ9eQ0KQ09ORklHX0JJTkZNVF9BT1VUPXkNCiMgQ09ORklHX0JJ
TkZNVF9NSVNDIGlzIG5vdCBzZXQNCkNPTkZJR19DT1JFRFVNUD15DQpDT05G
SUdfSEFWRV9BVE9NSUNfSU9NQVA9eQ0KQ09ORklHX0hBVkVfVEVYVF9QT0tF
X1NNUD15DQpDT05GSUdfTkVUPXkNCg0KIw0KIyBOZXR3b3JraW5nIG9wdGlv
bnMNCiMNCiMgQ09ORklHX1BBQ0tFVCBpcyBub3Qgc2V0DQpDT05GSUdfVU5J
WD15DQojIENPTkZJR19VTklYX0RJQUcgaXMgbm90IHNldA0KQ09ORklHX1hG
Uk09eQ0KQ09ORklHX1hGUk1fQUxHTz15DQpDT05GSUdfWEZSTV9VU0VSPW0N
CiMgQ09ORklHX1hGUk1fU1VCX1BPTElDWSBpcyBub3Qgc2V0DQojIENPTkZJ
R19YRlJNX01JR1JBVEUgaXMgbm90IHNldA0KQ09ORklHX1hGUk1fSVBDT01Q
PW0NCiMgQ09ORklHX05FVF9LRVkgaXMgbm90IHNldA0KQ09ORklHX0lORVQ9
eQ0KQ09ORklHX0lQX01VTFRJQ0FTVD15DQojIENPTkZJR19JUF9BRFZBTkNF
RF9ST1VURVIgaXMgbm90IHNldA0KIyBDT05GSUdfSVBfUE5QIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX05FVF9JUElQIGlzIG5vdCBzZXQNCiMgQ09ORklHX05F
VF9JUEdSRV9ERU1VWCBpcyBub3Qgc2V0DQpDT05GSUdfTkVUX0lQX1RVTk5F
TD1tDQojIENPTkZJR19JUF9NUk9VVEUgaXMgbm90IHNldA0KIyBDT05GSUdf
QVJQRCBpcyBub3Qgc2V0DQojIENPTkZJR19TWU5fQ09PS0lFUyBpcyBub3Qg
c2V0DQojIENPTkZJR19ORVRfSVBWVEkgaXMgbm90IHNldA0KQ09ORklHX0lO
RVRfQUg9eQ0KIyBDT05GSUdfSU5FVF9FU1AgaXMgbm90IHNldA0KQ09ORklH
X0lORVRfSVBDT01QPW0NCkNPTkZJR19JTkVUX1hGUk1fVFVOTkVMPW0NCkNP
TkZJR19JTkVUX1RVTk5FTD1tDQpDT05GSUdfSU5FVF9YRlJNX01PREVfVFJB
TlNQT1JUPW0NCkNPTkZJR19JTkVUX1hGUk1fTU9ERV9UVU5ORUw9bQ0KIyBD
T05GSUdfSU5FVF9YRlJNX01PREVfQkVFVCBpcyBub3Qgc2V0DQpDT05GSUdf
SU5FVF9MUk89bQ0KIyBDT05GSUdfSU5FVF9ESUFHIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1RDUF9DT05HX0FEVkFOQ0VEIGlzIG5vdCBzZXQNCkNPTkZJR19U
Q1BfQ09OR19DVUJJQz15DQpDT05GSUdfREVGQVVMVF9UQ1BfQ09ORz0iY3Vi
aWMiDQojIENPTkZJR19UQ1BfTUQ1U0lHIGlzIG5vdCBzZXQNCkNPTkZJR19J
UFY2PXkNCiMgQ09ORklHX0lQVjZfUFJJVkFDWSBpcyBub3Qgc2V0DQojIENP
TkZJR19JUFY2X1JPVVRFUl9QUkVGIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lQ
VjZfT1BUSU1JU1RJQ19EQUQgaXMgbm90IHNldA0KIyBDT05GSUdfSU5FVDZf
QUggaXMgbm90IHNldA0KQ09ORklHX0lORVQ2X0VTUD15DQojIENPTkZJR19J
TkVUNl9JUENPTVAgaXMgbm90IHNldA0KIyBDT05GSUdfSVBWNl9NSVA2IGlz
IG5vdCBzZXQNCiMgQ09ORklHX0lORVQ2X1hGUk1fVFVOTkVMIGlzIG5vdCBz
ZXQNCkNPTkZJR19JTkVUNl9UVU5ORUw9bQ0KIyBDT05GSUdfSU5FVDZfWEZS
TV9NT0RFX1RSQU5TUE9SVCBpcyBub3Qgc2V0DQpDT05GSUdfSU5FVDZfWEZS
TV9NT0RFX1RVTk5FTD1tDQojIENPTkZJR19JTkVUNl9YRlJNX01PREVfQkVF
VCBpcyBub3Qgc2V0DQpDT05GSUdfSU5FVDZfWEZSTV9NT0RFX1JPVVRFT1BU
SU1JWkFUSU9OPW0NCiMgQ09ORklHX0lQVjZfU0lUIGlzIG5vdCBzZXQNCkNP
TkZJR19JUFY2X1RVTk5FTD1tDQpDT05GSUdfSVBWNl9HUkU9bQ0KQ09ORklH
X0lQVjZfTVVMVElQTEVfVEFCTEVTPXkNCkNPTkZJR19JUFY2X1NVQlRSRUVT
PXkNCkNPTkZJR19JUFY2X01ST1VURT15DQpDT05GSUdfSVBWNl9NUk9VVEVf
TVVMVElQTEVfVEFCTEVTPXkNCkNPTkZJR19JUFY2X1BJTVNNX1YyPXkNCkNP
TkZJR19ORVRMQUJFTD15DQpDT05GSUdfTkVUV09SS19TRUNNQVJLPXkNCiMg
Q09ORklHX05FVFdPUktfUEhZX1RJTUVTVEFNUElORyBpcyBub3Qgc2V0DQpD
T05GSUdfTkVURklMVEVSPXkNCiMgQ09ORklHX05FVEZJTFRFUl9ERUJVRyBp
cyBub3Qgc2V0DQojIENPTkZJR19ORVRGSUxURVJfQURWQU5DRUQgaXMgbm90
IHNldA0KDQojDQojIENvcmUgTmV0ZmlsdGVyIENvbmZpZ3VyYXRpb24NCiMN
CkNPTkZJR19ORVRGSUxURVJfTkVUTElOSz1tDQpDT05GSUdfTkVURklMVEVS
X05FVExJTktfTE9HPW0NCiMgQ09ORklHX05GX0NPTk5UUkFDSyBpcyBub3Qg
c2V0DQpDT05GSUdfTkVURklMVEVSX1hUQUJMRVM9eQ0KDQojDQojIFh0YWJs
ZXMgY29tYmluZWQgbW9kdWxlcw0KIw0KIyBDT05GSUdfTkVURklMVEVSX1hU
X01BUksgaXMgbm90IHNldA0KDQojDQojIFh0YWJsZXMgdGFyZ2V0cw0KIw0K
Q09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfTE9HPXkNCiMgQ09ORklHX05F
VEZJTFRFUl9YVF9UQVJHRVRfTkZMT0cgaXMgbm90IHNldA0KQ09ORklHX05F
VEZJTFRFUl9YVF9UQVJHRVRfU0VDTUFSSz1tDQojIENPTkZJR19ORVRGSUxU
RVJfWFRfVEFSR0VUX1RDUE1TUyBpcyBub3Qgc2V0DQoNCiMNCiMgWHRhYmxl
cyBtYXRjaGVzDQojDQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1BPTElD
WT15DQpDT05GSUdfSVBfU0VUPW0NCkNPTkZJR19JUF9TRVRfTUFYPTI1Ng0K
Q09ORklHX0lQX1NFVF9CSVRNQVBfSVA9bQ0KIyBDT05GSUdfSVBfU0VUX0JJ
VE1BUF9JUE1BQyBpcyBub3Qgc2V0DQpDT05GSUdfSVBfU0VUX0JJVE1BUF9Q
T1JUPW0NCiMgQ09ORklHX0lQX1NFVF9IQVNIX0lQIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0lQX1NFVF9IQVNIX0lQUE9SVCBpcyBub3Qgc2V0DQpDT05GSUdf
SVBfU0VUX0hBU0hfSVBQT1JUSVA9bQ0KQ09ORklHX0lQX1NFVF9IQVNIX0lQ
UE9SVE5FVD1tDQpDT05GSUdfSVBfU0VUX0hBU0hfTkVUPW0NCkNPTkZJR19J
UF9TRVRfSEFTSF9ORVRQT1JUPW0NCkNPTkZJR19JUF9TRVRfSEFTSF9ORVRJ
RkFDRT1tDQojIENPTkZJR19JUF9TRVRfTElTVF9TRVQgaXMgbm90IHNldA0K
IyBDT05GSUdfSVBfVlMgaXMgbm90IHNldA0KDQojDQojIElQOiBOZXRmaWx0
ZXIgQ29uZmlndXJhdGlvbg0KIw0KIyBDT05GSUdfTkZfREVGUkFHX0lQVjQg
aXMgbm90IHNldA0KIyBDT05GSUdfSVBfTkZfSVBUQUJMRVMgaXMgbm90IHNl
dA0KDQojDQojIElQdjY6IE5ldGZpbHRlciBDb25maWd1cmF0aW9uDQojDQoj
IENPTkZJR19ORl9ERUZSQUdfSVBWNiBpcyBub3Qgc2V0DQpDT05GSUdfSVA2
X05GX0lQVEFCTEVTPXkNCiMgQ09ORklHX0lQNl9ORl9NQVRDSF9JUFY2SEVB
REVSIGlzIG5vdCBzZXQNCkNPTkZJR19JUDZfTkZfRklMVEVSPW0NCiMgQ09O
RklHX0lQNl9ORl9UQVJHRVRfUkVKRUNUIGlzIG5vdCBzZXQNCkNPTkZJR19J
UDZfTkZfTUFOR0xFPXkNCiMgQ09ORklHX0lQNl9ORl9SQVcgaXMgbm90IHNl
dA0KIyBDT05GSUdfQlJJREdFX05GX0VCVEFCTEVTIGlzIG5vdCBzZXQNCkNP
TkZJR19JUF9EQ0NQPW0NCg0KIw0KIyBEQ0NQIENDSURzIENvbmZpZ3VyYXRp
b24NCiMNCiMgQ09ORklHX0lQX0RDQ1BfQ0NJRDJfREVCVUcgaXMgbm90IHNl
dA0KIyBDT05GSUdfSVBfRENDUF9DQ0lEMyBpcyBub3Qgc2V0DQoNCiMNCiMg
RENDUCBLZXJuZWwgSGFja2luZw0KIw0KQ09ORklHX0lQX0RDQ1BfREVCVUc9
eQ0KQ09ORklHX0lQX1NDVFA9bQ0KIyBDT05GSUdfU0NUUF9EQkdfTVNHIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1NDVFBfREVGQVVMVF9DT09LSUVfSE1BQ19N
RDUgaXMgbm90IHNldA0KIyBDT05GSUdfU0NUUF9ERUZBVUxUX0NPT0tJRV9I
TUFDX1NIQTEgaXMgbm90IHNldA0KQ09ORklHX1NDVFBfREVGQVVMVF9DT09L
SUVfSE1BQ19OT05FPXkNCiMgQ09ORklHX1NDVFBfQ09PS0lFX0hNQUNfTUQ1
IGlzIG5vdCBzZXQNCkNPTkZJR19TQ1RQX0NPT0tJRV9ITUFDX1NIQTE9eQ0K
Q09ORklHX1JEUz15DQpDT05GSUdfUkRTX1RDUD15DQpDT05GSUdfUkRTX0RF
QlVHPXkNCiMgQ09ORklHX1RJUEMgaXMgbm90IHNldA0KIyBDT05GSUdfQVRN
IGlzIG5vdCBzZXQNCkNPTkZJR19MMlRQPXkNCkNPTkZJR19MMlRQX0RFQlVH
RlM9eQ0KIyBDT05GSUdfTDJUUF9WMyBpcyBub3Qgc2V0DQpDT05GSUdfU1RQ
PXkNCkNPTkZJR19CUklER0U9eQ0KQ09ORklHX0JSSURHRV9JR01QX1NOT09Q
SU5HPXkNCiMgQ09ORklHX1ZMQU5fODAyMVEgaXMgbm90IHNldA0KQ09ORklH
X0RFQ05FVD15DQojIENPTkZJR19ERUNORVRfUk9VVEVSIGlzIG5vdCBzZXQN
CkNPTkZJR19MTEM9eQ0KQ09ORklHX0xMQzI9eQ0KQ09ORklHX0lQWD15DQpD
T05GSUdfSVBYX0lOVEVSTj15DQojIENPTkZJR19BVEFMSyBpcyBub3Qgc2V0
DQojIENPTkZJR19YMjUgaXMgbm90IHNldA0KQ09ORklHX0xBUEI9bQ0KIyBD
T05GSUdfUEhPTkVUIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lFRUU4MDIxNTQg
aXMgbm90IHNldA0KIyBDT05GSUdfTkVUX1NDSEVEIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0RDQiBpcyBub3Qgc2V0DQojIENPTkZJR19ETlNfUkVTT0xWRVIg
aXMgbm90IHNldA0KQ09ORklHX0JBVE1BTl9BRFY9eQ0KQ09ORklHX0JBVE1B
Tl9BRFZfQkxBPXkNCkNPTkZJR19CQVRNQU5fQURWX0RBVD15DQpDT05GSUdf
QkFUTUFOX0FEVl9OQz15DQpDT05GSUdfQkFUTUFOX0FEVl9ERUJVRz15DQpD
T05GSUdfT1BFTlZTV0lUQ0g9eQ0KQ09ORklHX1ZTT0NLRVRTPXkNCkNPTkZJ
R19ORVRMSU5LX01NQVA9eQ0KIyBDT05GSUdfTkVUTElOS19ESUFHIGlzIG5v
dCBzZXQNCkNPTkZJR19ORVRQUklPX0NHUk9VUD1tDQpDT05GSUdfQlFMPXkN
Cg0KIw0KIyBOZXR3b3JrIHRlc3RpbmcNCiMNCiMgQ09ORklHX05FVF9EUk9Q
X01PTklUT1IgaXMgbm90IHNldA0KIyBDT05GSUdfSEFNUkFESU8gaXMgbm90
IHNldA0KIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQNCkNPTkZJR19JUkRBPW0N
Cg0KIw0KIyBJckRBIHByb3RvY29scw0KIw0KQ09ORklHX0lSTEFOPW0NCiMg
Q09ORklHX0lSQ09NTSBpcyBub3Qgc2V0DQpDT05GSUdfSVJEQV9VTFRSQT15
DQoNCiMNCiMgSXJEQSBvcHRpb25zDQojDQpDT05GSUdfSVJEQV9DQUNIRV9M
QVNUX0xTQVA9eQ0KQ09ORklHX0lSREFfRkFTVF9SUj15DQojIENPTkZJR19J
UkRBX0RFQlVHIGlzIG5vdCBzZXQNCg0KIw0KIyBJbmZyYXJlZC1wb3J0IGRl
dmljZSBkcml2ZXJzDQojDQoNCiMNCiMgU0lSIGRldmljZSBkcml2ZXJzDQoj
DQpDT05GSUdfSVJUVFlfU0lSPW0NCg0KIw0KIyBEb25nbGUgc3VwcG9ydA0K
Iw0KIyBDT05GSUdfRE9OR0xFIGlzIG5vdCBzZXQNCkNPTkZJR19LSU5HU1VO
X0RPTkdMRT1tDQpDT05GSUdfS1NEQVpaTEVfRE9OR0xFPW0NCiMgQ09ORklH
X0tTOTU5X0RPTkdMRSBpcyBub3Qgc2V0DQoNCiMNCiMgRklSIGRldmljZSBk
cml2ZXJzDQojDQpDT05GSUdfVVNCX0lSREE9bQ0KQ09ORklHX1NJR01BVEVM
X0ZJUj1tDQpDT05GSUdfTlNDX0ZJUj1tDQojIENPTkZJR19XSU5CT05EX0ZJ
UiBpcyBub3Qgc2V0DQpDT05GSUdfU01DX0lSQ0NfRklSPW0NCiMgQ09ORklH
X0FMSV9GSVIgaXMgbm90IHNldA0KQ09ORklHX1ZJQV9GSVI9bQ0KIyBDT05G
SUdfTUNTX0ZJUiBpcyBub3Qgc2V0DQojIENPTkZJR19CVCBpcyBub3Qgc2V0
DQpDT05GSUdfQUZfUlhSUEM9eQ0KIyBDT05GSUdfQUZfUlhSUENfREVCVUcg
aXMgbm90IHNldA0KQ09ORklHX1JYS0FEPXkNCkNPTkZJR19GSUJfUlVMRVM9
eQ0KIyBDT05GSUdfV0lSRUxFU1MgaXMgbm90IHNldA0KIyBDT05GSUdfV0lN
QVggaXMgbm90IHNldA0KQ09ORklHX1JGS0lMTD1tDQpDT05GSUdfUkZLSUxM
X0lOUFVUPXkNCkNPTkZJR19SRktJTExfUkVHVUxBVE9SPW0NCkNPTkZJR19O
RVRfOVA9eQ0KQ09ORklHX05FVF85UF9WSVJUSU89bQ0KIyBDT05GSUdfTkVU
XzlQX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19DQUlGPXkNCiMgQ09ORklH
X0NBSUZfREVCVUcgaXMgbm90IHNldA0KQ09ORklHX0NBSUZfTkVUREVWPW0N
CkNPTkZJR19DQUlGX1VTQj1tDQpDT05GSUdfQ0VQSF9MSUI9eQ0KQ09ORklH
X0NFUEhfTElCX1BSRVRUWURFQlVHPXkNCiMgQ09ORklHX0NFUEhfTElCX1VT
RV9ETlNfUkVTT0xWRVIgaXMgbm90IHNldA0KQ09ORklHX05GQz1tDQojIENP
TkZJR19ORkNfTkNJIGlzIG5vdCBzZXQNCiMgQ09ORklHX05GQ19IQ0kgaXMg
bm90IHNldA0KDQojDQojIE5lYXIgRmllbGQgQ29tbXVuaWNhdGlvbiAoTkZD
KSBkZXZpY2VzDQojDQpDT05GSUdfTkZDX1BONTMzPW0NCg0KIw0KIyBEZXZp
Y2UgRHJpdmVycw0KIw0KDQojDQojIEdlbmVyaWMgRHJpdmVyIE9wdGlvbnMN
CiMNCkNPTkZJR19VRVZFTlRfSEVMUEVSX1BBVEg9IiINCkNPTkZJR19ERVZU
TVBGUz15DQojIENPTkZJR19ERVZUTVBGU19NT1VOVCBpcyBub3Qgc2V0DQpD
T05GSUdfU1RBTkRBTE9ORT15DQojIENPTkZJR19QUkVWRU5UX0ZJUk1XQVJF
X0JVSUxEIGlzIG5vdCBzZXQNCkNPTkZJR19GV19MT0FERVI9eQ0KQ09ORklH
X0ZJUk1XQVJFX0lOX0tFUk5FTD15DQpDT05GSUdfRVhUUkFfRklSTVdBUkU9
IiINCiMgQ09ORklHX0ZXX0xPQURFUl9VU0VSX0hFTFBFUiBpcyBub3Qgc2V0
DQpDT05GSUdfREVCVUdfRFJJVkVSPXkNCiMgQ09ORklHX0RFQlVHX0RFVlJF
UyBpcyBub3Qgc2V0DQojIENPTkZJR19TWVNfSFlQRVJWSVNPUiBpcyBub3Qg
c2V0DQojIENPTkZJR19HRU5FUklDX0NQVV9ERVZJQ0VTIGlzIG5vdCBzZXQN
CkNPTkZJR19SRUdNQVA9eQ0KQ09ORklHX1JFR01BUF9JMkM9eQ0KQ09ORklH
X1JFR01BUF9JUlE9eQ0KQ09ORklHX0RNQV9TSEFSRURfQlVGRkVSPXkNCiMg
Q09ORklHX0NNQSBpcyBub3Qgc2V0DQoNCiMNCiMgQnVzIGRldmljZXMNCiMN
CiMgQ09ORklHX0NPTk5FQ1RPUiBpcyBub3Qgc2V0DQpDT05GSUdfTVREPXkN
CiMgQ09ORklHX01URF9URVNUUyBpcyBub3Qgc2V0DQojIENPTkZJR19NVERf
UkVEQk9PVF9QQVJUUyBpcyBub3Qgc2V0DQpDT05GSUdfTVREX0NNRExJTkVf
UEFSVFM9bQ0KIyBDT05GSUdfTVREX0FSN19QQVJUUyBpcyBub3Qgc2V0DQoN
CiMNCiMgVXNlciBNb2R1bGVzIEFuZCBUcmFuc2xhdGlvbiBMYXllcnMNCiMN
CkNPTkZJR19NVERfT09QUz15DQoNCiMNCiMgUkFNL1JPTS9GbGFzaCBjaGlw
IGRyaXZlcnMNCiMNCiMgQ09ORklHX01URF9DRkkgaXMgbm90IHNldA0KQ09O
RklHX01URF9KRURFQ1BST0JFPXkNCkNPTkZJR19NVERfR0VOX1BST0JFPXkN
CiMgQ09ORklHX01URF9DRklfQURWX09QVElPTlMgaXMgbm90IHNldA0KQ09O
RklHX01URF9NQVBfQkFOS19XSURUSF8xPXkNCkNPTkZJR19NVERfTUFQX0JB
TktfV0lEVEhfMj15DQpDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzQ9eQ0K
IyBDT05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzggaXMgbm90IHNldA0KIyBD
T05GSUdfTVREX01BUF9CQU5LX1dJRFRIXzE2IGlzIG5vdCBzZXQNCiMgQ09O
RklHX01URF9NQVBfQkFOS19XSURUSF8zMiBpcyBub3Qgc2V0DQpDT05GSUdf
TVREX0NGSV9JMT15DQpDT05GSUdfTVREX0NGSV9JMj15DQojIENPTkZJR19N
VERfQ0ZJX0k0IGlzIG5vdCBzZXQNCiMgQ09ORklHX01URF9DRklfSTggaXMg
bm90IHNldA0KIyBDT05GSUdfTVREX0NGSV9JTlRFTEVYVCBpcyBub3Qgc2V0
DQpDT05GSUdfTVREX0NGSV9BTURTVEQ9eQ0KIyBDT05GSUdfTVREX0NGSV9T
VEFBIGlzIG5vdCBzZXQNCkNPTkZJR19NVERfQ0ZJX1VUSUw9eQ0KQ09ORklH
X01URF9SQU09eQ0KQ09ORklHX01URF9ST009eQ0KQ09ORklHX01URF9BQlNF
TlQ9bQ0KDQojDQojIE1hcHBpbmcgZHJpdmVycyBmb3IgY2hpcCBhY2Nlc3MN
CiMNCiMgQ09ORklHX01URF9DT01QTEVYX01BUFBJTkdTIGlzIG5vdCBzZXQN
CiMgQ09ORklHX01URF9QSFlTTUFQIGlzIG5vdCBzZXQNCkNPTkZJR19NVERf
VFM1NTAwPXkNCiMgQ09ORklHX01URF9BTUQ3NlhST00gaXMgbm90IHNldA0K
Q09ORklHX01URF9JQ0hYUk9NPW0NCiMgQ09ORklHX01URF9ORVR0ZWwgaXMg
bm90IHNldA0KQ09ORklHX01URF9MNDQwR1g9eQ0KQ09ORklHX01URF9QTEFU
UkFNPXkNCg0KIw0KIyBTZWxmLWNvbnRhaW5lZCBNVEQgZGV2aWNlIGRyaXZl
cnMNCiMNCkNPTkZJR19NVERfU0xSQU09eQ0KIyBDT05GSUdfTVREX1BIUkFN
IGlzIG5vdCBzZXQNCiMgQ09ORklHX01URF9NVERSQU0gaXMgbm90IHNldA0K
DQojDQojIERpc2stT24tQ2hpcCBEZXZpY2UgRHJpdmVycw0KIw0KQ09ORklH
X01URF9ET0NHMz1tDQpDT05GSUdfQkNIX0NPTlNUX009MTQNCkNPTkZJR19C
Q0hfQ09OU1RfVD00DQpDT05GSUdfTVREX05BTkRfRUNDPW0NCiMgQ09ORklH
X01URF9OQU5EX0VDQ19TTUMgaXMgbm90IHNldA0KQ09ORklHX01URF9OQU5E
PW0NCiMgQ09ORklHX01URF9OQU5EX0VDQ19CQ0ggaXMgbm90IHNldA0KIyBD
T05GSUdfTVREX1NNX0NPTU1PTiBpcyBub3Qgc2V0DQpDT05GSUdfTVREX05B
TkRfREVOQUxJPW0NCkNPTkZJR19NVERfTkFORF9HUElPPW0NCkNPTkZJR19N
VERfTkFORF9JRFM9bQ0KQ09ORklHX01URF9OQU5EX0RJU0tPTkNISVA9bQ0K
Q09ORklHX01URF9OQU5EX0RJU0tPTkNISVBfUFJPQkVfQURWQU5DRUQ9eQ0K
Q09ORklHX01URF9OQU5EX0RJU0tPTkNISVBfUFJPQkVfQUREUkVTUz0wDQoj
IENPTkZJR19NVERfTkFORF9ESVNLT05DSElQX1BST0JFX0hJR0ggaXMgbm90
IHNldA0KIyBDT05GSUdfTVREX05BTkRfRElTS09OQ0hJUF9CQlRXUklURSBp
cyBub3Qgc2V0DQpDT05GSUdfTVREX05BTkRfRE9DRzQ9bQ0KQ09ORklHX01U
RF9OQU5EX0NTNTUzWD1tDQpDT05GSUdfTVREX05BTkRfTkFORFNJTT1tDQoj
IENPTkZJR19NVERfTkFORF9QTEFURk9STSBpcyBub3Qgc2V0DQpDT05GSUdf
TVREX0FMQVVEQT1tDQojIENPTkZJR19NVERfT05FTkFORCBpcyBub3Qgc2V0
DQoNCiMNCiMgTFBERFIgZmxhc2ggbWVtb3J5IGRyaXZlcnMNCiMNCiMgQ09O
RklHX01URF9MUEREUiBpcyBub3Qgc2V0DQojIENPTkZJR19NVERfVUJJIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1BBUlBPUlQgaXMgbm90IHNldA0KDQojDQoj
IE1pc2MgZGV2aWNlcw0KIw0KIyBDT05GSUdfU0VOU09SU19MSVMzTFYwMkQg
aXMgbm90IHNldA0KQ09ORklHX0FENTI1WF9EUE9UPW0NCkNPTkZJR19BRDUy
NVhfRFBPVF9JMkM9bQ0KQ09ORklHX0RVTU1ZX0lSUT15DQojIENPTkZJR19J
Q1M5MzJTNDAxIGlzIG5vdCBzZXQNCiMgQ09ORklHX0FUTUVMX1NTQyBpcyBu
b3Qgc2V0DQojIENPTkZJR19FTkNMT1NVUkVfU0VSVklDRVMgaXMgbm90IHNl
dA0KQ09ORklHX0FQRFM5ODAyQUxTPXkNCkNPTkZJR19JU0wyOTAwMz15DQpD
T05GSUdfSVNMMjkwMjA9bQ0KQ09ORklHX1NFTlNPUlNfVFNMMjU1MD15DQoj
IENPTkZJR19TRU5TT1JTX0JIMTc4MCBpcyBub3Qgc2V0DQpDT05GSUdfU0VO
U09SU19CSDE3NzA9eQ0KQ09ORklHX1NFTlNPUlNfQVBEUzk5MFg9bQ0KQ09O
RklHX0hNQzYzNTI9bQ0KIyBDT05GSUdfRFMxNjgyIGlzIG5vdCBzZXQNCiMg
Q09ORklHX1ZNV0FSRV9CQUxMT09OIGlzIG5vdCBzZXQNCkNPTkZJR19CTVAw
ODU9eQ0KQ09ORklHX0JNUDA4NV9JMkM9eQ0KQ09ORklHX1VTQl9TV0lUQ0hf
RlNBOTQ4MD1tDQpDT05GSUdfU1JBTT15DQpDT05GSUdfQzJQT1JUPW0NCiMg
Q09ORklHX0MyUE9SVF9EVVJBTUFSXzIxNTAgaXMgbm90IHNldA0KDQojDQoj
IEVFUFJPTSBzdXBwb3J0DQojDQpDT05GSUdfRUVQUk9NX0FUMjQ9eQ0KQ09O
RklHX0VFUFJPTV9MRUdBQ1k9bQ0KQ09ORklHX0VFUFJPTV9NQVg2ODc1PXkN
CiMgQ09ORklHX0VFUFJPTV85M0NYNiBpcyBub3Qgc2V0DQoNCiMNCiMgVGV4
YXMgSW5zdHJ1bWVudHMgc2hhcmVkIHRyYW5zcG9ydCBsaW5lIGRpc2NpcGxp
bmUNCiMNCiMgQ09ORklHX1RJX1NUIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NF
TlNPUlNfTElTM19JMkMgaXMgbm90IHNldA0KDQojDQojIEFsdGVyYSBGUEdB
IGZpcm13YXJlIGRvd25sb2FkIG1vZHVsZQ0KIw0KQ09ORklHX0FMVEVSQV9T
VEFQTD1tDQpDT05GSUdfSEFWRV9JREU9eQ0KDQojDQojIFNDU0kgZGV2aWNl
IHN1cHBvcnQNCiMNCkNPTkZJR19TQ1NJX01PRD15DQojIENPTkZJR19TQ1NJ
X0RNQSBpcyBub3Qgc2V0DQojIENPTkZJR19TQ1NJX05FVExJTksgaXMgbm90
IHNldA0KIyBDT05GSUdfTUFDSU5UT1NIX0RSSVZFUlMgaXMgbm90IHNldA0K
IyBDT05GSUdfTkVUREVWSUNFUyBpcyBub3Qgc2V0DQpDT05GSUdfVkhPU1Rf
TkVUPXkNCkNPTkZJR19WSE9TVF9SSU5HPXkNCg0KIw0KIyBJbnB1dCBkZXZp
Y2Ugc3VwcG9ydA0KIw0KQ09ORklHX0lOUFVUPXkNCkNPTkZJR19JTlBVVF9G
Rl9NRU1MRVNTPXkNCkNPTkZJR19JTlBVVF9QT0xMREVWPXkNCkNPTkZJR19J
TlBVVF9TUEFSU0VLTUFQPXkNCkNPTkZJR19JTlBVVF9NQVRSSVhLTUFQPXkN
Cg0KIw0KIyBVc2VybGFuZCBpbnRlcmZhY2VzDQojDQojIENPTkZJR19JTlBV
VF9NT1VTRURFViBpcyBub3Qgc2V0DQpDT05GSUdfSU5QVVRfSk9ZREVWPXkN
CkNPTkZJR19JTlBVVF9FVkRFVj15DQpDT05GSUdfSU5QVVRfRVZCVUc9bQ0K
DQojDQojIElucHV0IERldmljZSBEcml2ZXJzDQojDQpDT05GSUdfSU5QVVRf
S0VZQk9BUkQ9eQ0KQ09ORklHX0tFWUJPQVJEX0FEUDU1MjA9bQ0KIyBDT05G
SUdfS0VZQk9BUkRfQURQNTU4OCBpcyBub3Qgc2V0DQpDT05GSUdfS0VZQk9B
UkRfQURQNTU4OT15DQpDT05GSUdfS0VZQk9BUkRfQVRLQkQ9bQ0KQ09ORklH
X0tFWUJPQVJEX1FUMTA3MD1tDQpDT05GSUdfS0VZQk9BUkRfUVQyMTYwPW0N
CkNPTkZJR19LRVlCT0FSRF9MS0tCRD15DQpDT05GSUdfS0VZQk9BUkRfR1BJ
Tz1tDQojIENPTkZJR19LRVlCT0FSRF9HUElPX1BPTExFRCBpcyBub3Qgc2V0
DQpDT05GSUdfS0VZQk9BUkRfVENBNjQxNj1tDQojIENPTkZJR19LRVlCT0FS
RF9UQ0E4NDE4IGlzIG5vdCBzZXQNCkNPTkZJR19LRVlCT0FSRF9NQVRSSVg9
eQ0KQ09ORklHX0tFWUJPQVJEX0xNODMyMz15DQpDT05GSUdfS0VZQk9BUkRf
TE04MzMzPW0NCkNPTkZJR19LRVlCT0FSRF9NQVg3MzU5PXkNCkNPTkZJR19L
RVlCT0FSRF9NQ1M9bQ0KQ09ORklHX0tFWUJPQVJEX01QUjEyMT15DQojIENP
TkZJR19LRVlCT0FSRF9ORVdUT04gaXMgbm90IHNldA0KIyBDT05GSUdfS0VZ
Qk9BUkRfT1BFTkNPUkVTIGlzIG5vdCBzZXQNCiMgQ09ORklHX0tFWUJPQVJE
X0dPTERGSVNIX0VWRU5UUyBpcyBub3Qgc2V0DQojIENPTkZJR19LRVlCT0FS
RF9TVE9XQVdBWSBpcyBub3Qgc2V0DQojIENPTkZJR19LRVlCT0FSRF9TVU5L
QkQgaXMgbm90IHNldA0KQ09ORklHX0tFWUJPQVJEX1NUTVBFPXkNCiMgQ09O
RklHX0tFWUJPQVJEX1RDMzU4OVggaXMgbm90IHNldA0KIyBDT05GSUdfS0VZ
Qk9BUkRfVFdMNDAzMCBpcyBub3Qgc2V0DQpDT05GSUdfS0VZQk9BUkRfWFRL
QkQ9bQ0KIyBDT05GSUdfS0VZQk9BUkRfQ1JPU19FQyBpcyBub3Qgc2V0DQpD
T05GSUdfSU5QVVRfTU9VU0U9eQ0KIyBDT05GSUdfTU9VU0VfUFMyIGlzIG5v
dCBzZXQNCkNPTkZJR19NT1VTRV9TRVJJQUw9bQ0KIyBDT05GSUdfTU9VU0Vf
QVBQTEVUT1VDSCBpcyBub3Qgc2V0DQpDT05GSUdfTU9VU0VfQkNNNTk3ND1t
DQpDT05GSUdfTU9VU0VfQ1lBUEE9bQ0KQ09ORklHX01PVVNFX1ZTWFhYQUE9
eQ0KQ09ORklHX01PVVNFX0dQSU89bQ0KQ09ORklHX01PVVNFX1NZTkFQVElD
U19JMkM9eQ0KIyBDT05GSUdfTU9VU0VfU1lOQVBUSUNTX1VTQiBpcyBub3Qg
c2V0DQojIENPTkZJR19JTlBVVF9KT1lTVElDSyBpcyBub3Qgc2V0DQpDT05G
SUdfSU5QVVRfVEFCTEVUPXkNCkNPTkZJR19UQUJMRVRfVVNCX0FDRUNBRD15
DQpDT05GSUdfVEFCTEVUX1VTQl9BSVBURUs9eQ0KIyBDT05GSUdfVEFCTEVU
X1VTQl9HVENPIGlzIG5vdCBzZXQNCkNPTkZJR19UQUJMRVRfVVNCX0hBTldB
Tkc9bQ0KQ09ORklHX1RBQkxFVF9VU0JfS0JUQUI9eQ0KQ09ORklHX1RBQkxF
VF9VU0JfV0FDT009eQ0KQ09ORklHX0lOUFVUX1RPVUNIU0NSRUVOPXkNCiMg
Q09ORklHX1RPVUNIU0NSRUVOX0FENzg3OSBpcyBub3Qgc2V0DQpDT05GSUdf
VE9VQ0hTQ1JFRU5fQVRNRUxfTVhUPXkNCkNPTkZJR19UT1VDSFNDUkVFTl9B
VU9fUElYQ0lSPXkNCiMgQ09ORklHX1RPVUNIU0NSRUVOX0JVMjEwMTMgaXMg
bm90IHNldA0KIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQ1k4Q1RNRzExMCBpcyBu
b3Qgc2V0DQojIENPTkZJR19UT1VDSFNDUkVFTl9DWVRUU1BfQ09SRSBpcyBu
b3Qgc2V0DQpDT05GSUdfVE9VQ0hTQ1JFRU5fREE5MDM0PW0NCkNPTkZJR19U
T1VDSFNDUkVFTl9EWU5BUFJPPXkNCkNPTkZJR19UT1VDSFNDUkVFTl9IQU1Q
U0hJUkU9bQ0KQ09ORklHX1RPVUNIU0NSRUVOX0VFVEk9eQ0KIyBDT05GSUdf
VE9VQ0hTQ1JFRU5fRlVKSVRTVSBpcyBub3Qgc2V0DQpDT05GSUdfVE9VQ0hT
Q1JFRU5fSUxJMjEwWD15DQpDT05GSUdfVE9VQ0hTQ1JFRU5fR1VOWkU9eQ0K
Q09ORklHX1RPVUNIU0NSRUVOX0VMTz1tDQojIENPTkZJR19UT1VDSFNDUkVF
Tl9XQUNPTV9XODAwMSBpcyBub3Qgc2V0DQpDT05GSUdfVE9VQ0hTQ1JFRU5f
V0FDT01fSTJDPXkNCiMgQ09ORklHX1RPVUNIU0NSRUVOX01BWDExODAxIGlz
IG5vdCBzZXQNCkNPTkZJR19UT1VDSFNDUkVFTl9NQ1M1MDAwPXkNCiMgQ09O
RklHX1RPVUNIU0NSRUVOX01NUzExNCBpcyBub3Qgc2V0DQojIENPTkZJR19U
T1VDSFNDUkVFTl9NVE9VQ0ggaXMgbm90IHNldA0KQ09ORklHX1RPVUNIU0NS
RUVOX0lORVhJTz1tDQpDT05GSUdfVE9VQ0hTQ1JFRU5fTUs3MTI9bQ0KQ09O
RklHX1RPVUNIU0NSRUVOX1BFTk1PVU5UPW0NCkNPTkZJR19UT1VDSFNDUkVF
Tl9FRFRfRlQ1WDA2PXkNCkNPTkZJR19UT1VDSFNDUkVFTl9UT1VDSFJJR0hU
PW0NCiMgQ09ORklHX1RPVUNIU0NSRUVOX1RPVUNIV0lOIGlzIG5vdCBzZXQN
CkNPTkZJR19UT1VDSFNDUkVFTl9QSVhDSVI9eQ0KIyBDT05GSUdfVE9VQ0hT
Q1JFRU5fVVNCX0NPTVBPU0lURSBpcyBub3Qgc2V0DQojIENPTkZJR19UT1VD
SFNDUkVFTl9NQzEzNzgzIGlzIG5vdCBzZXQNCiMgQ09ORklHX1RPVUNIU0NS
RUVOX1RPVUNISVQyMTMgaXMgbm90IHNldA0KIyBDT05GSUdfVE9VQ0hTQ1JF
RU5fVFNDX1NFUklPIGlzIG5vdCBzZXQNCiMgQ09ORklHX1RPVUNIU0NSRUVO
X1RTQzIwMDcgaXMgbm90IHNldA0KQ09ORklHX1RPVUNIU0NSRUVOX1NUMTIz
Mj1tDQpDT05GSUdfVE9VQ0hTQ1JFRU5fU1RNUEU9bQ0KQ09ORklHX1RPVUNI
U0NSRUVOX1RQUzY1MDdYPXkNCkNPTkZJR19JTlBVVF9NSVNDPXkNCkNPTkZJ
R19JTlBVVF84OFBNODBYX09OS0VZPXkNCkNPTkZJR19JTlBVVF9BRDcxNFg9
eQ0KIyBDT05GSUdfSU5QVVRfQUQ3MTRYX0kyQyBpcyBub3Qgc2V0DQojIENP
TkZJR19JTlBVVF9CTUExNTAgaXMgbm90IHNldA0KIyBDT05GSUdfSU5QVVRf
UENTUEtSIGlzIG5vdCBzZXQNCkNPTkZJR19JTlBVVF9NQzEzNzgzX1BXUkJV
VFRPTj15DQojIENPTkZJR19JTlBVVF9NTUE4NDUwIGlzIG5vdCBzZXQNCkNP
TkZJR19JTlBVVF9NUFUzMDUwPW0NCkNPTkZJR19JTlBVVF9BUEFORUw9eQ0K
IyBDT05GSUdfSU5QVVRfR1AyQSBpcyBub3Qgc2V0DQpDT05GSUdfSU5QVVRf
R1BJT19USUxUX1BPTExFRD15DQpDT05GSUdfSU5QVVRfV0lTVFJPTl9CVE5T
PXkNCkNPTkZJR19JTlBVVF9BVElfUkVNT1RFMj1tDQpDT05GSUdfSU5QVVRf
S0VZU1BBTl9SRU1PVEU9eQ0KQ09ORklHX0lOUFVUX0tYVEo5PXkNCkNPTkZJ
R19JTlBVVF9LWFRKOV9QT0xMRURfTU9ERT15DQpDT05GSUdfSU5QVVRfUE9X
RVJNQVRFPW0NCkNPTkZJR19JTlBVVF9ZRUFMSU5LPXkNCkNPTkZJR19JTlBV
VF9DTTEwOT15DQpDT05GSUdfSU5QVVRfVFdMNDAzMF9QV1JCVVRUT049bQ0K
Q09ORklHX0lOUFVUX1RXTDQwMzBfVklCUkE9bQ0KQ09ORklHX0lOUFVUX1RX
TDYwNDBfVklCUkE9eQ0KQ09ORklHX0lOUFVUX1VJTlBVVD1tDQpDT05GSUdf
SU5QVVRfUENGODU3ND1tDQpDT05GSUdfSU5QVVRfR1BJT19ST1RBUllfRU5D
T0RFUj1tDQojIENPTkZJR19JTlBVVF9BRFhMMzRYIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0lOUFVUX0lNU19QQ1UgaXMgbm90IHNldA0KIyBDT05GSUdfSU5Q
VVRfQ01BMzAwMCBpcyBub3Qgc2V0DQoNCiMNCiMgSGFyZHdhcmUgSS9PIHBv
cnRzDQojDQpDT05GSUdfU0VSSU89eQ0KQ09ORklHX1NFUklPX0k4MDQyPW0N
CkNPTkZJR19TRVJJT19TRVJQT1JUPXkNCiMgQ09ORklHX1NFUklPX0NUODJD
NzEwIGlzIG5vdCBzZXQNCkNPTkZJR19TRVJJT19MSUJQUzI9bQ0KQ09ORklH
X1NFUklPX1JBVz1tDQojIENPTkZJR19TRVJJT19BTFRFUkFfUFMyIGlzIG5v
dCBzZXQNCkNPTkZJR19TRVJJT19QUzJNVUxUPW0NCkNPTkZJR19TRVJJT19B
UkNfUFMyPXkNCiMgQ09ORklHX0dBTUVQT1JUIGlzIG5vdCBzZXQNCg0KIw0K
IyBDaGFyYWN0ZXIgZGV2aWNlcw0KIw0KQ09ORklHX1RUWT15DQpDT05GSUdf
VlQ9eQ0KIyBDT05GSUdfQ09OU09MRV9UUkFOU0xBVElPTlMgaXMgbm90IHNl
dA0KIyBDT05GSUdfVlRfQ09OU09MRSBpcyBub3Qgc2V0DQpDT05GSUdfSFdf
Q09OU09MRT15DQpDT05GSUdfVlRfSFdfQ09OU09MRV9CSU5ESU5HPXkNCiMg
Q09ORklHX1VOSVg5OF9QVFlTIGlzIG5vdCBzZXQNCkNPTkZJR19MRUdBQ1lf
UFRZUz15DQpDT05GSUdfTEVHQUNZX1BUWV9DT1VOVD0yNTYNCkNPTkZJR19T
RVJJQUxfTk9OU1RBTkRBUkQ9eQ0KIyBDT05GSUdfTl9IRExDIGlzIG5vdCBz
ZXQNCkNPTkZJR19OX0dTTT15DQojIENPTkZJR19UUkFDRV9TSU5LIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0dPTERGSVNIX1RUWSBpcyBub3Qgc2V0DQojIENP
TkZJR19ERVZLTUVNIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NUQUxEUlYgaXMg
bm90IHNldA0KDQojDQojIFNlcmlhbCBkcml2ZXJzDQojDQpDT05GSUdfU0VS
SUFMXzgyNTA9bQ0KIyBDT05GSUdfU0VSSUFMXzgyNTBfREVQUkVDQVRFRF9P
UFRJT05TIGlzIG5vdCBzZXQNCkNPTkZJR19GSVhfRUFSTFlDT05fTUVNPXkN
CiMgQ09ORklHX1NFUklBTF84MjUwX0NTIGlzIG5vdCBzZXQNCkNPTkZJR19T
RVJJQUxfODI1MF9OUl9VQVJUUz00DQpDT05GSUdfU0VSSUFMXzgyNTBfUlVO
VElNRV9VQVJUUz00DQpDT05GSUdfU0VSSUFMXzgyNTBfRVhURU5ERUQ9eQ0K
Q09ORklHX1NFUklBTF84MjUwX01BTllfUE9SVFM9eQ0KQ09ORklHX1NFUklB
TF84MjUwX1NIQVJFX0lSUT15DQpDT05GSUdfU0VSSUFMXzgyNTBfREVURUNU
X0lSUT15DQpDT05GSUdfU0VSSUFMXzgyNTBfUlNBPXkNCkNPTkZJR19TRVJJ
QUxfODI1MF9EVz1tDQoNCiMNCiMgTm9uLTgyNTAgc2VyaWFsIHBvcnQgc3Vw
cG9ydA0KIw0KQ09ORklHX1NFUklBTF9DT1JFPXkNCkNPTkZJR19TRVJJQUxf
Q09SRV9DT05TT0xFPXkNCiMgQ09ORklHX1NFUklBTF9TQ0NOWFAgaXMgbm90
IHNldA0KQ09ORklHX1NFUklBTF9USU1CRVJEQUxFPXkNCkNPTkZJR19TRVJJ
QUxfQUxURVJBX0pUQUdVQVJUPXkNCkNPTkZJR19TRVJJQUxfQUxURVJBX0pU
QUdVQVJUX0NPTlNPTEU9eQ0KIyBDT05GSUdfU0VSSUFMX0FMVEVSQV9KVEFH
VUFSVF9DT05TT0xFX0JZUEFTUyBpcyBub3Qgc2V0DQojIENPTkZJR19TRVJJ
QUxfQUxURVJBX1VBUlQgaXMgbm90IHNldA0KIyBDT05GSUdfU0VSSUFMX0FS
QyBpcyBub3Qgc2V0DQojIENPTkZJR19UVFlfUFJJTlRLIGlzIG5vdCBzZXQN
CkNPTkZJR19IVkNfRFJJVkVSPXkNCkNPTkZJR19WSVJUSU9fQ09OU09MRT15
DQpDT05GSUdfSVBNSV9IQU5ETEVSPXkNCiMgQ09ORklHX0lQTUlfUEFOSUNf
RVZFTlQgaXMgbm90IHNldA0KQ09ORklHX0lQTUlfREVWSUNFX0lOVEVSRkFD
RT15DQpDT05GSUdfSVBNSV9TST15DQpDT05GSUdfSVBNSV9XQVRDSERPRz1t
DQpDT05GSUdfSVBNSV9QT1dFUk9GRj1tDQpDT05GSUdfSFdfUkFORE9NPW0N
CkNPTkZJR19IV19SQU5ET01fVElNRVJJT01FTT1tDQpDT05GSUdfSFdfUkFO
RE9NX1ZJQT1tDQojIENPTkZJR19IV19SQU5ET01fVklSVElPIGlzIG5vdCBz
ZXQNCkNPTkZJR19OVlJBTT15DQpDT05GSUdfUjM5NjQ9eQ0KDQojDQojIFBD
TUNJQSBjaGFyYWN0ZXIgZGV2aWNlcw0KIw0KQ09ORklHX1NZTkNMSU5LX0NT
PW0NCkNPTkZJR19DQVJETUFOXzQwMDA9bQ0KQ09ORklHX0NBUkRNQU5fNDA0
MD1tDQpDT05GSUdfTVdBVkU9bQ0KQ09ORklHX1BDODczNnhfR1BJTz15DQpD
T05GSUdfTlNDX0dQSU89eQ0KQ09ORklHX0hBTkdDSEVDS19USU1FUj15DQoj
IENPTkZJR19UQ0dfVFBNIGlzIG5vdCBzZXQNCkNPTkZJR19URUxDTE9DSz15
DQpDT05GSUdfSTJDPXkNCkNPTkZJR19JMkNfQk9BUkRJTkZPPXkNCkNPTkZJ
R19JMkNfQ09NUEFUPXkNCiMgQ09ORklHX0kyQ19DSEFSREVWIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX0kyQ19NVVggaXMgbm90IHNldA0KIyBDT05GSUdfSTJD
X0hFTFBFUl9BVVRPIGlzIG5vdCBzZXQNCkNPTkZJR19JMkNfU01CVVM9eQ0K
DQojDQojIEkyQyBBbGdvcml0aG1zDQojDQpDT05GSUdfSTJDX0FMR09CSVQ9
eQ0KQ09ORklHX0kyQ19BTEdPUENGPW0NCkNPTkZJR19JMkNfQUxHT1BDQT15
DQoNCiMNCiMgSTJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0DQojDQoNCiMNCiMg
STJDIHN5c3RlbSBidXMgZHJpdmVycyAobW9zdGx5IGVtYmVkZGVkIC8gc3lz
dGVtLW9uLWNoaXApDQojDQpDT05GSUdfSTJDX0NCVVNfR1BJTz15DQpDT05G
SUdfSTJDX0dQSU89bQ0KQ09ORklHX0kyQ19PQ09SRVM9eQ0KQ09ORklHX0ky
Q19QQ0FfUExBVEZPUk09eQ0KIyBDT05GSUdfSTJDX1BYQV9QQ0kgaXMgbm90
IHNldA0KQ09ORklHX0kyQ19TSU1URUM9bQ0KIyBDT05GSUdfSTJDX1hJTElO
WCBpcyBub3Qgc2V0DQoNCiMNCiMgRXh0ZXJuYWwgSTJDL1NNQnVzIGFkYXB0
ZXIgZHJpdmVycw0KIw0KQ09ORklHX0kyQ19ESU9MQU5fVTJDPW0NCkNPTkZJ
R19JMkNfUEFSUE9SVF9MSUdIVD15DQpDT05GSUdfSTJDX1RBT1NfRVZNPW0N
CkNPTkZJR19JMkNfVElOWV9VU0I9bQ0KDQojDQojIE90aGVyIEkyQy9TTUJ1
cyBidXMgZHJpdmVycw0KIw0KIyBDT05GSUdfSTJDX1NUVUIgaXMgbm90IHNl
dA0KQ09ORklHX0kyQ19ERUJVR19DT1JFPXkNCiMgQ09ORklHX0kyQ19ERUJV
R19BTEdPIGlzIG5vdCBzZXQNCkNPTkZJR19JMkNfREVCVUdfQlVTPXkNCiMg
Q09ORklHX1NQSSBpcyBub3Qgc2V0DQpDT05GSUdfSFNJPW0NCkNPTkZJR19I
U0lfQk9BUkRJTkZPPXkNCg0KIw0KIyBIU0kgY2xpZW50cw0KIw0KQ09ORklH
X0hTSV9DSEFSPW0NCg0KIw0KIyBQUFMgc3VwcG9ydA0KIw0KQ09ORklHX1BQ
Uz15DQojIENPTkZJR19QUFNfREVCVUcgaXMgbm90IHNldA0KDQojDQojIFBQ
UyBjbGllbnRzIHN1cHBvcnQNCiMNCiMgQ09ORklHX1BQU19DTElFTlRfS1RJ
TUVSIGlzIG5vdCBzZXQNCkNPTkZJR19QUFNfQ0xJRU5UX0xESVNDPXkNCkNP
TkZJR19QUFNfQ0xJRU5UX0dQSU89bQ0KDQojDQojIFBQUyBnZW5lcmF0b3Jz
IHN1cHBvcnQNCiMNCg0KIw0KIyBQVFAgY2xvY2sgc3VwcG9ydA0KIw0KQ09O
RklHX1BUUF8xNTg4X0NMT0NLPXkNCg0KIw0KIyBFbmFibGUgUEhZTElCIGFu
ZCBORVRXT1JLX1BIWV9USU1FU1RBTVBJTkcgdG8gc2VlIHRoZSBhZGRpdGlv
bmFsIGNsb2Nrcy4NCiMNCkNPTkZJR19QVFBfMTU4OF9DTE9DS19QQ0g9bQ0K
Q09ORklHX0FSQ0hfV0FOVF9PUFRJT05BTF9HUElPTElCPXkNCkNPTkZJR19H
UElPX0RFVlJFUz15DQpDT05GSUdfR1BJT0xJQj15DQojIENPTkZJR19ERUJV
R19HUElPIGlzIG5vdCBzZXQNCkNPTkZJR19HUElPX1NZU0ZTPXkNCkNPTkZJ
R19HUElPX01BWDczMFg9eQ0KDQojDQojIE1lbW9yeSBtYXBwZWQgR1BJTyBk
cml2ZXJzOg0KIw0KIyBDT05GSUdfR1BJT19HRU5FUklDX1BMQVRGT1JNIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0dQSU9fSVQ4NzYxRSBpcyBub3Qgc2V0DQpD
T05GSUdfR1BJT19UUzU1MDA9eQ0KDQojDQojIEkyQyBHUElPIGV4cGFuZGVy
czoNCiMNCiMgQ09ORklHX0dQSU9fQVJJWk9OQSBpcyBub3Qgc2V0DQpDT05G
SUdfR1BJT19NQVg3MzAwPXkNCiMgQ09ORklHX0dQSU9fTUFYNzMyWCBpcyBu
b3Qgc2V0DQpDT05GSUdfR1BJT19QQ0E5NTNYPXkNCiMgQ09ORklHX0dQSU9f
UENBOTUzWF9JUlEgaXMgbm90IHNldA0KIyBDT05GSUdfR1BJT19QQ0Y4NTdY
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0dQSU9fU1gxNTBYIGlzIG5vdCBzZXQN
CiMgQ09ORklHX0dQSU9fU1RNUEUgaXMgbm90IHNldA0KQ09ORklHX0dQSU9f
VEMzNTg5WD15DQpDT05GSUdfR1BJT19UV0w0MDMwPW0NCiMgQ09ORklHX0dQ
SU9fVFdMNjA0MCBpcyBub3Qgc2V0DQojIENPTkZJR19HUElPX1dNODM1MCBp
cyBub3Qgc2V0DQpDT05GSUdfR1BJT19XTTg5OTQ9eQ0KIyBDT05GSUdfR1BJ
T19BRFA1NTIwIGlzIG5vdCBzZXQNCiMgQ09ORklHX0dQSU9fQURQNTU4OCBp
cyBub3Qgc2V0DQoNCiMNCiMgUENJIEdQSU8gZXhwYW5kZXJzOg0KIw0KDQoj
DQojIFNQSSBHUElPIGV4cGFuZGVyczoNCiMNCkNPTkZJR19HUElPX01DUDIz
UzA4PW0NCg0KIw0KIyBBQzk3IEdQSU8gZXhwYW5kZXJzOg0KIw0KDQojDQoj
IE1PRFVMYnVzIEdQSU8gZXhwYW5kZXJzOg0KIw0KIyBDT05GSUdfR1BJT19Q
QUxNQVMgaXMgbm90IHNldA0KDQojDQojIFVTQiBHUElPIGV4cGFuZGVyczoN
CiMNCkNPTkZJR19XMT15DQoNCiMNCiMgMS13aXJlIEJ1cyBNYXN0ZXJzDQoj
DQpDT05GSUdfVzFfTUFTVEVSX0RTMjQ5MD1tDQojIENPTkZJR19XMV9NQVNU
RVJfRFMyNDgyIGlzIG5vdCBzZXQNCkNPTkZJR19XMV9NQVNURVJfRFMxV009
bQ0KQ09ORklHX1cxX01BU1RFUl9HUElPPW0NCg0KIw0KIyAxLXdpcmUgU2xh
dmVzDQojDQpDT05GSUdfVzFfU0xBVkVfVEhFUk09eQ0KQ09ORklHX1cxX1NM
QVZFX1NNRU09eQ0KQ09ORklHX1cxX1NMQVZFX0RTMjQwOD15DQojIENPTkZJ
R19XMV9TTEFWRV9EUzI0MDhfUkVBREJBQ0sgaXMgbm90IHNldA0KQ09ORklH
X1cxX1NMQVZFX0RTMjQxMz15DQojIENPTkZJR19XMV9TTEFWRV9EUzI0MjMg
aXMgbm90IHNldA0KIyBDT05GSUdfVzFfU0xBVkVfRFMyNDMxIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1cxX1NMQVZFX0RTMjQzMyBpcyBub3Qgc2V0DQojIENP
TkZJR19XMV9TTEFWRV9EUzI3NjAgaXMgbm90IHNldA0KQ09ORklHX1cxX1NM
QVZFX0RTMjc4MD15DQpDT05GSUdfVzFfU0xBVkVfRFMyNzgxPXkNCiMgQ09O
RklHX1cxX1NMQVZFX0RTMjhFMDQgaXMgbm90IHNldA0KQ09ORklHX1cxX1NM
QVZFX0JRMjcwMDA9bQ0KQ09ORklHX1BPV0VSX1NVUFBMWT15DQpDT05GSUdf
UE9XRVJfU1VQUExZX0RFQlVHPXkNCiMgQ09ORklHX1BEQV9QT1dFUiBpcyBu
b3Qgc2V0DQpDT05GSUdfR0VORVJJQ19BRENfQkFUVEVSWT1tDQojIENPTkZJ
R19XTTgzNTBfUE9XRVIgaXMgbm90IHNldA0KIyBDT05GSUdfVEVTVF9QT1dF
UiBpcyBub3Qgc2V0DQpDT05GSUdfQkFUVEVSWV9EUzI3ODA9bQ0KIyBDT05G
SUdfQkFUVEVSWV9EUzI3ODEgaXMgbm90IHNldA0KQ09ORklHX0JBVFRFUllf
RFMyNzgyPXkNCkNPTkZJR19CQVRURVJZX1NCUz1tDQpDT05GSUdfQkFUVEVS
WV9CUTI3eDAwPW0NCiMgQ09ORklHX0JBVFRFUllfQlEyN1gwMF9JMkMgaXMg
bm90IHNldA0KQ09ORklHX0JBVFRFUllfQlEyN1gwMF9QTEFURk9STT15DQpD
T05GSUdfQkFUVEVSWV9EQTkwMzA9eQ0KQ09ORklHX0JBVFRFUllfTUFYMTcw
NDA9eQ0KQ09ORklHX0JBVFRFUllfTUFYMTcwNDI9eQ0KQ09ORklHX0JBVFRF
UllfUlg1MT1tDQpDT05GSUdfQ0hBUkdFUl9JU1AxNzA0PXkNCiMgQ09ORklH
X0NIQVJHRVJfTUFYODkwMyBpcyBub3Qgc2V0DQojIENPTkZJR19DSEFSR0VS
X1RXTDQwMzAgaXMgbm90IHNldA0KIyBDT05GSUdfQ0hBUkdFUl9MUDg3Mjcg
aXMgbm90IHNldA0KIyBDT05GSUdfQ0hBUkdFUl9HUElPIGlzIG5vdCBzZXQN
CiMgQ09ORklHX0NIQVJHRVJfTUFOQUdFUiBpcyBub3Qgc2V0DQpDT05GSUdf
Q0hBUkdFUl9CUTI0MTVYPXkNCkNPTkZJR19DSEFSR0VSX1NNQjM0Nz15DQpD
T05GSUdfQ0hBUkdFUl9UUFM2NTA5MD15DQpDT05GSUdfQkFUVEVSWV9HT0xE
RklTSD15DQpDT05GSUdfUE9XRVJfUkVTRVQ9eQ0KQ09ORklHX1BPV0VSX0FW
Uz15DQpDT05GSUdfSFdNT049eQ0KQ09ORklHX0hXTU9OX1ZJRD15DQojIENP
TkZJR19IV01PTl9ERUJVR19DSElQIGlzIG5vdCBzZXQNCg0KIw0KIyBOYXRp
dmUgZHJpdmVycw0KIw0KIyBDT05GSUdfU0VOU09SU19BRDc0MTQgaXMgbm90
IHNldA0KQ09ORklHX1NFTlNPUlNfQUQ3NDE4PXkNCkNPTkZJR19TRU5TT1JT
X0FETTEwMjE9bQ0KQ09ORklHX1NFTlNPUlNfQURNMTAyNT15DQojIENPTkZJ
R19TRU5TT1JTX0FETTEwMjYgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNf
QURNMTAyOT15DQpDT05GSUdfU0VOU09SU19BRE0xMDMxPXkNCiMgQ09ORklH
X1NFTlNPUlNfQURNOTI0MCBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JT
X0FEVDc0MTAgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfQURUNzQxMT15
DQpDT05GSUdfU0VOU09SU19BRFQ3NDYyPXkNCkNPTkZJR19TRU5TT1JTX0FE
VDc0NzA9eQ0KQ09ORklHX1NFTlNPUlNfQURUNzQ3NT15DQpDT05GSUdfU0VO
U09SU19BU0M3NjIxPW0NCiMgQ09ORklHX1NFTlNPUlNfQVNCMTAwIGlzIG5v
dCBzZXQNCkNPTkZJR19TRU5TT1JTX0FUWFAxPW0NCkNPTkZJR19TRU5TT1JT
X0RTNjIwPW0NCiMgQ09ORklHX1NFTlNPUlNfRFMxNjIxIGlzIG5vdCBzZXQN
CkNPTkZJR19TRU5TT1JTX0Y3MTgwNUY9bQ0KQ09ORklHX1NFTlNPUlNfRjcx
ODgyRkc9eQ0KIyBDT05GSUdfU0VOU09SU19GNzUzNzVTIGlzIG5vdCBzZXQN
CkNPTkZJR19TRU5TT1JTX0ZTQ0hNRD1tDQojIENPTkZJR19TRU5TT1JTX0c3
NjBBIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX0dMNTE4U009eQ0KQ09O
RklHX1NFTlNPUlNfR0w1MjBTTT1tDQojIENPTkZJR19TRU5TT1JTX0dQSU9f
RkFOIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX0hJSDYxMzA9eQ0KIyBD
T05GSUdfU0VOU09SU19DT1JFVEVNUCBpcyBub3Qgc2V0DQpDT05GSUdfU0VO
U09SU19JQk1BRU09bQ0KIyBDT05GSUdfU0VOU09SU19JQk1QRVggaXMgbm90
IHNldA0KIyBDT05GSUdfU0VOU09SU19JSU9fSFdNT04gaXMgbm90IHNldA0K
Q09ORklHX1NFTlNPUlNfSVQ4Nz1tDQpDT05GSUdfU0VOU09SU19KQzQyPXkN
CiMgQ09ORklHX1NFTlNPUlNfTElORUFHRSBpcyBub3Qgc2V0DQojIENPTkZJ
R19TRU5TT1JTX0xNNjMgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfTE03
Mz1tDQpDT05GSUdfU0VOU09SU19MTTc1PW0NCiMgQ09ORklHX1NFTlNPUlNf
TE03NyBpcyBub3Qgc2V0DQojIENPTkZJR19TRU5TT1JTX0xNNzggaXMgbm90
IHNldA0KQ09ORklHX1NFTlNPUlNfTE04MD1tDQpDT05GSUdfU0VOU09SU19M
TTgzPXkNCiMgQ09ORklHX1NFTlNPUlNfTE04NSBpcyBub3Qgc2V0DQojIENP
TkZJR19TRU5TT1JTX0xNODcgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNf
TE05MD1tDQojIENPTkZJR19TRU5TT1JTX0xNOTIgaXMgbm90IHNldA0KQ09O
RklHX1NFTlNPUlNfTE05Mz15DQojIENPTkZJR19TRU5TT1JTX0xUQzQxNTEg
aXMgbm90IHNldA0KIyBDT05GSUdfU0VOU09SU19MVEM0MjE1IGlzIG5vdCBz
ZXQNCkNPTkZJR19TRU5TT1JTX0xUQzQyNDU9eQ0KQ09ORklHX1NFTlNPUlNf
TFRDNDI2MT15DQpDT05GSUdfU0VOU09SU19MTTk1MjM0PXkNCiMgQ09ORklH
X1NFTlNPUlNfTE05NTI0MSBpcyBub3Qgc2V0DQpDT05GSUdfU0VOU09SU19M
TTk1MjQ1PXkNCkNPTkZJR19TRU5TT1JTX01BWDE2MDY1PXkNCkNPTkZJR19T
RU5TT1JTX01BWDE2MTk9eQ0KQ09ORklHX1NFTlNPUlNfTUFYMTY2OD1tDQoj
IENPTkZJR19TRU5TT1JTX01BWDE5NyBpcyBub3Qgc2V0DQojIENPTkZJR19T
RU5TT1JTX01BWDY2MzkgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfTUFY
NjY0Mj1tDQpDT05GSUdfU0VOU09SU19NQVg2NjUwPXkNCkNPTkZJR19TRU5T
T1JTX01BWDY2OTc9bQ0KQ09ORklHX1NFTlNPUlNfTUNQMzAyMT15DQojIENP
TkZJR19TRU5TT1JTX05DVDY3NzUgaXMgbm90IHNldA0KQ09ORklHX1NFTlNP
UlNfTlRDX1RIRVJNSVNUT1I9bQ0KIyBDT05GSUdfU0VOU09SU19QQzg3MzYw
IGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFTlNPUlNfUEM4NzQyNyBpcyBub3Qg
c2V0DQpDT05GSUdfU0VOU09SU19QQ0Y4NTkxPW0NCkNPTkZJR19QTUJVUz1t
DQpDT05GSUdfU0VOU09SU19QTUJVUz1tDQpDT05GSUdfU0VOU09SU19BRE0x
Mjc1PW0NCkNPTkZJR19TRU5TT1JTX0xNMjUwNjY9bQ0KIyBDT05GSUdfU0VO
U09SU19MVEMyOTc4IGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX01BWDE2
MDY0PW0NCkNPTkZJR19TRU5TT1JTX01BWDM0NDQwPW0NCkNPTkZJR19TRU5T
T1JTX01BWDg2ODg9bQ0KQ09ORklHX1NFTlNPUlNfVUNEOTAwMD1tDQojIENP
TkZJR19TRU5TT1JTX1VDRDkyMDAgaXMgbm90IHNldA0KIyBDT05GSUdfU0VO
U09SU19aTDYxMDAgaXMgbm90IHNldA0KQ09ORklHX1NFTlNPUlNfU0hUMTU9
bQ0KQ09ORklHX1NFTlNPUlNfU0hUMjE9bQ0KQ09ORklHX1NFTlNPUlNfU01N
NjY1PXkNCkNPTkZJR19TRU5TT1JTX0RNRTE3Mzc9bQ0KIyBDT05GSUdfU0VO
U09SU19FTUMxNDAzIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX0VNQzIx
MDM9bQ0KQ09ORklHX1NFTlNPUlNfRU1DNlcyMDE9bQ0KQ09ORklHX1NFTlNP
UlNfU01TQzQ3TTE9bQ0KQ09ORklHX1NFTlNPUlNfU01TQzQ3TTE5Mj15DQoj
IENPTkZJR19TRU5TT1JTX1NNU0M0N0IzOTcgaXMgbm90IHNldA0KQ09ORklH
X1NFTlNPUlNfU0NINTZYWF9DT01NT049eQ0KQ09ORklHX1NFTlNPUlNfU0NI
NTYyNz1tDQpDT05GSUdfU0VOU09SU19TQ0g1NjM2PXkNCiMgQ09ORklHX1NF
TlNPUlNfQURTMTAxNSBpcyBub3Qgc2V0DQpDT05GSUdfU0VOU09SU19BRFM3
ODI4PW0NCkNPTkZJR19TRU5TT1JTX0FNQzY4MjE9bQ0KQ09ORklHX1NFTlNP
UlNfSU5BMjA5PXkNCiMgQ09ORklHX1NFTlNPUlNfSU5BMlhYIGlzIG5vdCBz
ZXQNCkNPTkZJR19TRU5TT1JTX1RITUM1MD15DQpDT05GSUdfU0VOU09SU19U
TVAxMDI9eQ0KQ09ORklHX1NFTlNPUlNfVE1QNDAxPXkNCkNPTkZJR19TRU5T
T1JTX1RNUDQyMT1tDQpDT05GSUdfU0VOU09SU19UV0w0MDMwX01BREM9bQ0K
Q09ORklHX1NFTlNPUlNfVklBX0NQVVRFTVA9bQ0KQ09ORklHX1NFTlNPUlNf
VlQxMjExPW0NCkNPTkZJR19TRU5TT1JTX1c4Mzc4MUQ9eQ0KQ09ORklHX1NF
TlNPUlNfVzgzNzkxRD1tDQpDT05GSUdfU0VOU09SU19XODM3OTJEPXkNCkNP
TkZJR19TRU5TT1JTX1c4Mzc5Mz1tDQpDT05GSUdfU0VOU09SU19XODM3OTU9
eQ0KQ09ORklHX1NFTlNPUlNfVzgzNzk1X0ZBTkNUUkw9eQ0KQ09ORklHX1NF
TlNPUlNfVzgzTDc4NVRTPXkNCkNPTkZJR19TRU5TT1JTX1c4M0w3ODZORz1t
DQpDT05GSUdfU0VOU09SU19XODM2MjdIRj15DQpDT05GSUdfU0VOU09SU19X
ODM2MjdFSEY9eQ0KIyBDT05GSUdfU0VOU09SU19XTTgzNTAgaXMgbm90IHNl
dA0KIyBDT05GSUdfU0VOU09SU19BUFBMRVNNQyBpcyBub3Qgc2V0DQpDT05G
SUdfU0VOU09SU19NQzEzNzgzX0FEQz1tDQojIENPTkZJR19USEVSTUFMIGlz
IG5vdCBzZXQNCkNPTkZJR19XQVRDSERPRz15DQpDT05GSUdfV0FUQ0hET0df
Q09SRT15DQpDT05GSUdfV0FUQ0hET0dfTk9XQVlPVVQ9eQ0KDQojDQojIFdh
dGNoZG9nIERldmljZSBEcml2ZXJzDQojDQojIENPTkZJR19TT0ZUX1dBVENI
RE9HIGlzIG5vdCBzZXQNCkNPTkZJR19XTTgzNTBfV0FUQ0hET0c9bQ0KIyBD
T05GSUdfVFdMNDAzMF9XQVRDSERPRyBpcyBub3Qgc2V0DQpDT05GSUdfQUNR
VUlSRV9XRFQ9eQ0KQ09ORklHX0FEVkFOVEVDSF9XRFQ9bQ0KIyBDT05GSUdf
RjcxODA4RV9XRFQgaXMgbm90IHNldA0KIyBDT05GSUdfU0M1MjBfV0RUIGlz
IG5vdCBzZXQNCkNPTkZJR19TQkNfRklUUEMyX1dBVENIRE9HPW0NCkNPTkZJ
R19FVVJPVEVDSF9XRFQ9bQ0KIyBDT05GSUdfSUI3MDBfV0RUIGlzIG5vdCBz
ZXQNCkNPTkZJR19JQk1BU1I9bQ0KIyBDT05GSUdfV0FGRVJfV0RUIGlzIG5v
dCBzZXQNCkNPTkZJR19JVDg3MTJGX1dEVD15DQojIENPTkZJR19JVDg3X1dE
VCBpcyBub3Qgc2V0DQpDT05GSUdfU0MxMjAwX1dEVD15DQojIENPTkZJR19Q
Qzg3NDEzX1dEVCBpcyBub3Qgc2V0DQpDT05GSUdfNjBYWF9XRFQ9bQ0KIyBD
T05GSUdfU0JDODM2MF9XRFQgaXMgbm90IHNldA0KQ09ORklHX1NCQzcyNDBf
V0RUPXkNCkNPTkZJR19DUFU1X1dEVD1tDQojIENPTkZJR19TTVNDX1NDSDMx
MVhfV0RUIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NNU0MzN0I3ODdfV0RUIGlz
IG5vdCBzZXQNCkNPTkZJR19XODM2MjdIRl9XRFQ9eQ0KQ09ORklHX1c4MzY5
N0hGX1dEVD15DQpDT05GSUdfVzgzNjk3VUdfV0RUPXkNCkNPTkZJR19XODM4
NzdGX1dEVD1tDQpDT05GSUdfVzgzOTc3Rl9XRFQ9bQ0KQ09ORklHX01BQ0ha
X1dEVD1tDQpDT05GSUdfU0JDX0VQWF9DM19XQVRDSERPRz15DQoNCiMNCiMg
VVNCLWJhc2VkIFdhdGNoZG9nIENhcmRzDQojDQpDT05GSUdfVVNCUENXQVRD
SERPRz1tDQpDT05GSUdfU1NCX1BPU1NJQkxFPXkNCg0KIw0KIyBTb25pY3Mg
U2lsaWNvbiBCYWNrcGxhbmUNCiMNCkNPTkZJR19TU0I9eQ0KIyBDT05GSUdf
U1NCX1NJTEVOVCBpcyBub3Qgc2V0DQojIENPTkZJR19TU0JfREVCVUcgaXMg
bm90IHNldA0KQ09ORklHX1NTQl9EUklWRVJfR1BJTz15DQpDT05GSUdfQkNN
QV9QT1NTSUJMRT15DQoNCiMNCiMgQnJvYWRjb20gc3BlY2lmaWMgQU1CQQ0K
Iw0KQ09ORklHX0JDTUE9eQ0KIyBDT05GSUdfQkNNQV9EUklWRVJfR01BQ19D
TU4gaXMgbm90IHNldA0KQ09ORklHX0JDTUFfRFJJVkVSX0dQSU89eQ0KIyBD
T05GSUdfQkNNQV9ERUJVRyBpcyBub3Qgc2V0DQoNCiMNCiMgTXVsdGlmdW5j
dGlvbiBkZXZpY2UgZHJpdmVycw0KIw0KQ09ORklHX01GRF9DT1JFPXkNCiMg
Q09ORklHX01GRF9BUzM3MTEgaXMgbm90IHNldA0KQ09ORklHX1BNSUNfQURQ
NTUyMD15DQojIENPTkZJR19NRkRfQUFUMjg3MF9DT1JFIGlzIG5vdCBzZXQN
CkNPTkZJR19NRkRfQ1JPU19FQz1tDQpDT05GSUdfTUZEX0NST1NfRUNfSTJD
PW0NCkNPTkZJR19QTUlDX0RBOTAzWD15DQojIENPTkZJR19NRkRfREE5MDUy
X0kyQyBpcyBub3Qgc2V0DQojIENPTkZJR19NRkRfREE5MDU1IGlzIG5vdCBz
ZXQNCkNPTkZJR19NRkRfTUMxMzc4Mz15DQpDT05GSUdfTUZEX01DMTNYWFg9
eQ0KQ09ORklHX01GRF9NQzEzWFhYX0kyQz15DQojIENPTkZJR19IVENfUEFT
SUMzIGlzIG5vdCBzZXQNCkNPTkZJR19IVENfSTJDUExEPXkNCkNPTkZJR19N
RkRfODhQTTgwMD15DQpDT05GSUdfTUZEXzg4UE04MDU9bQ0KIyBDT05GSUdf
TUZEXzg4UE04NjBYIGlzIG5vdCBzZXQNCkNPTkZJR19NRkRfTUFYNzc2ODY9
eQ0KQ09ORklHX01GRF9NQVg3NzY5Mz15DQpDT05GSUdfTUZEX01BWDg5MDc9
eQ0KIyBDT05GSUdfTUZEX01BWDg5MjUgaXMgbm90IHNldA0KIyBDT05GSUdf
TUZEX01BWDg5OTcgaXMgbm90IHNldA0KIyBDT05GSUdfTUZEX01BWDg5OTgg
aXMgbm90IHNldA0KIyBDT05GSUdfTUZEX1ZJUEVSQk9BUkQgaXMgbm90IHNl
dA0KIyBDT05GSUdfTUZEX1JFVFUgaXMgbm90IHNldA0KIyBDT05GSUdfTUZE
X1BDRjUwNjMzIGlzIG5vdCBzZXQNCiMgQ09ORklHX01GRF9SQzVUNTgzIGlz
IG5vdCBzZXQNCkNPTkZJR19NRkRfU0VDX0NPUkU9eQ0KIyBDT05GSUdfTUZE
X1NJNDc2WF9DT1JFIGlzIG5vdCBzZXQNCiMgQ09ORklHX01GRF9TTTUwMSBp
cyBub3Qgc2V0DQojIENPTkZJR19NRkRfU01TQyBpcyBub3Qgc2V0DQojIENP
TkZJR19BQlg1MDBfQ09SRSBpcyBub3Qgc2V0DQpDT05GSUdfTUZEX1NUTVBF
PXkNCg0KIw0KIyBTVE1pY3JvZWxlY3Ryb25pY3MgU1RNUEUgSW50ZXJmYWNl
IERyaXZlcnMNCiMNCkNPTkZJR19TVE1QRV9JMkM9eQ0KIyBDT05GSUdfTUZE
X1NZU0NPTiBpcyBub3Qgc2V0DQojIENPTkZJR19NRkRfVElfQU0zMzVYX1RT
Q0FEQyBpcyBub3Qgc2V0DQojIENPTkZJR19NRkRfTFA4Nzg4IGlzIG5vdCBz
ZXQNCkNPTkZJR19NRkRfUEFMTUFTPXkNCkNPTkZJR19UUFM2MTA1WD15DQoj
IENPTkZJR19UUFM2NTAxMCBpcyBub3Qgc2V0DQojIENPTkZJR19UUFM2NTA3
WCBpcyBub3Qgc2V0DQpDT05GSUdfTUZEX1RQUzY1MDkwPXkNCkNPTkZJR19N
RkRfVFBTNjUyMTc9bQ0KIyBDT05GSUdfTUZEX1RQUzY1ODZYIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX01GRF9UUFM2NTkxMCBpcyBub3Qgc2V0DQojIENPTkZJ
R19NRkRfVFBTNjU5MTIgaXMgbm90IHNldA0KIyBDT05GSUdfTUZEX1RQUzY1
OTEyX0kyQyBpcyBub3Qgc2V0DQojIENPTkZJR19NRkRfVFBTODAwMzEgaXMg
bm90IHNldA0KQ09ORklHX1RXTDQwMzBfQ09SRT15DQpDT05GSUdfVFdMNDAz
MF9NQURDPW0NCkNPTkZJR19NRkRfVFdMNDAzMF9BVURJTz15DQpDT05GSUdf
VFdMNjA0MF9DT1JFPXkNCkNPTkZJR19NRkRfV0wxMjczX0NPUkU9bQ0KQ09O
RklHX01GRF9MTTM1MzM9bQ0KQ09ORklHX01GRF9UQzM1ODlYPXkNCiMgQ09O
RklHX01GRF9UTUlPIGlzIG5vdCBzZXQNCkNPTkZJR19NRkRfQVJJWk9OQT15
DQpDT05GSUdfTUZEX0FSSVpPTkFfSTJDPW0NCiMgQ09ORklHX01GRF9XTTUx
MDIgaXMgbm90IHNldA0KIyBDT05GSUdfTUZEX1dNNTExMCBpcyBub3Qgc2V0
DQpDT05GSUdfTUZEX1dNODQwMD15DQojIENPTkZJR19NRkRfV004MzFYX0ky
QyBpcyBub3Qgc2V0DQpDT05GSUdfTUZEX1dNODM1MD15DQpDT05GSUdfTUZE
X1dNODM1MF9JMkM9eQ0KQ09ORklHX01GRF9XTTg5OTQ9eQ0KQ09ORklHX1JF
R1VMQVRPUj15DQpDT05GSUdfUkVHVUxBVE9SX0RFQlVHPXkNCkNPTkZJR19S
RUdVTEFUT1JfRFVNTVk9eQ0KQ09ORklHX1JFR1VMQVRPUl9GSVhFRF9WT0xU
QUdFPXkNCkNPTkZJR19SRUdVTEFUT1JfVklSVFVBTF9DT05TVU1FUj15DQoj
IENPTkZJR19SRUdVTEFUT1JfVVNFUlNQQUNFX0NPTlNVTUVSIGlzIG5vdCBz
ZXQNCiMgQ09ORklHX1JFR1VMQVRPUl9HUElPIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1JFR1VMQVRPUl9BRDUzOTggaXMgbm90IHNldA0KQ09ORklHX1JFR1VM
QVRPUl9EQTkwM1g9eQ0KQ09ORklHX1JFR1VMQVRPUl9GQU41MzU1NT15DQpD
T05GSUdfUkVHVUxBVE9SX01DMTNYWFhfQ09SRT15DQpDT05GSUdfUkVHVUxB
VE9SX01DMTM3ODM9eQ0KQ09ORklHX1JFR1VMQVRPUl9NQzEzODkyPXkNCiMg
Q09ORklHX1JFR1VMQVRPUl9JU0w2MjcxQSBpcyBub3Qgc2V0DQpDT05GSUdf
UkVHVUxBVE9SX01BWDE1ODY9bQ0KQ09ORklHX1JFR1VMQVRPUl9NQVg4NjQ5
PXkNCiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4NjYwIGlzIG5vdCBzZXQNCkNP
TkZJR19SRUdVTEFUT1JfTUFYODkwNz1tDQojIENPTkZJR19SRUdVTEFUT1Jf
TUFYODk1MiBpcyBub3Qgc2V0DQojIENPTkZJR19SRUdVTEFUT1JfTUFYODk3
MyBpcyBub3Qgc2V0DQpDT05GSUdfUkVHVUxBVE9SX01BWDc3Njg2PXkNCiMg
Q09ORklHX1JFR1VMQVRPUl9MUDM5NzEgaXMgbm90IHNldA0KQ09ORklHX1JF
R1VMQVRPUl9MUDM5NzI9bQ0KIyBDT05GSUdfUkVHVUxBVE9SX0xQODcyWCBp
cyBub3Qgc2V0DQpDT05GSUdfUkVHVUxBVE9SX0xQODc1NT15DQpDT05GSUdf
UkVHVUxBVE9SX1MyTVBTMTE9eQ0KQ09ORklHX1JFR1VMQVRPUl9TNU04NzY3
PW0NCkNPTkZJR19SRUdVTEFUT1JfUEFMTUFTPXkNCkNPTkZJR19SRUdVTEFU
T1JfVFBTNTE2MzI9eQ0KQ09ORklHX1JFR1VMQVRPUl9UUFM2MTA1WD1tDQpD
T05GSUdfUkVHVUxBVE9SX1RQUzYyMzYwPXkNCkNPTkZJR19SRUdVTEFUT1Jf
VFBTNjUwMjM9eQ0KQ09ORklHX1JFR1VMQVRPUl9UUFM2NTA3WD1tDQojIENP
TkZJR19SRUdVTEFUT1JfVFBTNjUwOTAgaXMgbm90IHNldA0KIyBDT05GSUdf
UkVHVUxBVE9SX1RQUzY1MjE3IGlzIG5vdCBzZXQNCiMgQ09ORklHX1JFR1VM
QVRPUl9UV0w0MDMwIGlzIG5vdCBzZXQNCkNPTkZJR19SRUdVTEFUT1JfV004
MzUwPXkNCkNPTkZJR19SRUdVTEFUT1JfV004NDAwPW0NCkNPTkZJR19SRUdV
TEFUT1JfV004OTk0PW0NCkNPTkZJR19NRURJQV9TVVBQT1JUPXkNCg0KIw0K
IyBNdWx0aW1lZGlhIGNvcmUgc3VwcG9ydA0KIw0KIyBDT05GSUdfTUVESUFf
Q0FNRVJBX1NVUFBPUlQgaXMgbm90IHNldA0KQ09ORklHX01FRElBX0FOQUxP
R19UVl9TVVBQT1JUPXkNCkNPTkZJR19NRURJQV9ESUdJVEFMX1RWX1NVUFBP
UlQ9eQ0KIyBDT05GSUdfTUVESUFfUkFESU9fU1VQUE9SVCBpcyBub3Qgc2V0
DQpDT05GSUdfTUVESUFfUkNfU1VQUE9SVD15DQpDT05GSUdfVklERU9fREVW
PXkNCkNPTkZJR19WSURFT19WNEwyPXkNCkNPTkZJR19WSURFT19BRFZfREVC
VUc9eQ0KIyBDT05GSUdfVklERU9fRklYRURfTUlOT1JfUkFOR0VTIGlzIG5v
dCBzZXQNCkNPTkZJR19WSURFT19UVU5FUj15DQpDT05GSUdfVklERU9CVUZf
R0VOPXkNCkNPTkZJR19WSURFT0JVRl9WTUFMTE9DPXkNCkNPTkZJR19WSURF
T0JVRjJfQ09SRT15DQpDT05GSUdfVklERU9CVUYyX01FTU9QUz15DQpDT05G
SUdfVklERU9CVUYyX1ZNQUxMT0M9eQ0KQ09ORklHX1ZJREVPX1Y0TDJfSU5U
X0RFVklDRT15DQpDT05GSUdfRFZCX0NPUkU9eQ0KIyBDT05GSUdfRFZCX05F
VCBpcyBub3Qgc2V0DQpDT05GSUdfVFRQQ0lfRUVQUk9NPW0NCkNPTkZJR19E
VkJfTUFYX0FEQVBURVJTPTgNCkNPTkZJR19EVkJfRFlOQU1JQ19NSU5PUlM9
eQ0KDQojDQojIE1lZGlhIGRyaXZlcnMNCiMNCkNPTkZJR19SQ19DT1JFPXkN
CiMgQ09ORklHX1JDX01BUCBpcyBub3Qgc2V0DQojIENPTkZJR19SQ19ERUNP
REVSUyBpcyBub3Qgc2V0DQojIENPTkZJR19SQ19ERVZJQ0VTIGlzIG5vdCBz
ZXQNCkNPTkZJR19NRURJQV9VU0JfU1VQUE9SVD15DQoNCiMNCiMgQW5hbG9n
IFRWIFVTQiBkZXZpY2VzDQojDQojIENPTkZJR19WSURFT19QVlJVU0IyIGlz
IG5vdCBzZXQNCkNPTkZJR19WSURFT19IRFBWUj1tDQpDT05GSUdfVklERU9f
VVNCVklTSU9OPW0NCkNPTkZJR19WSURFT19TVEsxMTYwPXkNCg0KIw0KIyBB
bmFsb2cvZGlnaXRhbCBUViBVU0IgZGV2aWNlcw0KIw0KQ09ORklHX1ZJREVP
X0FVMDgyOD1tDQojIENPTkZJR19WSURFT19BVTA4MjhfVjRMMiBpcyBub3Qg
c2V0DQojIENPTkZJR19WSURFT19DWDIzMVhYIGlzIG5vdCBzZXQNCkNPTkZJ
R19WSURFT19UTTYwMDA9eQ0KQ09ORklHX1ZJREVPX1RNNjAwMF9EVkI9eQ0K
DQojDQojIERpZ2l0YWwgVFYgVVNCIGRldmljZXMNCiMNCkNPTkZJR19EVkJf
VVNCPXkNCiMgQ09ORklHX0RWQl9VU0JfREVCVUcgaXMgbm90IHNldA0KIyBD
T05GSUdfRFZCX1VTQl9BODAwIGlzIG5vdCBzZXQNCkNPTkZJR19EVkJfVVNC
X0RJQlVTQl9NQj15DQojIENPTkZJR19EVkJfVVNCX0RJQlVTQl9NQl9GQVVM
VFkgaXMgbm90IHNldA0KIyBDT05GSUdfRFZCX1VTQl9ESUJVU0JfTUMgaXMg
bm90IHNldA0KQ09ORklHX0RWQl9VU0JfRElCMDcwMD15DQojIENPTkZJR19E
VkJfVVNCX1VNVF8wMTAgaXMgbm90IHNldA0KQ09ORklHX0RWQl9VU0JfQ1hV
U0I9bQ0KQ09ORklHX0RWQl9VU0JfTTkyMFg9eQ0KQ09ORklHX0RWQl9VU0Jf
RElHSVRWPXkNCiMgQ09ORklHX0RWQl9VU0JfVlA3MDQ1IGlzIG5vdCBzZXQN
CiMgQ09ORklHX0RWQl9VU0JfVlA3MDJYIGlzIG5vdCBzZXQNCkNPTkZJR19E
VkJfVVNCX0dQOFBTSz1tDQpDT05GSUdfRFZCX1VTQl9OT1ZBX1RfVVNCMj1t
DQojIENPTkZJR19EVkJfVVNCX1RUVVNCMiBpcyBub3Qgc2V0DQojIENPTkZJ
R19EVkJfVVNCX0RUVDIwMFUgaXMgbm90IHNldA0KQ09ORklHX0RWQl9VU0Jf
T1BFUkExPXkNCkNPTkZJR19EVkJfVVNCX0FGOTAwNT15DQpDT05GSUdfRFZC
X1VTQl9BRjkwMDVfUkVNT1RFPW0NCkNPTkZJR19EVkJfVVNCX1BDVFY0NTJF
PW0NCkNPTkZJR19EVkJfVVNCX0RXMjEwMj1tDQpDT05GSUdfRFZCX1VTQl9D
SU5FUkdZX1QyPXkNCkNPTkZJR19EVkJfVVNCX0RUVjUxMDA9eQ0KQ09ORklH
X0RWQl9VU0JfRlJJSU89eQ0KQ09ORklHX0RWQl9VU0JfQVo2MDI3PXkNCkNP
TkZJR19EVkJfVVNCX1RFQ0hOSVNBVF9VU0IyPXkNCkNPTkZJR19EVkJfVVNC
X1YyPXkNCkNPTkZJR19EVkJfVVNCX0FGOTAxNT15DQojIENPTkZJR19EVkJf
VVNCX0FGOTAzNSBpcyBub3Qgc2V0DQpDT05GSUdfRFZCX1VTQl9BTllTRUU9
eQ0KQ09ORklHX0RWQl9VU0JfQVU2NjEwPW0NCkNPTkZJR19EVkJfVVNCX0Fa
NjAwNz1tDQpDT05GSUdfRFZCX1VTQl9DRTYyMzA9eQ0KQ09ORklHX0RWQl9V
U0JfRUMxNjg9eQ0KQ09ORklHX0RWQl9VU0JfR0w4NjE9bQ0KQ09ORklHX0RW
Ql9VU0JfSVQ5MTNYPW0NCiMgQ09ORklHX0RWQl9VU0JfTE1FMjUxMCBpcyBu
b3Qgc2V0DQojIENPTkZJR19EVkJfVVNCX01YTDExMVNGIGlzIG5vdCBzZXQN
CiMgQ09ORklHX0RWQl9VU0JfUlRMMjhYWFUgaXMgbm90IHNldA0KQ09ORklH
X1NNU19VU0JfRFJWPW0NCkNPTkZJR19EVkJfQjJDMl9GTEVYQ09QX1VTQj15
DQojIENPTkZJR19EVkJfQjJDMl9GTEVYQ09QX1VTQl9ERUJVRyBpcyBub3Qg
c2V0DQoNCiMNCiMgV2ViY2FtLCBUViAoYW5hbG9nL2RpZ2l0YWwpIFVTQiBk
ZXZpY2VzDQojDQpDT05GSUdfVklERU9fRU0yOFhYPW0NCkNPTkZJR19WSURF
T19FTTI4WFhfRFZCPW0NCkNPTkZJR19WSURFT19FTTI4WFhfUkM9bQ0KDQoj
DQojIFN1cHBvcnRlZCBNTUMvU0RJTyBhZGFwdGVycw0KIw0KQ09ORklHX1NN
U19TRElPX0RSVj1tDQpDT05GSUdfTUVESUFfQ09NTU9OX09QVElPTlM9eQ0K
DQojDQojIGNvbW1vbiBkcml2ZXIgb3B0aW9ucw0KIw0KQ09ORklHX1ZJREVP
X1RWRUVQUk9NPW0NCkNPTkZJR19DWVBSRVNTX0ZJUk1XQVJFPW0NCkNPTkZJ
R19EVkJfQjJDMl9GTEVYQ09QPXkNCkNPTkZJR19TTVNfU0lBTk9fTURUVj1t
DQojIENPTkZJR19TTVNfU0lBTk9fUkMgaXMgbm90IHNldA0KQ09ORklHX1NN
U19TSUFOT19ERUJVR0ZTPXkNCg0KIw0KIyBNZWRpYSBhbmNpbGxhcnkgZHJp
dmVycyAodHVuZXJzLCBzZW5zb3JzLCBpMmMsIGZyb250ZW5kcykNCiMNCiMg
Q09ORklHX01FRElBX1NVQkRSVl9BVVRPU0VMRUNUIGlzIG5vdCBzZXQNCkNP
TkZJR19WSURFT19JUl9JMkM9eQ0KDQojDQojIEVuY29kZXJzLCBkZWNvZGVy
cywgc2Vuc29ycyBhbmQgb3RoZXIgaGVscGVyIGNoaXBzDQojDQoNCiMNCiMg
QXVkaW8gZGVjb2RlcnMsIHByb2Nlc3NvcnMgYW5kIG1peGVycw0KIw0KQ09O
RklHX1ZJREVPX1RWQVVESU89eQ0KQ09ORklHX1ZJREVPX1REQTc0MzI9eQ0K
IyBDT05GSUdfVklERU9fVERBOTg0MCBpcyBub3Qgc2V0DQojIENPTkZJR19W
SURFT19URUE2NDE1QyBpcyBub3Qgc2V0DQpDT05GSUdfVklERU9fVEVBNjQy
MD1tDQojIENPTkZJR19WSURFT19NU1AzNDAwIGlzIG5vdCBzZXQNCkNPTkZJ
R19WSURFT19DUzUzNDU9bQ0KIyBDT05GSUdfVklERU9fQ1M1M0wzMkEgaXMg
bm90IHNldA0KQ09ORklHX1ZJREVPX1RMVjMyMEFJQzIzQj1tDQojIENPTkZJ
R19WSURFT19VREExMzQyIGlzIG5vdCBzZXQNCkNPTkZJR19WSURFT19XTTg3
NzU9bQ0KQ09ORklHX1ZJREVPX1dNODczOT15DQojIENPTkZJR19WSURFT19W
UDI3U01QWCBpcyBub3Qgc2V0DQojIENPTkZJR19WSURFT19TT05ZX0JURl9N
UFggaXMgbm90IHNldA0KDQojDQojIFJEUyBkZWNvZGVycw0KIw0KQ09ORklH
X1ZJREVPX1NBQTY1ODg9eQ0KDQojDQojIFZpZGVvIGRlY29kZXJzDQojDQpD
T05GSUdfVklERU9fQURWNzE4MD15DQpDT05GSUdfVklERU9fQURWNzE4Mz1t
DQpDT05GSUdfVklERU9fQlQ4MTk9bQ0KQ09ORklHX1ZJREVPX0JUODU2PXkN
CkNPTkZJR19WSURFT19CVDg2Nj15DQpDT05GSUdfVklERU9fS1MwMTI3PW0N
CkNPTkZJR19WSURFT19TQUE3MTEwPXkNCkNPTkZJR19WSURFT19TQUE3MTFY
PXkNCkNPTkZJR19WSURFT19TQUE3MTkxPXkNCkNPTkZJR19WSURFT19UVlA1
MTRYPXkNCiMgQ09ORklHX1ZJREVPX1RWUDUxNTAgaXMgbm90IHNldA0KIyBD
T05GSUdfVklERU9fVFZQNzAwMiBpcyBub3Qgc2V0DQpDT05GSUdfVklERU9f
VFcyODA0PW0NCkNPTkZJR19WSURFT19UVzk5MDM9bQ0KQ09ORklHX1ZJREVP
X1RXOTkwNj15DQpDT05GSUdfVklERU9fVlBYMzIyMD1tDQoNCiMNCiMgVmlk
ZW8gYW5kIGF1ZGlvIGRlY29kZXJzDQojDQojIENPTkZJR19WSURFT19TQUE3
MTdYIGlzIG5vdCBzZXQNCkNPTkZJR19WSURFT19DWDI1ODQwPW0NCg0KIw0K
IyBWaWRlbyBlbmNvZGVycw0KIw0KIyBDT05GSUdfVklERU9fU0FBNzEyNyBp
cyBub3Qgc2V0DQpDT05GSUdfVklERU9fU0FBNzE4NT15DQpDT05GSUdfVklE
RU9fQURWNzE3MD15DQpDT05GSUdfVklERU9fQURWNzE3NT1tDQpDT05GSUdf
VklERU9fQURWNzM0Mz1tDQpDT05GSUdfVklERU9fQURWNzM5Mz1tDQpDT05G
SUdfVklERU9fQUs4ODFYPW0NCg0KIw0KIyBDYW1lcmEgc2Vuc29yIGRldmlj
ZXMNCiMNCg0KIw0KIyBGbGFzaCBkZXZpY2VzDQojDQoNCiMNCiMgVmlkZW8g
aW1wcm92ZW1lbnQgY2hpcHMNCiMNCiMgQ09ORklHX1ZJREVPX1VQRDY0MDMx
QSBpcyBub3Qgc2V0DQojIENPTkZJR19WSURFT19VUEQ2NDA4MyBpcyBub3Qg
c2V0DQoNCiMNCiMgTWlzY2VsYW5lb3VzIGhlbHBlciBjaGlwcw0KIw0KQ09O
RklHX1ZJREVPX1RIUzczMDM9bQ0KQ09ORklHX1ZJREVPX001Mjc5MD1tDQoN
CiMNCiMgU2Vuc29ycyB1c2VkIG9uIHNvY19jYW1lcmEgZHJpdmVyDQojDQpD
T05GSUdfTUVESUFfQVRUQUNIPXkNCkNPTkZJR19NRURJQV9UVU5FUj15DQoN
CiMNCiMgQ3VzdG9taXplIFRWIHR1bmVycw0KIw0KQ09ORklHX01FRElBX1RV
TkVSX1NJTVBMRT15DQpDT05GSUdfTUVESUFfVFVORVJfVERBODI5MD15DQpD
T05GSUdfTUVESUFfVFVORVJfVERBODI3WD15DQpDT05GSUdfTUVESUFfVFVO
RVJfVERBMTgyNzE9eQ0KQ09ORklHX01FRElBX1RVTkVSX1REQTk4ODc9eQ0K
Q09ORklHX01FRElBX1RVTkVSX1RFQTU3NjE9eQ0KIyBDT05GSUdfTUVESUFf
VFVORVJfVEVBNTc2NyBpcyBub3Qgc2V0DQpDT05GSUdfTUVESUFfVFVORVJf
TVQyMFhYPW0NCkNPTkZJR19NRURJQV9UVU5FUl9NVDIwNjA9bQ0KQ09ORklH
X01FRElBX1RVTkVSX01UMjA2Mz1tDQpDT05GSUdfTUVESUFfVFVORVJfTVQy
MjY2PXkNCiMgQ09ORklHX01FRElBX1RVTkVSX01UMjEzMSBpcyBub3Qgc2V0
DQpDT05GSUdfTUVESUFfVFVORVJfUVQxMDEwPW0NCkNPTkZJR19NRURJQV9U
VU5FUl9YQzIwMjg9eQ0KQ09ORklHX01FRElBX1RVTkVSX1hDNTAwMD15DQoj
IENPTkZJR19NRURJQV9UVU5FUl9YQzQwMDAgaXMgbm90IHNldA0KQ09ORklH
X01FRElBX1RVTkVSX01YTDUwMDVTPXkNCkNPTkZJR19NRURJQV9UVU5FUl9N
WEw1MDA3VD1tDQojIENPTkZJR19NRURJQV9UVU5FUl9NQzQ0UzgwMyBpcyBu
b3Qgc2V0DQpDT05GSUdfTUVESUFfVFVORVJfTUFYMjE2NT15DQpDT05GSUdf
TUVESUFfVFVORVJfVERBMTgyMTg9bQ0KIyBDT05GSUdfTUVESUFfVFVORVJf
RkMwMDExIGlzIG5vdCBzZXQNCiMgQ09ORklHX01FRElBX1RVTkVSX0ZDMDAx
MiBpcyBub3Qgc2V0DQojIENPTkZJR19NRURJQV9UVU5FUl9GQzAwMTMgaXMg
bm90IHNldA0KQ09ORklHX01FRElBX1RVTkVSX1REQTE4MjEyPXkNCkNPTkZJ
R19NRURJQV9UVU5FUl9FNDAwMD15DQojIENPTkZJR19NRURJQV9UVU5FUl9G
QzI1ODAgaXMgbm90IHNldA0KQ09ORklHX01FRElBX1RVTkVSX1RVQTkwMDE9
eQ0KIyBDT05GSUdfTUVESUFfVFVORVJfSVQ5MTNYIGlzIG5vdCBzZXQNCiMg
Q09ORklHX01FRElBX1RVTkVSX1I4MjBUIGlzIG5vdCBzZXQNCg0KIw0KIyBD
dXN0b21pc2UgRFZCIEZyb250ZW5kcw0KIw0KDQojDQojIE11bHRpc3RhbmRh
cmQgKHNhdGVsbGl0ZSkgZnJvbnRlbmRzDQojDQpDT05GSUdfRFZCX1NUQjA4
OTk9eQ0KQ09ORklHX0RWQl9TVEI2MTAwPW0NCiMgQ09ORklHX0RWQl9TVFYw
OTB4IGlzIG5vdCBzZXQNCkNPTkZJR19EVkJfU1RWNjExMHg9bQ0KDQojDQoj
IE11bHRpc3RhbmRhcmQgKGNhYmxlICsgdGVycmVzdHJpYWwpIGZyb250ZW5k
cw0KIw0KQ09ORklHX0RWQl9EUlhLPW0NCkNPTkZJR19EVkJfVERBMTgyNzFD
MkREPW0NCg0KIw0KIyBEVkItUyAoc2F0ZWxsaXRlKSBmcm9udGVuZHMNCiMN
CiMgQ09ORklHX0RWQl9DWDI0MTEwIGlzIG5vdCBzZXQNCiMgQ09ORklHX0RW
Ql9DWDI0MTIzIGlzIG5vdCBzZXQNCiMgQ09ORklHX0RWQl9NVDMxMiBpcyBu
b3Qgc2V0DQpDT05GSUdfRFZCX1pMMTAwMzY9bQ0KIyBDT05GSUdfRFZCX1pM
MTAwMzkgaXMgbm90IHNldA0KQ09ORklHX0RWQl9TNUgxNDIwPXkNCkNPTkZJ
R19EVkJfU1RWMDI4OD1tDQpDT05GSUdfRFZCX1NUQjYwMDA9bQ0KIyBDT05G
SUdfRFZCX1NUVjAyOTkgaXMgbm90IHNldA0KIyBDT05GSUdfRFZCX1NUVjYx
MTAgaXMgbm90IHNldA0KQ09ORklHX0RWQl9TVFYwOTAwPW0NCkNPTkZJR19E
VkJfVERBODA4Mz1tDQpDT05GSUdfRFZCX1REQTEwMDg2PW0NCkNPTkZJR19E
VkJfVERBODI2MT1tDQpDT05GSUdfRFZCX1ZFUzFYOTM9eQ0KIyBDT05GSUdf
RFZCX1RVTkVSX0lURDEwMDAgaXMgbm90IHNldA0KIyBDT05GSUdfRFZCX1RV
TkVSX0NYMjQxMTMgaXMgbm90IHNldA0KQ09ORklHX0RWQl9UREE4MjZYPW0N
CkNPTkZJR19EVkJfVFVBNjEwMD15DQpDT05GSUdfRFZCX0NYMjQxMTY9eQ0K
Q09ORklHX0RWQl9TSTIxWFg9eQ0KQ09ORklHX0RWQl9UUzIwMjA9eQ0KQ09O
RklHX0RWQl9EUzMwMDA9bQ0KQ09ORklHX0RWQl9NQjg2QTE2PXkNCkNPTkZJ
R19EVkJfVERBMTAwNzE9eQ0KDQojDQojIERWQi1UICh0ZXJyZXN0cmlhbCkg
ZnJvbnRlbmRzDQojDQpDT05GSUdfRFZCX1NQODg3MD15DQpDT05GSUdfRFZC
X1NQODg3WD15DQpDT05GSUdfRFZCX0NYMjI3MDA9eQ0KQ09ORklHX0RWQl9D
WDIyNzAyPW0NCkNPTkZJR19EVkJfUzVIMTQzMj15DQojIENPTkZJR19EVkJf
RFJYRCBpcyBub3Qgc2V0DQojIENPTkZJR19EVkJfTDY0NzgxIGlzIG5vdCBz
ZXQNCkNPTkZJR19EVkJfVERBMTAwNFg9eQ0KQ09ORklHX0RWQl9OWFQ2MDAw
PXkNCkNPTkZJR19EVkJfTVQzNTI9bQ0KQ09ORklHX0RWQl9aTDEwMzUzPXkN
CkNPTkZJR19EVkJfRElCMzAwME1CPXkNCkNPTkZJR19EVkJfRElCMzAwME1D
PW0NCiMgQ09ORklHX0RWQl9ESUI3MDAwTSBpcyBub3Qgc2V0DQojIENPTkZJ
R19EVkJfRElCNzAwMFAgaXMgbm90IHNldA0KIyBDT05GSUdfRFZCX0RJQjkw
MDAgaXMgbm90IHNldA0KIyBDT05GSUdfRFZCX1REQTEwMDQ4IGlzIG5vdCBz
ZXQNCkNPTkZJR19EVkJfQUY5MDEzPXkNCkNPTkZJR19EVkJfRUMxMDA9eQ0K
Q09ORklHX0RWQl9IRDI5TDI9bQ0KQ09ORklHX0RWQl9TVFYwMzY3PXkNCkNP
TkZJR19EVkJfQ1hEMjgyMFI9bQ0KIyBDT05GSUdfRFZCX1JUTDI4MzAgaXMg
bm90IHNldA0KQ09ORklHX0RWQl9SVEwyODMyPW0NCg0KIw0KIyBEVkItQyAo
Y2FibGUpIGZyb250ZW5kcw0KIw0KQ09ORklHX0RWQl9WRVMxODIwPW0NCkNP
TkZJR19EVkJfVERBMTAwMjE9bQ0KQ09ORklHX0RWQl9UREExMDAyMz1tDQpD
T05GSUdfRFZCX1NUVjAyOTc9bQ0KDQojDQojIEFUU0MgKE5vcnRoIEFtZXJp
Y2FuL0tvcmVhbiBUZXJyZXN0cmlhbC9DYWJsZSBEVFYpIGZyb250ZW5kcw0K
Iw0KIyBDT05GSUdfRFZCX05YVDIwMFggaXMgbm90IHNldA0KQ09ORklHX0RW
Ql9PUjUxMjExPXkNCkNPTkZJR19EVkJfT1I1MTEzMj15DQpDT05GSUdfRFZC
X0JDTTM1MTA9bQ0KQ09ORklHX0RWQl9MR0RUMzMwWD1tDQpDT05GSUdfRFZC
X0xHRFQzMzA1PXkNCiMgQ09ORklHX0RWQl9MRzIxNjAgaXMgbm90IHNldA0K
Q09ORklHX0RWQl9TNUgxNDA5PW0NCkNPTkZJR19EVkJfQVU4NTIyPXkNCkNP
TkZJR19EVkJfQVU4NTIyX0RUVj1tDQpDT05GSUdfRFZCX0FVODUyMl9WNEw9
eQ0KQ09ORklHX0RWQl9TNUgxNDExPXkNCg0KIw0KIyBJU0RCLVQgKHRlcnJl
c3RyaWFsKSBmcm9udGVuZHMNCiMNCiMgQ09ORklHX0RWQl9TOTIxIGlzIG5v
dCBzZXQNCkNPTkZJR19EVkJfRElCODAwMD1tDQpDT05GSUdfRFZCX01CODZB
MjBTPW0NCg0KIw0KIyBEaWdpdGFsIHRlcnJlc3RyaWFsIG9ubHkgdHVuZXJz
L1BMTA0KIw0KQ09ORklHX0RWQl9QTEw9bQ0KQ09ORklHX0RWQl9UVU5FUl9E
SUIwMDcwPW0NCiMgQ09ORklHX0RWQl9UVU5FUl9ESUIwMDkwIGlzIG5vdCBz
ZXQNCg0KIw0KIyBTRUMgY29udHJvbCBkZXZpY2VzIGZvciBEVkItUw0KIw0K
Q09ORklHX0RWQl9MTkJQMjE9bQ0KQ09ORklHX0RWQl9MTkJQMjI9bQ0KIyBD
T05GSUdfRFZCX0lTTDY0MDUgaXMgbm90IHNldA0KQ09ORklHX0RWQl9JU0w2
NDIxPXkNCkNPTkZJR19EVkJfSVNMNjQyMz15DQpDT05GSUdfRFZCX0E4Mjkz
PW0NCkNPTkZJR19EVkJfTEdTOEdMNT15DQpDT05GSUdfRFZCX0xHUzhHWFg9
eQ0KQ09ORklHX0RWQl9BVEJNODgzMD15DQojIENPTkZJR19EVkJfVERBNjY1
eCBpcyBub3Qgc2V0DQpDT05GSUdfRFZCX0lYMjUwNVY9bQ0KQ09ORklHX0RW
Ql9JVDkxM1hfRkU9bQ0KIyBDT05GSUdfRFZCX004OFJTMjAwMCBpcyBub3Qg
c2V0DQojIENPTkZJR19EVkJfQUY5MDMzIGlzIG5vdCBzZXQNCg0KIw0KIyBU
b29scyB0byBkZXZlbG9wIG5ldyBmcm9udGVuZHMNCiMNCiMgQ09ORklHX0RW
Ql9EVU1NWV9GRSBpcyBub3Qgc2V0DQoNCiMNCiMgR3JhcGhpY3Mgc3VwcG9y
dA0KIw0KIyBDT05GSUdfRFJNIGlzIG5vdCBzZXQNCkNPTkZJR19WR0FTVEFU
RT15DQpDT05GSUdfVklERU9fT1VUUFVUX0NPTlRST0w9eQ0KQ09ORklHX0ZC
PXkNCkNPTkZJR19GSVJNV0FSRV9FRElEPXkNCiMgQ09ORklHX0ZCX0REQyBp
cyBub3Qgc2V0DQpDT05GSUdfRkJfQk9PVF9WRVNBX1NVUFBPUlQ9eQ0KQ09O
RklHX0ZCX0NGQl9GSUxMUkVDVD15DQpDT05GSUdfRkJfQ0ZCX0NPUFlBUkVB
PXkNCkNPTkZJR19GQl9DRkJfSU1BR0VCTElUPXkNCiMgQ09ORklHX0ZCX0NG
Ql9SRVZfUElYRUxTX0lOX0JZVEUgaXMgbm90IHNldA0KQ09ORklHX0ZCX1NZ
U19GSUxMUkVDVD15DQpDT05GSUdfRkJfU1lTX0NPUFlBUkVBPXkNCkNPTkZJ
R19GQl9TWVNfSU1BR0VCTElUPXkNCiMgQ09ORklHX0ZCX0ZPUkVJR05fRU5E
SUFOIGlzIG5vdCBzZXQNCkNPTkZJR19GQl9TWVNfRk9QUz15DQpDT05GSUdf
RkJfREVGRVJSRURfSU89eQ0KQ09ORklHX0ZCX0hFQ1VCQT15DQojIENPTkZJ
R19GQl9TVkdBTElCIGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZCX01BQ01PREVT
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZCX0JBQ0tMSUdIVCBpcyBub3Qgc2V0
DQpDT05GSUdfRkJfTU9ERV9IRUxQRVJTPXkNCkNPTkZJR19GQl9USUxFQkxJ
VFRJTkc9eQ0KDQojDQojIEZyYW1lIGJ1ZmZlciBoYXJkd2FyZSBkcml2ZXJz
DQojDQojIENPTkZJR19GQl9BUkMgaXMgbm90IHNldA0KQ09ORklHX0ZCX1ZH
QTE2PXkNCkNPTkZJR19GQl9WRVNBPXkNCkNPTkZJR19GQl9ONDExPXkNCiMg
Q09ORklHX0ZCX0hHQSBpcyBub3Qgc2V0DQpDT05GSUdfRkJfUzFEMTNYWFg9
eQ0KQ09ORklHX0ZCX1RNSU89eQ0KIyBDT05GSUdfRkJfVE1JT19BQ0NFTEwg
aXMgbm90IHNldA0KIyBDT05GSUdfRkJfU01TQ1VGWCBpcyBub3Qgc2V0DQpD
T05GSUdfRkJfVURMPW0NCkNPTkZJR19GQl9HT0xERklTSD15DQojIENPTkZJ
R19GQl9WSVJUVUFMIGlzIG5vdCBzZXQNCkNPTkZJR19GQl9NRVRST05PTUU9
bQ0KQ09ORklHX0ZCX0JST0FEU0hFRVQ9eQ0KQ09ORklHX0ZCX0FVT19LMTkw
WD15DQpDT05GSUdfRkJfQVVPX0sxOTAwPXkNCkNPTkZJR19GQl9BVU9fSzE5
MDE9bQ0KIyBDT05GSUdfRVhZTk9TX1ZJREVPIGlzIG5vdCBzZXQNCkNPTkZJ
R19CQUNLTElHSFRfTENEX1NVUFBPUlQ9eQ0KIyBDT05GSUdfTENEX0NMQVNT
X0RFVklDRSBpcyBub3Qgc2V0DQpDT05GSUdfQkFDS0xJR0hUX0NMQVNTX0RF
VklDRT15DQpDT05GSUdfQkFDS0xJR0hUX0dFTkVSSUM9bQ0KIyBDT05GSUdf
QkFDS0xJR0hUX0xNMzUzMyBpcyBub3Qgc2V0DQpDT05GSUdfQkFDS0xJR0hU
X0RBOTAzWD15DQpDT05GSUdfQkFDS0xJR0hUX1NBSEFSQT1tDQojIENPTkZJ
R19CQUNLTElHSFRfQURQNTUyMCBpcyBub3Qgc2V0DQpDT05GSUdfQkFDS0xJ
R0hUX0FEUDg4NjA9eQ0KQ09ORklHX0JBQ0tMSUdIVF9BRFA4ODcwPXkNCiMg
Q09ORklHX0JBQ0tMSUdIVF9MTTM2MzAgaXMgbm90IHNldA0KQ09ORklHX0JB
Q0tMSUdIVF9MTTM2Mzk9bQ0KQ09ORklHX0JBQ0tMSUdIVF9MUDg1NVg9eQ0K
Q09ORklHX0JBQ0tMSUdIVF9QQU5ET1JBPXkNCkNPTkZJR19CQUNLTElHSFRf
VFBTNjUyMTc9bQ0KDQojDQojIENvbnNvbGUgZGlzcGxheSBkcml2ZXIgc3Vw
cG9ydA0KIw0KQ09ORklHX1ZHQV9DT05TT0xFPXkNCkNPTkZJR19WR0FDT05f
U09GVF9TQ1JPTExCQUNLPXkNCkNPTkZJR19WR0FDT05fU09GVF9TQ1JPTExC
QUNLX1NJWkU9NjQNCkNPTkZJR19EVU1NWV9DT05TT0xFPXkNCkNPTkZJR19G
UkFNRUJVRkZFUl9DT05TT0xFPW0NCkNPTkZJR19GUkFNRUJVRkZFUl9DT05T
T0xFX0RFVEVDVF9QUklNQVJZPXkNCiMgQ09ORklHX0ZSQU1FQlVGRkVSX0NP
TlNPTEVfUk9UQVRJT04gaXMgbm90IHNldA0KIyBDT05GSUdfRk9OVFMgaXMg
bm90IHNldA0KQ09ORklHX0ZPTlRfOHg4PXkNCkNPTkZJR19GT05UXzh4MTY9
eQ0KIyBDT05GSUdfTE9HTyBpcyBub3Qgc2V0DQojIENPTkZJR19TT1VORCBp
cyBub3Qgc2V0DQoNCiMNCiMgSElEIHN1cHBvcnQNCiMNCkNPTkZJR19ISUQ9
eQ0KIyBDT05GSUdfSElEX0JBVFRFUllfU1RSRU5HVEggaXMgbm90IHNldA0K
Q09ORklHX0hJRFJBVz15DQpDT05GSUdfVUhJRD15DQpDT05GSUdfSElEX0dF
TkVSSUM9eQ0KDQojDQojIFNwZWNpYWwgSElEIGRyaXZlcnMNCiMNCkNPTkZJ
R19ISURfQTRURUNIPW0NCkNPTkZJR19ISURfQUNSVVg9bQ0KIyBDT05GSUdf
SElEX0FDUlVYX0ZGIGlzIG5vdCBzZXQNCkNPTkZJR19ISURfQVBQTEU9bQ0K
IyBDT05GSUdfSElEX0FQUExFSVIgaXMgbm90IHNldA0KIyBDT05GSUdfSElE
X0FVUkVBTCBpcyBub3Qgc2V0DQojIENPTkZJR19ISURfQkVMS0lOIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0hJRF9DSEVSUlkgaXMgbm90IHNldA0KIyBDT05G
SUdfSElEX0NISUNPTlkgaXMgbm90IHNldA0KQ09ORklHX0hJRF9DWVBSRVNT
PXkNCiMgQ09ORklHX0hJRF9EUkFHT05SSVNFIGlzIG5vdCBzZXQNCkNPTkZJ
R19ISURfRU1TX0ZGPXkNCkNPTkZJR19ISURfRUxFQ09NPXkNCiMgQ09ORklH
X0hJRF9FWktFWSBpcyBub3Qgc2V0DQojIENPTkZJR19ISURfSE9MVEVLIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0hJRF9LRVlUT1VDSCBpcyBub3Qgc2V0DQoj
IENPTkZJR19ISURfS1lFIGlzIG5vdCBzZXQNCkNPTkZJR19ISURfVUNMT0dJ
Qz1tDQpDT05GSUdfSElEX1dBTFRPUD1tDQpDT05GSUdfSElEX0dZUkFUSU9O
PW0NCiMgQ09ORklHX0hJRF9JQ0FERSBpcyBub3Qgc2V0DQpDT05GSUdfSElE
X1RXSU5IQU49eQ0KIyBDT05GSUdfSElEX0tFTlNJTkdUT04gaXMgbm90IHNl
dA0KQ09ORklHX0hJRF9MQ1BPV0VSPXkNCkNPTkZJR19ISURfTEVOT1ZPX1RQ
S0JEPW0NCkNPTkZJR19ISURfTE9HSVRFQ0g9bQ0KQ09ORklHX0hJRF9MT0dJ
VEVDSF9ESj1tDQojIENPTkZJR19MT0dJVEVDSF9GRiBpcyBub3Qgc2V0DQoj
IENPTkZJR19MT0dJUlVNQkxFUEFEMl9GRiBpcyBub3Qgc2V0DQojIENPTkZJ
R19MT0dJRzk0MF9GRiBpcyBub3Qgc2V0DQojIENPTkZJR19MT0dJV0hFRUxT
X0ZGIGlzIG5vdCBzZXQNCkNPTkZJR19ISURfTUFHSUNNT1VTRT15DQojIENP
TkZJR19ISURfTUlDUk9TT0ZUIGlzIG5vdCBzZXQNCkNPTkZJR19ISURfTU9O
VEVSRVk9bQ0KIyBDT05GSUdfSElEX01VTFRJVE9VQ0ggaXMgbm90IHNldA0K
Q09ORklHX0hJRF9OVFJJRz15DQpDT05GSUdfSElEX09SVEVLPW0NCiMgQ09O
RklHX0hJRF9QQU5USEVSTE9SRCBpcyBub3Qgc2V0DQojIENPTkZJR19ISURf
UEVUQUxZTlggaXMgbm90IHNldA0KQ09ORklHX0hJRF9QSUNPTENEPW0NCkNP
TkZJR19ISURfUElDT0xDRF9GQj15DQojIENPTkZJR19ISURfUElDT0xDRF9C
QUNLTElHSFQgaXMgbm90IHNldA0KIyBDT05GSUdfSElEX1BJQ09MQ0RfTEVE
UyBpcyBub3Qgc2V0DQpDT05GSUdfSElEX1BJQ09MQ0RfQ0lSPXkNCkNPTkZJ
R19ISURfUFJJTUFYPXkNCkNPTkZJR19ISURfUFMzUkVNT1RFPW0NCiMgQ09O
RklHX0hJRF9ST0NDQVQgaXMgbm90IHNldA0KQ09ORklHX0hJRF9TQUlURUs9
eQ0KIyBDT05GSUdfSElEX1NBTVNVTkcgaXMgbm90IHNldA0KQ09ORklHX0hJ
RF9TT05ZPW0NCkNPTkZJR19ISURfU1BFRURMSU5LPW0NCkNPTkZJR19ISURf
U1RFRUxTRVJJRVM9bQ0KQ09ORklHX0hJRF9TVU5QTFVTPW0NCiMgQ09ORklH
X0hJRF9HUkVFTkFTSUEgaXMgbm90IHNldA0KQ09ORklHX0hJRF9TTUFSVEpP
WVBMVVM9bQ0KQ09ORklHX1NNQVJUSk9ZUExVU19GRj15DQpDT05GSUdfSElE
X1RJVk89bQ0KQ09ORklHX0hJRF9UT1BTRUVEPXkNCkNPTkZJR19ISURfVEhJ
TkdNPW0NCkNPTkZJR19ISURfVEhSVVNUTUFTVEVSPXkNCiMgQ09ORklHX1RI
UlVTVE1BU1RFUl9GRiBpcyBub3Qgc2V0DQojIENPTkZJR19ISURfV0FDT00g
aXMgbm90IHNldA0KIyBDT05GSUdfSElEX1dJSU1PVEUgaXMgbm90IHNldA0K
Q09ORklHX0hJRF9aRVJPUExVUz15DQpDT05GSUdfWkVST1BMVVNfRkY9eQ0K
Q09ORklHX0hJRF9aWURBQ1JPTj1tDQpDT05GSUdfSElEX1NFTlNPUl9IVUI9
bQ0KDQojDQojIFVTQiBISUQgc3VwcG9ydA0KIw0KQ09ORklHX1VTQl9ISUQ9
eQ0KIyBDT05GSUdfSElEX1BJRCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX0hJ
RERFVj15DQoNCiMNCiMgSTJDIEhJRCBzdXBwb3J0DQojDQpDT05GSUdfSTJD
X0hJRD1tDQojIENPTkZJR19VU0JfQVJDSF9IQVNfT0hDSSBpcyBub3Qgc2V0
DQojIENPTkZJR19VU0JfQVJDSF9IQVNfRUhDSSBpcyBub3Qgc2V0DQojIENP
TkZJR19VU0JfQVJDSF9IQVNfWEhDSSBpcyBub3Qgc2V0DQpDT05GSUdfVVNC
X1NVUFBPUlQ9eQ0KQ09ORklHX1VTQl9DT01NT049eQ0KQ09ORklHX1VTQl9B
UkNIX0hBU19IQ0Q9eQ0KQ09ORklHX1VTQj15DQpDT05GSUdfVVNCX0RFQlVH
PXkNCkNPTkZJR19VU0JfQU5OT1VOQ0VfTkVXX0RFVklDRVM9eQ0KDQojDQoj
IE1pc2NlbGxhbmVvdXMgVVNCIG9wdGlvbnMNCiMNCiMgQ09ORklHX1VTQl9E
RUZBVUxUX1BFUlNJU1QgaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX0RZTkFN
SUNfTUlOT1JTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9PVEcgaXMgbm90
IHNldA0KQ09ORklHX1VTQl9PVEdfV0hJVEVMSVNUPXkNCiMgQ09ORklHX1VT
Ql9PVEdfQkxBQ0tMSVNUX0hVQiBpcyBub3Qgc2V0DQojIENPTkZJR19VU0Jf
TU9OIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfV1VTQl9DQkFGPW0NCiMgQ09O
RklHX1VTQl9XVVNCX0NCQUZfREVCVUcgaXMgbm90IHNldA0KDQojDQojIFVT
QiBIb3N0IENvbnRyb2xsZXIgRHJpdmVycw0KIw0KIyBDT05GSUdfVVNCX0M2
N1gwMF9IQ0QgaXMgbm90IHNldA0KQ09ORklHX1VTQl9PWFUyMTBIUF9IQ0Q9
eQ0KQ09ORklHX1VTQl9JU1AxMTZYX0hDRD1tDQpDT05GSUdfVVNCX0lTUDE3
NjBfSENEPXkNCkNPTkZJR19VU0JfSVNQMTM2Ml9IQ0Q9eQ0KIyBDT05GSUdf
VVNCX0ZVU0JIMjAwX0hDRCBpcyBub3Qgc2V0DQojIENPTkZJR19VU0JfVTEz
Ml9IQ0QgaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX1NMODExX0hDRCBpcyBu
b3Qgc2V0DQojIENPTkZJR19VU0JfUjhBNjY1OTdfSENEIGlzIG5vdCBzZXQN
CkNPTkZJR19VU0JfUkVORVNBU19VU0JIU19IQ0Q9bQ0KIyBDT05GSUdfVVNC
X0hDRF9CQ01BIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9IQ0RfU1NCIGlz
IG5vdCBzZXQNCkNPTkZJR19VU0JfTVVTQl9IRFJDPW0NCiMgQ09ORklHX1VT
Ql9NVVNCX1RVU0I2MDEwIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfTVVTQl9E
U1BTPW0NCkNPTkZJR19VU0JfTVVTQl9VWDUwMD1tDQpDT05GSUdfVVNCX1VY
NTAwX0RNQT15DQojIENPTkZJR19NVVNCX1BJT19PTkxZIGlzIG5vdCBzZXQN
CkNPTkZJR19VU0JfUkVORVNBU19VU0JIUz1tDQoNCiMNCiMgVVNCIERldmlj
ZSBDbGFzcyBkcml2ZXJzDQojDQpDT05GSUdfVVNCX0FDTT15DQojIENPTkZJ
R19VU0JfUFJJTlRFUiBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1dETT1tDQpD
T05GSUdfVVNCX1RNQz1tDQoNCiMNCiMgTk9URTogVVNCX1NUT1JBR0UgZGVw
ZW5kcyBvbiBTQ1NJIGJ1dCBCTEtfREVWX1NEIG1heQ0KIw0KDQojDQojIGFs
c28gYmUgbmVlZGVkOyBzZWUgVVNCX1NUT1JBR0UgSGVscCBmb3IgbW9yZSBp
bmZvDQojDQoNCiMNCiMgVVNCIEltYWdpbmcgZGV2aWNlcw0KIw0KIyBDT05G
SUdfVVNCX01EQzgwMCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX0RXQzM9eQ0K
Q09ORklHX1VTQl9EV0MzX0hPU1Q9eQ0KQ09ORklHX1VTQl9EV0MzX0RFQlVH
PXkNCiMgQ09ORklHX1VTQl9EV0MzX1ZFUkJPU0UgaXMgbm90IHNldA0KIyBD
T05GSUdfVVNCX0NISVBJREVBIGlzIG5vdCBzZXQNCg0KIw0KIyBVU0IgcG9y
dCBkcml2ZXJzDQojDQpDT05GSUdfVVNCX1NFUklBTD1tDQojIENPTkZJR19V
U0JfU0VSSUFMX0dFTkVSSUMgaXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJ
QUxfQUlSQ0FCTEU9bQ0KQ09ORklHX1VTQl9TRVJJQUxfQVJLMzExNj1tDQpD
T05GSUdfVVNCX1NFUklBTF9CRUxLSU49bQ0KQ09ORklHX1VTQl9TRVJJQUxf
Q0gzNDE9bQ0KIyBDT05GSUdfVVNCX1NFUklBTF9XSElURUhFQVQgaXMgbm90
IHNldA0KIyBDT05GSUdfVVNCX1NFUklBTF9ESUdJX0FDQ0VMRVBPUlQgaXMg
bm90IHNldA0KIyBDT05GSUdfVVNCX1NFUklBTF9DUDIxMFggaXMgbm90IHNl
dA0KIyBDT05GSUdfVVNCX1NFUklBTF9DWVBSRVNTX004IGlzIG5vdCBzZXQN
CkNPTkZJR19VU0JfU0VSSUFMX0VNUEVHPW0NCiMgQ09ORklHX1VTQl9TRVJJ
QUxfRlRESV9TSU8gaXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxfRlVO
U09GVD1tDQpDT05GSUdfVVNCX1NFUklBTF9WSVNPUj1tDQpDT05GSUdfVVNC
X1NFUklBTF9JUEFRPW0NCiMgQ09ORklHX1VTQl9TRVJJQUxfSVIgaXMgbm90
IHNldA0KIyBDT05GSUdfVVNCX1NFUklBTF9FREdFUE9SVCBpcyBub3Qgc2V0
DQojIENPTkZJR19VU0JfU0VSSUFMX0VER0VQT1JUX1RJIGlzIG5vdCBzZXQN
CkNPTkZJR19VU0JfU0VSSUFMX0Y4MTIzMj1tDQpDT05GSUdfVVNCX1NFUklB
TF9HQVJNSU49bQ0KQ09ORklHX1VTQl9TRVJJQUxfSVBXPW0NCkNPTkZJR19V
U0JfU0VSSUFMX0lVVT1tDQojIENPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5f
UERBIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU49bQ0K
Q09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9NUFI9eQ0KIyBDT05GSUdfVVNC
X1NFUklBTF9LRVlTUEFOX1VTQTI4IGlzIG5vdCBzZXQNCkNPTkZJR19VU0Jf
U0VSSUFMX0tFWVNQQU5fVVNBMjhYPXkNCkNPTkZJR19VU0JfU0VSSUFMX0tF
WVNQQU5fVVNBMjhYQT15DQojIENPTkZJR19VU0JfU0VSSUFMX0tFWVNQQU5f
VVNBMjhYQiBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1NFUklBTF9LRVlTUEFO
X1VTQTE5PXkNCiMgQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0ExOFgg
aXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0ExOVc9
eQ0KQ09ORklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0ExOVFXPXkNCiMgQ09O
RklHX1VTQl9TRVJJQUxfS0VZU1BBTl9VU0ExOVFJIGlzIG5vdCBzZXQNCkNP
TkZJR19VU0JfU0VSSUFMX0tFWVNQQU5fVVNBNDlXPXkNCkNPTkZJR19VU0Jf
U0VSSUFMX0tFWVNQQU5fVVNBNDlXTEM9eQ0KIyBDT05GSUdfVVNCX1NFUklB
TF9LTFNJIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfS09CSUxf
U0NUIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfU0VSSUFMX01DVF9VMjMyPW0N
CkNPTkZJR19VU0JfU0VSSUFMX01FVFJPPW0NCiMgQ09ORklHX1VTQl9TRVJJ
QUxfTU9TNzcyMCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1NFUklBTF9NT1M3
ODQwPW0NCkNPTkZJR19VU0JfU0VSSUFMX01PVE9ST0xBPW0NCiMgQ09ORklH
X1VTQl9TRVJJQUxfTkFWTUFOIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9T
RVJJQUxfUEwyMzAzIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxf
T1RJNjg1OCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1NFUklBTF9RQ0FVWD1t
DQojIENPTkZJR19VU0JfU0VSSUFMX1FVQUxDT01NIGlzIG5vdCBzZXQNCkNP
TkZJR19VU0JfU0VSSUFMX1NQQ1A4WDU9bQ0KIyBDT05GSUdfVVNCX1NFUklB
TF9IUDRYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfU0FGRSBp
cyBub3Qgc2V0DQojIENPTkZJR19VU0JfU0VSSUFMX1NJRU1FTlNfTVBJIGlz
IG5vdCBzZXQNCiMgQ09ORklHX1VTQl9TRVJJQUxfU0lFUlJBV0lSRUxFU1Mg
aXMgbm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxfU1lNQk9MPW0NCkNPTkZJ
R19VU0JfU0VSSUFMX1RJPW0NCkNPTkZJR19VU0JfU0VSSUFMX0NZQkVSSkFD
Sz1tDQpDT05GSUdfVVNCX1NFUklBTF9YSVJDT009bQ0KQ09ORklHX1VTQl9T
RVJJQUxfV1dBTj1tDQpDT05GSUdfVVNCX1NFUklBTF9PUFRJT049bQ0KIyBD
T05GSUdfVVNCX1NFUklBTF9PTU5JTkVUIGlzIG5vdCBzZXQNCkNPTkZJR19V
U0JfU0VSSUFMX09QVElDT049bQ0KQ09ORklHX1VTQl9TRVJJQUxfVklWT1BB
WV9TRVJJQUw9bQ0KIyBDT05GSUdfVVNCX1NFUklBTF9YU0VOU19NVCBpcyBu
b3Qgc2V0DQpDT05GSUdfVVNCX1NFUklBTF9aSU89bQ0KQ09ORklHX1VTQl9T
RVJJQUxfV0lTSEJPTkU9bQ0KIyBDT05GSUdfVVNCX1NFUklBTF9aVEUgaXMg
bm90IHNldA0KQ09ORklHX1VTQl9TRVJJQUxfU1NVMTAwPW0NCkNPTkZJR19V
U0JfU0VSSUFMX1FUMj1tDQpDT05GSUdfVVNCX1NFUklBTF9ERUJVRz1tDQoN
CiMNCiMgVVNCIE1pc2NlbGxhbmVvdXMgZHJpdmVycw0KIw0KQ09ORklHX1VT
Ql9FTUk2Mj15DQpDT05GSUdfVVNCX0VNSTI2PW0NCkNPTkZJR19VU0JfQURV
VFVYPW0NCiMgQ09ORklHX1VTQl9TRVZTRUcgaXMgbm90IHNldA0KQ09ORklH
X1VTQl9SSU81MDA9bQ0KIyBDT05GSUdfVVNCX0xFR09UT1dFUiBpcyBub3Qg
c2V0DQpDT05GSUdfVVNCX0xDRD1tDQojIENPTkZJR19VU0JfTEVEIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1VTQl9DWVBSRVNTX0NZN0M2MyBpcyBub3Qgc2V0
DQpDT05GSUdfVVNCX0NZVEhFUk09eQ0KQ09ORklHX1VTQl9JRE1PVVNFPW0N
CkNPTkZJR19VU0JfRlRESV9FTEFOPW0NCkNPTkZJR19VU0JfQVBQTEVESVNQ
TEFZPXkNCkNPTkZJR19VU0JfU0lTVVNCVkdBPW0NCiMgQ09ORklHX1VTQl9T
SVNVU0JWR0FfQ09OIGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfTEQ9eQ0KIyBD
T05GSUdfVVNCX1RSQU5DRVZJQlJBVE9SIGlzIG5vdCBzZXQNCkNPTkZJR19V
U0JfSU9XQVJSSU9SPW0NCiMgQ09ORklHX1VTQl9URVNUIGlzIG5vdCBzZXQN
CiMgQ09ORklHX1VTQl9JU0lHSFRGVyBpcyBub3Qgc2V0DQojIENPTkZJR19V
U0JfWVVSRVggaXMgbm90IHNldA0KQ09ORklHX1VTQl9FWlVTQl9GWDI9bQ0K
Q09ORklHX1VTQl9IU0lDX1VTQjM1MDM9bQ0KQ09ORklHX1VTQl9QSFk9eQ0K
IyBDT05GSUdfTk9QX1VTQl9YQ0VJViBpcyBub3Qgc2V0DQpDT05GSUdfT01B
UF9DT05UUk9MX1VTQj15DQpDT05GSUdfT01BUF9VU0IzPXkNCkNPTkZJR19T
QU1TVU5HX1VTQlBIWT15DQpDT05GSUdfU0FNU1VOR19VU0IyUEhZPW0NCkNP
TkZJR19TQU1TVU5HX1VTQjNQSFk9bQ0KQ09ORklHX1VTQl9HUElPX1ZCVVM9
bQ0KQ09ORklHX1VTQl9JU1AxMzAxPXkNCiMgQ09ORklHX1VTQl9SQ0FSX1BI
WSBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX0dBREdFVD1tDQpDT05GSUdfVVNC
X0dBREdFVF9ERUJVRz15DQojIENPTkZJR19VU0JfR0FER0VUX0RFQlVHX0ZT
IGlzIG5vdCBzZXQNCkNPTkZJR19VU0JfR0FER0VUX1ZCVVNfRFJBVz0yDQpD
T05GSUdfVVNCX0dBREdFVF9TVE9SQUdFX05VTV9CVUZGRVJTPTINCg0KIw0K
IyBVU0IgUGVyaXBoZXJhbCBDb250cm9sbGVyDQojDQojIENPTkZJR19VU0Jf
RlVTQjMwMCBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX1I4QTY2NTk3PW0NCkNP
TkZJR19VU0JfUkVORVNBU19VU0JIU19VREM9bQ0KQ09ORklHX1VTQl9QWEEy
N1g9bQ0KQ09ORklHX1VTQl9NVl9VREM9bQ0KQ09ORklHX1VTQl9NVl9VM0Q9
bQ0KIyBDT05GSUdfVVNCX0dBREdFVF9NVVNCX0hEUkMgaXMgbm90IHNldA0K
IyBDT05GSUdfVVNCX002NjU5MiBpcyBub3Qgc2V0DQpDT05GSUdfVVNCX05F
VDIyNzI9bQ0KQ09ORklHX1VTQl9ORVQyMjcyX0RNQT15DQpDT05GSUdfVVNC
X0RVTU1ZX0hDRD1tDQpDT05GSUdfVVNCX0xJQkNPTVBPU0lURT1tDQpDT05G
SUdfVVNCX0ZfQUNNPW0NCkNPTkZJR19VU0JfRl9TU19MQj1tDQpDT05GSUdf
VVNCX1VfU0VSSUFMPW0NCkNPTkZJR19VU0JfRl9TRVJJQUw9bQ0KQ09ORklH
X1VTQl9GX09CRVg9bQ0KQ09ORklHX1VTQl9aRVJPPW0NCkNPTkZJR19VU0Jf
RVRIPW0NCkNPTkZJR19VU0JfRVRIX1JORElTPXkNCiMgQ09ORklHX1VTQl9F
VEhfRUVNIGlzIG5vdCBzZXQNCiMgQ09ORklHX1VTQl9HX05DTSBpcyBub3Qg
c2V0DQpDT05GSUdfVVNCX0dBREdFVEZTPW0NCkNPTkZJR19VU0JfRlVOQ1RJ
T05GUz1tDQojIENPTkZJR19VU0JfRlVOQ1RJT05GU19FVEggaXMgbm90IHNl
dA0KQ09ORklHX1VTQl9GVU5DVElPTkZTX1JORElTPXkNCkNPTkZJR19VU0Jf
RlVOQ1RJT05GU19HRU5FUklDPXkNCkNPTkZJR19VU0JfR19TRVJJQUw9bQ0K
IyBDT05GSUdfVVNCX0dfUFJJTlRFUiBpcyBub3Qgc2V0DQpDT05GSUdfVVNC
X0NEQ19DT01QT1NJVEU9bQ0KQ09ORklHX1VTQl9HX0hJRD1tDQpDT05GSUdf
VVNCX0dfREJHUD1tDQojIENPTkZJR19VU0JfR19EQkdQX1BSSU5USyBpcyBu
b3Qgc2V0DQpDT05GSUdfVVNCX0dfREJHUF9TRVJJQUw9eQ0KIyBDT05GSUdf
VVNCX0dfV0VCQ0FNIGlzIG5vdCBzZXQNCkNPTkZJR19NTUM9bQ0KIyBDT05G
SUdfTU1DX0RFQlVHIGlzIG5vdCBzZXQNCkNPTkZJR19NTUNfVU5TQUZFX1JF
U1VNRT15DQojIENPTkZJR19NTUNfQ0xLR0FURSBpcyBub3Qgc2V0DQoNCiMN
CiMgTU1DL1NEL1NESU8gQ2FyZCBEcml2ZXJzDQojDQpDT05GSUdfU0RJT19V
QVJUPW0NCkNPTkZJR19NTUNfVEVTVD1tDQoNCiMNCiMgTU1DL1NEL1NESU8g
SG9zdCBDb250cm9sbGVyIERyaXZlcnMNCiMNCiMgQ09ORklHX01NQ19TREhD
SSBpcyBub3Qgc2V0DQpDT05GSUdfTU1DX1dCU0Q9bQ0KIyBDT05GSUdfTU1D
X0dPTERGSVNIIGlzIG5vdCBzZXQNCkNPTkZJR19NTUNfVlVCMzAwPW0NCkNP
TkZJR19NTUNfVVNIQz1tDQpDT05GSUdfTUVNU1RJQ0s9eQ0KIyBDT05GSUdf
TUVNU1RJQ0tfREVCVUcgaXMgbm90IHNldA0KDQojDQojIE1lbW9yeVN0aWNr
IGRyaXZlcnMNCiMNCiMgQ09ORklHX01FTVNUSUNLX1VOU0FGRV9SRVNVTUUg
aXMgbm90IHNldA0KDQojDQojIE1lbW9yeVN0aWNrIEhvc3QgQ29udHJvbGxl
ciBEcml2ZXJzDQojDQpDT05GSUdfTkVXX0xFRFM9eQ0KQ09ORklHX0xFRFNf
Q0xBU1M9eQ0KDQojDQojIExFRCBkcml2ZXJzDQojDQpDT05GSUdfTEVEU19M
TTM1MzA9bQ0KIyBDT05GSUdfTEVEU19MTTM1MzMgaXMgbm90IHNldA0KIyBD
T05GSUdfTEVEU19MTTM2NDIgaXMgbm90IHNldA0KIyBDT05GSUdfTEVEU19Q
Q0E5NTMyIGlzIG5vdCBzZXQNCkNPTkZJR19MRURTX0dQSU89bQ0KIyBDT05G
SUdfTEVEU19MUDM5NDQgaXMgbm90IHNldA0KQ09ORklHX0xFRFNfTFA1NVhY
X0NPTU1PTj1tDQojIENPTkZJR19MRURTX0xQNTUyMSBpcyBub3Qgc2V0DQpD
T05GSUdfTEVEU19MUDU1MjM9bQ0KIyBDT05GSUdfTEVEU19MUDU1NjIgaXMg
bm90IHNldA0KQ09ORklHX0xFRFNfUENBOTU1WD15DQpDT05GSUdfTEVEU19Q
Q0E5NjMzPW0NCkNPTkZJR19MRURTX1dNODM1MD15DQojIENPTkZJR19MRURT
X0RBOTAzWCBpcyBub3Qgc2V0DQpDT05GSUdfTEVEU19SRUdVTEFUT1I9eQ0K
Q09ORklHX0xFRFNfQkQyODAyPXkNCkNPTkZJR19MRURTX0xUMzU5Mz1tDQpD
T05GSUdfTEVEU19BRFA1NTIwPW0NCiMgQ09ORklHX0xFRFNfTUMxMzc4MyBp
cyBub3Qgc2V0DQpDT05GSUdfTEVEU19UQ0E2NTA3PXkNCiMgQ09ORklHX0xF
RFNfTE0zNTV4IGlzIG5vdCBzZXQNCiMgQ09ORklHX0xFRFNfT1QyMDAgaXMg
bm90IHNldA0KIyBDT05GSUdfTEVEU19CTElOS00gaXMgbm90IHNldA0KDQoj
DQojIExFRCBUcmlnZ2Vycw0KIw0KIyBDT05GSUdfTEVEU19UUklHR0VSUyBp
cyBub3Qgc2V0DQpDT05GSUdfQUNDRVNTSUJJTElUWT15DQojIENPTkZJR19B
MTFZX0JSQUlMTEVfQ09OU09MRSBpcyBub3Qgc2V0DQojIENPTkZJR19FREFD
IGlzIG5vdCBzZXQNCkNPTkZJR19SVENfTElCPXkNCkNPTkZJR19SVENfQ0xB
U1M9eQ0KIyBDT05GSUdfUlRDX0hDVE9TWVMgaXMgbm90IHNldA0KIyBDT05G
SUdfUlRDX1NZU1RPSEMgaXMgbm90IHNldA0KIyBDT05GSUdfUlRDX0RFQlVH
IGlzIG5vdCBzZXQNCg0KIw0KIyBSVEMgaW50ZXJmYWNlcw0KIw0KQ09ORklH
X1JUQ19JTlRGX1NZU0ZTPXkNCiMgQ09ORklHX1JUQ19JTlRGX0RFViBpcyBu
b3Qgc2V0DQpDT05GSUdfUlRDX0RSVl9URVNUPW0NCg0KIw0KIyBJMkMgUlRD
IGRyaXZlcnMNCiMNCkNPTkZJR19SVENfRFJWXzg4UE04MFg9bQ0KQ09ORklH
X1JUQ19EUlZfRFMxMzA3PW0NCkNPTkZJR19SVENfRFJWX0RTMTM3ND1tDQoj
IENPTkZJR19SVENfRFJWX0RTMTY3MiBpcyBub3Qgc2V0DQpDT05GSUdfUlRD
X0RSVl9EUzMyMzI9bQ0KQ09ORklHX1JUQ19EUlZfTUFYNjkwMD1tDQojIENP
TkZJR19SVENfRFJWX01BWDg5MDcgaXMgbm90IHNldA0KQ09ORklHX1JUQ19E
UlZfTUFYNzc2ODY9eQ0KQ09ORklHX1JUQ19EUlZfUlM1QzM3Mj15DQpDT05G
SUdfUlRDX0RSVl9JU0wxMjA4PW0NCkNPTkZJR19SVENfRFJWX0lTTDEyMDIy
PW0NCkNPTkZJR19SVENfRFJWX1gxMjA1PXkNCiMgQ09ORklHX1JUQ19EUlZf
UEFMTUFTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1JUQ19EUlZfUENGODUyMyBp
cyBub3Qgc2V0DQpDT05GSUdfUlRDX0RSVl9QQ0Y4NTYzPXkNCkNPTkZJR19S
VENfRFJWX1BDRjg1ODM9eQ0KIyBDT05GSUdfUlRDX0RSVl9NNDFUODAgaXMg
bm90IHNldA0KQ09ORklHX1JUQ19EUlZfQlEzMks9eQ0KIyBDT05GSUdfUlRD
X0RSVl9UV0w0MDMwIGlzIG5vdCBzZXQNCkNPTkZJR19SVENfRFJWX1MzNTM5
MEE9bQ0KIyBDT05GSUdfUlRDX0RSVl9GTTMxMzAgaXMgbm90IHNldA0KQ09O
RklHX1JUQ19EUlZfUlg4NTgxPXkNCiMgQ09ORklHX1JUQ19EUlZfUlg4MDI1
IGlzIG5vdCBzZXQNCkNPTkZJR19SVENfRFJWX0VNMzAyNz15DQpDT05GSUdf
UlRDX0RSVl9SVjMwMjlDMj1tDQoNCiMNCiMgU1BJIFJUQyBkcml2ZXJzDQoj
DQoNCiMNCiMgUGxhdGZvcm0gUlRDIGRyaXZlcnMNCiMNCiMgQ09ORklHX1JU
Q19EUlZfQ01PUyBpcyBub3Qgc2V0DQpDT05GSUdfUlRDX0RSVl9EUzEyODY9
bQ0KQ09ORklHX1JUQ19EUlZfRFMxNTExPXkNCkNPTkZJR19SVENfRFJWX0RT
MTU1Mz1tDQojIENPTkZJR19SVENfRFJWX0RTMTc0MiBpcyBub3Qgc2V0DQoj
IENPTkZJR19SVENfRFJWX1NUSzE3VEE4IGlzIG5vdCBzZXQNCkNPTkZJR19S
VENfRFJWX000OFQ4Nj15DQojIENPTkZJR19SVENfRFJWX000OFQzNSBpcyBu
b3Qgc2V0DQpDT05GSUdfUlRDX0RSVl9NNDhUNTk9bQ0KIyBDT05GSUdfUlRD
X0RSVl9NU002MjQyIGlzIG5vdCBzZXQNCkNPTkZJR19SVENfRFJWX0JRNDgw
Mj1tDQpDT05GSUdfUlRDX0RSVl9SUDVDMDE9bQ0KQ09ORklHX1JUQ19EUlZf
VjMwMjA9bQ0KQ09ORklHX1JUQ19EUlZfRFMyNDA0PXkNCiMgQ09ORklHX1JU
Q19EUlZfV004MzUwIGlzIG5vdCBzZXQNCg0KIw0KIyBvbi1DUFUgUlRDIGRy
aXZlcnMNCiMNCiMgQ09ORklHX1JUQ19EUlZfTUMxM1hYWCBpcyBub3Qgc2V0
DQoNCiMNCiMgSElEIFNlbnNvciBSVEMgZHJpdmVycw0KIw0KIyBDT05GSUdf
UlRDX0RSVl9ISURfU0VOU09SX1RJTUUgaXMgbm90IHNldA0KIyBDT05GSUdf
RE1BREVWSUNFUyBpcyBub3Qgc2V0DQpDT05GSUdfQVVYRElTUExBWT15DQoj
IENPTkZJR19VSU8gaXMgbm90IHNldA0KQ09ORklHX1ZJUlRfRFJJVkVSUz15
DQpDT05GSUdfVklSVElPPXkNCg0KIw0KIyBWaXJ0aW8gZHJpdmVycw0KIw0K
Q09ORklHX1ZJUlRJT19CQUxMT09OPW0NCiMgQ09ORklHX1ZJUlRJT19NTUlP
IGlzIG5vdCBzZXQNCg0KIw0KIyBNaWNyb3NvZnQgSHlwZXItViBndWVzdCBz
dXBwb3J0DQojDQojIENPTkZJR19TVEFHSU5HIGlzIG5vdCBzZXQNCiMgQ09O
RklHX1g4Nl9QTEFURk9STV9ERVZJQ0VTIGlzIG5vdCBzZXQNCiMgQ09ORklH
X0dPTERGSVNIX1BJUEUgaXMgbm90IHNldA0KDQojDQojIEhhcmR3YXJlIFNw
aW5sb2NrIGRyaXZlcnMNCiMNCkNPTkZJR19DTEtTUkNfSTgyNTM9eQ0KQ09O
RklHX0NMS0VWVF9JODI1Mz15DQpDT05GSUdfSTgyNTNfTE9DSz15DQpDT05G
SUdfQ0xLQkxEX0k4MjUzPXkNCiMgQ09ORklHX01BSUxCT1ggaXMgbm90IHNl
dA0KQ09ORklHX0lPTU1VX1NVUFBPUlQ9eQ0KDQojDQojIFJlbW90ZXByb2Mg
ZHJpdmVycw0KIw0KQ09ORklHX1JFTU9URVBST0M9bQ0KQ09ORklHX1NURV9N
T0RFTV9SUFJPQz1tDQoNCiMNCiMgUnBtc2cgZHJpdmVycw0KIw0KQ09ORklH
X1BNX0RFVkZSRVE9eQ0KDQojDQojIERFVkZSRVEgR292ZXJub3JzDQojDQpD
T05GSUdfREVWRlJFUV9HT1ZfU0lNUExFX09OREVNQU5EPW0NCkNPTkZJR19E
RVZGUkVRX0dPVl9QRVJGT1JNQU5DRT15DQojIENPTkZJR19ERVZGUkVRX0dP
Vl9QT1dFUlNBVkUgaXMgbm90IHNldA0KQ09ORklHX0RFVkZSRVFfR09WX1VT
RVJTUEFDRT1tDQoNCiMNCiMgREVWRlJFUSBEcml2ZXJzDQojDQpDT05GSUdf
RVhUQ09OPW0NCg0KIw0KIyBFeHRjb24gRGV2aWNlIERyaXZlcnMNCiMNCiMg
Q09ORklHX0VYVENPTl9HUElPIGlzIG5vdCBzZXQNCkNPTkZJR19FWFRDT05f
QURDX0pBQ0s9bQ0KQ09ORklHX0VYVENPTl9NQVg3NzY5Mz1tDQojIENPTkZJ
R19NRU1PUlkgaXMgbm90IHNldA0KQ09ORklHX0lJTz1tDQpDT05GSUdfSUlP
X0JVRkZFUj15DQpDT05GSUdfSUlPX0JVRkZFUl9DQj15DQpDT05GSUdfSUlP
X0tGSUZPX0JVRj1tDQpDT05GSUdfSUlPX1RSSUdHRVJFRF9CVUZGRVI9bQ0K
Q09ORklHX0lJT19UUklHR0VSPXkNCkNPTkZJR19JSU9fQ09OU1VNRVJTX1BF
Ul9UUklHR0VSPTINCg0KIw0KIyBBY2NlbGVyb21ldGVycw0KIw0KIyBDT05G
SUdfSElEX1NFTlNPUl9BQ0NFTF8zRCBpcyBub3Qgc2V0DQpDT05GSUdfSUlP
X1NUX0FDQ0VMXzNBWElTPW0NCkNPTkZJR19JSU9fU1RfQUNDRUxfSTJDXzNB
WElTPW0NCg0KIw0KIyBBbmFsb2cgdG8gZGlnaXRhbCBjb252ZXJ0ZXJzDQoj
DQpDT05GSUdfTUFYMTM2Mz1tDQpDT05GSUdfVElfQURDMDgxQz1tDQoNCiMN
CiMgQW1wbGlmaWVycw0KIw0KDQojDQojIEhpZCBTZW5zb3IgSUlPIENvbW1v
bg0KIw0KQ09ORklHX0hJRF9TRU5TT1JfSUlPX0NPTU1PTj1tDQpDT05GSUdf
SElEX1NFTlNPUl9JSU9fVFJJR0dFUj1tDQpDT05GSUdfSElEX1NFTlNPUl9F
TlVNX0JBU0VfUVVJUktTPXkNCkNPTkZJR19JSU9fU1RfU0VOU09SU19JMkM9
bQ0KQ09ORklHX0lJT19TVF9TRU5TT1JTX0NPUkU9bQ0KDQojDQojIERpZ2l0
YWwgdG8gYW5hbG9nIGNvbnZlcnRlcnMNCiMNCkNPTkZJR19BRDUwNjQ9bQ0K
Q09ORklHX0FENTM4MD1tDQpDT05GSUdfQUQ1NDQ2PW0NCkNPTkZJR19NQVg1
MTc9bQ0KQ09ORklHX01DUDQ3MjU9bQ0KDQojDQojIEZyZXF1ZW5jeSBTeW50
aGVzaXplcnMgRERTL1BMTA0KIw0KDQojDQojIENsb2NrIEdlbmVyYXRvci9E
aXN0cmlidXRpb24NCiMNCg0KIw0KIyBQaGFzZS1Mb2NrZWQgTG9vcCAoUExM
KSBmcmVxdWVuY3kgc3ludGhlc2l6ZXJzDQojDQoNCiMNCiMgRGlnaXRhbCBn
eXJvc2NvcGUgc2Vuc29ycw0KIw0KQ09ORklHX0hJRF9TRU5TT1JfR1lST18z
RD1tDQpDT05GSUdfSUlPX1NUX0dZUk9fM0FYSVM9bQ0KQ09ORklHX0lJT19T
VF9HWVJPX0kyQ18zQVhJUz1tDQojIENPTkZJR19JVEczMjAwIGlzIG5vdCBz
ZXQNCg0KIw0KIyBJbmVydGlhbCBtZWFzdXJlbWVudCB1bml0cw0KIw0KIyBD
T05GSUdfSU5WX01QVTYwNTBfSUlPIGlzIG5vdCBzZXQNCg0KIw0KIyBMaWdo
dCBzZW5zb3JzDQojDQpDT05GSUdfQURKRF9TMzExPW0NCiMgQ09ORklHX1NF
TlNPUlNfTE0zNTMzIGlzIG5vdCBzZXQNCkNPTkZJR19TRU5TT1JTX1RTTDI1
NjM9bQ0KIyBDT05GSUdfVkNOTDQwMDAgaXMgbm90IHNldA0KIyBDT05GSUdf
SElEX1NFTlNPUl9BTFMgaXMgbm90IHNldA0KDQojDQojIE1hZ25ldG9tZXRl
ciBzZW5zb3JzDQojDQpDT05GSUdfQUs4OTc1PW0NCkNPTkZJR19ISURfU0VO
U09SX01BR05FVE9NRVRFUl8zRD1tDQpDT05GSUdfSUlPX1NUX01BR05fM0FY
SVM9bQ0KQ09ORklHX0lJT19TVF9NQUdOX0kyQ18zQVhJUz1tDQojIENPTkZJ
R19QV00gaXMgbm90IHNldA0KQ09ORklHX0lQQUNLX0JVUz1tDQpDT05GSUdf
U0VSSUFMX0lQT0NUQUw9bQ0KQ09ORklHX1JFU0VUX0NPTlRST0xMRVI9eQ0K
DQojDQojIEZpcm13YXJlIERyaXZlcnMNCiMNCkNPTkZJR19FREQ9eQ0KIyBD
T05GSUdfRUREX09GRiBpcyBub3Qgc2V0DQojIENPTkZJR19GSVJNV0FSRV9N
RU1NQVAgaXMgbm90IHNldA0KQ09ORklHX0RFTExfUkJVPW0NCkNPTkZJR19E
Q0RCQVM9bQ0KQ09ORklHX0lTQ1NJX0lCRlRfRklORD15DQpDT05GSUdfR09P
R0xFX0ZJUk1XQVJFPXkNCg0KIw0KIyBHb29nbGUgRmlybXdhcmUgRHJpdmVy
cw0KIw0KDQojDQojIEZpbGUgc3lzdGVtcw0KIw0KQ09ORklHX0RDQUNIRV9X
T1JEX0FDQ0VTUz15DQojIENPTkZJR19GU19QT1NJWF9BQ0wgaXMgbm90IHNl
dA0KIyBDT05GSUdfRklMRV9MT0NLSU5HIGlzIG5vdCBzZXQNCkNPTkZJR19G
U05PVElGWT15DQojIENPTkZJR19ETk9USUZZIGlzIG5vdCBzZXQNCkNPTkZJ
R19JTk9USUZZX1VTRVI9eQ0KIyBDT05GSUdfRkFOT1RJRlkgaXMgbm90IHNl
dA0KQ09ORklHX1FVT1RBPXkNCiMgQ09ORklHX1FVT1RBX05FVExJTktfSU5U
RVJGQUNFIGlzIG5vdCBzZXQNCkNPTkZJR19QUklOVF9RVU9UQV9XQVJOSU5H
PXkNCkNPTkZJR19RVU9UQV9ERUJVRz15DQpDT05GSUdfUVVPVEFfVFJFRT1t
DQpDT05GSUdfUUZNVF9WMT1tDQpDT05GSUdfUUZNVF9WMj1tDQpDT05GSUdf
UVVPVEFDVEw9eQ0KQ09ORklHX0FVVE9GUzRfRlM9eQ0KQ09ORklHX0ZVU0Vf
RlM9bQ0KQ09ORklHX0NVU0U9bQ0KDQojDQojIENhY2hlcw0KIw0KQ09ORklH
X0ZTQ0FDSEU9eQ0KIyBDT05GSUdfRlNDQUNIRV9ERUJVRyBpcyBub3Qgc2V0
DQoNCiMNCiMgUHNldWRvIGZpbGVzeXN0ZW1zDQojDQojIENPTkZJR19QUk9D
X0ZTIGlzIG5vdCBzZXQNCkNPTkZJR19TWVNGUz15DQojIENPTkZJR19UTVBG
UyBpcyBub3Qgc2V0DQojIENPTkZJR19IVUdFVExCRlMgaXMgbm90IHNldA0K
IyBDT05GSUdfSFVHRVRMQl9QQUdFIGlzIG5vdCBzZXQNCkNPTkZJR19DT05G
SUdGU19GUz1tDQpDT05GSUdfTUlTQ19GSUxFU1lTVEVNUz15DQpDT05GSUdf
RUNSWVBUX0ZTPW0NCkNPTkZJR19FQ1JZUFRfRlNfTUVTU0FHSU5HPXkNCiMg
Q09ORklHX0pGRlMyX0ZTIGlzIG5vdCBzZXQNCkNPTkZJR19MT0dGUz15DQpD
T05GSUdfUk9NRlNfRlM9bQ0KQ09ORklHX1JPTUZTX0JBQ0tFRF9CWV9NVEQ9
eQ0KQ09ORklHX1JPTUZTX09OX01URD15DQpDT05GSUdfUFNUT1JFPXkNCiMg
Q09ORklHX1BTVE9SRV9DT05TT0xFIGlzIG5vdCBzZXQNCkNPTkZJR19QU1RP
UkVfUkFNPW0NCiMgQ09ORklHX05FVFdPUktfRklMRVNZU1RFTVMgaXMgbm90
IHNldA0KQ09ORklHX05MUz15DQpDT05GSUdfTkxTX0RFRkFVTFQ9Imlzbzg4
NTktMSINCkNPTkZJR19OTFNfQ09ERVBBR0VfNDM3PW0NCiMgQ09ORklHX05M
U19DT0RFUEFHRV83MzcgaXMgbm90IHNldA0KQ09ORklHX05MU19DT0RFUEFH
RV83NzU9eQ0KQ09ORklHX05MU19DT0RFUEFHRV84NTA9eQ0KQ09ORklHX05M
U19DT0RFUEFHRV84NTI9eQ0KIyBDT05GSUdfTkxTX0NPREVQQUdFXzg1NSBp
cyBub3Qgc2V0DQpDT05GSUdfTkxTX0NPREVQQUdFXzg1Nz1tDQpDT05GSUdf
TkxTX0NPREVQQUdFXzg2MD15DQpDT05GSUdfTkxTX0NPREVQQUdFXzg2MT15
DQpDT05GSUdfTkxTX0NPREVQQUdFXzg2Mj15DQpDT05GSUdfTkxTX0NPREVQ
QUdFXzg2Mz1tDQpDT05GSUdfTkxTX0NPREVQQUdFXzg2ND1tDQpDT05GSUdf
TkxTX0NPREVQQUdFXzg2NT15DQpDT05GSUdfTkxTX0NPREVQQUdFXzg2Nj15
DQpDT05GSUdfTkxTX0NPREVQQUdFXzg2OT1tDQojIENPTkZJR19OTFNfQ09E
RVBBR0VfOTM2IGlzIG5vdCBzZXQNCiMgQ09ORklHX05MU19DT0RFUEFHRV85
NTAgaXMgbm90IHNldA0KQ09ORklHX05MU19DT0RFUEFHRV85MzI9bQ0KQ09O
RklHX05MU19DT0RFUEFHRV85NDk9bQ0KQ09ORklHX05MU19DT0RFUEFHRV84
NzQ9bQ0KQ09ORklHX05MU19JU084ODU5Xzg9eQ0KQ09ORklHX05MU19DT0RF
UEFHRV8xMjUwPXkNCkNPTkZJR19OTFNfQ09ERVBBR0VfMTI1MT15DQojIENP
TkZJR19OTFNfQVNDSUkgaXMgbm90IHNldA0KQ09ORklHX05MU19JU084ODU5
XzE9bQ0KQ09ORklHX05MU19JU084ODU5XzI9bQ0KQ09ORklHX05MU19JU084
ODU5XzM9bQ0KIyBDT05GSUdfTkxTX0lTTzg4NTlfNCBpcyBub3Qgc2V0DQpD
T05GSUdfTkxTX0lTTzg4NTlfNT1tDQpDT05GSUdfTkxTX0lTTzg4NTlfNj1t
DQpDT05GSUdfTkxTX0lTTzg4NTlfNz15DQpDT05GSUdfTkxTX0lTTzg4NTlf
OT15DQpDT05GSUdfTkxTX0lTTzg4NTlfMTM9bQ0KQ09ORklHX05MU19JU084
ODU5XzE0PXkNCkNPTkZJR19OTFNfSVNPODg1OV8xNT1tDQpDT05GSUdfTkxT
X0tPSThfUj15DQojIENPTkZJR19OTFNfS09JOF9VIGlzIG5vdCBzZXQNCkNP
TkZJR19OTFNfTUFDX1JPTUFOPXkNCkNPTkZJR19OTFNfTUFDX0NFTFRJQz1t
DQpDT05GSUdfTkxTX01BQ19DRU5URVVSTz1tDQpDT05GSUdfTkxTX01BQ19D
Uk9BVElBTj15DQpDT05GSUdfTkxTX01BQ19DWVJJTExJQz1tDQojIENPTkZJ
R19OTFNfTUFDX0dBRUxJQyBpcyBub3Qgc2V0DQojIENPTkZJR19OTFNfTUFD
X0dSRUVLIGlzIG5vdCBzZXQNCkNPTkZJR19OTFNfTUFDX0lDRUxBTkQ9bQ0K
Q09ORklHX05MU19NQUNfSU5VSVQ9eQ0KQ09ORklHX05MU19NQUNfUk9NQU5J
QU49bQ0KQ09ORklHX05MU19NQUNfVFVSS0lTSD15DQpDT05GSUdfTkxTX1VU
Rjg9eQ0KQ09ORklHX0RMTT1tDQpDT05GSUdfRExNX0RFQlVHPXkNCg0KIw0K
IyBLZXJuZWwgaGFja2luZw0KIw0KQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NV
UFBPUlQ9eQ0KQ09ORklHX0RFRkFVTFRfTUVTU0FHRV9MT0dMRVZFTD00DQpD
T05GSUdfRU5BQkxFX1dBUk5fREVQUkVDQVRFRD15DQojIENPTkZJR19FTkFC
TEVfTVVTVF9DSEVDSyBpcyBub3Qgc2V0DQpDT05GSUdfRlJBTUVfV0FSTj0x
MDI0DQojIENPTkZJR19NQUdJQ19TWVNSUSBpcyBub3Qgc2V0DQpDT05GSUdf
U1RSSVBfQVNNX1NZTVM9eQ0KIyBDT05GSUdfUkVBREFCTEVfQVNNIGlzIG5v
dCBzZXQNCiMgQ09ORklHX1VOVVNFRF9TWU1CT0xTIGlzIG5vdCBzZXQNCkNP
TkZJR19ERUJVR19GUz15DQpDT05GSUdfSEVBREVSU19DSEVDSz15DQpDT05G
SUdfREVCVUdfU0VDVElPTl9NSVNNQVRDSD15DQpDT05GSUdfREVCVUdfS0VS
TkVMPXkNCkNPTkZJR19ERUJVR19TSElSUT15DQojIENPTkZJR19MT0NLVVBf
REVURUNUT1IgaXMgbm90IHNldA0KQ09ORklHX1BBTklDX09OX09PUFM9eQ0K
Q09ORklHX1BBTklDX09OX09PUFNfVkFMVUU9MQ0KIyBDT05GSUdfREVURUNU
X0hVTkdfVEFTSyBpcyBub3Qgc2V0DQpDT05GSUdfREVCVUdfT0JKRUNUUz15
DQojIENPTkZJR19ERUJVR19PQkpFQ1RTX1NFTEZURVNUIGlzIG5vdCBzZXQN
CkNPTkZJR19ERUJVR19PQkpFQ1RTX0ZSRUU9eQ0KIyBDT05GSUdfREVCVUdf
T0JKRUNUU19USU1FUlMgaXMgbm90IHNldA0KQ09ORklHX0RFQlVHX09CSkVD
VFNfV09SSz15DQojIENPTkZJR19ERUJVR19PQkpFQ1RTX1JDVV9IRUFEIGlz
IG5vdCBzZXQNCiMgQ09ORklHX0RFQlVHX09CSkVDVFNfUEVSQ1BVX0NPVU5U
RVIgaXMgbm90IHNldA0KQ09ORklHX0RFQlVHX09CSkVDVFNfRU5BQkxFX0RF
RkFVTFQ9MQ0KIyBDT05GSUdfU0xVQl9ERUJVR19PTiBpcyBub3Qgc2V0DQpD
T05GSUdfU0xVQl9TVEFUUz15DQpDT05GSUdfSEFWRV9ERUJVR19LTUVNTEVB
Sz15DQpDT05GSUdfREVCVUdfS01FTUxFQUs9eQ0KQ09ORklHX0RFQlVHX0tN
RU1MRUFLX0VBUkxZX0xPR19TSVpFPTQwMA0KQ09ORklHX0RFQlVHX0tNRU1M
RUFLX1RFU1Q9bQ0KQ09ORklHX0RFQlVHX0tNRU1MRUFLX0RFRkFVTFRfT0ZG
PXkNCiMgQ09ORklHX0RFQlVHX1JUX01VVEVYRVMgaXMgbm90IHNldA0KQ09O
RklHX1JUX01VVEVYX1RFU1RFUj15DQpDT05GSUdfREVCVUdfU1BJTkxPQ0s9
eQ0KQ09ORklHX0RFQlVHX01VVEVYRVM9eQ0KQ09ORklHX0RFQlVHX0xPQ0tf
QUxMT0M9eQ0KIyBDT05GSUdfUFJPVkVfTE9DS0lORyBpcyBub3Qgc2V0DQpD
T05GSUdfTE9DS0RFUD15DQpDT05GSUdfTE9DS19TVEFUPXkNCkNPTkZJR19E
RUJVR19MT0NLREVQPXkNCkNPTkZJR19ERUJVR19BVE9NSUNfU0xFRVA9eQ0K
Q09ORklHX0RFQlVHX0xPQ0tJTkdfQVBJX1NFTEZURVNUUz15DQpDT05GSUdf
U1RBQ0tUUkFDRT15DQojIENPTkZJR19ERUJVR19TVEFDS19VU0FHRSBpcyBu
b3Qgc2V0DQojIENPTkZJR19ERUJVR19LT0JKRUNUIGlzIG5vdCBzZXQNCkNP
TkZJR19ERUJVR19ISUdITUVNPXkNCkNPTkZJR19ERUJVR19JTkZPPXkNCkNP
TkZJR19ERUJVR19JTkZPX1JFRFVDRUQ9eQ0KIyBDT05GSUdfREVCVUdfVk0g
aXMgbm90IHNldA0KQ09ORklHX0RFQlVHX1ZJUlRVQUw9eQ0KIyBDT05GSUdf
REVCVUdfV1JJVEVDT1VOVCBpcyBub3Qgc2V0DQpDT05GSUdfREVCVUdfTUVN
T1JZX0lOSVQ9eQ0KQ09ORklHX0RFQlVHX0xJU1Q9eQ0KIyBDT05GSUdfVEVT
VF9MSVNUX1NPUlQgaXMgbm90IHNldA0KQ09ORklHX0RFQlVHX1NHPXkNCkNP
TkZJR19ERUJVR19OT1RJRklFUlM9eQ0KQ09ORklHX0RFQlVHX0NSRURFTlRJ
QUxTPXkNCkNPTkZJR19BUkNIX1dBTlRfRlJBTUVfUE9JTlRFUlM9eQ0KQ09O
RklHX0ZSQU1FX1BPSU5URVI9eQ0KDQojDQojIFJDVSBEZWJ1Z2dpbmcNCiMN
CkNPTkZJR19TUEFSU0VfUkNVX1BPSU5URVI9eQ0KQ09ORklHX1JDVV9UT1JU
VVJFX1RFU1Q9eQ0KQ09ORklHX1JDVV9UT1JUVVJFX1RFU1RfUlVOTkFCTEU9
eQ0KQ09ORklHX1JDVV9DUFVfU1RBTExfVElNRU9VVD0yMQ0KQ09ORklHX1JD
VV9UUkFDRT15DQojIENPTkZJR19CQUNLVFJBQ0VfU0VMRl9URVNUIGlzIG5v
dCBzZXQNCkNPTkZJR19ERUJVR19GT1JDRV9XRUFLX1BFUl9DUFU9eQ0KIyBD
T05GSUdfTk9USUZJRVJfRVJST1JfSU5KRUNUSU9OIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0ZBVUxUX0lOSkVDVElPTiBpcyBub3Qgc2V0DQpDT05GSUdfQVJD
SF9IQVNfREVCVUdfU1RSSUNUX1VTRVJfQ09QWV9DSEVDS1M9eQ0KQ09ORklH
X0RFQlVHX1NUUklDVF9VU0VSX0NPUFlfQ0hFQ0tTPXkNCkNPTkZJR19ERUJV
R19QQUdFQUxMT0M9eQ0KQ09ORklHX1dBTlRfUEFHRV9ERUJVR19GTEFHUz15
DQpDT05GSUdfUEFHRV9HVUFSRD15DQpDT05GSUdfVVNFUl9TVEFDS1RSQUNF
X1NVUFBPUlQ9eQ0KQ09ORklHX05PUF9UUkFDRVI9eQ0KQ09ORklHX0hBVkVf
RlVOQ1RJT05fVFJBQ0VSPXkNCkNPTkZJR19IQVZFX0ZVTkNUSU9OX0dSQVBI
X1RSQUNFUj15DQpDT05GSUdfSEFWRV9GVU5DVElPTl9HUkFQSF9GUF9URVNU
PXkNCkNPTkZJR19IQVZFX0ZVTkNUSU9OX1RSQUNFX01DT1VOVF9URVNUPXkN
CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNFPXkNCkNPTkZJR19IQVZFX0RZ
TkFNSUNfRlRSQUNFX1dJVEhfUkVHUz15DQpDT05GSUdfSEFWRV9GVFJBQ0Vf
TUNPVU5UX1JFQ09SRD15DQpDT05GSUdfSEFWRV9TWVNDQUxMX1RSQUNFUE9J
TlRTPXkNCkNPTkZJR19IQVZFX0NfUkVDT1JETUNPVU5UPXkNCkNPTkZJR19U
UkFDRVJfTUFYX1RSQUNFPXkNCkNPTkZJR19UUkFDRV9DTE9DSz15DQpDT05G
SUdfUklOR19CVUZGRVI9eQ0KQ09ORklHX0VWRU5UX1RSQUNJTkc9eQ0KQ09O
RklHX0NPTlRFWFRfU1dJVENIX1RSQUNFUj15DQpDT05GSUdfUklOR19CVUZG
RVJfQUxMT1dfU1dBUD15DQpDT05GSUdfVFJBQ0lORz15DQpDT05GSUdfR0VO
RVJJQ19UUkFDRVI9eQ0KQ09ORklHX1RSQUNJTkdfU1VQUE9SVD15DQpDT05G
SUdfRlRSQUNFPXkNCiMgQ09ORklHX0ZVTkNUSU9OX1RSQUNFUiBpcyBub3Qg
c2V0DQojIENPTkZJR19JUlFTT0ZGX1RSQUNFUiBpcyBub3Qgc2V0DQpDT05G
SUdfU0NIRURfVFJBQ0VSPXkNCkNPTkZJR19GVFJBQ0VfU1lTQ0FMTFM9eQ0K
Q09ORklHX1RSQUNFUl9TTkFQU0hPVD15DQojIENPTkZJR19UUkFDRVJfU05B
UFNIT1RfUEVSX0NQVV9TV0FQIGlzIG5vdCBzZXQNCkNPTkZJR19CUkFOQ0hf
UFJPRklMRV9OT05FPXkNCiMgQ09ORklHX1BST0ZJTEVfQU5OT1RBVEVEX0JS
QU5DSEVTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1BST0ZJTEVfQUxMX0JSQU5D
SEVTIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NUQUNLX1RSQUNFUiBpcyBub3Qg
c2V0DQojIENPTkZJR19VUFJPQkVfRVZFTlQgaXMgbm90IHNldA0KIyBDT05G
SUdfUFJPQkVfRVZFTlRTIGlzIG5vdCBzZXQNCiMgQ09ORklHX0ZUUkFDRV9T
VEFSVFVQX1RFU1QgaXMgbm90IHNldA0KQ09ORklHX1JJTkdfQlVGRkVSX0JF
TkNITUFSSz1tDQpDT05GSUdfUklOR19CVUZGRVJfU1RBUlRVUF9URVNUPXkN
CkNPTkZJR19SQlRSRUVfVEVTVD1tDQpDT05GSUdfSU5URVJWQUxfVFJFRV9U
RVNUPW0NCiMgQ09ORklHX0JVSUxEX0RPQ1NSQyBpcyBub3Qgc2V0DQpDT05G
SUdfRE1BX0FQSV9ERUJVRz15DQojIENPTkZJR19BVE9NSUM2NF9TRUxGVEVT
VCBpcyBub3Qgc2V0DQojIENPTkZJR19TQU1QTEVTIGlzIG5vdCBzZXQNCkNP
TkZJR19IQVZFX0FSQ0hfS0dEQj15DQojIENPTkZJR19LR0RCIGlzIG5vdCBz
ZXQNCkNPTkZJR19IQVZFX0FSQ0hfS01FTUNIRUNLPXkNCkNPTkZJR19URVNU
X1NUUklOR19IRUxQRVJTPXkNCkNPTkZJR19URVNUX0tTVFJUT1g9bQ0KQ09O
RklHX1NUUklDVF9ERVZNRU09eQ0KQ09ORklHX1g4Nl9WRVJCT1NFX0JPT1RV
UD15DQpDT05GSUdfRUFSTFlfUFJJTlRLPXkNCkNPTkZJR19ERUJVR19TVEFD
S09WRVJGTE9XPXkNCkNPTkZJR19YODZfUFREVU1QPXkNCkNPTkZJR19ERUJV
R19ST0RBVEE9eQ0KIyBDT05GSUdfREVCVUdfUk9EQVRBX1RFU1QgaXMgbm90
IHNldA0KQ09ORklHX0RFQlVHX1NFVF9NT0RVTEVfUk9OWD15DQpDT05GSUdf
REVCVUdfTlhfVEVTVD1tDQpDT05GSUdfRE9VQkxFRkFVTFQ9eQ0KIyBDT05G
SUdfREVCVUdfVExCRkxVU0ggaXMgbm90IHNldA0KQ09ORklHX0lPTU1VX1NU
UkVTUz15DQpDT05GSUdfSEFWRV9NTUlPVFJBQ0VfU1VQUE9SVD15DQpDT05G
SUdfSU9fREVMQVlfVFlQRV8wWDgwPTANCkNPTkZJR19JT19ERUxBWV9UWVBF
XzBYRUQ9MQ0KQ09ORklHX0lPX0RFTEFZX1RZUEVfVURFTEFZPTINCkNPTkZJ
R19JT19ERUxBWV9UWVBFX05PTkU9Mw0KIyBDT05GSUdfSU9fREVMQVlfMFg4
MCBpcyBub3Qgc2V0DQojIENPTkZJR19JT19ERUxBWV8wWEVEIGlzIG5vdCBz
ZXQNCkNPTkZJR19JT19ERUxBWV9VREVMQVk9eQ0KIyBDT05GSUdfSU9fREVM
QVlfTk9ORSBpcyBub3Qgc2V0DQpDT05GSUdfREVGQVVMVF9JT19ERUxBWV9U
WVBFPTINCiMgQ09ORklHX0RFQlVHX0JPT1RfUEFSQU1TIGlzIG5vdCBzZXQN
CiMgQ09ORklHX0NQQV9ERUJVRyBpcyBub3Qgc2V0DQpDT05GSUdfT1BUSU1J
WkVfSU5MSU5JTkc9eQ0KQ09ORklHX0RFQlVHX05NSV9TRUxGVEVTVD15DQoN
CiMNCiMgU2VjdXJpdHkgb3B0aW9ucw0KIw0KQ09ORklHX0tFWVM9eQ0KQ09O
RklHX0VOQ1JZUFRFRF9LRVlTPXkNCiMgQ09ORklHX0tFWVNfREVCVUdfUFJP
Q19LRVlTIGlzIG5vdCBzZXQNCkNPTkZJR19TRUNVUklUWV9ETUVTR19SRVNU
UklDVD15DQpDT05GSUdfU0VDVVJJVFk9eQ0KQ09ORklHX1NFQ1VSSVRZRlM9
eQ0KQ09ORklHX1NFQ1VSSVRZX05FVFdPUks9eQ0KIyBDT05GSUdfU0VDVVJJ
VFlfTkVUV09SS19YRlJNIGlzIG5vdCBzZXQNCkNPTkZJR19TRUNVUklUWV9Q
QVRIPXkNCkNPTkZJR19MU01fTU1BUF9NSU5fQUREUj02NTUzNg0KQ09ORklH
X1NFQ1VSSVRZX1NFTElOVVg9eQ0KIyBDT05GSUdfU0VDVVJJVFlfU0VMSU5V
WF9CT09UUEFSQU0gaXMgbm90IHNldA0KIyBDT05GSUdfU0VDVVJJVFlfU0VM
SU5VWF9ESVNBQkxFIGlzIG5vdCBzZXQNCkNPTkZJR19TRUNVUklUWV9TRUxJ
TlVYX0RFVkVMT1A9eQ0KQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfQVZDX1NU
QVRTPXkNCkNPTkZJR19TRUNVUklUWV9TRUxJTlVYX0NIRUNLUkVRUFJPVF9W
QUxVRT0xDQojIENPTkZJR19TRUNVUklUWV9TRUxJTlVYX1BPTElDWURCX1ZF
UlNJT05fTUFYIGlzIG5vdCBzZXQNCiMgQ09ORklHX1NFQ1VSSVRZX1NNQUNL
IGlzIG5vdCBzZXQNCkNPTkZJR19TRUNVUklUWV9UT01PWU89eQ0KQ09ORklH
X1NFQ1VSSVRZX1RPTU9ZT19NQVhfQUNDRVBUX0VOVFJZPTIwNDgNCkNPTkZJ
R19TRUNVUklUWV9UT01PWU9fTUFYX0FVRElUX0xPRz0xMDI0DQpDT05GSUdf
U0VDVVJJVFlfVE9NT1lPX09NSVRfVVNFUlNQQUNFX0xPQURFUj15DQojIENP
TkZJR19TRUNVUklUWV9BUFBBUk1PUiBpcyBub3Qgc2V0DQojIENPTkZJR19T
RUNVUklUWV9ZQU1BIGlzIG5vdCBzZXQNCkNPTkZJR19JTlRFR1JJVFk9eQ0K
Q09ORklHX0lOVEVHUklUWV9TSUdOQVRVUkU9eQ0KIyBDT05GSUdfSU5URUdS
SVRZX0FTWU1NRVRSSUNfS0VZUyBpcyBub3Qgc2V0DQojIENPTkZJR19JTUEg
aXMgbm90IHNldA0KQ09ORklHX0VWTT15DQpDT05GSUdfRVZNX0hNQUNfVkVS
U0lPTj0yDQojIENPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX1NFTElOVVggaXMg
bm90IHNldA0KQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfVE9NT1lPPXkNCiMg
Q09ORklHX0RFRkFVTFRfU0VDVVJJVFlfREFDIGlzIG5vdCBzZXQNCkNPTkZJ
R19ERUZBVUxUX1NFQ1VSSVRZPSJ0b21veW8iDQpDT05GSUdfQ1JZUFRPPXkN
Cg0KIw0KIyBDcnlwdG8gY29yZSBvciBoZWxwZXINCiMNCkNPTkZJR19DUllQ
VE9fQUxHQVBJPXkNCkNPTkZJR19DUllQVE9fQUxHQVBJMj15DQpDT05GSUdf
Q1JZUFRPX0FFQUQ9eQ0KQ09ORklHX0NSWVBUT19BRUFEMj15DQpDT05GSUdf
Q1JZUFRPX0JMS0NJUEhFUj15DQpDT05GSUdfQ1JZUFRPX0JMS0NJUEhFUjI9
eQ0KQ09ORklHX0NSWVBUT19IQVNIPXkNCkNPTkZJR19DUllQVE9fSEFTSDI9
eQ0KQ09ORklHX0NSWVBUT19STkc9eQ0KQ09ORklHX0NSWVBUT19STkcyPXkN
CkNPTkZJR19DUllQVE9fUENPTVAyPXkNCkNPTkZJR19DUllQVE9fTUFOQUdF
Uj15DQpDT05GSUdfQ1JZUFRPX01BTkFHRVIyPXkNCkNPTkZJR19DUllQVE9f
VVNFUj1tDQpDT05GSUdfQ1JZUFRPX01BTkFHRVJfRElTQUJMRV9URVNUUz15
DQpDT05GSUdfQ1JZUFRPX0dGMTI4TVVMPXkNCkNPTkZJR19DUllQVE9fTlVM
TD15DQpDT05GSUdfQ1JZUFRPX1dPUktRVUVVRT15DQpDT05GSUdfQ1JZUFRP
X0NSWVBURD15DQpDT05GSUdfQ1JZUFRPX0FVVEhFTkM9eQ0KIyBDT05GSUdf
Q1JZUFRPX1RFU1QgaXMgbm90IHNldA0KQ09ORklHX0NSWVBUT19BQkxLX0hF
TFBFUl9YODY9eQ0KDQojDQojIEF1dGhlbnRpY2F0ZWQgRW5jcnlwdGlvbiB3
aXRoIEFzc29jaWF0ZWQgRGF0YQ0KIw0KQ09ORklHX0NSWVBUT19DQ009bQ0K
Q09ORklHX0NSWVBUT19HQ009bQ0KQ09ORklHX0NSWVBUT19TRVFJVj15DQoN
CiMNCiMgQmxvY2sgbW9kZXMNCiMNCkNPTkZJR19DUllQVE9fQ0JDPXkNCkNP
TkZJR19DUllQVE9fQ1RSPW0NCkNPTkZJR19DUllQVE9fQ1RTPXkNCkNPTkZJ
R19DUllQVE9fRUNCPXkNCkNPTkZJR19DUllQVE9fTFJXPXkNCkNPTkZJR19D
UllQVE9fUENCQz15DQpDT05GSUdfQ1JZUFRPX1hUUz15DQoNCiMNCiMgSGFz
aCBtb2Rlcw0KIw0KIyBDT05GSUdfQ1JZUFRPX0NNQUMgaXMgbm90IHNldA0K
Q09ORklHX0NSWVBUT19ITUFDPXkNCiMgQ09ORklHX0NSWVBUT19YQ0JDIGlz
IG5vdCBzZXQNCkNPTkZJR19DUllQVE9fVk1BQz15DQoNCiMNCiMgRGlnZXN0
DQojDQpDT05GSUdfQ1JZUFRPX0NSQzMyQz15DQpDT05GSUdfQ1JZUFRPX0NS
QzMyQ19JTlRFTD15DQpDT05GSUdfQ1JZUFRPX0NSQzMyPW0NCiMgQ09ORklH
X0NSWVBUT19DUkMzMl9QQ0xNVUwgaXMgbm90IHNldA0KQ09ORklHX0NSWVBU
T19DUkNUMTBESUY9eQ0KQ09ORklHX0NSWVBUT19HSEFTSD15DQpDT05GSUdf
Q1JZUFRPX01END1tDQpDT05GSUdfQ1JZUFRPX01ENT15DQpDT05GSUdfQ1JZ
UFRPX01JQ0hBRUxfTUlDPW0NCiMgQ09ORklHX0NSWVBUT19STUQxMjggaXMg
bm90IHNldA0KQ09ORklHX0NSWVBUT19STUQxNjA9bQ0KIyBDT05GSUdfQ1JZ
UFRPX1JNRDI1NiBpcyBub3Qgc2V0DQpDT05GSUdfQ1JZUFRPX1JNRDMyMD1t
DQpDT05GSUdfQ1JZUFRPX1NIQTE9eQ0KQ09ORklHX0NSWVBUT19TSEEyNTY9
eQ0KQ09ORklHX0NSWVBUT19TSEE1MTI9eQ0KQ09ORklHX0NSWVBUT19UR1Ix
OTI9eQ0KIyBDT05GSUdfQ1JZUFRPX1dQNTEyIGlzIG5vdCBzZXQNCg0KIw0K
IyBDaXBoZXJzDQojDQpDT05GSUdfQ1JZUFRPX0FFUz15DQpDT05GSUdfQ1JZ
UFRPX0FFU181ODY9eQ0KQ09ORklHX0NSWVBUT19BRVNfTklfSU5URUw9eQ0K
Q09ORklHX0NSWVBUT19BTlVCSVM9bQ0KQ09ORklHX0NSWVBUT19BUkM0PXkN
CkNPTkZJR19DUllQVE9fQkxPV0ZJU0g9eQ0KQ09ORklHX0NSWVBUT19CTE9X
RklTSF9DT01NT049eQ0KIyBDT05GSUdfQ1JZUFRPX0NBTUVMTElBIGlzIG5v
dCBzZXQNCiMgQ09ORklHX0NSWVBUT19DQVNUNSBpcyBub3Qgc2V0DQojIENP
TkZJR19DUllQVE9fQ0FTVDYgaXMgbm90IHNldA0KQ09ORklHX0NSWVBUT19E
RVM9eQ0KQ09ORklHX0NSWVBUT19GQ1JZUFQ9eQ0KIyBDT05GSUdfQ1JZUFRP
X0tIQVpBRCBpcyBub3Qgc2V0DQpDT05GSUdfQ1JZUFRPX1NBTFNBMjA9eQ0K
Q09ORklHX0NSWVBUT19TQUxTQTIwXzU4Nj15DQojIENPTkZJR19DUllQVE9f
U0VFRCBpcyBub3Qgc2V0DQojIENPTkZJR19DUllQVE9fU0VSUEVOVCBpcyBu
b3Qgc2V0DQojIENPTkZJR19DUllQVE9fU0VSUEVOVF9TU0UyXzU4NiBpcyBu
b3Qgc2V0DQpDT05GSUdfQ1JZUFRPX1RFQT1tDQpDT05GSUdfQ1JZUFRPX1RX
T0ZJU0g9bQ0KQ09ORklHX0NSWVBUT19UV09GSVNIX0NPTU1PTj15DQpDT05G
SUdfQ1JZUFRPX1RXT0ZJU0hfNTg2PXkNCg0KIw0KIyBDb21wcmVzc2lvbg0K
Iw0KQ09ORklHX0NSWVBUT19ERUZMQVRFPXkNCiMgQ09ORklHX0NSWVBUT19a
TElCIGlzIG5vdCBzZXQNCkNPTkZJR19DUllQVE9fTFpPPXkNCkNPTkZJR19D
UllQVE9fTFo0PW0NCkNPTkZJR19DUllQVE9fTFo0SEM9eQ0KDQojDQojIFJh
bmRvbSBOdW1iZXIgR2VuZXJhdGlvbg0KIw0KQ09ORklHX0NSWVBUT19BTlNJ
X0NQUk5HPW0NCkNPTkZJR19DUllQVE9fVVNFUl9BUEk9eQ0KQ09ORklHX0NS
WVBUT19VU0VSX0FQSV9IQVNIPW0NCkNPTkZJR19DUllQVE9fVVNFUl9BUElf
U0tDSVBIRVI9eQ0KIyBDT05GSUdfQ1JZUFRPX0hXIGlzIG5vdCBzZXQNCiMg
Q09ORklHX0FTWU1NRVRSSUNfS0VZX1RZUEUgaXMgbm90IHNldA0KQ09ORklH
X0hBVkVfS1ZNPXkNCkNPTkZJR19WSVJUVUFMSVpBVElPTj15DQojIENPTkZJ
R19MR1VFU1QgaXMgbm90IHNldA0KQ09ORklHX0JJTkFSWV9QUklOVEY9eQ0K
DQojDQojIExpYnJhcnkgcm91dGluZXMNCiMNCkNPTkZJR19CSVRSRVZFUlNF
PXkNCkNPTkZJR19HRU5FUklDX1NUUk5DUFlfRlJPTV9VU0VSPXkNCkNPTkZJ
R19HRU5FUklDX1NUUk5MRU5fVVNFUj15DQpDT05GSUdfR0VORVJJQ19GSU5E
X0ZJUlNUX0JJVD15DQpDT05GSUdfR0VORVJJQ19QQ0lfSU9NQVA9eQ0KQ09O
RklHX0dFTkVSSUNfSU9NQVA9eQ0KQ09ORklHX0dFTkVSSUNfSU89eQ0KQ09O
RklHX0NSQ19DQ0lUVD15DQpDT05GSUdfQ1JDMTY9eQ0KQ09ORklHX0NSQ19U
MTBESUY9eQ0KIyBDT05GSUdfQ1JDX0lUVV9UIGlzIG5vdCBzZXQNCkNPTkZJ
R19DUkMzMj15DQpDT05GSUdfQ1JDMzJfU0VMRlRFU1Q9eQ0KQ09ORklHX0NS
QzMyX1NMSUNFQlk4PXkNCiMgQ09ORklHX0NSQzMyX1NMSUNFQlk0IGlzIG5v
dCBzZXQNCiMgQ09ORklHX0NSQzMyX1NBUldBVEUgaXMgbm90IHNldA0KIyBD
T05GSUdfQ1JDMzJfQklUIGlzIG5vdCBzZXQNCkNPTkZJR19DUkM3PW0NCkNP
TkZJR19MSUJDUkMzMkM9eQ0KQ09ORklHX0NSQzg9bQ0KQ09ORklHX0FVRElU
X0dFTkVSSUM9eQ0KQ09ORklHX1pMSUJfSU5GTEFURT15DQpDT05GSUdfWkxJ
Ql9ERUZMQVRFPXkNCkNPTkZJR19MWk9fQ09NUFJFU1M9eQ0KQ09ORklHX0xa
T19ERUNPTVBSRVNTPXkNCkNPTkZJR19MWjRfQ09NUFJFU1M9bQ0KQ09ORklH
X0xaNEhDX0NPTVBSRVNTPXkNCkNPTkZJR19MWjRfREVDT01QUkVTUz15DQpD
T05GSUdfWFpfREVDPW0NCiMgQ09ORklHX1haX0RFQ19YODYgaXMgbm90IHNl
dA0KQ09ORklHX1haX0RFQ19QT1dFUlBDPXkNCkNPTkZJR19YWl9ERUNfSUE2
ND15DQojIENPTkZJR19YWl9ERUNfQVJNIGlzIG5vdCBzZXQNCkNPTkZJR19Y
Wl9ERUNfQVJNVEhVTUI9eQ0KQ09ORklHX1haX0RFQ19TUEFSQz15DQpDT05G
SUdfWFpfREVDX0JDSj15DQpDT05GSUdfWFpfREVDX1RFU1Q9bQ0KQ09ORklH
X0dFTkVSSUNfQUxMT0NBVE9SPXkNCkNPTkZJR19SRUVEX1NPTE9NT049bQ0K
Q09ORklHX1JFRURfU09MT01PTl9FTkM4PXkNCkNPTkZJR19SRUVEX1NPTE9N
T05fREVDOD15DQpDT05GSUdfUkVFRF9TT0xPTU9OX0RFQzE2PXkNCkNPTkZJ
R19CQ0g9bQ0KQ09ORklHX0JDSF9DT05TVF9QQVJBTVM9eQ0KQ09ORklHX0JU
UkVFPXkNCkNPTkZJR19IQVNfSU9NRU09eQ0KQ09ORklHX0hBU19JT1BPUlQ9
eQ0KQ09ORklHX0hBU19ETUE9eQ0KQ09ORklHX0NIRUNLX1NJR05BVFVSRT15
DQpDT05GSUdfRFFMPXkNCkNPTkZJR19OTEFUVFI9eQ0KQ09ORklHX0FSQ0hf
SEFTX0FUT01JQzY0X0RFQ19JRl9QT1NJVElWRT15DQojIENPTkZJR19BVkVS
QUdFIGlzIG5vdCBzZXQNCkNPTkZJR19DTFpfVEFCPXkNCiMgQ09ORklHX0NP
UkRJQyBpcyBub3Qgc2V0DQojIENPTkZJR19ERFIgaXMgbm90IHNldA0KQ09O
RklHX01QSUxJQj15DQpDT05GSUdfU0lHTkFUVVJFPXkNCg==

--8323328-410157428-1369047873=:26558--
