Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3LFDtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:49:35 -0500
Received: from ozlabs.org ([203.10.76.45]:48458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3LFDtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:49:31 -0500
Date: Fri, 6 Dec 2013 14:49:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 6
Message-Id: <20131206144924.dd26a33a577672ca7bda3eaa@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Dec_2013_14_49_24_+1100__8IvgOtyP+7hymaD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Dec_2013_14_49_24_+1100__8IvgOtyP+7hymaD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131205:

The crypto tree gained a build failure so I used the version from
next-20131205.

Non-merge commits (relative to Linus' tree): 2639
 2875 files changed, 111902 insertions(+), 72577 deletions(-)

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

I am currently merging 210 trees (counting Linus' and 29 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

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
Stephen Rothwell <sfr@canb.auug.org.au>

$ git checkout master
$ git reset --hard stable
Merging origin/master (29be6345bbae Merge tag 'nfs-for-3.13-3' of git://git=
.linux-nfs.org/projects/trondmy/linux-nfs)
Merging fixes/master (8ae516aa8b81 Merge tag 'trace-fixes-v3.13-rc1' of git=
://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (da990a4f2d5a ARC: [perf] Fix a few thinkos)
Merging arm-current/fixes (11d4bb1bd067 ARM: 7907/1: lib: delay-loop: Add a=
lign directive to fix BogoMIPS calculation)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (721cb59e9d95 powerpc/windfarm: Fix XServe G5 f=
an control Makefile issue)
Merging sparc/master (1de425c7b271 sparc64: Fix build regression)
Merging net/master (e1ca87bb1b64 Merge branch 'for-davem' of git://git.kern=
el.org/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (dff345c5c85d be2net: call napi_disable() for all even=
t queues)
Merging sound-current/for-linus (18e4753ff3c8 ALSA: usb-audio: fix uninitia=
lized variable compile warning)
Merging pci-current/for-linus (4bff6749905d PCI: Move device_del() from pci=
_stop_dev() to pci_destroy_dev())
Merging wireless/master (a59b40b30f3f Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (dc1ccc48159d Linux 3.13-rc2)
Merging tty.current/tty-linus (39434abd942c n_tty: Fix missing newline echo)
Merging usb.current/usb-linus (2d51f3cd11f4 usb: hub: Use correct reset for=
 wedged USB3 devices that are NOTATTACHED)
Merging staging.current/staging-linus (55ef003e4ae6 Merge tag 'iio-fixes-fo=
r-3.13b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (76a9635979e5 mei: add 9 series P=
CH mei device ids)
Merging input-current/for-linus (95f75e91588a Input: ALPS - add support for=
 DualPoint device on Dell XT2 model)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (8ec25c512916 crypto: testmgr - fix sglen in =
test_aead for case 'dst !=3D src')
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (3459f11a8b16 virtio_balloon: update_balloon_size():=
 update correct field)
Merging mfd-fixes/master (88ec6a4d8369 Merge tag 'mfd-lee-3.13-fixes-1' of =
git://git.linaro.org/people/ljones/mfd)
Merging vfio-fixes/for-linus (dc1ccc48159d Linux 3.13-rc2)
Merging drm-intel-fixes/for-linux-next-fixes (0d1430a3f4b7 drm/i915: Hold m=
utex across i915_gem_release)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (035a20627b46 ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (fb4bdc534590 Merge branches 'fixes', 'kees' and 'misc=
' into for-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (2e3b55132560 Merge branch 'fixes' into for-next)
Merging arm-v7-cache-opt/v7-cache-opt (e11d68fee368 arm: mm: refactor v7 ca=
che cleaning ops to use way/index sequence)
Merging bcm2835/for-next (18e3c64befe5 Merge branch 'for-3.14/defconfig' in=
to for-next)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (5d49e797de3a Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (02d93eb266e3 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (e715696ab1b7 Merge branch 'heads/usb-r8a66597-hcd' in=
to next)
Merging samsung/for-next (8465d57097ce Merge branch 'v3.14-next/samsung-def=
config' into for-next)
Merging tegra/for-next (850500ad1edd Merge branch for-3.14/dt into for-next)
Merging arm64/upstream (dc1ccc48159d Linux 3.13-rc2)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (959f58544b7f Linux 3.12-rc7)
Merging m68k/for-next (50190edb2a56 m68k/amiga: Provide mach_random_get_ent=
ropy())
Merging m68knommu/for-next (d4d80b54a862 m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (1d61cf121d7d smp, metag: kill SMP single function c=
all interrupt)
Merging microblaze/next (a1dd107fcafa microblaze: Remove duplicate declarat=
ions of _stext[] and _etext[])
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (dc1ccc48159d Linux 3.13-rc2)
Merging powerpc/next (66c29da6782b powerpc/powernv: Replace CONFIG_POWERNV_=
MSI with just CONFIG_PPC_POWERNV)
Merging mpc5xxx/next (4384290b1f1a powerpc/512x: dts: remove misplaced IRQ =
spec from 'soc' node)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (c9b851905dba s390/blacklist: Perform subchannel scan=
 only when needed)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (3bf4c10bb2e3 xtensa: implement CPU hotplug)
Merging btrfs/next (91aef86f3b8a Btrfs: rename btrfs_start_all_delalloc_ino=
des)
Merging ceph/master (ff638b7df5a9 ceph: allocate non-zero page to fscache i=
n readpage())
Merging cifs/for-next (dea4f48a0a30 Merge branch 'leds-fixes-for-3.13' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (2000f5beabc9 eCryptfs: file->private_data is always =
valid)
Merging ext3/for_next (df4e7ac0bb70 ext2: Fix oops in ext2_get_block() call=
ed from ext2_quota_write())
Merging ext4/dev (0826a7e1ffac ext4: check for overlapping extents in ext4_=
valid_extent_entries())
Merging f2fs/dev (0491fe20cb11 f2fs: replace the debugfs_root with f2fs_deb=
ugfs_root)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (c599ca2dc6f5 GFS2: Remove test which is always true)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (3873d064b853 nfs: fix do_div() warning by instead u=
sing sector_div())
Merging nfsd/nfsd-next (d2c2ad54c485 Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f94741fd2832 net/9p: remove virtio default hack and =
set appropriate bits instead)
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (ef701600fd26 xfs: fix memory leak in xfs_dir2_node_re=
movename)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (6ce4eac1f600 Linux 3.13-rc1)
Merging hid/for-next (074fb898390b Merge branch 'for-3.14/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (af91706d5dde ima: store address of template_fmt_c=
opy in a pointer before calling strsep)
Merging jdelvare-hwmon/master (024cd034d0e6 hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (7f438058ec86 hwmon: remove DEFINE_PCI_DEV=
ICE_TABLE macro)
Merging v4l-dvb/master (258a9e5cbc63 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (e6483a58eca6 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (c5fd0781fbae Merge branch 'for-3.14' into for-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (a91a2b84c04d Merge branch 'acpi-hotplug-next' into l=
inux-next)
Merging idle/next (1ae2a8af4228 tools/power turbostat: run on HSX)
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (86e0a0bdf81c Merge branches 'intel_powerclamp', 'tmon=
' and 'misc' of .git into next)
Merging ieee1394/for-next (db9ae8fec7b1 firewire: ohci: Fix deadlock at bus=
 reset)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (a97f4a66d8ee dlm: Avoid that dlm_release_lockspace() inco=
rrectly returns -EBUSY)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (29732357a296 Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (6ce4eac1f600 Linux 3.13-rc1)
Merging net-next/master (e1ca87bb1b64 Merge branch 'for-davem' of git://git=
.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec-next/master (9bb8ca86075f virtio-net: switch to use XPS to ch=
oose txq)
Merging wireless-next/master (251c9ba19143 ath: fix dynamic user regulatory=
 domain support)
CONFLICT (content): Merge conflict in net/mac80211/util.c
CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/Kconfig
Merging bluetooth/master (0ce43ce60d5e Bluetooth: Simplify l2cap_chan initi=
alization for LE CoC)
Merging infiniband/for-next (b4fdf52b3fc8 Merge branches 'cma', 'cxgb4', 'f=
lowsteer', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'srp=
' into for-next)
Merging mtd/master (6ce4eac1f600 Linux 3.13-rc1)
Merging l2-mtd/master (1947664f29db mtd: tests: mtd_nandecctest: Use IS_ENA=
BLED() macro)
Merging crypto/master (f7b2b5dd6a62 crypto: omap-aes - add error check for =
pm_runtime_get_sync)
$ git reset --hard HEAD^
Merging next-20131205 version of crypto
Merging drm/drm-next (a3483353ca4e drm: check for !kdev in drm_unplug_minor=
())
Merging drm-intel/for-linux-next (d299cce76e00 drm/i915: check context rese=
t stats before relocations)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
Merging sound/for-next (b13a714923fe ALSA: AACI: Convert to modern PM ops)
Merging sound-asoc/for-next (04a1c49aa897 Merge remote-tracking branches 'a=
soc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/adsp', 'asoc/topic/ak4=
641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc/topic/bcm2835', 'aso=
c/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topic/da7210', 'asoc/topic/ep9=
3xx', 'asoc/topic/fsl', 'asoc/topic/hdmi', 'asoc/topic/jack', 'asoc/topic/j=
z4740', 'asoc/topic/max98090', 'asoc/topic/mxs', 'asoc/topic/omap', 'asoc/t=
opic/rcar', 'asoc/topic/samsung', 'asoc/topic/spear', 'asoc/topic/ssm2602',=
 'asoc/topic/tegra', 'asoc/topic/uda1380', 'asoc/topic/wm8510', 'asoc/topic=
/wm8523', 'asoc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm8728', 'a=
soc/topic/wm8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc/topic/wm=
8753', 'asoc/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm8900', 'asoc=
/topic/wm8901', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/topic/wm897=
4', 'asoc/topic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/to=
pic/wm8991', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm9081' =
and 'asoc/topic/x86' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (54f05e95132b Input: sh_keysc - restrict non-COMPILE_TES=
T compilation)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (ac62b401a590 Merge branch 'for-3.14' into for-next)
Merging block/for-next (391b7a7bfb52 Merge branch 'for-3.14/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
Merging device-mapper/for-next (27cafc612c3b dm snapshot: avoid snapshot sp=
ace leak on crash)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (e395c4387c74 mmc: wbsd: Silence compiler warning)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (a8c0b0837359 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (6d183de40771 md/raid5: fix newly-broken locking in get=
_active_stripe.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (2b12ea963aa2 mfd: wm831x: Use PM ops for shutd=
own)
Merging battery/master (d36240d26025 power_supply: Add power_supply notifie=
r)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (46ac29568e63 video: vt8500: fix error handling =
in probe())
Merging regulator/for-next (62d41257a174 Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/arizona', 'regulator/topic/gpio', '=
regulator/topic/lp3971', 'regulator/topic/lp3972', 'regulator/topic/pcf5063=
3' and 'regulator/topic/tps51632' into regulator-next)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
Merging selinux/master (0b1f24e6db9a selinux: pull address family directly =
from the request_sock struct)
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (0a9cc5eca904 sc1200_wdt: Fix oops)
CONFLICT (add/add): Merge conflict in drivers/watchdog/rt2880_wdt.c
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (e6ca48d995e4 Merge branches 'iommu/fixes', 'tracing', '=
core', 'arm/tegra' and 'x86/vt-d' into next)
Merging vfio/next (15c03dd4859a Linux 3.12-rc3)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (6bbdc3984efb vio: remove dangly makefile bits)
Merging audit/master (fc582aef7dcc Merge tag 'v3.12')
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (1b50b0c3330e Merge branch 'for-3.14' into for-next)
Merging spi/for-next (6099087e62df Merge remote-tracking branches 'spi/topi=
c/atmel', 'spi/topic/bcm63xx-hsspi', 'spi/topic/coldfire', 'spi/topic/davin=
ci', 'spi/topic/falcon', 'spi/topic/gpio', 'spi/topic/msiof', 'spi/topic/om=
ap', 'spi/topic/pci', 'spi/topic/rcar', 'spi/topic/sc18is602' and 'spi/topi=
c/xcomm' into spi-next)
Merging tip/auto-latest (c4372b1b29f2 Merge branch 'x86/urgent')
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c92132f59806 edac/85xx: Add PCIe error interrupt=
 edac support)
Merging ftrace/for-next (8a56d7761d2d ftrace: Fix function graph with loadi=
ng of modules)
Merging rcu/rcu/next (9dd97744fb2f Merge branches 'doc.2013.12.03a', 'fixes=
.2013.12.03a', 'rcutorture.2013.12.03a' and 'sparse.2013.12.03a' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (d6d63b51fe3b Merge tag 'kvm-s390-20131128' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next)
Merging kvm-arm/kvm-arm-next (ede582224231 Merge tag 'kvm-arm64/for-3.13-1'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms into kv=
m-next)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (aa5437afa9b3 Merge branch 'xentip-3.13-3' into =
linux-next-3)
Merging percpu/for-next (b1a0fbfdde65 percpu: fix spurious sparse warnings =
from DEFINE_PER_CPU())
Merging workqueues/for-next (4e8b22bd1a37 workqueue: fix pool ID allocation=
 leakage and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (a80e1053aaa3 x86, wmi fix modalias_show ret=
urn values)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (d929555edfba Merge remote-tracking branch 'regmap/=
topic/core' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (4a87d107bfc3 leds: lp5521/5523: Remove duplicate mut=
ex)
Merging driver-core/driver-core-next (2322392b020b kernfs: implement "trust=
ed.*" xattr support)
Merging tty/tty-next (dc1ccc48159d Linux 3.13-rc2)
Merging usb/usb-next (2e30d14f1242 USB: fix coccinelle warnings)
Merging usb-gadget/next (989c78dd5630 usb: gadget: r8a66597-udc: convert to=
 clk_prepare/unprepare)
Merging staging/staging-next (58b179dcf28c staging: dwc2: disable uframe_sc=
hed on the bcm2835)
CONFLICT (content): Merge conflict in include/linux/hid-sensor-ids.h
Merging char-misc/char-misc-next (b0abd6ee9e4f misc: bmp085: devicetree irq=
 update.)
Merging scsi/for-next (ef5cb624a9b2 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (86784c6bdeee iscsi-target: chap auth shoul=
dn't match username with trailing garbage)
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (a8b2d7c89dc8 Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (40e3b642538b Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (6ca142ad0d1b pwm: sysfs: Convert to use ATTRIBUTE_GRO=
UPS macro)
Merging dma-buf/for-next (19e8697ba45e dma-buf: Expose buffer size to users=
pace (v2))
Merging userns/for-next (41301ae78a99 vfs: Fix a regression in mounting pro=
c)
Merging ktest/for-next (298a0d1d5750 ktest: Add documentation of CLOSE_CONS=
OLE_SIGNAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (cdf64eeeb0d7 clk: exynos5420: fix cpll clock register=
 offsets)
Merging random/dev (392a546dc836 random: add debugging code to detect early=
 use of get_random_bytes())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (ddb8c45ba151 aio: nullify aio->ring_pages after freeing=
 it)
Merging akpm-current/current (6e7ebeb1cb49 lib/decompress_unlz4.c: always s=
et an error return code on failures)
CONFLICT (content): Merge conflict in kernel/params.c
CONFLICT (content): Merge conflict in arch/um/kernel/sysrq.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: mm: add strictlimit knob
Merging akpm/master (1f86bd878a86 mm: add strictlimit knob)

--Signature=_Fri__6_Dec_2013_14_49_24_+1100__8IvgOtyP+7hymaD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSoUlIAAoJEMDTa8Ir7ZwVsx0P/j0TZyukupPgGToyV2mEnz/j
flQKPbxM+rAYwvzOItogZniFrvxpryNuZuJDXEmCMGfXpkFdDIOJcTTjsjHwpOHx
4rS1nPJHevP5bUk82luH9kLlyP52D31I30+CjRJ43CM8A1L1Ais/L7bOMoT1kXLG
HCcNjIZqirGUR8GtqsyfgwMEfFVpiPRG/CN9YlvM9HY4qaZ9xYkp01MxuVZih/nY
DwjYxCQqWVEA3KIghnAuscxFwaR6ZpgpIDnhF4LriBYUPsIX3SC3IKe4x88cWT63
Gosg9srlXdYXb3SiXUJkD54hodnTOiqboceAIfVb8TohWTw4VsEcOjjwMNR9fysZ
mTUpz1FTOlmr9koc4P6mNXgEvEAPDUJ7U7LktTKbdSezDBXBT9EobrRghchox0OC
Uywrh3KSzE1XOvZMpFd8hgeQmPvjtU5w+h+/lZtR6Ks2Y+9pNBXfht9kwsuK1PjX
ceAYgZtOS3b2NWlMqFM5kExRyPNqo+ZnRKc1N2/qYAN/IoEUERI2anMyd3CRssq5
P3LJ/7fqCcVM8tPewmn2ev5GeSt0qHNZwrJLFDjIPdfw5xEBL0ItJjG1TY1LaGoz
UnqXgdL9Mc/or4Yht53HL/SOYtBJ2td3VFueX8yyPq8PPorG/sAP0esNsMylpIFC
p9ZZYlrJbK0oyA4JjMOk
=tbIB
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Dec_2013_14_49_24_+1100__8IvgOtyP+7hymaD--
