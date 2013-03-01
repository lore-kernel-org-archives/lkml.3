Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab3CAFAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:00:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35132 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CAFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:00:29 -0500
Date: Fri, 1 Mar 2013 16:00:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 1
Message-Id: <20130301160013.9565d4b3c03576c0ee633934@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_16_00_13_+1100_V7i5C45+6kM5nUWN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_16_00_13_+1100_V7i5C45+6kM5nUWN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add any work destined for v3.10 to your -next included
branches until after Linus has release v3.9-rc1.

Changes since 20130228:

The nfsd tree gained a conflict against Linus' tree and a build failure
so I used the version from next-20130228.

The bluetooth tree gained a conflict against Linus' tree.

The ftrace tree gained a build failure so I used the version from
next-20130228.

The kvm tree gained a conflict against Linus' tree.

The akpm tree gained a build failure for which I applied a patch and lost
a lost of patches that turned up elsewhere.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 216 trees (counting Linus' and 28 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (de1a226 Merge tag 'writeback-fixes' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/wfg/linux)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arm-current/fixes (e36815e ARM: Fix broken commit 0cc41e4a21d43 cor=
rupting kernel messages)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (eda8eeb powerpc/mm: Fix hash computation funct=
ion)
Merging sparc/master (f9fd348 sparc32: refactor smp boot)
Merging net/master (32fcafb net/phy: micrel: Disable asymmetric pause for K=
SZ9021)
Merging ipsec/master (85dfb74 af_key: initialize satype in key_notify_polic=
y_flush())
Merging sound-current/for-linus (d0ec95f ALSA: emu10k1: Allow to switch har=
dware sampe rate on EMU)
Merging pci-current/for-linus (249bfb8 PCI/PM: Clean up PME state when remo=
ving a device)
Merging wireless/master (4660269 libertas: fix crash for SD8688)
Merging driver-core.current/driver-core-linus (949db15 Linux 3.8-rc5)
Merging tty.current/tty-linus (8b5628a Merge tag 'virt' of git://git.kernel=
.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging usb.current/usb-linus (221f8df USB: EHCI: revert "remove ASS/PSS po=
lling timeout")
Merging staging.current/staging-linus (8b5628a Merge tag 'virt' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging char-misc.current/char-misc-linus (302a3c0 Drivers: hv: vmbus: Use =
the new infrastructure for delivering VMBUS interrupts)
Merging input-current/for-linus (171fb58 Input: ALPS - update documentation=
 for recent touchpad driver mods)
Merging md-current/for-linus (f3378b4 md: expedite metadata update when swi=
tching  read-auto -> active)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (8fd61d3 crypto: user - ensure user supplied =
strings are nul-terminated)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (084a0ec x86: add CONFIG_X86_MOVBE option)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (ab28698 of: define struct devi=
ce in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
Merging spi-current/spi/merge (d3601e5 spi/sh-hspi: fix return value check =
in hspi_probe().)
Merging gpio-current/gpio/merge (bc1008c gpio/mvebu-gpio: Make mvebu-gpio d=
epend on OF_CONFIG)
Merging rr-fixes/fixes (6515925 Merge tag 'ext4_for_linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (8ccfe66 ARC: split elf.h into uapi and export it for =
userspace)
CONFLICT (content): Merge conflict in init/Kconfig
Merging arm/for-next (3576216 Merge branches 'devel-stable', 'fixes' and 'm=
mci' into for-next)
Merging arm-perf/for-next/perf (5ef1240 Merge branches 'for-rmk/hw-breakpoi=
nt' and 'for-rmk/perf' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (42ead3a arm: zynq: timer: Set clock_event cpumask)
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
Merging arm64/upstream (ec45d1c arm64: mm: update CONTEXTIDR register to co=
ntain PID of current process)
Merging blackfin/for-linus (f656c24 blackfin: time-ts: Remove duplicate ass=
ignment)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (77c8006 UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (c9500a7 Merge branch 'pstore' into next)
Merging m68k/for-next (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs. CONFIG_H=
AS_DMA)
Merging m68knommu/for-next (8a67f21 m68knommu: fix trap on execing /bin/ini=
t)
Merging metag/for-next (2149e40 metag: remove SET_PERSONALITY())
CONFLICT (content): Merge conflict in tools/perf/perf.h
CONFLICT (content): Merge conflict in drivers/irqchip/Makefile
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (content): Merge conflict in drivers/clocksource/Kconfig
Merging microblaze/next (711e5b4 asm-generic: io: Fix ioread16/32be and iow=
rite16/32be)
Merging mips/mips-for-linux-next (19aa5ac Merge branch 'master' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/torvalds/linux into mips-for-linux-ne=
xt)
CONFLICT (content): Merge conflict in arch/mips/kernel/syscall.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal_n32.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal32.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal.c
CONFLICT (content): Merge conflict in arch/mips/kernel/scall64-o32.S
CONFLICT (content): Merge conflict in arch/mips/kernel/process.c
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/octeon/cvmx-hel=
per-util.h
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/executive/cvm=
x-helper-util.c
Merging openrisc/for-upstream (545ebd0 openrisc: require gpiolib)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (8520e44 powerpc/kexec: Disable hard IRQ before kexec)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fa59f17 powerpc/5200: Use the gpt* labels to simplify=
 mpc5200 dts files)
Merging galak/next (12c7e8f powerpc/85xx: l2sram - Add compatible string fo=
r BSC9131 platform)
Merging s390/features (72a6b43 s390/module: fix compile warning)
Merging sh/sh-latest (035688d sh: ecovec: add sample amixer settings)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (ecc46c5 tile: support atomic64_dec_if_positive())
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (9cf81c7 xtensa: add accept4 syscall)
Merging btrfs/next (dc81cdc Btrfs: fix remount vs autodefrag)
CONFLICT (content): Merge conflict in fs/btrfs/extent-tree.c
Merging ceph/master (83ca14f libceph: add support for HASHPSPOOL pool flag)
Merging cifs/for-next (c51bb0e cifs: bugfix for unreclaimed writeback pages=
 in cifs_writev_requeue())
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (1111eae eCryptfs: Fix redundant error check on ecryp=
tfs_find_daemon_by_euid())
Merging ext3/for_next (712ddc5 Ext2: remove the static function release_blo=
cks to optimize the kernel)
Merging ext4/dev (8e919d1 ext4: fix extent status tree regression for file =
systems > 512GB)
Merging f2fs/dev (7dd690c f2fs: avoid build warning)
Merging fuse/for-next (634734b fuse: allow control of adaptive readdirplus =
use)
Merging gfs2/master (fd95e81 GFS2: Reinstate withdraw ack system)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (f6488c9 nfs: don't allow nfs_find_actor to match in=
odes of the wrong type)
Merging nfsd/nfsd-next (dc10740 SUNRPC: make AF_LOCAL connect synchronous)
CONFLICT (content): Merge conflict in net/sunrpc/svcauth_unix.c
CONFLICT (content): Merge conflict in fs/nfsd/nfscache.c
$ git reset --hard HEAD^
Merging 20130228 version of nfsd
CONFLICT (content): Merge conflict in net/sunrpc/svcauth_unix.c
CONFLICT (content): Merge conflict in fs/nfsd/nfscache.c
[master a879319] 20130228/nfsd
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
Merging ubifs/linux-next (8afd500 UBIFS: fix double free of ubifs_orphan ob=
jects)
Merging xfs/for-next (1e82379 xfs: xfs_bmap_add_attrfork_local is too gener=
ic)
Merging vfs/for-next (d3d009c saner proc_get_inode() calling conventions)
Merging pci/next (018ba0a Merge branch 'pci/yinghai-root-bus-hotplug' into =
next)
Merging hid/for-next (e3dc8bf Merge branch 'for-3.9/logitech' into for-next)
Merging i2c/i2c/for-next (55827f4 i2c: Remove unneeded xxx_set_drvdata(...,=
 NULL) calls)
Merging jdelvare-hwmon/master (2a7d2b9 Merge branch 'akpm' (final batch fro=
m Andrew))
Merging hwmon-staging/hwmon-next (796450c hwmon: (pmbus/ltc2978) Use detect=
ed chip ID to select supported functionality)
Merging v4l-dvb/master (eccaaad Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (26901f2 Merge branches 'kbuild/kbuild' and 'kbuild=
/kconfig' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (53637e0 [libata] fix smatch warning for zpodd_wake_dev)
Merging infiniband/for-next (ef4e359 Merge branches 'core', 'cxgb4', 'ipoib=
', 'iser', 'misc', 'mlx4', 'qib' and 'srp' into for-next)
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging pm/linux-next (4383822 Merge branch 'acpi-pm' into fixes)
Merging idle/next (ca62cf5 Merge branch 'misc' into release)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (f5b6d45 thermal: rcar: remove __devinitconst)
CONFLICT (content): Merge conflict in drivers/thermal/exynos_thermal.c
Applying: sched/rt: fix PowerClamp Driver for define move
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (19f949f Linux 3.8)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (319cc77 Merge branch 'misc' into for-next)
Merging target-updates/for-next (2dbe10a target/pscsi: Rename sg_num to nr_=
vecs in pscsi_get_bio())
Merging target-merge/for-next-merge (d1c3ed6 Linux 3.8-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (f9c6a65 dmaengine: dw_dmac: move to generic DMA bin=
ding)
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (1cef935 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec-next/master (a0b1c42 Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net-next)
Merging wireless-next/master (b53cf45 net: wireless: hostap: hostap_ap.c: R=
eturn -ENOMEM instead of -1 for if kmalloc() fails.)
Merging bluetooth/master (0d4b884 Bluetooth: Remove redundant RFCOMM BT_CLO=
SED settings)
CONFLICT (content): Merge conflict in net/bluetooth/rfcomm/core.c
Merging mtd/master (0ce82b7 mtd: nand: onfi don't WARN if we are in 16 bits=
 mode)
Merging l2-mtd/master (24dea0c mtd: map: BUG() in non handled cases)
Merging crypto/master (7eb9c5d crypto: caam - Added property fsl,sec-era in=
 SEC4.0 device tree binding.)
Merging drm/drm-next (be88298 drm/tilcdc: only build on arm)
Merging drm-intel/drm-intel-next-queued (90a72f8 drm/i915: Refactor gen2 to=
 gen4 vblank interrupt handling)
Merging sound/for-next (d0ec95f ALSA: emu10k1: Allow to switch hardware sam=
pe rate on EMU)
Merging sound-asoc/for-next (5475931 Merge remote-tracking branch 'asoc/top=
ic/da7213' into asoc-next)
Merging modules/modules-next (fffddfd Merge branch 'drm-next' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging pekey/devel-pekey (4ea349d MODSIGN: Fix including certificate twice=
 when the signing_key.x509 already exists)
Merging virtio/virtio-next (6515925 Merge tag 'ext4_for_linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging input/next (005a69d Input: cyttsp-spi - remove duplicate MODULE_ALI=
AS())
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (5d30b00 Merge branch 'for-3.9' into for-next)
Merging block/for-next (833dd2e Merge branch 'for-3.9/drivers' into for-nex=
t)
Merging device-mapper/master (8678bfa A simple cache policy that writes bac=
k all data to the origin.)
Applying: hlist-drop-the-node-parameter-from-iterators-dm-cache-policy-fix
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (adf96e6 sysrq: don't depend on weak undefined arrays =
to have an address that compares as NULL)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (7d557b3 slub: correctly bootstrap boot caches)
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (f1e79ce raid5: create multiple threads to handle strip=
es)
Merging mfd/for-next (ff7109f mfd: lpc_ich: Use devres API to allocate priv=
ate data)
Merging battery/master (845e37e Merge git://git.kernel.org/pub/scm/linux/ke=
rnel/git/torvalds/linux)
CONFLICT (content): Merge conflict in include/linux/mfd/abx500/ab8500-bm.h
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (2730fd8 Merge remote-tracking branch 'regulator=
/topic/tps65090' into regulator-next)
Merging security/next (5b26603 tpm/ibmvtpm: build only when IBM pseries is =
configured)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (9ebe0e8 watchdog: sp805_wdt depends on ARM)
CONFLICT (content): Merge conflict in drivers/watchdog/Makefile
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
CONFLICT (content): Merge conflict in drivers/rtc/rtc-stmp3xxx.c
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (604542b Merge branches 'core', 'arm/omap', 'iommu/fixes=
', 'arm/tegra', 'arm/shmobile', 'arm/exynos', 'x86/vt-d' and 'x86/amd' into=
 next)
Merging vfio/next (d65530f drivers/vfio: remove depends on CONFIG_EXPERIMEN=
TAL)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (df63447 DocBook: update EXPORT_SYMBOL entry to po=
int at export.h)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (b076989 i5100_edac: convert to use simple_open())
Merging edac-amd/for-next (e7d2c21 mpc85xx_edac: Fix typo)
Merging devicetree/devicetree/next (02bbde7 Revert "of: use platform_device=
_add")
Merging dt-rh/for-next (1421954 documentation/devicetree: Fix a typo in exy=
nos-dw-mshc.txt)
Merging spi/spi/next (095c375 spi: Document cs_gpios and cs_gpio in kernel-=
doc)
Merging spi-mb/spi-next (a349685 spi/pxa2xx: add support for Lynxpoint SPI =
controllers)
Merging tip/auto-latest (641e71a Merge branch 'x86/urgent')
CONFLICT (content): Merge conflict in arch/x86/include/asm/pgtable.h
Merging ftrace/for-next (6c895ca tracing: Add rmdir to remove multibuffer i=
nstances)
$ git reset --hard HEAD^
Merging 20130228 version of ftrace
Merging rcu/rcu/next (7a6b55e srcu: use ACCESS_ONCE() to access sp->complet=
ed in srcu_read_lock())
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (3ab66e8 KVM: VMX: Pass vcpu to __vmx_complete_inter=
rupts)
CONFLICT (content): Merge conflict in arch/x86/kernel/kvmclock.c
Merging kvm-ppc/kvm-ppc-next (bd31a7f KVM: nVMX: Trap unconditionally if ms=
r bitmap access fails)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (39ada15 Merge branch 'stable/for-linus-3.9-take=
-two' into linux-next)
Applying: xen: fix bad merge of arch/x86/xen/mmu.c
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (a4791ca Merge branch 'for-3.9' into for-next)
Merging drivers-x86/linux-next (e6e5224 ideapad-laptop: Depend on BACKLIGHT=
_CLASS_DEVICE instead of selecting it)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (a2b37ef Merge remote-tracking branch 'regmap/topic=
/no-bus' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (4b07c5d leds: leds-sunfire: use dev_err()/pr_err() i=
nstead of printk())
Merging driver-core/driver-core-next (8b5628a Merge tag 'virt' of git://git=
.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging tty/tty-next (8b5628a Merge tag 'virt' of git://git.kernel.org/pub/=
scm/linux/kernel/git/arm/arm-soc)
Merging usb/usb-next (74e1a2a Merge tag 'usb-3.9-rc1' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/gregkh/usb)
Merging staging/staging-next (8b5628a Merge tag 'virt' of git://git.kernel.=
org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging char-misc/char-misc-next (0988496 mm: do not grow the stack vma jus=
t because of an overrun on preceding vma)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (ade158e pinctrl: tegra: add clfvs function to Teg=
ra114 support)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (9170100 arm64: select ARCH_WANT_OPTIONAL_GPIOLIB)
Merging gpio-lw/for-next (c7886b1 gpio: em: Use irq_domain_add_simple() to =
fix runtime error)
Merging arm-soc/for-next (1ead4fb Merge branch 'late/mvebu-dt' into for-nex=
t)
CONFLICT (content): Merge conflict in include/linux/mmc/host.h
CONFLICT (content): Merge conflict in drivers/mmc/host/sh_mmcif.c
CONFLICT (content): Merge conflict in drivers/mmc/host/sdhci-pxav3.c
CONFLICT (content): Merge conflict in drivers/mmc/host/sdhci-esdhc-imx.c
CONFLICT (add/add): Merge conflict in drivers/mmc/host/sdhci-bcm2835.c
CONFLICT (content): Merge conflict in drivers/mmc/core/sdio.c
CONFLICT (content): Merge conflict in drivers/mmc/core/core.c
CONFLICT (content): Merge conflict in drivers/mmc/card/block.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-4430sdp.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/armada-370-xp.dtsi
Merging bcm2835/for-next (836dc9e Linux 3.8-rc7)
Merging cortex/for-next (6ebd4d0 ARM: stub out read_cpuid and read_cpuid_ex=
t for CPU_CP15=3Dn)
CONFLICT (content): Merge conflict in arch/arm/include/asm/cputype.h
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (1b8b1c3 Merge branches 'heads/defconfig', 'heads/boar=
ds3', 'heads/pfc' and 'heads/clocksource' into next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-mackerel=
.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadill=
o800eva.c
Merging samsung/for-next (786b270 Merge branch 'next/cpufreq-exynos' into f=
or-next)
Merging tegra/for-next (19f949f Linux 3.8)
Merging dma-mapping/dma-mapping-next (d589829 ARM: DMA-mapping: fix memory =
leak in IOMMU dma-mapping implementation)
Merging pwm/for-next (a32e1d1 pwm_backlight: remove unnecessary ifdefs)
Merging dma-buf/for-next (495c10c CHROMIUM: dma-buf: restore args on failur=
e of dma_buf_mmap)
Merging userns/for-next (139321c cifs: Enable building with user namespaces=
 enabled.)
Merging ktest/for-next (7328735 ktest: Remove indexes from warnings check)
Merging signal/for-next (9e2d59a Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/signal)
Merging clk/clk-next (fde8bc5 clk: sunxi: remove stale Makefile entry)
Merging random/dev (6133705 random: Mix cputime from each thread that exits=
 to the pool)
Merging lzo-update/lzo-update (0ec7382 crypto: testmgr - update LZO compres=
sion test vectors)
Merging modem_shm/remoteproc-next (c68dc8d remoteproc: Always perserve reso=
urce table data)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (6df6a56 device_cgroup: don't grab mutex in rc=
u callback)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timer_list: split timer_list_show_tickdevices()
Applying: timer_list: convert timer list to be a proper seq_file
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: fs: return EAGAIN when O_NONBLOCK write should block on frozen fs
Applying: fs: fix hang with BSD accounting on frozen filesystem
Applying: ocfs2: add freeze protection to ocfs2_file_splice_write()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: mm: memmap_init_zone() performance improvement
Applying: mm: remove free_area_cache
Applying: include/linux/mmzone.h: cleanups
Applying: include-linux-mmzoneh-cleanups-fix
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: MAINTAINERS: Remove Mark M. Hoffman
Applying: maintainers-remove-mark-m-hoffman-fix
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: epoll: support for disabling items, and a self-test app
CONFLICT (content): Merge conflict in tools/testing/selftests/Makefile
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc-ds1307-long-block-operations-bugfix-fix
Applying: arm: mvebu: add RTC support for Armada 370 and Armada XP
Applying: vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
Applying: coredump: abort core dump piping only due to a fatal signal
Applying: nfsd: idr_destroy() no longer needs idr_remove_all()
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: mm: remove old aio use_mm() comment
Applying: aio: remove dead code from aio.h
Applying: gadget: remove only user of aio retry
Applying: aio: remove retry-based AIO
Applying: char: add aio_{read,write} to /dev/{null,zero}
Applying: aio: kill return value of aio_complete()
Applying: aio: add kiocb_cancel()
Applying: aio-kiocb_cancel-fix
Applying: aio: move private stuff out of aio.h
Applying: aio: dprintk() -> pr_debug()
Applying: aio: do fget() after aio_get_req()
Applying: aio: make aio_put_req() lockless
Applying: aio: refcounting cleanup
CONFLICT (content): Merge conflict in fs/aio.c
Applying: wait: add wait_event_hrtimeout()
Applying: wait-add-wait_event_hrtimeout-fix
Applying: aio: make aio_read_evt() more efficient, convert to hrtimers
Applying: aio: use flush_dcache_page()
Applying: aio: use cancellation list lazily
Applying: aio-use-cancellation-list-lazily-fix
Applying: aio-use-cancellation-list-lazily-fix-fix
Applying: aio: change reqs_active to include unreaped completions
Applying: aio: kill batch allocation
Applying: aio: kill struct aio_ring_info
Applying: aio: give shared kioctx fields their own cachelines
Applying: aio-give-shared-kioctx-fields-their-own-cachelines-fix
Applying: aio: reqs_active -> reqs_available
Applying: aio: percpu reqs_available
Applying: generic dynamic per cpu refcounting
Applying: generic-dynamic-per-cpu-refcounting-fix
Applying: percpu-refcount: sparse fixes
Applying: generic-dynamic-per-cpu-refcounting-sparse-fixes-fix
Applying: generic-dynamic-per-cpu-refcounting-doc
Applying: generic-dynamic-per-cpu-refcounting-doc-fix
Applying: aio: percpu ioctx refcount
Applying: aio: use xchg() instead of completion_lock
Applying: aio: don't include aio.h in sched.h
Applying: aio-dont-include-aioh-in-schedh-fix
Applying: aio-dont-include-aioh-in-schedh-fix-fix
Applying: aio-dont-include-aioh-in-schedh-fix-3
Applying: aio-dont-include-aioh-in-schedh-fix-3-fix
Applying: aio-dont-include-aioh-in-schedh-fix-3-fix-fix
Applying: aio: kill ki_key
Applying: aio: kill ki_retry
Applying: aio-kill-ki_retry-fix
Applying: aio-kill-ki_retry-fix-fix
Applying: block, aio: batch completion for bios/kiocbs
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
Applying: Fix build error due to bio_endio_batch
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
Applying: aio: Fix a null pointer deref in batch_complete_aio
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: fix aio_read_events_ring() types
Applying: aio: document, clarify aio_read_events() and shadow_tail
Applying: aio: correct calculation of available events
Applying: aio: fix kioctx not being freed after cancellation at exit time
Applying: aio: v3: fix kioctx not being freed after cancellation at exit ti=
me
Merging akpm/master (cc321d5 aio: v3: fix kioctx not being freed after canc=
ellation at exit time)
Applying: aio: fixup for hlist_for_each_entry_safe API change

--Signature=_Fri__1_Mar_2013_16_00_13_+1100_V7i5C45+6kM5nUWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMDXdAAoJEECxmPOUX5FETysP/i+alS5oczNg7h+PxICZvPzB
DvbBG6c+kIugGlY/WcMZqc0G27miaEdjUKyCNtdqbdg8IfjAYT/rjeFrTtZvmLE0
0uHwrGX2r+mF7U9fCX1EQVCgTKXuO8a7mN6ly1hScrxFLz25Ixx0xbMrZh+JAkpI
NCYT8hk27mbczwW/xdUB9NkkZxnJ+dgPbq6qtYSoZdhqzyWE1Xp3pjriB9mjRed8
LmE6xSejGYGt0m+Han0P/v6yH9PHZ69QfAF2pMJJ+VrHdurZSSyiVyaEPnWVGmar
Er8o8LVfW+Zom2l8+4AZr3SYYlWGlwn3aLHAP6syouLDflnmUeWO2mWpq5H/uwNv
pbyqk2/yqe8QYzklJxCYlikUJ5gg8pFGwZgi5Y1rZ3aTRCW98hHI0tusyemmjxC5
XRqEqkftFqt+B6eUMdhDNz+eEdhCwYGxv+hHHJ+82EKeUQnbU8xFuGxSyDxaGQ2b
zUHPkc3WyjlEwvfD/YsfH1a313eBb1kImFFtg1T2eoS7zAAL0P/lOJTxhjHCpQ21
G6MM0euX5ZVQ2+ukBq/cQooZ10WH5T91OoeAyQWxFEVbn/ZhYo4jOljqNOPENukz
Ux96qEAMpZr6pkmcFCeo6Md0u88CUM4a7KiDCW0s2nDUI5vhidXji4oxAPzmJ0Ns
duLltkfugh3I0p0n5Wxz
=tqM7
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_16_00_13_+1100_V7i5C45+6kM5nUWN--
