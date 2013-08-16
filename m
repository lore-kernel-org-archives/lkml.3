Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3HPHQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:16:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3HPHQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:16:46 -0400
Date: Fri, 16 Aug 2013 17:16:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 16
Message-Id: <20130816171634.8cb22a8f67d6dce8669d9899@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Aug_2013_17_16_34_+1000_MZrsP1hvkgbhJ6iK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Aug_2013_17_16_34_+1000_MZrsP1hvkgbhJ6iK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130815:

The dlm tree gained a conflict against Linus' tree.

The akpm-current tree gained a build failure for which I applied a patch
and another for which I reverted a commit.

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
Merging origin/master (f1d6e17 Merge branch 'akpm' (patches from Andrew Mor=
ton))
Merging fixes/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (c095ba7 Linux 3.11-rc4)
Merging arm-current/fixes (2a28224 Merge branch 'security-fixes' into fixes)
CONFLICT (content): Merge conflict in arch/arm/kernel/perf_event.c
Merging m68k-current/for-linus (ea077b1 m68k: Truncate base in do_div())
Merging metag-fixes/fixes (dfe248b MAINTAINERS: add linux-metag mailing lis=
t)
Merging powerpc-merge/merge (28e61cc powerpc/tm: Fix context switching TAR,=
 PPR and DSCR SPRs)
Merging sparc/master (1c2696c sparc64: Fix ITLB handler of null page)
Merging net/master (0a324f3 net/mlx5_core: Support MANAGE_PAGES and QUERY_P=
AGES firmware command changes)
Merging ipsec/master (0ea9d5e xfrm: introduce helper for safe determination=
 of mtu)
