Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaGLW0X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 18:26:23 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34040 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaGLW0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 18:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140711171844.39fcbb50@canb.auug.org.au>
References: <20140711171844.39fcbb50@canb.auug.org.au>
Date: Sat, 12 Jul 2014 18:26:17 -0400
Message-ID: <CAPDOMVgi8Cw8z_i7bTEXQSRWbOiu7kQSpAnnDkyWCkr=yf7xsQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 11
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 3:18 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20140710:
>
> My fixes tree contains:
>         powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64
>
> The tty.current tree gained a build failure so I used the version from
> next-20140710.
>
> The irqchip tree gained a conflict against the arm64 tree.
>
> The staging tree lost its build failure and gained a conflict against
> the tty tree.
>
> Non-merge commits (relative to Linus' tree): 5114
>  4474 files changed, 191199 insertions(+), 226003 deletions(-)
>
> ----------------------------------------------------------------------------
>
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> (patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" and checkout or reset to the new
> master.
>
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
> multi_v7_defconfig for arm. After the final fixups (if any), it is also
> built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
> allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
> defconfig.
>
> Below is a summary of the state of the merge.
>
> I am currently merging 222 trees (counting Linus' and 30 trees of patches
> pending for Linus' tree).
>
> Stats about the size of the tree over time can be seen at
> http://neuling.org/linux-next-size.html .
>
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.
>
> Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
> Gortmaker for triage and bug fixes.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> $ git checkout master
> $ git reset --hard stable
> Merging origin/master (4c71842375f5 Merge branch 'for-3.16-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata)
> Merging fixes/master (b8accbbce667 powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64)
> Merging kbuild-current/rc-fixes (dd5a6752ae7d firmware: Create directories for external firmware)
> Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
> Merging arm-current/fixes (9a2c33a422d6 ARM: l2c: fix revision checking)
> Merging m68k-current/for-linus (f1a1b6352998 m68k: Fix boot regression on machines with RAM at non-zero)
> Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
> Merging powerpc-merge/merge (6663a4fa6711 powerpc: Don't skip ePAPR spin-table CPUs)
> Merging sparc/master (894e552cfaa3 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
> Merging net/master (f6864c6f3513 Merge branch 'for-davem' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
> Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
> Merging sound-current/for-linus (91947d8cc553 ALSA: hda - Add new GPU codec ID 0x10de0070 to snd-hda)
> Merging pci-current/for-linus (bf177a1eb6d1 MAINTAINERS: Update mx6 PCI driver maintainer's email)
> Merging wireless/master (2c4db12ec469 rt2800usb: Don't perform DMA from stack)
> Merging driver-core.current/driver-core-linus (cd3de83f1476 Linux 3.16-rc4)
> Merging tty.current/tty-linus (99ecb001f52e serial: arc_uart: Use uart_circ_empty() for open-coded comparison)
> $ git reset --hard HEAD^
> Merging next-20140710 version of tty.current
> Merging usb.current/usb-linus (5a7fbe7e9ea0 USB: ftdi_sio: Add extra PID.)
> Merging usb-gadget-fixes/fixes (8035691365b8 usb: musb: dsps: fix the base address for accessing the mode register)
> Merging usb-serial-fixes/usb-linus (3d28bd840b2d usb: option: Add ID for Telewell TW-LTE 4G v2)
> Merging staging.current/staging-linus (bdac8ca90e07 Merge tag 'iio-fixes-for-3.16c' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus)
> Merging char-misc.current/char-misc-linus (6d827fbcc370 i8k: Fix non-SMP operation)
> Merging input-current/for-linus (31972f6e517d Input: ti_am335x_tsc - warn about incorrect spelling)
> Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" stripe)
> Merging crypto-current/master (0378c9a855bf crypto: caam - fix memleak in caam_jr module)
> Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
> Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
> Merging devicetree-current/devicetree/merge (356facff5275 of/platform: Fix of_platform_device_destroy iteration of devices)
> Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting module removal.)
> Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts before cancelling delayed works)
> Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into for-linus)
> Merging drm-intel-fixes/for-linux-next-fixes (92ae62076957 Revert "drm/i915: Don't set the 8to6 dither flag when not scaling")
> Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for nommu)
> Merging arc/for-next (4c834452aad0 Linux 3.16-rc3)
> Merging arm/for-next (f6340c16dabd Merge branches 'fixes' and 'misc' into for-next)
> Merging arm-perf/for-next/perf (4b2974fa6a4a ARM: perf: disable the pagefault handler when reading from user space)
> CONFLICT (content): Merge conflict in arch/arm/kernel/perf_event_cpu.c
> Merging arm-soc/for-next (9dd436a6410c Merge branch 'fixes' into for-next)
> Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
> Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into berlin/for-next)
> Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend support)
> Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' into ep93xx-for-next)
> Merging imx-mxs/for-next (3a426a906aac Merge branch 'imx/dt' into for-next)
> Merging ixp4xx/next (19f949f52599 Linux 3.8)
> Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
> Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix)
> Merging mvebu/for-next (0e8c4a5c6ef3 Merge branch 'mvebu/fixes' into mvebu/for-next)
> CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
> Merging renesas/next (f637615fba7f Merge branch 'heads/shdma-for-v3.17' into next)
> CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/headsmp.S
> Merging samsung/for-next (1858942aece6 Merge branch 'v3.17-next/mach-exynos' into for-next)
> Merging sunxi/sunxi/for-next (a2aa371b1d53 Merge branches 'sunxi/dt-for-3.17' and 'sunxi/clocks-for-3.17' into sunxi/for-next)
> Merging tegra/for-next (545617fb69e4 Merge branch for-3.17/defconfig into for-next)
> Merging arm64/for-next/core (da57a369d3bc arm64: Enable TEXT_OFFSET fuzzing)
> Merging blackfin/for-linus (51fdc6bf9880 blackfin: defconfigs: add MTD_SPI_NOR (new dependency for M25P80))
> Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by cache.h)
> Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
> Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
> Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress using big_oops_buf)
> Merging m68k/for-next (f4ea0a48c63e m68k/sun3: Remove define statement no longer needed)
> Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prototype for kobjsize())
> Merging metag/for-next (8bc613befaec metag: hugetlbpage: Remove null pointer checks that could never happen)
> Merging microblaze/next (08e6bbda0b48 microblaze: Wire-up renameat2 syscall)
> Merging mips/mips-for-linux-next (de3d02f3906d Merge branch '3.16-fixes' into mips-for-linux-next)
> Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() signal_setup_done())
> Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs parameter from do_execve() in hpux_execve())
> Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
> Merging powerpc/next (68986c9f0f45 Revert "offb: Add palette hack for little endian")
> Merging fsl/next (cd1154770ba9 powerpc/85xx: drop hypervisor specific board compatibles)
> Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock specs)
> Merging s390/features (c60d0baa40f9 s390/3270: correct size detection with the read-partition command)
> Merging sparc-next/master (894e552cfaa3 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
> Merging tile/master (ed93567c6fbc tile: Remove tile-specific _sinitdata and _einitdata)
> Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
> CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
> Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFREQ config option)
> Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_TTY)
> Merging btrfs/next (c7548af69d9e Btrfs: convert smp_mb__{before,after}_clear_bit)
> Merging ceph/master (437f2c0d0c01 rbd: fix ida/idr memory leak)
> Merging cifs/for-next (4b26c7b1fc36 cifs: Split lanman auth from CIFS_SessSetup())
> Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
> Merging ecryptfs/next (27199b15e4f0 ecryptfs: Remove unnecessary include of syscall.h in keystore.c)
> Merging ext3/for_next (19ef1229bc2e reiserfs: Fix compilation breakage with CONFIG_REISERFS_CHECK)
> Merging ext4/dev (14b02deff1ae [regression] fix 32-bit breakage in block device read(2))
> Merging f2fs/dev (81e366f87f52 f2fs: check name_len of dir entry to prevent from deadloop)
> Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded object to the fscache_object_list rb tree)
> Merging fuse/for-next (4237ba43b65a fuse: restructure ->rename2())
> Merging gfs2/master (c04d5ee35ba6 GFS2: fs/gfs2/rgrp.c: kernel-doc warning fixes)
> Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to kstr)
> Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free segment found)
> Merging nfs/linux-next (4bd9d3a90cb3 Merge branch 'bugfixes' into testing)
> Merging nfsd/nfsd-next (d6c249b4d4cf nfsd: reduce some spinlocking in put_client_renew)
> CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
> Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
> Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages on decompress error)
> Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_set)
> Merging ubifs/linux-next (e9110361a9a4 UBI: fix the volumes tree sorting criteria)
> Merging xfs/for-next (2451337dd043 xfs: global error sign conversion)
> Merging file-private-locks/linux-next (a497c3ba1d97 Linux 3.16-rc2)
> Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing maximal number of pages)
> Merging pci/next (1d0df48692af Merge branches 'pci/host-rcar', 'pci/hotplug', 'pci/iommu', 'pci/misc' and 'pci/msi' into next)
> Merging hid/for-next (1d259fbdd1dc Merge branch 'for-3.17/cp2112' into for-next)
> Merging i2c/i2c/for-next (2fd6cf0523fc i2c: taos-evm: Use module_serio_driver())
> Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
> Merging hwmon-staging/hwmon-next (0b06e14a229c hwmon: (pmbus) Add tps40422 front-end driver)
> Merging v4l-dvb/master (ac35b35b30aa Merge branch 'patchwork' into to_next)
> Merging kbuild/for-next (6296fcc8a669 Merge branch 'kbuild/kbuild' into kbuild/for-next)
> Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends by default settings)
> Merging libata/for-next (c4666b089d2b Merge branch 'for-3.16-fixes' into for-next)
> Merging pm/linux-next (eb5085c917bc Merge branch 'pm-apm' into linux-next)
> Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle' into release)
> Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
> Merging cpupowerutils/master (f16603386b38 cpupower tools: add install target to the debug tools' makefiles)
> Merging thermal/next (b6902baa1fab Merge branch 'for-rc' of .git into next)
> Merging ieee1394/for-next (165d560bb267 Merge branch 'master' into for-next)
> Merging dlm/next (883854c5457a dlm: keep listening connection alive with sctp mode)
> Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is invalid)
> Merging slave-dma/next (d1a792f3b407 Update imx-sdma cyclic handling to report residue)
> Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_cleanup() to mv_xor_slot_cleanup())
> Merging net-next/master (5e6438db34d5 Merge branch 'mvebu')
> Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
> Merging wireless-next/master (ca424b202241 Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next)
> Merging bluetooth/master (12aa4f0a3d05 Bluetooth: Set HCI_PAIRABLE during power on for legacy ioctl)
> Merging infiniband/for-next (eeaddf3670d4 Merge branches 'core', 'cxgb3', 'cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 'srp' and 'usnic' into for-next)
> Merging mtd/master (6938ad40cb97 mtd: devices: elm: fix elm_context_save() and elm_context_restore() functions)
> Merging l2-mtd/master (fdf43a420f5c mtd: Account for BBT blocks when a partition is being allocated)
> Merging crypto/master (96956aef2ff5 crypto: drbg - drbg_exit() can be static)
> Merging drm/drm-next (62eb3e20f8f3 drm/tilcdc: Fix build breakage)
> CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
> Merging drm-panel/drm/panel/for-next (7e40b5162b3c drm/panel: make DRM_PANEL_LD9040 depend on SPI)
> Merging drm-intel/for-linux-next (7b3c29f6fd37 drm/i915: Make the RPS interrupt generation mask handle the vlv wa)
> Merging drm-tegra/drm/tegra/for-next (1f64ae7c5af0 drm/tegra: sor - Remove obsolete comment)
> Merging sound/for-next (50dd9050e45c ALSA: hda - add capture mute led support in led_power_filter)
> Merging sound-asoc/for-next (eec04ea0c231 Merge remote-tracking branches 'asoc/topic/tlv320aic3x', 'asoc/topic/wm0010', 'asoc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-next)
> Merging modules/modules-next (4982223e51e8 module: set nx before marking module MODULE_STATE_COMING.)
> Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_add_sgs(... GFP_NOIO) holding spinlock.)
> Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return from mxt_get_bootloader_version)
> Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
> Merging block/for-next (b0adcfe80363 Merge branch 'for-3.17/drivers' into for-next)
> Merging device-mapper/for-next (e7be4af4f2d2 dm crypt: sort writes)
> Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator precedence)
> Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware(), v3)
> Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usage)
> Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and remove the card_tasklet)
> Merging mmc-uh/next (f25c33724d15 mmc: sdhci: add DDR50 1.8V mode support for BayTrail eMMC Controller)
> Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
> Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
> Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
> Merging md/for-next (133d4527eab8 md: flush writes before starting a recovery.)
> Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.linaro.org/people/ljones/mfd)
> Merging mfd-lj/for-mfd-next (53a1cf27c450 mfd: cros_ec: Use the proper size when looking at the cros_ec_i2c result)
> Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dereference when there is no platform_data)
> Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
> Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup in set_par)
> Merging omap_dss2/for-next (b1f46dd1079d video: clps711x: Fix sparse warnings)
> Merging regulator/for-next (3012b47d28f1 Merge remote-tracking branches 'regulator/topic/tps65217', 'regulator/topic/tps65218', 'regulator/topic/tps6586x' and 'regulator/topic/twl' into regulator-next)
> Merging security/next (f01387d26938 Merge commit 'v3.15' into next)
> Merging integrity/next (a0f9fd9d6d8a ima: define '.ima' as a builtin 'trusted' keyring)
> Merging selinux/next (615e51fdda6f selinux: reduce the number of calls to synchronize_net() when flushing caches)
> Merging lblnet/next (d8ec26d7f828 Linux 3.13)
> Merging watchdog/master (7171511eaec5 Linux 3.16-rc1)
> Merging iommu/next (7ee9bd3a4990 Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/amd', 'arm/omap', 'ppc/pamu' and 'core' into next)
> Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
> Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt count)
> Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
> Merging jc_docs/docs-next (5c050fb96380 docs: update the development process document)
> Merging trivial/for-next (d31e373d0778 irq-gic: remove file name from heading comment)
> CONFLICT (content): Merge conflict in arch/arm/mach-msm/Kconfig
> Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_syscall_entry() interface)
> CONFLICT (content): Merge conflict in kernel/audit.c
> CONFLICT (content): Merge conflict in arch/x86/Kconfig
> CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
> CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
> Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart syscalls)
> Merging devicetree/devicetree/next (c9e0fb3bb3aa tty: Update hypervisor tty drivers to use core stdout parsing code.)
> Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumption that of_allnodes is root)
> Merging spi/for-next (fac810e1487c Merge remote-tracking branches 'spi/topic/rspi', 'spi/topic/sh' and 'spi/topic/sh-msiof' into spi-next)
> Merging tip/auto-latest (ae072dca7a35 Merge branch 'locking/core')
> Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freescale FlexTimer Module (FTM) timer support)
> Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell based systems)
> Merging edac-amd/for-next (791b470684c1 MAINTAINERS: add ie31200_edac entry)
> Merging irqchip/irqchip/for-next (ecdad51eb008 Merge branch 'irqchip/urgent' into irqchip/for-next)
> CONFLICT (content): Merge conflict in arch/arm64/Kconfig
> Merging ftrace/for-next (d048a8c7b509 tracing: Add description of set_graph_notrace to tracing/README)
> Merging rcu/rcu/next (af72a9957a82 rcu: Uninline rcu_read_lock_held())
> Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and singlestep exceptions)
> Merging kvm/linux-next (9f6226a762c7 arch: x86: kvm: x86.c: Cleaning up variable is set more than once)
> Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support for Cortex-A53)
> Merging kvm-ppc/kvm-ppc-next (c387936a9386 KVM: PPC: Book3S: Move vcore definition to end of kvm_arch struct)
> Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
> Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_work)
> Merging xen-tip/linux-next (77945ca73e9a x86/xen: map foreign pfns for autotranslated guests)
> Merging percpu/for-next (a46e532a9145 Merge branch 'for-3.16-fixes' into for-next)
> Merging workqueues/for-next (51cb2603aed0 Merge branch 'for-3.16-fixes' into for-next)
> CONFLICT (content): Merge conflict in kernel/workqueue.c
> Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some systems)
> Merging chrome-platform/for-next (d1c1437062db platform/chrome: pstore: fix dmi table to match all chrome systems)
> Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that may go away)
> Merging regmap/for-next (cd3de83f1476 Linux 3.16-rc4)
> Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module refcounting)
> Merging leds/for-next (7e7743901b53 leds:pca963x: Update for PCA9635 and correct statement about MODE2 OUTDRV default)
> CONFLICT (add/add): Merge conflict in drivers/hid/hid-gt683r.c
> Merging driver-core/driver-core-next (b23b35445ec8 Documentation: devres: Add devm_kmalloc() et al)
> Merging tty/tty-next (68252424a7c7 tty: serial: msm: Support big-endian CPUs)
> Merging usb/usb-next (0e278b340899 fotg210: Use managed interfaces for allocation of resources)
> Merging usb-gadget/next (527b570c8427 usb: gadget: s3c2410: Move to clk_prepare_enable/clk_disable_unprepare)
> CONFLICT (content): Merge conflict in drivers/usb/musb/musb_cppi41.c
> Merging usb-serial/usb-next (5bc9e5933a41 USB: kl5kusb105: Remove klsi_105_tiocmset function)
> Merging staging/staging-next (4f31668f6169 staging: vt6656: rename s_vFillCTSHead to vnt_fill_cts_head)
> CONFLICT (modify/delete): drivers/staging/dgrp/dgrp_tty.c deleted in staging/staging-next and modified in HEAD. Version HEAD of drivers/staging/dgrp/dgrp_tty.c left in tree.
> $ git rm -f drivers/staging/dgrp/dgrp_tty.c
> Merging char-misc/char-misc-next (1db121d65841 MAINTAINERS: Add thunderbolt driver)
> CONFLICT (content): Merge conflict in drivers/w1/masters/mxc_w1.c
> Merging cgroup/for-next (52c5b223e4d5 Merge branch 'for-3.17' into for-next)
> Merging scsi/for-next (eed78c36555c Merge remote-tracking branch 'scsi-queue/core-for-3.17' into for-next)
> CONFLICT (content): Merge conflict in include/scsi/sg.h
> Merging scsi-core/core-for-3.16 (7bafc240e126 scsi: use the scsi data buffer length to extract transfer size)
> Merging scsi-drivers/drivers-for-3.16 (8faeb529b2da virtio-scsi: fix various bad behavior on aborted requests)
> Merging target-updates/for-next (a497c3ba1d97 Linux 3.16-rc2)
> Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
> Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corruption on NFS)
> Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS entries)
> Merging pinctrl/for-next (6af796862531 Merge branch 'devel' into for-next)
> Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
> CONFLICT (content): Merge conflict in drivers/vhost/net.c
> Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize local symbols)
> Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VIRTIO)
> Merging gpio/for-next (b45d1c62672f Merge branch 'devel' into for-next)
> Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock target)
> Merging pwm/for-next (39fd3f99aba3 pwm: fsl-ftm: set pwm_chip can_sleep flag)
> Merging dma-buf/for-next (b23b35445ec8 Documentation: devres: Add devm_kmalloc() et al)
> Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of BSD accounting files)
> CONFLICT (content): Merge conflict in fs/namespace.c
> CONFLICT (content): Merge conflict in fs/namei.c
> CONFLICT (content): Merge conflict in fs/dcache.c
> CONFLICT (content): Merge conflict in fs/btrfs/ioctl.c
> Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_bisect)
> Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
> Merging clk/clk-next (cdae1730d0c6 Merge branch 'clk-fixes' into clk-next)
> Merging random/dev (5458c2fecbb8 hw_random: fix sparse warning (NULL vs 0 for pointer))
> Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression speedup on ARM by using unaligned access)
> Merging aio/master (855ef0dec727 aio: kill the misleading rcu read locks in ioctx_add_table() and kill_ioctx())
> Merging llvmlinux/for-next (f9da455b93f6 Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next)
> Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Parse device tree to setup idle states)
> Merging rd-docs/master (0af05db576e9 Dell kernel driver dell-smo8800 provides same freefall interface as hp_accel so program hpfall.c works also on Dell laptops. So rename it to freefall.c.)
> CONFLICT (content): Merge conflict in Documentation/laptops/freefall.c
> Merging akpm-current/current (7407621ec9e0 fs/dlm/debug_fs.c: remove unnecessary null test before debugfs_remove)
> $ git checkout -b akpm remotes/origin/akpm/master
> Applying: drivers/gpio/gpio-zevio.c: fix build
> Applying: x86-64: fix vDSO build
> Applying: ix86: fix vDSO build
> Applying: init/main.c: code clean-up
> Applying: arch/arm/mach-omap2: replace strict_strto* with kstrto*
> Applying: arch/arm/mach-pxa: replace strict_strto call with kstrto
> Applying: arch/arm/mach-s3c24xx/mach-jive.c: replace strict_strto* with kstrto*
> Applying: arch/arm/mach-w90x900/cpu.c: replace obsolete strict_strto
> Applying: arch/powerpc: replace obsolete strict_strto* calls
> Applying: arch/x86: replace strict_strto calls
> Applying: drivers/scsi: replace strict_strto calls
> Applying: net/sunrpc: replace strict_strto calls
> Applying: include/linux: remove strict_strto* definitions
> Applying: pci-dma-compat: add pci_zalloc_consistent helper
> Applying: atm: use pci_zalloc_consistent
> Applying: block: use pci_zalloc_consistent
> Applying: crypto: use pci_zalloc_consistent
> Applying: infiniband: use pci_zalloc_consistent
> Applying: i810: use pci_zalloc_consistent
> Applying: media: use pci_zalloc_consistent
> Applying: amd: use pci_zalloc_consistent
> Applying: atl1e: use pci_zalloc_consistent
> Applying: enic: use pci_zalloc_consistent
> Applying: sky2: use pci_zalloc_consistent
> Applying: micrel: use pci_zalloc_consistent
> Applying: qlogic: use pci_zalloc_consistent
> Applying: irda: use pci_zalloc_consistent
> Applying: ipw2100: use pci_zalloc_consistent
> Applying: mwl8k: use pci_zalloc_consistent
> Applying: rtl818x: use pci_zalloc_consistent
> Applying: rtlwifi: use pci_zalloc_consistent
> Applying: scsi: use pci_zalloc_consistent
> Applying: staging: use pci_zalloc_consistent
> Applying: synclink_gt: use pci_zalloc_consistent
> Applying: vme: bridges: use pci_zalloc_consistent
> Applying: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary OOM messages
> Applying: kernel/posix-timers.c: code clean-up
> Applying: kernel-posix-timersc-code-clean-up-checkpatch-fixes
> Applying: MAINTAINERS: update microcode patterns
> Applying: MAINTAINERS: update cifs location
> Applying: MAINTAINERS: use the correct efi-stub location
> Applying: MAINTAINERS: update clk/sirf patterns
> Applying: MAINTAINERS: fix ssbi pattern
> Applying: MAINTAINERS: use correct filename for sdhci-bcm-kona
> Applying: MAINTAINERS: fix PXA3xx NAND FLASH DRIVER pattern
> Applying: MAINTAINERS: update picoxcell patterns
> Applying: MAINTAINERS: remove section CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
> Applying: MAINTAINERS: remove METAG imgdafs pattern
> Applying: MAINTAINERS: remove unused radeon drm pattern
> Applying: MAINTAINERS: remove unusd ARM/QUALCOMM MSM pattern
> Applying: MAINTAINERS: remove unused NFSD pattern
> Applying: kernel/kprobes.c: convert printk to pr_foo()
> Applying: mm: replace remap_file_pages() syscall with emulation
> Applying: mm-replace-remap_file_pages-syscall-with-emulation-fix
> Applying: mm: remap_file_pages: initialize populate before usage
> Applying: mm: remap_file_pages: grab file ref to prevent race while mmaping
> Applying: memcg: deprecate memory.force_empty knob
> Applying: memcg-deprecate-memoryforce_empty-knob-fix
> Applying: fat: add i_disksize to represent uninitialized size
> Applying: fat: add fat_fallocate operation
> Applying: fat: zero out seek range on _fat_get_block
> Applying: fat: fallback to buffered write in case of fallocated region on direct IO
> Applying: fat: permit to return phy block number by fibmap in fallocated region
> Applying: Documentation/filesystems/vfat.txt: update the limitation for fat fallocate
> Applying: drivers/w1/w1_int.c: call put_device if device_register fails
> Applying: mm: add strictlimit knob
> Merging akpm/master (f96adb0500b6 mm: add strictlimit knob)
Steven,
I am been trying your tests for a while. Seems most of your failing
tests work for me.
Can you test a newer compiler in the 4.8 release series for gcc to see
if this fixes your
issues.
Cheers Nick
