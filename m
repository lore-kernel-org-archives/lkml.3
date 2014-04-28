Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaD1G5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:57:38 -0400
Received: from ozlabs.org ([103.22.144.67]:47641 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaD1G5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:57:32 -0400
Date: Mon, 28 Apr 2014 16:57:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 28
Message-Id: <20140428165724.6361cf10ebd3067b7f998c0f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Apr_2014_16_57_24_+1000_QG2LrzZjUccbV3kA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Apr_2014_16_57_24_+1000_QG2LrzZjUccbV3kA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree still fails (more than usual) the powerpc allyesconfig build.

Changes since 20140424:

The mvebu tree gained a conflict against the arm tree.

The powerpc tree still had its build failure.

The libata tree lost its build failure.

The net-next tree gained conflicts against the net tree.

The wireless-next tree lost its build failure.

The mfd-lj tree still had its build failure so I used the version from
next-20140423.

The usb-gadget tree gained a conflict against the usb tree.

Non-merge commits (relative to Linus' tree): 3092
 2868 files changed, 105988 insertions(+), 71520 deletions(-)

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

I am currently merging 216 trees (counting Linus' and 29 trees of patches
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
Merging origin/master (ec6931b28179 word-at-a-time: avoid undefined behavio=
ur in zero_bytemask macro)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (a798c10faf62 Linux 3.15-rc2)
Merging arm-current/fixes (d93003e8e4e1 ARM: 8042/1: iwmmxt: allow to build=
 iWMMXt on Marvell PJ4B)
Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3=
.14-rc1)
Merging metag-fixes/fixes (a798c10faf62 Linux 3.15-rc2)
Merging powerpc-merge/merge (cc4f265ad9a3 powerpc/powernv Adapt opal-elog a=
nd opal-dump to new sysfs_remove_file_self)
Merging sparc/master (a798c10faf62 Linux 3.15-rc2)
Merging net/master (85350871317a sctp: reset flowi4_oif parameter on route =
lookup)
Merging ipsec/master (a32452366b72 vti4: Don't count header length twice.)
CONFLICT (content): Merge conflict in net/ipv4/ip_vti.c
Merging sound-current/for-linus (8dc9abb93dde ALSA: hda/realtek - Add heads=
et Mic support for Dell machine)
Merging pci-current/for-linus (f5d3352b2751 PCI: tegra: Use new OF interrup=
t mapping when possible)
Merging wireless/master (38f3106a9b98 Merge branch 'for-upstream' of git://=
git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth)
Merging driver-core.current/driver-core-linus (0c8c77d35582 s390/ccwgroup: =
Fix memory corruption)
Merging tty.current/tty-linus (7deb39ed8d94 serial_core: fix uart PORT_UNKN=
OWN handling)
Merging usb.current/usb-linus (34f972d6156f usb: option: add and update a n=
umber of CMOTech devices)
Merging usb-gadget-fixes/fixes (a31a942a148e usb: phy: am335x-control: wait=
 1ms after power-up transitions)
Merging staging.current/staging-linus (2704f807f949 staging: comedi: usbdux=
: bug fix for accessing 'ao_chanlist' in private data)
Merging char-misc.current/char-misc-linus (a798c10faf62 Linux 3.15-rc2)
Merging input-current/for-linus (c16134976fb2 Input: tca8418 - fix loading =
this driver as a module from a device tree)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (eb4a5346e777 hwrng: bcm2835 - fix oops when =
rng h/w is accessed during registration)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (9ec36cafe43b of/irq: do irq re=
solution in platform_get_irq)
Merging rr-fixes/fixes (132e9a68a579 Fix: tracing: use 'E' instead of 'X' f=
or unsigned module tain flag)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (b6842feb63a2 drm/i915: Allow =
user modes to exceed DVI 165MHz limit)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (134aeaed08c4 ARC: Fixed spelling errors within commen=
ts)
Merging arm/for-next (ffd8404ead02 Merge branches 'fixes', 'l2c' (early par=
t) and 'misc' into for-next)
Applying: ARM: outer cache: remove include of linux/bug.h from outercache.h
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (c9eaa447e77e Linux 3.15-rc1)
Merging arm-soc/for-next (1fc52762e33c Merge tag 'vexpress/fixes-for-3.15' =
of git://git.linaro.org/people/pawel.moll/linux into fixes)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (ca8965fd2af1 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (9f1f9455d84c Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (47fc77cc704e Merge branch 'for_3.15/fixes' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (2f9d157fdb43 Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/board-v7.c
Merging renesas/next (1dcb57aa37dc Merge branch 'heads/dt-for-v3.16' into n=
ext)
Merging samsung/for-next (3c27f314c676 ARM: S3C24XX: convert s3c2412 to com=
mon clock framework)
Merging tegra/for-next (628d56b42d35 Merge branch for-3.16/defconfig into f=
or-next)
Merging arm64/for-next/core (ebf81a938dad arm64: Fix DMA range invalidation=
 for cache line unaligned buffers)
Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
Merging m68knommu/for-next (2bf0787b4b42 m68k: fix a compiler warning when =
building for DragonBall)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (a66a626538af microblaze: Use asm-generic/io.h)
Merging mips/mips-for-linux-next (d061774ea0ba Merge branch '3.15-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (cd427485357c Merge remote-tracking branch 'scott/next=
' into next)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (164739eff3f9 s390/pci: add some new arch specific pc=
i attributes)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5eb0bdf84433 arch/tile: remove unused variable 'devcap=
')
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (cfe8255f0afc xtensa: xt2000: drop redundant sysmem=
 initialization)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache r=
eaddir)
Merging cifs/for-next (a87c9ad95667 cifs: fix actimeo=3D0 corner case when =
cifs_i->time =3D=3D jiffies)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (26f9c9ac0a11 ext4: add fallocate mode blocking for debugg=
ing purposes)
Merging f2fs/dev (5a7e8650be70 f2fs: return errors right after checking the=
m)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (f3846266f593 fuse: fix "uninitialized variable" warn=
ing)
Merging gfs2/master (991deec8193a GFS2: quotas not being refreshed in gfs2_=
adjust_quota)
Merging jfs/jfs-next (24e4a0f3de21 fs/jfs/jfs_inode.c: atomically set inode=
->i_flags)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (1f2edbe3fe21 NFS: Don't ignore suid/sgid bit change=
s after a successful write)
Merging nfsd/nfsd-next (06f9cc12caa8 nfsd4: don't create unnecessary mask a=
cl)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging ubifs/linux-next (d56030ac25d3 UBI: block: Remove __initdata from u=
biblock_param_ops)
Merging xfs/for-next (b8b39d39f94c Merge branch 'xfs-free-inode-btree' into=
 for-next)
Merging file-private-locks/linux-next (cff2fce58b2b locks: rename FL_FILE_P=
VT and IS_FILE_PVT to use "*_OFDLCK" instead)
Merging vfs/for-next (673b65614f0c kill generic_file_splice_write())
Merging pci/next (c9eaa447e77e Linux 3.15-rc1)
Merging hid/for-next (16a988700163 Merge branch 'for-3.16/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (9e897e13bd46 Merge branch 'for-linus' of git://gi=
t.open-osd.org/linux-open-osd)
Merging jdelvare-hwmon/master (c9eaa447e77e Linux 3.15-rc1)
Merging hwmon-staging/hwmon-next (e3df50654e7f hwmon: (lm92) Convert to use=
 devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (b40dfe97cc3a Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (42651ec91af5 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (49686b98a059 Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (d92a2dae7ecf Merge branch 'acpi-hotplug' into linux-=
next)
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (9477165ec525 thermal: rcar-thermal: update thermal zo=
ne only when temperature changes)
Merging ieee1394/for-next (0ca49345b6f4 firewire: ohci: fix probe failure w=
ith Agere/LSI controllers)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (406efb1a745c dmaengine: edma: No need save/restore =
interrupt flags during spin_lock in IRQ)
Merging dmaengine/next (b9bf6d2e84b7 dma: mv_xor: Flush descriptors before =
activating a channel)
Merging net-next/master (f71677502670 qlcnic: Use pci_enable_msix_exact() i=
nstead of pci_enable_msix())
CONFLICT (content): Merge conflict in net/netlink/af_netlink.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/altera/altera_sg=
dma.c
Merging ipsec-next/master (2e71029e2c32 xfrm: Remove useless xfrm_audit str=
uct.)
Merging wireless-next/master (bb0f8609ba9a Revert "mwifiex: add firmware du=
mp feature for PCIe")
Merging bluetooth/master (22e70786413e Bluetooth: Remove hci_h4 unused defi=
nes)
Merging infiniband/for-next (5ae2866f5264 Merge branches 'cxgb4', 'misc', '=
mlx5' and 'qib' into for-next)
Merging mtd/master (c9eaa447e77e Linux 3.15-rc1)
Merging l2-mtd/master (be54f8f1c768 mtd: mtd_oobtest: generate consistent d=
ata for verification)
Merging crypto/master (f51f593b3eb1 crypto: omap-des - handle error of pm_r=
untime_get_sync)
CONFLICT (rename/delete): drivers/crypto/bfin_crc.h deleted in HEAD and ren=
amed in crypto/master. Version crypto/master of drivers/crypto/bfin_crc.h l=
eft in tree.
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
Merging drm/drm-next (c39b06951f1d DRM: armada: fix corruption while loadin=
g cursors)
Merging drm-panel/drm/panel/for-next (810e49d8978f drm/panel: add support f=
or LG LD070WX3-SL01 panel)
Merging drm-intel/for-linux-next (b7c0d9df97c1 drm/i915: Integrate cmd pars=
er kerneldoc)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_context=
.c
Merging drm-tegra/drm/tegra/for-next (4b9701e02b3b drm/tegra: hdmi - Add Te=
gra124 support)
Merging sound/for-next (38137a064199 ALSA: lx_core: Translate comments from=
 french to english)
Merging sound-asoc/for-next (e6722e900535 Merge remote-tracking branches 'a=
soc/topic/rt5651', 'asoc/topic/samsung', 'asoc/topic/sgtl5000', 'asoc/topic=
/simple' and 'asoc/topic/sirf' into asoc-next)
Merging modules/modules-next (22c9bcad859d staging: fix up speakup kobject =
mode)
Merging virtio/virtio-next (fc4324b4597c virtio-blk: base queue-depth on vi=
rtqueue ringsize or module param)
Merging input/next (0aa21e226149 Input: gpio-beeper - simplify GPIO handlin=
g)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (7e6e4c2b4df8 Merge branch 'for-3.16/core' into for-=
next)
Merging device-mapper/for-next (ec052772958d Merge branch 'for-3.15' into f=
or-next)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (865042c01637 mmc: Add realtek USB sdmmc host driver)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (34bf6ef94a83 mm: slab/slub: use page->list consisten=
tly instead of page->lru)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (e2f23b606b94 md: avoid oops on unload if some process =
is in poll or select.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (06ed83a1566a mfd: sec-core: Remove duplicated =
device type from sec_pmic_dev)
$ git reset --hard HEAD^
Merging next-20140423 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (a798c10faf62 Linux 3.15-rc2)
Merging regulator/for-next (979b29716454 Merge remote-tracking branches 're=
gulator/topic/arizona', 'regulator/topic/axp20', 'regulator/topic/of', 'reg=
ulator/topic/pbias', 'regulator/topic/s2mps11', 'regulator/topic/s5m8767' a=
nd 'regulator/topic/tps65217' into regulator-next)
Merging security/next (fab71a90edda security: Convert use of typedef ctl_ta=
ble to struct ctl_table)
Merging selinux/next (6d32c850621b Merge tag 'v3.14' into next)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (9a60ee117bbe Merge tag 'hwmon-for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging)
Merging iommu/next (57c343bad18f Merge branches 'iommu/fixes' and 'arm/omap=
' into next)
Merging dwmw2-iommu/master (5ae0566a0fff iommu/vt-d: fix bug in matching PC=
I devices with DRHD/RMRR descriptors)
Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
Merging osd/linux-next (f1f6630b53e7 MAINTAINERS: Update email address for =
bhalevy)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (c800bcd5f53f sparse: fix comment)
Merging audit/master (35d0c383e526 sparc: implement is_32bit_task)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (d88cf7d7b424 Merge remote-tracking bran=
ch 'robh/for-next' into devicetree/next)
Merging dt-rh/for-next (e7a62df8e8b4 of: Clean up of_update_property)
Merging spi/for-next (198ddbe8dc3b Merge remote-tracking branches 'spi/topi=
c/pxa2xx', 'spi/topic/s3c24xx', 'spi/topic/sirf' and 'spi/topic/workqueue' =
into spi-next)
Merging tip/auto-latest (c3d94576af33 Merge branch 'x86/uv')
Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct:=
 silence a static checker warning)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (c045ebdf6079 Merge branch 'edac-for-3.15' into f=
or-next)
Merging ftrace/for-next (ad1438a076e2 tracing: Add static to local function=
s)
Merging rcu/rcu/next (27397ab69d38 rcu: Variable name changed in tree_plugi=
n.h and used in tree.c)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (198c74f43f0f KVM: MMU: flush tlb out of mmu lock wh=
en write-protect the sptes)
Merging kvm-arm/next (198c74f43f0f KVM: MMU: flush tlb out of mmu lock when=
 write-protect the sptes)
Merging kvm-ppc/kvm-ppc-next (0f689a33ad17 Merge branch 'for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/s390/linux)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (0a25e113b480 Merge branch 'devel/for-linus-3.15=
' into linux-next)
Merging percpu/for-next (4abee313c9a8 Merge branch 'for-3.16' into for-next)
Merging workqueues/for-next (534a3fbb3f37 workqueue: simplify wq_update_unb=
ound_numa() by jumping to use_dfl_pwq if the target cpumask equals wq's)
Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scen=
arios where memory allocations would fail)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (f624c7e5486b Merge remote-tracking branches 'regma=
p/topic/le', 'regmap/topic/mmio', 'regmap/topic/rbtree' and 'regmap/topic/s=
mbus' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (c73bcf7cca71 leds: 88pm860x: Fix missing refcount de=
crement for parent of_node)
Merging driver-core/driver-core-next (86d56134f1b6 kobject: Make support fo=
r uevent_helper optional.)
Merging tty/tty-next (d952795d8193 serial: sc16is7xx: fix implicit decl of =
func copy_{to,from}_user)
Merging usb/usb-next (d5dbd3f7d822 usb: dwc2: fix sparse warning)
Merging usb-gadget/next (041832565e40 usb: phy: mv-u3d: switch over to writ=
el/readl)
CONFLICT (modify/delete): drivers/usb/phy/phy-mv-u3d-usb.c deleted in HEAD =
and modified in usb-gadget/next. Version usb-gadget/next of drivers/usb/phy=
/phy-mv-u3d-usb.c left in tree.
$ git rm -f drivers/usb/phy/phy-mv-u3d-usb.c
Merging staging/staging-next (1da4f83c0c43 staging/lustre/llite: Fix a comp=
ile warning.)
Merging char-misc/char-misc-next (a798c10faf62 Linux 3.15-rc2)
Merging cgroup/for-next (9f30813bbca6 Merge branch 'for-3.16' into for-next)
Merging scsi/for-next (1a2184c0d747 [SCSI] More USB deadlock fixes)
Merging target-updates/for-next (b076808051f2 ib_srpt: Use correct ib_sg_dm=
a primitives)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (d1b2402c203b Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (b8c3f94437ad Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (59f0f119e85c arm: dma-mapping: Fix ma=
pping size value)
Merging pwm/for-next (2ae69a460413 pwm: pxa: Constify OF match table)
Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of=
 BSD accounting files)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (31c2c4b8e911 clk: bcm281xx: don't use unnamed structs=
 or unions)
Merging random/dev (7b878d4b48c4 random: Add arch_has_random[_seed]())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (d52a8f9ead60 fs/aio.c: Remove ctx parameter in kiocb_ca=
ncel)
Merging llvmlinux/for-next (752ac52c381b unwind_support)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (c9e7f4124daa The sum at the beginning of line "intr=
" includes also unnumbered interrupts. It implies that the sum at the begin=
ning isn't the sum of the remainder of the line, not even an estimation.)
Merging akpm-current/current (8429721cf61b sysrq,rcu: suppress RCU stall wa=
rnings while sysrq runs)
CONFLICT (content): Merge conflict in arch/x86/kernel/apic/hw_nmi.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: mm/page_io.c: work around gcc bug
Applying: arm: convert use of typedef ctl_table to struct ctl_table
Applying: ia64: convert use of typedef ctl_table to struct ctl_table
Applying: tile: convert use of typedef ctl_table to struct ctl_table
Applying: cdrom: convert use of typedef ctl_table to struct ctl_table
Applying: random: convert use of typedef ctl_table to struct ctl_table
Applying: parport: convert use of typedef ctl_table to struct ctl_table
Applying: scsi: convert use of typedef ctl_table to struct ctl_table
Applying: coda: convert use of typedef ctl_table to struct ctl_table
Applying: fscache: convert use of typedef ctl_table to struct ctl_table
Applying: lockd: convert use of typedef ctl_table to struct ctl_table
Applying: nfs: convert use of typedef ctl_table to struct ctl_table
Applying: inotify: convert use of typedef ctl_table to struct ctl_table
Applying: ntfs: convert use of typedef ctl_table to struct ctl_table
Applying: fs: convert use of typedef ctl_table to struct ctl_table
Applying: key: convert use of typedef ctl_table to struct ctl_table
Applying: ipc: convert use of typedef ctl_table to struct ctl_table
Applying: sysctl: convert use of typedef ctl_table to struct ctl_table
Applying: mm: convert use of typedef ctl_table to struct ctl_table
Applying: mfd/rtc: s5m: do not allocate RTC I2C dummy and regmap for unsupp=
orted chipsets
Applying: mfd/rtc: sec/s5m: rename SEC* symbols to S5M
Applying: rtc: s5m: remove undocumented time init on first boot
Applying: rtc: s5m: use shorter time of register update
Applying: rtc: s5m: support different register layout
Applying: rtc: s5m: add support for S2MPS14 RTC
Applying: rtc: s5m: consolidate two device type switch statements
Applying: blackfin/ptrace: call find_vma with the mmap_sem held
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: ufs: sb mutex merge + mutex_destroy
Applying: mm: add strictlimit knob
Merging akpm/master (bbf568860f01 mm: add strictlimit knob)

--Signature=_Mon__28_Apr_2014_16_57_24_+1000_QG2LrzZjUccbV3kA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTXfvaAAoJEMDTa8Ir7ZwVJAcP/1AUypWGQCKCjI8axDqYGKR4
aMpgCVxHMuz8e7Jyo0Ge/giLt9AYBWhT+DKRIoEjJx3YoB+It3yoIK8svr4Byop6
1WVaICpa9LjAPYkMgv7a3OAko8uA/OY9DePC5SUfvP4arN24DdD8EUt+yXXavzd+
r42FqgC0sRlDk8b1LrQmcZP/j7pg9WZ1K5ZAm0US8EaRnTtDaZScSVQmAWxNX1QI
ZIo1IyN0U3gJGLjOPq2BncRG+YWRqpAlCbUS0PDWfWoT9WDCLUf4oD5QQfQSuAuX
en6xFcC3pPjDDt8654AIH0DsP4foezxFeVIy7InTojjBnROuilMO+Z9Qv5gpZsgM
wI3uRcwjeudEH21T6XcN2OSumv5nLC+kG0aS127uEDcq4DLuJPmTf5MYVVMuWKPg
bKpzEMQNwrW/LJ016gXb+yVuQUICpT5ra8+F6LH58MmCxahJfpSfINCoYZwl5WXN
5XUSeRBplEMxc3NC/bN9I+AiDwT0tHsqLZ+NINUVlnRLLc76AfIoRp7Hj2WjWAxt
qK58JZ8e+hduBxtD3chLBONQl9+8GrVRxsn8J/b9kVEeoM1rywJL1NF1pLuLXXwC
WeuMVuxR3qdLAv7lm44gqHLEe4FCaDtKINEbAqmbYONm31rtbcqgKMEclU7eZJWn
HDlLuNgkEJagjn3hN+Af
=2sB2
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Apr_2014_16_57_24_+1000_QG2LrzZjUccbV3kA--
