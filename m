Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3IIGQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:16:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43890 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab3IIGQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:16:26 -0400
Date: Mon, 9 Sep 2013 16:16:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sep 9
Message-Id: <20130909161616.0d663a37c9d5b6b3a2a2735a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Sep_2013_16_16_16_+1000_nehNk6=wsI=cGys+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Sep_2013_16_16_16_+1000_nehNk6=wsI=cGys+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add any code for v3.13 to your linux-next included branches
until after v3.12-rc1 is released.

Changes since 20130906:

The vfs tree gained a build failure so I used the version from
next-20130906.

The akpm tree gained conflicts against Linus' tree.

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

We are up to 222 trees (counting Linus' and 30 trees of patches pending
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
Merging origin/master (b409624 Merge git://git.infradead.org/users/willy/li=
nux-nvme)
Merging fixes/master (fa8218d Merge tag 'regmap-v3.11-rc7' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (07b9b65 ARC: fix new Section mismatches in bu=
ild (post __cpuinit cleanup))
Merging arm-current/fixes (e1f0203 Merge branch 'security-fixes' into fixes)
Merging m68k-current/for-linus (5549005 m68k/atari: ARAnyM - Always use phy=
sical addresses in NatFeat calls)
Merging metag-fixes/fixes (3b2f64d Linux 3.11-rc2)
Merging powerpc-merge/merge (d220980 powerpc/hvsi: Increase handshake timeo=
ut from 200ms to 400ms.)
Merging sparc/master (4de9ad9 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/cmetcalf/linux-tile)
Merging net/master (e7d33bb lockref: add ability to mark lockrefs "dead")
Merging ipsec/master (302a50b xfrm: Fix potential null pointer dereference =
in xdst_queue_output)
Merging sound-current/for-linus (58f7d28 ALSA: hda - unmute pin amplifier i=
n infoframe setup for Haswell)
Merging pci-current/for-linus (a923874 Merge tag 'pci-v3.12-changes' of git=
://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging wireless/master (d2779e9 sh_eth: fix napi_{en|dis}able() calls raci=
ng against interrupts)
Merging driver-core.current/driver-core-linus (816434e Merge branch 'x86-sp=
inlocks-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging tty.current/tty-linus (c095ba7 Linux 3.11-rc4)
Merging usb.current/usb-linus (d347404 USB: OHCI: fix build error related t=
o ohci_suspend/resume)
Merging staging.current/staging-linus (d8dfad3 Linux 3.11-rc7)
Merging char-misc.current/char-misc-linus (b36f4be Linux 3.11-rc6)
Merging input-current/for-linus (c7dc657 Input: evdev - add EVIOCREVOKE ioc=
tl)
Merging md-current/for-linus (f94c0b6 md/raid5: fix interaction of 'replace=
' and 'recovery'.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (77dbd7a crypto: api - Fix race condition in =
larval lookup)
Merging ide/master (64110c1 ide: sgiioc4: Staticize ioc4_ide_attach_one())
Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging devicetree-current/devicetree/merge (cf9e236 of/irq: init struct re=
source to 0 in of_irq_to_resource())
Merging rr-fixes/fixes (6c2580c Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (d24cdbf vfio-pci: Avoid deadlock on remove)
Merging drm-intel-fixes/for-linux-next-fixes (6e46645 Linux 3.11)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (d8dfad3 Linux 3.11-rc7)
Merging arm/for-next (c0a27da Merge branches 'debug-choice', 'devel-stable'=
 and 'misc' into for-next)
Merging arm-perf/for-next/perf (ad81f05 Linux 3.11-rc1)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging arm64/upstream (4d5e0b1 Documentation/arm64: clarify requirements f=
or DTB placement)
Merging blackfin/for-linus (eb043d3 smp: blackfin: fix check error, using a=
tomic_ops to handle atomic_t type)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging h8300-remove/h8300-remove (b307c32 fs/minix: Drop dependency on H83=
00)
CONFLICT (content): Merge conflict in drivers/net/ethernet/8390/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (174a9a0 Merge branch 'misc-3.12' into next)
Merging m68k/for-next (5549005 m68k/atari: ARAnyM - Always use physical add=
resses in NatFeat calls)
Merging m68knommu/for-next (c065edd m68k: remove 16 unused boards in Kconfi=
g.machine)
Merging metag/for-next (b6ef916 irq-imgpdc: add ImgTec PDC irqchip driver)
Merging microblaze/next (54ea21f microblaze: Show message when reset gpio i=
s not present)
Merging mips/mips-for-linux-next (eb37e6d Merge branch '3.11-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9f0f4fb parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (9f24b0c powerpc: Correct FSCR bit definitions)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f2110cb dts: mpc512x: prepare for preprocessor suppor=
t)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (2ec7f4a s390/compat,uid16: use current_cred())
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (06da662 tile: refresh tile defconfig files)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (8872366 xtensa: Fix broken allmodconfig build)
Merging aio-direct/for-next (b080082 tmpfs: add support for read_iter and w=
rite_iter)
CONFLICT (content): Merge conflict in fs/direct-io.c
CONFLICT (content): Merge conflict in fs/block_dev.c
Merging btrfs/next (d7396f0 Btrfs: optimize key searches in btrfs_search_sl=
ot)
Merging ceph/master (a8d436f ceph: use d_invalidate() to invalidate aliases)
Merging cifs/for-next (77993be [CIFS] quiet sparse compile warning)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (cb69f36 ecryptfs: avoid ctx initialization race)
Merging ext3/for_next (97a2847 Merge branch 'for-3.12' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jeffm/linux-reiserfs into for_next_testing)
Merging ext4/dev (ad4eec6 ext4: allow specifying external journal by pathna=
me mount option)
Merging f2fs/dev (a26b7c8 f2fs: optimize gc for better performance)
Merging fscache/fscache (19ce0a7 CIFS: FS-Cache: Uncache unread pages in ci=
fs_readpages() before freeing them)
Merging fuse/for-next (05726ac fuse: use list_for_each_entry() for list tra=
versing)
Merging gfs2/master (0c90180 GFS2: dirty inode correctly in gfs2_write_end)
Merging jfs/jfs-next (a0263d8 jfs: fix error path in ialloc)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (b1b3e13 NFSv4: use mach cred for SECINFO_NO_NAME w/=
 integrity)
Merging nfsd/nfsd-next (d4a5165 rpc: let xdr layer allocate gssproxy receie=
ve pages)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (9e01242 Squashfs: add corruption check for type in=
 squashfs_readdir())
Merging v9fs/for-next (50192ab fs/9p: avoid accessing utsname after namespa=
ce has been torn down)
Merging ubifs/linux-next (c23e9b7 UBIFS: remove invalid warn msg with tst_r=
ecovery enabled)
Merging xfs/for-next (1d03c6f xfs: XFS_MOUNT_QUOTA_ALL needed by userspace)
CONFLICT (content): Merge conflict in fs/xfs/xfs_log_recover.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_inode.c
Merging vfs/for-next (38373e1 make unlazy_walk() always unlock)
$ git reset --hard HEAD^
Merging next-20130906 version of vfs
Merging pci/next (a923874 Merge tag 'pci-v3.12-changes' of git://git.kernel=
.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging hid/for-next (2f39579 Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (b720423 i2c: rcar: add rcar-H2 support)
Merging jdelvare-hwmon/master (c05c09f hwmon: (emc6w201) Do not declare enu=
m variable)
Merging hwmon-staging/hwmon-next (f060c65 hwmon: (htu21) Add Measurement Sp=
ecialties HTU21D support)
Merging v4l-dvb/master (d6cd75e Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in drivers/media/platform/s5p-mfc/s5p_mf=
c_dec.c
Merging kbuild/for-next (9aebd48 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (062728a Merge branch 'for-3.12' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (1ab7518 Merge branch 'acpi-pci-hotplug-next' into li=
nux-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (50e66c7 drivers: thermal: add check when unregisterin=
g cpu cooling)
Merging ieee1394/for-next (db9ae8f firewire: ohci: Fix deadlock at bus rese=
t)
Merging ubi/linux-next (8930fa5 UBI: Fix invalidate_fastmap())
Merging dlm/next (c6ca7bc dlm: remove signal blocking)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (71af442 Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in drivers/dma/Makefile
Merging dmaengine/next (e6a5fa6 ioatdma: silence GCC warnings)
Merging net-next/master (e7d33bb lockref: add ability to mark lockrefs "dea=
d")
Merging ipsec-next/master (aba8269 {ipv4,xfrm}: Introduce xfrm_tunnel_notif=
ier for xfrm tunnel mode callback)
CONFLICT (content): Merge conflict in include/net/xfrm.h
Merging wireless-next/master (f212781 net: ipv6: mld: document force_mld_ve=
rsion in ip-sysctl.txt)
Merging bluetooth/master (5a30d1f Bluetooth: Use devname:vhci module alias =
for virtual HCI driver)
Merging infiniband/for-next (82af24a Merge branches 'cxgb4', 'flowsteer', '=
ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (6c3b889 mtd: chips: Add support for PMC SPI Flash chips=
 in m25p80.c)
Merging l2-mtd/master (f3b3914 of_mtd: Add no-op stubs to support CONFIG_OF=
=3Dn)
Merging crypto/master (6841152 Reinstate "crypto: crct10dif - Wrap crc_t10d=
if function all to use crypto transform framework")
Merging drm/drm-next (86a7e12 Merge branch 'exynos-drm-next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next)
Merging drm-intel/for-linux-next (fd4daa9 drm/i915: Track pfit enable state=
 separately from size)
Merging drm-tegra/drm/for-next (03da0e7 drm/tegra: Parse device tree earlie=
r)
Merging sound/for-next (58f7d28 ALSA: hda - unmute pin amplifier in infofra=
me setup for Haswell)
Merging sound-asoc/for-next (7fe9767 Merge remote-tracking branch 'asoc/fix=
/kirkwood' into asoc-linus)
Merging modules/modules-next (942e443 module: Fix mod->mkobj.kobj potential=
ly freed too early)
Merging virtio/virtio-next (9e266ec virtio_pci: pm: Use CONFIG_PM_SLEEP ins=
tead of CONFIG_PM)
Merging input/next (52764fe Input: add SYN_MAX and SYN_CNT constants)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (66c144c Merge branch 'for-3.11-fixes' into for-nex=
t)
Merging block/for-next (3fe9649 Merge branch 'for-3.11/drivers' into for-ne=
xt)
Merging device-mapper/for-next (7fff5e8 dm stripe: silence a couple sparse =
warnings)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (9d731e7 Revert "mmc: tmio-mmc: Remove .set_pwr() call=
back from platform data")
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (9de1bc8 mm, slab_common: add 'unlikely' to size chec=
k of kmalloc_slab())
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (bfc90cb raid5: only wakeup necessary threads)
CONFLICT (content): Merge conflict in lib/raid6/test/Makefile
CONFLICT (content): Merge conflict in lib/raid6/Makefile
Merging mfd/master (9c31e88 Merge tag 'mfd-lee-3.12-2' of git://git.linaro.=
org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (02a0bf6 mfd: ucb1x00-core: Rewrite ucb1x00_add=
_dev())
Merging battery/master (db15e63 rx51_battery: Fix channel number when readi=
ng adc value)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (6f001cc Merge branch '3.12/dss-legacy-removal' =
into for-next)
Merging regulator/for-next (0f42823 Merge remote-tracking branch 'regulator=
/fix/palmas' into regulator-linus)
Merging security/next (7320336 Merge branch 'smack-for-3.12' of git://git.g=
itorious.org/smack-next/kernel into ra-next)
Merging selinux/master (0b4bdb3 Revert "SELinux: do not handle seclabel as =
a special flag")
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (f9a67f3 watchdog: s3c2410_wdt: simplify use of dev=
m_ioremap_resource)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (f098cc4 Merge branches 'arm/exynos', 'ppc/pamu', 'arm/s=
mmu', 'x86/amd' and 'iommu/fixes' into next)
Merging vfio/next (dac09b5 vfio: fix documentation)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (f8ea61e6 doc: Documentation/cputopology.txt fix t=
ypo)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging devicetree/devicetree/next (109b623 of: Feed entire flattened devic=
e tree into the random pool)
CONFLICT (content): Merge conflict in include/linux/of.h
Merging dt-rh/for-next (8851b9f include: dt-binding: input: create a DT hea=
der defining key codes.)
Merging spi/for-next (75c501e Merge remote-tracking branch 'spi/fix/pxa' in=
to spi-linus)
Merging tip/auto-latest (6eeb541 Merge branch 'x86/spinlocks')
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (75a9551 cpc925_edac: Use proper array terminatio=
n)
Merging ftrace/for-next (a0a5a05 ftrace/rcu: Do not trace debug_lockdep_rcu=
_enabled())
Merging rcu/rcu/next (25f27ce Merge branches 'doc.2013.08.19a', 'fixes.2013=
.08.20a', 'sysidle.2013.08.31a' and 'torture.2013.08.20a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (6b9e4fa Merge tag 'kvm-arm-for-3.12' of git://git.l=
inaro.org/people/cdall/linux-kvm-arm into queue)
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (bf550fc Merge remote-tracking branch 'origin/=
next' into kvm-ppc-next)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (32d70ed4 Merge branch 'stable/for-linus-3.12' i=
nto linux-next)
Merging percpu/for-next (abec1a8 percpu: Make __verify_pcu_ptr handle per c=
pu pointers to arrays)
Merging workqueues/for-next (1fb9107 workqueue: fix ordered workqueues in N=
UMA setups)
Merging drivers-x86/linux-next (5c07eae platform/x86: panasonic-laptop: reu=
se module_acpi_driver)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (365c9ee Merge remote-tracking branch 'regmap/topic=
/sparse' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (61abeba leds: wm831x-status: Request a REG resource)
CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in HEAD a=
nd modified in leds/for-next. Version leds/for-next of drivers/leds/leds-re=
nesas-tpu.c left in tree.
$ git rm -f drivers/leds/leds-renesas-tpu.c
Merging driver-core/driver-core-next (816434e Merge branch 'x86-spinlocks-f=
or-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging tty/tty-next (2d1d3f3 hvc_xen: Remove unnecessary __GFP_ZERO from k=
zalloc)
Merging usb/usb-next (b9a1048 usbcore: fix incorrect type in assignment in =
descriptors_changed())
Merging usb-gadget/next (0f2aa8c usb: musb: ux500: Add check for NULL board=
 data)
Merging staging/staging-next (91121c1 staging: dwc2: make dwc2_core_params =
documentation more complete)
Merging char-misc/char-misc-next (3cc1f95 drivers: uio: Kconfig: add MMU de=
pendancy for UIO)
Merging scsi/for-next (d3e89ba [SCSI] ufs: configure the attribute for powe=
r mode)
Merging target-updates/for-next (62b62d6 target: remove unused including <l=
inux/version.h>)
Merging target-merge/for-next-merge (d4e4ab8 Linux 3.11-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (8bb495e Linux 3.10)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (c9e3b2d pinctrl: sunxi: Fix off-by-one for valid =
offset range checking)
Merging vhost/linux-next (8c325ee vhost: wake up worker outside spin_lock)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (be1a4b1 gpio: improve error path in gpiolib)
Merging arm-soc/for-next (ca59147 ARM: next: added back arm-soc-for-next-co=
ntents.txt)
CONFLICT (content): Merge conflict in drivers/cpuidle/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7779.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7778.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/r=
8a7779.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/r=
8a7778.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-marzen.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/kirkwood.dtsi
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (6868a89 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (9445012 Merge branches 'imx/fixes-3.12', 'imx/soc=
-3.13' and 'imx/dt-3.13' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
Merging mvebu/for-next (e3cd46e Merge branch 'mvebu/dove_pcie-mbus-dt' into=
 for-next)
CONFLICT (content): Merge conflict in drivers/pci/host/pci-mvebu.c
CONFLICT (content): Merge conflict in drivers/pci/host/Kconfig
CONFLICT (content): Merge conflict in arch/arm/boot/dts/kirkwood.dtsi
Merging renesas/next (63c9972 Merge branch 'clocksource-fixes-for-v3.12' in=
to next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a7790.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a73a4.dtsi
Merging samsung/for-next (84b6f2e Merge branch 'v3.11-samsung-fixes-2' into=
 for-next)
Merging tegra/for-next (d8dfad3 Linux 3.11-rc7)
Merging dma-mapping/dma-mapping-next (10bcdfb ARM: init: add support for re=
served memory defined by device tree)
CONFLICT (content): Merge conflict in mm/Kconfig
CONFLICT (content): Merge conflict in drivers/base/dma-contiguous.c
Merging pwm/for-next (1e185c7 pwm: pxa: Use module_platform_driver)
Merging dma-buf/for-next (6e46645 Linux 3.11)
Merging userns/for-next (c7b96ac userns:  Kill nsown_capable it makes the w=
rong thing easy)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (b05c683 clk: Move symbol export to proper location)
CONFLICT (content): Merge conflict in drivers/clk/zynq/clkc.c
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging ptr-ret/PTR_RET (ad151d5 GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO)
Merging aio/master (77d30b1 aio: fix rcu sparse warnings introduced by ioct=
x table lookup patch)
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/block_dev.c
Applying: aio: semantic fixup
Applying: aio: another semantic merge fix
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (ea8adca mm-page-writebackc-add-strictlimit-fe=
ature-fix)
CONFLICT (content): Merge conflict in kernel/fork.c
Applying: fat: fix up for lockref changes
$ git checkout -b akpm remotes/origin/akpm/master
Applying: memcg: remove redundant code in mem_cgroup_force_empty_write()
Applying: memcg, vmscan: integrate soft reclaim tighter with zone shrinking=
 code
Applying: memcg: get rid of soft-limit tree infrastructure
Applying: vmscan, memcg: do softlimit reclaim also for targeted reclaim
Applying: memcg: enhance memcg iterator to support predicates
Applying: mm: fix memcg-less page reclaim
Applying: memcg: track children in soft limit excess to improve soft limit
Applying: memcg, vmscan: do not attempt soft limit reclaim if it would not =
scan anything
Applying: memcg: track all children over limit in the root
Applying: memcg, vmscan: do not fall into reclaim-all pass too quickly
Applying: memcg: trivial cleanups
Applying: arch: mm: remove obsolete init OOM protection
Applying: arch: mm: do not invoke OOM killer on kernel fault OOM
Applying: arch: mm: pass userspace fault flag to generic fault handler
Applying: x86: finish user fault error path with fatal signal
Applying: mm: memcg: enable memcg OOM killer only for user faults
Applying: mm: memcg: rework and document OOM waiting and wakeup
Applying: mm: memcg: do not trap chargers with full callstack on OOM
Applying: memcg: correct RESOURCE_MAX to ULLONG_MAX
Applying: memcg: rename RESOURCE_MAX to RES_COUNTER_MAX
Applying: memcg: avoid overflow caused by PAGE_ALIGN
Applying: memcg: reduce function dereference
Applying: memcg: remove MEMCG_NR_FILE_MAPPED
Applying: memcg: check for proper lock held in mem_cgroup_update_page_stat
Applying: memcg: add per cgroup writeback pages accounting
Applying: memcg: document cgroup dirty/writeback memory statistics
Applying: mm: make lru_add_drain_all() selective
Applying: truncate: drop 'oldsize' truncate_pagecache() parameter
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Applying: thp: account anon transparent huge pages into NR_ANON_PAGES
Applying: mm: cleanup add_to_page_cache_locked()
Applying: thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
Applying: thp: do_huge_pmd_anonymous_page() cleanup
Applying: thp: consolidate code between handle_mm_fault() and do_huge_pmd_a=
nonymous_page()
Applying: mm, thp: count thp_fault_fallback anytime thp fault fails
Applying: kernel: replace strict_strto*() with kstrto*()
Applying: fs: bump inode and dentry counters to long
Applying: super: fix calculation of shrinkable objects for small numbers
Applying: dcache: convert dentry_stat.nr_unused to per-cpu counters
Applying: dentry: move to per-sb LRU locks
Applying: dcache: remove dentries from LRU before putting on dispose list
Applying: mm: new shrinker API
Applying: shrinker: convert superblock shrinkers to new API
CONFLICT (content): Merge conflict in fs/internal.h
CONFLICT (content): Merge conflict in fs/dcache.c
Applying: shrinker-convert-superblock-shrinkers-to-new-api-fix
Applying: list: add a new LRU list type
Applying: inode: convert inode lru list to generic lru list code.
Applying: inode: move inode to a different list inside lock
Applying: dcache: convert to use new lru list infrastructure
CONFLICT (content): Merge conflict in fs/dcache.c
Applying: list_lru: per-node list infrastructure
Applying: list_lru: per-node list infrastructure fix
Applying: list_lru: fix broken LRU_RETRY behaviour
Applying: list_lru: per-node API
Applying: list_lru: remove special case function list_lru_dispose_all.
Applying: shrinker: add node awareness
Applying: vmscan: per-node deferred work
Applying: fs: convert inode and dentry shrinking to be node aware
CONFLICT (content): Merge conflict in fs/internal.h
Applying: xfs: convert buftarg LRU to generic code
Applying: xfs-convert-buftarg-lru-to-generic-code-fix
Applying: xfs: rework buffer dispose list tracking
Applying: xfs: convert dquot cache lru to list_lru
Applying: xfs-convert-dquot-cache-lru-to-list_lru-fix
Applying: xfs: fix dquot isolation hang
Applying: fs: convert fs shrinkers to new scan/count API
Applying: fs-convert-fs-shrinkers-to-new-scan-count-api-fix
Applying: UBIFS: signedness bug in ubifs_shrink_count()
Applying: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
Applying: drivers: convert shrinkers to new count/scan API
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix-2
Applying: i915: bail out earlier when shrinker cannot acquire mutex
Applying: shrinker: convert remaining shrinkers to count/scan API
Applying: shrinker-convert-remaining-shrinkers-to-count-scan-api-fix
Applying: hugepage: convert huge zero page shrinker to new shrinker API
Applying: hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix
Applying: shrinker: Kill old ->shrink API.
Applying: shrinker-kill-old-shrink-api-fix
Applying: list_lru: dynamically adjust node arrays
Applying: super: fix for destroy lrus
Applying: staging/lustre/ldlm: convert to shrinkers to count/scan API
Applying: staging/lustre/obdclass: convert lu_object shrinker to count/scan=
 API
Applying: staging/lustre/ptlrpc: convert to new shrinker API
Applying: staging/lustre/libcfs: cleanup linux-mem.h
Applying: mm/Kconfig: add MMU dependency for MIGRATION.
Applying: dcache: fix up for lockref changes
Merging akpm/master (d423792 dcache: fix up for lockref changes)

--Signature=_Mon__9_Sep_2013_16_16_16_+1000_nehNk6=wsI=cGys+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLWe1AAoJEECxmPOUX5FEZGEQAKUzJ0XaSTb9IcxwZ/5qgaFl
wUMIsO/5zwa3+lU+GkEyaZpFQwOHP6M85atb8cct9ex87feQSfmnWzbfgYyswu5b
KAeE3ldCus2YC54vZ2wIOnFuUW9CIo+MaPMoLmbQjK/wi9XU2qIyRKQy03WqfT2q
MYKWPJvri/ikgds5BeTZU5sp4M+0k+tWMfH57Di+UUfBJTvzP6fk4o6cQgsSHsit
9Hl+8ExuFv2p4Vxrwg85WmjTWKbSw24PlGVs3wvtaxgBSFv9eRWJZ5VdTE+PtrwN
xzWuOCPH0PH38UgnrjfzzFMT0RjB1WlP2+dZzgamP0qEPnxaSDVblzZY2mK9u3mV
gdpnVPeafLu+NzMSGyNrd8y6ApP2DEcb35GnBYdhWMA2QA4JSS8ZiP4SQjDAMDC0
fJHh5c41rfzeJ+nWCsQQ5OiP4PuN3dKDSMGjas1TVaFjwszSWVAEHHSrwHnP6Q18
CNfpcKdqbXU7kmXa2uRNBfmhvDT8G4ACMaRCFxpzV7cgz8IH7wcW3HxQrOAiZzLE
dxPdGDao+LmE7n+MVOm8lP5/Fhg43j1/l5VEhTB/XZ/DmuSnccJnu6C5lxgQRRDR
Wk/0tvp9EYKZAe80oYgt08eXPY9ncrK+A6YyR9RbrcNPY8BJEOknFuuQUOYzCD2n
nsEGHo5b83oj9Y8g3VPs
=1AQr
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Sep_2013_16_16_16_+1000_nehNk6=wsI=cGys+--
