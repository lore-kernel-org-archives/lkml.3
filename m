Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaDCFCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 01:02:25 -0400
Received: from ozlabs.org ([203.10.76.45]:41740 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaDCFCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 01:02:21 -0400
Date: Thu, 3 Apr 2014 16:02:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 3
Message-Id: <20140403160211.3f21430dbedcd2c1514a5126@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Apr_2014_16_02_11_+1100_ehZWeeXlzPRrn0Lg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Apr_2014_16_02_11_+1100_ehZWeeXlzPRrn0Lg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add material intended for v3.16 to your linux-next included
branches until after v3.15-rc1 is released.

This tree still fails (more than usual) the powerpc allyesconfig build.

Changes since 20140402:

The powerpc tree still had its build failure.

The drm-intel tree gained a conflict against the drm tree and a build
failure for which I applied a merge fix patch.

Non-merge commits (relative to Linus' tree): 6953
 5823 files changed, 295072 insertions(+), 116620 deletions(-)

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

I am currently merging 214 trees (counting Linus' and 28 trees of patches
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
Merging origin/master (7cbb39d4d4d5 Merge tag 'kvm-3.15-1' of git://git.ker=
nel.org/pub/scm/virt/kvm/kvm)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (6041003a8fec ARC: Remove unused DT template f=
ile)
Merging arm-current/fixes (95c52fe06335 ARM: 8007/1: Remove extraneous kcmp=
 syscall ignore)
Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3=
.14-rc1)
Merging metag-fixes/fixes (0414855fdc4a Linux 3.14-rc5)
Merging powerpc-merge/merge (ece980ff6de6 powerpc/book3s: Fix CFAR clobberi=
ng issue in machine check handler.)
Merging sparc/master (455c6fdbd219 Linux 3.14)
Merging net/master (17e84a925346 at86rf230: mask irq's before deregister de=
vice)
Merging ipsec/master (3e3d35402140 ATHEROS-ATL1E: Convert iounmap to pci_io=
unmap)
Merging sound-current/for-linus (69dd89fd2b94 Merge tag 'asoc-v3.15-4' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
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
Merging staging.current/staging-linus (b33ce4429938 Merge branch 'for-3.15/=
drivers' of git://git.kernel.dk/linux-block)
Merging char-misc.current/char-misc-linus (b33ce4429938 Merge branch 'for-3=
.15/drivers' of git://git.kernel.dk/linux-block)
Merging input-current/for-linus (e4dbedc7eac7 Input: mousedev - fix race wh=
en creating mixed device)
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
Merging arm/for-next (54740e1ee0fe Merge branch 'devel-stable' into for-nex=
t)
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (6d0abeca3242 Linux 3.14-rc3)
Merging arm-soc/for-next (e98cd7220a1b arm-soc: document samsung merges)
CONFLICT (content): Merge conflict in sound/soc/kirkwood/Kconfig
CONFLICT (content): Merge conflict in include/asm-generic/vmlinux.lds.h
CONFLICT (content): Merge conflict in drivers/watchdog/orion_wdt.c
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
CONFLICT (content): Merge conflict in drivers/phy/Kconfig
CONFLICT (content): Merge conflict in drivers/clocksource/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
CONFLICT (modify/delete): arch/arm/mach-imx/pm-imx6q.c deleted in arm-soc/f=
or-next and modified in HEAD. Version HEAD of arch/arm/mach-imx/pm-imx6q.c =
left in tree.
CONFLICT (content): Merge conflict in arch/arm/boot/dts/sun7i-a20.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/keystone-clocks.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/imx53-qsb.dts
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/phy=
/samsung-phy.txt
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/iio=
/adc/at91_adc.txt
$ git rm -f arch/arm/mach-imx/pm-imx6q.c
Applying: arm: Replace various irq_desc accesses fix for file move
Applying: ARM: dts: i.MX53: merge fix patch
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (faa51ae59b9a Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (47fc77cc704e Merge branch 'for_3.15/fixes' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (97623e934388 Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging renesas/next (68d1f3aad83a Merge branch 'heads/clock-for-v3.15' int=
o next)
Merging samsung/for-next (82cd4473bde8 Merge branch 'v3.15-next/cleanup-exy=
nos' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/exynos.c
Merging tegra/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging arm64/for-next/core (196adf2f3015 arm64: Remove pgprot_dmacoherent(=
))
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
Merging m68knommu/for-next (4dc5aa217237 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (cff2ee046e06 microblaze: Wire-up new system calls =
sched_setattr/getattr)
Merging mips/mips-for-linux-next (e6d9bfc63813 Merge branch 'powernv-cpuidl=
e' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (84021f14762a parisc: Replace __get_cpu_var uses=
 for address calculation)
Merging powerpc/next (cd427485357c Merge remote-tracking branch 'scott/next=
' into next)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (9f0128f9e7bf s390/sclp: add timeout for queued reque=
sts)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (620830b69549 perf tools: Allow building for tile)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (b3fdfc1b4b64 Merge tag 'xtensa-for-next-20140221-1=
' into for_next)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (bee26897097f libceph: a per-osdc crush scratch buffer)
Merging cifs/for-next (04807bc81e39 Return correct error on query of xattr =
on file with empty xattrs)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (ad6599ab3ac9 ext4: fix premature freeing of partial clust=
ers split across leaf blocks)
CONFLICT (content): Merge conflict in fs/ext4/inode.c
Merging f2fs/dev (ce23447fe576 f2fs: fix to cover io->bio with io_rwsem)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (f3846266f593 fuse: fix "uninitialized variable" warn=
ing)
Merging gfs2/master (1b2ad41214c9 GFS2: Fix address space from page functio=
n)
Merging jfs/jfs-next (844fa1b5f849 jfs: set i_ctime when setting ACL)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (e911b8158ee1 NFSv4: Fix a use-after-free problem in=
 open())
Merging nfsd/nfsd-next (18df11d0eacf nfsd4: fix memory leak in nfsd4_encode=
_fattr())
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (8a5daf1e2c19 9pnet_rdma: check token type before int=
 conversion)
Merging ubifs/linux-next (d56030ac25d3 UBI: block: Remove __initdata from u=
biblock_param_ops)
Merging xfs/for-next (fe986f9d88ab Merge branch 'xfs-O_TMPFILE-support' int=
o for-next)
Merging file-private-locks/linux-next (08ab986a0c6d locks: make locks_manda=
tory_area check for file-private locks)
CONFLICT (content): Merge conflict in fs/compat.c
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (30723cbf6f7a Merge branch 'pci/resource' into next)
Merging hid/for-next (d1443c96d663 Merge branch 'for-3.15/sony' into for-ne=
xt)
CONFLICT (content): Merge conflict in drivers/hid/i2c-hid/i2c-hid.c
CONFLICT (content): Merge conflict in drivers/hid/hid-sony.c
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
Merging i2c/i2c/for-next (3428f018e610 i2c: efm32: fix binding doc)
Merging jdelvare-hwmon/master (a1261382eab0 hwmon: (it87) Add support for I=
T8623E)
Merging hwmon-staging/hwmon-next (f76992b00a41 hwmon: (pmbus/ltc2978) Add s=
upport for LTM4676)
Merging v4l-dvb/master (83701d7a7094 Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in drivers/staging/media/msi3101/sdr-msi=
3101.c
CONFLICT (content): Merge conflict in drivers/media/v4l2-core/v4l2-of.c
CONFLICT (content): Merge conflict in drivers/media/platform/exynos4-is/fim=
c-is.c
Merging kbuild/for-next (23c88a23ace8 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (27aa64b9d1bd pata_at91: fix ata_host_activate() fa=
ilure handling)
Merging pm/linux-next (2f28ecfc46ed Merge branch 'cpu-hotplug' into linux-n=
ext)
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/perf_event_intel_=
uncore.c
Merging idle/next (62eec04c7fa3 Merge branch 'turbostat' into release)
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
Merging slave-dma/next (b4dedf0b120c Merge branch 'for-linus' into next)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (b1586f099ba8 netpoll: Use skb_irq_freeable to make=
 zap_completion_queue safe.)
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/cfg80211.c
CONFLICT (content): Merge conflict in drivers/staging/wlags49_h2/wl_netdev.c
CONFLICT (content): Merge conflict in drivers/of/of_net.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/net=
/stmmac.txt
Merging ipsec-next/master (3ab428a4c5ad netfilter: Add missing vmalloc.h in=
clude to nft_hash.c)
Merging wireless-next/master (a31267c30880 rtl8187: fix use after free on f=
ailure path in rtl8187_probe())
Merging bluetooth/master (5c5b93e4be2f Bluetooth: Fix address in unmergeabl=
e device found events)
Merging infiniband/for-next (38eb1cb6631c Merge branches 'core', 'cxgb4', '=
ip-roce', 'iser', 'misc', 'mlx4', 'nes', 'ocrdma', 'qib', 'sgwrapper', 'srp=
' and 'usnic' into for-next)
Merging mtd/master (fa389e220254 Linux 3.14-rc6)
Merging l2-mtd/master (86e4bbc766b9 mtd: diskonchip: mem resource name is n=
ot optional)
Merging crypto/master (37b28947170e crypto: x86/sha1 - reduce size of the A=
VX2 asm implementation)
Merging drm/drm-next (2844ea3f2523 Merge branch 'primary-plane' of git://pe=
ople.freedesktop.org/~robclark/linux into drm-next)
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/parallel-disp=
lay.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-tve.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-ldb.c
CONFLICT (content): Merge conflict in drivers/staging/imx-drm/imx-hdmi.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ddi.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_gtt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/gma500/mmu.c
Merging drm-intel/for-linux-next (c8431fda9f9f drm/i915: don't get/put runt=
ime PM at the debugfs forcewake file)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_ddi.c
Applying: drm: fix for "Replace crtc fb with primary plane fb"
Merging drm-tegra/drm/for-next (c1a68b4c29b8 drm/tegra: Add eDP support)
Merging sound/for-next (a4b7f21d7b42 ALSA: hda - Enable beep for ASUS 1015E)
Merging sound-asoc/for-next (0569d7b48119 Merge remote-tracking branches 'a=
soc/fix/rt5640' and 'asoc/fix/tlv320aic23' into asoc-linus)
Merging modules/modules-next (22c9bcad859d staging: fix up speakup kobject =
mode)
Merging virtio/virtio-next (fc4324b4597c virtio-blk: base queue-depth on vi=
rtqueue ringsize or module param)
Merging input/next (7bbdba56ba9e Input: appletouch - fix jumps when additio=
nal fingers are detected)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (3cffe7d19b82 Merge branch 'for-3.15/drivers' into f=
or-next)
Merging device-mapper/for-next (f3b2858a9406 dm crypt: sort writes)
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
CONFLICT (content): Merge conflict in drivers/video/fbdev/exynos/Kconfig
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
Merging regulator/for-next (5481b348e80f Merge remote-tracking branches 're=
gulator/topic/tps65218', 'regulator/topic/tps6524x', 'regulator/topic/tps65=
86x', 'regulator/topic/tps65910', 'regulator/topic/tps80031', 'regulator/to=
pic/wm831x', 'regulator/topic/wm8350' and 'regulator/topic/wm8994' into reg=
ulator-next)
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
Merging osd/linux-next (dfd847bf8c37 MAINTAINERS: Update email address for =
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
Merging spi/for-next (098a6fedd186 Merge remote-tracking branches 'spi/fix/=
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
Merging kvm/linux-next (7227fc066660 Merge branch 'kvm-ppchv-next' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-next)
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (7227fc066660 Merge branch 'kvm-ppchv-next' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc into kvm-next)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (0a25e113b480 Merge branch 'devel/for-linus-3.15=
' into linux-next)
CONFLICT (content): Merge conflict in drivers/xen/events/events_base.c
Merging percpu/for-next (21ddfd38ee9a percpu: renew the max_contig if we me=
rge the head and previous block)
Merging workqueues/for-next (c4b75dadde82 Merge branch 'for-3.15' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (e32719017210 regmap/fix/block)
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
Merging staging/staging-next (b33ce4429938 Merge branch 'for-3.15/drivers' =
of git://git.kernel.dk/linux-block)
Merging char-misc/char-misc-next (b33ce4429938 Merge branch 'for-3.15/drive=
rs' of git://git.kernel.dk/linux-block)
Merging cgroup/for-next (af276c2c356c Merge branch 'for-3.15' into for-next)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Applying: cgroup: fix up for kernfs_mount API change
Merging scsi/for-next (b2bff6ceb61a [SCSI] sd: Quiesce mode sense error mes=
sages)
Merging target-updates/for-next (0b1764770437 Target/sbc: Initialize COMPAR=
E_AND_WRITE write_sg scatterlist)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (43f23a0660fa pinctrl: tegra: add some missing Teg=
ra114 entries)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (b22978fc33de gpio: rcar: Add helper variable dev =3D=
 &pdev->dev)
CONFLICT (content): Merge conflict in drivers/gpio/gpio-ich.c
Merging dma-mapping/dma-mapping-next (68efd7d2fb32 arm: dma-mapping: remove=
 order parameter from arm_iommu_create_mapping())
Merging pwm/for-next (2ae69a460413 pwm: pxa: Constify OF match table)
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/Kconfig
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging userns/for-next (d211f177b28e audit: Update kdoc for audit_send_rep=
ly and audit_list_rules_send)
Merging ktest/for-next (62183dcac539 ktest: Set CLOSE_CONSOLE_SIGNAL in the=
 kvm.conf)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (e44df332f30b clk: shmobile: fix setting paretn clock =
rate)
Merging random/dev (91a60dc7aa88 random: Add arch_has_random[_seed]())
CONFLICT (content): Merge conflict in arch/x86/include/asm/archrandom.h
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
Merging compat/compat (1e4ec6217dcf s390/compat: add copyright statement)
Merging rd-docs/master (7cbb39d4d4d5 Merge tag 'kvm-3.15-1' of git://git.ke=
rnel.org/pub/scm/virt/kvm/kvm)
Merging akpm-current/current (f684c6995922 ipc: use device_initcall)
CONFLICT (content): Merge conflict in fs/fs-writeback.c
$ git am -3 ../patches/0001-Revert-vmstat-use-raw_cpu_ops-to-avoid-false-po=
sitiv.patch
Applying: Revert "vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemp=
tion-checks-fix"
$ git am -3 ../patches/0002-Revert-vmstat-use-raw_cpu_ops-to-avoid-false-po=
sitiv.patch
Applying: Revert "vmstat: use raw_cpu_ops to avoid false positives on preem=
ption checks"
Applying: ocfs2: VERIFY_OCTAL_PERMISSIONS fix up
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: Kconfig: rename HAS_IOPORT to HAS_IOPORT_MAP
Applying: kernel: use macros from compiler.h instead of __attribute__((...))
Applying: asm/system.h: clean asm/system.h from docs
Applying: asm/system.h: um: arch_align_stack() moved to asm/exec.h
Applying: memcg, slab: never try to merge memcg caches
Applying: memcg, slab: cleanup memcg cache creation
Applying: memcg, slab: separate memcg vs root cache creation paths
Applying: memcg, slab: unregister cache from memcg before starting to destr=
oy it
Applying: memcg, slab: do not destroy children caches if parent has aliases
Applying: slub: adjust memcg caches when creating cache alias
Applying: slub: rework sysfs layout for memcg caches
Applying: slub: fix leak of 'name' in sysfs_slab_add
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: percpu: add raw_cpu_ops
Applying: mm: use raw_cpu ops for determining current NUMA node
Applying: modules: use raw_cpu_write for initialization of per cpu refcount.
Applying: net: replace __this_cpu_inc in route.c with raw_cpu_inc
Applying: slub: use raw_cpu_inc for incrementing statistics
Applying: slub-use-raw_cpu_inc-for-incrementing-statistics-fix
Applying: percpu: add preemption checks to __this_cpu ops
Applying: preemption_checks: avoid snprintf before checking error conditions
Applying: percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fix=
es
Applying: lglock: map to spinlock when !CONFIG_SMP
Applying: x86/mm: sparse warning fix for early_memremap
Applying: mm: create generic early_ioremap() support
Applying: x86: use generic early_ioremap
Applying: arm64: initialize pgprot info earlier in boot
Applying: arm64: add early_ioremap support
Applying: doc/kernel-parameters.txt: add early_ioremap_debug
Applying: fs/ufs/super.c: add __init to init_inodecache()
Applying: fs/ufs: remove unused ufs_super_block_first pointer
Applying: fs/ufs: remove unused ufs_super_block_second pointer
Applying: fs/ufs: remove unused ufs_super_block_third pointer
Applying: ufs: sb mutex merge + mutex_destroy
Applying: mm: add strictlimit knob
Merging akpm/master (c6294af3fa2f mm: add strictlimit knob)
Applying: vmstat: use raw_cpu_ops to avoid false positives on preemption ch=
ecks
Applying: vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-che=
cks-fix

--Signature=_Thu__3_Apr_2014_16_02_11_+1100_ehZWeeXlzPRrn0Lg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTPOtYAAoJEMDTa8Ir7ZwVGVsP/RbcUPUaE45jvetGPJwvEVGO
MLjNwNetXZL8cBVkXN6bCKN8r5g3hyg37jD7WwY3frSWqIOzaj/v8ojEQbJPpEAs
YHVzLsiXnGNBoRibenMLdD7T8zv75O4WFj68q1vesRNn3wmWdmp/KtNYxyIRqszU
E0W4DNGTapNTUDuj7z6OfAiawsKWSQzewlPNM+DAYBd2q0eiIHRaeWg2BHtIF3yy
fuLX9LfFTjzcowL/CW8goGmComprc1S9JQpWK0xRFeJhbVPX02gsewb5MSCA1bha
lT4rbGI5L5fjJj4lQZKDcNcnD7cajPxk7yWZv98NNwa89W+hdrvp8q2AhRofT1T1
s7OpUKeRsSl5qs21cu78xu3Y7MhxcRpFQ/hc4a19bCN+n+L1go7kY7Y50nNdtkjk
93+7+hCI1OWYPXFf884bJv/qF9TIrqSh7D/6SJQjcreL6mZc07ANOpfmVXrinBLc
gqAIzaplGAMAJYQbr8KGtFkUFW6LAaMhkNz1Z/rI8XPL4CRTGfYUnC4JYZuM7zMC
sJbx41ao/a7ygOZLFr0hv+OoLxmMq6pYYU8CPDKtcABMIkzLmu530h7d7gq/gb4k
/cMHE1cUXA/2K0zid8c0ieZVjmQ2ToAFB0Wm+mKBPUHUAciE4ThdE3xiJ9wq72jv
8XRYZs4rf1wMdXRMfwM8
=EMal
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Apr_2014_16_02_11_+1100_ehZWeeXlzPRrn0Lg--
