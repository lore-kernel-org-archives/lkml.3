Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049Ab3CGEHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 23:07:00 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52690 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3CGEG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 23:06:56 -0500
Date: Thu, 7 Mar 2013 15:06:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 7
Message-Id: <20130307150645.e4e23e69340c25b5d21b70e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Mar_2013_15_06_45_+1100_by4T.uP.U7Zjf6fG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Mar_2013_15_06_45_+1100_by4T.uP.U7Zjf6fG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130306:

The staging tree lost its build failure.

The gpio tree still had its build failure for which I reverted a commit.

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

We are up to 217 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (9f22578 Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arm-current/fixes (3f7d1fe ARM: 7665/1: Wire up kcmp syscall)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (54c9b225 powerpc: Set DSCR bit in FSCR setup)
Merging sparc/master (a295642 sparc,leon: fix GRPCI2 device0 PCI config spa=
ce access)
Merging net/master (f8af75f tun: add a missing nf_reset() in tun_net_xmit())
Merging ipsec/master (85dfb74 af_key: initialize satype in key_notify_polic=
y_flush())
Merging sound-current/for-linus (85c50a5 ALSA: seq: seq_oss_event: missing =
range checks)
Merging pci-current/for-linus (249bfb8 PCI/PM: Clean up PME state when remo=
ving a device)
Merging wireless/master (930df2d Merge branch 'for-davem' of git://git.kern=
el.org/pub/scm/linux/kernel/git/linville/wireless)
Merging driver-core.current/driver-core-linus (6dbe51c Linux 3.9-rc1)
Merging tty.current/tty-linus (34dcfb8 TTY: disable debugging warning)
Merging usb.current/usb-linus (feca774 USB: EHCI: don't check DMA values in=
 QH overlays)
Merging staging.current/staging-linus (1223ad3 Merge tag 'iio-fixes-for-3.9=
a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-=
linus)
Merging char-misc.current/char-misc-linus (6dbe51c Linux 3.9-rc1)
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
Merging gpio-current/gpio/merge (e97f9b5 gpio/gpio-ich: fix ichx_gpio_check=
_available() return what callers expect)
Merging rr-fixes/fixes (f7f154f hw_random: make buffer usable in scatterlis=
t.)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (672bce9 ARC: Remove duplicate inclusion of header fil=
es)
Merging arm/for-next (3f7d1fe ARM: 7665/1: Wire up kcmp syscall)
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
Merging m68knommu/for-next (7538a2c m68k: drop "select EMAC_INC")
Merging metag/for-next (c60ac31 metag: Provide dma_get_sgtable())
Merging microblaze/next (a7c1120 Merge tag 'ext4_for_linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging mips/mips-for-linux-next (19aa5ac Merge branch 'master' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/torvalds/linux into mips-for-linux-ne=
xt)
Merging openrisc/for-upstream (545ebd0 openrisc: require gpiolib)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (9e2d59a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/signal)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (6dbe51c Linux 3.9-rc1)
Merging galak/next (12c7e8f powerpc/85xx: l2sram - Add compatible string fo=
r BSC9131 platform)
Merging s390/features (460f0c0 s390/pci: use kmem_cache_zalloc instead of k=
mem_cache_alloc/memset)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (ecc46c5 tile: support atomic64_dec_if_positive())
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (9cf81c7 xtensa: add accept4 syscall)
Merging btrfs/next (6aec51f Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into for-linus-3.9)
Merging ceph/master (83ca14f libceph: add support for HASHPSPOOL pool flag)
Merging cifs/for-next (6dbe51c Linux 3.9-rc1)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (290502b eCryptfs: allow userspace messaging to be di=
sabled)
Merging ext3/for_next (712ddc5 Ext2: remove the static function release_blo=
cks to optimize the kernel)
Merging ext4/dev (6ca470d7 ext4: invalidate extent status tree during exten=
t migration)
Merging f2fs/dev (7dd690c f2fs: avoid build warning)
Merging fuse/for-next (634734b fuse: allow control of adaptive readdirplus =
use)
Merging gfs2/master (9c0c039 GFS2: use kmalloc for lvb bitmap)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (6dbe51c Linux 3.9-rc1)
Merging nfsd/nfsd-next (dc10740 SUNRPC: make AF_LOCAL connect synchronous)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
Merging ubifs/linux-next (8afd500 UBIFS: fix double free of ubifs_orphan ob=
jects)
Merging xfs/for-next (6dbe51c Linux 3.9-rc1)
Merging vfs/for-next (dcf787f constify path_get/path_put and fs_struct.c st=
uff)
Merging pci/next (018ba0a Merge branch 'pci/yinghai-root-bus-hotplug' into =
next)
Merging hid/for-next (506bc34 Merge branches 'for-3.10/hid-driver-transport=
-cleanups' and 'for-3.10/logitech' into for-next)
Merging i2c/i2c/for-next (21ea3f4 i2c: core: Pick i2c bus number from dt al=
ias if present)
Merging jdelvare-hwmon/master (2a7d2b9 Merge branch 'akpm' (final batch fro=
m Andrew))
Merging hwmon-staging/hwmon-next (2bed34b hwmon: (mc13783-adc.c) use module=
_platform_driver_probe())
Merging v4l-dvb/master (eccaaad Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (4382a99 Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (b186aff pata_samsung_cf: use module_platform_driver_pr=
obe())
Merging infiniband/for-next (ef4e359 Merge branches 'core', 'cxgb4', 'ipoib=
', 'iser', 'misc', 'mlx4', 'qib' and 'srp' into for-next)
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging pm/linux-next (6bd5165 Merge branch 'pm-fixes' into fixes)
Merging idle/next (ca62cf5 Merge branch 'misc' into release)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (f5b6d45 thermal: rcar: remove __devinitconst)
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (19f949f Linux 3.8)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (6dbe51c Linux 3.9-rc1)
Merging target-updates/for-next (2dbe10a target/pscsi: Rename sg_num to nr_=
vecs in pscsi_get_bio())
Merging target-merge/for-next-merge (d1c3ed6 Linux 3.8-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (90872c6 Merge branch 'for-linus' into next)
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (6906f4e htb: add HTB_DIRECT_QLEN attribute)
Merging ipsec-next/master (6fac411 bnx2x: use the default NAPI weight)
Merging wireless-next/master (7da060c mwifiex: add WOWLAN support)
Merging bluetooth/master (114d204 Bluetooth: Remove empty HCI event handler=
s)
CONFLICT (content): Merge conflict in net/bluetooth/rfcomm/core.c
Merging mtd/master (48476df Merge tag 'for-linus-20130301' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (aa38329 mtd: nand: provision full ID support)
Merging crypto/master (7eb9c5d crypto: caam - Added property fsl,sec-era in=
 SEC4.0 device tree binding.)
Merging drm/drm-next (be88298 drm/tilcdc: only build on arm)
Merging drm-intel/drm-intel-next-queued (35aad75 drm/i915/dp: add pre-PCH e=
DP checking to DP detect for VLV)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_sdvo.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_hdmi.c
Merging sound/for-next (f1f6b8f ALSA: snd-usb-caiaq: switch to dev_*() logg=
ing)
Merging sound-asoc/for-next (0a2fbbc Merge remote-tracking branch 'asoc/top=
ic/wm8960' into asoc-next)
Merging modules/modules-next (6dbe51c Linux 3.9-rc1)
Merging pekey/devel-pekey (4ea349d MODSIGN: Fix including certificate twice=
 when the signing_key.x509 already exists)
Merging virtio/virtio-next (6dbe51c Linux 3.9-rc1)
Merging input/next (005a69d Input: cyttsp-spi - remove duplicate MODULE_ALI=
AS())
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (ff794de cpuset: remove include of cgroup.h from cp=
uset.h)
Merging block/for-next (833dd2e Merge branch 'for-3.9/drivers' into for-nex=
t)
Merging device-mapper/master (28467d5 We have found a race in the optimisat=
ion used in the dm cache writethrough implementation.  Currently, dm core s=
ends the cache target two bios, one for the origin device and one for the c=
ache device and these are processed in parallel.  This patch avoids the rac=
e by changing the code back to a simpler (slower) implementation which proc=
esses the two writes in series, one after the other, until we can find a co=
mplete fix for the problem.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (5ebf255 mmc: sdhci-tegra: add basic support for Tegra=
114)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (7d557b3 slub: correctly bootstrap boot caches)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
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
Merging regulator/for-next (92f9a87 Merge remote-tracking branch 'regulator=
/topic/enable-invert' into regulator-next)
Merging security/next (5b26603 tpm/ibmvtpm: build only when IBM pseries is =
configured)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (6595dfb Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/torvalds/linux)
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
Merging edac-amd/for-next (fbe2d36 EDAC: Make sysfs functions static)
Merging devicetree/devicetree/next (02bbde7 Revert "of: use platform_device=
_add")
Merging dt-rh/for-next (1421954 documentation/devicetree: Fix a typo in exy=
nos-dw-mshc.txt)
Merging spi/spi/next (095c375 spi: Document cs_gpios and cs_gpio in kernel-=
doc)
Merging spi-mb/spi-next (468050c spi: fix return value check in ce4100_spi_=
probe())
Merging tip/auto-latest (641e71a Merge branch 'x86/urgent')
CONFLICT (content): Merge conflict in arch/x86/include/asm/pgtable.h
Merging ftrace/for-next (cb0c38e tracing: Fix some section mismatch warning=
s)
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
Merging xen-two/linux-next (0e07643 x86/xen: remove depends on CONFIG_EXPER=
IMENTAL)
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
Merging regmap/for-next (d04f1a3 Merge remote-tracking branch 'regmap/topic=
/range' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (4b07c5d leds: leds-sunfire: use dev_err()/pr_err() i=
nstead of printk())
Merging driver-core/driver-core-next (6dbe51c Linux 3.9-rc1)
Merging tty/tty-next (6dbe51c Linux 3.9-rc1)
Merging usb/usb-next (6dbe51c Linux 3.9-rc1)
Merging usb-gadget/next (6dbe51c Linux 3.9-rc1)
Merging staging/staging-next (e9f5b81 staging: android: ashmem: Add support=
 for 32bit ashmem calls in a 64bit kernel)
Merging char-misc/char-misc-next (6dbe51c Linux 3.9-rc1)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (1bfc0da Merge branch 'devel' into for-next)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (7ff2db4 gpio/em: Add Device Tree support)
[master db2ed29] Revert "gpio/palmas: add in GPIO support for palmas charge=
r"
Merging gpio-lw/for-next (c7886b1 gpio: em: Use irq_domain_add_simple() to =
fix runtime error)
Merging arm-soc/for-next (e33a4ed Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (836dc9e Linux 3.8-rc7)
Merging cortex/for-next (6ebd4d0 ARM: stub out read_cpuid and read_cpuid_ex=
t for CPU_CP15=3Dn)
CONFLICT (content): Merge conflict in arch/arm/include/asm/cputype.h
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (6f09953 Merge branch 'msm-defconfig' into for-next)
Merging renesas/next (8f2468b Merge branches 'heads/defconfig', 'heads/boar=
ds3', 'heads/pfc' and 'heads/clocksource' into next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
Merging samsung/for-next (d22d20e Merge branch 'next/pinctrl-exynos' into f=
or-next)
Merging tegra/for-next (1e9b4f4 Merge branch 'for-3.10/dt' into for-next)
Merging dma-mapping/dma-mapping-next (6dbe51c Linux 3.9-rc1)
Merging pwm/for-next (a32e1d1 pwm_backlight: remove unnecessary ifdefs)
Merging dma-buf/for-next (6dbe51c Linux 3.9-rc1)
Merging userns/for-next (7f78e03 fs: Limit sys_mount to only request filesy=
stem modules.)
Merging ktest/for-next (7328735 ktest: Remove indexes from warnings check)
Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of=
 macros)
Merging clk/clk-next (fde8bc5 clk: sunxi: remove stale Makefile entry)
Merging random/dev (6133705 random: Mix cputime from each thread that exits=
 to the pool)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging modem_shm/remoteproc-next (c68dc8d remoteproc: Always perserve reso=
urce table data)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (b0af9cd Merge tag 'lzo-update-signature-20130=
226' of git://github.com/markus-oberhumer/linux)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: ipc: fix potential oops when src msg > 4k w/ MSG_COPY
Applying: ipc: don't allocate a copy larger than max
Applying: mm/mempolicy.c: fix wrong sp_node insertion
Applying: mm/mempolicy.c: fix sp_node_init() argument ordering
Applying: shmem: fix build regression
Applying: shmem-fix-build-regression-fix
Applying: idr: remove WARN_ON_ONCE() on negative IDs
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: drivers/platform/x86/thinkpad_acpi.c: move hotkey_thread_mutex lo=
ck after set_freezable()
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: matroxfb: convert struct i2c_msg initialization to C99 format
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timer_list: split timer_list_show_tickdevices()
Applying: timer_list-split-timer_list_show_tickdevices-v4
Applying: timer_list: convert timer list to be a proper seq_file
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix
Applying: mkcapflags.pl: convert to mkcapflags.sh
Applying: headers_install.pl: convert to headers_install.sh
Applying: scripts/decodecode: make faulting insn ptr more robust
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: debug_locks.h: make warning more verbose
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
Applying: mm, show_mem: suppress page counts in non-blockable contexts
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
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: drivers/video/backlight/ams369fg06.c: convert ams369fg06 to dev_p=
m_ops
Applying: drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_=
ops-fix
Applying: drivers/video/backlight/platform_lcd.c: remove unnecessary ifdefs
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/int_sqrt.c: optimize square root algorithm
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
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
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc: rtc-palmas: use devm_request_threaded_irq()
Applying: coredump: only SIGKILL should interrupt the coredumping task
Applying: coredump: ensure that SIGKILL always kills the dumping thread
Applying: coredump: sanitize the setting of signal->group_exit_code
Applying: coredump: factor out the setting of PF_DUMPCORE
Applying: freezer: do not send a fake signal to a PF_DUMPCORE thread
Applying: coredump: make wait_for_dump_helpers() freezable
Applying: procfs: improve scaling in proc
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
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: semaphore: use unlikely() for down's timeout
Applying: semaphore: use `bool' type for semaphore_waiter's up
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
Applying: conversion to bio batch completion
Applying: aio: fix aio_read_events_ring() types
Applying: aio: document, clarify aio_read_events() and shadow_tail
Applying: aio: correct calculation of available events
Applying: aio: fix kioctx not being freed after cancellation at exit time
Applying: aio: v3: fix kioctx not being freed after cancellation at exit ti=
me
Applying: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Applying: kernel/sys.c: make prctl(PR_SET_MM) generally available
Merging akpm/master (df2363d kernel/sys.c: make prctl(PR_SET_MM) generally =
available)

--Signature=_Thu__7_Mar_2013_15_06_45_+1100_by4T.uP.U7Zjf6fG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJROBJVAAoJEECxmPOUX5FEPr4QAI+SVaTcBtl4dp/PP3kZ9NML
aWoasx2pMFkbvCev0KNAl+U3PoXtVgf2NU63Wp/0lZTyIRMwdGjpAhw6H44gbxFx
piACg2UNYMg3rzctwGKOTlNe3ZxFJ1Vg3wHVK5bgh5GOJBQlu4YwEgsjxnYXmkqO
VjyhMSbo8SRnCaljnnlu+p9rdGk652y1mvHr9moWBP7hIAe96La0lGiOo2aJ3LFr
qSNZBwVb/hBlBGS+8gbjR8WJGTT+vJoS04Mk/uqLoOFdVVoju08gsmsEdSXrIHg9
J1YQB21Fh+g3DXBafH2s4969g7LwkmQFuJHyaPMnt06dzI+E9//FHpTEN0Hko+By
8uApDE4JiX4bXMiHD0xpmYYmMXeeOPSy23pg4vziEW+headTeMcK4QTj9ku2fsjA
jYUrXUEWArTJgkxeyPcO4ACVrEIGy8y2MLB7SSiYWj3LTUMVNdWo/iUqbhPij8uf
ZIsYectzwAjGYRVgq5A6NiJ1nBOefQXIlzBRBLRmEG2/jQCvVGTJEViE0JwJfE/q
xmsiMUFitxFGeIsu9PGNWf5kOfyZfv71b8HtLo22dftLD4XZdnZjy4zEbB5rqm2y
xKvFNQAgxjhBfFyv1d9/nPgA2uGypj4iKZcNxpnQQGP2bz3eCkefsoMRDVDaRehj
PWaRr0Mi1RoDjWFrZ4+n
=fyBK
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Mar_2013_15_06_45_+1100_by4T.uP.U7Zjf6fG--
