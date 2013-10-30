Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3J3Hp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:45:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52049 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3J3HpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:45:23 -0400
Date: Wed, 30 Oct 2013 18:45:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Oct 30
Message-Id: <20131030184511.c90aa7f40fec6b2e1652f394@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Oct_2013_18_45_11_+1100_tDUXYw16vbPRuI8B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Oct_2013_18_45_11_+1100_tDUXYw16vbPRuI8B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

News:  I am now doing an arm multi_v7_defconfig build between each merge.

Changes since 20131029:

The arm defconfig build is fixed again.

The net-next tree gained a conflict against the net tree.

The xen-tip tree gained a conflict against the arm tree.

The akpm-current tree gained a conflict against the tip tree and a build
failure for which I reverted 3 commits.

Various build problems from yesterday have been resolved.

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
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES - this fails its final
link) and i386, sparc, sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 212 trees (counting Linus' and 30 trees of patches pending
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
Merging origin/master (7314e613d5ff Fix a few incorrectly checked [io_]rema=
p_pfn_range() calls)
Merging fixes/master (fa8218def1b1 Merge tag 'regmap-v3.11-rc7' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (020bc50bf8f6 ARC: SMP TLB flush)
Merging arm-current/fixes (0ea1ec713f04 ARM: dma-mapping: don't allow DMA m=
appings to be marked executable)
Merging m68k-current/for-linus (55490050df0f m68k/atari: ARAnyM - Always us=
e physical addresses in NatFeat calls)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (8b5ede69d24d powerpc/irq: Don't switch to irq =
stack from softirq stack)
Merging sparc/master (6d15ee492809 Merge git://git.kernel.org/pub/scm/virt/=
kvm/kvm)
Merging net/master (911aeb108493 Merge branch 'fixes' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/jesse/openvswitch)
Merging ipsec/master (eeb1b73378b5 xfrm: Increase the garbage collector thr=
eshold)
Merging sound-current/for-linus (1ac3293095de ALSA: hda - Fix silent headph=
one on Thinkpads with AD1984A codec)
Merging pci-current/for-linus (67d470e0e171 Revert "x86/PCI: MMCONFIG: Chec=
k earlier for MMCONFIG region at address zero")
Merging wireless/master (8ce9beac4661 drivers: net: wireless: b43: Fix poss=
ible NULL ptr dereference)
Merging driver-core.current/driver-core-linus (31d141e3a666 Linux 3.12-rc6)
Merging tty.current/tty-linus (6e757ad2c92c tty/serial: at91: fix uart/usar=
t selection for older products)
Merging usb.current/usb-linus (31d141e3a666 Linux 3.12-rc6)
Merging staging.current/staging-linus (31d141e3a666 Linux 3.12-rc6)
Merging char-misc.current/char-misc-linus (31d141e3a666 Linux 3.12-rc6)
Merging input-current/for-linus (2d3163f10256 Input: wacom - add support fo=
r ISDv4 0x10E sensor)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging audit-current/for-linus (c158a35c8a68 audit: no leading space in au=
dit_log_d_path prefix)
Merging crypto-current/master (26052f9b9bb8 crypto: crct10dif - Add fallbac=
k for broken initrds)
Merging ide/master (64110c16e012 ide: sgiioc4: Staticize ioc4_ide_attach_on=
e())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (d8524ae9d6f4 Merge branch 'drm-fixes' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging mfd-fixes/master (d0e639c9e06d Linux 3.12-rc4)
Merging vfio-fixes/for-linus (d93b3ac0edb8 VFIO: vfio_iommu_type1: fix bug =
caused by break in nested loop)
Merging drm-intel-fixes/for-linux-next-fixes (1fbc0d789d12 drm/i915: Fix th=
e PPT fdi lane bifurcate state handling on ivb)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (61e6cfa80de5 Linux 3.12-rc5)
Merging arm/for-next (e37c1a3f0bd1 Merge branches 'fixes', 'mmci' and 'sa11=
x0' into for-next)
Merging arm-perf/for-next/perf (15c03dd4859a Linux 3.12-rc3)
Merging arm64/upstream (d0f38f9130b7 arm64: update 32-bit kuser helpers to =
ARMv8)
Merging blackfin/for-linus (08b67faa23fd blackfin: Ignore generated uImages)
Merging c6x/for-linux-next (d90c3eb31535 Kconfig cleanup (PARPORT_PC depend=
encies))
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging h8300-remove/h8300-remove (ca40e295018f fs/minix: Drop dependency o=
n H8300)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d37bbb3ac5c6 Merge branch 'pstore' into next)
Merging m68k/for-next (77a42796786c m68k: Remove deprecated IRQF_DISABLED)
Merging m68knommu/for-next (959f58544b7f Linux 3.12-rc7)
Merging metag/for-next (b6ef9161e43a irq-imgpdc: add ImgTec PDC irqchip dri=
ver)
Merging microblaze/next (d5d04bb48f0e Bye, bye, WfW flag)
Merging mips/mips-for-linux-next (522649837f97 Merge branch '3.12-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (6af609515d78 openrisc: remove HAVE_VIRT_TO_B=
US)
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (89bcde9f4c7f parisc: make "make install" not de=
pend on vmlinux)
Merging powerpc/next (3ad26e5c4459 Merge branch 'for-kvm' into next)
Merging mpc5xxx/next (d75a212c7d79 Kind of revert "powerpc: 52xx: provide a=
 default in mpc52xx_irqhost_map()")
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (ac526f42abda tty/hvc_iucv: remove redundant NULL che=
ck)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1faf5595 Merge tag 'modules-next-for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (e823acc0a9e3 tile: remove stray blank space)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (8872366df396 xtensa: Fix broken allmodconfig build)
Merging aio-direct/for-next (bb6f7be48318 tmpfs: add support for read_iter =
and write_iter)
Merging btrfs/next (d7396f07358a Btrfs: optimize key searches in btrfs_sear=
ch_slot)
Merging ceph/master (53d028160f1a ceph: implement readv/preadv for sync ope=
ration)
Applying: ceph: Fix up for iov_iter changes
Merging cifs/for-next (3d4c7a41eec5 SMB2/SMB3 Copy offload support (refcopy=
) phase 1)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (959f58544b7f Linux 3.12-rc7)
Merging ext3/for_next (721a769c0342 reiserfs: fix race with flush_used_jour=
nal_lists and flush_journal_list)
Merging ext4/dev (efbed4dc5857 ext4: add ratelimiting to ext4 messages)
Merging f2fs/dev (cc3de6a3acce f2fs: fix calculating incorrect free size wh=
en update xattr in __f2fs_setxattr)
Merging fscache/fscache (f1fe29b4a02d NFS: Use i_writecount to control whet=
her to get an fscache cookie in nfs_open())
Merging fuse/for-next (16f60ab14ce2 fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (e66cf161098a GFS2: Use lockref for glocks)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (c698dbf9feca Merge branch 'fscache' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into linux-next)
Merging nfsd/nfsd-next (01a87d91fcec nfsd: no need to unhash_stid before fr=
ee)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (9e012423869e Squashfs: add corruption check for ty=
pe in squashfs_readdir())
Merging v9fs/for-next (94876b5bb6a8 9P: introduction of a new cache=3Dmmap =
model.)
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (c963c6193a5a xfs: split xfs_rtalloc.c for userspace s=
anity)
Merging vfs/for-next (dc03a60dfcff do_remount(): pull touch_mnt_namespace()=
 up)
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/9p/vfs_inode_dotl.c
CONFLICT (content): Merge conflict in fs/9p/vfs_inode.c
CONFLICT (content): Merge conflict in fs/9p/vfs_file.c
Merging pci/next (605d24005247 Merge branch 'pci/misc' into next)
Merging hid/for-next (deaed542efdb Merge branch 'for-3.13/holtek' into for-=
next)
Merging i2c/i2c/for-next (19e221bed222 i2c: mxs: Fix PIO mode on i.MX23)
Merging jdelvare-hwmon/master (0e7a3ed04f0c Merge branch 'perf-urgent-for-l=
inus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging hwmon-staging/hwmon-next (26336c8a36c0 hwmon: (w83793) Clean up a s=
ignedness issue)
Merging v4l-dvb/master (e329bac4416d Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (86dd0b57e56d Merge branches 'kbuild/kbuild' and 'k=
build/misc' into kbuild/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (e358127fdd22 ata: libata-eh: Remove unnecessary sn=
printf arithmetic)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (53e2cd4b26ff Merge branch 'master' into linux-next)
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging idle/next (d7b0a1b0b9b1 intel_idle: Support Intel Atom Processor C2=
000 Product Family)
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (79122105c394 Merge branches 'intel_powerclamp', 'misc=
' and 'x86_pkg_temp' of .git into next)
Merging ieee1394/for-next (db9ae8fec7b1 firewire: ohci: Fix deadlock at bus=
 reset)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (a97f4a66d8ee dlm: Avoid that dlm_release_lockspace() inco=
rrectly returns -EBUSY)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (51cd92a1a192 Merge branch 'dma_complete' into next)
Merging dmaengine/next (4a43f394a082 dmaengine: dma_sync_wait and dma_find_=
channel undefined)
Merging net-next/master (87f20c26f9c0 net/benet: Make lancer_wait_ready() s=
tatic)
CONFLICT (content): Merge conflict in drivers/net/netconsole.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be.h
CONFLICT (content): Merge conflict in arch/parisc/include/uapi/asm/socket.h
CONFLICT (modify/delete): arch/h8300/include/uapi/asm/socket.h deleted in H=
EAD and modified in net-next/master. Version net-next/master of arch/h8300/=
include/uapi/asm/socket.h left in tree.
$ git rm -f arch/h8300/include/uapi/asm/socket.h
Merging ipsec-next/master (1c5ad13f7c2b net: esp{4,6}: get rid of struct es=
p_data)
CONFLICT (content): Merge conflict in net/xfrm/xfrm_policy.c
Merging wireless-next/master (a1b13b9ad375 rt2x00: rt2800pci: use module_pc=
i_driver macro)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/pcie/drv=
.c
CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/brcmfm=
ac/sdio_host.h
Merging bluetooth/master (45e2a2e3756f Bluetooth: Fix limited discoverable =
mode for Zeevo modules)
Merging infiniband/for-next (a78fc816b361 Merge branches 'cma', 'ipoib', 'm=
isc', 'mlx5', 'ocrdma', 'qib' and 'srp' into for-next)
Merging mtd/master (d255c59aab2a Merge tag 'for-linus-20131025' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (dfe26c2dc684 mtd: m25p80: remove 'disabled' device c=
heck)
Merging crypto/master (c306a98d6376 crypto: talitos - Simplify key parsing)
Merging drm/drm-next (be51e4a78155 Merge tag 'drm-intel-next-2013-10-18' of=
 git://people.freedesktop.org/~danvet/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ddi.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_crt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Applying: drm/i915: Resolve interaction with drm-fixes tree
Merging drm-intel/for-linux-next (ddb642fb0566 drm/i915: rename i915_init_p=
ower_well to init_power_domains_init)
Merging drm-tegra/drm/for-next (f099513c3202 drm/tegra: Support bottom-up b=
uffer objects)
CONFLICT (content): Merge conflict in drivers/gpu/drm/tegra/Kconfig
CONFLICT (content): Merge conflict in MAINTAINERS
Merging sound/for-next (9cd5ab9c3c32 ALSA: lola: Fix uninitialized variable=
 access in error message)
Merging sound-asoc/for-next (72f2da67c585 Merge remote-tracking branch 'aso=
c/topic/wm8962' into asoc-next)
Merging modules/modules-next (eb3057df732c kernel: add support for init_arr=
ay constructors)
Merging virtio/virtio-next (630b54d33493 virtio_config: remove virtio_confi=
g_val)
Merging input/next (33777f34b5cc Input: fix PWM-related undefined reference=
 errors)
Merging input-mt/for-next (ad81f0545ef0 Linux 3.11-rc1)
Merging cgroup/for-next (0d60e6cd793e Merge branch 'for-3.13' into for-next)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Merging block/for-next (53a629c7acce Merge branch 'for-3.13/core' into for-=
next)
CONFLICT (content): Merge conflict in include/linux/blk_types.h
Merging device-mapper/for-next (8a478f032b40 dm crypt: add TCW IV mode for =
old CBC TCRYPT containers)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (9a8d2faaae4e mmc: core: Add MMC_CAP_RUNTIME_RESUME to=
 resume at runtime_resume)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (dbbebcb87055 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (555c28a5b0c1 raid1: Add some macros to make code clear=
ly.)
Merging mfd/master (4c78b520ee8f mfd: as3722: Don't export the regmap confi=
g)
CONFLICT (content): Merge conflict in sound/soc/codecs/mc13783.c
Merging mfd-lj/for-mfd-next (6bfd1e63de34 mfd: lpc_sch: Ignore resource con=
flicts when adding mfd cells)
Merging battery/master (588bd5918bac power_supply: Fix documentation for TE=
MP_*ALERT* properties)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Applying: video: xilinxfb: Fix for "Use standard variable name convention"
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (718b90ac4c21 video: xilinxfb: Simplify error pa=
th)
Merging regulator/for-next (4445d0094e75 Merge remote-tracking branch 'regu=
lator/topic/tps65910' into regulator-next)
Merging security/next (3ea7a56067e6 ima: provide hash algo info in the xatt=
r)
CONFLICT (content): Merge conflict in crypto/Makefile
Merging selinux/master (42d64e1add3a selinux: correct locking in selinux_ne=
tlbl_socket_connect))
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (a19ce9e987f9 watchdog: watchdog_core: Fix a trivia=
l typo)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (e6ca48d995e4 Merge branches 'iommu/fixes', 'tracing', '=
core', 'arm/tegra' and 'x86/vt-d' into next)
Merging vfio/next (15c03dd4859a Linux 3.12-rc3)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (ebd46f016a30 doc: add missing files to timers/00-=
INDEX)
CONFLICT (content): Merge conflict in net/netfilter/xt_set.c
Merging audit/for-next (dcd6c9226715 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (f7578496a671 of/irq: Use irq_of_parse_a=
nd_map())
Merging dt-rh/for-next (5116b1defad7 of: remove empty arch prom.h headers)
Applying: powerpc: add include of prom.h to fix powernv/rng.c build
Merging spi/for-next (f8ce25620cdc Merge remote-tracking branch 'spi/topic/=
wr' into spi-next)
CONFLICT (content): Merge conflict in drivers/spi/spi.c
Merging tip/auto-latest (fb5abcd26523 Merge branch 'x86/uaccess')
CONFLICT (modify/delete): tools/perf/config/feature-tests.mak deleted in ti=
p/auto-latest and modified in HEAD. Version HEAD of tools/perf/config/featu=
re-tests.mak left in tree.
CONFLICT (content): Merge conflict in tools/perf/config/Makefile
CONFLICT (content): Merge conflict in include/linux/wait.h
CONFLICT (content): Merge conflict in include/linux/acpi.h
CONFLICT (modify/delete): arch/h8300/include/asm/Kbuild deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/h8300/include=
/asm/Kbuild left in tree.
$ git rm -f arch/h8300/include/asm/Kbuild
$ git rm -f tools/perf/config/feature-tests.mak
Applying: tip: extra fixes for perf changes
Merging edac/linux_next (de4772c62148 edac: sb_edac.c should not require pr=
escence of IMC_DDRIO device)
Merging edac-amd/for-next (c3e511e4c4d9 amd64_edac: Remove superfluous cond=
ition check.)
Merging ftrace/for-next (29ad23b00474 ftrace: Add set_graph_notrace filter)
Merging rcu/rcu/next (4102adab9189 rcu: Move RCU-related source code to ker=
nel/rcu directory)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (d57014267489 Merge tag 'kvm-arm-for-3.13-1' of git:=
//git.linaro.org/people/cdall/linux-kvm-arm into next)
CONFLICT (content): Merge conflict in arch/arm/kvm/reset.c
Merging kvm-arm/kvm-arm-next (79c648806f90 arm/arm64: KVM: PSCI: use MPIDR =
to identify a target CPU)
CONFLICT (content): Merge conflict in arch/arm/kvm/reset.c
Merging kvm-ppc/kvm-ppc-next (d57014267489 Merge tag 'kvm-arm-for-3.13-1' o=
f git://git.linaro.org/people/cdall/linux-kvm-arm into next)
Merging oprofile/for-next (b574ae8c6a02 edac: Unify reporting of device inf=
o for device, mc and pci)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (af8bdd968a7e Merge branch 'swiotlb-xen' into xe=
ntip/linux-next)
CONFLICT (content): Merge conflict in arch/arm/include/asm/dma-mapping.h
Merging percpu/for-next (90f2492cf9c8 x86: remove this_cpu_xor() implementa=
tion)
Merging workqueues/for-next (016564d41b35 workqueue: fix pool ID allocation=
 leakage and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (5c07eae979df platform/x86: panasonic-laptop=
: reuse module_acpi_driver)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (04bc9ac163a2 Merge remote-tracking branch 'regmap/=
topic/spmi' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (30dae2f98612 leds: lp55xx: handle enable pin in driv=
er)
Merging driver-core/driver-core-next (d1c1459e4594 sysfs: separate out dup =
filename warning into a separate function)
CONFLICT (content): Merge conflict in include/linux/netdevice.h
CONFLICT (content): Merge conflict in drivers/mmc/host/mvsdio.c
Merging tty/tty-next (7ac57347c23d tty: xuartps: Fix build error when COMMO=
N_CLK is not set)
CONFLICT (content): Merge conflict in drivers/tty/serial/imx.c
CONFLICT (content): Merge conflict in drivers/tty/serial/atmel_serial.c
Merging usb/usb-next (a1924d8a1da2 usb/gadget: f_mass_storage: use string l=
iteral as format in dev_set_name)
CONFLICT (content): Merge conflict in drivers/usb/musb/davinci.c
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging usb-gadget/next (80d7d8a768cd usb: phy: twl6030-usb: Include linux/=
of.h header)
Merging staging/staging-next (0e51fc360f32 staging: r8188eu: Fix sparse war=
nings in rtl_p2p.c)
Merging char-misc/char-misc-next (629c66a22c21 lkdtm: isolate stack corrupt=
ion test)
Applying: Intel MIC Host Driver: fix for sysfs_get_dirent API change
Merging scsi/for-next (2aee240c68ed Merge branch 'misc' into for-next)
Merging target-updates/for-next (2dd1d53fe004 iscsi-target: Implement demo_=
mode_discovery logic)
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging bcon/master (e284f3493206 netconsole: s/syslogd/cancd/ in documenta=
tion)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (e16dbf601113 pinctrl: imx27: imx27 pincontrol dri=
ver)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (56a8b79e98ea gpiolib: provide a declaration of seq_f=
ile in gpio/driver.h)
Merging arm-soc/for-next (413cbdab707a Merge branch 'next/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/board-mop500.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/opp.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/omap3-evm.dts
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging bcm2835/for-next (7d132055814e Linux 3.10-rc6)
Merging cortex/for-next (0df651a0740c Merge branch 'parisc-3.12' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (e37856fdefe1 Merge branch 'imx/dt-3.14' into for-=
next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (e1b38e17e9a9 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (597472bb771b Merge branch 'heads/clock' into next)
Merging samsung/for-next (d2287944920d Merge branch 'v3.13-next/samsung' in=
to for-next)
Merging tegra/for-next (1ebd0d6a0589 Merge branch for-3.13/maintainers into=
 for-next)
CONFLICT (content): Merge conflict in MAINTAINERS
Merging dma-mapping/dma-mapping-next (0df651a0740c Merge branch 'parisc-3.1=
2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging pwm/for-next (702e304f198f Documentation/pwm: Fix trivial typos)
CONFLICT (modify/delete): arch/arm/mach-omap2/board-zoom-peripherals.c dele=
ted in HEAD and modified in pwm/for-next. Version pwm/for-next of arch/arm/=
mach-omap2/board-zoom-peripherals.c left in tree.
$ git rm -f arch/arm/mach-omap2/board-zoom-peripherals.c
Merging dma-buf/for-next (19e8697ba45e dma-buf: Expose buffer size to users=
pace (v2))
Merging userns/for-next (40216baa0101 vfs: Lazily remove mounts on unlinked=
 files and directories. v2)
CONFLICT (content): Merge conflict in fs/fuse/dir.c
Merging ktest/for-next (df5f7c66013c ktest: Reset grub menu cache with diff=
erent machines)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (f61027426a5b clk: of: helper for determining number o=
f parent clocks)
CONFLICT (content): Merge conflict in drivers/clk/Makefile
Merging random/dev (f80bbd8b9298 random: convert DEBUG_ENT to tracepoints)
CONFLICT (content): Merge conflict in drivers/char/random.c
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (5e9ae2e5da0b aio: fix use-after-free in aio_migratepage)
Merging akpm-current/current (c41533dd6ac2 ipc/util.c: remove unnecessary w=
ork pending test)
CONFLICT (content): Merge conflict in arch/x86/mm/init.c
[master e3abd9a3a96d] Revert "epoll-do-not-take-global-epmutex-for-simple-t=
opologies-fix"
[master 46e3a87d03bc] Revert "epoll: do not take global 'epmutex' for simpl=
e topologies"
[master bb45894af615] Revert "epoll: optimize EPOLL_CTL_DEL using rcu"
$ git checkout -b akpm remotes/origin/akpm/master
Applying: net/netfilter/ipset/ip_set_hash_netnet.c: fix build with older gcc
Applying: net/netfilter/ipset/ip_set_hash_netportnet.c: fix build with olde=
r gccs
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Applying: mm: avoid increase sizeof(struct page) due to split page table lo=
ck
Applying: mm: rename USE_SPLIT_PTLOCKS to USE_SPLIT_PTE_PTLOCKS
Applying: mm: convert mm->nr_ptes to atomic_long_t
Applying: mm: introduce api for split page table lock for PMD level
Applying: mm, thp: change pmd_trans_huge_lock() to return taken lock
Applying: mm, thp: move ptl taking inside page_check_address_pmd()
Applying: mm, thp: do not access mm->pmd_huge_pte directly
Applying: mm, hugetlb: convert hugetlbfs to use split pmd lock
Applying: mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fix=
es
Applying: mm: convert the rest to new page table lock api
Applying: mm: implement split page table lock for PMD level
Applying: x86, mm: enable split page table lock for PMD level
Applying: x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes
Applying: x86: add missed pgtable_pmd_page_ctor/dtor calls for preallocated=
 pmds
Applying: cris: fix potential NULL-pointer dereference
Applying: m32r: fix potential NULL-pointer dereference
Applying: xtensa: fix potential NULL-pointer dereference
Applying: mm: allow pgtable_page_ctor() to fail
Applying: microblaze: add missing pgtable_page_ctor/dtor calls
Applying: mn10300: add missing pgtable_page_ctor/dtor calls
Applying: openrisc: add missing pgtable_page_ctor/dtor calls
Applying: alpha: handle pgtable_page_ctor() fail
Applying: arc: handle pgtable_page_ctor() fail
Applying: arm: handle pgtable_page_ctor() fail
Applying: arm64: handle pgtable_page_ctor() fail
Applying: avr32: handle pgtable_page_ctor() fail
Applying: cris: handle pgtable_page_ctor() fail
Applying: frv: handle pgtable_page_ctor() fail
Applying: hexagon: handle pgtable_page_ctor() fail
Applying: ia64: handle pgtable_page_ctor() fail
Applying: m32r: handle pgtable_page_ctor() fail
Applying: m68k: handle pgtable_page_ctor() fail
Applying: m68k-handle-pgtable_page_ctor-fail-fix
Applying: m68k-handle-pgtable_page_ctor-fail-fix-fix
Applying: metag: handle pgtable_page_ctor() fail
Applying: mips: handle pgtable_page_ctor() fail
Applying: parisc: handle pgtable_page_ctor() fail
Applying: powerpc: handle pgtable_page_ctor() fail
Applying: s390: handle pgtable_page_ctor() fail
Applying: score: handle pgtable_page_ctor() fail
Applying: sh: handle pgtable_page_ctor() fail
Applying: sparc: handle pgtable_page_ctor() fail
Applying: tile: handle pgtable_page_ctor() fail
Applying: um: handle pgtable_page_ctor() fail
Applying: unicore32: handle pgtable_page_ctor() fail
Applying: x86: handle pgtable_page_ctor() fail
Applying: xtensa: handle pgtable_page_ctor() fail
Applying: iommu/arm-smmu: handle pgtable_page_ctor() fail
Applying: xtensa: use buddy allocator for PTE table
Applying: mm: dynamically allocate page->ptl if it cannot be embedded to st=
ruct page
Applying: mm: try to detect that page->ptl is in use
Applying: mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-stru=
ct-page-fix-fix
Applying: seq_file: introduce seq_setwidth() and seq_pad()
Applying: seq_file: remove "%n" usage from seq_file users
Applying: seq_file-remove-%n-usage-from-seq_file-users-fix
Applying: vsprintf: ignore %n again
Applying: drivers/rtc/rtc-hid-sensor-time.c: use dev_get_platdata()
Applying: drivers/rtc/rtc-hid-sensor-time.c: enable HID input processing ea=
rly
Applying: sched: replace INIT_COMPLETION with reinit_completion
Applying: tree-wide: use reinit_completion instead of INIT_COMPLETION
Applying: tree-wide-use-reinit_completion-instead-of-init_completion-fix
Applying: sched: remove INIT_COMPLETION
Merging akpm/master (592e45d2af59 sched: remove INIT_COMPLETION)

--Signature=_Wed__30_Oct_2013_18_45_11_+1100_tDUXYw16vbPRuI8B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScLkOAAoJEMDTa8Ir7ZwVXPEQAIalUq7KqYXmNUuyPxxdo1e8
GYBu0s5c8JTZ7/1lWOu4klW8dqk67iQeiOrQWs3u/dhUiWE1+ZtaQ5vJPUYkaQO2
7IplZkCYBe/ii4rTsm5zuVuw1mxO6Ebsj2Zt8azAIOvlT7CCTZbtQCQwPbQUhSMS
DzJezZ1mrk+sMAZbjUhTRKx000vw1t9FtqIkfpZY5ZWSvgI/VX7F6y+MHN9F7uI8
PgYIAaDA4lTuHqgYfd5sAO4lpGGHWO992InRHDChIyqedVULI1BNKqxafRtcIHnf
IlkgH7ng6aR+3n/kbN1fPXZjkjQUmX/yKHab+cZMHI4EUCoaflb52wZsEUcsc3jJ
ZBJllY3GS8AIPD2DEJrwZkSzkXrLwJmLPfOwFkyl3gYmwJJwZ+2BhhTDXv2VDXEF
/eFyB2QFQJHY2arDPetJGGn3aIFlMOYQhw76vDyRW+FK7a3gct/oiWVx73TwcbEj
Pxij+eHFV/AUjLpBBwsEb9ul4APoaT1P2kBCqheN6h7glinpZTW8riYPlocKhtDc
z2nQhuUBu/Dip4J720/vxItNNd9n/fMHReo2A34Mq67bKHf1+BdrIJkazloc1mJG
JMTZBUbMbLMRprsobpFr7x0mijjeuPJ2ONVO/8CC+jBbAxxXsumRusixFA/AmtdS
Gm55BFtLFPaRLwJ7ORJd
=oJpO
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Oct_2013_18_45_11_+1100_tDUXYw16vbPRuI8B--
