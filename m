Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaDHDlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:41:44 -0400
Received: from ozlabs.org ([203.10.76.45]:48178 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbaDHDlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:41:40 -0400
Date: Tue, 8 Apr 2014 13:41:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 8
Message-Id: <20140408134131.3a82e167eb332d535577f357@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Apr_2014_13_41_31_+1000_uPAgZzBh9hvn1YGy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Apr_2014_13_41_31_+1000_uPAgZzBh9hvn1YGy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add material intended for v3.16 to your linux-next included
branches until after v3.15-rc1 is released.

This tree still fails (more than usual) the powerpc allyesconfig build.

Changes since 20140407:

Dropped trees: akpm-current, akpm (too complex conflicts)

The powerpc tree still had its build failure.

Non-merge commits (relative to Linus' tree): 1631
 1840 files changed, 145755 insertions(+), 30565 deletions(-)

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
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 213 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (dc5ed40686a4 Merge branch 'for-3.15-fixes' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (61fb4bfc010b ARC: [nsimosci] Unbork console)
Merging arm-current/fixes (c9d347e02776 ARM: 8009/1: dcscb.c: remove call t=
o outer_flush_all())
Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3=
.14-rc1)
Merging metag-fixes/fixes (0414855fdc4a Linux 3.14-rc5)
Merging powerpc-merge/merge (27143b9a0da7 powerpc/le: Avoid creatng R_PPC64=
_TOCSAVE relocations for modules.)
Merging sparc/master (455c6fdbd219 Linux 3.14)
Merging net/master (6859e7df6d90 netdev: remove potentially harmful checks)
Merging ipsec/master (d80e773f16f6 Merge branch 'master' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/pablo/nf)
Merging sound-current/for-linus (de9481cb4033 ALSA: hda/realtek - Improve H=
P depop when system change power state on Chromebook)
Merging pci-current/for-linus (707d4eefbdb3 Revert "[PATCH] Insert GART reg=
ion into resource map")
Merging wireless/master (584221918925 Revert "rt2x00: rt2800lib: Update BBP=
 register initialization for RT53xx")
Merging driver-core.current/driver-core-linus (b33ce4429938 Merge branch 'f=
or-3.15/drivers' of git://git.kernel.dk/linux-block)
Merging tty.current/tty-linus (b33ce4429938 Merge branch 'for-3.15/drivers'=
 of git://git.kernel.dk/linux-block)
Merging usb.current/usb-linus (b33ce4429938 Merge branch 'for-3.15/drivers'=
 of git://git.kernel.dk/linux-block)
Merging staging.current/staging-linus (8e0c0832348c Merge tag 'fbdev-main-3=
.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux)
Merging char-misc.current/char-misc-linus (b33ce4429938 Merge branch 'for-3=
.15/drivers' of git://git.kernel.dk/linux-block)
Merging input-current/for-linus (692d96552c9a Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (8ceee72808d1 crypto: ghash-clmulni-intel - u=
se C implementation for setkey())
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (1f42e5dd5065 of: Add self test=
 for of_match_node())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (9db32cb625a5 drm/i915: Undo g=
tt scratch pte unmapping again)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (b098d6726bbf Linux 3.14-rc8)
Merging arm/for-next (2434eadb5f53 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (6d0abeca3242 Linux 3.14-rc3)
Merging arm-soc/for-next (64a5445b2b9e arm-soc: add contents file)
CONFLICT (content): Merge conflict in sound/soc/kirkwood/Kconfig
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/pdata-quirks.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/qcom-msm8974.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/qcom-msm8960.dtsi
Applying: arm: Replace various irq_desc accesses fix for file move
Applying: ARM: dts: i.MX53: merge fix patch
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (ec75de15f440 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (47fc77cc704e Merge branch 'for_3.15/fixes' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (6412d6635b67 Merge branch 'mvebu/dt-fixes-non-criti=
cal' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging renesas/next (68d1f3aad83a Merge branch 'heads/clock-for-v3.15' int=
o next)
Merging samsung/for-next (82cd4473bde8 Merge branch 'v3.15-next/cleanup-exy=
nos' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/exynos.c
Merging tegra/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging arm64/for-next/core (0420fa9426ed arm64: Clean up the default pgpro=
t setting)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
Merging m68knommu/for-next (4dc5aa217237 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (a66a626538af microblaze: Use asm-generic/io.h)
Merging mips/mips-for-linux-next (75d61b3bbd4c Merge branch '3.15-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (496252f78756 parisc: Replace __get_cpu_var uses=
 for address calculation)
Merging powerpc/next (cd427485357c Merge remote-tracking branch 'scott/next=
' into next)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (457f2180951c s390/uaccess: rework uaccess code - fix=
 locking issues)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5eb0bdf84433 arch/tile: remove unused variable 'devcap=
')
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (b3fdfc1b4b64 Merge tag 'xtensa-for-next-20140221-1=
' into for_next)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache r=
eaddir)
Merging cifs/for-next (a5a64da8c4e5 fs: cifs: remove unused variable.)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (ad6599ab3ac9 ext4: fix premature freeing of partial clust=
ers split across leaf blocks)
Merging f2fs/dev (48b230a58396 f2fs: fix wrong statistics of inline data)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (f3846266f593 fuse: fix "uninitialized variable" warn=
ing)
Merging gfs2/master (1b2ad41214c9 GFS2: Fix address space from page functio=
n)
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (2b3a8fd735f8 Merge tag 'nfs-for-3.15-1' of git://gi=
t.linux-nfs.org/projects/trondmy/linux-nfs)
Merging nfsd/nfsd-next (06f9cc12caa8 nfsd4: don't create unnecessary mask a=
cl)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (8a5daf1e2c19 9pnet_rdma: check token type before int=
 conversion)
Merging ubifs/linux-next (d56030ac25d3 UBI: block: Remove __initdata from u=
biblock_param_ops)
Merging xfs/for-next (a6cf33bc566c Merge branch 'xfs-bug-fixes-for-3.15-3' =
into for-next)
Merging file-private-locks/linux-next (18a1a7a1d862 Merge git://git.kernel.=
org/pub/scm/linux/kernel/git/cmetcalf/linux-tile)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (30723cbf6f7a Merge branch 'pci/resource' into next)
Merging hid/for-next (d1443c96d663 Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (1fbeab0b8fd5 i2c: cadence: fix Kconfig dependency)
Merging jdelvare-hwmon/master (455c6fdbd219 Linux 3.14)
Merging hwmon-staging/hwmon-next (ec0159503ae7 hwmon: (k10temp) Add support=
 for AMD F16 M30h processor)
Merging v4l-dvb/master (83701d7a7094 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (b072b79f07d2 Merge branch 'kbuild/lto' into kbuild=
/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (27aa64b9d1bd pata_at91: fix ata_host_activate() fa=
ilure handling)
Merging pm/linux-next (22b38e4f3729 Merge branch 'cpu-hotplug' into linux-n=
ext)
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (e79ca84d62d2 Merge branches 'soc-fix' and 'thermal-co=
re-fix' of .git into next)
Merging ieee1394/for-next (0ca49345b6f4 firewire: ohci: fix probe failure w=
ith Agere/LSI controllers)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (420598e2a088 Merge branch 'for-linus' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (cd6362befe4c Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net-next)
Merging ipsec-next/master (cd6362befe4c Merge git://git.kernel.org/pub/scm/=
linux/kernel/git/davem/net-next)
Merging wireless-next/master (a31267c30880 rtl8187: fix use after free on f=
ailure path in rtl8187_probe())
Merging bluetooth/master (5c5b93e4be2f Bluetooth: Fix address in unmergeabl=
e device found events)
Merging infiniband/for-next (f7eaa7ed8fd4 Merge branches 'core', 'cxgb4', '=
ip-roce', 'iser', 'misc', 'mlx4', 'nes', 'ocrdma', 'qib', 'sgwrapper', 'srp=
' and 'usnic' into for-next)
Merging mtd/master (4a4163caccae Fix index regression in nand_read_subpage)
Merging l2-mtd/master (4a4163caccae Fix index regression in nand_read_subpa=
ge)
Merging crypto/master (0ea481466d1c crypto: ghash-clmulni-intel - Use u128 =
instead of be128 for internal key)
Merging drm/drm-next (9f97ba806a9c Merge tag 'drm-intel-fixes-2014-04-04' o=
f git://anongit.freedesktop.org/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/video/exynos/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/parallel-disp=
lay.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-tve.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-ldb.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-hdmi.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/gma500/mmu.c
Merging drm-intel/for-linux-next (10b6ee4a8781 Skip intel_crt_init for Dell=
 XPS 8700)
Merging drm-tegra/drm/for-next (3d1c1474386e drm/tegra: Use standard GPL v2=
 license text)
Merging sound/for-next (a4b7f21d7b42 ALSA: hda - Enable beep for ASUS 1015E)
Merging sound-asoc/for-next (821d8eed3aed Merge remote-tracking branches 'a=
soc/fix/tlv320aic23' and 'asoc/fix/warn' into asoc-linus)
Merging modules/modules-next (22c9bcad859d staging: fix up speakup kobject =
mode)
Merging virtio/virtio-next (fc4324b4597c virtio-blk: base queue-depth on vi=
rtqueue ringsize or module param)
Merging input/next (e2c3ecf0ea8e Input: edt-ft5x06 - add a missing conditio=
n)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (bccb5f7c8bdf blk-mq: fix potential stall during CPU=
 unplug with IO pending)
Merging device-mapper/for-next (303d4a25d8a2 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (5491ce3f79ee mmc: sdhci-pxav3: add support for the Ar=
mada 38x SDHCI controller)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (5f0985bb1123 mm/slab.c: cleanup outdated comments an=
d unify variables naming)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (789b5e031528 md/raid5: Fix CPU hotplug callback regist=
ration)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (2d28ca731b9b mfd: wm5110: Correct default for =
HEADPHONE_DETECT_1)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (d754589d8044 OMAPDSS: add missing __init for ds=
s_init_ports)
CONFLICT (rename/delete): drivers/video/fbdev/sgivwfb.c deleted in HEAD and=
 renamed in omap_dss2/for-next. Version omap_dss2/for-next of drivers/video=
/fbdev/sgivwfb.c left in tree.
CONFLICT (content): Merge conflict in drivers/video/Makefile
CONFLICT (content): Merge conflict in drivers/video/Kconfig
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_reg.h"->"d=
rivers/gpu/drm/exynos/exynos_dp_reg.h" in branch "HEAD" rename "drivers/vid=
eo/exynos/exynos_dp_reg.h"->"drivers/video/fbdev/exynos/exynos_dp_reg.h" in=
 "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_reg.c"->"d=
rivers/gpu/drm/exynos/exynos_dp_reg.c" in branch "HEAD" rename "drivers/vid=
eo/exynos/exynos_dp_reg.c"->"drivers/video/fbdev/exynos/exynos_dp_reg.c" in=
 "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_core.h"->"=
drivers/gpu/drm/exynos/exynos_dp_core.h" in branch "HEAD" rename "drivers/v=
ideo/exynos/exynos_dp_core.h"->"drivers/video/fbdev/exynos/exynos_dp_core.h=
" in "omap_dss2/for-next"
CONFLICT (rename/rename): Rename "drivers/video/exynos/exynos_dp_core.c"->"=
drivers/gpu/drm/exynos/exynos_dp_core.c" in branch "HEAD" rename "drivers/v=
ideo/exynos/exynos_dp_core.c"->"drivers/video/fbdev/exynos/exynos_dp_core.c=
" in "omap_dss2/for-next"
$ git rm -f drivers/video/fbdev/exynos/exynos_dp_core.c drivers/video/fbdev=
/exynos/exynos_dp_core.h drivers/video/fbdev/exynos/exynos_dp_reg.c drivers=
/video/fbdev/exynos/exynos_dp_reg.h drivers/video/exynos/exynos_dp_core.c d=
rivers/video/exynos/exynos_dp_core.h drivers/video/exynos/exynos_dp_reg.c d=
rivers/video/exynos/exynos_dp_reg.h
$ git rm -f drivers/video/fbdev/sgivwfb.c
Applying: video: fbdev: fix up fro removal of SGI Visual Workstation
Merging regulator/for-next (ecf0b537f0dd Merge remote-tracking branches 're=
gulator/fix/s2m' and 'regulator/fix/s5m8767' into regulator-linus)
Merging security/next (f64410ec6654 selinux: correctly label /proc inodes i=
n use before the policy is loaded)
Merging selinux/next (eee3094683fb selinux: correctly label /proc inodes in=
 use before the policy is loaded)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (fa62c102a75e watchdog: Fix Elan SC520 dependencies)
CONFLICT (content): Merge conflict in drivers/watchdog/orion_wdt.c
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
Merging iommu/next (e172b8122254 Merge branches 'iommu/fixes', 'arm/smmu', =
'x86/amd', 'arm/omap', 'arm/shmobile' and 'x86/vt-d' into next)
Merging dwmw2-iommu/master (7713ec066ae8 iommu/vt-d: Fix error handling in =
ANDD processing)
Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
Merging osd/linux-next (f1f6630b53e7 MAINTAINERS: Update email address for =
bhalevy)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (c800bcd5f53f sparse: fix comment)
Merging audit/master (e231d54c1239 kernel: Use RCU_INIT_POINTER(x, NULL) in=
 audit.c)
CONFLICT (content): Merge conflict in kernel/seccomp.c
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (d88cf7d7b424 Merge remote-tracking bran=
ch 'robh/for-next' into devicetree/next)
Merging dt-rh/for-next (6f976267da0e of: add missing major vendors)
Merging spi/for-next (577d0b6ca192 Merge remote-tracking branches 'spi/fix/=
complete' and 'spi/fix/omap2-mcspi' into spi-linus)
Merging tip/auto-latest (309ba7457356 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in arch/x86/kernel/early-quirks.c
Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct:=
 silence a static checker warning)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into f=
or-next)
Merging ftrace/for-next (3862807880ac tracing: Add BUG_ON when stack end lo=
cation is over written)
Merging rcu/rcu/next (765a3f4fed70 rcu: Provide grace-period piggybacking A=
PI)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (7cbb39d4d4d5 Merge tag 'kvm-3.15-1' of git://git.ke=
rnel.org/pub/scm/virt/kvm/kvm)
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (7227fc066660 Merge branch 'kvm-ppchv-next' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-next)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (0a25e113b480 Merge branch 'devel/for-linus-3.15=
' into linux-next)
Merging percpu/for-next (21ddfd38ee9a percpu: renew the max_contig if we me=
rge the head and previous block)
Merging workqueues/for-next (c4b75dadde82 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (d17a5ee12973 Add WMI driver for controlling=
 AlienFX features on some Alienware products)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (64ca15fdcaa9 Merge remote-tracking branch 'regmap/=
fix/nodev' into regmap-linus)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (0016db26c093 leds: clevo-mail: Make probe function _=
_init)
Merging driver-core/driver-core-next (b33ce4429938 Merge branch 'for-3.15/d=
rivers' of git://git.kernel.dk/linux-block)
Merging tty/tty-next (b33ce4429938 Merge branch 'for-3.15/drivers' of git:/=
/git.kernel.dk/linux-block)
Merging usb/usb-next (b33ce4429938 Merge branch 'for-3.15/drivers' of git:/=
/git.kernel.dk/linux-block)
Merging usb-gadget/next (4b76e14d95f7 phy: ti-pipe3: Add SATA compatible to=
 Documentation binding)
Merging staging/staging-next (dda26427bd52 staging: rtl8723au: The 8723 onl=
y has two paths)
Merging char-misc/char-misc-next (b33ce4429938 Merge branch 'for-3.15/drive=
rs' of git://git.kernel.dk/linux-block)
Merging cgroup/for-next (49957f8e2a43 cgroup: newly created dirs and files =
should be owned by the creator)
Merging scsi/for-next (b2bff6ceb61a [SCSI] sd: Quiesce mode sense error mes=
sages)
Merging target-updates/for-next (17411c8da356 target: Enable READ_STRIP emu=
lation in target_complete_ok_work)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (69c0f2a16ab4 pinctrl: rockchip: handle first half=
 of rk3188-bank0 correctly)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (b22978fc33de gpio: rcar: Add helper variable dev =3D=
 &pdev->dev)
Merging dma-mapping/dma-mapping-next (68efd7d2fb32 arm: dma-mapping: remove=
 order parameter from arm_iommu_create_mapping())
Merging pwm/for-next (2ae69a460413 pwm: pxa: Constify OF match table)
Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging userns/for-next (d211f177b28e audit: Update kdoc for audit_send_rep=
ly and audit_list_rules_send)
Merging ktest/for-next (62183dcac539 ktest: Set CLOSE_CONSOLE_SIGNAL in the=
 kvm.conf)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (e44df332f30b clk: shmobile: fix setting paretn clock =
rate)
Merging random/dev (7b878d4b48c4 random: Add arch_has_random[_seed]())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (fa8a53c39f3f aio: v4 ensure access to ctx->ring_pages i=
s correctly serialised for migration)
Merging llvmlinux/for-next (fbc151c073f4 x86: LLVMLinux: Fix "incomplete ty=
pe const struct x86cpu_device_id")
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (dc5ed40686a4 Merge branch 'for-3.15-fixes' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup)

--Signature=_Tue__8_Apr_2014_13_41_31_+1000_uPAgZzBh9hvn1YGy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQ2/yAAoJEMDTa8Ir7ZwVJq4P/1VAdrQHTmggDpvD9wbVLiof
m2TnSR8FgmXzfFUd/arJjZqOGdwjCqPxzKveAmZ2pQDlzC770icmszcU/DjF8fvk
ix06xFCZq/pAbUZjzpP9sWsc6RvatoOKWBdqJCHlBsttMpW/pcAbXaxadaPopfND
Apcjoib/uJ+dD+IuWtgtdHBr48q8xBzqXcwO5e5nOWLzQ+mEpb1lExNhnIWOFiK4
ktibC9FkFqzlKYF8N0P5hxy9A24XVm5JLiftXgNUxbNUKp5qfjBOa8+iK67X0G7i
Kq7jrgdEjCwVQ4ofB6LPIKcdoJ1ExvmV95HzPJpr+MP60QlS27KAoqnA8FbAhQ3y
tkRiQW2WZKwTbM6M/Bmma8Rkfw4PkfUpR1CJzaMyJf+wquIkhxzjabjYONOr9PPr
ALdz/vLHcdJSHNkXvCBvwej2j+ffBP7OFc+W2Zh5CNiVL4Z2LgQj5Z0j4EJ95cQV
XI+Kqv7Kvtg4T+UP4s/2PhRnzoOq3lylhpEX9NhwiCA5wM+hmNcjYTMWRpWCQmhx
n4h0TRcnM6M3Lq3AtG8TIJFIKNIdjc9Tm05goPVtlMABfzqGbYiDz+JqSBIctjSM
M+JpFKDq691l6h/x5l74Xhk0npZBMYObsGJ2NK8DDfAWWkuLl5/uh3WGQhRBt1+P
ofq0/pI2NxQPNh1A9Jg4
=y6xL
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Apr_2014_13_41_31_+1000_uPAgZzBh9hvn1YGy--