Merging sound-current/for-linus (f85a659 Merge tag 'asoc-v3.11-rc5' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (36dd1f3 PCI: mvebu: Disable prefetchable mem=
ory support in PCI-to-PCI bridge)
Merging wireless/master (48c3e37 Merge branch 'for-john' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (5ae90d8 Linux 3.11-rc3)
Merging tty.current/tty-linus (c095ba7 Linux 3.11-rc4)
Merging usb.current/usb-linus (ff8a43c USB: keyspan: fix null-deref at disc=
onnect and release)
Merging staging.current/staging-linus (d4e4ab8 Linux 3.11-rc5)
Merging char-misc.current/char-misc-linus (5ae90d8 Linux 3.11-rc3)
Merging input-current/for-linus (88ce3c3 Merge branch 'next' into for-linus)
Merging md-current/for-linus (f94c0b6 md/raid5: fix interaction of 'replace=
' and 'recovery'.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (e70308e Revert "crypto: crct10dif - Wrap crc=
_t10dif function all to use crypto transform framework")
Merging ide/master (6d128e1 Revert "Makefile: Fix install error with make -=
j option")
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
Merging drm-intel-fixes/drm-intel-fixes (63b66e5 drm/i915: Don't deref pipe=
->cpu_transcoder in the hangcheck code)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (a00b92e ARC: [ASID] Optimize the threads-of-process s=
witching case)
Merging arm/for-next (3aa90dd Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (ad81f05 Linux 3.11-rc1)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b028161 Merge branch 'for-3.11' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging arm64/upstream (c095ba7 Linux 3.11-rc4)
Merging blackfin/for-linus (eb043d3 smp: blackfin: fix check error, using a=
tomic_ops to handle atomic_t type)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (67eded6 Merge branch 'pstore' into next)
CONFLICT (content): Merge conflict in arch/ia64/configs/xen_domu_defconfig
CONFLICT (content): Merge conflict in arch/ia64/configs/tiger_defconfig
CONFLICT (content): Merge conflict in arch/ia64/configs/gensparse_defconfig
CONFLICT (content): Merge conflict in arch/ia64/configs/generic_defconfig
Merging m68k/for-next (ad81f05 Linux 3.11-rc1)
Merging m68knommu/for-next (5fbed81 m68k: remove 16 unused boards in Kconfi=
g.machine)
Merging metag/for-next (8a69782 metag: tz1090: instantiate gpio-tz1090-pdc)
Merging microblaze/next (a9b9d22 of/pci: Use of_pci_range_parser)
Merging mips/mips-for-linux-next (49e12af Merge branch '3.11-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9f0f4fb parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (5ba840e Revert "powerpc/e500: Update compilation flag=
s with core specific options")
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (6391f69 powerpc: 52xx: provide a default in mpc52xx_i=
rqhost_map())
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (6d7e8d8 s390/time: clock comparator revalidation)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (a36cd9c tile: make __write_once a synonym for __read_m=
ostly)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (3b2f64d Linux 3.11-rc2)
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
Merging ceph/master (fe2a801 ceph: Remove bogus check in invalidatepage)
Merging cifs/for-next (3b4dd0d cifs: Move string length definitions to uapi)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging ext3/for_next (97a2847 Merge branch 'for-3.12' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jeffm/linux-reiserfs into for_next_testing)
Merging ext4/dev (3ddb6c0 ext4: avoid reusing recently deleted inodes in no=
 journal mode)
Merging f2fs/dev (c2d715d f2fs: fix a build failure due to missing the kobj=
ect header)
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (c7263bc fuse: readdirplus: cleanup)
Merging gfs2/master (31ffe92 GFS2: alloc_workqueue() doesn't return an ERR_=
PTR)
Merging jfs/jfs-next (4451244 jfs: fix readdir cookie incompatibility with =
NFSv4)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (9743120 NFSv4.1 Use clientid management rpc_clnt fo=
r secinfo_no_name)
Merging nfsd/nfsd-next (df66e75 nfsd: nfs4_file_get_access: need to be more=
 careful with O_RDWR)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b3f8ab4 fs: 9p: use strlcpy instead of strncpy)
Merging ubifs/linux-next (beadadf UBIFS: correct mount message)
Merging xfs/for-next (4bb928c xfs: split the CIL lock)
CONFLICT (content): Merge conflict in fs/xfs/xfs_inode.c
Merging vfs/for-next (d405be4 ext4: ->tmpfile() support)
CONFLICT (content): Merge conflict in mm/shmem.c
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Merging pci/next (7d8c4a2 Merge branch 'pci/aw-reset-v5' into next)
Merging hid/for-next (e999c8b Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (2806914 drivers/i2c/busses: don't check resource =
with devm_ioremap_resource)
Merging jdelvare-hwmon/master (6f7e0b6 hwmon: (w83792d) Update module autho=
r)
Merging hwmon-staging/hwmon-next (f767589 hwmon: (adt7462) ADT7462_REG_VOLT=
_MAX() should return 0)
Merging v4l-dvb/master (e5c9146 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (c06f7c3 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (70a01c3 Merge branch 'for-3.12' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (4fdcde3 Merge branch 'acpi-assorted-next' into linux=
-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (ace120d Thermal: Fix lockup of cpu_down())
Merging ieee1394/for-next (0a41981 firewire: core: typecast from gfp_t to b=
ool more safely)
Merging ubi/linux-next (83ff59a UBI: support ubi_num on mtd.ubi command lin=
e)
Merging dlm/next (c6ca7bc dlm: remove signal blocking)
CONFLICT (content): Merge conflict in fs/dlm/user.c
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (13699ae Merge branch 'for-linus' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (16b304f netlink: Eliminate kmalloc in netlink dump=
 operation.)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/pcie/tra=
ns.c
Merging ipsec-next/master (af83fde xfrm: Remove rebundant address family ch=
ecking)
Merging wireless-next/master (67d0cf5 brcmsmac: Fix WARNING caused by lack =
of calls to dma_mapping_error())
Merging bluetooth/master (e056739 Bluetooth: Set different event mask for L=
E-only controllers)
Merging infiniband/for-next (3e76458 Merge branches 'cxgb4', 'ipoib', 'iser=
', 'mlx4', 'ocrdma' and 'qib' into for-next)
Applying: cxgb4: fix up for bond_for_each_slave API change
Merging mtd/master (e79265b mtd: ofpart: add compatible check for child nod=
es)
Merging l2-mtd/master (8bb3c7d mtd: nand: Allow to build pxa3xx_nand on Ori=
on platforms)
Merging crypto/master (9dc4803 hwrng: tx4939 - simplify use of devm_ioremap=
_resource)
Merging drm/drm-next (00fd78e drm: provide agp dummies for CONFIG_AGP=3Dn)
CONFLICT (content): Merge conflict in drivers/gpu/drm/qxl/qxl_release.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-intel/for-linux-next (815ca98 drm/i915: inline vma_create into =
lookup_or_create_vma)
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (b892ca1 ALSA: rme96: Add pcm stream synchronization)
Merging sound-asoc/for-next (917bbd6 Merge remote-tracking branch 'asoc/top=
ic/wm8994' into asoc-next)
Merging modules/modules-next (ad81f05 Linux 3.11-rc1)
Merging virtio/virtio-next (3b868a4 virtio: console: prevent use-after-free=
 of port name in port unplug)
Merging input/next (c3b3a38 Input: elantech - fix packet check for v3 and v=
4 hardware)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (e2c121e Merge branch 'for-3.12' into for-next)
CONFLICT (content): Merge conflict in include/net/netprio_cgroup.h
Merging block/for-next (3fe9649 Merge branch 'for-3.11/drivers' into for-ne=
xt)
Merging device-mapper/master (d4e4ab8 Linux 3.11-rc5)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (6d1d6b4 mmc: tmio: fix compiler warning)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (9de1bc8 mm, slab_common: add 'unlikely' to size chec=
k of kmalloc_slab())
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (5ad58b4 md/raid5: make release_stripe lockless)
Merging mfd/master (38c4faa mfd: ucb1x00: Explicitely include linux/device.=
h)
Merging mfd-lj/for-mfd-next (5d945d9 mfd: ti_am335x_tscadc: Update reg_cach=
e variable in clr function)
Merging battery/master (f107ae1 power_supply: Replace strict_strtol() with =
kstrtol())
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (fd3cd7e OMAPDSS: HDMI: Fix AVI infoframe bug)
Merging regulator/for-next (ec63a3b Merge remote-tracking branch 'regulator=
/topic/tps65912' into regulator-next)
Merging security/next (f8eb8a1 apparmor: add the ability to report a sha1 h=
ash of loaded policy)
Merging selinux/master (2be4d74 Add SELinux policy capability for always ch=
ecking packet and peer classes.)
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (f098cc4 Merge branches 'arm/exynos', 'ppc/pamu', 'arm/s=
mmu', 'x86/amd' and 'iommu/fixes' into next)
Merging vfio/next (6cdd978 vfio: add external user support)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (ccb7cc0 credits: update contact information for C=
hris Cheney)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (75a9551 cpc925_edac: Use proper array terminatio=
n)
Merging devicetree/devicetree/next (245d964 of/platform: Staticize of_platf=
orm_device_create_pdata())
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/for-next (9e55a20 Merge remote-tracking branch 'spi/topic/xilin=
x' into spi-next)
Merging tip/auto-latest (97eea45 Merge branch 'x86/urgent')
CONFLICT (content): Merge conflict in drivers/video/simplefb.c
Applying: simplefb: merge conflict fix
Merging ftrace/for-next (9457158 tracing: Fix reset of time stamps during t=
race_clock changes)
Merging rcu/rcu/next (0cecd37 Merge branches 'doc.2013.08.13a', 'fixes.2013=
.08.13a', 'sysidle.2013.08.13a' and 'torture.2013.08.13a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (205befd KVM: nVMX: correctly set tr base on nested =
vmexit emulation)
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (20f7462 Merge remote-tracking branch 'cmadma/=
for-v3.12-cma-dma' into kvm-ppc-next)
CONFLICT (content): Merge conflict in mm/Kconfig
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (85e5d6e Merge remote branch 'xentip/stable/for-=
linus-3.11' into xentip-linux-next)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (b84acfb Merge branch 'for-3.11-fixes' into for=
-next)
Merging drivers-x86/linux-next (de91b53 x86 platform drivers: fix gpio leak)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (ce0609a Merge remote-tracking branch 'regmap/topic=
/sparse' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (bfaadeb Documentation: leds: Fix a typo)
Merging driver-core/driver-core-next (c7991b0 driver core / cpu: Check if N=
UMA node is valid before bringing CPU up)
CONFLICT (content): Merge conflict in net/core/net-sysfs.c
Merging tty/tty-next (09a5163 serial: pch_uart: fix compilation warning)
CONFLICT (content): Merge conflict in include/uapi/linux/serial_core.h
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
Merging usb/usb-next (9821aa9 USB: uss720: fix DMA-buffer allocation)
CONFLICT (content): Merge conflict in include/linux/usb/usbnet.h
Merging usb-gadget/next (aaeaae0 usb: dwc3: core: cope with NULL pdata)
Merging staging/staging-next (35cf904 staging: dgnc: removes proc code)
Merging char-misc/char-misc-next (eefbc59 drivers/misc/hpilo: Correct panic=
 when an AUX iLO is detected)
Merging scsi/for-next (959823b Merge branch 'fixes' into for-next)
Merging target-updates/for-next (dfecf61 iscsi-target: ST response on IN6AD=
DR_ANY socket)
Merging target-merge/for-next-merge (d4e4ab8 Linux 3.11-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (8bb495e Linux 3.10)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (47b301e Merge branch 'devel' into for-next)
Merging vhost/linux-next (8c325ee vhost: wake up worker outside spin_lock)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (b0305e9 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (6723182 Merge branch 'next/soc' into for-next)
CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in arm-so=
c/for-next and modified in HEAD. Version HEAD of drivers/leds/leds-renesas-=
tpu.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
$ git rm -f drivers/leds/leds-renesas-tpu.c
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (9c59be7 Merge branch 'ep93xx-devel' into ep=
93xx-for-next)
Merging imx-mxs/for-next (cf37a61 Merge branch 'imx/soc' into for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
Merging mvebu/for-next (56df74f Merge branch 'mvebu/dove_pcie-mbus-dt' into=
 for-next)
CONFLICT (content): Merge conflict in drivers/pci/host/pci-mvebu.c
CONFLICT (content): Merge conflict in drivers/pci/host/Kconfig
Merging renesas/next (8a8c6f7 Merge tag 'renesas-defconfig-for-v3.12' into =
next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a7790.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a73a4.dtsi
Merging samsung/for-next (45fd387 Merge branch 'v3.12-next/cleanup-samsung'=
 into for-next)
Merging tegra/for-next (dca9ac6 Merge branch for-3.12/defconfig into for-ne=
xt)
CONFLICT (content): Merge conflict in drivers/pci/host/Makefile
Merging dma-mapping/dma-mapping-next (f7d8f1e Merge remote-tracking branch =
'dma-public/for-v3.12-cma-dma' into for-next)
Merging pwm/for-next (6d0cf4d ARM: dts: Use the PWM polarity flags)
Merging dma-buf/for-next (8bb495e Linux 3.10)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (18f5863 clk: prima2: Fix incorrect placement of __ini=
tdata)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging ptr-ret/PTR_RET (ad151d5 GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO)
CONFLICT (modify/delete): drivers/staging/zcache/zcache-main.c deleted in H=
EAD and modified in ptr-ret/PTR_RET. Version ptr-ret/PTR_RET of drivers/sta=
ging/zcache/zcache-main.c left in tree.
$ git rm -f drivers/staging/zcache/zcache-main.c
Merging aio/master (f30d704 aio: table lookup: verify ctx pointer)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (368776d lz4: fix compression/decompression si=
gnedness mismatch)
Applying: mm: move is_hugepage_active() outside protecting ifdef
$ git checkout -b akpm remotes/origin/akpm/master
Applying: revert "SELinux: do not handle seclabel as a special flag"
Applying: memcg: remove redundant code in mem_cgroup_force_empty_write()
Applying: memcg, vmscan: integrate soft reclaim tighter with zone shrinking=
 code
Applying: memcg: get rid of soft-limit tree infrastructure
Applying: vmscan, memcg: do softlimit reclaim also for targeted reclaim
Applying: memcg: enhance memcg iterator to support predicates
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
Applying: mm: make lru_add_drain_all() selective
Applying: fs: bump inode and dentry counters to long
Applying: super: fix calculation of shrinkable objects for small numbers
Applying: dcache: convert dentry_stat.nr_unused to per-cpu counters
Applying: dentry: move to per-sb LRU locks
Applying: dcache: remove dentries from LRU before putting on dispose list
Applying: mm: new shrinker API
Applying: shrinker: convert superblock shrinkers to new API
Applying: shrinker-convert-superblock-shrinkers-to-new-api-fix
Applying: list: add a new LRU list type
Applying: inode: convert inode lru list to generic lru list code.
Applying: inode: move inode to a different list inside lock
Applying: dcache: convert to use new lru list infrastructure
Applying: list_lru: per-node list infrastructure
Applying: list_lru: per-node list infrastructure fix
Applying: list_lru: fix broken LRU_RETRY behaviour
Applying: list_lru: per-node API
Applying: list_lru: remove special case function list_lru_dispose_all.
Applying: shrinker: add node awareness
Applying: vmscan: per-node deferred work
Applying: fs: convert inode and dentry shrinking to be node aware
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
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
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
Merging akpm/master (e61a68f mm/Kconfig: add MMU dependency for MIGRATION.)
[master 53925e7] Revert "drivers/block/brd.c: make 'rd_size' static"

--Signature=_Fri__16_Aug_2013_17_16_34_+1000_MZrsP1hvkgbhJ6iK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSDdHXAAoJEECxmPOUX5FEidoP/20jOXbhIPCkF9E332EaCmLP
fiPMHPZc+T7LGwOCy4DG/tCoiUp+/zbEleYQCRNcW8cJvuIhB3vovWooh+FtKSoX
j03Q3NDr05UDaqSat89QL8DwUqRsXImUXYZrpG28sfDr8uIgv+xdenJuzCMgg1HI
Zqw3pdzZJ6ZnnFw+ugpIWv6DXCOH6fvbYTPy0pl4jPeYzYu7+ycRuHKw+/olED7+
bqxDRJFQg1lmBgeT90CTvZJlsrahNqvGyUBxstn5Uw+4gMKYl8s6T98UmtnpHt15
DD7wVe8LCqsMesXUIooSsjgIpx6Z7NxbATxHqEMMHJ45CTh1A9WPN4MrYYHcN9o7
V9dZcwXNfbEOelMPyn89YyOBPbU6L74S+GVz30uqIpRbL0U0YAsC1iYS59e53tIq
jifrsWQAKITNEB3TdWdxSyYGexCSB3x3USXQGaSBYtxNed4Zj0Azk8xmyqHvNijV
BYwii3mZviZka+gDEMAzNSBigBljbS9VQQbkkYcBQpgVvz+pkIISoGy2/OKk34/c
POcbtDCVNAD6PgBDxO4qQk5FrrrG0bvAeFpCq2Jlr0Kw6hw8bQnxzTI+k5HU/Hz2
GLK1gOZKHCIsB6GSfknA+0wyWoPCiw5mruQj/o2XozfGl3qnrlhkHzdoAGGNnXFc
fDkS8mzehh7qxlWSy6PE
=vZxh
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Aug_2013_17_16_34_+1000_MZrsP1hvkgbhJ6iK--
