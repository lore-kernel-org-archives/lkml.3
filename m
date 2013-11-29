Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3K2Cpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:45:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53782 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3K2Cpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:45:46 -0500
Date: Fri, 29 Nov 2013 13:45:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 29
Message-Id: <20131129134535.f886fbf966dcfea00178a1b7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Nov_2013_13_45_35_+1100_6kS6fM/rVGcCdJN4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Nov_2013_13_45_35_+1100_6kS6fM/rVGcCdJN4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131128:

The slave-dma tree gained conflicts against the imx-mxs tree.

The sound-asoc tree gained a build failure so I used teh version from
next-20131128.

Non-merge commits (relative to Linus' tree): 1585
 1774 files changed, 68549 insertions(+), 33718 deletions(-)

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
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (dda9cc3a1451 Merge tag 'gpio-v3.13-2' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio)
Merging fixes/master (8ae516aa8b81 Merge tag 'trace-fixes-v3.13-rc1' of git=
://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (da990a4f2d5a ARC: [perf] Fix a few thinkos)
Merging arm-current/fixes (476d1c03d202 ARM: dma-mapping: check DMA mask ag=
ainst available memory)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (721cb59e9d95 powerpc/windfarm: Fix XServe G5 f=
an control Makefile issue)
Merging sparc/master (b4789b8e6be3 aacraid: prevent invalid pointer derefer=
ence)
Merging net/master (2c7a9dc16416 be2net: Avoid programming permenant MAC by=
 BE3-R VFs)
Merging ipsec/master (be408cd3e1fe Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging sound-current/for-linus (eb9ca3ab2194 ALSA: hda - Add LFE chmap to =
ASUS ET2700)
Merging pci-current/for-linus (4bff6749905d PCI: Move device_del() from pci=
_stop_dev() to pci_destroy_dev())
Merging wireless/master (d5aedd7e1b2f Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/jberg/mac80211)
Merging driver-core.current/driver-core-linus (81440e737444 Revert "sysfs: =
handle duplicate removal attempts in sysfs_remove_group()")
Merging tty.current/tty-linus (c42b4e6501cd Revert "n_gsm: race between ld =
close and gsmtty open")
Merging usb.current/usb-linus (c24cb6c8b501 Merge tag 'fixes-for-v3.13-rc2'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging staging.current/staging-linus (930ba4a374b9 Staging: tidspbridge: d=
isable driver)
Merging char-misc.current/char-misc-linus (d0b00d3fb96d Merge tag 'extcon-l=
inus-for-3.13-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo=
/extcon into char-misc-linus)
Merging input-current/for-linus (358f24704f2f Input: add key code for ambie=
nt light sensor button)
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
Merging rr-fixes/fixes (f6537f2f0eba scripts/kallsyms: filter symbols not i=
n kernel address space)
Merging mfd-fixes/master (88ec6a4d8369 Merge tag 'mfd-lee-3.13-fixes-1' of =
git://git.linaro.org/people/ljones/mfd)
Merging vfio-fixes/for-linus (d93b3ac0edb8 VFIO: vfio_iommu_type1: fix bug =
caused by break in nested loop)
Merging drm-intel-fixes/for-linux-next-fixes (32cf0cb02948 drm/i915: Fix pi=
pe CSC post offset calculation)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (418556e7743b ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (e69662a3b19d Merge branches 'fixes', 'kees' and 'misc=
' into for-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (9f6f9eb67d48 Merge branch 'fixes' into for-next)
Merging arm-v7-cache-opt/v7-cache-opt (e11d68fee368 arm: mm: refactor v7 ca=
che cleaning ops to use way/index sequence)
Merging bcm2835/for-next (7d132055814e Linux 3.10-rc6)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (8bb2a9b78b11 Merge branches 'imx/soc' and 'imx/dt=
' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (e210fca4aaf9 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (4c92422b0a8c Merge tag 'renesas-clocksource-for-v3.13=
' into devel)
Merging samsung/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging tegra/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging arm64/upstream (67317c268956 ARM64: /proc/interrupts: display IPIs =
of online CPUs only)
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
Merging metag/for-next (cdf8d75818e3 metag: dma: remove dead code in dma_al=
loc_init())
Merging microblaze/next (a1dd107fcafa microblaze: Remove duplicate declarat=
ions of _stext[] and _etext[])
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (82023bb7f75b Merge tag 'pm+acpi-2-3.13-rc1' of =
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging powerpc/next (280270828f10 powerpc: Wrong DWARF CFI in the kernel v=
dso for little-endian / ELFv2)
Merging mpc5xxx/next (7e198197ec87 powerpc/mpc512x: remove unnecessary #if)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (f83bc037ad05 s390/blacklist: Perform subchannel scan=
 only when needed)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (9248053f80fd tile: Remove tile-specific _sinitdata and=
 _einitdata)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (dcc345a63b61 xtensa: implement CPU hotplug)
Merging btrfs/next (91aef86f3b8a Btrfs: rename btrfs_start_all_delalloc_ino=
des)
Merging ceph/master (02d794b3142e ceph: allocate non-zero page to fscache i=
n readpage())
Merging cifs/for-next (75e068fa2439 mounting SMB2 with mapchars fails)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (2000f5beabc9 eCryptfs: file->private_data is always =
valid)
Merging ext3/for_next (7ba3ec5749dd ext2: Fix fs corruption in ext2_get_xip=
_mem())
Merging ext4/dev (3f61c0cc706d ext4: add prototypes for macro-generated fun=
ctions)
Merging f2fs/dev (4607fbf82668 f2fs: send REQ_META or REQ_PRIO when reading=
 meta area)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (7a66e7559ea8 GFS2: Remove gfs2_quota_change_host struc=
ture)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (c97cf606e43b NFSv4: Update list of irrecoverable er=
rors on DELEGRETURN)
Merging nfsd/nfsd-next (d2c2ad54c485 Merge git://git.kernel.org/pub/scm/lin=
ux/kernel/git/davem/net)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f94741fd2832 net/9p: remove virtio default hack and =
set appropriate bits instead)
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (2fe8c1c08b3f xfs: open code inc_inode_iversion when l=
ogging an inode)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (6ce4eac1f600 Linux 3.13-rc1)
Merging hid/for-next (9ac5fb6d7fc1 Merge branch 'for-3.14/i2c-hid' into for=
-next)
Merging i2c/i2c/for-next (07a27a004727 i2c: bcm2835: Linking platform nodes=
 to adapter nodes)
Merging jdelvare-hwmon/master (b16f9771248b hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (6ce4eac1f600 Linux 3.13-rc1)
Merging v4l-dvb/master (52eca34d5e35 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (e6483a58eca6 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (d665f5f731f0 Merge branch 'for-3.13-fixes' into fo=
r-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (089a1c0be213 Merge branch 'pm-cpufreq-next' into lin=
ux-next)
Merging idle/next (8de8187d167c Merge branches 'acpi-blacklist-year' and 'a=
vn-upstream' into release)
CONFLICT (content): Merge conflict in drivers/idle/intel_idle.c
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
Merging slave-dma/next (8dfdf72daeaf Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (82a1402eaee5 dma: mv_xor: Fix mis-usage of mmio 'ba=
se' and 'high_base' registers)
Merging net-next/master (42a2d923cc34 Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net-next)
Merging ipsec-next/master (9bb8ca86075f virtio-net: switch to use XPS to ch=
oose txq)
Merging wireless-next/master (9d8506cc2d7e gso: handle new frag_list of fra=
gs GRO packets)
Merging bluetooth/master (c2e1182218ac Bluetooth: Enable autosuspend for In=
tel Bluetooth device)
Merging infiniband/for-next (b4fdf52b3fc8 Merge branches 'cma', 'cxgb4', 'f=
lowsteer', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'srp=
' into for-next)
Merging mtd/master (6ce4eac1f600 Linux 3.13-rc1)
Merging l2-mtd/master (e2b856498bb0 mtd: dataflash: remove unnecessary spi_=
set_drvdata())
Merging crypto/master (f262f0f5cad0 crypto: s390 - Fix aes-cbc IV corruptio=
n)
Merging drm/drm-next (a3483353ca4e drm: check for !kdev in drm_unplug_minor=
())
Merging drm-intel/for-linux-next (c19de8eb67f7 drm/i915: Return a drm_mode_=
status enum in the mode_valid vfuncs)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
Merging sound/for-next (e7c263718324 ALSA: hda/realtek - Add more codecs al=
ias name for Dell)
Merging sound-asoc/for-next (cdb40f07be87 Merge remote-tracking branches 'a=
soc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/ak4641', 'asoc/topic/a=
k4642', 'asoc/topic/arizona', 'asoc/topic/bcm2835', 'asoc/topic/cs4271', 'a=
soc/topic/cs42l52', 'asoc/topic/da7210', 'asoc/topic/fsl', 'asoc/topic/hdmi=
', 'asoc/topic/jack', 'asoc/topic/omap', 'asoc/topic/rcar', 'asoc/topic/spe=
ar', 'asoc/topic/ssm2602', 'asoc/topic/uda1380', 'asoc/topic/wm8510', 'asoc=
/topic/wm8523', 'asoc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm872=
8', 'asoc/topic/wm8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc/to=
pic/wm8753', 'asoc/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm8900',=
 'asoc/topic/wm8901', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/topic=
/wm8974', 'asoc/topic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990', 'a=
soc/topic/wm8991', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm=
9081' and 'asoc/topic/x86' into asoc-next)
$ git reset --hard HEAD^
Merging next-20131128 version of sound-asoc
Merging modules/modules-next (b6568b1a19ad modpost: fix bogus 'exported twi=
ce' warnings.)
Merging virtio/virtio-next (cdd77e87eae5 x86, asmlinkage, lguest: Pass in g=
lobals into assembler statement)
Merging input/next (976358e23435 Input: add a new driver for GPIO beeper)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (f28a2cfe2871 Merge branch 'for-3.14' into for-next)
Merging block/for-next (3bca3547dd4a Merge branch 'for-3.14/core' into for-=
next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
Applying: f2fs: cope with bvec iterator abstraction
Merging device-mapper/for-next (f0417b93a59e dm cache: update Documentation=
 for invalidate_cblocks's range syntax)
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
Merging mfd-lj/for-mfd-next (d0436a3dab1f Merge branch 'ib-asoc' into for-m=
fd-next)
CONFLICT (content): Merge conflict in drivers/mfd/arizona-core.c
Merging battery/master (c8024234c20e pm2301-charger: Remove unneeded NULL c=
hecks)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (3a41c5dbe8bc fb: reorder the lock sequence to f=
ix potential dead lock)
Merging regulator/for-next (5192e9dcd845 Merge remote-tracking branches 're=
gulator/topic/arizona', 'regulator/topic/lp3971', 'regulator/topic/lp3972' =
and 'regulator/topic/tps51632' into regulator-next)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
Merging selinux/master (94851b18d4eb Merge tag 'v3.12')
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (608564867a38 watchdog: Drop unnecessary include of=
 miscdevice.h)
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
Merging trivial/for-next (2bb9936beac2 doc: usb: Fix typo in Documentation/=
usb/gadget_configs.txt)
Merging audit/master (fc582aef7dcc Merge tag 'v3.12')
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (c11eede69b6a powerpc: add missing explicit OF inclu=
des for ppc)
Merging spi/for-next (5eeeb6ffab9a Merge remote-tracking branches 'spi/topi=
c/davinci', 'spi/topic/gpio', 'spi/topic/msiof', 'spi/topic/omap' and 'spi/=
topic/rcar' into spi-next)
Merging tip/auto-latest (6a4d0941dae2 Merge branch 'x86/mm')
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c92132f59806 edac/85xx: Add PCIe error interrupt=
 edac support)
Merging ftrace/for-next (8a56d7761d2d ftrace: Fix function graph with loadi=
ng of modules)
Merging rcu/rcu/next (4102adab9189 rcu: Move RCU-related source code to ker=
nel/rcu directory)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (0a00a775d2a4 KVM: Change maintainer email address)
Merging kvm-arm/kvm-arm-next (ede582224231 Merge tag 'kvm-arm64/for-3.13-1'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms into kv=
m-next)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (2b347c70b36f Merge branch 'stable/for-linus-3.1=
3' into linux-next)
Merging percpu/for-next (90f2492cf9c8 x86: remove this_cpu_xor() implementa=
tion)
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
Merging leds/for-next (07d0ea496eec LEDS: tca6507 - fix up some comments.)
Merging driver-core/driver-core-next (44c3eea65000 Merge branch 'driver-cor=
e-linus' into driver-core-next)
Merging tty/tty-next (6ce4eac1f600 Linux 3.13-rc1)
Merging usb/usb-next (6ce4eac1f600 Linux 3.13-rc1)
Merging usb-gadget/next (989c78dd5630 usb: gadget: r8a66597-udc: convert to=
 clk_prepare/unprepare)
Merging staging/staging-next (931cf48d2db6 staging: comedi: unionxx5: tidy =
up some dev_{level} messages)
Merging char-misc/char-misc-next (10ee90743e99 mei: cleanup mei_irq_read_ha=
ndler)
Merging scsi/for-next (2aee240c68ed Merge branch 'misc' into for-next)
Merging target-updates/for-next (86784c6bdeee iscsi-target: chap auth shoul=
dn't match username with trailing garbage)
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (b221209faa58 Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (aaeaaa660ccb Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (1b3f25ce991d Documentation/pwm: Update supported SoC =
name for pwm-samsung)
Merging dma-buf/for-next (19e8697ba45e dma-buf: Expose buffer size to users=
pace (v2))
Merging userns/for-next (41301ae78a99 vfs: Fix a regression in mounting pro=
c)
Merging ktest/for-next (df5f7c66013c ktest: Reset grub menu cache with diff=
erent machines)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (9ed9c07d9b7d clk: new driver for efm32 SoC)
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
$ git checkout -b akpm remotes/origin/akpm/master
Applying: mm: add strictlimit knob
Merging akpm/master (4e6352224af5 mm: add strictlimit knob)

--Signature=_Fri__29_Nov_2013_13_45_35_+1100_6kS6fM/rVGcCdJN4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSl//TAAoJEMDTa8Ir7ZwVcTgP/Rphp7TC3nA2dJj60MWWQFs7
pBg6lNKOdkCITVONfrkoergV5r9fuPS+eSOutjH4BRFszkhBeMVWtAFxsf7/uTXD
+1yA4RO0pUXTazCC6QURM0H56uiDUJNryJdQwlEpsEBNn38dihm9n4peOo1m5Sdf
sds8lzt3sAXS1MDC1eXNpUQgo86BXJxreDmixtw/JL402VIeiMbAJy9CA98MI1+m
7Ogzg6mnacvcxj3KzWuSb3+6iwSsuZ61kmhllpcmNmu++Dku7gguHpvG6XPNIoH0
yGDkq/fC6azF6RQ2eDbE1qYPyXRjpfzAsrFujaXdeOxKXc5CicYnP5R1tdTs/EoY
/Aj4lGwKRjJFPhobQzdF8lMyXTJh0QL5/3x/L3acjllVKaOHgeJh3rhMCTWHJwLJ
k2roRUIRorDChlACWfvz46bOjQfD7yGIEpLMX2Tr7DCcnPzM0e7Wz62z6afmp89a
VzkUl8z/NOh95n4h+S1JeJJB6IUAERvZwDOOy8ECXOBTBj2kfO0ohPzIM1eKBWM0
gTZrTHnXvk92uUZlPqsnrCKqECcqU3tImS4zjuf1aqp4xiO9bCQzB7KgmCP8rNfb
VD5b0WS3PycXcodRNFVSq8yV3rZXCntyRF7v3Qf3r5Iry93Z3G3xVzEnXLz6x1Yp
PXwuJ61EDI28L/XIXTtj
=YTLP
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Nov_2013_13_45_35_+1100_6kS6fM/rVGcCdJN4--
