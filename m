Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbaAIGu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 01:50:59 -0500
Received: from ozlabs.org ([203.10.76.45]:56850 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaAIGuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 01:50:46 -0500
Date: Thu, 9 Jan 2014 17:50:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 9
Message-Id: <20140109175039.415b95a3cba82e9f04a2dd44@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Jan_2014_17_50_39_+1100_Ti7onSzU_suPadtc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jan_2014_17_50_39_+1100_Ti7onSzU_suPadtc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140108:

Dropped tree: sh (complex merge conflicts against very old commits)

The powerpc tree still had its build failure.

The libata tree gained a conflict against the pci tree.

The ipsec-next tree gained a conflict against the net-next tree.

The sound-asoc tree gained a conflict against the slave-dma tree.

The block tree gained a conflict against the btrfs tree.

The gpio tree gained a conflict against the leds tree.

Non-merge commits (relative to Linus' tree): 7463
 7194 files changed, 361132 insertions(+), 181733 deletions(-)

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
Merging origin/master (ceb3b0212dfc Merge branch 'drm-nouveau-next' of git:=
//anongit.freedesktop.org/nouveau/linux-2.6 into drm-fixes)
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
Merging sparc/master (ef350bb7c5e0 Merge tag 'ext4_for_linus_stable' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging net/master (732256b9335f tipc: correctly unlink packets from deferr=
ed packet queue)
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (150116bcfbd9 ALSA: hiface: Fix typo in 352=
800 rate definition)
Merging pci-current/for-linus (f0b75693cbb2 MAINTAINERS: Add DesignWare, i.=
MX6, Armada, R-Car PCI host maintainers)
Merging wireless/master (2eff7c791a18 Merge tag 'nfc-fixes-3.13-1' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes)
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
Merging drm-intel-fixes/for-linux-next-fixes (0882dae98370 drm/i915: fix DD=
I PLLs HW state readout code)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (d8e8c7dda11f ARC: [SMP] optimize IPI send and receive)
Merging arm/for-next (7969c5824e60 Merge branches 'amba', 'fixes', 'kees', =
'misc' and 'unstable/sa11x0' into for-next)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (edf2305d38a1 Merge tag 'clk-hisilicon' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/hzhuang1/linux into for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging bcm2835/for-next (413541dd66d5 Linux 3.13-rc5)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (433594150fa9 Merge branches 'imx/soc' and 'imx/dt=
' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (6da7d0ea74e4 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (794e9d136270 Merge branch 'soc-fixes-for-v3.14' into =
next)
Merging samsung/for-next (8109c477487a Merge branch 'v3.14-next/dt-exynos-3=
' into for-next)
Merging tegra/for-next (95e770a5ad96 Merge branch for-3.14/defconfig into f=
or-next)
Merging arm64/for-next/core (f4be8433fc2f jump_label: use defined macros in=
stead of hard-coding for better readability)
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
Merging microblaze/next (a23e64af1a9b microblaze: Simplify fcpu helper func=
tion)
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (f8dae00684d6 parisc: Ensure full cache coherenc=
y for kmap/kunmap)
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
Merging btrfs/next (56817eda3c10 Btrfs: introduce the delayed inode ref del=
etion for the single link inode)
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
Merging f2fs/dev (b1c57c1caa75 f2fs: add a sysfs entry to control max_victi=
m_search)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (62e96cf81988 GFS2: Increase i_writecount during gfs2_s=
etattr_chown)
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
Merging pci/next (04f982beb900 Merge branch 'pci/msi' into next)
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
CONFLICT (content): Merge conflict in drivers/ata/ahci.c
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (5881fdd356b5 Merge branch 'pm-tools')
Merging idle/next (1ae2a8af4228 tools/power turbostat: run on HSX)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (c698a4492f01 Merge branch 'misc' of .git into next)
CONFLICT (content): Merge conflict in drivers/cpufreq/Kconfig
Merging ieee1394/for-next (ce027ed98fd1 firewire: sbp2: bring back WRITE SA=
ME support)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (ee2d516e235f Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx51.dtsi
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (54b553e2c160 Merge branch 'master' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/pablo/nf-next)
Merging ipsec-next/master (5537a0557c26 pktgen_dst_metrics[] can be static)
CONFLICT (content): Merge conflict in net/xfrm/xfrm_policy.c
Merging wireless-next/master (300e5fd16011 Merge branch 'for-upstream' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next)
CONFLICT (content): Merge conflict in net/ieee802154/6lowpan.c
Merging bluetooth/master (4520714e3404 Bluetooth: Fix outgoing authenticati=
on requirement check)
Applying: net: 6lowpan: fixup for code movement
Merging infiniband/for-next (d8a0f63e2a7b Merge branches 'cxgb4', 'flowstee=
r', 'misc', 'ocrdma' and 'usnic' into for-next)
Merging mtd/master (802eee95bde7 Linux 3.13-rc6)
Merging l2-mtd/master (f0501e81fbaa mtd: bcm47xxpart: alternative MAGIC for=
 board_data partition)
Merging crypto/master (d16b87003ff4 crypto: drivers - Sort drivers/crypto/M=
akefile)
Merging drm/drm-next (859ae233cd0e Merge tag 'drm-intel-next-2013-12-13' of=
 git://people.freedesktop.org/~danvet/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_stub.c
Merging drm-intel/for-linux-next (89eff4bea721 drm/i915: fix wrong PLL debu=
g messages.)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
Merging drm-tegra/drm/for-next (81239c6f7972 drm/tegra: fix compile w/ CONF=
IG_DYNAMIC_DEBUG)
Merging sound/for-next (b317b032d2dc ALSA: hda - Split Thinkpad ACPI-relate=
d code)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging sound-asoc/for-next (ea5b180a293f Merge remote-tracking branches 'a=
soc/topic/ad1836', 'asoc/topic/ad193x', 'asoc/topic/adav80x', 'asoc/topic/a=
dsp', 'asoc/topic/ak4641', 'asoc/topic/ak4642', 'asoc/topic/arizona', 'asoc=
/topic/atmel', 'asoc/topic/au1x', 'asoc/topic/axi', 'asoc/topic/bcm2835', '=
asoc/topic/blackfin', 'asoc/topic/cs4271', 'asoc/topic/cs42l52', 'asoc/topi=
c/da7210', 'asoc/topic/davinci', 'asoc/topic/docs', 'asoc/topic/ep93xx', 'a=
soc/topic/fsl', 'asoc/topic/fsl-mxs', 'asoc/topic/generic', 'asoc/topic/hdm=
i', 'asoc/topic/jack', 'asoc/topic/jz4740', 'asoc/topic/max98090', 'asoc/to=
pic/mc13783', 'asoc/topic/mxs', 'asoc/topic/omap', 'asoc/topic/pxa', 'asoc/=
topic/rcar', 'asoc/topic/s6000', 'asoc/topic/sai', 'asoc/topic/samsung', 'a=
soc/topic/sgtl5000', 'asoc/topic/spear', 'asoc/topic/ssm2518', 'asoc/topic/=
ssm2602', 'asoc/topic/tegra', 'asoc/topic/tlv320aic3x', 'asoc/topic/twl4030=
', 'asoc/topic/twl6040', 'asoc/topic/txx9', 'asoc/topic/uda1380', 'asoc/top=
ic/ux500', 'asoc/topic/width', 'asoc/topic/wm8510', 'asoc/topic/wm8523', 'a=
soc/topic/wm8580', 'asoc/topic/wm8711', 'asoc/topic/wm8728', 'asoc/topic/wm=
8731', 'asoc/topic/wm8741', 'asoc/topic/wm8750', 'asoc/topic/wm8753', 'asoc=
/topic/wm8776', 'asoc/topic/wm8804', 'asoc/topic/wm8900', 'asoc/topic/wm890=
1', 'asoc/topic/wm8940', 'asoc/topic/wm8962', 'asoc/topic/wm8974', 'asoc/to=
pic/wm8985', 'asoc/topic/wm8988', 'asoc/topic/wm8990', 'asoc/topic/wm8991',=
 'asoc/topic/wm8994', 'asoc/topic/wm8995', 'asoc/topic/wm9081' and 'asoc/to=
pic/x86' into asoc-next)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging modules/modules-next (74e22fac8858 module.h: Remove unnecessary sem=
icolon)
CONFLICT (add/add): Merge conflict in Documentation/module-signing.txt
Merging virtio/virtio-next (7d2dddda5c92 virtio: pci: remove unnecessary pc=
i_set_drvdata())
Merging input/next (bf9a9f8e5105 Input: delete non-required instances of in=
clude <linux/init.h>)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (51cd0751d46f Merge branch 'for-3.14' into for-next)
Merging block/for-next (f74ce0e115fe Merge branch 'for-3.14/core' into for-=
next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
CONFLICT (content): Merge conflict in fs/btrfs/extent_io.c
Merging device-mapper/for-next (7e664b3dec43 dm space map metadata: fix ext=
ending the space map)
CONFLICT (content): Merge conflict in drivers/md/dm-thin.c
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (259245a845a1 MAINTAINERS: mmc: Update Chris Ball's em=
ail address.)
Applying: mmc: merge fixup for imx6qdl-sabresd.dtsi
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (8afb1474db47 slub: Fix calculation of cpu slabs)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (6d183de40771 md/raid5: fix newly-broken locking in get=
_active_stripe.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (c02ba56a19af mfd: omap-usb-tll: Don't hold loc=
k during pm_runtime_get/put_sync())
Merging battery/master (26740dbb50f2 max17042_battery: Add IRQF_ONESHOT fla=
g to use default irq handler)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (8f8455814173 Merge branches '3.14/fbdev', '3.14=
/dss-misc' and '3.14/dss-fclk' into for-next)
Merging regulator/for-next (b22ce67655bb Merge remote-tracking branches 're=
gulator/topic/ab8500', 'regulator/topic/act8865', 'regulator/topic/anatop',=
 'regulator/topic/arizona', 'regulator/topic/as3722', 'regulator/topic/db85=
00', 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3=
972', 'regulator/topic/max14577', 'regulator/topic/max77693', 'regulator/to=
pic/pcf50633', 'regulator/topic/pfuze100', 'regulator/topic/s2mps11', 'regu=
lator/topic/s5m8767', 'regulator/topic/stw481x-vmmc', 'regulator/topic/tps5=
1632', 'regulator/topic/tps62360', 'regulator/topic/tps65910' and 'regulato=
r/topic/wm831x' into regulator-next)
Merging security/next (923b49ff69fc Merge branch 'master' of git://git.infr=
adead.org/users/pcmoore/selinux into next)
CONFLICT (content): Merge conflict in drivers/char/tpm/tpm_ppi.c
Merging selinux/master (8ed814602876 SELinux: Fix memory leak upon loading =
policy)
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (4505bc47230f watchdog: s3c2410_wdt: Report when th=
e watchdog reset the system)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (53b173565919 Merge branches 'arm/smmu', 'core', 'x86/vt=
-d', 'arm/shmobile', 'x86/amd', 'ppc/pamu', 'iommu/fixes' and 'arm/msm' int=
o next)
Merging vfio/next (d10999016f41 vfio: Convert control interface to misc dri=
ver)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (6fe495e0f80e thermal: rcar: comment spelling)
CONFLICT (content): Merge conflict in drivers/gpu/drm/qxl/Kconfig
Merging audit/master (fc582aef7dcc Merge tag 'v3.12')
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (1ca56e7dcadd of: irq: Ignore disabled intc's when s=
earching map)
Merging spi/for-next (ed614af5bb75 Merge remote-tracking branches 'spi/topi=
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
Merging kvm-arm/kvm-arm-next (61466710de07 KVM: ARM: Remove duplicate inclu=
de)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (b1a3b1c8a8d9 xen/fb: allow xenfb initialization=
 for hvm guests)
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
Merging leds/for-next (cfc7937fb6bd leds: s3c24xx: Remove hardware.h inclus=
ion)
Merging driver-core/driver-core-next (eb4c69033fd1 Revert "kobject: introdu=
ce kobj_completion")
Merging tty/tty-next (3685f19e0780 serial: 8250: enable UART_BUG_NOMSR for =
Tegra)
Merging usb/usb-next (f3c1f5151a90 USB: c67x00: correct spelling mistakes i=
n comments)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (8a3cecf5030f Merge tag 'iio-for-3.14c' of git=
://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-drm-core.c
Merging char-misc/char-misc-next (634608f27acd misc: genwqe: fix return val=
ue check in genwqe_device_create())
Merging scsi/for-next (81286dea29d1 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (d79dc4525ad5 target: Convert inquiry tempo=
rary buffer to heap memory)
CONFLICT (content): Merge conflict in drivers/target/target_core_tpg.c
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (8385af02bad1 pinctrl: sirf: add pin group for USP=
0 with only RX or TX frame sync)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (ccb6fbb99020 Documentation / ACPI: update to GPIO de=
scriptor API)
CONFLICT (content): Merge conflict in drivers/leds/leds-s3c24xx.c
CONFLICT (content): Merge conflict in arch/xtensa/Kconfig
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
CONFLICT (content): Merge conflict in block/blk-mq-cpu.c
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
Merging akpm/master (7178e2055358 mm: add strictlimit knob)

--Signature=_Thu__9_Jan_2014_17_50_39_+1100_Ti7onSzU_suPadtc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzkbDAAoJEMDTa8Ir7ZwVjzEP/33YWas+PlGayrBIkUvygxnf
VuQCRon1esSkPPd49OinDdlHvuJ+N3yoDXhC71j0kaezlx2RGETbpv1jcO9mmZQ4
yxeA9kRclw2uSucZwzlQzsfIWEsuUYOQTuKwXTwC1piaHNzevtq7IjgPWkQlfo4V
cstP4T5ELbCqjt3VDlP21raQo8ZN68DXSv4q9mbduBdPb+xert02420a7W47OxCL
zZ6/SGzILRXcdn/ufMggkMlfA2cUjwRduMv7U+/pYFOjesUyasDAfAVL3xettVGT
K7Jzr9ZW8Rag+DV8xrJ7mXWIfp1A9oA7YvrAD16HRMZ0QwxfaDP337kSEbtIq6+g
uxRFjbAj0Dm9lutc3WcxqXvtKjK7E9rVazq6qeOTmHypL0OdWgN2UwOhTCTlLlyF
FHU2PvtrT5hPeLJsyO7FUjapYp9QQV7E6qoblmZ9FDpA0dIMZSY3YftFfV70PDkT
h3No1C5TLoZaIPP9igJIe4DKGOVDcDkB/PC4869BKSDxvLx29kjmB48ILcrg2kcQ
Qc0kZnLmTfqQQLtDJrJEd4cJHGC1r6k5z8dDBklV6c94PdfLHKTDaxXZGITBjVAD
ZVaK3vQPCDI9XaImtj82VQhdrXvHkPwmTKHuIlv6DFAnoO2jb5SWPHhFLBw5m0io
ty8YKHl8silIUmYLgP2m
=40Cx
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jan_2014_17_50_39_+1100_Ti7onSzU_suPadtc--
