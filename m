Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3LTGZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 01:25:24 -0500
Received: from ozlabs.org ([203.10.76.45]:42568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab3LTGZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 01:25:18 -0500
Date: Fri, 20 Dec 2013 17:25:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Dec 20
Message-Id: <20131220172503.b2b7cb92f437d974f032e1a4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Dec_2013_17_25_03_+1100_YXLdmkQQ+Yv_sSP4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Dec_2013_17_25_03_+1100_YXLdmkQQ+Yv_sSP4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20131219:

New tree: clockevents

The powerpc tree still had its build failure for which I applied a
supplied patch.

The sound-asoc tree gained a conflict against the slave-dma tree.

The net-next tree lost its new build failure.

The mmc tree still had its build failure so I used the version from
next-20131212.

The spi tree gained a conflict against the mpc5xxx tree.

The clockevents tree gained a conflict against Linus' tree.

The usb-gadget lost its build failure.

The akpm-current tree still had its build failures for which I applied
patches.

Non-merge commits (relative to Linus' tree): 5223
 5421 files changed, 250649 insertions(+), 134680 deletions(-)

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
Merging origin/master (f7556698a369 Merge branch 'sched-urgent-for-linus' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (319e2e3f63c3 Linux 3.13-rc4)
Merging arm-current/fixes (b713aa0b1501 ARM: fix asm/memory.h build error)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (803c2d2f84da powerpc/powernv: Fix OPAL LPC acc=
ess in Little Endian)
Merging sparc/master (1de425c7b271 sparc64: Fix build regression)
Merging net/master (c047e0707307 bnx2x: downgrade "valid ME register value"=
 message level)
Merging ipsec/master (239c78db9c41 net: clear local_df when passing skb bet=
ween namespaces)
Merging sound-current/for-linus (356f402da0f9 Merge tag 'asoc-v3.13-rc4' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (f0b75693cbb2 MAINTAINERS: Add DesignWare, i.=
MX6, Armada, R-Car PCI host maintainers)
Merging wireless/master (b7e047358449 Merge branch 'for-upstream' of git://=
git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth)
Merging driver-core.current/driver-core-linus (a8b14744429f sysfs: give dif=
ferent locking key to regular and bin files)
Merging tty.current/tty-linus (c2db11eca089 tty: xuartps: Properly guard sy=
srq specific code)
Merging usb.current/usb-linus (fb5f1834c322 usb: ohci-at91: fix irq and iom=
em resource retrieval)
Merging staging.current/staging-linus (fd6040ed57d8 imx-drm: imx-drm-core: =
improve safety of imx_drm_add_crtc())
Merging char-misc.current/char-misc-linus (319e2e3f63c3 Linux 3.13-rc4)
Merging input-current/for-linus (2a4d81547b88 Input: define KEY_WWAN for Wi=
reless WAN)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (389a5390583a crypto: scatterwalk - Use sg_ch=
ain_ptr on chain entries)
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (a885b3ccc74d drm/i915: Use th=
e correct GMCH_CTRL register for Sandybridge+)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (e11cbe1fbd91 ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (79f82a866ed4 Merge branches 'amba', 'fixes', 'kees', =
'misc' and 'unstable/sa11x0' into for-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (58946e1037ce Merge branch 'next/soc' into for-nex=
t)
Merging bcm2835/for-next (5cc686267845 Merge branch 'for-3.14/defconfig' in=
to for-next)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (1310160a701f Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (7df09017fc41 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (833895910f5e Merge branch 'heads/sh-sci' into next)
CONFLICT (content): Merge conflict in drivers/clk/Makefile
Merging samsung/for-next (0da8b319041a Merge branch 'v3.14-next/soc-exynos-=
2' into for-next)
Merging tegra/for-next (171b8da397a7 Merge branch for-3.14/defconfig into f=
or-next)
Merging arm64/for-next/core (0a5be743e8c3 Merge tag 'arm64-suspend' of git:=
//linux-arm.org/linux-2.6-lp into upstream)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (27d632d27c4f m68k/atari: Hide RTC_PORT() macro from =
rtc-cmos)
Merging m68knommu/for-next (a695b9c8911e m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (40979d327c99 metag: topology: export 'cpu_core_map')
Merging microblaze/next (a1dd107fcafa microblaze: Remove duplicate declarat=
ions of _stext[] and _etext[])
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (dc1ccc48159d Linux 3.13-rc2)
Merging powerpc/next (75eb3d9b60c2 powerpc/powernv: Get FSP memory errors a=
nd plumb into memory poison infrastructure.)
Applying: powerpc: Fix "attempt to move .org backwards" error
Merging mpc5xxx/next (0cb5486a2035 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (91f3e3eaba44 s390/zcrypt: add support for EP11 copro=
cessor cards)
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
Merging xtensa/for_next (d30841d27218 xtensa: ISS: avoid simple_strtoul usa=
ge)
Merging btrfs/next (91aef86f3b8a Btrfs: rename btrfs_start_all_delalloc_ino=
des)
Merging ceph/master (8eb4efb091c8 ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (cfae639783f0 cifs: set FILE_CREATED)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (df4e7ac0bb70 ext2: Fix oops in ext2_get_block() call=
ed from ext2_quota_write())
Merging ext4/dev (c25625a1b6a5 ext4: enable punch hole for bigalloc)
Merging f2fs/dev (737b77f0d0a3 f2fs: add description about small_discards i=
n document)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (8953e11bb191 GFS2: Fix slab memory leak in gfs2_bufdat=
a)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (23e66ba97127 rpc_pipe: fix cleanup of dummy gssd di=
rectory when notification fails)
Merging nfsd/nfsd-next (a0ef5e19684f nfsd: don't try to reuse an expired DR=
C entry off the list)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f94741fd2832 net/9p: remove virtio default hack and =
set appropriate bits instead)
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (324bb26144e9 Merge branch 'xfs-for-linus-v3.13-rc5' i=
nto for-next)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (608235a30706 Merge branch 'pci/vc' into next)
Merging hid/for-next (460d9a348628 Merge branch 'for-3.14/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (e5bf216a945e i2c: imx: Check the return value fro=
m clk_prepare_enable())
Merging jdelvare-hwmon/master (68d5516b35c7 hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (e0425401acaa hwmon: (coretemp) Refine TjM=
ax detection)
Merging v4l-dvb/master (c4f181f1efc5 Merge branch 'v4l_for_linus' into temp)
Merging kbuild/for-next (e6483a58eca6 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (23f5e334cbd9 Merge branch 'for-3.13-fixes' into fo=
r-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (dd61525a92dd Merge branch 'acpi-hotplug-next' into l=
inux-next)
Merging idle/next (1ae2a8af4228 tools/power turbostat: run on HSX)
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (86e0a0bdf81c Merge branches 'intel_powerclamp', 'tmon=
' and 'misc' of .git into next)
Merging ieee1394/for-next (ce027ed98fd1 firewire: sbp2: bring back WRITE SA=
ME support)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (087a45b74e02 Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (de47c4ab25d4 Merge branch 'for-davem' of git://git=
orious.org/linux-can/linux-can-next)
Merging ipsec-next/master (b3c6efbc36e2 xfrm: Add file to document IPsec co=
rner case)
Merging wireless-next/master (39731b78b4af ath9k: simplify/fix tx packet TI=
D handling)
Merging bluetooth/master (c567c77101f0 6lowpan: cleanup udp compress functi=
on)
Merging infiniband/for-next (771b0f3fc474 Merge branches 'cxgb4', 'flowstee=
r', 'misc', 'ocrdma' and 'usnic' into for-next)
Merging mtd/master (15b540c71cac mtd: nand: pxa3xx: Use info->use_dma to re=
lease DMA resources)
Merging l2-mtd/master (dd0a577efe72 mtd: nand: pxa3xx: Consolidate ECC init=
ialization)
Merging crypto/master (e37b94ebffdd crypto: memneq - fix for archs without =
efficient unaligned access)
Merging drm/drm-next (fe3c703c3d80 drm/dp: Clarify automated test constant =
and add constant for FAUX test pattern)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_stub.c
Merging drm-intel/for-linux-next (d8ccba866356 drm/i915: grab a pages pin c=
ount for preallocate stolen)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ddi.c
Merging drm-tegra/drm/for-next (f3873c15d43a drm/tegra: fix compile w/ CONF=
IG_DYNAMIC_DEBUG)
Merging sound/for-next (d8f66c71d547 ALSA: hda - Add warning texts when cod=
ec driver Kconfig doesn't match)
Merging sound-asoc/for-next (4af673891afe Merge remote-tracking branches 'a=
soc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/adsp', 'asoc/topic/ak4=
641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc/topic/axi', 'asoc/to=
pic/bcm2835', 'asoc/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topic/da7210=
', 'asoc/topic/davinci', 'asoc/topic/ep93xx', 'asoc/topic/fsl', 'asoc/topic=
/fsl-mxs', 'asoc/topic/generic', 'asoc/topic/hdmi', 'asoc/topic/jack', 'aso=
c/topic/jz4740', 'asoc/topic/max98090', 'asoc/topic/mxs', 'asoc/topic/omap'=
, 'asoc/topic/pxa', 'asoc/topic/rcar', 'asoc/topic/sai', 'asoc/topic/samsun=
g', 'asoc/topic/sgtl5000', 'asoc/topic/spear', 'asoc/topic/ssm2602', 'asoc/=
topic/tegra', 'asoc/topic/tlv320aic3x', 'asoc/topic/twl6040', 'asoc/topic/u=
da1380', 'asoc/topic/wm8510', 'asoc/topic/wm8523', 'asoc/topic/wm8580', 'as=
oc/topic/wm8711', 'asoc/topic/wm8728', 'asoc/topic/wm8731', 'asoc/topic/wm8=
741', 'asoc/topic/wm8750', 'asoc/topic/wm8753', 'asoc/topic/wm8776', 'asoc/=
topic/wm8804', 'asoc/topic/wm8900', 'asoc/topic/wm8901', 'asoc/topic/wm8940=
', 'asoc/topic/wm8962', 'asoc/topic/wm8974', 'asoc/topic/wm8985', 'asoc/top=
ic/wm8988', 'asoc/topic/wm8990', 'asoc/topic/wm8991', 'asoc/topic/wm8994', =
'asoc/topic/wm8995', 'asoc/topic/wm9081' and 'asoc/topic/x86' into asoc-nex=
t)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
CONFLICT (add/add): Merge conflict in Documentation/module-signing.txt
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (01d08185850c Input: fix typos in Documentation/input/ga=
mepad.txt)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (824960aa4e6c Merge branch 'for-3.13-fixes' into fo=
r-next)
Merging block/for-next (391b7a7bfb52 Merge branch 'for-3.14/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/logfs/dev_bdev.c
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
CONFLICT (content): Merge conflict in fs/btrfs/scrub.c
CONFLICT (content): Merge conflict in fs/btrfs/extent_io.c
CONFLICT (content): Merge conflict in fs/btrfs/check-integrity.c
CONFLICT (content): Merge conflict in block/blk-flush.c
Merging device-mapper/for-next (1584dbbde46a dm cache policy mq: introduce =
three promotion threshold tunables)
CONFLICT (content): Merge conflict in drivers/md/dm-thin.c
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (82793a517714 mmc: sh_mmcif: Fix compilation warning o=
n 64-bit platforms)
$ git reset --hard HEAD^
Merging next-20131212 version of mmc
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (e1168c2cc4a5 slab.h: remove duplicate kmalloc declar=
ation and fix kernel-doc warnings)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (6d183de40771 md/raid5: fix newly-broken locking in get=
_active_stripe.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (6a48ec837ea1 mfd: rtsx: Add support for card r=
eader rtl8402)
Merging battery/master (d36240d26025 power_supply: Add power_supply notifie=
r)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (46ac29568e63 video: vt8500: fix error handling =
in probe())
Merging regulator/for-next (8b9b9fd2e354 Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/arizona', 'regulator/topic/db8500',=
 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3972'=
, 'regulator/topic/pcf50633', 'regulator/topic/pfuze100', 'regulator/topic/=
s5m8767', 'regulator/topic/stw481x-vmmc' and 'regulator/topic/tps51632' int=
o regulator-next)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
Merging selinux/master (465954cd649a selinux: selinux_setprocattr()->ptrace=
_parent() needs rcu_read_lock())
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (28748defa512 watchdog: remove DEFINE_PCI_DEVICE_TA=
BLE macro)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (e6ca48d995e4 Merge branches 'iommu/fixes', 'tracing', '=
core', 'arm/tegra' and 'x86/vt-d' into next)
Merging vfio/next (d10999016f41 vfio: Convert control interface to misc dri=
ver)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (5e4fcf9d5e4c doc: driver-model/platform.txt: fix =
a typo)
Merging audit/master (fc582aef7dcc Merge tag 'v3.12')
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (1b50b0c3330e Merge branch 'for-3.14' into for-next)
Merging spi/for-next (4aaaa679ca1e Merge remote-tracking branches 'spi/topi=
c/ath79', 'spi/topic/atmel', 'spi/topic/bcm2835', 'spi/topic/bcm63xx', 'spi=
/topic/bcm63xx-hsspi', 'spi/topic/coldfire', 'spi/topic/davinci', 'spi/topi=
c/designware', 'spi/topic/falcon', 'spi/topic/fsl-espi', 'spi/topic/gpio', =
'spi/topic/mpc512x', 'spi/topic/msiof', 'spi/topic/nuc900', 'spi/topic/omap=
', 'spi/topic/orion', 'spi/topic/pci', 'spi/topic/qspi', 'spi/topic/rcar', =
'spi/topic/s3c24xx', 'spi/topic/s3c64xx', 'spi/topic/sc18is602', 'spi/topic=
/tegra114', 'spi/topic/tegra20-sflash', 'spi/topic/tegra20-slink', 'spi/top=
ic/txx9' and 'spi/topic/xcomm' into spi-next)
CONFLICT (content): Merge conflict in drivers/spi/spi-mpc512x-psc.c
Merging tip/auto-latest (66fa28e2bb4a Merge branch 'x86/ras')
Merging clockevents/clockevents/next (98aefbe72ec6 Merge branch 'clockevent=
s/for-Simon-3.13-rc2' into clockevents/3.14)
CONFLICT (content): Merge conflict in drivers/clocksource/clksrc-of.c
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (0facccc00c7c Merge branch 'ras-for-3.14' into fo=
r-next)
Merging ftrace/for-next (3ccb01239201 tracing: Only run synchronize_sched()=
 at instance deletion time)
Merging rcu/rcu/next (0d3c55bc9fd5 Merge branches 'doc.2013.12.03a', 'fixes=
.2013.12.12a', 'rcutorture.2013.12.03a' and 'sparse.2013.12.12a' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (6bb05ef78553 Merge tag 'kvm-s390-20131211' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next)
Merging kvm-arm/kvm-arm-next (4fda342cc7f5 arm/arm64: kvm: Use virt_to_idma=
p instead of virt_to_phys for idmap mappings)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (85be9741104f Merge branch 'stable/for-linus-3.1=
3' into linux-next)
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
Merging regmap/for-next (057c2d5071eb Merge remote-tracking branch 'regmap/=
topic/ack' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (da2cbb0f96cb leds: pwm: Remove a warning on non-DT p=
latforms)
Merging driver-core/driver-core-next (880ae359173c Documentation: fix spell=
ing in design-patterns)
Merging tty/tty-next (4903713cac8b serial: Remove old SC26XX driver)
Merging usb/usb-next (1ce0fd15be28 uwb: umc-dev: add missing put_device cal=
l)
CONFLICT (content): Merge conflict in drivers/usb/host/ohci-at91.c
Merging usb-gadget/next (8ed1fb790ea2 usb: musb: finish suspend/reset work =
independently from musb_hub_control())
CONFLICT (content): Merge conflict in drivers/usb/phy/Kconfig
Merging staging/staging-next (364014fda831 staging: dgap: Fix trailing whit=
espace in dgap_trace.c)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
Merging char-misc/char-misc-next (76f5adbcb371 GenWQE Enable driver)
Merging scsi/for-next (81286dea29d1 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (d79dc4525ad5 target: Convert inquiry tempo=
rary buffer to heap memory)
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (37ef1d924375 pinctrl: at91: replace clk_prepare +=
 clk_enable by clk_prepare_enable)
CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/pfc-sh7372.c
CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/pfc-r8a7740.c
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (e0f0edc67d07 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (3f958fe7d3e3 of: Add Atmel PWM controller device tree=
 binding)
Merging dma-buf/for-next (17b2112f332d Merge branch 'merge' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging userns/for-next (41301ae78a99 vfs: Fix a regression in mounting pro=
c)
Merging ktest/for-next (298a0d1d5750 ktest: Add documentation of CLOSE_CONS=
OLE_SIGNAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (1459c837036a clk: si570: Add a driver for SI570 oscil=
lators)
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (374b105797c3 Linux 3.13-rc3)
Merging akpm-current/current (3d655d441006 ipc,sem: correct header comment =
for perform_atomic_semop)
Applying: memblock-make-memblock_set_node-support-different-memblock_type-f=
ix
Applying: rtc: hym8563: include clkout code only if COMMON_CLK active
$ git checkout -b akpm remotes/origin/akpm/master
Applying: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcore=
info_append_str()
Applying: softirq: use ffs() in __do_softirq()
Applying: softirq: convert printks to pr_<level>
Applying: softirq: use const char * const for softirq_to_name, whitespace n=
eatening
Applying: mm/migrate.c: fix set cpupid on page migration twice against thp
Applying: mm/migrate.c: fix setting of cpupid on page migration twice again=
st normal page
Applying: zsmalloc: move it under mm
Applying: zram: promote zram from staging
Applying: mm: add strictlimit knob
Merging akpm/master (f803d17b263f mm: add strictlimit knob)

--Signature=_Fri__20_Dec_2013_17_25_03_+1100_YXLdmkQQ+Yv_sSP4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSs+LDAAoJEMDTa8Ir7ZwVE80QAIT5Mq0XarQxkCpa8mRFsIev
/GSp/PPN/JPLli3cViDZVS2dZsQC85MmtPKMW/9wqlMRCGlGqdSQEKA1JQYHYdSF
nn9hb9SratIbyqoCNf6cpI0DBy32BGjnPwYsn0Ef7ZDDob6bm0KIe9nhDZwsO3jl
sxMrUTMTnXTB0rKuQL1ushsUcxAo7IPAy7pggHiPNalDpBajsvxTAV5Sg7l30r7n
GoVk/Wcq/jSzUYTYbqFgb6sjpiocFltdu0JI4yu5UMGLto5KaqXDCGbp94ElTrMi
Vy6ldyf5ccuhSqQm2zMAiK0M7WGczAqRQqcB3pw9HpIDjKAmmslBnkkF+HxmgKXs
3eyIv7Nf9G338VfspA52bJ59gmWbbztogjcEJavP6pF760e8KfLwISHgHNqNn2f4
Rj+e2nA+ECt8pxf9+fCUtYoc3K6Dq2iCiWfpKd/8sRDzVBUE9UOarthzMtxygiDb
ICVtp3G7FDt7zr1Q0rJr01aDsO9wuu9cG83G0vwLwvzInBS10MJ7RN0L0R8pU3Z1
8SMvE+KgK2Jmam+M58hPqUCzkUfOXqlkrnkd6M3KfumN8NrpBusSEqlWXWVDhmqI
NZunrHVnIg3wIjrSCD2Z+pbz6lI0Ex3EZ71nvq1lKoTs3xGzOGqpHyGgnh5sGuhM
1/xRx4UYf407ab7yfH5s
=C0K4
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Dec_2013_17_25_03_+1100_YXLdmkQQ+Yv_sSP4--
