Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaAGGib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:38:31 -0500
Received: from ozlabs.org ([203.10.76.45]:58716 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbaAGGi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:38:26 -0500
Date: Tue, 7 Jan 2014 17:38:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 7
Message-Id: <20140107173816.003dc67433cea097c097eb74@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Jan_2014_17_38_16_+1100_OJigsKI8CbH5iXqM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jan_2014_17_38_16_+1100_OJigsKI8CbH5iXqM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140106:

Dropped tree: sh (complex merge conflicts against very old commits)

The powerpc tree still had its build failure.

The net-next tree lost its build failure.

The bluetooth tree gained a conflict against the net and net-next trees.

The mmc tree lost its build failure after I applied a supplied merge fix.

The regulator tree lost its build failure.

The security tree gained a conflict against the pm tree.

The spi tree lost its build failure.

The tip tree gained a conflict against the pm tree.

The xen-tip tree gained a conflict against the arm-current tree.

The akpm-current tree gained a conflict against the tip tree.

Non-merge commits (relative to Linus' tree): 6985
 6796 files changed, 346068 insertions(+), 174150 deletions(-)

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
Merging origin/master (f0a679afefc0 Merge branch 'fixes' of git://ftp.arm.l=
inux.org.uk/~rmk/linux-arm)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (1e01c7eb7c43 ARC: Allow conditional multiple =
inclusion of uapi/asm/unistd.h)
Merging arm-current/fixes (0a5ccc86507f ARM: 7933/1: rename ioremap_cached =
to ioremap_cache)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (f991db1cf1bd Merge remote-tracking branch 'agu=
st/merge' into merge)
Merging sparc/master (d11739e6d83d Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/sparc)
Merging net/master (fe0d692bbc64 bridge: use spin_lock_bh() in br_multicast=
_set_hash_max)
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (150116bcfbd9 ALSA: hiface: Fix typo in 352=
800 rate definition)
Merging pci-current/for-linus (f0b75693cbb2 MAINTAINERS: Add DesignWare, i.=
MX6, Armada, R-Car PCI host maintainers)
Merging wireless/master (e46316c86ee6 Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (413541dd66d5 Linux 3.13-rc5)
Merging tty.current/tty-linus (413541dd66d5 Linux 3.13-rc5)
Merging usb.current/usb-linus (413541dd66d5 Linux 3.13-rc5)
Merging staging.current/staging-linus (413541dd66d5 Linux 3.13-rc5)
Merging char-misc.current/char-misc-linus (319e2e3f63c3 Linux 3.13-rc4)
Merging input-current/for-linus (8e2f2325b73f Input: xpad - add new USB IDs=
 for Logitech F310 and F710)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (efb753b8e013 crypto: ixp4xx - Fix kernel com=
pile error)
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (6f041e99fc7b of: Fix NULL dere=
ference in unflatten_and_copy())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (d6e0a2dd12f4 Linux 3.13-rc7)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (d8e8c7dda11f ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (7969c5824e60 Merge branches 'amba', 'fixes', 'kees', =
'misc' and 'unstable/sa11x0' into for-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (5e59dd41794c Merge branches 'fixes', 'next/driver=
s' and 'next/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging bcm2835/for-next (413541dd66d5 Linux 3.13-rc5)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (a54b6b33090f Merge branches 'imx/fixes', 'imx/soc=
' and 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (6da7d0ea74e4 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (2fb5c387800c Merge branch 'heads/soc-fixes-for-v3.14'=
 into next)
Merging samsung/for-next (8109c477487a Merge branch 'v3.14-next/dt-exynos-3=
' into for-next)
Merging tegra/for-next (95e770a5ad96 Merge branch for-3.14/defconfig into f=
or-next)
Merging arm64/for-next/core (4e5e1eb89f48 arm64: dts: Reduce size of virtio=
 block device for foundation model)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (a16f9a42a557 m68k: Update defconfigs for v3.13-rc1)
Merging m68knommu/for-next (a695b9c8911e m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (a1dd107fcafa microblaze: Remove duplicate declarat=
ions of _stext[] and _etext[])
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (e6a3420e24e0 parisc: fix aio cache flushing bug)
Merging powerpc/next (dece8ada993e Merge branch 'merge' into next)
Merging mpc5xxx/next (8c699054e995 powerpc/512x: dts: add MPC5125 clock spe=
cs)
CONFLICT (content): Merge conflict in arch/powerpc/boot/dts/mpc5125twr.dts
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (91f3e3eaba44 s390/zcrypt: add support for EP11 copro=
cessor cards)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
$ git merge --abort
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
Merging cifs/for-next (f1e3268126a3 cifs: set FILE_CREATED)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (27e25f8135e5 ext4: standardize error handling in ext4_da_=
write_inline_data_begin())
Merging f2fs/dev (04a17fb17faf f2fs: avoid to read inline data except first=
 page)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (70d4ee94b370 GFS2: Use only a single address space for=
 rgrps)
Merging jfs/jfs-next (0439e091e3b1 jfs: fix xattr value size overflow in __=
jfs_setxattr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (16a6ddc70920 point to the right include file in a c=
omment (left over from a9004abc3))
Merging nfsd/nfsd-next (0fdc26785d0a sunrpc: get rid of use_gssp_lock)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f94741fd2832 net/9p: remove virtio default hack and =
set appropriate bits instead)
Merging ubifs/linux-next (c23e9b75ccd0 UBIFS: remove invalid warn msg with =
tst_recovery enabled)
Merging xfs/for-next (324bb26144e9 Merge branch 'xfs-for-linus-v3.13-rc5' i=
nto for-next)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (79bf7fc51118 Merge branch 'pci/misc' into next)
Merging hid/for-next (b18c2fbc3e1a Merge branch 'for-3.14/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (168e722dcb9a i2c: xilinx: Use devm_* functions)
Merging jdelvare-hwmon/master (68d5516b35c7 hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (b17276b13b38 hwmon: (nct6775) Re-enable l=
ogical device mapping for NCT6791 during resume)
Merging v4l-dvb/master (bb79fe3ca2ad Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (ddbfd0b07555 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (421f2c8280ec Merge branch 'for-3.14' into for-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (aac2277578ae Merge branch 'pm-tools')
Merging idle/next (1ae2a8af4228 tools/power turbostat: run on HSX)
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (c698a4492f01 Merge branch 'misc' of .git into next)
CONFLICT (content): Merge conflict in drivers/cpufreq/Kconfig
Merging ieee1394/for-next (ce027ed98fd1 firewire: sbp2: bring back WRITE SA=
ME support)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (91fec0f562bd swiotlb: update format)
Merging slave-dma/next (087a45b74e02 Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (56a4342dfe31 Merge branch 'master' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/davem/net)
Merging ipsec-next/master (5537a0557c26 pktgen_dst_metrics[] can be static)
Merging wireless-next/master (6e08d757b72f mmc: add SDIO identifiers for Br=
oadcom WLAN devices)
Merging bluetooth/master (f86772af6a0f Bluetooth: Remove rfcomm_carrier_rai=
sed())
CONFLICT (content): Merge conflict in net/ieee802154/6lowpan.c
Applying: net: 6lowpan: fixup for code movement
Merging infiniband/for-next (d8a0f63e2a7b Merge branches 'cxgb4', 'flowstee=
r', 'misc', 'ocrdma' and 'usnic' into for-next)
Merging mtd/master (802eee95bde7 Linux 3.13-rc6)
Merging l2-mtd/master (276176226564 mtd: bcm47xxpart: alternative MAGIC for=
 board_data partition)
Merging crypto/master (d16b87003ff4 crypto: drivers - Sort drivers/crypto/M=
akefile)
Merging drm/drm-next (fe3c703c3d80 drm/dp: Clarify automated test constant =
and add constant for FAUX test pattern)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_stub.c
Merging drm-intel/for-linux-next (3ec2f427e6f8 drm/i915: Fix refcount leak =
and possible NULL pointerdereference.)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ddi.c
Merging drm-tegra/drm/for-next (81239c6f7972 drm/tegra: fix compile w/ CONF=
IG_DYNAMIC_DEBUG)
Merging sound/for-next (b8bab04829ab ALSA: compress: update struct snd_code=
c_desc for sample rate)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging sound-asoc/for-next (17081ba4d2e2 Merge remote-tracking branches 'a=
soc/topic/ad1836', 'asoc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/a=
dsp', 'asoc/topic/ak4641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc=
/topic/atmel', 'asoc/topic/au1x', 'asoc/topic/axi', 'asoc/topic/bcm2835', '=
asoc/topic/blackfin', 'asoc/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topi=
c/da7210', 'asoc/topic/davinci', 'asoc/topic/ep93xx', 'asoc/topic/fsl', 'as=
oc/topic/fsl-mxs', 'asoc/topic/generic', 'asoc/topic/hdmi', 'asoc/topic/jac=
k', 'asoc/topic/jz4740', 'asoc/topic/max98090', 'asoc/topic/mc13783', 'asoc=
/topic/mxs', 'asoc/topic/omap', 'asoc/topic/pxa', 'asoc/topic/rcar', 'asoc/=
topic/s6000', 'asoc/topic/sai', 'asoc/topic/samsung', 'asoc/topic/sgtl5000'=
, 'asoc/topic/spear', 'asoc/topic/ssm2518', 'asoc/topic/ssm2602', 'asoc/top=
ic/tegra', 'asoc/topic/tlv320aic3x', 'asoc/topic/twl6040', 'asoc/topic/txx9=
', 'asoc/topic/uda1380', 'asoc/topic/width', 'asoc/topic/wm8510', 'asoc/top=
ic/wm8523', 'asoc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm8728', =
'asoc/topic/wm8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc/topic/=
wm8753', 'asoc/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm8900', 'as=
oc/topic/wm8901', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/topic/wm8=
974', 'asoc/topic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/=
topic/wm8991', 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm9081=
' and 'asoc/topic/x86' into asoc-next)
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
CONFLICT (add/add): Merge conflict in Documentation/module-signing.txt
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (7abf38d6d13c Input: twl4030-keypad - add device tree su=
pport)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (51cd0751d46f Merge branch 'for-3.14' into for-next)
Merging block/for-next (c94566e6fd6f Merge branch 'for-3.14/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
Merging device-mapper/for-next (3b1e77ef973f dm cache policy mq: introduce =
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
Applying: mmc: merge fixup for imx6qdl-sabresd.dtsi
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (8afb1474db47 slub: Fix calculation of cpu slabs)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (6d183de40771 md/raid5: fix newly-broken locking in get=
_active_stripe.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (121a84bf85fc mfd: sta2x11-mfd: Use named const=
ants for pci_power_t values)
Merging battery/master (26740dbb50f2 max17042_battery: Add IRQF_ONESHOT fla=
g to use default irq handler)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (46ac29568e63 video: vt8500: fix error handling =
in probe())
Merging regulator/for-next (bd97e2079530 Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/act8865', 'regulator/topic/anatop',=
 'regulator/topic/arizona', 'regulator/topic/as3722', 'regulator/topic/db85=
00', 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3=
972', 'regulator/topic/max14577', 'regulator/topic/max77693', 'regulator/to=
pic/pcf50633', 'regulator/topic/pfuze100', 'regulator/topic/s2mps11', 'regu=
lator/topic/s5m8767', 'regulator/topic/stw481x-vmmc', 'regulator/topic/tps5=
1632', 'regulator/topic/tps62360', 'regulator/topic/tps65910' and 'regulato=
r/topic/wm831x' into regulator-next)
Merging security/next (d4a82a4a033d Merge branch 'master' of git://git.infr=
adead.org/users/pcmoore/selinux into next)
CONFLICT (content): Merge conflict in drivers/char/tpm/tpm_ppi.c
Merging selinux/master (465954cd649a selinux: selinux_setprocattr()->ptrace=
_parent() needs rcu_read_lock())
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (9d0e644bfd47 watchdog: GPIO-controlled watchdog)
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
Merging trivial/for-next (97e81acd31de IXP4xx: remove '1 &&' from a conditi=
on check in ixp4xx_restart())
CONFLICT (content): Merge conflict in drivers/gpu/drm/qxl/Kconfig
Merging audit/master (fc582aef7dcc Merge tag 'v3.12')
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (1b50b0c3330e Merge branch 'for-3.14' into for-next)
Merging spi/for-next (a1bf3fdd3e2e Merge remote-tracking branches 'spi/topi=
c/ath79', 'spi/topic/atmel', 'spi/topic/bcm2835', 'spi/topic/bcm63xx', 'spi=
/topic/bcm63xx-hsspi', 'spi/topic/coldfire', 'spi/topic/davinci', 'spi/topi=
c/dw', 'spi/topic/falcon', 'spi/topic/fsl-espi', 'spi/topic/gpio', 'spi/top=
ic/mpc512x', 'spi/topic/msiof', 'spi/topic/nuc900', 'spi/topic/omap', 'spi/=
topic/orion', 'spi/topic/pci', 'spi/topic/qspi', 'spi/topic/rcar', 'spi/top=
ic/rspi', 'spi/topic/s3c24xx', 'spi/topic/s3c64xx', 'spi/topic/sc18is602', =
'spi/topic/tegra114', 'spi/topic/tegra20-sflash', 'spi/topic/tegra20-slink'=
, 'spi/topic/txx9' and 'spi/topic/xcomm' into spi-next)
CONFLICT (content): Merge conflict in drivers/spi/spi-mpc512x-psc.c
Merging tip/auto-latest (bb4d5c0664ff Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in drivers/acpi/processor_idle.c
CONFLICT (content): Merge conflict in drivers/acpi/acpi_extlog.c
Merging clockevents/clockevents/next (98aefbe72ec6 Merge branch 'clockevent=
s/for-Simon-3.13-rc2' into clockevents/3.14)
CONFLICT (content): Merge conflict in drivers/clocksource/clksrc-of.c
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (90ed4988b8c0 e752x_edac: Fix pci_dev usage count)
Merging ftrace/for-next (e0d18fe06346 tracing/probes: Fix build break on !C=
ONFIG_KPROBE_EVENT)
Merging rcu/rcu/next (0d3c55bc9fd5 Merge branches 'doc.2013.12.03a', 'fixes=
.2013.12.12a', 'rcutorture.2013.12.03a' and 'sparse.2013.12.12a' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (989c6b34f6a9 KVM: MMU: handle invalid root_hpa at _=
_direct_map)
Merging kvm-arm/kvm-arm-next (478a8237f656 arm: KVM: Don't return PSCI_INVA=
L if waitqueue is inactive)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (11c7ff17c9b6 xen/grant-table: Force to use v1 o=
f grants.)
CONFLICT (content): Merge conflict in arch/arm/include/asm/xen/page.h
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
Merging leds/for-next (4776dc54b071 leds: replace list_for_each with list_f=
or_each_entry)
Merging driver-core/driver-core-next (eb4c69033fd1 Revert "kobject: introdu=
ce kobj_completion")
Merging tty/tty-next (b86b75ec57c3 Merge 3.13-rc5 into tty-next)
Merging usb/usb-next (bd6383c81d5f USB: oti6858: switch to generic TIOCMIWA=
IT implementation)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (a6e8e3a470bf Merge tag 'iio-for-3.14b' of git=
://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
Merging char-misc/char-misc-next (a45a0258d1f8 GenWQE: Accidently casting t=
o u32 where u64 is required)
Merging scsi/for-next (81286dea29d1 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (d79dc4525ad5 target: Convert inquiry tempo=
rary buffer to heap memory)
CONFLICT (content): Merge conflict in drivers/target/target_core_tpg.c
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (44a45b55a727 pinctrl: sh-pfc: ARM: Constify pins =
and cfg_regs arrays)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (b10b45c0a17b gpio: tb10x: Remove redundant of_match_=
ptr helper)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (82569e5b2236 pwm: tiehrpwm: use dev_err() instead of =
pr_err())
Merging dma-buf/for-next (17b2112f332d Merge branch 'merge' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging userns/for-next (41301ae78a99 vfs: Fix a regression in mounting pro=
c)
Merging ktest/for-next (298a0d1d5750 ktest: Add documentation of CLOSE_CONS=
OLE_SIGNAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (dbdf6ff51e3c Merge branch 'clk-next-unregister' into =
clk-next)
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (8e321fefb0e6 aio/migratepages: make aio migrate pages s=
ane)
Merging akpm-current/current (28d6b6dd3443 ipc: change kern_ipc_perm.delete=
d type to bool)
CONFLICT (content): Merge conflict in mm/mlock.c
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in arch/x86/mm/numa.c
CONFLICT (content): Merge conflict in arch/Kconfig
Applying: ARM: mm: change further appearance of arm_dma_zone_size to phys_a=
ddr_t
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
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: drivers/video/backlight/lcd.c: call put_device if device_register=
 fails
Applying: drivers/net/phy/mdio_bus.c: call put_device on device_register() =
failure
Applying: checkpatch.pl: check for function declarations without arguments
Applying: mm: add strictlimit knob
Merging akpm/master (d266c60be773 mm: add strictlimit knob)

--Signature=_Tue__7_Jan_2014_17_38_16_+1100_OJigsKI8CbH5iXqM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSy6DdAAoJEMDTa8Ir7ZwVjbEP/0Y4Akq2Iqle+7Hrrr3R4YcS
I3swXW6/RucWv6t7Hon4JGkZsjhad1dn6zKOpuNS+LtEIetXkSim+k9AjcYiB3io
dWzhJznonlOzQk7vfPWeJtj8YmREsIlemoqIFVKHo7AobeCUW6a/cY15peWdTCeg
CNI/VmLyKQ+YKT1ab6jUEI0MqZXRvwt6bBUe0oq6sBEnL61N5R7HGzQvuJ6Pm6dt
M+pctVcKkJROYlifcOqzug9HIKdUaVzLDupojYwLDEwO++sdPyzJRsnDtgGy22j2
rhXIa8ldzLQh9V5aAVD4GLxr5Jk+FZuaHv02MSMcwYdXoXOZFz/Hettu5dSoZ2eX
1dQilNbb12Mjb9yzQi6egiIPQFSN/W+wqPJnasbM4J/N3Kbza2JvmSFdU4PcNONH
WKqmHRcSIsK+x+1rT9G2ldL8bu+leVwdsjNOWF3MWfvoIIdEIlCi/Wug1dat1x4E
FULRspVxZBSF2N4pHNOVYPg+Ixb6pkOfPTb0hN+wTmQ2yYN2dG7WzGezJKXaq09U
+kxAOekTVqE++7uy84PmE8ExAXQIzE+IrBZE3HzSYdytbX2wPbw3XLiDC0o1BYef
XtUQj6KOulTvbs9Psf/fUcQvFuz5cEjDO+H2/G5QEtwy1+TxK0Y24N0PuUr0vyE8
Grzl2DBgs2X8DMBtKqbH
=QlBR
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jan_2014_17_38_16_+1100_OJigsKI8CbH5iXqM--
