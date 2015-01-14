Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbbANGR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:17:57 -0500
Received: from ozlabs.org ([103.22.144.67]:33173 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbbANGRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:17:53 -0500
Date: Wed, 14 Jan 2015 17:17:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jan 14
Message-ID: <20150114171738.6e001279@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//U2M9Hhtm.VnYc6pvpTiriH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//U2M9Hhtm.VnYc6pvpTiriH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20150113:

*crickets*

Non-merge commits (relative to Linus' tree): 2846
 2773 files changed, 85954 insertions(+), 47224 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" and checkout or reset to the new
master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 234 trees (counting Linus' and 32 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (e7a823be2adc Merge tag 'linux-kselftest-3.19-rc-5' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (a16c5f99a28c kbuild: Fix removal of the de=
bian/ directory)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (1e3479225acb ARM: 8275/1: mm: fix PMD_SECT_RDONL=
Y undeclared compile error)
Merging m68k-current/for-linus (f27bd5bfeda5 m68k: Wire up execveat)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (a87e810f61b4 powerpc: Work around gcc bug =
in current_thread_info())
Merging sparc/master (66d0f7ec9f10 sparc32: destroy_context() and switch_mm=
() needs to disable interrupts.)
Merging net/master (900e183301b5 xen-netfront: use different locks for Rx a=
nd Tx stats)
Merging ipsec/master (f855691975bb xfrm6: Fix the nexthdr offset in _decode=
_session6.)
Merging sound-current/for-linus (92cb46584e10 ALSA: fireworks: fix an endia=
nness bug for transaction length)
Merging pci-current/for-linus (97bf6af1f928 Linux 3.19-rc1)
Merging wireless-drivers/master (81a07128214e Merge tag 'wireless-drivers-f=
or-davem-2015-01-09' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo=
/wireless-drivers)
Merging driver-core.current/driver-core-linus (72392ed0eb6f kernfs: Fix ker=
nfs_name_compare)
Merging tty.current/tty-linus (31ec77aca72e serial: samsung: Add the suppor=
t for Exynos5433 SoC)
Merging usb.current/usb-linus (06087cb42dc1 Merge tag 'fixes-for-v3.19-rc5'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging usb-gadget-fixes/fixes (bbe51d55c1af usb: dwc3: gadget: Stop TRB pr=
eparation after limit is reached)
Merging usb-serial-fixes/usb-linus (04f9c6e6d175 usb: serial: handle -ENODE=
V quietly in generic_submit_read_urb)
Merging staging.current/staging-linus (a307d1d6d4cf staging: vt6655: fix sp=
arse warning: argument type)
Merging char-misc.current/char-misc-linus (7b7c54914f73 mcb: mcb-pci: Only =
remap the 1st 0x200 bytes of BAR 0)
Merging input-current/for-linus (9333caeaeae4 Input: I8042 - add Acer Aspir=
e 7738 to the nomux list)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (3e14dcf7cb80 crypto: add missing crypto modu=
le aliases)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (094cb98179f1 of/fdt: memblock_=
reserve /memreserve/ regions in the case of partial overlap)
Merging rr-fixes/fixes (574732c73d15 param: initialize store function to NU=
LL if not available.)
Merging vfio-fixes/for-linus (7c2e211f3c95 vfio-pci: Fix the check on pci d=
evice type in vfio_pci_probe())
Merging kselftest-fixes/fixes (f5db310d77ef selftests/vm: fix link error fo=
r transhuge-stress test)
Merging drm-intel-fixes/for-linux-next-fixes (226e5ae9e5f9 drm/i915: Fix mu=
tex->owner inspection race under DEBUG_MUTEXES)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (5840adceb962 arc: Remove unused prepare_to_copy())
Merging arm/for-next (1e3479225acb ARM: 8275/1: mm: fix PMD_SECT_RDONLY und=
eclared compile error)
Merging arm-perf/for-next/perf (97bf6af1f928 Linux 3.19-rc1)
Merging arm-soc/for-next (5a915bc9801b ARM: SoC: Document merges)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (8553bf8fd181 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (e799b6f37e6c ARM: zImage: add support for ARMv7-=
M)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (bc8127e027df Merge branch 'imx/defconfig' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (82e1ad0bcd24 Merge branch 'mvebu/dt' into mvebu/for=
-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging omap/for-next (06e479e57be7 Merge branch 'omap-for-v3.20/dt' into f=
or-next)
Merging omap-pending/for-next (99d076b74745 MAINTAINERS: add maintainer for=
 OMAP hwmod data)
Merging renesas/next (233b2d521778 Merge branches 'heads/soc-fixes-for-v3.1=
9', 'heads/defconfig-for-v3.20', 'heads/dt-cleanups-for-v3.20', 'heads/sh-d=
rivers-for-v3.20', 'heads/lager-board-removal-for-v3.20', 'heads/sh73a0-mul=
tiplatform-for-v3.20' and 'heads/dt-cleanup-for-v3.20' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging samsung/for-next (4c00d1347cb1 Merge branch 'v3.20-next/update-sams=
ung' into for-next)
Merging sunxi/sunxi/for-next (ca735dafe21d Merge branches 'sunxi/dt-for-3.2=
0' and 'sunxi/core-for-3.20' into sunxi/for-next)
Merging tegra/for-next (4fd40ac71480 Merge branch for-3.20/soc into for-nex=
t)
Merging arm64/for-next/core (fb59d007a0e4 arm64: mm: dump: don't skip final=
 region)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (8914d7e85780 Hexagon: fix signal delivery for d=
ebug traps)
Merging ia64/next (0fd2468fd035 Merge branch 'misc-3.19' into next)
Merging m68k/for-next (e69229f2eb9d m68k/atari: Remove obsolete keyboard_ta=
sklet scheduling)
Merging m68knommu/for-next (8d84d4aaf311 arch: m68k: 68360: config: Remove =
unused function)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (132d5dfc0469 microblaze: whitespace fix)
Merging mips/mips-for-linux-next (767db1014d10 Merge branch '3.19-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (1b0f44923e18 nios2: Use preempt_schedule_irq)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (b2776bf7149b Linux 3.18)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (9a4fc4eaf111 powerpc/kvm: Create proper names for=
 the kvm_host_state PMU fields)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (d97d929f06d0 s390: move cacheinfo sysfs to generic c=
acheinfo infrastructure)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (557e90b9fcb7 tile: enable sparse checks for get/put_us=
er)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (1f2fdbd0078c xtensa: disable link optimization)
Merging btrfs/next (1edb647bb954 Btrfs: remove non-sense btrfs_error_discar=
d_extent() function)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
CONFLICT (content): Merge conflict in net/ceph/auth_x.c
CONFLICT (content): Merge conflict in fs/ceph/super.h
CONFLICT (content): Merge conflict in fs/ceph/super.c
CONFLICT (content): Merge conflict in fs/ceph/snap.c
Merging cifs/for-next (cac8894b8ed7 cifs: use memzero_explicit to clear sta=
ck buffer)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (942080643bce eCryptfs: Remove buggy and unnecessary =
write in file name decode routine)
Merging ext3/for_next (bbe48dd81147 udf: destroy sbi mutex in put_super)
Merging ext4/dev (4033d19d28ab ext4: add optimization for the lazytime moun=
t option)
Merging f2fs/dev (ebb0d36e21a0 f2fs: pids_lock can be static)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (9759bd518994 fuse: add memory barrier to INIT)
Merging gfs2/master (3566c9647678 GFS2: fix sprintf format specifier)
Merging jfs/jfs-next (e1f1fe798d2f jfs: get rid of homegrown endianness hel=
pers)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (4e379d36c050 NFSv4: Remove incorrect check in can_o=
pen_delegated())
Merging nfsd/nfsd-next (0ec016e3e02f nfsd4: tweak rd_dircount accounting)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (4330397e4e8a ovl: discard independent cur=
sor in readdir())
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (ad7df6e858ef Merge branch 'xfs-sb-logging-rework' int=
o for-next)
Merging file-locks/linux-next (01a41d8dcc4e locks: keep a count of locks on=
 the flctx lists)
Merging vfs/for-next (88174fd2c8fb kill d_validate())
Merging pci/next (75f30c3d9949 Merge branches 'pci/host-keystone', 'pci/hos=
t-layerscape', 'pci/host-rcar' and 'pci/host-tegra' into next)
Merging hid/for-next (88cbbe74e88b Merge branch 'for-3.20/wacom' into for-n=
ext)
Merging i2c/i2c/for-next (523c5b89640e i2c: Remove support for legacy PM)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (e4dcddb1b78c hwmon: (ina2xx) use DIV_ROUN=
D_CLOSEST() to avoid rounding errors)
Merging v4l-dvb/master (2ea3258b238c Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (5ea04a1a0860 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (8ce20e750623 Merge branch 'for-3.19-fixes' into fo=
r-next)
Merging pm/linux-next (794c3a0a9380 Merge branches 'acpi-pm', 'acpi-process=
or' and 'acpi-video')
Merging idle/next (f7c0e22f2d14 Merge branch 'turbostat' into release)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (783f0e5a024e Merge branches 'for-rc', 'int340x-enhanc=
ement' and 'int3406-thermal' of .git into next)
Merging thermal-soc/next (1813d8087469 thermal: rcar: Spelling/grammar: s/d=
rier use .../driver uses ...s/)
Merging ieee1394/for-next (d737d7da8e7e firewire: sbp2: replace card lock b=
y target lock)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (1d49160e0f0f Merge branch 'topic/slave_caps_device_=
control_fix_rebased' into next)
Merging net-next/master (357c4774b5b0 tipc: correctly handle releasing a no=
t fully initialized sock)
Merging ipsec-next/master (78890ed75494 csiostor:fix sparse warnings)
Merging wireless-drivers-next/master (350b193ebd50 Merge ath-next from ath.=
git)
Merging bluetooth/master (a93661203641 Bluetooth: Process result of HCI Del=
ete Stored Link Key command)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (7c272ac5eefb mtd: denali: fix incorrect bitmask erro=
r in denali_setup_dma)
Merging crypto/master (d8219f52a720 crypto: x86/des3_ede - drop bogus modul=
e aliases)
Merging drm/drm-next (426959c94553 drm: fix mismerge in drm_crtc.c)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_runtime_pm=
.c
Merging drm-panel/drm/panel/for-next (54cbc4e298ea drm/mipi-dsi: Avoid pote=
ntial NULL pointer dereference)
Merging drm-intel/for-linux-next (cd52471999ef drm/i915: Fix kerneldoc for =
i915 atomic plane code)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (c439f38ae1c5 drm: Make drm_read() more r=
obust against multithreaded races)
Merging sound/for-next (7b617289b699 ALSA: compress_driver.h: include sound=
/core.h explicitly)
Merging sound-asoc/for-next (41debc82537a Merge remote-tracking branch 'aso=
c/topic/xtfpga' into asoc-next)
Merging modules/modules-next (97bf6af1f928 Linux 3.19-rc1)
Merging virtio/virtio-next (97bf6af1f928 Linux 3.19-rc1)
Merging input/next (34412ba28232 Input: alps - add sanity checks for non Du=
alPoint devices)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (177ccd2f8f39 Merge branch 'for-3.20/drivers' into f=
or-next)
Merging device-mapper/for-next (6a55c9861326 block: keep established cmd_fl=
ags when cloning into a blk-mq request)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (d04524acfd9c Merge branch 'tmio' into next)
Merging kgdb/kgdb-next (c7d9ebf81c45 kdb: Fix off by one error in kdb_cpu())
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (f851b60db0fd md: Check MD_RECOVERY_RUNNING as well as =
->sync_thread.)
Merging mfd/for-mfd-next (a3b63979f8a3 mfd: rtsx: Add func to split u32 int=
o register)
Merging backlight/for-backlight-next (3d6969a641d0 MAINTAINERS: Remove my n=
ame from Backlight subsystem)
Merging battery/master (02088e3ed79f power: reset: augment versatile driver=
 for integrator)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (574d54112fda Merge branches '3.19/omapdss' and =
'3.19/simplefb' into for-next)
Merging regulator/for-next (2de4cd54a7a1 Merge remote-tracking branches 're=
gulator/topic/rk808', 'regulator/topic/rt5033' and 'regulator/topic/tps6502=
3' into regulator-next)
Merging security/next (b2d1965dcea1 Merge branch 'next' of git://git.infrad=
ead.org/users/pcmoore/selinux into next)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (135641d6567d selinux: quiet the filesystem labeling b=
ehavior message)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (e0c3e00f4045 watchdog: drop owner assignment from =
platform_drivers)
Merging iommu/next (2c0ee8b85aae iommu/rockchip: Drop owner assignment from=
 platform_drivers)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (174236285cf8 Merge branch 'doc/sp-update' into d=
ocs-next)
Merging trivial/for-next (231821d4c3fa dynamic_debug: fix comment)
Merging audit/next (0f7e94ee40d0 Merge branch 'next' into upstream for v3.1=
9)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (c46ca3c8310b of: Delete unnecessary che=
ck before calling "of_node_put()")
Merging dt-rh/for-next (e94fbe607f8c dt-bindings: use isil prefix for Inter=
sil in vendor-prefixes.txt)
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (52052f9b7ea1 Merge remote-tracking branches 'spi/topi=
c/pxa2xx', 'spi/topic/qup', 'spi/topic/sirf' and 'spi/topic/st-ssc' into sp=
i-next)
Merging tip/auto-latest (c1c82bd68fa5 Merge branch 'x86/platform')
Merging clockevents/clockevents/next (81428bbe1d8a clocksource: marco: Rena=
me marco to atlas7)
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (a4972b1b9a04 edac: i5100_edac: Remove unused i51=
00_recmema_dm_buf_id)
Merging irqchip/irqchip/for-next (91d117921216 irqchip: atmel-aic-common: P=
revent clobbering of priority when changing IRQ type)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (d716ff71dd12 tracing: Remove taking of trace_types=
_lock in pipe files)
Merging rcu/rcu/next (e4032e5c458e rcu_tree: Avoid touching rnp->completed =
when a new GP is started)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (bab5bb398273 kvm: x86: Remove kvm_make_request from=
 lapic.c)
Merging kvm-arm/next (bab5bb398273 kvm: x86: Remove kvm_make_request from l=
apic.c)
Merging kvm-ppc/kvm-ppc-next (2c4aa55a6af0 Merge tag 'signed-kvm-ppc-next' =
of git://github.com/agraf/linux-2.6 into HEAD)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
Merging percpu/for-next (4c907baf36d8 percpu_ref: implement percpu_ref_is_d=
ying())
Merging workqueues/for-next (9da7dae94fb8 workqueue.h: remove loops of sing=
le statement macros)
Merging drivers-x86/for-next (200db647112d platform/x86/acerhdf: Still depe=
nds on THERMAL)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (270ded427d7b Merge remote-tracking branch 'regmap/=
topic/core' into regmap-next)
Merging hsi/for-next (67e9a2ce6e07 hsi: nokia-modem: fix uninitialized devi=
ce pointer)
Merging leds/for-next (7f95adda052d leds: Use setup_timer)
Merging ipmi/for-next (1421c935df15 ipmi: Fix compile warning with tv_usec)
Merging driver-core/driver-core-next (b7392d2247cf Linux 3.19-rc2)
Merging tty/tty-next (4c215fe8e288 vt: fix locking around vt_bind/vt_unbind)
Merging usb/usb-next (1d97869198a3 usb: host: drop owner assignment from pl=
atform_drivers)
Merging usb-gadget/next (487d60cc0923 usb: gadget: mv_udc_core: delete pull=
up operation at .udc_start)
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/bdc/bdc_ep.c
CONFLICT (content): Merge conflict in drivers/usb/dwc2/gadget.c
Merging usb-serial/usb-next (b7392d2247cf Linux 3.19-rc2)
Merging staging/staging-next (29d586247d21 staging: unisys: fix checkpatch =
space prohibited before comma errors)
Merging char-misc/char-misc-next (d885d4f3728f pcmcia: add missing include =
for new pci resource handler)
Merging cgroup/for-next (f3ba53802eff cgroup: add dummy css_put() for !CONF=
IG_CGROUPS)
Merging scsi/for-next (cbd5bdf0a2fd Merge branch 'misc' into for-next)
Merging target-updates/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (c9ef73dccd6f Merge branch 'devel' into for-next)
Merging vhost/linux-next (0795cb1b46e7 sparc32: nocheck uaccess coding styl=
e tweaks)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (fa62e88f6295 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (39e046f2c1dd pwm: atmel-hlcdc: add at91sam9x5 and sam=
a5d3 errata handling)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (db86da7cb76f userns: Unbreak the unprivileged remo=
unt tests)
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (f1e9203e2366 clk: samsung: Fix Exynos 5420 pinctrl se=
tup and clock disable failure due to domain being gated)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (5f785de58873 aio: Skip timer for io_getevents if timeou=
t=3D0)
Merging llvmlinux/for-next (25d4aee23af2 arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
Merging kselftest/next (97bf6af1f928 Linux 3.19-rc1)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
Merging luto-misc/next (d4812e169de4 x86, mce: Get rid of TIF_MCE_NOTIFY an=
d associated mce tricks)
Merging access_once/linux-next (b5b64f62ed08 kernel: Fix sparse warning for=
 ACCESS_ONCE)
Merging livepatching/for-next (99590ba565a2 livepatch: fix deferred module =
patching order)
Merging akpm-current/current (1d9e76e2eb3f fs/affs/file.c: replace if/BUG b=
y BUG_ON)
CONFLICT (content): Merge conflict in mm/memory.c
CONFLICT (content): Merge conflict in drivers/misc/ti-st/st_core.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: dt-bindings: use isil prefix for Intersil
Applying: rtc: isl12022: deprecate use of isl in compatible string for isil
Applying: rtc: isl12057: deprecate use of isl in compatible string for isil
Applying: staging: iio: isl29028: deprecate use of isl in compatible string=
 for isil
Applying: arm: dts: zynq: update isl9305 compatible string to use isil vend=
or prefix
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (65baa8cc868c mm: add strictlimit knob)

--Sig_//U2M9Hhtm.VnYc6pvpTiriH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtgoMAAoJEMDTa8Ir7ZwVFc4P/3VDbsVVsDbinTMyFxkKm+KL
L/dlI4O1IysnvEz1sJ0PhQO8/Da6KiPfciKlZ5eU/jCFxi/L5kC65HXexjdzhqaC
6exOsqPKe/LF6HIY8jZ5rRqda2kDUb03FcZTpra29riicBaRYxvIyAMNWzGL+mzV
hsdklAv7ktFnhQhoT4jvHsuJSqP8ry6hQzlcGfftCLsZgfmgYHPu/JsVucj630Uu
KX//et3siZ0VBTGTM6AF+CtYy2cdIu2+jB7+ksksD2AxsjfRiaA2BjzjaiyPSP3n
J9fbboRRL5dwZ7mqVyCx1NG8u66UY9YM5yoZoxs6ErysULhTPBK9ogtngkfwi4u/
xROEhfbkl7LVVz42aPi/rtRKdZ+Y1o7N3Gl+WWwI9KAVmNhiJQTvdXEr8mxsMkao
nm5fCgckm9vcTjEJHErgrIP7TDIAP0yfLSYIufkWloYIv0cjiMe6yUr/4hpkYZIQ
tHPGl62W9RU8J7HhSQ5vbgxfcGxUo6UzS7b8FTJB/QOlgcFcFHXc5JjWbzh3dUPL
FT1gHP0Rj0/VLf/m6ywmBaLyghfOn4Anm3uod/MtHhXT4HiSU934rbHjUb3bNzFJ
8splngLJxWfljZ2FVv0lBCLH4ZU4ZnMkN8LF2Nv1z8kl836Kw4krklRdq2YEVel1
bw/ocM7j/ba0RRt2Ttfy
=v86j
-----END PGP SIGNATURE-----

--Sig_//U2M9Hhtm.VnYc6pvpTiriH--
