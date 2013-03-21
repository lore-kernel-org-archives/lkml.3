Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3CUGip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:38:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35656 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab3CUGil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:38:41 -0400
Date: Thu, 21 Mar 2013 17:38:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 21
Message-Id: <20130321173832.c72cc034bd67452c9c2c567b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_17_38_32_+1100_VAP2BTfr0Udzzj2p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_17_38_32_+1100_VAP2BTfr0Udzzj2p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130320:

New tree: gen-gpio

Removed tree: pekey (Linus will not merge this as is)

Linus' tree gained a build failure for which I reverted a commit.

The v4l-dvb tree gained a conflict against the s390 tree.

The sound-asoc tree gained 2 build failures do I used the version from
next-20130320.

The cgroup tree lost its build failure.

The tty tree lost one of its build failures (after I reverted a commit)
but still had the other so I used the version from next-20130319.

The usb tree gained a conflict against the usb.current tree.

The gpio tree lost its build failure.

The akpm tree gained a conflict against the sparc-next tree and lost
several patches that were rejected for now.

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

We are up to 220 trees (counting Linus' and 31 trees of patches pending
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
Merging origin/master (2ffdd7e Merge tag 'vfio-v3.9-rc4' of git://github.co=
m/awilliam/linux-vfio)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arc-current/for-curr (367f3fc ARC: Fix the typo in event identifier=
 flags used by ptrace)
Merging arm-current/fixes (112ccff Merge branch 'hwmon-for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (af81d78 powerpc: Rename USER_ESID_BITS* to ESI=
D_BITS*)
Merging sparc/master (10b3866 Merge tag 'for-linus-v3.9-rc4' of git://oss.s=
gi.com/xfs/xfs)
Merging net/master (73214f5 thermal: shorten too long mcast group name)
Merging ipsec/master (85dfb74 af_key: initialize satype in key_notify_polic=
y_flush())
Merging sound-current/for-linus (eb49faa ALSA: hda - Fix abuse of snd_hda_l=
ock_devices() for DSP loader)
Merging pci-current/for-linus (249bfb8 PCI/PM: Clean up PME state when remo=
ving a device)
Merging wireless/master (36ef0b47 rtlwifi: usb: add missing freeing of skbu=
ff)
Merging driver-core.current/driver-core-linus (f6161aa Linux 3.9-rc2)
Merging tty.current/tty-linus (8b5c913 serial: 8250_pci: Add WCH CH352 quir=
k to avoid Xscale detection)
Merging usb.current/usb-linus (d714aaf USB: EHCI: fix regression in QH unli=
nking)
Merging staging.current/staging-linus (27ca039 staging: zcache: fix typo "6=
4_BIT")
Merging char-misc.current/char-misc-linus (347e089 VMCI: Fix process-to-pro=
cess DRGAMs.)
Merging input-current/for-linus (4b7d293 Input: mms114 - Fix regulator enab=
le and disable paths)
Merging md-current/for-linus (238f590 md: remove CONFIG_MULTICORE_RAID456 e=
ntirely)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (8fd61d3 crypto: user - ensure user supplied =
strings are nul-terminated)
Merging ide/master (bf6b438 ide: gayle: use module_platform_driver_probe())
Merging dwmw2/master (63662139 params: Fix potential memory leak in add_sys=
fs_param())
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (ab28698 of: define struct devi=
ce in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
Merging spi-current/spi/merge (d3601e5 spi/sh-hspi: fix return value check =
in hspi_probe().)
Merging gpio-current/gpio/merge (e97f9b5 gpio/gpio-ich: fix ichx_gpio_check=
_available() return what callers expect)
Merging rr-fixes/fixes (b7d44d9 hw_random: free rng_buffer at module exit)
Merging mfd-fixes/master (0371541 mfd: twl4030-madc: Remove __exit_p annota=
tion)
Merging vfio-fixes/for-linus (25e9789 vfio: include <linux/slab.h> for kmal=
loc)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (191db3f ARC: remove #ifdef-ed out include of dead hea=
der)
Merging arm/for-next (8d9c644 Merge branches 'devel-stable', 'fixes' and 'm=
isc' into for-next)
Merging arm-perf/for-next/perf (a937536 Linux 3.9-rc3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (42ead3a arm: zynq: timer: Set clock_event cpumask)
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
Merging arm64/upstream (7920720 arm64: Kconfig.debug: Remove unused CONFIG_=
DEBUG_ERRORS)
Merging blackfin/for-linus (f656c24 blackfin: time-ts: Remove duplicate ass=
ignment)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (77c8006 UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (96edc75 Change "select DMAR" to "select INTEL_IOMMU")
Merging m68k/for-next (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs. CONFIG_H=
AS_DMA)
Merging m68knommu/for-next (a937536 Linux 3.9-rc3)
Merging metag/for-next (2b8660e memblock: Kill ARCH_POPULATES_NODE_MAP once=
 more)
Merging microblaze/next (01cc2cb microblaze: intc: set the default irq_doma=
in)
Merging mips/mips-for-linux-next (306d20e Merge branches 'next/3.9-fixes', =
'next/kvm' and 'next/micromips' into mips-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (9e2d59a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/signal)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (cb1dc32 powerpc/mpc512x: create SoC devices for more =
nodes)
Merging galak/next (22aebe6 powerpc/qe: Fix Kconfig enablement of QE_USB su=
pport)
Merging s390/features (ffbee5e s390/mm: speedup storage key initialization)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
Merging sparc-next/master (d6d88ba sparc64: Kill __ARCH_WANT_UNLOCKED_CTXSW)
Merging tile/master (ecc46c5 tile: support atomic64_dec_if_positive())
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (9cf81c7 xtensa: add accept4 syscall)
Merging btrfs/next (6aec51f Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into for-linus-3.9)
Merging ceph/master (d6c0dd6 libceph: fix decoding of pgids)
Merging cifs/for-next (885fa95 cifs: ignore everything in SPNEGO blob after=
 mechTypes)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
Merging ext3/for_next (c288d29 ext2: Fix BUG_ON in evict() on inode deletio=
n)
Merging ext4/dev (2b405bf ext4: fix data=3Djournal fast mount/umount hang)
Merging f2fs/dev (330900b f2fs: avoid extra ++ while returning from get_nod=
e_path)
Merging fuse/for-next (634734b fuse: allow control of adaptive readdirplus =
use)
Merging gfs2/master (26217f5 GFS2: Fix unlock of fcntl locks during withdra=
wn state)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (90eabc5 NFSv4: Fix the string length returned by th=
e idmapper)
Merging nfsd/nfsd-next (6dbe51c Linux 3.9-rc1)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
Merging ubifs/linux-next (67e753c UBIFS: make space fixup work in the remou=
nt case)
Merging xfs/for-next (56cea2d xfs: take inode version into account in XFS_L=
ITINO)
Merging vfs/for-next (dcf787f constify path_get/path_put and fs_struct.c st=
uff)
Merging pci/next (f6161aa Linux 3.9-rc2)
Merging hid/for-next (26c3791 Merge branch 'for-3.10/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (21ea3f4 i2c: core: Pick i2c bus number from dt al=
ias if present)
Merging jdelvare-hwmon/master (c662b7a hwmon: (lm75) Add support for the Da=
llas/Maxim DS7505)
Merging hwmon-staging/hwmon-next (d43324c hwmon: (max6697) Use is_visible a=
nd sysfs_create_group)
Merging v4l-dvb/master (b9e7b1a Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/media/platform/Kconfig
Merging kbuild/for-next (4382a99 Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (b186aff pata_samsung_cf: use module_platform_driver_pr=
obe())
Merging infiniband/for-next (ef4e359 Merge branches 'core', 'cxgb4', 'ipoib=
', 'iser', 'misc', 'mlx4', 'qib' and 'srp' into for-next)
Merging pstore/master (c530267 pstore: Replace calls to kmalloc and memcpy =
with kmemdup)
Merging pm/linux-next (b1993ac Merge branch 'acpica-next' into linux-next)
Merging idle/next (deda402 tools/power turbostat: additional Haswell CPU-id)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (043e465 thermal: exynos_thermal: return a proper erro=
r code while thermal_zone_device_register fail.)
Merging ieee1394/for-next (6dbe51c Linux 3.9-rc1)
Merging ubi/linux-next (f6161aa Linux 3.9-rc2)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (6dbe51c Linux 3.9-rc1)
Merging target-updates/for-next (783e150 target: Change default sense key o=
f NOT_READY)
Merging target-merge/for-next-merge (a937536 Linux 3.9-rc3)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (ca85cb8 Merge branch 'for-linus' into next)
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (e76d120 chelsio: use netdev_alloc_skb_ip_align)
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (0d4e671 ath6kl: fix size_t printf warnings)
Merging bluetooth/master (0227c7b Bluetooth: fix error return code in rfcom=
m_add_listener())
Merging mtd/master (35f8c76 Merge tag 'for-linus-20130318' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (91aabd2 mtd: nand_ids: use size macros)
Merging crypto/master (6375bcf hwrng: Fix a wrong comment in Documentation/=
hw_random.txt)
Merging drm/drm-next (be88298 drm/tilcdc: only build on arm)
Merging drm-intel/drm-intel-next-queued (81fa12a drm/i915: Implement WaSwit=
chSolVfFArbitrationPriority)
Merging sound/for-next (9f5c6fa ALSA: hda - Add GPIO-based LED support on H=
P desktop machines)
Merging sound-asoc/for-next (a6a3d54 Merge remote-tracking branch 'asoc/top=
ic/wm8903' into asoc-next)
$ git reset --hard HEAD^
Merging 20130320 version of sound-asoc
Merging modules/modules-next (d70f82a genksyms: pass symbol-prefix instead =
of arch)
Merging virtio/virtio-next (cf994e0 tools/virtio: remove virtqueue_add_buf(=
) from tests.)
Merging input/next (38a46eb Input: mc13783_ts - use module_platform_driver_=
probe())
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (081aa45 cgroup: consolidate cgroup_attach_task() a=
nd cgroup_attach_proc())
CONFLICT (content): Merge conflict in include/linux/res_counter.h
Merging block/for-next (833dd2e Merge branch 'for-3.9/drivers' into for-nex=
t)
Merging device-mapper/master (fc60439 Correct the documented requirement on=
 the return code from dm cache policy lookup functions stated in the policy=
 module header file.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (0aacd23 mmc: tegra: use mmc_of_parse to get the suppo=
rt of standard MMC DT bindings)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (7d557b3 slub: correctly bootstrap boot caches)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (864e8cb md/raid10: Allow skipping recovery when clean =
arrays are assembled)
Merging mfd/master (5096cd1 mfd: cros_ec_spi: Warnings fix)
Merging battery/master (c6cc9fc s3c-adc-battery: Fix possible NULL pointer =
dereference)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (10affc9 Merge remote-tracking branch 'regulator=
/topic/tps6586x' into regulator-next)
Merging security/next (921f3ac tomoyo: use DEFINE_SRCU() to define tomoyo_s=
s)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (ebf590bb watchdog: Convert to devm_ioremap_resourc=
e())
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (ae19158 iommu: OMAP: build only on OMAP2+)
Merging vfio/next (dad9f89 VFIO-AER: Vfio-pci driver changes for supporting=
 AER)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (07f4225 treewide: Fix typos in printk)
CONFLICT (modify/delete): Documentation/virtual/virtio-spec.txt deleted in =
HEAD and modified in trivial/for-next. Version trivial/for-next of Document=
ation/virtual/virtio-spec.txt left in tree.
$ git rm -f Documentation/virtual/virtio-spec.txt
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (b076989 i5100_edac: convert to use simple_open())
Merging edac-amd/for-next (9713fae EDAC: Merge mci.mem_is_per_rank with mci=
.csbased)
Merging devicetree/devicetree/next (02bbde7 Revert "of: use platform_device=
_add")
Merging dt-rh/for-next (1421954 documentation/devicetree: Fix a typo in exy=
nos-dw-mshc.txt)
Merging spi/spi/next (095c375 spi: Document cs_gpios and cs_gpio in kernel-=
doc)
Merging spi-mb/spi-next (b66c773 spi/bcm63xx: use devm_ioremap_resource())
Merging tip/auto-latest (c56c948 Merge branch 'x86/paravirt')
Merging ftrace/for-next (0d3006d tracing: Update debugfs README file)
CONFLICT (content): Merge conflict in kernel/trace/ftrace.c
Merging rcu/rcu/next (53bbeb2 Merge branches 'doc.2013.03.12a', 'fixes.2013=
.03.12a' and 'idlenocb.2013.03.12a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (04b6683 KVM: x86: correctly initialize the CS base =
on reset)
Merging kvm-ppc/kvm-ppc-next (bd31a7f KVM: nVMX: Trap unconditionally if ms=
r bitmap access fails)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (849b022 Merge branch 'stable/for-linus-3.9-take=
-two' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (30db5f1 Merge branch 'master' into for-next)
Merging drivers-x86/linux-next (e6e5224 ideapad-laptop: Depend on BACKLIGHT=
_CLASS_DEVICE instead of selecting it)
CONFLICT (content): Merge conflict in drivers/platform/x86/chromeos_laptop.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (cc15f48 Merge remote-tracking branch 'regmap/topic=
/irq' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (103e6ad leds: leds-pwm: Defer led_pwm_set() if PWM c=
an sleep)
Merging driver-core/driver-core-next (8f46baa base: core: WARN() about bogu=
s permissions on device attributes)
Merging tty/tty-next (8358f62 driver: tty: vt: remove cast for kmalloc retu=
rn value)
$ git am -3 ../patches/0001-Revert-USB-quatech2-only-write-to-the-tty-if-th=
e-por.patch
Applying: Revert "USB: quatech2: only write to the tty if the port is open."
$ git reset --hard HEAD^
Merging 20130319 version of tty
Merging usb/usb-next (3f3b55b usb: ehci-s5p: Use devm for requesting ehci_v=
bus_gpio)
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-timer.c
Merging usb-gadget/next (e8d891f usb: phy: gpio-vbus: don't ignore regulato=
r APIs return value)
Merging staging/staging-next (25eeb66 zram: fix zram_bvec_read duplicate du=
mp failure message and stat accumulation)
Merging char-misc/char-misc-next (501ad1c FIX: softingcs conversion to modu=
le_pcmcia_driver macro)
Merging bcon/master (06c6942 blockconsole: Mark a local work struct static)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (f440836 Merge branch 'devel' into for-next)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
CONFLICT (content): Merge conflict in drivers/vhost/Makefile
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (753c598 gpio/em: Add Device Tree support)
Merging gpio-lw/for-next (c7886b1 gpio: em: Use irq_domain_add_simple() to =
fix runtime error)
Merging gen-gpio/for_next (994817c blackfin: force use of gpiolib)
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging arm-soc/for-next (5ad6b87 Merge branch 'next/soc' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/snowball.dts
Merging bcm2835/for-next (4c4d449 Merge branch 'for-3.10/defconfig' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging cortex/for-next (6ebd4d0 ARM: stub out read_cpuid and read_cpuid_ex=
t for CPU_CP15=3Dn)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (5bc31f8 Merge branch 'msm-defconfig' into for-next)
Merging renesas/next (811689a Merge branches 'heads/defconfig', 'heads/boar=
ds', 'heads/clocksource' and 'heads/intc-external-irq' into next)
Merging samsung/for-next (9daee5a Merge branch 'next/clk-exynos' into for-n=
ext)
Merging tegra/for-next (250266f Merge branch 'for-3.10/dt' into for-next)
CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
Merging dma-mapping/dma-mapping-next (a937536 Linux 3.9-rc3)
Merging pwm/for-next (a32e1d1 pwm_backlight: remove unnecessary ifdefs)
Merging dma-buf/for-next (6dbe51c Linux 3.9-rc1)
Merging userns/for-next (92f28d9 scm: Require CAP_SYS_ADMIN over the curren=
t pidns to spoof pids.)
Merging ktest/for-next (7328735 ktest: Remove indexes from warnings check)
Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of=
 macros)
CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
CONFLICT (content): Merge conflict in arch/tile/kernel/compat.c
CONFLICT (content): Merge conflict in arch/tile/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
Applying: cond_syscall and SYSCALL_ALIAS merge fixup
Merging clk/clk-next (0e646c5 clk: Add axi-clkgen driver)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (112ccff Merge branch 'hwmon-for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: irq_work.h: fix warning when CONFIG_IRQ_WORK=3Dn
Applying: printk: Provide a wake_up_klogd() off-case
Applying: printk-provide-a-wake_up_klogd-off-case-fix
Applying: mm/hugetlb: fix total hugetlbfs pages count when using memory ove=
rcommit accouting
Applying: mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit=
-accouting-fix
Applying: poweroff: change orderly_poweroff() to use schedule_work()
Applying: mm: zone_end_pfn is too small
Applying: drivers/rtc/rtc-da9052.c: fix for rtc device registration
Applying: dma-debug: fix locking bug in check_unmap()
Applying: dma-debug-fix-locking-bug-in-check_unmap-fix
Applying: dma-debug: update DMA debug API to better handle multiple mapping=
s of a buffer
Applying: mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: mips: define KVM_USER_MEM_SLOTS
Applying: thinkpad-acpi: kill hotkey_thread_mutex
Applying: kthread: introduce to_live_kthread()
Applying: kthread: kill task_get_live_kthread()
Applying: arch/x86/mm/init_64.c: fix build warning when CONFIG_MEMORY_HOTRE=
MOVE=3Dn
Applying: sound: convert snd_info_register() to use proc_create_data()
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: matroxfb: convert struct i2c_msg initialization to C99 format
Applying: drivers/video/console/fbcon_cw.c: fix compiler warning in cw_upda=
te_attr
Applying: drivers/video: add Hyper-V Synthetic Video Frame Buffer Driver
Applying: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_r=
esource()
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timer_list: split timer_list_show_tickdevices()
Applying: timer_list-split-timer_list_show_tickdevices-v4
Applying: timer_list: convert timer list to be a proper seq_file
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix
Applying: posix_cpu_timer: consolidate expiry time type
Applying: posix_cpu_timers: consolidate timer list cleanups
Applying: posix_cpu_timers: consolidate expired timers check
Applying: selftests: add basic posix timers selftests
CONFLICT (content): Merge conflict in tools/testing/selftests/Makefile
Applying: mkcapflags.pl: convert to mkcapflags.sh
Applying: headers_install.pl: convert to headers_install.sh
Applying: scripts/decodecode: make faulting insn ptr more robust
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: ocfs2: delay inode update transactions after verifying the input =
flags
Applying: kernel/sched/sched.h: fix warning
Applying: debug_locks.h: make warning more verbose
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: cciss: fix invalid use of sizeof in cciss_find_cfgtables()
Applying: loop: cleanup partitions when detaching loop device
Applying: loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fix=
es
Applying: loop-cleanup-partitions-when-detaching-loop-device-fix
Applying: loop-cleanup-partitions-when-detaching-loop-device-fix-fix
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: fs: return EAGAIN when O_NONBLOCK write should block on frozen fs
Applying: fs: fix hang with BSD accounting on frozen filesystem
Applying: ocfs2: add freeze protection to ocfs2_file_splice_write()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: HWPOISON: check dirty flag to match against clean page
Applying: mm: trace filemap add and del
Applying: mm-trace-filemap-add-and-del-v2
Applying: mm, show_mem: suppress page counts in non-blockable contexts
Applying: mm/shmem.c: remove an ifdef
Applying: vm: adjust ifdef for TINY_RCU
Applying: mm: frontswap: lazy initialization to allow tmem backends to buil=
d/run as modules
Applying: frontswap: make frontswap_init use a pointer for the ops
Applying: mm: frontswap: cleanup code
Applying: frontswap: get rid of swap_lock dependency
Applying: mm: cleancache: lazy initialization to allow tmem backends to bui=
ld/run as modules
Applying: cleancache: Make cleancache_init use a pointer for the ops
Applying: mm: cleancache: clean up cleancache_enabled
Applying: xen: tmem: enable Xen tmem shim to be built/loaded as a module
Applying: xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix
Applying: zcache/tmem: Better error checking on frontswap_register_ops retu=
rn value.
Applying: staging: zcache: enable ramster to be built/loaded as a module
Applying: staging: zcache: enable zcache to be built/loaded as a module
Applying: rmap: recompute pgoff for unmapping huge page
Applying: memblock: add assertion for zero allocation alignment
Applying: mm: walk_memory_range(): fix typo in comment
Applying: direct-io: Fix boundary block handling
Applying: mm/vmscan.c: minor cleanup for kswapd
Applying: mm: introduce common help functions to deal with reserved/managed=
 pages
Applying: mm/alpha: use common help functions to free reserved pages
Applying: mm/ARM: use common help functions to free reserved pages
Applying: mm/avr32: use common help functions to free reserved pages
Applying: mm/blackfin: use common help functions to free reserved pages
Applying: mm/c6x: use common help functions to free reserved pages
Applying: mm/cris: use common help functions to free reserved pages
Applying: mm/FRV: use common help functions to free reserved pages
Applying: mm/h8300: use common help functions to free reserved pages
Applying: mm/IA64: use common help functions to free reserved pages
Applying: mm/m32r: use common help functions to free reserved pages
Applying: mm/m68k: use common help functions to free reserved pages
Applying: mm/microblaze: use common help functions to free reserved pages
Applying: mm/MIPS: use common help functions to free reserved pages
Applying: mm/mn10300: use common help functions to free reserved pages
Applying: mm/openrisc: use common help functions to free reserved pages
Applying: mm/parisc: use common help functions to free reserved pages
Applying: mm/ppc: use common help functions to free reserved pages
Applying: mm/s390: use common help functions to free reserved pages
Applying: mm/score: use common help functions to free reserved pages
Applying: mm/SH: use common help functions to free reserved pages
Applying: mm/SPARC: use common help functions to free reserved pages
CONFLICT (content): Merge conflict in arch/sparc/mm/init_64.c
Applying: mm/um: use common help functions to free reserved pages
Applying: mm/unicore32: use common help functions to free reserved pages
Applying: mm/x86: use common help functions to free reserved pages
Applying: mm/xtensa: use common help functions to free reserved pages
Applying: mm/arc: use common help functions to free reserved pages
Applying: mm/metag: use common help functions to free reserved pages
Applying: mm,kexec: use common help functions to free reserved pages
Applying: mm: introduce free_highmem_page() helper to free highmem pages in=
to buddy system
Applying: mm/ARM: use free_highmem_page() to free highmem pages into buddy =
system
Applying: mm/FRV: use free_highmem_page() to free highmem pages into buddy =
system
Applying: mm/metag: use free_highmem_page() to free highmem pages into budd=
y system
Applying: mm/microblaze: use free_highmem_page() to free highmem pages into=
 buddy system
Applying: mm/MIPS: use free_highmem_page() to free highmem pages into buddy=
 system
Applying: mm/PPC: use free_highmem_page() to free highmem pages into buddy =
system
Applying: mm/SPARC: use free_highmem_page() to free highmem pages into budd=
y system
Applying: mm/um: use free_highmem_page() to free highmem pages into buddy s=
ystem
Applying: mm/x86: use free_highmem_page() to free highmem pages into buddy =
system
Applying: memcg: keep prev's css alive for the whole mem_cgroup_iter
Applying: memcg: rework mem_cgroup_iter to use cgroup iterators
Applying: memcg: relax memcg iter caching
Applying: memcg-relax-memcg-iter-caching-checkpatch-fixes
Applying: memcg: simplify mem_cgroup_iter
Applying: memcg: further simplify mem_cgroup_iter
Applying: cgroup: remove css_get_next
Applying: fs: don't compile in drop_caches.c when CONFIG_SYSCTL=3Dn
Applying: mm/hugetlb: add more arch-defined huge_pte functions
Applying: mm: make snapshotting pages for stable writes a per-bio operation
Applying: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-=
fix
Applying: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-=
fix-fix
Applying: mm, vmalloc: change iterating a vmlist to find_vm_area()
Applying: mm, vmalloc: move get_vmalloc_info() to vmalloc.c
Applying: mm, vmalloc: protect va->vm by vmap_area_lock
Applying: mm, vmalloc: iterate vmap_area_list, instead of vmlist in vread/v=
write()
Applying: mm, vmalloc: iterate vmap_area_list in get_vmalloc_info()
Applying: mm, vmalloc: iterate vmap_area_list, instead of vmlist, in vmallo=
cinfo()
Applying: mm, vmalloc: export vmap_area_list, instead of vmlist
Applying: mm, vmalloc: remove list management of vmlist after initializing =
vmalloc
Applying: kexec, vmalloc: export additional vmalloc layer information
Applying: kexec-vmalloc-export-additional-vmalloc-layer-information-fix
Applying: mmap: find_vma: remove the WARN_ON_ONCE(!mm) check
Applying: memcg: do not check for do_swap_account in mem_cgroup_{read,write=
,reset}
Applying: mm: allow arch code to control the user page table ceiling
Applying: arm: set the page table freeing ceiling to TASK_SIZE
Applying: mm: remove free_area_cache
Applying: include/linux/mmzone.h: cleanups
Applying: include-linux-mmzoneh-cleanups-fix
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: kernel/watchdog.c: add comments to explain watchdog_disabled vari=
able
Applying: kernel/range.c: subtract_range: fix the broken phrase issued by p=
rintk
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: printk/tracing: rework console tracing
Applying: early_printk: consolidate random copies of identical code
Applying: early_printk: consolidate random copies of identical code
Applying: early_printk-consolidate-random-copies-of-identical-code-v3-fix
Applying: include/linux/printk.h: include stdarg.h
Applying: get_maintainer: use filename-only regex match for Tegra
Applying: get_maintainer-use-filename-only-regex-match-for-tegra-fix
Applying: drivers/video/backlight/ams369fg06.c: convert ams369fg06 to dev_p=
m_ops
Applying: drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_=
ops-fix
Applying: drivers/video/backlight/platform_lcd.c: remove unnecessary ifdefs
Applying: drivers/video/backlight/ep93xx_bl.c: remove incorrect __init anno=
tation
Applying: drivers/video/backlight/atmel-pwm-bl.c: use module_platform_drive=
r_probe()
Applying: drivers/video/backlight/atmel-pwm-bl.c: add __init annotation
Applying: drivers/video/backlight/lp855x_bl.c: fix compiler warning in lp85=
5x_probe
Applying: drivers/video/backlight/jornada720_*.c: use dev_err()/dev_info() =
instead of pr_err()/pr_info()
Applying: drivers/video/backlight/omap1_bl.c: use dev_info() instead of pr_=
info()
Applying: drivers/video/backlight/generic_bl.c: use dev_info() instead of p=
r_info()
Applying: drivers/video/backlight/adp8870_bl.c: add missing braces
Applying: drivers/video/backlight/l4f00242t03.c: check return value of regu=
lator_enable()
Applying: drivers-video-backlight-l4f00242t03c-check-return-value-of-regula=
tor_enable-fix
Applying: backlight: ld9040: convert ld9040 to dev_pm_ops
Applying: backlight: lms501kf03: convert lms501kf03 to dev_pm_ops
Applying: backlight: s6e63m0: convert s6e63m0 to dev_pm_ops
Applying: backlight: adp5520: convert adp5520_bl to dev_pm_ops
Applying: backlight: adp8860: convert adp8860 to dev_pm_ops
Applying: backlight: adp8870: convert adp8870 to dev_pm_ops
Applying: backlight: corgi_lcd: convert corgi_lcd to dev_pm_ops
Applying: backlight: ep93xx: convert ep93xx to dev_pm_ops
Applying: backlight: hp680_bl: convert hp680bl to dev_pm_ops
Applying: backlight: kb3886_bl: convert kb3886bl to dev_pm_ops
Applying: backlight: lm3533_bl: convert lm3533_bl to dev_pm_ops
Applying: backlight: locomolcd: convert locomolcd to dev_pm_ops
Applying: backlight: ltv350qv: convert ltv350qv to dev_pm_ops
Applying: backlight: tdo24m: convert tdo24m to dev_pm_ops
Applying: drivers/video/backlight/Kconfig: fix typo "MACH_SAM9...EK" three =
times
Applying: drivers/video/backlight/adp5520_bl.c: fix compiler warning in adp=
5520_show()
Applying: video: backlight: add ili922x lcd driver
Applying: backlight: da903x_bl: use BL_CORE_SUSPENDRESUME option
Applying: drivers/video/backlight/lp855x_bl.c: use PAGE_SIZE for the sysfs =
read operation
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/int_sqrt.c: optimize square root algorithm
Applying: argv_split(): teach it to handle mutable strings
Applying: argv_split-teach-it-to-handle-mutable-strings-fix
Applying: argv_split-teach-it-to-handle-mutable-strings-fix-2
Applying: checkpatch: add check for reuse of krealloc arg
Applying: checkpatch: Prefer seq_puts to seq_printf
Applying: checkpatch: Complain about executable files
Applying: epoll: trim epitem by one cache line
Applying: epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
Applying: epoll: comment + BUILD_BUG_ON to prevent epitem bloat
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: epoll: use RCU to protect wakeup_source in epitem
Applying: epoll: lock ep->mtx in ep_free to silence lockdep
Applying: epoll: cleanup: hoist out f_op->poll calls
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: init: scream bloody murder if interrupts are enabled too early
Applying: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()
Applying: dmi_scan: proper buf type in dmi_present()
Applying: i2o: check copy_from_user() size parameter
Applying: rtc: rtc-mv: add __init annotation
Applying: rtc: rtc-davinci: add __exit annotation
Applying: rtc: rtc-ds1302: add __exit annotation
Applying: rtc: rtc-imxdi: add __init/__exit annotation
Applying: rtc: rtc-nuc900: add __init/__exit annotation
Applying: rtc: rtc-pcap: add __init/__exit annotation
Applying: rtc: rtc-tegra: add __init/__exit annotation
Applying: rtc: add devm_rtc_device_{register,unregister}()
Applying: drivers/rtc/rtc-max77686.c: use module_platform_driver()
Applying: drivers/rtc/rtc-max77686.c: add missing module author name
Applying: drivers/rtc/rtc-max77686.c: use devm_kzalloc()
Applying: drivers/rtc/rtc-max77686.c: fix indentation of bit definitions
Applying: drivers/rtc/rtc-max77686.c: use dev_info()/dev_emerg() instead of=
 pr_info()/pr_emerg()
Applying: drivers/rtc/rtc-v3020.c: use gpio_request_array()
Applying: drivers/rtc/class.c: use struct device as the first argument for =
devm_rtc_device_register()
Applying: rtc: rtc-ab3100: use module_platform_driver_probe()
Applying: rtc: rtc-at32ap700x: use module_platform_driver_probe()
Applying: rtc: rtc-at91rm9200: use module_platform_driver_probe()
Applying: rtc: rtc-au1xxx: use module_platform_driver_probe()
Applying: rtc: rtc-coh901331: use module_platform_driver_probe()
Applying: rtc: rtc-davinci: use module_platform_driver_probe()
Applying: rtc: rtc-ds1302: use module_platform_driver_probe()
Applying: rtc: rtc-efi: use module_platform_driver_probe()
Applying: rtc: rtc-generic: use module_platform_driver_probe()
Applying: rtc: rtc-imxdi: use module_platform_driver_probe()
Applying: rtc: rtc-mc13xxx: use module_platform_driver_probe()
Applying: rtc: rtc-msm6242: use module_platform_driver_probe()
Applying: rtc: rtc-mv: use module_platform_driver_probe()
Applying: rtc: rtc-nuc900: use module_platform_driver_probe()
Applying: rtc: rtc-omap: use module_platform_driver_probe()
Applying: rtc: rtc-pcap: use module_platform_driver_probe()
Applying: rtc: rtc-ps3: use module_platform_driver_probe()
Applying: rtc: rtc-pxa: use module_platform_driver_probe()
Applying: rtc: rtc-rp5c01: use module_platform_driver_probe()
Applying: rtc: rtc-sh: use module_platform_driver_probe()
Applying: rtc: rtc-starfire: use module_platform_driver_probe()
Applying: rtc: rtc-sun4v: use module_platform_driver_probe()
Applying: rtc: rtc-tegra: use module_platform_driver_probe()
Applying: rtc: rtc-tx4939: use module_platform_driver_probe()
Applying: rtc: rtc-88pm80x: use devm_rtc_device_register()
Applying: rtc: rtc-coh90133: use devm_rtc_device_register()
Applying: rtc: rtc-da9052: use devm_rtc_device_register()
Applying: rtc: rtc-da9055: use devm_rtc_device_register()
Applying: rtc: rtc-davinci: use devm_rtc_device_register()
Applying: rtc: rtc-ds1511: use devm_rtc_device_register()
Applying: rtc: rtc-ds1553: use devm_rtc_device_register()
Applying: rtc: rtc-ds1742: use devm_rtc_device_register()
Applying: rtc: rtc-ep93xx: use devm_rtc_device_register()
Applying: rtc: rtc-imxdi: use devm_rtc_device_register()
Applying: rtc: rtc-lp8788: use devm_rtc_device_register()
Applying: rtc: rtc-lpc32xx: use devm_rtc_device_register()
Applying: rtc: rtc-max77686: use devm_rtc_device_register()
Applying: rtc: rtc-max8907: use devm_rtc_device_register()
Applying: rtc: rtc-max8997: use devm_rtc_device_register()
Applying: rtc: rtc-mv: use devm_rtc_device_register()
Applying: rtc: rtc-mxc: use devm_rtc_device_register()
Applying: rtc: rtc-palmas: use devm_rtc_device_register()
Applying: rtc: rtc-pcf8523: use devm_rtc_device_register()
Applying: rtc: rtc-s3c: use devm_rtc_device_register()
Applying: rtc: rtc-snvs: use devm_rtc_device_register()
Applying: rtc: rtc-spear: use devm_rtc_device_register()
Applying: rtc: rtc-stk17ta8: use devm_rtc_device_register()
Applying: rtc: rtc-tps6586x: use devm_rtc_device_register()
Applying: rtc: rtc-tps65910: use devm_rtc_device_register()
Applying: rtc: rtc-tps80031: use devm_rtc_device_register()
Applying: rtc: rtc-tx4939: use devm_rtc_device_register()
Applying: rtc: rtc-vt8500: use devm_rtc_device_register()
Applying: rtc: rtc-wm831x: use devm_rtc_device_register()
Applying: below is the warning reported with the gcc (gcc (GCC) 4.7.2 20121=
109 (Red
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-tegra.c: protect suspend/resume callbacks with CO=
NFIG_PM_SLEEP
Applying: drivers/rtc/rtc-tegra.c: use struct dev_pm_ops for power manageme=
nt
Applying: drivers/rtc/rtc-tegra.c: set irq name as device name
Applying: drivers/rtc/rtc-tegra.c: use managed rtc_device_register()
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc: rtc-palmas: use devm_request_threaded_irq()
Applying: drivers/rtc/rtc-s3c.c: convert s3c_rtc to dev_pm_ops
Applying: rtc: rtc-ds1307: use dev_dbg() instead of pr_debug()
Applying: rtc: rtc-fm3130: use dev_dbg() instead of pr_debug()
Applying: rtc: rtc-ab3100: use devm_rtc_device_register()
Applying: rtc: rtc-au1xxx: use devm_rtc_device_register()
Applying: rtc: rtc-bq32k: use devm_rtc_device_register()
Applying: rtc: rtc-dm355evm: use devm_rtc_device_register()
Applying: rtc: rtc-ds1302: use devm_rtc_device_register()
Applying: rtc: rtc-ds1672: use devm_rtc_device_register()
Applying: rtc: rtc-ds3234: use devm_rtc_device_register()
Applying: rtc: rtc-efi: use devm_rtc_device_register()
Applying: rtc: rtc-em3027: use devm_rtc_device_register()
Applying: rtc: rtc-generic: use devm_rtc_device_register()
Applying: rtc: hid-sensor-time: use devm_rtc_device_register()
Applying: rtc: rtc-ls1x: use devm_rtc_device_register()
Applying: rtc: rtc-m41t93: use devm_rtc_device_register()
Applying: rtc: rtc-m41t94: use devm_rtc_device_register()
Applying: rtc: rtc-m48t86: use devm_rtc_device_register()
Applying: rtc: rtc-max6900: use devm_rtc_device_register()
Applying: rtc: rtc-max6902: use devm_rtc_device_register()
Applying: rtc: rtc-ps3: use devm_rtc_device_register()
Applying: rtc: rtc-r9701: use devm_rtc_device_register()
Applying: rtc: rtc-rc5t583: use devm_rtc_device_register()
Applying: rtc: rtc-rs5c313: use devm_rtc_device_register()
Applying: rtc: rtc-rv3029c2: use devm_rtc_device_register()
Applying: rtc: rtc-rx4581: use devm_rtc_device_register()
Applying: rtc: rtc-rx8581: use devm_rtc_device_register()
Applying: rtc: rtc-starfire: use devm_rtc_device_register()
Applying: rtc: rtc-sun4v: use devm_rtc_device_register()
Applying: rtc: rtc-test: use devm_rtc_device_register()
Applying: rtc: rtc-tile: use devm_rtc_device_register()
Applying: rtc: rtc-wm8350: use devm_rtc_device_register()
Applying: rtc: rtc-x1205: use devm_rtc_device_register()
Applying: rtc: rtc-at91rm9200: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-mxc: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-pxa: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-rc5t583: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-sa1100: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-sh: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-wm8350: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-tps6586x: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-tps65910: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-tps80031: switch to using SIMPLE_DEV_PM_OPS
Applying: hfsplus: fix warnings in fs/hfsplus/bfind.c
Applying: hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1s=
t_rec_by_cnid-fix
Applying: fat: introduce 2 new values for the -o nfs mount option
Applying: fat: move fat_i_pos_read to fat.h
Applying: fat: introduce a helper fat_get_blknr_offset()
Applying: fat: restructure export_operations
Applying: fat (exportfs): rebuild inode if ilookup() fails
Applying: fat (exportfs): rebuild directory-inode if fat_dget()
Applying: Documentation: update nfs option in filesystem/vfat.txt
Applying: ptrace: add ability to retrieve signals without removing from a q=
ueue (v4)
Applying: selftest: add a test case for PTRACE_PEEKSIGINFO
Applying: usermodehelper: export call_usermodehelper_exec() and call_usermo=
dehelper_setup()
Applying: usermodehelper-export-_exec-and-_setup-functions-fix
Applying: kmod: split call to call_usermodehelper_fns()
Applying: KEYS: split call to call_usermodehelper_fns()
Applying: coredump: remove trailling whitespace
Applying: usermodehelper: split remaining calls to call_usermodehelper_fns()
Applying: kmod: remove call_usermodehelper_fns()
Applying: coredump: only SIGKILL should interrupt the coredumping task
Applying: coredump: ensure that SIGKILL always kills the dumping thread
Applying: coredump: sanitize the setting of signal->group_exit_code
Applying: coredump: introduce dump_interrupted()
Applying: coredump: factor out the setting of PF_DUMPCORE
Applying: coredump: change wait_for_dump_helpers() to use wait_event_interr=
uptible()
Applying: procfs: improve scaling in proc
Applying: procfs-improve-scaling-in-proc-v5
Applying: set_task_comm: kill the pointless memset() + wmb()
Applying: kexec: fix wrong types of some local variables
Applying: kexec: Use min() and min_t() to simplify logic
Applying: kexec-use-min_t-to-simplify-logic-fix
Applying: ipc: clamp with min()
Applying: ipc: separate msg allocation from userspace copy
Applying: ipc: tighten msg copy loops
Applying: ipc: set EFAULT as default error in load_msg()
Applying: ipc: remove msg handling from queue scan
Applying: ipc: implement MSG_COPY as a new receive mode
Applying: ipc: simplify msg list search
Applying: ipc: refactor msg list search into separate function
Applying: ipc: find_msg can be static
Applying: ipc/msgutil.c: use linux/uaccess.h
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: drivers/char/hw_random/exynos-rng.c: add CONFIG_PM_SLEEP to suspe=
nd/resume functions
Applying: kernel/pid.c: improve flow of a loop inside alloc_pidmap.
Applying: kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix
Applying: pid_namespace.c/.h: simplify defines
Applying: pid_namespacec-h-simplify-defines-fix
Applying: raid6test: use prandom_bytes()
Applying: uuid: use prandom_bytes()
Applying: x86: pageattr-test: remove srandom32 call
Applying: x86: rename random32() to prandom_u32()
Applying: lib/: rename random32() to prandom_u32()
Applying: mm/: rename random32() to prandom_u32()
Applying: kernel/: rename random32() to prandom_u32()
Applying: drbd: rename random32() to prandom_u32()
Applying: infiniband: rename random32() to prandom_u32()
Applying: mmc: rename random32() to prandom_u32()
Applying: video/uvesafb: rename random32() to prandom_u32()
Applying: uwb: rename random32() to prandom_u32()
Applying: lguest: rename random32() to prandom_u32()
Applying: scsi: rename random32() to prandom_u32()
Applying: scsi: fix the wrong position of the comment
Applying: drivers/net: rename random32() to prandom_u32()
Applying: drivers-net-rename-random32-to-prandom_u32-fix
Applying: net/sunrpc: rename random32() to prandom_u32()
Applying: net/sched: rename random32() to prandom_u32()
Applying: net/netfilter: rename random32() to prandom_u32()
Applying: net/core: rename random32() to prandom_u32()
Applying: net/core: remove duplicate statements by do-while loop
Applying: net: rename random32 to prandom
Applying: remove unused random32() and srandom32()
Applying: semaphore: use unlikely() for down's timeout
Applying: semaphore: use `bool' type for semaphore_waiter's up
Applying: drivers/memstick/host/r592.c: make r592_pm_ops static
Applying: kernel/relay.c: remove unused function argument actor
Applying: kernel/relay.c: move FIX_SIZE macro into relay.c
Applying: mm: remove old aio use_mm() comment
Applying: aio: remove dead code from aio.h
Applying: gadget: remove only user of aio retry
Applying: aio: remove retry-based AIO
Applying: char: add aio_{read,write} to /dev/{null,zero}
Applying: aio: kill return value of aio_complete()
Applying: aio: add kiocb_cancel()
Applying: aio: move private stuff out of aio.h
Applying: aio: dprintk() -> pr_debug()
Applying: aio: do fget() after aio_get_req()
Applying: aio: make aio_put_req() lockless
Applying: aio: refcounting cleanup
Applying: wait: add wait_event_hrtimeout()
Applying: aio: make aio_read_evt() more efficient, convert to hrtimers
Applying: aio: use flush_dcache_page()
Applying: aio: use cancellation list lazily
Applying: aio: change reqs_active to include unreaped completions
Applying: aio: kill batch allocation
Applying: aio: kill struct aio_ring_info
Applying: aio: give shared kioctx fields their own cachelines
Applying: aio: reqs_active -> reqs_available
Applying: aio: percpu reqs_available
Applying: generic dynamic per cpu refcounting
Applying: aio: percpu ioctx refcount
Applying: aio: use xchg() instead of completion_lock
Applying: aio: don't include aio.h in sched.h
Applying: aio: kill ki_key
Applying: aio: kill ki_retry
Applying: block, aio: batch completion for bios/kiocbs
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: fix aio_read_events_ring() types
Applying: aio: document, clarify aio_read_events() and shadow_tail
Applying: aio: correct calculation of available events
Applying: aio: fix kioctx not being freed after cancellation at exit time
Applying: aio: fix ringbuffer calculation so we don't wrap
Applying: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Applying: kconfig-consolidate-config_debug_strict_user_copy_checks-fix
Applying: kconfig menu: move Virtualization drivers near other virtualizati=
on options
Applying: kernel/sys.c: make prctl(PR_SET_MM) generally available
Applying: decompressor: add LZ4 decompressor module
Applying: lib: add support for LZ4-compressed kernel
Applying: arm: add support for LZ4-compressed kernel
Applying: x86: add support for LZ4-compressed kernel
Applying: lib: add lz4 compressor module
Applying: crypto: add lz4 Cryptographic API
Merging akpm/master (7113718 crypto: add lz4 Cryptographic API)
[master 1fb2753] Revert "KVM: allow host header to be included even for !CO=
NFIG_KVM"

--Signature=_Thu__21_Mar_2013_17_38_32_+1100_VAP2BTfr0Udzzj2p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSqroAAoJEECxmPOUX5FEn6oP/3f0Dd/i/Cs/jIExGj5qqPM0
d6V5t/KJreYAvXv5RbFxqQ/PhIv2AjVRxCyfvIBPe2OvTcPxnghKifXrGyaYnxzA
jJJ9HGpbPOQl3i/W282xcRVWJ+m0gc0xxMTVkIL4Lr1b1kjrGDZKjCow3aGnmGHo
BjAb9f2k8/WkGyAlICa0BYdt3H3FyEYORaJcmOFZrobOUIaxSehKlQAkvrGeJKyI
73Jsod6WxMUwRfbzR5RFiaY7yc+P8pf7EWCOnUmdc2KLX+Ugm8l6PaCpR+JJ0lSU
P0p6yR0y1f+1v6luubEwUJo6wZRP1unJytaro1eZjqbMI7POzzQQkjQINSWto82H
20wVvsufWVz6Vom68j1y/t6KxNgjvPqO3Ptu8X0TjIh3q+gdPkYg1G0diGnkSTkh
vB5YAijKnRJ7vN93HHpWasBFsGHlgwmvZqmC0IYupEm5QzEWdEKMIkWDRNJ7tQp9
MnM4NrJixolrEBezG3s+VTgbPS5f3814DQXD2rGsiFi+seB6gE3QpxofGxehpdrZ
q7dGNbXB8kscqTYOwSQrbFJ2nVTMoiMc7yb+FmIHDKbkZLPLJgcfgpfmdvc+JSnQ
jDaQvIClCVLmh79AgfBOaFgv/F0ogu1araCA69ihLNxkKvWWQxfZWhD25XWR9SM/
sQxuINmBnyfxpImJ+F0o
=ZC0Q
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_17_38_32_+1100_VAP2BTfr0Udzzj2p--
