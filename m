Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab3CMFsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:48:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54587 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3CMFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:48:34 -0400
Date: Wed, 13 Mar 2013 16:48:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Mar 13
Message-Id: <20130313164832.11bb0e44f6757b4a77d81b1c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Mar_2013_16_48_32_+1100_0+2v.zsDTQvwTFNa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Mar_2013_16_48_32_+1100_0+2v.zsDTQvwTFNa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130312:

The input tree lost its build failure.

The net-next tree lost its conflict.

The drm-intel still had its build failure for which I reverted a commit.

The trivial tree gained a conflict against the virtio tree.

The gpio tree still had its build failure for which I reverted a commit.

The cgroup tree gained a build failure for which I reverted a commit.

The staging tree gained a build failure for which I applied a patch.

The akpm tree gained a conflicts against the workqueues and rcu trees.

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
Merging origin/master (4febd95 Select VIRT_TO_BUS directly where needed)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arc-current/for-curr (180d406 ARC: ABIv3: fork/vfork wrappers not n=
eeded in "no-legacy-syscall" ABI)
Merging arm-current/fixes (418df63a ARM: 7670/1: fix the memset fix)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (54c9b225 powerpc: Set DSCR bit in FSCR setup)
Merging sparc/master (76950e6 sparc64: correctly recognize SPARC64-X chips)
Merging net/master (c80a851 net/core: move vlan_depth out of while loop in =
skb_network_protocol())
Merging ipsec/master (85dfb74 af_key: initialize satype in key_notify_polic=
y_flush())
Merging sound-current/for-linus (281a6ac ALSA: usb-audio: add a workaround =
for the NuForce UDH-100)
Merging pci-current/for-linus (249bfb8 PCI/PM: Clean up PME state when remo=
ving a device)
Merging wireless/master (de12198 Merge tag 'nfc-fixes-3.9-1' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes)
Merging driver-core.current/driver-core-linus (f6161aa Linux 3.9-rc2)
Merging tty.current/tty-linus (c51d41a tty: serial: fix typo "SERIAL_S3C241=
2")
Merging usb.current/usb-linus (c0f5ece USB: cdc-wdm: fix buffer overflow)
Merging staging.current/staging-linus (564c526 staging: comedi: dt9812: use=
 CR_CHAN() for channel number)
Merging char-misc.current/char-misc-linus (3d374d0 final removal of CONFIG_=
EXPERIMENTAL)
Merging input-current/for-linus (4b7d293 Input: mms114 - Fix regulator enab=
le and disable paths)
Merging md-current/for-linus (f3378b4 md: expedite metadata update when swi=
tching  read-auto -> active)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (8fd61d3 crypto: user - ensure user supplied =
strings are nul-terminated)
Merging ide/master (bf6b438 ide: gayle: use module_platform_driver_probe())
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
Merging rr-fixes/fixes (5c119c5 Revert "virtio_console: Initialize guest_co=
nnected=3Dtrue for rproc_serial")
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (fcf0c3d ARC: Remove duplicate inclusion of header fil=
es)
Merging arm/for-next (f4bea8b Merge branches 'devel-stable' and 'fixes' int=
o for-next)
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
Merging metag/for-next (40f09f3 metag: Inhibit NUMA balancing.)
Merging microblaze/next (c9c1f3c microblaze/PCI: remove duplicated include =
from pci-common.c)
Merging mips/mips-for-linux-next (f4cdb6a MIPS: SEAD3: Enable LL/SC.)
Merging openrisc/for-upstream (545ebd0 openrisc: require gpiolib)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (9e2d59a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/signal)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (6dbe51c Linux 3.9-rc1)
Merging galak/next (19c29f1 powerpc/85xx: add CONFIG_E1000E to corenet64_sm=
p_defconfig)
Merging s390/features (043f620 s390/monreader: Remove redundant NULL check =
before kfree)
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
Merging ceph/master (d6c0dd6 libceph: fix decoding of pgids)
Merging cifs/for-next (7c6baa3 Merge branch 'perf-urgent-for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
Merging ext3/for_next (af591ad reiserfs: Use kstrdup instead of kmalloc/str=
cpy)
Merging ext4/dev (e23bf97 ext4: use s_extent_max_zeroout_kb value as number=
 of kb)
Merging f2fs/dev (330900b f2fs: avoid extra ++ while returning from get_nod=
e_path)
Merging fuse/for-next (634734b fuse: allow control of adaptive readdirplus =
use)
Merging gfs2/master (4d16e2c GFS2: return error if malloc failed in gfs2_rs=
_alloc())
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
Merging ubifs/linux-next (8afd500 UBIFS: fix double free of ubifs_orphan ob=
jects)
Merging xfs/for-next (9e5987a xfs: rearrange some code in xfs_bmap for bett=
er locality)
Merging vfs/for-next (dcf787f constify path_get/path_put and fs_struct.c st=
uff)
Merging pci/next (f6161aa Linux 3.9-rc2)
Merging hid/for-next (e618f2e Merge branch 'for-3.10/hid-driver-transport-c=
leanups' into for-next)
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
Merging pm/linux-next (6348aa0 Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
Merging idle/next (ca62cf5 Merge branch 'misc' into release)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (043e465 thermal: exynos_thermal: return a proper erro=
r code while thermal_zone_device_register fail.)
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
Merging slave-dma/next (ca85cb8 Merge branch 'for-linus' into next)
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (c1ad32a ks8851_mll: basic ethernet statistics)
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (c3f251a mwl8k: don't overwrite regulatory set=
tings on fw reload)
CONFLICT (content): Merge conflict in net/nfc/llcp/llcp.c
Merging bluetooth/master (ad82cdd Bluetooth: Fix endianness handling of cmd=
_status/complete opcodes)
Merging mtd/master (91d542f mtd: bcm47xxpart: look for NVRAM at the end of =
device)
Merging l2-mtd/master (a70c811 mtd: devices: elm: check for device's presen=
ce before configuration)
Merging crypto/master (6375bcf hwrng: Fix a wrong comment in Documentation/=
hw_random.txt)
Merging drm/drm-next (be88298 drm/tilcdc: only build on arm)
Merging drm-intel/drm-intel-next-queued (99e35fd drm/i915: clarify reasonin=
g for the access_ok call)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_sdvo.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_hdmi.c
[master edb6cc4] Revert "drm/i915: use simple attribute in debugfs routines"
Merging sound/for-next (eb7c06e ALSA: add/change some comments describing f=
unction return values)
Merging sound-asoc/for-next (c1e7c13 Merge remote-tracking branch 'asoc/top=
ic/wm8960' into asoc-next)
Merging modules/modules-next (6dbe51c Linux 3.9-rc1)
Merging pekey/devel-pekey (4ea349d MODSIGN: Fix including certificate twice=
 when the signing_key.x509 already exists)
Merging virtio/virtio-next (29266e2 Remove Documentation/virtual/virtio-spe=
c.txt)
Merging input/next (1614265 USB: cdc-acm - blacklist IMS PCU device)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (86b5cb4 cgroup: fix an off-by-one bug which may tr=
igger BUG_ON())
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
Merging mmc/mmc-next (9665f7f mmc: dw_mmc: Make dw_mci_exynos_probe static)
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
Merging regulator/for-next (457e7a4 Merge remote-tracking branch 'regulator=
/topic/tps6586x' into regulator-next)
Merging security/next (2c4cdf5 Merge tag 'v3.9-rc2' into next)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (a4f0685 watchdog: sp5100_tco: Set the AcpiMmioSel =
bitmask value to 1 instead of 2)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (ae19158 iommu: OMAP: build only on OMAP2+)
Merging vfio/next (dad9f89 VFIO-AER: Vfio-pci driver changes for supporting=
 AER)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (d097dda doc: virtual: Fix typos in virtio-spec.tx=
t)
CONFLICT (modify/delete): Documentation/virtual/virtio-spec.txt deleted in =
HEAD and modified in trivial/for-next. Version trivial/for-next of Document=
ation/virtual/virtio-spec.txt left in tree.
$ git rm -f Documentation/virtual/virtio-spec.txt
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
Merging spi-mb/spi-next (b66c773 spi/bcm63xx: use devm_ioremap_resource())
Merging tip/auto-latest (c56c948 Merge branch 'x86/paravirt')
Merging ftrace/for-next (2227b79 tracing: Fix the branch tracer that broke =
with buffer change)
Merging rcu/rcu/next (53bbeb2 Merge branches 'doc.2013.03.12a', 'fixes.2013=
.03.12a' and 'idlenocb.2013.03.12a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (5da5960 KVM: MMU: Introduce a helper function for F=
IFO zapping)
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
Merging workqueues/for-next (e2cdb2c Merge branch 'for-3.10-async' into for=
-next)
Merging drivers-x86/linux-next (e6e5224 ideapad-laptop: Depend on BACKLIGHT=
_CLASS_DEVICE instead of selecting it)
CONFLICT (content): Merge conflict in drivers/platform/x86/chromeos_laptop.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (98c2b9c Merge remote-tracking branch 'regmap/topic=
/range' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (9d5ebeb leds: wm8350: Complain if we fail to reenabl=
e DCDC)
Merging driver-core/driver-core-next (f6161aa Linux 3.9-rc2)
Merging tty/tty-next (f6161aa Linux 3.9-rc2)
Merging usb/usb-next (f6161aa Linux 3.9-rc2)
Merging usb-gadget/next (6dbe51c Linux 3.9-rc1)
Merging staging/staging-next (ca4d4aa staging: comedi: ni_atmio: fix build =
errors)
Merging char-misc/char-misc-next (388f7bd w1: mxc_w1: Convert to devm_iorem=
ap_resource())
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (cac7a14 Merge branch 'devel' into for-next)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (7ff2db4 gpio/em: Add Device Tree support)
[master 589673a] Revert "gpio/palmas: add in GPIO support for palmas charge=
r"
Merging gpio-lw/for-next (c7886b1 gpio: em: Use irq_domain_add_simple() to =
fix runtime error)
Merging arm-soc/for-next (7b59496 Merge tag 'davinci-for-v3.9-rc/fixes' of =
git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci into fi=
xes)
Merging bcm2835/for-next (905f767 Merge branch 'for-3.10/defconfig' into fo=
r-next)
Merging cortex/for-next (6ebd4d0 ARM: stub out read_cpuid and read_cpuid_ex=
t for CPU_CP15=3Dn)
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (5bc31f8 Merge branch 'msm-defconfig' into for-next)
Merging renesas/next (d34cef5 Merge branches 'heads/defconfig', 'heads/boar=
ds3', 'heads/clocksource' and 'heads/intc-external-irq' into next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
Merging samsung/for-next (9daee5a Merge branch 'next/clk-exynos' into for-n=
ext)
Merging tegra/for-next (c4b5dde Merge branch 'for-3.10/dt' into for-next)
Merging dma-mapping/dma-mapping-next (cb6aefc ARM: DMA-mapping: add missing=
 GFP_DMA flag for atomic buffer allocation)
Merging pwm/for-next (a32e1d1 pwm_backlight: remove unnecessary ifdefs)
Merging dma-buf/for-next (6dbe51c Linux 3.9-rc1)
Merging userns/for-next (3e64fe5 fs: Limit sys_mount to only request filesy=
stem modules. (Part 3))
Merging ktest/for-next (7328735 ktest: Remove indexes from warnings check)
Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of=
 macros)
CONFLICT (content): Merge conflict in arch/tile/kernel/compat.c
CONFLICT (content): Merge conflict in arch/tile/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
Merging clk/clk-next (fde8bc5 clk: sunxi: remove stale Makefile entry)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (9f22578 Merge branch 'merge' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/benh/powerpc)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: include/linux/res_counter.h needs errno.h
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: thinkpad-acpi: kill hotkey_thread_mutex
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: matroxfb: convert struct i2c_msg initialization to C99 format
Applying: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_r=
esource()
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
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
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
Applying: zcache/tmem: Better error checking on frontswap_register_ops retu=
rn value.
Applying: staging: zcache: enable ramster to be built/loaded as a module
Applying: staging: zcache: enable zcache to be built/loaded as a module
Applying: rmap: recompute pgoff for unmapping huge page
Applying: memblock: add assertion for zero allocation alignment
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
Applying: printk/tracing: rework console tracing
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
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/int_sqrt.c: optimize square root algorithm
Applying: epoll: trim epitem by one cache line
Applying: epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()
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
Applying: rtc: rtc-tegra: use devm_rtc_device_register()
Applying: rtc: rtc-tps6586x: use devm_rtc_device_register()
Applying: rtc: rtc-tps65910: use devm_rtc_device_register()
Applying: rtc: rtc-tps80031: use devm_rtc_device_register()
Applying: rtc: rtc-tx4939: use devm_rtc_device_register()
Applying: rtc: rtc-vt8500: use devm_rtc_device_register()
Applying: rtc: rtc-wm831x: use devm_rtc_device_register()
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc: rtc-palmas: use devm_request_threaded_irq()
Applying: hfsplus: fix warnings in fs/hfsplus/bfind.c
Applying: hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1s=
t_rec_by_cnid-fix
Applying: ptrace: add ability to retrieve signals without removing from a q=
ueue (v4)
Applying: selftest: add a test case for PTRACE_PEEKSIGINFO
Applying: coredump: only SIGKILL should interrupt the coredumping task
Applying: coredump: ensure that SIGKILL always kills the dumping thread
Applying: coredump: sanitize the setting of signal->group_exit_code
Applying: coredump: factor out the setting of PF_DUMPCORE
Applying: freezer: do not send a fake signal to a PF_DUMPCORE thread
Applying: coredump: make wait_for_dump_helpers() freezable
Applying: procfs: improve scaling in proc
Applying: procfs-improve-scaling-in-proc-v5
Applying: kexec: fix wrong types of some local variables
Applying: kexec: Use min() and min_t() to simplify logic
Applying: kexec-use-min_t-to-simplify-logic-fix
Applying: nfsd: remove unused get_new_stid()
Applying: nfsd: convert to idr_alloc()
Applying: workqueue: convert to idr_alloc()
CONFLICT (content): Merge conflict in kernel/workqueue.c
Applying: mlx4: remove leftover idr_pre_get() call
Applying: zcache: convert to idr_alloc()
Applying: tidspbridge: convert to idr_alloc()
Applying: idr: deprecate idr_pre_get() and idr_get_new[_above]()
Applying: ipc: clamp with min()
Applying: ipc: separate msg allocation from userspace copy
Applying: ipc: tighten msg copy loops
Applying: ipc: set EFAULT as default error in load_msg()
Applying: ipc: remove msg handling from queue scan
Applying: ipc: implement MSG_COPY as a new receive mode
Applying: ipc: simplify msg list search
Applying: ipc: refactor msg list search into separate function
Applying: ipc/msgutil.c: use linux/uaccess.h
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: pid_namespace.c/.h: simplify defines
Applying: pid_namespacec-h-simplify-defines-fix
Applying: raid6test: use prandom_bytes()
Applying: uuid: use prandom_bytes()
Applying: x86: pageattr-test: remove srandom32 call
Applying: x86: rename random32() to prandom_u32()
Applying: lib/: rename random32() to prandom_u32()
Applying: mm/: rename random32() to prandom_u32()
Applying: kernel/: rename random32() to prandom_u32()
CONFLICT (content): Merge conflict in kernel/rcutree.c
Applying: drbd: rename random32() to prandom_u32()
Applying: infiniband: rename random32() to prandom_u32()
Applying: mmc: rename random32() to prandom_u32()
Applying: video/uvesafb: rename random32() to prandom_u32()
Applying: uwb: rename random32() to prandom_u32()
Applying: lguest: rename random32() to prandom_u32()
Applying: scsi: rename random32() to prandom_u32()
Applying: drivers/net: rename random32() to prandom_u32()
Applying: drivers-net-rename-random32-to-prandom_u32-fix
Applying: net/sunrpc: rename random32() to prandom_u32()
Applying: net/sched: rename random32() to prandom_u32()
Applying: net/netfilter: rename random32() to prandom_u32()
Applying: net/core: rename random32() to prandom_u32()
Applying: net/core: remove duplicate statements by do-while loop
Applying: net: rename random32 to prandom
Applying: remove unused random32() and srandom32()
Applying: futex: fix kernel-doc notation and spello
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
Applying: decompressor: add LZ4 decompressor module
Applying: lib: add support for LZ4-compressed kernel
Applying: arm: add support for LZ4-compressed kernel
Applying: x86: add support for LZ4-compressed kernel
Merging akpm/master (47bab4e x86: add support for LZ4-compressed kernel)
[master 35139a1] Revert "cgroup: remove unneeded includes from cgroup.h"
Applying: staging: the DWC2 driver uses bus_to_virt

--Signature=_Wed__13_Mar_2013_16_48_32_+1100_0+2v.zsDTQvwTFNa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQBMwAAoJEECxmPOUX5FEfNUP/1jZ8uFOertnXpRzi9QPrp2V
djvp9gOJ9+15YMa6Ppc6tu/Kpwp20/KtUMGuX9KXVkdOZwNc7s7z2Zr19KWjnehe
8borUQAm4ad4McYA2F6/FXdt3z+2EpeBhaeUv97BCjECvwhVJh2e1RPJKScgT2TG
mewMjBCwzQLcvzhI0K50hdjxppOHPC1KubmzC9ImaoC4jQ/iSiqHn6Sf0pvudAUT
i8I2e/TG0c47yiPT+ZI5LrnQGdHecMCJx1gnBeDAKposFqa6vS/tmFZGXNhjs7sc
UyP2SybjB8DROyPxRqyD5f8rUr1Le1gNWK6YQyny5XWbMUviHIlFukxqkdZt1sqx
wsvnvjh1QUBieguLgsQ7qQWFiBvhwbXEcIdgPA0hTot8jQUIPpDdi/phP5+/SD4W
2fsB/ghQmK4bm5HSXKlV2hbQS2fM1iUPvyxN+Pi9L7Vjex9qR53IvouEXNKUHwGp
TL40c30n0DeMB8O3yLYZqHSB9Kxw0tjiMJc/mVCm5TG2jQLPzQKQMNsFaHXOPZFn
Ht30zfS5sYeMwhNbfUX6HOIrN4fingnfLOcvUNoON2xOhqviCZ86OqLGdR6TWO7L
t+mfmglVh31eB6JzFR3PSObWBTTH9sgYK65ryML3lK6PFt60YmQx5dNEcaw1HPyn
5gHZCvrlYRolrZ+8wC1n
=Jrbx
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Mar_2013_16_48_32_+1100_0+2v.zsDTQvwTFNa--
