Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab3B0CoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:44:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34607 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3B0CoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:44:18 -0500
Date: Wed, 27 Feb 2013 13:44:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 27
Message-Id: <20130227134406.132ab12a4f7fb6000d34b6a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Feb_2013_13_44_06_+1100_Y.6ZhyAjw4lZMCYP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Feb_2013_13_44_06_+1100_Y.6ZhyAjw4lZMCYP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add any work destined for v3.10 to your -next included
branches until after Linus has release v3.9-rc1.

Changes since 20130226:

The drm tree lost its build failure.

The renesas tree gained a conflict against Linus' tree.

The akpm tree gained a conflict against the vfs tree and lost a few
patches that turned up elsewhere.

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
Merging origin/master (1cef935 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/davem/net)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arm-current/fixes (b255188 ARM: fix scheduling while atomic warning=
 in alignment handling code)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (eda8eeb powerpc/mm: Fix hash computation funct=
ion)
Merging sparc/master (f9fd348 sparc32: refactor smp boot)
Merging net/master (0237c11 drivers: net: ethernet: cpsw: consider number o=
f slaves in interation)
Merging ipsec/master (85dfb74 af_key: initialize satype in key_notify_polic=
y_flush())
Merging sound-current/for-linus (d0ec95f ALSA: emu10k1: Allow to switch har=
dware sampe rate on EMU)
Merging pci-current/for-linus (249bfb8 PCI/PM: Clean up PME state when remo=
ving a device)
Merging wireless/master (dc4a787 brcmfmac: fix missing unlock on error in b=
rcmf_notify_vif_event())
Merging driver-core.current/driver-core-linus (949db15 Linux 3.8-rc5)
Merging tty.current/tty-linus (8b5628a Merge tag 'virt' of git://git.kernel=
.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging usb.current/usb-linus (221f8df USB: EHCI: revert "remove ASS/PSS po=
lling timeout")
Merging staging.current/staging-linus (8b5628a Merge tag 'virt' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging char-misc.current/char-misc-linus (7ed214a Merge tag 'char-misc-3.9=
-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc)
Merging input-current/for-linus (171fb58 Input: ALPS - update documentation=
 for recent touchpad driver mods)
Merging md-current/for-linus (ee0b024 md/raid1,raid10: fix deadlock with fr=
eeze_array())
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
Merging rr-fixes/fixes (aded024 virtio_console: Don't access uninitialized =
data.)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (7e0d306 ARC: Kconfig cleanup tracking cross-arch Kcon=
fig pruning in merge window)
CONFLICT (content): Merge conflict in init/Kconfig
Merging arm/for-next (b47ce09 Merge branches 'devel-stable', 'fixes' and 'm=
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
Merging metag/for-next (068bf1c metag: prom.h: remove declaration of metag_=
dt_memblock_reserve())
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
Merging openrisc/for-upstream (160d837 openrisc: add missing header inclusi=
on)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (8520e44 powerpc/kexec: Disable hard IRQ before kexec)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fa59f17 powerpc/5200: Use the gpt* labels to simplify=
 mpc5200 dts files)
Merging galak/next (12c7e8f powerpc/85xx: l2sram - Add compatible string fo=
r BSC9131 platform)
Merging s390/features (7f46a97 s390/uaccess: fix kernel ds access for page =
table walk)
Merging sh/sh-latest (035688d sh: ecovec: add sample amixer settings)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (ecc46c5 tile: support atomic64_dec_if_positive())
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (9cf81c7 xtensa: add accept4 syscall)
Merging btrfs/next (dc81cdc Btrfs: fix remount vs autodefrag)
Merging ceph/master (3ebc21f libceph: fix messenger CONFIG_BLOCK dependenci=
es)
Merging cifs/for-next (68851c4 cifs: set MAY_SIGN when sec=3Dkrb5)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (1101d58 ecryptfs: ecryptfs_msg_ctx_alloc_to_free(): =
remove kfree() redundant null check)
Merging ext3/for_next (712ddc5 Ext2: remove the static function release_blo=
cks to optimize the kernel)
Merging ext4/dev (304e220 ext4: fix free clusters calculation in bigalloc f=
ilesystem)
Merging f2fs/dev (7dd690c f2fs: avoid build warning)
Merging fuse/for-next (634734b fuse: allow control of adaptive readdirplus =
use)
Merging gfs2/master (fd95e81 GFS2: Reinstate withdraw ack system)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (a47970f NFSv4.1: Hold reference to layout hdr in la=
youtget)
Merging nfsd/nfsd-next (56edc86 nfsd: fix compiler warning about ambiguous =
types in nfsd_cache_csum)
CONFLICT (content): Merge conflict in net/sunrpc/svcauth_unix.c
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
Merging jdelvare-hwmon/master (54e37b8 Merge tag 'vfio-for-v3.8-v2' of git:=
//github.com/awilliam/linux-vfio)
Merging hwmon-staging/hwmon-next (55529fa Merge tag 'edac_3.9' of git://git=
.kernel.org/pub/scm/linux/kernel/git/bp/bp)
Merging v4l-dvb/master (eccaaad Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (26901f2 Merge branches 'kbuild/kbuild' and 'kbuild=
/kconfig' into kbuild/for-next)
CONFLICT (modify/delete): kernel/timeconst.pl deleted in kbuild/for-next an=
d modified in HEAD. Version HEAD of kernel/timeconst.pl left in tree.
$ git rm -f kernel/timeconst.pl
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
Merging thermal/next (ef3ac3a Revert "Thermal: exynos: Add sysfs node suppo=
rting exynos's emulation mode.")
Applying: sched/rt: fix PowerClamp Driver for define move
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (19f949f Linux 3.8)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (319cc77 Merge branch 'misc' into for-next)
Merging target-updates/for-next (972b29c target: Rename spc_get_write_same_=
sectors -> sbc_get_write_same_sectors)
Merging target-merge/for-next-merge (d1c3ed6 Linux 3.8-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (17166a3 Revert "ARM: SPEAr13xx: Pass DW DMAC platfo=
rm data from DT")
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (a0b1c42 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net-next)
Merging ipsec-next/master (a0b1c42 Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net-next)
Merging wireless-next/master (b53cf45 net: wireless: hostap: hostap_ap.c: R=
eturn -ENOMEM instead of -1 for if kmalloc() fails.)
Merging bluetooth/master (baf94f0 Bluetooth: change bt_sock_unregister() to=
 return void)
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
Merging virtio/virtio-next (8078db7 virtio_console: Initialize guest_connec=
ted=3Dtrue for rproc_serial)
Merging input/next (005a69d Input: cyttsp-spi - remove duplicate MODULE_ALI=
AS())
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (5d30b00 Merge branch 'for-3.9' into for-next)
Merging block/for-next (833dd2e Merge branch 'for-3.9/drivers' into for-nex=
t)
Merging device-mapper/master (9d680a0 Add a persistent bitset as a wrapper =
around dm-array.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (0e78610 mmc: tegra: assume CONFIG_OF, remove platform=
 data)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (b1e0541 mm/sl[au]b: correct allocation type check in=
 kmalloc_slab())
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (15ae704 raid5: create multiple threads to handle strip=
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
Merging watchdog/master (144ff55 watchdog: davinci_wdt: update to devm_* AP=
I)
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
Merging ftrace/for-next (8c189ea ftrace: Call ftrace cleanup module notifie=
r after all other notifiers)
Merging rcu/rcu/next (7a6b55e srcu: use ACCESS_ONCE() to access sp->complet=
ed in srcu_read_lock())
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (bd31a7f KVM: nVMX: Trap unconditionally if msr bitm=
ap access fails)
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
Merging drivers-x86/linux-next (8732068 ideapad: depends on backlight subsy=
stem and update comment)
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
Merging char-misc/char-misc-next (7ed214a Merge tag 'char-misc-3.9-rc1' of =
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
CONFLICT (content): Merge conflict in fs/btrfs/extent-tree.c
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
Merging renesas/next (289ed81 Merge branches 'heads/defconfig', 'heads/boar=
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
Merging dma-buf/for-next (6764143 CHROMIUM: dma-buf: restore args on failur=
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
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: Revert "x86, mm: Make spurious_fault check explicitly check the P=
RESENT bit"
Applying: pageattr: prevent PSE and GLOABL leftovers to confuse pmd/pte_pre=
sent and pmd_huge
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
Applying: mm: use vm_unmapped_area() on parisc architecture
Applying: sched: /proc/sched_stat fails on very very large machines
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-fix
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-v2
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix
Applying: sched: /proc/sched_debug fails on very very large machines
Applying: sched-proc-sched_debug-fails-on-very-very-large-machines-fix
Applying: sched-proc-sched_debug-fails-on-very-very-large-machines-v2
Applying: sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix
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
Applying: mm: accelerate munlock() treatment of THP pages
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm: use vm_unmapped_area() on frv architecture
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: get_maintainer: allow keywords to match filenames
Applying: MAINTAINERS: Remove Mark M. Hoffman
Applying: maintainers-remove-mark-m-hoffman-fix
Applying: backlight: add new lp8788 backlight driver
Applying: backlight-add-new-lp8788-backlight-driver-checkpatch-fixes
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/scatterlist: add simple page iterator
Applying: lib/scatterlist: use page iterator in the mapping iterator
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc-ds1307-long-block-operations-bugfix-fix
Applying: arm: mvebu: add RTC support for Armada 370 and Armada XP
Applying: hfsplus: add osx.* prefix for handling namespace of Mac OS X exte=
nded attributes
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus: add support of manipulation by attributes file
Applying: hfsplus: fix issue with unzeroed unused b-tree nodes
Applying: fat: add extended fileds to struct fat_boot_sector
Applying: fat: mark fs as dirty on mount and clean on umount
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: Documentation/cgroups/blkio-controller.txt: fix typo
Applying: signal: allow to send any siginfo to itself
Applying: signal-allow-to-send-any-siginfo-to-itself-fix
Applying: kernel/signal.c - fix suboptimal printk usage
Applying: coredump: remove redundant defines for dumpable states
Applying: fs/proc: clean up printks
CONFLICT (content): Merge conflict in fs/proc/inode.c
Applying: fs-proc-clean-up-printks-fix
Applying: fs-proc-clean-up-printks-fix-fix
Applying: fs/proc/vmcore.c: put if tests in the top of the while loop to re=
duce duplication
Applying: fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-redu=
ce-duplication-fix
Applying: fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-redu=
ce-duplication-fix-fix
Applying: vfork: don't freezer_count() for in-kernel users of CLONE_VFORK
Applying: lockdep: check that no locks held at freeze time
Applying: lockdep-check-that-no-locks-held-at-freeze-time-fix
Applying: coredump: cleanup the waiting for coredump_finish code
Applying: coredump: use a freezable_schedule for the coredump_finish wait
Applying: coredump: abort core dump piping only due to a fatal signal
Applying: seq-file: use SEEK_ macros instead of hardcoded numbers
Applying: fs/seq_file.c:seq_lseek(): fix switch statement indenting
Applying: fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-=
fixes
Applying: fork: unshare: remove dead code
Applying: kexec: add the values related to buddy system for filtering free =
pages.
Applying: kexec: get rid of duplicate check for hole_end
Applying: kexec: export PG_hwpoison flag into vmcoreinfo
Applying: block: fix ext_devt_idr handling
Applying: idr: fix a subtle bug in idr_get_next()
Applying: idr: make idr_destroy() imply idr_remove_all()
Applying: atm/nicstar: don't use idr_remove_all()
Applying: block/loop: don't use idr_remove_all()
Applying: firewire: don't use idr_remove_all()
Applying: drm: don't use idr_remove_all()
Applying: dm: don't use idr_remove_all()
Applying: remoteproc: don't use idr_remove_all()
Applying: rpmsg: don't use idr_remove_all()
Applying: dlm: use idr_for_each_entry() in recover_idr_clear() error path
Applying: dlm: don't use idr_remove_all()
Applying: nfs: idr_destroy() no longer needs idr_remove_all()
Applying: inotify: don't use idr_remove_all()
Applying: cgroup: don't use idr_remove_all()
Applying: nfsd: idr_destroy() no longer needs idr_remove_all()
Applying: idr: deprecate idr_remove_all()
Applying: idr: cosmetic updates to struct / initializer definitions
Applying: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new=
()
Applying: idr: remove _idr_rc_to_errno() hack
Applying: idr: refactor idr_get_new_above()
Applying: idr: implement idr_preload[_end]() and idr_alloc()
Applying: idr: implement idr_preload[_end]() and idr_alloc()
Applying: block: fix synchronization and limit check in blk_alloc_devt()
Applying: block: convert to idr_alloc()
Applying: block/loop: convert to idr_alloc()
Applying: atm/nicstar: convert to idr_alloc()
Applying: drbd: convert to idr_alloc()
Applying: dca: convert to idr_alloc()
Applying: dmaengine: convert to idr_alloc()
Applying: firewire: add minor number range check to fw_device_init()
Applying: firewire: convert to idr_alloc()
Applying: firewire: fw_device_init: 'minor' may be used uninitialized
Applying: gpio: convert to idr_alloc()
Applying: drm: convert to idr_alloc()
Applying: drm: missing idr_preload_end in drm_gem_flink_ioctl
Applying: drm-convert-to-idr_alloc-fix-fix
Applying: drm/exynos: convert to idr_alloc()
Applying: drm/i915: convert to idr_alloc()
Applying: drm/sis: convert to idr_alloc()
Applying: drm/via: convert to idr_alloc()
Applying: drm/vmwgfx: convert to idr_alloc()
Applying: i2c: convert to idr_alloc()
Applying: i2c-convert-to-idr_alloc-fix
Applying: i2c: style cleanups after idr_alloc() conversion
Applying: IB/core: convert to idr_alloc()
Applying: IB/amso1100: convert to idr_alloc()
Applying: IB/cxgb3: convert to idr_alloc()
Applying: IB/cxgb4: convert to idr_alloc()
Applying: IB/ehca: convert to idr_alloc()
Applying: IB/ipath: convert to idr_alloc()
Applying: IB/mlx4: convert to idr_alloc()
Applying: IB/ocrdma: convert to idr_alloc()
Applying: IB/qib: convert to idr_alloc()
Applying: dm: convert to idr_alloc()
Applying: memstick: convert to idr_alloc()
Applying: mfd: convert to idr_alloc()
Applying: misc/c2port: convert to idr_alloc()
Applying: misc/tifm_core: convert to idr_alloc()
Applying: mmc: convert to idr_alloc()
Applying: mtd: convert to idr_alloc()
Applying: macvtap: convert to idr_alloc()
Applying: ppp: convert to idr_alloc()
Applying: power: convert to idr_alloc()
Applying: pps: convert to idr_alloc()
Applying: remoteproc: convert to idr_alloc()
Applying: rpmsg: convert to idr_alloc()
Applying: scsi/bfa: convert to idr_alloc()
Applying: scsi: convert to idr_alloc()
Applying: target/iscsi: convert to idr_alloc()
Applying: scsi/lpfc: convert to idr_alloc()
Applying: thermal: convert to idr_alloc()
Applying: uio: convert to idr_alloc()
Applying: vfio: convert to idr_alloc()
Applying: dlm: convert to idr_alloc()
Applying: inotify: convert to idr_alloc()
Applying: ocfs2: convert to idr_alloc()
Applying: ipc: convert to idr_alloc()
Applying: ipc-convert-to-idr_alloc-fix
Applying: cgroup: convert to idr_alloc()
Applying: events: convert to idr_alloc()
Applying: posix-timers: convert to idr_alloc()
Applying: net/9p: convert to idr_alloc()
Applying: mac80211: convert to idr_alloc()
Applying: sctp: convert to idr_alloc()
Applying: nfs4client: convert to idr_alloc()
Applying: idr: fix top layer handling
Applying: idr: remove MAX_IDR_MASK and move left MAX_IDR_* into idr.c
Applying: idr: remove length restriction from idr_layer->bitmap
Applying: idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fi=
xes
Applying: idr: make idr_layer larger
Applying: idr: add idr_layer->prefix
Applying: idr: implement lookup hint
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipmi: remove superfluous kernel/userspace explanation
Applying: ipmi: add new kernel options to prevent automatic ipmi init
Applying: ipmi: add options to disable openfirmware and PCI scanning
Applying: drivers/char/misc.c:misc_register(): do not loop on misc_list unc=
onditionally
Applying: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-uncondi=
tionally-fix
Applying: block/partition/msdos: detect AIX formatted disks even without 55=
aa
Applying: block/partitions/efi.c: ensure that the GPT header is at least th=
e size of the structure.
Applying: sysctl: fix null checking in bin_dn_node_address()
Applying: kernel/utsname_sysctl.c: put get/get_uts() into CONFIG_PROC_SYSCT=
L code block
Applying: nbd: support FLUSH requests
Applying: nbd: fsync and kill block device on shutdown
Applying: nbd: show read-only state in sysfs
Applying: nbd: update documentation and link to mailinglist
Applying: kernel/utsname.c: fix wrong comment about clone_uts_ns()
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: include/linux/eventfd.h: fix incorrect filename is a comment
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Applying: drivers/pps/clients/pps-gpio.c: use devm_kzalloc
Applying: w1: add support for DS2413 Dual Channel Addressable Switch
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
Applying: arch Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Applying: kfifo: move kfifo.c from kernel/ to lib/
Applying: kfifo: fix kfifo_alloc() and kfifo_init()
Applying: selftests: add tests for efivarfs
Applying: selftests-add-tests-for-efivarfs-fix
Applying: selftests-add-tests-for-efivarfs-fix-fix
Applying: selftests/efivarfs: add empty file creation test
Applying: selftests/efivarfs: add create-read test
Applying: tools/testing/selftests/Makefile: rearrange targets
Applying: selftests: add a simple doc
Applying: selftests-add-a-simple-doc-fix
Applying: kcmp: make it depend on CHECKPOINT_RESTORE
Applying: hlist: drop the node parameter from iterators
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix
Applying: hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes
Applying: hlist-drop-the-node-parameter-from-iterators-fix
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix
Applying: hlist-drop-the-node-parameter-from-iterators-redo-kvm
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-=
fix
Applying: hlist-drop-the-node-parameter-from-iterators-mlx4-fix
Applying: hlist-drop-the-node-parameter-from-iterators-qlnic-fix
Applying: hlist-drop-the-node-parameter-from-iterators-qlnic-2-fix
Merging akpm/master (abfe68d hlist-drop-the-node-parameter-from-iterators-q=
lnic-2-fix)

--Signature=_Wed__27_Feb_2013_13_44_06_+1100_Y.6ZhyAjw4lZMCYP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLXL2AAoJEECxmPOUX5FEIA0P/iU3X54I4bdNkAPPguPbieeF
1kLBF95nCT29UbKPk0D8uKxzEuIyQFhLlyf9KD3pVt3hdKINHZJTn8P5AHO7ai3l
6xd03/WW8lBec8W0NHbxwvlK89PYjbrzl/4r5BKgiLCSAy9adOZp2EcK9COS2tmb
dukv2+USO+tLtPOU47XbH9o61QIqQOXhxLnmQc5d+FBv1Es//dEJtdJjhrlHl5MR
pntZ6GhoN4cQD/tlkE5vgAj19qD8p2cxYXxFgxU8FsowNaAMDhygqgJQNFzuaVT9
QiUwfKe7FNjFPnba4RlaiKeql1l/tfQQz+BGWLcjxThAVFa11av6vLkm/daXUCpK
jVlGByFiWLX/yldl6dVQjqOOOl3maAsda5JrA4XtRctR1s8kz5FsT4OE9JpNY3vc
n+OxUs+zJay3dmARew2ng8r38aBVB1UA0PEMh815MHZ48oHv8iJ3pBR26oxxrmcq
iny2BDyMoFnNUjg+eWrfisPn26PknLsqaPU412YixkgBg3FVHIZSiMpBRj3Ngkxf
oGocHAxeZ2fOmPEkFLQXdcWUWutYlC+l9bme6xO30Jgu+WS9LDm5J5ZZflnu9+Rm
vTPRUYWahd1kpI9XNH1xiIes+9qUQLgbQqYUHCgMwL86ixpDoP9hpi8mV8wLZcdA
GTpH8GSZnGdKzVYayKhf
=iCig
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Feb_2013_13_44_06_+1100_Y.6ZhyAjw4lZMCYP--
