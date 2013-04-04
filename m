Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019Ab3DDHWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:22:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32859 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763224Ab3DDHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:22:44 -0400
Date: Thu, 4 Apr 2013 18:22:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 4
Message-Id: <20130404182232.bd2dbfba27620bdab9e0de42@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_18_22_32_+1100_H5+rUXdu8whs7rfc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_18_22_32_+1100_H5+rUXdu8whs7rfc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130403:

The ext4 tree gained a build failure so I used the version from
next-20130403.

The nfsd tree lost its build failure.

The vfs tree lost its build failure.

The net-next tree gained a conflict against the wireless tree.

The wireless-next tree lost its build failure but gained another for
which I reverted a commit.

The block tree gained a conflict against the vfs tree.

The tty tree lost its build failure.

The usb-gadget tree gained a conflict against the usb tree.

The char-misc tree lost its build failure.

The staging tree gained conflicts against the vfs tree.

The imx-mxs tree gained a conflict against the pm tree.

The signal tree gained conflicts against the vfs tree.

The akpm tree gained conflicts against the vfs tree and lost some patches
that turned up elsewhere and gained a build failure for which I applied a
merge fix patch.

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

We are up to 222 trees (counting Linus' and 31 trees of patches pending
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
Merging origin/master (da241ef Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/davem/net)
Merging fixes/master (9064171 Merge tag 'for-linus' of git://git.kernel.org=
/pub/scm/linux/kernel/git/sfr/next-fixes)
Merging kbuild-current/rc-fixes (6dbe51c Linux 3.9-rc1)
Merging arc-current/for-curr (07961ac Linux 3.9-rc5)
Merging arm-current/fixes (4e1db26 ARM: 7690/1: mm: fix CONFIG_LPAE typos)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (af81d78 powerpc: Rename USER_ESID_BITS* to ESI=
D_BITS*)
Merging sparc/master (cbf1ef6 sparc: use asm-generic version of types.h)
Merging net/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kernel=
/git/davem/net)
Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging sound-current/for-linus (690a863 ALSA: usb: Work around CM6631 samp=
le rate change bug)
Merging pci-current/for-linus (6e0eda3 PCI: Don't try to disable Bus Master=
 on disconnected PCI devices)
