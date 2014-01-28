Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaA1Dh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:37:56 -0500
Received: from ozlabs.org ([203.10.76.45]:57173 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaA1Dhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:37:51 -0500
Date: Tue, 28 Jan 2014 14:37:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 28
Message-Id: <20140128143743.75414e6b1ac85830c19c8918@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Jan_2014_14_37_43_+1100_cKE3yR5PFoPBy/Ju"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jan_2014_14_37_43_+1100_cKE3yR5PFoPBy/Ju
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do *not* add material destined for v3.15 to your linux-next
included trees until after v3.14-rc1 is released.

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140124:

Dropped trees: imx-mxs (complex merge conflicts against the arm tree)

The powerpc tree still had its build failure.

Tip tree gained a conflict against Linus' tree.

The staging tree lost its build failure.

The scsi tree lost its conflicts so it is back.

The init tree lost some more of its patches.

Non-merge commits (relative to Linus' tree): 2689
 3435 files changed, 215376 insertions(+), 61940 deletions(-)

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

I am currently merging 208 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (ba635f8cd20e Merge tag 'trace-fixes-3.14' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (b25f3e1c3584 ARM: 7938/1: OMAP4/highbank: Flush =
L2 cache before disabling)
Merging m68k-current/for-linus (56931d73697c m68k/mac: Make SCC reset work =
more reliably)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (b3084f4db3ae powerpc/thp: Fix crash on mremap)
Merging sparc/master (ef350bb7c5e0 Merge tag 'ext4_for_linus_stable' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging net/master (bb9fbe2ddd6d AF_PACKET: Add documentation for queue map=
ping fanout mode)
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (e7729a415315 ALSA: hda - Fix silent output=
 on MacBook Air 1,1)
Merging pci-current/for-linus (f0b75693cbb2 MAINTAINERS: Add DesignWare, i.=
MX6, Armada, R-Car PCI host maintainers)
Merging wireless/master (7d0d46da750a Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
Merging driver-core.current/driver-core-linus (90804ed61f24 Merge branch 'f=
or_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging tty.current/tty-linus (413541dd66d5 Linux 3.13-rc5)
Merging usb.current/usb-linus (90804ed61f24 Merge branch 'for_linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging staging.current/staging-linus (77d143de7581 Merge branch 'for-linus=
' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml)
Merging char-misc.current/char-misc-linus (90804ed61f24 Merge branch 'for_l=
inus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging input-current/for-linus (55df811f2066 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (79ba451d66ca crypto: aesni - fix build on x8=
6 (32bit))
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (6f041e99fc7b of: Fix NULL dere=
ference in unflatten_and_copy())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (09f2344d0896 drm/i915/bdw: ma=
ke sure south port interrupts are enabled properly v2)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (e57d339a6264 ARC: [cmdline] support External Device T=
rees from u-boot)
Merging arm/for-next (e45022aa729f Merge branch 'cubox-i-init' into for-nex=
t)
Merging arm-perf/for-next/perf (6ce4eac1f600 Linux 3.13-rc1)
Merging arm-soc/for-next (57f319bc4fb8 Merge branch 'late/misc' into for-ne=
xt)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/bcm11351.dtsi
Merging bcm2835/for-next (413541dd66d5 Linux 3.13-rc5)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (211028099575 Merge branch 'imx/dt' into for-next)
CONFLICT (add/add): Merge conflict in arch/arm/boot/dts/imx6qdl-microsom.dt=
si
CONFLICT (add/add): Merge conflict in arch/arm/boot/dts/imx6qdl-microsom-ar=
8035.dtsi
CONFLICT (add/add): Merge conflict in arch/arm/boot/dts/imx6dl-hummingboard=
.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
$ git merge --abort
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (a76f86614bab Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (88c499f14016 Merge branch 'heads/dt-fixes' into next)
Merging samsung/for-next (8109c477487a Merge branch 'v3.14-next/dt-exynos-3=
' into for-next)
Merging tegra/for-next (95e770a5ad96 Merge branch for-3.14/defconfig into f=
or-next)
Merging arm64/for-next/core (883c05736701 arm64: fix typo in entry.S)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (e269a869417c Drop code for CRISv10 CPU simulator)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (56931d73697c m68k/mac: Make SCC reset work more reli=
ably)
Merging m68knommu/for-next (a695b9c8911e m68k : Kill CONFIG_MTD_PARTITIONS)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (c0d68cea2db3 microblaze: Add missing v8.50.a versi=
on)
Merging mips/mips-for-linux-next (b26a21c1eacd mips: select ARCH_MIGHT_HAVE=
_PC_SERIO)
CONFLICT (content): Merge conflict in arch/mips/netlogic/xlp/setup.c
CONFLICT (content): Merge conflict in arch/mips/kernel/vpe.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/vpe.h
CONFLICT (content): Merge conflict in arch/mips/bcm47xx/setup.c
CONFLICT (content): Merge conflict in arch/mips/Kconfig
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (7d1c153ab373 Merge branch 'parisc-3.13' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging powerpc/next (fac515db4520 Merge remote-tracking branch 'scott/next=
' into next)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
CONFLICT (content): Merge conflict in drivers/spi/spi-mpc512x-psc.c
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (07be03820970 s390/hypfs: add interface for diagnose =
0x304)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (9ed82c6866e2 xtensa: implement ndelay)
Merging btrfs/next (56817eda3c10 Btrfs: introduce the delayed inode ref del=
etion for the single link inode)
Merging ceph/master (8eb4efb091c8 ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (d81b8a40e2ec CIFS: Cleanup cifs open codepath)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (353aeefe7f86 ext4: delete "set but not used" variables)
Merging f2fs/dev (bf39c00a9a7f f2fs: drop obsolete node page when it is tru=
ncated)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (c6f459d25c02 fuse: Turn writeback cache on)
Merging gfs2/master (d57b9c9a999a GFS2: revert "GFS2: d_splice_alias() can'=
t return error")
Merging jfs/jfs-next (0439e091e3b1 jfs: fix xattr value size overflow in __=
jfs_setxattr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (0ea9de0ea6a4 sunrpc: turn warn_gssd() log message i=
nto a dprintk())
Merging nfsd/nfsd-next (c692554bf4fe gss_krb5: use lcm from kernel lib)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (98009cb25d6b 9p: update documentation)
Merging ubifs/linux-next (c23e9b75ccd0 UBIFS: remove invalid warn msg with =
tst_recovery enabled)
Merging xfs/for-next (7c71ee78031c xfs: allow logical-sector sized O_DIRECT)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (cef09b808e58 Merge branch 'eisa' into next)
Merging hid/for-next (fd7e37af337b Merge branch 'for-3.14/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (6ff4b1051632 i2c: rcar: fix NACK error code)
Merging jdelvare-hwmon/master (68d5516b35c7 hwmon: (it87) Print proper name=
s for the IT8771E and IT8772E)
Merging hwmon-staging/hwmon-next (d303b1b5fbb6 hwmon: (k10temp) Add support=
 for Kaveri CPUs)
Merging v4l-dvb/master (e26d710a8cdf Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in drivers/staging/media/go7007/go7007-u=
sb.c
CONFLICT (content): Merge conflict in MAINTAINERS
Merging kbuild/for-next (ddbfd0b07555 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (f939ad10650c Merge branch 'for-3.14' into for-next)
Merging pm/linux-next (1d26f32cd334 Merge branch 'pm-devfreq-next' into lin=
ux-next)
Merging idle/next (5c56be9a25ba turbostat: Add option to report joules cons=
umed per sample)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (262afa97587b Merge branches 'soc-eduardo', 'soc', 'mi=
sc' and 'int3404-thermal' of .git into next)
CONFLICT (content): Merge conflict in drivers/thermal/Kconfig
Merging ieee1394/for-next (fcd46b34425d firewire: Enable remote DMA above 4=
 GB)
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (468241ca5903 Merge branch 'for-linus' into next)
CONFLICT (content): Merge conflict in sound/soc/fsl/fsl_ssi.c
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (77d143de7581 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/rw/uml)
Merging ipsec-next/master (abfce3ef58b6 sctp: remove the unnecessary assign=
ment)
Merging wireless-next/master (a64e1a45060f ath9k: Fix RX interrupt mitigati=
on)
Merging bluetooth/master (5a54df7ae120 Bluetooth: Fix CID initialization fo=
r fixed channels)
Applying: net: 6lowpan: fixup for code movement
Merging infiniband/for-next (fb1b5034e498 Merge branch 'ip-roce' into for-n=
ext)
Merging mtd/master (802eee95bde7 Linux 3.13-rc6)
Merging l2-mtd/master (02d018625b78 mtd: s3c2410: Merge plat/regs-nand.h in=
to s3c2410.c)
Merging crypto/master (79ba451d66ca crypto: aesni - fix build on x86 (32bit=
))
Merging drm/drm-next (76f4f415e502 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-intel/for-linux-next (22accca01713 i915: remove pm_qos request =
on error)
Merging drm-tegra/drm/for-next (13411ddd3190 drm/tegra: Obtain head number =
from DT)
Merging sound/for-next (e7729a415315 ALSA: hda - Fix silent output on MacBo=
ok Air 1,1)
Merging sound-asoc/for-next (024531999da9 Merge remote-tracking branches 'a=
soc/fix/arizona', 'asoc/fix/fsl', 'asoc/fix/omap', 'asoc/fix/samsung', 'aso=
c/fix/simple' and 'asoc/fix/wm5100' into asoc-linus)
Merging modules/modules-next (22e669568d51 module: Add missing newline in p=
rintk call.)
Merging virtio/virtio-next (05c54de8c88c drivers: virtio: Mark function vir=
tballoon_migratepage() as static in virtio_balloon.c)
Merging input/next (497ab1f290a2 Input: wacom - add support for DTU-1031)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (f446b64bccab Merge branch 'for-3.14' into for-next)
Merging block/for-next (c0f80832454e Merge branch 'for-3.14/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in include/trace/events/f2fs.h
CONFLICT (content): Merge conflict in fs/f2fs/segment.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
CONFLICT (content): Merge conflict in fs/btrfs/extent_io.c
CONFLICT (content): Merge conflict in drivers/md/raid10.c
CONFLICT (content): Merge conflict in drivers/md/raid1.c
CONFLICT (content): Merge conflict in drivers/md/dm-thin.c
Merging device-mapper/for-next (5066a4df1f42 dm log userspace: allow mark r=
equests to piggyback on flush requests)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (945be38caa28 mmc: sdhci-pci: Fix possibility of chip-=
>fixes being null)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (7da9d450ab28 md/raid5: close recently introduced race =
in stripe_head management.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (02915661dbb9 mfd: wm5110: Add register patch f=
or rev D chip)
Merging battery/master (4f8dd2c10bec dt: binding documentation for bq2415x =
charger)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (cb1fbad7ec25 Merge branches '3.14/fbdev', '3.14=
/dss-misc' and '3.14/dss-fclk' into for-next)
Merging regulator/for-next (dab396310a03 Merge remote-tracking branch 'regu=
lator/fix/ab3100' into regulator-linus)
Merging security/next (923b49ff69fc Merge branch 'master' of git://git.infr=
adead.org/users/pcmoore/selinux into next)
Merging selinux/next (41be702a542a Merge tag 'v3.13' into next)
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (c5321c491606 watchdog: w83627hf_wdt: Reset watchdo=
g trigger during initialization)
CONFLICT (content): Merge conflict in arch/arm/configs/bcm_defconfig
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (dd1a175695ed Merge branches 'arm/smmu', 'core', 'x86/vt=
-d', 'arm/shmobile', 'x86/amd', 'ppc/pamu', 'iommu/fixes' and 'arm/msm' int=
o next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/msm/Kconfig
Merging vfio/next (3be3a074cf5b vfio-pci: Don't use device_lock around AER =
interrupt setup)
Merging osd/linux-next (19350e7627a6 exofs: Print less in r4w)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (c04e7da0133f neighbour.h: fix comment)
Merging audit/master (f3411cb2b2e3 audit: whitespace fix in kernel-paramete=
rs.txt)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (2a9330010bea dt/bindings: submitting pa=
tches and ABI documents)
Merging dt-rh/for-next (e48ca29d30a1 dt-bindings: add rockchip vendor prefi=
x)
Merging spi/for-next (ae49d4c5d6e9 Merge remote-tracking branches 'spi/topi=
c/altera', 'spi/topic/ath79', 'spi/topic/atmel', 'spi/topic/bcm2835', 'spi/=
topic/bcm63xx', 'spi/topic/bcm63xx-hsspi', 'spi/topic/bitbang', 'spi/topic/=
bpw', 'spi/topic/clps711x', 'spi/topic/coldfire', 'spi/topic/davinci', 'spi=
/topic/dw', 'spi/topic/falcon', 'spi/topic/fsl-espi', 'spi/topic/gpio', 'sp=
i/topic/hspi', 'spi/topic/mpc512x', 'spi/topic/msiof', 'spi/topic/nuc900', =
'spi/topic/oc-tiny', 'spi/topic/omap', 'spi/topic/orion', 'spi/topic/pci', =
'spi/topic/pxa2xx', 'spi/topic/qspi', 'spi/topic/s3c24xx', 'spi/topic/s3c64=
xx', 'spi/topic/sc18is602', 'spi/topic/sh', 'spi/topic/tegra114', 'spi/topi=
c/tegra20-sflash', 'spi/topic/tegra20-slink', 'spi/topic/txx9' and 'spi/top=
ic/xcomm' into spi-next)
Merging tip/auto-latest (5a0c401955b2 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in Documentation/sysctl/kernel.txt
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (881f0fcef999 EDAC: Don't try to cancel workqueue=
 when it's never setup)
Merging ftrace/for-next (3132e107d608 tracing: Check if tracing is enabled =
in trace_puts())
Merging rcu/rcu/next (98cbc61863d3 Merge commit '0d3c55bc9fd58393bd3bd99749=
91ec1f815e1326' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (c760f5e29d92 Merge tag 'kvm-s390-20140117' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-queue)
Merging kvm-arm/kvm-arm-next (31ac1ca80d75 KVM: Specify byte order for KVM_=
EXIT_MMIO)
Merging kvm-ppc/kvm-ppc-next (27025a602cb9 powerpc: kvm: optimize "sc 1" as=
 fast return)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (c9f6e9977e38 xen/pvh: Set X86_CR0_WP and others=
 in CR0 (v2))
Merging percpu/for-next (d5f2deed588b Merge branch 'for-3.14' into for-next)
Merging workqueues/for-next (9af16df84f0c Merge branch 'for-3.14' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
CONFLICT (content): Merge conflict in drivers/platform/x86/mxm-wmi.c
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (afda06ac2771 Merge remote-tracking branch 'regmap/=
fix/block' into regmap-linus)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (44f17fa9218b leds: s3c24xx: Remove hardware.h inclus=
ion)
CONFLICT (content): Merge conflict in drivers/leds/leds-s3c24xx.c
Merging driver-core/driver-core-next (90804ed61f24 Merge branch 'for_linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging tty/tty-next (4fbd269f1f9f Merge branch 'fixes' into tty-next)
Merging usb/usb-next (90804ed61f24 Merge branch 'for_linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (d7216f8f02da staging: r8821ae: Enable build b=
y reverting BROKEN marking)
Merging char-misc/char-misc-next (90804ed61f24 Merge branch 'for_linus' of =
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging scsi/for-next (3ce438df1068 [SCSI] hpsa: allow SCSI mid layer to ha=
ndle unit attention)
Merging target-updates/for-next (76736db3e291 target: Report bad sector in =
sense data for DIF errors)
CONFLICT (content): Merge conflict in drivers/target/target_core_tpg.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
Applying: tagtet/iblock: merge for for bvec_iter changes
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (cf8400ce6fe6 imx27: pinctrl: fix wrong offset to =
ICONFB)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (3a54bb21f219 gpio: xtensa: fix build when XCHAL_HAVE=
_CP is 0)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (6691a19966f0 pwm: tiecap: Remove duplicate put_sync c=
all)
Merging dma-buf/for-next (17b2112f332d Merge branch 'merge' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging userns/for-next (f58437f1f916 MIPS: VPE: Remove vpe_getuid and vpe_=
getgid)
Merging ktest/for-next (961d9caceea2 ktest: Add BISECT_TRIES to bisect test)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (051c8d0b6674 clk: qcom: Fix modular build)
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (8e321fefb0e6 aio/migratepages: make aio migrate pages s=
ane)
Merging akpm-current/current (0fc6f4e2e3d5 splice: fix unexpected size trun=
cation)
CONFLICT (content): Merge conflict in mm/rmap.c
CONFLICT (content): Merge conflict in mm/page_alloc.c
CONFLICT (content): Merge conflict in mm/oom_kill.c
CONFLICT (content): Merge conflict in mm/nobootmem.c
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in lib/vsprintf.c
CONFLICT (content): Merge conflict in lib/percpu_counter.c
CONFLICT (content): Merge conflict in include/linux/vm_event_item.h
CONFLICT (content): Merge conflict in arch/x86/mm/srat.c
CONFLICT (content): Merge conflict in Documentation/sysctl/kernel.txt
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Applying: nobootmem: fix mismerge
$ git checkout -b akpm remotes/origin/akpm/master
Applying: kernel/kexec.c: use vscnprintf() instead of vsnprintf() in vmcore=
info_append_str()
Applying: softirq: use ffs() in __do_softirq()
Applying: softirq: convert printks to pr_<level>
Applying: softirq: use const char * const for softirq_to_name, whitespace n=
eatening
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
Applying: zram: remove old private project comment
Applying: zram: add copyright
Applying: zsmalloc: add copyright
Applying: zram: add zram maintainers
Applying: zsmalloc: add maintainers
Applying: block/blk-mq-cpu.c: use hotcpu_notifier()
Applying: kernel: use lockless list for smp_call_function_single
Applying: kernel/smp.c: remove cpumask_ipi
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: zram: fix race between reset and flushing pending work
Applying: zram: delay pending free request in read path
Applying: zram: remove unnecessary free
Applying: zram: use atomic operation for stat
Applying: zram: introduce zram->tb_lock
Applying: zram: remove workqueue for freeing removed pending slot
Applying: zram: remove zram->lock in read path and change it with mutex
Applying: mm: add strictlimit knob
Merging akpm/master (b59dc266e32b mm: add strictlimit knob)
$ git checkout -b init remotes/origin/init/master
Applying: init: delete the __cpuinit related stubs
Applying: mm: replace module_init usages with subsys_initcall in nommu.c
Applying: fs/notify: don't use module_init for non-modular inotify_user code
Applying: netfilter: don't use module_init/exit in core IPV4 code
Applying: x86: don't use module_init in non-modular intel_mid_vrtc.c
Applying: x86: don't use module_init for non-modular core bootflag code
Applying: x86: replace __init_or_module with __init in non-modular vsmp_64.c
Applying: x86: don't use module_init in non-modular devicetree.c code
Applying: drivers/tty/hvc: don't use module_init in non-modular hyp. consol=
e code
Applying: staging: don't use module_init in non-modular ion_dummy_driver.c
Applying: powerpc: use device_initcall for registering rtc devices
Applying: powerpc: book3s KVM can be modular so it should use module.h
Applying: powerpc: kvm e500/44x is not modular, so don't use module_init
Applying: powerpc: use subsys_initcall for Freescale Local Bus
Applying: powerpc: don't use module_init for non-modular core hugetlb code
Applying: powerpc: don't use module_init in non-modular 83xx suspend code
Applying: arm: include module.h in drivers/bus/omap_l3_smx.c
Applying: arm: fix implicit module.h use in mach-at91 gpio.h
Applying: arm: fix implicit #include <linux/init.h> in entry asm.
Applying: arm: mach-s3c64xx mach-crag6410-module.c is not modular
Applying: arm: use subsys_initcall in non-modular pl320 IPC code
Applying: arm: don't use module_init in non-modular mach-vexpress/spc.c code
Applying: alpha: don't use module_init for non-modular core code
Applying: sparc: don't use module_init in non-modular pci.c code
Applying: m68k: don't use module_init in non-modular mvme16x/rtc.c code
Applying: ia64: don't use module_init for non-modular core kernel/mca.c code
Applying: ia64: don't use module_init in non-modular sim/simscsi.c code
Applying: mips: make loongsoon serial driver explicitly modular
Applying: mips: don't use module_init in non-modular sead3-mtd.c code
Applying: cris: don't use module_init for non-modular core intmem.c code
Applying: parisc: don't use module_init for non-modular core pdc_cons code
Applying: parisc64: don't use module_init for non-modular core perf code
Applying: mn10300: don't use module_init in non-modular flash.c code
Applying: sh: don't use module_init in non-modular psw.c code
Applying: sh: mach-highlander/psw.c is tristate and should use module.h
Applying: xtensa: don't use module_init for non-modular core network.c code
Applying: drivers/clk: don't use module_init in clk-nomadik.c which is non-=
modular
Applying: cpuidle: don't use modular platform register in non-modular ARM d=
rivers
Applying: drivers/platform: don't use modular register in non-modular pdev_=
bus.c
Applying: module: relocate module_init from init.h to module.h
Applying: logo: emit "#include <linux/init.h> in autogenerated C file
Applying: arm: delete non-required instances of include <linux/init.h>
Applying: mips: restore init.h usage to arch/mips/ar7/time.c
Applying: sparc: delete non-required instances of include <linux/init.h>
Applying: s390: delete non-required instances of include <linux/init.h>
Applying: alpha: delete non-required instances of <linux/init.h>
Applying: blackfin: delete non-required instances of <linux/init.h>
Applying: powerpc: delete another unrequired instance of <linux/init.h>
Applying: arm64: delete non-required instances of <linux/init.h>
Applying: watchdog: delete non-required instances of include <linux/init.h>
Applying: video: delete non-required instances of include <linux/init.h>
Applying: rtc: delete non-required instances of include <linux/init.h>
Applying: scsi: delete non-required instances of include <linux/init.h>
Applying: spi: delete non-required instances of include <linux/init.h>
Applying: acpi: delete non-required instances of include <linux/init.h>
Applying: drivers/power: delete non-required instances of include <linux/in=
it.h>
Applying: drivers/media: delete non-required instances of include <linux/in=
it.h>
Applying: drivers/ata: delete non-required instances of include <linux/init=
.h>
Applying: drivers/mtd: delete non-required instances of include <linux/init=
.h>
Applying: drivers/hwmon: delete non-required instances of include <linux/in=
it.h>
Applying: drivers/pinctrl: delete non-required instances of include <linux/=
init.h>
Applying: drivers/isdn: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/leds: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/pcmcia: delete non-required instances of include <linux/i=
nit.h>
Applying: drivers/char: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/infiniband: delete non-required instances of include <lin=
ux/init.h>
Applying: drivers/mfd: delete non-required instances of include <linux/init=
.h>
Applying: drivers/gpio: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/bluetooth: delete non-required instances of include <linu=
x/init.h>
Applying: drivers/mmc: delete non-required instances of include <linux/init=
.h>
Applying: drivers/crypto: delete non-required instances of include <linux/i=
nit.h>
Applying: drivers/platform: delete non-required instances of include <linux=
/init.h>
Applying: drivers/misc: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/edac: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/macintosh: delete non-required instances of include <linu=
x/init.h>
Applying: drivers/base: delete non-required instances of include <linux/ini=
t.h>
Applying: drivers/cpufreq: delete non-required instances of <linux/init.h>
Applying: drivers/pci: delete non-required instances of <linux/init.h>
Applying: drivers/dma: delete non-required instances of <linux/init.h>
Applying: drivers/gpu: delete non-required instances of <linux/init.h>
Applying: drivers: delete remaining non-required instances of <linux/init.h>
Applying: include: remove needless instances of <linux/init.h>
CONFLICT (content): Merge conflict in include/linux/percpu_ida.h
Merging init/master (29866d706a6a include: remove needless instances of <li=
nux/init.h>)

--Signature=_Tue__28_Jan_2014_14_37_43_+1100_cKE3yR5PFoPBy/Ju
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS5yYLAAoJEMDTa8Ir7ZwVQuwP/38qhmXTAO/+wFO3Hk6k/lH5
1czWEVmJrM/Yjz5rNC3m4NghOVEGfahOlHctCJFMgapc5aIC91mcz3e3XbPpWy6u
dQTFwXjJ6Ftmmn+FXsdhCJqbziXJMbwcUmzoqlNny/wQKL/BHDxpM7PAuMUw8j55
eZI3TzcAq84jlZM50E1Lxvmmh81JDfz4sxX5aO+HKcsrbSCa2stroago2haWpZw6
B+IwLU3IHsCmjKKTVfqa6ZF9fazQWwN69Szd3axL01oCbuq0NfMNciZeDhvZHBSp
woMHXz/naqssR499afIcYw//rFac6HsgZRpr7WXiP261/ciyKwlHCDdE0pKCi1bf
4pFXfUrMwwwAx2Xh5/4Bv3GyW2AlLrfaj45z2x2JkVw25ZcS61lgjGWJMXe70UPE
Jr3rDw+DjQwl5TekFgAzXUf/XmAJYRSUV70C8JGPZa2ABapfkxaizvr6Iq3cpmlb
9LQViNpClz+INq9v+lF39m9/cHBRWVjhjsAa80JVe6jYJHaSm13jO7AhOTkoIjjd
/bUtGCaFpBTyMJPyRxoa+ggtEMr108E7aZFrxoC/UBWI7QkDivNLwKuSf2cqMAyi
Fyy2ruYgN+xA2yqHjGMnt+CfXFjzAjFhxW9zhKW9SEnnGj7Z8DmCBqmSikSIZ77C
iwxfOQHiAhAcGGCL9Xn4
=5Ycy
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jan_2014_14_37_43_+1100_cKE3yR5PFoPBy/Ju--
