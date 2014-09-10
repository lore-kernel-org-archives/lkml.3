Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaIJI7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:59:43 -0400
Received: from ozlabs.org ([103.22.144.67]:35120 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaIJI72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:59:28 -0400
Date: Wed, 10 Sep 2014 18:59:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 10
Message-ID: <20140910185920.336180d4@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/a3+NcBpz7O3b7vbzo+/N=nF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/a3+NcBpz7O3b7vbzo+/N=nF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140909:

New tree: powerpc-merge-mpe

The pm tree gained conflicts against the mvebu and arm-soc trees.

The v4l-dvb tree still had its build failure so I used the version from
next-20140908.

The net-next tree gained a conflict against the arm-soc tree.

The wireless-next tree lost its build failure.

The drm tree still had its build failure for which I applied a merge
fix patch.

The regulator tree still had its build failure for which I reverted
several commits.

The trivial tree gained a conflict against the block tree.

The clk tree gained a conflict against the renesas tree.

The akpm-current tree lost its build failure.

Non-merge commits (relative to Linus' tree): 4389
 4067 files changed, 140816 insertions(+), 93267 deletions(-)

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

I am currently merging 223 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (619df5d2870b Merge tag 'microblaze-3.17-rc5' of git:=
//git.monstr.eu/linux-2.6-microblaze)
Merging fixes/master (23cf8d3ca0fd powerpc: Fix "attempt to move .org backw=
ards" error)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (0621ecd05923 ARC: Allow SMP kernel to build/b=
oot on UP-only infrastructure)
Merging arm-current/fixes (a040803a9d6b ARM: 8133/1: use irq_set_affinity w=
ith force=3Dfalse when migrating irqs)
Merging m68k-current/for-linus (4ed7800987b1 m68k: Wire up memfd_create)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging sparc/master (b84ca92e1672 sparc32, leon: Make leon_dma_ops avaiabl=
e when !CONFIG_PCI)
Merging net/master (6a2a2b3ae075 net:socket: set msg_namelen to 0 if msg_na=
me is passed as NULL in msghdr struct from userland.)
Merging ipsec/master (2d39d120781a mvneta: Add missing if_vlan.h include.)
Merging sound-current/for-linus (05244d166739 Merge tag 'asoc-v3.17-rc3' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (fd7155fc9fca Merge branch 'pci/host-imx6' in=
to for-linus)
Merging wireless/master (3b924ea1ac55 Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (69e273c0b0a3 Linux 3.17-rc3)
Merging tty.current/tty-linus (6731af573ac2 tty: xuartps: Fix tx_emtpy() ca=
llback)
Merging usb.current/usb-linus (604eac3c0c69 usb: dwc2/gadget: avoid disabli=
ng ep0)
Merging usb-gadget-fixes/fixes (9ce9ec95fb9b usb: phy: tegra: Avoid use of =
sizeof(void))
Merging usb-serial-fixes/usb-linus (5b3da69285c1 USB: sierra: add 1199:68AA=
 device ID)
Merging staging.current/staging-linus (3ea411c56ef5 android: fix reference =
leak in sync_fence_create)
Merging char-misc.current/char-misc-linus (3f0d97d97f2b Lattice ECP3 FPGA: =
Check firmware pointer)
Merging input-current/for-linus (5715fc764f77 Input: synaptics - add suppor=
t for ForcePads)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (78f543a93473 crypto: drbg - remove check for=
 uninitialized DRBG handle)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (ff7e0055bb5d module: Clean up ro/nx after early mod=
ule load failures)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (2ed36928373c memfd_test: Add missing argumen=
t to printf())
Merging drm-intel-fixes/for-linux-next-fixes (be71eabebaf9 Revert "drm/i915=
: Enable semaphores on BDW")
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (2a5e95d4181c mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (f58d5ede6aa0 Merge branch 'swp' (early part) into for=
-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (8224b1fb3027 arm-soc: document merges)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (94bb14e50e5e Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (ef200e12f772 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (556cc4a7dc24 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (4f431976c960 Merge branch 'heads/clk-for-v3.18' into =
next)
Merging samsung/for-next (213e1f6f5f0b Merge branch 'v3.18-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (779b646c8102 Merge branch 'sunxi/dt-for-3.18'=
 into sunxi/for-next)
Merging tegra/for-next (264a6086e257 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (e3672649faae arm64: defconfig: increase NR_CPU=
S default to 64)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (6b15075c2c36 [IA64] sn: Do not needlessly convert betwee=
n pointers and integers)
Merging m68k/for-next (9117710a5997 m68k/sun3: Remove define statement no l=
onger needed)
Merging m68knommu/for-next (740c615d71f4 m68knommu: fix size of address fie=
ld for 5272 interrupt controller)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (9fc4b7e241a7 microblaze: Fix number of syscalls)
Merging mips/mips-for-linux-next (739c25724af0 Merge branch '3.17-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (c90f06943e05 parisc: Wire up seccomp, getrandom=
 and memfd_create syscalls)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging fsl/next (78eb9094ca08 powerpc/t2080rdb: Add T2080RDB board support)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (233a2a5710d6 s390/zcrypt: support for extended numbe=
r of ap domains)
Merging sparc-next/master (619df5d2870b Merge tag 'microblaze-3.17-rc5' of =
git://git.monstr.eu/linux-2.6-microblaze)
Merging tile/master (9c29b2aea7fa tile gxio: use better string copy primiti=
ve)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (e792290be763 Merge tag 'xtensa-for-next-20140815' =
into for_next)
Merging btrfs/next (8d875f95da43 btrfs: disable strict file flushes for ren=
ames and truncates)
Merging ceph/master (5f740d7e1531 libceph: set last_piece in ceph_msg_data_=
pages_cursor_init() correctly)
Merging cifs/for-next (ca5d13fc33cc Clarify Kconfig help text for CIFS and =
SMB2/SMB3)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (0b93a92be4cb udf: saner calling conventions for udf_=
new_inode())
Merging ext4/dev (a49058fab291 jbd/jbd2: use non-movable memory for the jbd=
 superblock)
Merging f2fs/dev (054ed1ae0fdc f2fs: fix negative value for lseek offset)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (2ddfbdd6848d GFS2: Request demote when a "try" flock f=
ails)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (6478bd5dc666 NFS: Fix a compile warning when !(CONF=
IG_NFS_V3 || CONFIG_NFS_V4))
Merging nfsd/nfsd-next (0a137ecaa3d2 nfsd: update mtime on truncate)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (ba29e721eb2d UBIFS: fix free log space calculatio=
n)
Merging xfs/for-next (a4241aebe924 Merge branch 'xfs-misc-fixes-for-3.18-1'=
 into for-next)
Merging file-locks/linux-next (b0dd1b52742a locks: flock_make_lock should r=
eturn a struct file_lock (or PTR_ERR))
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in fs/locks.c
Merging vfs/for-next (7b0527f875b1 fs: namespace: suppress 'may be used uni=
nitialized' warnings)
Merging pci/next (a2351efeb3b4 Merge branches 'pci/misc', 'pci/pm', 'pci/ho=
st-designware', 'pci/host-imx6', 'pci/host-keystone', 'pci/host-tegra' and =
'pci/host-xilinx' into next)
Merging hid/for-next (1446b04c56cf Merge branch 'for-3.18/always-poll-quirk=
' into for-next)
Merging i2c/i2c/for-next (2ce7598c9a45 Linux 3.17-rc4)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (ce95e1886a5f MAINTAINERS: add entry for t=
he PWM fan driver)
Merging v4l-dvb/master (0465653d64d4 Merge branch 'v4l_for_linus' into to_n=
ext)
$ git reset --hard HEAD^
Merging next-20140908 version of v4l-dvb
Merging kbuild/for-next (c7377ed8b9eb Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (9b8a2d2b9a97 Merge branch 'for-3.17-fixes' into fo=
r-next)
Merging pm/linux-next (9705afcec459 Merge branch 'pm-cpufreq-next' into lin=
ux-next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-ape6evm-=
reference.c
CONFLICT (content): Merge conflict in arch/arm/configs/mvebu_v7_defconfig
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (47d104ba5879 Merge branches 'exynos-fix', 'for-rc', '=
int3403-fix', 'misc', 'rcar-thermal' and 'sti-thermal' of .git into next)
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (bebbbb764e5b Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (4ef6dae4ba0f sfc: Convert the normal transmit comp=
lete path to dev_consume_skb_any())
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188-radxarock.dts
Merging ipsec-next/master (880a6fab8f6b xfrm: configure policy hash table t=
hresholds by netlink)
Merging wireless-next/master (1716bcf3f76f bcma: add support for chipcommon=
 B core)
Merging bluetooth/master (196332f5a1e5 Bluetooth: Fix allowing SMP Signing =
info PDU)
Merging infiniband/for-next (d087f6ad724d Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'iwcm', 'mad', 'misc', 'mlx4', 'mlx5', 'ocrdma' and 'srp' i=
nto for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (5b49ab3e03f6 Merge l2-mtd/next into l2-mtd/master)
Merging crypto/master (ea2d9fc1af6e Merge git://git.kernel.org/pub/scm/linu=
x/kernel/git/herbert/crypto-2.6)
Merging drm/drm-next (58b21c22c66d drm/qxl: Fix crash in eviction from qxl_=
release_fence_buffer_objects)
Applying: drm/i915: fix up for recent merge
Merging drm-panel/drm/panel/for-next (9746c61960b6 drm/panel: simple: Use d=
evm_gpiod_get_optional())
Merging drm-intel/for-linux-next (6e47e3f097cc drm/i915: Wrap -EIO send-vbl=
ank event for failed pageflip in spinlock)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/tegra/for-next (ef70728c7a65 drm/tegra: add MODULE_DE=
VICE_TABLEs)
Merging sound/for-next (e7e69265b626 sound: pci: au88x0: printk replacement)
Merging sound-asoc/for-next (2cc1253d290f Merge remote-tracking branches 'a=
soc/topic/tlv320aic31xx', 'asoc/topic/txx9', 'asoc/topic/wm8978' and 'asoc/=
topic/wm8994' into asoc-next)
Merging modules/modules-next (480cadc2b7e0 scsi: Fix qemu boot hang problem)
Merging virtio/virtio-next (480cadc2b7e0 scsi: Fix qemu boot hang problem)
Merging input/next (1c24622572d6 Input: add support for the DRV2667 haptic =
driver)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (eec64fc23ce1 Merge branch 'for-3.18/core' into for-=
next)
Merging device-mapper/for-next (e8531a5cbbd9 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (ce437aa4519c mmc: mmci: augment driver to handle gpio =
descriptors)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (90c25a429b62 md/raid5: fix init_stripe() inconsistenci=
es)
Merging mfd/for-mfd-next (eb61b3276e09 mfd: rtsx_pcr: Fix MSI enable error =
handling)
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (5e37195f30cc ipaq_micro_battery: fix sparse non sta=
tic symbol warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (30296f61159e video: fbdev: use %*ph specifier t=
o dump small buffers)
Merging regulator/for-next (0e03526cca2e Merge remote-tracking branches 're=
gulator/topic/tps65910' and 'regulator/topic/voltage-ev' into regulator-nex=
t)
$ git am -3 ../patches/0001-Revert-regulator-RK808-Add-proper-input-supplie=
s-for.patch
Applying: Revert "regulator: RK808: Add proper input supplies for rk808"
$ git am -3 ../patches/0002-Revert-regulator-rk808-Fix-n_voltages-for-DCDC4=
.patch
Applying: Revert "regulator: rk808: Fix n_voltages for DCDC4"
$ git am -3 ../patches/0003-Revert-regulator-rk808-Fix-memory-leak.patch
Applying: Revert "regulator: rk808: Fix memory leak"
$ git am -3 ../patches/0004-Revert-regulator-rk808-remove-redundant-code.pa=
tch
Applying: Revert "regulator: rk808: remove redundant code"
$ git am -3 ../patches/0005-Revert-regulator-RK808-modify-for-struct-rk808-=
chang.patch
Applying: Revert "regulator: RK808: modify for struct rk808 change"
$ git am -3 ../patches/0006-Revert-regulator-rk808-Fix-uninitialized-value.=
patch
Applying: Revert "regulator: rk808: Fix uninitialized value"
$ git am -3 ../patches/0007-Revert-regulator-RK808-Add-regulator-driver-for=
-RK80.patch
Applying: Revert "regulator: RK808: Add regulator driver for RK808"
Merging security/next (a0cfd75fdc46 seccomp: Add reviewers to MAINTAINERS)
Merging integrity/next (a2d61ed525f3 integrity: make integrity files as 'in=
tegrity' module)
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging selinux/next (25db6bea1ff5 selinux: register nf hooks with single n=
f_register_hooks call)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (d030671f3f26 Merge branch 'for-3.17-fixes' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging iommu/next (f55c86642759 Merge branches 'iommu/fixes', 'arm/exynos'=
, 'arm/omap', 'x86/vt-d' and 'x86/amd' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (9b936c960f22 drivers/vfio: Enable VFIO if EEH is not sup=
ported)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (00703e0b7990 Documentation: remove obsolete pcmci=
a-cs from Changes)
CONFLICT (content): Merge conflict in block/blk-core.c
Merging audit/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a9ecdc0fdc54 of/irq: Fix lookup to use =
'interrupts-extended' property first)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (5f31c32425da Merge remote-tracking branches 'spi/topi=
c/sh-msiof', 'spi/topic/sirf' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (69843f8383fa Merge branch 'x86/uv')
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (f4ce6eca71d1 EDAC: Fix mem_types strings type)
Merging irqchip/irqchip/for-next (39ec800c791e Merge branch 'irqchip/handle=
_domain' into irqchip/for-next)
Merging ftrace/for-next (4ce97dbf5024 trace: Fix epoll hang when we race wi=
th new entries)
Merging rcu/rcu/next (1de764863531 compiler: Allow 1- and 2-byte smp_load_a=
cquire() and smp_store_release())
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (fd2752352bbc KVM: x86: use guest maxphyaddr to chec=
k MTRR values)
Merging kvm-arm/next (de56fb1923ca KVM: vgic: declare probe function pointe=
r as const)
CONFLICT (content): Merge conflict in arch/arm64/include/asm/kvm_host.h
Merging kvm-ppc/kvm-ppc-next (c77dcacb3975 KVM: Move more code under CONFIG=
_HAVE_KVM_IRQFD)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (db77bfe346ab MAINTAINERS: Add xen pvscsi mainta=
iner)
Merging percpu/for-next (31ccce691f9f Merge branch 'for-3.18' into for-next)
CONFLICT (content): Merge conflict in fs/ext4/super.c
Applying: percpu_counter: fix for ext4 updates
Merging workqueues/for-next (ebb48ccd98d1 Merge branch 'for-3.17' into for-=
next)
Merging drivers-x86/for-next (aeaac098bd58 toshiba_acpi: fix and cleanup to=
shiba_kbd_bl_mode_store())
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (6bee5daa9e26 Merge remote-tracking branch 'regmap/=
topic/dt-endian' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (3f6815f711ef leds: lp3944: fix sparse warning)
CONFLICT (content): Merge conflict in include/linux/leds.h
CONFLICT (content): Merge conflict in drivers/leds/led-core.c
CONFLICT (content): Merge conflict in drivers/leds/led-class.c
Merging driver-core/driver-core-next (69e273c0b0a3 Linux 3.17-rc3)
Merging tty/tty-next (b99b121b2aa4 tty: serial: 8250_core: allow to overwri=
te & export serial8250_startup())
Merging usb/usb-next (8df438571cdb usb: dwc2: move "samsung,s3c6400-hsotg" =
into common platform)
Merging usb-gadget/next (f7cc38b16e27 Merge tag 'v3.17-rc4' into next)
CONFLICT (content): Merge conflict in drivers/usb/phy/phy-mxs-usb.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/usb=
/mxs-phy.txt
Merging usb-serial/usb-next (adceac14166d usb: serial: xsens_mt: always bin=
d to interface number 1)
Merging staging/staging-next (2a3b60d8ba4c staging: clean up checkpatch war=
nings in lustre)
Merging char-misc/char-misc-next (69e273c0b0a3 Linux 3.17-rc3)
Merging cgroup/for-next (fd2443519da9 Merge branch 'for-3.17-fixes' into fo=
r-next)
Merging scsi/for-next (bc215e400856 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
Merging target-updates/for-next (4ca7ea3ceeb9 iscsi-target: Ignore ICF_GOT_=
LAST_DATAOUT during Data-Out ITT lookup)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (b25495c7d7c0 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (7a95008062c6 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (70145f87139f pwm: Fix uninitialized warnings in pwm_g=
et())
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (16eeaec77922 clk: at91: fix div by zero in USB clock =
driver)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging random/dev (13aa93c70e71 random: add and use memzero_explicit() for=
 clearing data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (7be141d05549 Merge branch 'x86-urgent-for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging llvmlinux/for-next (f7940ee9731f arm64: LLVMLinux: Use global stack=
 pointer in return_address())
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (51243a99459f v4l2-pci-skeleton: Only build if PCI i=
s available)
CONFLICT (content): Merge conflict in Documentation/networking/timestamping=
/Makefile
Merging kselftest/next (69e273c0b0a3 Linux 3.17-rc3)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
Merging powerpc-merge-mpe/for-linus (7d59deb50aaf powerpc: Wire up sys_secc=
omp(), sys_getrandom() and sys_memfd_create())
Merging akpm-current/current (3c07507edced scripts/headers_install.sh: fix =
error handling)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: x86, vdso: fix vdso2c's special_pages error checking
Applying: include/linux: remove strict_strto* definitions
Applying: lib / string_helpers: move documentation to c-file
Applying: lib / string_helpers: refactoring the test suite
Applying: lib / string_helpers: introduce string_escape_mem()
Applying: lib-string_helpers-introduce-string_escape_mem-fix
Applying: lib/vsprintf: add %*pE[achnops] format specifier
Applying: lib-vsprintf-add-%pe-format-specifier-fix
Applying: wireless: libertas: print esaped string via %*pE
Applying: wireless: ipw2x00: print SSID via %*pE
Applying: wireless: hostap: proc: print properly escaped SSID
Applying: wireless-hostap-proc-print-properly-escaped-ssid-fix
Applying: lib80211: remove unused print_ssid()
Applying: staging: wlan-ng: use %*pEhp to print SN
Applying: staging: rtl8192e: use %*pEn to escape buffer
Applying: staging: rtl8192u: use %*pEn to escape buffer
Applying: kernel/watchdog.c: control hard lockup detection default
Applying: watchdog-control-hard-lockup-detection-default-fix
Applying: watchdog, nmi: Fix compile issues on sparc
Applying: kvm: ensure hard lockup detection is disabled by default
Applying: kernel: add support for kernel restart handler call chain
Applying: power/restart: call machine_restart instead of arm_pm_restart
Applying: arm64: support restart through restart handler call chain
Applying: arm: support restart through restart handler call chain
Applying: watchdog: moxart: register restart handler with kernel restart ha=
ndler
Applying: watchdog: alim7101: register restart handler with kernel restart =
handler
Applying: watchdog: sunxi: register restart handler with kernel restart han=
dler
Applying: arm/arm64: unexport restart handlers
Applying: watchdog: s3c2410: add restart handler
Applying: clk: samsung: register restart handlers for s3c2412 and s3c2443
Applying: clk: rockchip: add restart handler
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: zero out seek range on _fat_get_block
Applying: fat: fallback to buffered write in case of fallocated region on d=
irect IO
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (495fe489e41c mm: add strictlimit knob)

--Sig_/a3+NcBpz7O3b7vbzo+/N=nF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUEBLtAAoJEMDTa8Ir7ZwVahEP/jQar2GdRbn6uqVNedcZXRSC
6m0aO4WY0UU2Bqy2QbnwfnJpXrwUCdoh772H8Tk7skZsRAOGqxgr6gQCqlY3tnR8
7sJ4/bALr4CGmye/aihZle/G+jLA0Jvc0bl3lvBAFwVe/F02+I3CDUkOJZzK0KQQ
bRN27/rt4qGPC7qbfvlPfx9fJxZZhhju7ky4DDGvgCRAc6yhtGEywewaFrKaI3hw
0d9oGy0Bo8sfc2RABlmlgmDfg1dOsmP6bK7MUEL5fJ6IK9TPUpBWVnQjUQKH9Zp9
ooPM1whgRCybxlmzr8BGWLo1TL3N9h3AXL0PepWL/oU+yyzLCjvBW4RC0eqUtyYz
xQAkFHJ23emKfTOKqk2dMg8Hv9IZ+DaW3uhf1UriNup04zkxCSE+7ypS81I3gDZl
9y8lCE6n5/PMSiIxJJRqdwp68C5nQvkq1hUBawuKCksxGlGhKnY0kU5lXTFc6emv
G1qETWyWWVH+KgN0om/lVGaJEqjpV1rqxfNDBQejqoydj5nEiuVi8rEMcZZBiNf8
vdoKMu/9RYyii0Y1nU79C1d55LTP373XswBW/GzGazRqA7UiklcwMlCce2VL6Z+8
ZmHwiqFQqtr+zIcI537O51ujfXclhW9QotMnTlqgogxxAawl0mU+YLwxLllbUXAz
cEJJluFmUI4SV2E4bxfp
=NesR
-----END PGP SIGNATURE-----

--Sig_/a3+NcBpz7O3b7vbzo+/N=nF--