Merging wireless/master (69a2bac rt2x00: rt2x00pci: fix build error on Rali=
nk RT3x5x SoCs)
Merging driver-core.current/driver-core-linus (07961ac Linux 3.9-rc5)
Merging tty.current/tty-linus (1f66396 OMAP/serial: Revert bad fix of Rx FI=
FO threshold granularity)
Merging usb.current/usb-linus (07961ac Linux 3.9-rc5)
Merging staging.current/staging-linus (07961ac Linux 3.9-rc5)
Merging char-misc.current/char-misc-linus (6d4f013 misc/vmw_vmci: Add depen=
dency on CONFIG_NET)
Merging input-current/for-linus (4b7d293 Input: mms114 - Fix regulator enab=
le and disable paths)
Merging md-current/for-linus (238f590 md: remove CONFIG_MULTICORE_RAID456 e=
ntirely)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (d3dde52 crypto: gcm - fix assumption that as=
soc has one segment)
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
Merging rr-fixes/fixes (9ba5c80 virtio: console: add locking around c_ovq o=
perations)
Merging mfd-fixes/master (0371541 mfd: twl4030-madc: Remove __exit_p annota=
tion)
Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overfl=
ow)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (3917dbf ARC: de-uglify the reg file dumping)
Merging arm/for-next (8e65f78 Merge branches 'devel-stable', 'entry', 'fixe=
s', 'mach-types' and 'misc' into for-next)
Merging arm-perf/for-next/perf (a937536 Linux 3.9-rc3)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (8bb9660 Linux 3.9-rc4)
Merging arm64/upstream (d4784be Merge branch 'arm64-klib' into upstream)
Merging blackfin/for-linus (f656c24 blackfin: time-ts: Remove duplicate ass=
ignment)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (ae0b105 CRIS: Remove last traces of legacy RTC drive=
rs)
Merging hexagon/linux-next (411d53d Hexagon: remove two Kconfig entries)
Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
Merging m68k/for-next (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs. CONFIG_H=
AS_DMA)
Merging m68knommu/for-next (b46ab88 m68k: clean up unused "config ROMVECSIZ=
E")
Merging metag/for-next (82bbb83 metag: add exported <asm/ech.h> for extende=
d context handling)
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
Merging mpc5xxx/next (b9e7196 powerpc/512x: move mpc5121_generic platform t=
o mpc512x_generic.)
Merging galak/next (ddb487d powerpc/85xx: fix a bug with the parameter of m=
pic_reset_core())
Merging s390/features (635640a s390/mm: speedup storage key initialization)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
Merging sparc-next/master (d6d88ba sparc64: Kill __ARCH_WANT_UNLOCKED_CTXSW)
Merging tile/master (39e8202 tile: ns2cycles should use __raw_get_cpu_var)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (9cf81c7 xtensa: add accept4 syscall)
Merging btrfs/next (6aec51f Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into for-linus-3.9)
Merging ceph/master (6e2a450 rbd: don't zero-fill non-image object requests)
Merging cifs/for-next (457d215 cifs: remove ENOSPC handling in smb_sendv)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
Merging ext3/for_next (e678a4f jbd: don't wait (forever) for stale tid caus=
ed by wraparound)
Merging ext4/dev (82a2180 ext4: print more info in ext4_print_free_blocks())
$ git reset --hard HEAD^
Merging 20130403 version of ext4
Merging f2fs/dev (9078af8 f2fs: fix the bitmap consistency of dirty segment=
s)
Merging fuse/for-next (634734b fuse: allow control of adaptive readdirplus =
use)
Merging gfs2/master (1987566 GFS2: Issue discards in 512b sectors)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (29dbc93 NFSv4: Be less aggressive about returning d=
elegations for open files)
Merging nfsd/nfsd-next (a7823c7 SUNRPC/cache: add module_put() on error pat=
h in cache_open())
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
Merging ubifs/linux-next (67e753c UBIFS: make space fixup work in the remou=
nt case)
Merging xfs/for-next (ff9a28f xfs: Fix WARN_ON(delalloc) in xfs_vm_releasep=
age())
CONFLICT (content): Merge conflict in fs/xfs/xfs_iomap.c
Merging vfs/for-next (0f647ac create_proc_cpu_mask() doesn't need an argume=
nt...)
Merging pci/next (8332606 Merge branch 'pci/shuah-defines' into next)
Merging hid/for-next (ac990a1 Merge branch 'for-3.10/upstream' into for-nex=
t)
CONFLICT (content): Merge conflict in drivers/hid/hid-multitouch.c
Merging i2c/i2c/for-next (51d9570 i2c: Make the return type of i2c_del_mux_=
adapter() void)
Merging jdelvare-hwmon/master (c662b7a hwmon: (lm75) Add support for the Da=
llas/Maxim DS7505)
Merging hwmon-staging/hwmon-next (86d948a hwmon: (tmp401) Fix device detect=
ion for TMP411B and TMP411C)
Merging v4l-dvb/master (7307913 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/staging/media/go7007/go7007-d=
river.c
CONFLICT (content): Merge conflict in drivers/media/platform/Kconfig
CONFLICT (content): Merge conflict in drivers/media/pci/bt8xx/bttv-input.c
Applying: i2c: fixup for code movement from bttv_input.c
Merging kbuild/for-next (d1fc916 Merge branch 'kbuild/misc' into kbuild/for=
-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (b186aff pata_samsung_cf: use module_platform_driver_pr=
obe())
Merging infiniband/for-next (4e73a54 Merge branches 'cxgb4', 'ipoib' and 'q=
ib' into for-next)
Merging pstore/master (c530267 pstore: Replace calls to kmalloc and memcpy =
with kmemdup)
Merging pm/linux-next (33da2f7 Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
Merging idle/next (e6bfd82 Merge branch 'ia64-idle-regression-fix' into nex=
t)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (2fd1db8 thermal: dove: Fix thermal sensor formula)
Merging ieee1394/for-next (6dbe51c Linux 3.9-rc1)
Merging ubi/linux-next (f6161aa Linux 3.9-rc2)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (6dbe51c Linux 3.9-rc1)
Merging target-updates/for-next (65b3d1b tcm_vhost: Initialize vq->last_use=
d_idx when set endpoint)
Merging target-merge/for-next-merge (a937536 Linux 3.9-rc3)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (a2a1a6d Merge branch 'fixes' into next)
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (d662483 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
CONFLICT (content): Merge conflict in drivers/nfc/microread/mei.c
CONFLICT (content): Merge conflict in drivers/net/wireless/rt2x00/rt2x00pci=
.c
Applying: drivers:net: fix up for code movement from rt2x00pci.c
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (84bcc0c brcmfmac: enable sk_buff queueing whe=
n credits deplete)
CONFLICT (content): Merge conflict in net/wireless/core.h
CONFLICT (content): Merge conflict in net/mac80211/sta_info.c
CONFLICT (content): Merge conflict in drivers/nfc/microread/mei.c
Merging bluetooth/master (e32ca96 Bluetooth: Add support for Foxconn/Hon Ha=
i [0489:e04d])
Merging mtd/master (35f8c76 Merge tag 'for-linus-20130318' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (91aabd2 mtd: nand_ids: use size macros)
Merging crypto/master (30975d2 hwrng: timeriomem - added devicetree hooks)
Merging drm/drm-next (be88298 drm/tilcdc: only build on arm)
Merging drm-intel/drm-intel-next-queued (eca4472 drm/i915: Don't use the HD=
MI port color range bit on Valleyview)
Merging sound/for-next (7c517465 ALSA: usb-audio: Clean up the code in set_=
sample_rate_v2())
Merging sound-asoc/for-next (5c0f555 Merge remote-tracking branch 'asoc/top=
ic/wm8994' into asoc-next)
Merging modules/modules-next (d70f82a genksyms: pass symbol-prefix instead =
of arch)
Merging virtio/virtio-next (1aef76e caif_virtio: fix error return code in c=
fv_create_genpool())
CONFLICT (content): Merge conflict in drivers/char/virtio_console.c
Merging input/next (3c2b901 Input: ims-pcu - fix a memory leak on error)
Merging input-mt/for-next (8bb9660 Linux 3.9-rc4)
Merging cgroup/for-next (081aa45 cgroup: consolidate cgroup_attach_task() a=
nd cgroup_attach_proc())
CONFLICT (content): Merge conflict in include/linux/res_counter.h
Merging block/for-next (a0d9f3e Merge branch 'for-linus' into for-next)
CONFLICT (content): Merge conflict in drivers/block/drbd/drbd_proc.c
Merging device-mapper/master (c9bfbec Correct the documented requirement on=
 the return code from dm cache policy lookup functions stated in the policy=
 module header file.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (e573d69 mmc: mvsdio: use dev_*() API instead of pr_*(=
) API)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (338b264 slub: add 'likely' macro to inc_slabs_node())
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (023a4ef raid5: make release_stripe lockless)
Merging mfd/master (e8ea76b mfd: as3711: Add OF support)
Merging battery/master (a92d4c7 goldfish_battery: Use resource_size())
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (6a234f0 Merge branch '3.10/misc' into for-next)
Merging regulator/for-next (c921540 Merge remote-tracking branch 'regulator=
/topic/tps6586x' into regulator-next)
Merging security/next (958d2c2 Smack: include magic.h in smackfs.c)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (112b55a watchdog: Convert to devm_ioremap_resource=
())
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (fbe973e Merge branches 'iommu/fixes' and 'x86/vt-d' int=
o next)
Merging vfio/next (a7d1ea1 vfio-pci: Enable raw access to unassigned config=
 space)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (1051e9b treewide: Fix typos in kernel messages)
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
Merging spi-mb/spi-next (58ad60b mxs/spi: fix error return code in mxs_spi_=
probe())
Merging tip/auto-latest (a2d66a370 Merge branch 'x86/platform')
Merging ftrace/for-next (22f4564 tracing: Update debugfs README file)
CONFLICT (content): Merge conflict in kernel/trace/ftrace.c
Merging rcu/rcu/next (6d87669 Merge branches 'doc.2013.03.12a', 'fixes.2013=
.03.13a' and 'idlenocb.2013.03.26b' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (81f4f76 KVM: MMU: Rename kvm_mmu_free_some_pages() =
to make_mmu_pages_available())
CONFLICT (content): Merge conflict in drivers/s390/kvm/virtio_ccw.c
Merging kvm-ppc/kvm-ppc-next (fbfba34 Merge commit 'origin/next' into kvm-p=
pc-next)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (562eb8e Merge branch 'stable/for-linus-3.9-take=
-two' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (aee35c6 percpu: add documentation on this_cpu oper=
ations)
Merging workqueues/for-next (8ddc6d2 Merge branch 'for-3.10' into for-next)
Merging drivers-x86/linux-next (e6e5224 ideapad-laptop: Depend on BACKLIGHT=
_CLASS_DEVICE instead of selecting it)
CONFLICT (content): Merge conflict in drivers/platform/x86/chromeos_laptop.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (833d040 Merge remote-tracking branch 'regmap/topic=
/range' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (df92d5f leds: leds-asic3: switch to using SIMPLE_DEV=
_PM_OPS)
Merging driver-core/driver-core-next (bcfb87f sysfs: fix crash_notes_size b=
uild warning)
Merging tty/tty-next (89fa28d amba-pl011: fix build error if CONFIG_DMA_ENG=
INE is not enabled)
Merging usb/usb-next (369a9a9 usb: host: ehci-tegra: Fix oops in error clea=
nup)
CONFLICT (content): Merge conflict in drivers/usb/serial/usb-serial.c
Merging usb-gadget/next (9b192de usb: gadget: nokia: include f_ecm.c)
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-tegra.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/net2280.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/net2272.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/udc.c
Merging staging/staging-next (e9e7023 staging: comedi: rtd520: rename thisb=
oard variable)
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_specproc.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_ports_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_net_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_mon_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_dpa_ops.c
CONFLICT (modify/delete): drivers/staging/ccg/rndis.c deleted in staging/st=
aging-next and modified in HEAD. Version HEAD of drivers/staging/ccg/rndis.=
c left in tree.
CONFLICT (modify/delete): drivers/staging/ccg/f_fs.c deleted in staging/sta=
ging-next and modified in HEAD. Version HEAD of drivers/staging/ccg/f_fs.c =
left in tree.
$ git rm -f drivers/staging/ccg/f_fs.c drivers/staging/ccg/rndis.c
Merging char-misc/char-misc-next (2638953 Merge tag 'extcon-arizona-v3.10' =
of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc into char-mis=
c-next)
Merging bcon/master (06c6942 blockconsole: Mark a local work struct static)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (bdbe59f Merge branch 'devel' into for-next)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
CONFLICT (content): Merge conflict in drivers/vhost/Makefile
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (753c598 gpio/em: Add Device Tree support)
Merging gpio-lw/for-next (290722b Merge branch 'next' into for-next)
Merging gen-gpio/for_next (a2523d3 blackfin: force use of gpiolib)
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of s=
izeof in mailbox_msg_send())
Merging arm-soc/for-next (0be783d Merge branch 'next/boards2' into for-next)
Merging bcm2835/for-next (d1a7707 Merge branch 'for-3.10/defconfig' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging cortex/for-next (6ebd4d0 ARM: stub out read_cpuid and read_cpuid_ex=
t for CPU_CP15=3Dn)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (6180585 Merge branch 'imx/dt' into for-next)
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (modify/delete): arch/arm/mach-imx/cpufreq.c deleted in imx-mxs/fo=
r-next and modified in HEAD. Version HEAD of arch/arm/mach-imx/cpufreq.c le=
ft in tree.
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
$ git rm -f arch/arm/mach-imx/cpufreq.c
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (d0f6e50 Merge branch 'msm-defconfig' into for-next)
Merging renesas/next (837d8a9 Merge branches 'heads/defconfig', 'heads/boar=
ds', 'heads/clocksource' and 'heads/fbdev-fixes' into next)
Merging samsung/for-next (d58f6a1 Merge branch 'next/clk-exynos-2' into for=
-next)
Merging tegra/for-next (fe98dc2 Merge branch 'for-3.10/defconfig' into for-=
next)
CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/tegra.c
Merging dma-mapping/dma-mapping-next (a937536 Linux 3.9-rc3)
Merging pwm/for-next (a46ef4d pwm: puv3: Remove unused enabled filed from s=
truct puv3_pwm_chip)
Merging dma-buf/for-next (6dbe51c Linux 3.9-rc1)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (7328735 ktest: Remove indexes from warnings check)
Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of=
 macros)
CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
CONFLICT (content): Merge conflict in fs/splice.c
CONFLICT (content): Merge conflict in fs/read_write.h
CONFLICT (content): Merge conflict in fs/read_write.c
CONFLICT (content): Merge conflict in fs/compat.c
CONFLICT (content): Merge conflict in arch/tile/kernel/compat.c
CONFLICT (content): Merge conflict in arch/tile/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
Applying: cond_syscall and SYSCALL_ALIAS merge fixup
Merging clk/clk-next (533ddeb clk: allow reentrant calls into the clk frame=
work)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (a12183c Merge branch 'timers-urgent-for-linus=
' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: revert "ipc: don't allocate a copy larger than max"
Applying: thinkpad-acpi: kill hotkey_thread_mutex
Applying: mips: define KVM_USER_MEM_SLOTS
Applying: drivers/char/random.c: fix priming of last_data
Applying: kthread: introduce to_live_kthread()
Applying: kthread: kill task_get_live_kthread()
Applying: arch/x86/mm/init_64.c: fix build warning when CONFIG_MEMORY_HOTRE=
MOVE=3Dn
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: matroxfb: convert struct i2c_msg initialization to C99 format
Applying: drivers/video/console/fbcon_cw.c: fix compiler warning in cw_upda=
te_attr
Applying: drivers/video: add Hyper-V Synthetic Video Frame Buffer Driver
Applying: video: fix a type warning in hyperv_fb.c
Applying: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_r=
esource()
Applying: drivers/video/ep93xx-fb.c: fix section mismatch and use module_pl=
atform_driver
Applying: drivers/video/mmp: remove legacy hw definitions
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
Applying: ktime_add_ns() may overflow on 32bit architectures
Applying: mkcapflags.pl: convert to mkcapflags.sh
Applying: headers_install.pl: convert to headers_install.sh
Applying: scripts/decodecode: make faulting insn ptr more robust
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: ocfs2: delay inode update transactions after verifying the input =
flags
Applying: debug_locks.h: make warning more verbose
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: drivers/block/mg_disk.c: add CONFIG_PM_SLEEP to suspend/resume fu=
nctions
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: fs: fix hang with BSD accounting on frozen filesystem
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
Applying: mm: merging memory blocks resets mempolicy
Applying: mm, hugetlb: include hugepages in meminfo
Applying: mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes
Applying: mm: try harder to allocate vmemmap blocks
Applying: sparse-vmemmap: specify vmemmap population range in bytes
Applying: sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix
Applying: x86-64: remove dead debugging code for !pse setups
Applying: x86-64: use vmemmap_populate_basepages() for !pse setups
Applying: x86-64: use vmemmap_populate_basepages() for !pse setups fix
Applying: x86-64: fall back to regular page vmemmap on allocation failure
Applying: mm: page_alloc: avoid marking zones full prematurely after zone_r=
eclaim()
Applying: mm/migrate: fix comment typo syncronous->synchronous
Applying: mm: speedup in __early_pfn_to_nid
Applying: mm-speedup-in-__early_pfn_to_nid-fix
Applying: page_alloc: make setup_nr_node_ids() usable for arch init code
Applying: x86/mm/numa: use setup_nr_node_ids() instead of opencoding.
Applying: powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.
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
Applying: drivers/rpmsg/virtio_rpmsg_bus.c: fix error return code in rpmsg_=
probe()
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
Applying: MAINTAINERS: i8k driver is orphan
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
Applying: drivers/video/backlight/adp8860_bl.c: fix error return code in ad=
p8860_led_probe()
Applying: drivers/video/backlight/adp8870_bl.c: fix error return code in ad=
p8870_led_probe()
Applying: drivers/video/backlight/as3711_bl.c: add OF support
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
Applying: epoll: fix suspicious RCU usage in ep_poll_callback
Applying: epoll: lock ep->mtx in ep_free to silence lockdep
Applying: epoll: cleanup: hoist out f_op->poll calls
Applying: fs: make binfmt support for #! scripts modular and removable
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: init: scream bloody murder if interrupts are enabled too early
Applying: init: raise log level
Applying: init/main.c: convert to pr_foo()
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
Applying: drivers/rtc/rtc-tegra.c: fix build warning
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
Applying: drivers/rtc/rtc-omap.c: update to devm_* API
Applying: drivers/rtc/rtc-palmas.c: add dt support
Applying: drivers/rtc/rtc-ds1374.c: add CONFIG_PM_SLEEP to suspend/resume f=
unctions
Applying: drivers/rtc/rtc-88pm80x.c: add CONFIG_PM_SLEEP to suspend/resume =
functions
Applying: drivers/rtc/rtc-tps6586x.c: remove incorrect use of rtc_device_un=
register
Applying: drivers/rtc/rtc-tps65910.c: fix incorrect return value on error
Applying: drivers/rtc/rtc-max8997.c: fix incorrect return value on error
Applying: drivers/rtc/rtc-max77686.c: fix incorrect return value on error
Applying: drivers/rtc/rtc-max8907.c: remove redundant code
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
CONFLICT (content): Merge conflict in fs/coredump.c
Applying: coredump: introduce dump_interrupted()
CONFLICT (content): Merge conflict in fs/coredump.c
Applying: coredump: factor out the setting of PF_DUMPCORE
Applying: coredump: change wait_for_dump_helpers() to use wait_event_interr=
uptible()
Applying: set_task_comm: kill the pointless memset() + wmb()
Applying: exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
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
Applying: ipc: remove bogus lock comment for ipc_checkid
Applying: ipc: introduce obtaining a lockless ipc object
Applying: ipc-introduce-obtaining-a-lockless-ipc-object-fix
Applying: ipc: introduce lockless pre_down ipcctl
Applying: ipc,sem: do not hold ipc lock more than necessary
Applying: ipc,sem: open code and rename sem_lock
Applying: ipcsem-open-code-and-rename-sem_lock-fix
Applying: ipc,sem: have only one list in struct sem_queue
Applying: ipc,sem: fine grained locking for semtimedop
Applying: fix for sem_lock
Applying: ipc, sem: prevent possible deadlock
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: kernel/pid.c: improve flow of a loop inside alloc_pidmap.
Applying: kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix
Applying: pid_namespace.c/.h: simplify defines
Applying: pid_namespacec-h-simplify-defines-fix
Applying: aoe: replace kmalloc and then memcpy with kmemdup
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
Applying: relay: use macro PAGE_ALIGN instead of FIX_SIZE
Applying: mm: remove old aio use_mm() comment
Applying: aio: remove dead code from aio.h
Applying: gadget: remove only user of aio retry
Applying: gadget-remove-only-user-of-aio-retry-checkpatch-fixes
Applying: aio: remove retry-based AIO
Applying: aio-remove-retry-based-aio-checkpatch-fixes
Applying: char: add aio_{read,write} to /dev/{null,zero}
Applying: aio: kill return value of aio_complete()
Applying: aio: add kiocb_cancel()
Applying: aio: move private stuff out of aio.h
Applying: aio: dprintk() -> pr_debug()
Applying: aio: do fget() after aio_get_req()
Applying: aio: make aio_put_req() lockless
Applying: aio-make-aio_put_req-lockless-checkpatch-fixes
Applying: aio: refcounting cleanup
Applying: aio-refcounting-cleanup-checkpatch-fixes
Applying: wait: add wait_event_hrtimeout()
Applying: aio: make aio_read_evt() more efficient, convert to hrtimers
Applying: aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpat=
ch-fixes
Applying: aio: use flush_dcache_page()
Applying: aio: use cancellation list lazily
Applying: aio: change reqs_active to include unreaped completions
Applying: aio: kill batch allocation
Applying: aio: kill struct aio_ring_info
Applying: aio: give shared kioctx fields their own cachelines
Applying: aio: reqs_active -> reqs_available
Applying: aio: percpu reqs_available
Applying: generic dynamic per cpu refcounting
Applying: generic-dynamic-per-cpu-refcounting-checkpatch-fixes
Applying: aio: percpu ioctx refcount
Applying: aio: use xchg() instead of completion_lock
Applying: aio: don't include aio.h in sched.h
Applying: aio-dont-include-aioh-in-schedh-fix
Applying: aio: kill ki_key
Applying: aio: kill ki_retry
Applying: aio-kill-ki_retry-checkpatch-fixes
Applying: block: prep work for batch completion
Applying: block-prep-work-for-batch-completion-checkpatch-fixes
Applying: block-prep-work-for-batch-completion-checkpatch merge fixes
Applying: block-prep-work-for-batch-completion-fix-2
Applying: block-prep-work-for-batch-completion-fix-3
Applying: block, aio: batch completion for bios/kiocbs
Applying: block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: fix kioctx not being freed after cancellation at exit time
Applying: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Applying: kconfig-consolidate-config_debug_strict_user_copy_checks-fix
Applying: kconfig menu: move Virtualization drivers near other virtualizati=
on options
Applying: init/Kconfig: make EXPERT as config instead of menuconfig
Applying: UAPI: Remove empty Kbuild files
Applying: kernel/sys.c: make prctl(PR_SET_MM) generally available
Applying: decompressor: add LZ4 decompressor module
Applying: lib: add support for LZ4-compressed kernel
Applying: arm: add support for LZ4-compressed kernel
Applying: x86: add support for LZ4-compressed kernel
Applying: lib: add lz4 compressor module
Applying: lib-add-lz4-compressor-module-fix
Applying: crypto: add lz4 Cryptographic API
Applying: crypto-add-lz4-cryptographic-api-fix
Applying: powerpc/mm/numa: use setup_nr_node_ids() fix
Merging akpm/master (a427346 powerpc/mm/numa: use setup_nr_node_ids() fix)
Applying: aio: kill ki_retry merge fix
[master 6dc59fb] Revert "rtlwifi: rtl8188ee: Enable build of new driver"

--Signature=_Thu__4_Apr_2013_18_22_32_+1100_H5+rUXdu8whs7rfc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXSo4AAoJEECxmPOUX5FEfkwP/i01iWpzyNbYKwCvVw2or/Ud
OO8NKoW+EY50jciVKLRT5TNQPvigK7vRvfb8YPTv3yi8kfBAmFg+Re+db15m6I8C
Pdzt1Cl2HlGP+CIhG+ae/qZcDimQv2K4d+iOL34/WElRGAvKCcTiH6XEEztxjf1J
YHWTqOpXBhMI9dUvoF4jmuhlvMoLbALiep01t0ftYdxSwEiPgloF7MZWwckWyDJA
QYq2qzsPZMKiOX0KtkZFya3D4v0SOjcwvlOFUl5Xw1W6xh0Z6i6BhuwThRpQiB6U
VfkeWs5n3R8NV4a3akQV4MVlFYstHVKEOl22WI95ig8E6dc4zTT1aT4uQzotkNQb
uleDVxXbn9ubjzp1s9skVSAps1u385IYdSawy62hW3voJECe2ym/hmbbqcXN7w4I
HtCiZwE6iLNgUW/rDhzdGEUgguIugzoeCu4N/Y+zRtozQx5Ui6hMOxuLtZNW9hsa
I4jHtomn+oPpMf44Q9vnWz9RGNCw3OqI9dzmw2fidLLn9uJR11oR+2Lym2VWFmUe
uQVeSgySF97eC4e1zbMOcV7MtQWUoGEaS+3xSvisNUsiWU/qL4ejn46858qnm7vW
70r/jhB6oEC8TjiMt5df6iGZYYnYoJRMmAsrbJcDY4G2KPqrcsdmhADG1twRmDQ7
g3BLKnwAC3/9lawe59CL
=drs/
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_18_22_32_+1100_H5+rUXdu8whs7rfc--
