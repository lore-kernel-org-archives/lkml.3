Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaIPH4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:56:25 -0400
Received: from ozlabs.org ([103.22.144.67]:59270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaIPH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:56:21 -0400
Date: Tue, 16 Sep 2014 17:56:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 16
Message-ID: <20140916175612.3a348b9c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+6bsIuU2oMgvzLpTO5moDen"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+6bsIuU2oMgvzLpTO5moDen
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140912:

The net tree gained a build failure so I used the version from
next-20140915.

The nfs tree lost its build failure.

The v4l-dvb tree still had its build failure so I used the version from
next-20140908.

The slave-dma tree gained a build faiure so I used the version from
next-20140911.

The drm tree still had its build failure for which I applied a merge
fix patch.

The llvmlinux tree gained a conflict against the kbuild tree.

The rd-docs tree gained a build failure for which I reverted a commit.

Non-merge commits (relative to Linus' tree): 5279
 4805 files changed, 176345 insertions(+), 114250 deletions(-)

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

I am currently merging 224 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (2324067fa9a4 Merge tag 'regmap-v3.17-rc5' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging fixes/master (23cf8d3ca0fd powerpc: Fix "attempt to move .org backw=
ards" error)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (55d65081ef2a ARC: [nsimosci] Allow "headless"=
 models to boot)
Merging arm-current/fixes (3ddc65411caa ARM: 8149/1: perf: Don't sleep whil=
e atomic when enabling per-cpu interrupts)
Merging m68k-current/for-linus (4ed7800987b1 m68k: Wire up memfd_create)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/for-linus (7d59deb50aaf powerpc: Wire up sys_secc=
omp(), sys_getrandom() and sys_memfd_create())
Merging sparc/master (d1105287aabe sparc32: dma_alloc_coherent must honour =
gfp flags)
Merging net/master (fe42048e2a7a Merge branch 'bnx2-deps')
$ git reset --hard HEAD^
Merging next-20140915 version of net
Merging ipsec/master (2d39d120781a mvneta: Add missing if_vlan.h include.)
Merging sound-current/for-linus (7a9744cb455e ALSA: hda - Fix invalid pin p=
owermap without jack detection)
Merging pci-current/for-linus (6de8eee17a32 Merge branch 'pci/hotplug-vga' =
into for-linus)
Merging wireless/master (d21ccfd0a60e ath9k_htc: fix random decryption fail=
ure)
Merging driver-core.current/driver-core-linus (9e82bf014195 Linux 3.17-rc5)
Merging tty.current/tty-linus (9e82bf014195 Linux 3.17-rc5)
Merging usb.current/usb-linus (9e82bf014195 Linux 3.17-rc5)
Merging usb-gadget-fixes/fixes (0b93a4c838fa usb: dwc3: fix TRB completion =
when multiple TRBs are started)
Merging usb-serial-fixes/usb-linus (9e82bf014195 Linux 3.17-rc5)
Merging staging.current/staging-linus (9e82bf014195 Linux 3.17-rc5)
Merging char-misc.current/char-misc-linus (9e82bf014195 Linux 3.17-rc5)
Merging input-current/for-linus (807362cd960d Input: atmel_mxt_ts - fix mer=
ge in DT documentation)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (78f543a93473 crypto: drbg - remove check for=
 uninitialized DRBG handle)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
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
Merging arm/for-next (3c79cbca62c6 Merge branch 'swp' (early part) into for=
-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (37bd1119d8b2 arm-soc: document merges)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8d4f3361e05c Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (822e4d347f9e Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (e286df53b1b3 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (bdd3f83ac9be Merge branches 'heads/defconfig-for-v3.1=
8' and 'heads/soc-for-v3.18' into next)
Merging samsung/for-next (ab76395571e4 Merge branch 'v3.18-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (b3a99b3783e8 Merge branch 'sunxi/dt-for-3.18'=
 into sunxi/for-next)
Merging tegra/for-next (264a6086e257 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (7a9c43bed891 setup: Move unmask of async inter=
rupts after possible earlycon setup)
CONFLICT (content): Merge conflict in Documentation/networking/filter.txt
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (6b15075c2c36 [IA64] sn: Do not needlessly convert betwee=
n pointers and integers)
Merging m68k/for-next (9aa59cacdf22 m68k/atari - stram: Add missing #includ=
e <linux/ioport.h>)
Merging m68knommu/for-next (740c615d71f4 m68knommu: fix size of address fie=
ld for 5272 interrupt controller)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (554336c714f4 microblaze: Use empty asm-generic/lin=
kage.h)
Merging mips/mips-for-linux-next (359cf4a70ae8 Merge branch '3.17-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (f3b5933190c1 ia64: Fix syscall number for memfd=
_create)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging fsl/next (78eb9094ca08 powerpc/t2080rdb: Add T2080RDB board support)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (49d3ea4b7a5d s390/hmcdrv: HMC drive CD/DVD access)
Merging sparc-next/master (619df5d2870b Merge tag 'microblaze-3.17-rc5' of =
git://git.monstr.eu/linux-2.6-microblaze)
Merging tile/master (9c29b2aea7fa tile gxio: use better string copy primiti=
ve)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (f2589bff1ce8 xtensa/uapi: Add definition of TIOC[S=
G]RS485)
Merging btrfs/next (8d875f95da43 btrfs: disable strict file flushes for ren=
ames and truncates)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (da80659d4aa7 [SMB3] Fix oops when creating symlinks =
on smb3)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (0b93a92be4cb udf: saner calling conventions for udf_=
new_inode())
Merging ext4/dev (684de5748660 ext4: don't keep using page if inline conver=
sion fails)
Merging f2fs/dev (6e6d1ee7eb4b f2fs: use nm_i->next_scan_nid as default for=
 next_free_nid)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (cfb2f9d5c921 GFS2: fix d_splice_alias() misuses)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (c8ed1434b10a Merge branch 'bugfixes' into linux-nex=
t)
Merging nfsd/nfsd-next (dbec4215b041 nfsd: reject reclaim request when clie=
nt has already sent RECLAIM_COMPLETE)
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
CONFLICT (content): Merge conflict in fs/locks.c
Merging vfs/for-next (bb4623448d40 vfs: move getname() from callers to do_m=
ount())
Merging pci/next (a2351efeb3b4 Merge branches 'pci/misc', 'pci/pm', 'pci/ho=
st-designware', 'pci/host-imx6', 'pci/host-keystone', 'pci/host-tegra' and =
'pci/host-xilinx' into next)
Merging hid/for-next (f73b5bcf1024 Merge branch 'for-3.18/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (2ce7598c9a45 Linux 3.17-rc4)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (bbb9a02ed4e7 hwmon: (smsc47b397) Convert =
to devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (0465653d64d4 Merge branch 'v4l_for_linus' into to_n=
ext)
$ git reset --hard HEAD^
Merging next-20140908 version of v4l-dvb
Merging kbuild/for-next (04d29c44a5c9 Merge branch 'kbuild/misc' into kbuil=
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
Merging slave-dma/next (87c82fe92c69 Merge branch 'for-linus' into next)
$ git reset --hard HEAD^
Merging next-20140911 version of slave-dma
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (c1f570a6abc1 net: dsa: fix mii_bus to host_dev rep=
lacement)
CONFLICT (content): Merge conflict in arch/mips/net/bpf_jit.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188-radxarock.dts
Merging ipsec-next/master (880a6fab8f6b xfrm: configure policy hash table t=
hresholds by netlink)
Merging wireless-next/master (1030f9fe6560 ath9k: Fix primary station confi=
guration)
Merging bluetooth/master (6970c34cea87 MAINTAINERS: add maintainer for gene=
ric 6LoWPAN)
Merging infiniband/for-next (d087f6ad724d Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'iwcm', 'mad', 'misc', 'mlx4', 'mlx5', 'ocrdma' and 'srp' i=
nto for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (7622d4905a03 Merge tag 'v3.17-rc5' from upstream)
Merging crypto/master (cc2db0727040 crypto: qat - Removed unneeded partial =
state)
Merging drm/drm-next (4ac073640a52 Merge branch 'linux-3.18' of git://anong=
it.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Applying: drm/i915: fix up for recent merge
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (a0f641374b0f drm/i915/bios: add missing _=
_packed to structs used for reading vbt)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/tegra/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging sound/for-next (941a74ca9e66 ALSA: Update document about PCM nonato=
mic ops)
Merging sound-asoc/for-next (12a43488df18 Merge remote-tracking branch 'aso=
c/topic/wm8994' into asoc-next)
Merging modules/modules-next (184c3fc3f52f moduleparam: Resolve missing-fie=
ld-initializer warning)
Merging virtio/virtio-next (7ec62d421bdf Merge branch 'for_linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging input/next (05f7588c3c16 Input: palmas-pwrbutton - fix typo in the =
license string)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (18a88466a36d Merge branch 'for-3.18/drivers' into f=
or-next)
Merging device-mapper/for-next (06b09ab4ae16 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (87d2163dae1f mmc: sdhci-pxav3: fix error handling of s=
dhci_add_host)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (06ca229597cf md: use wait_event() to simplify md_super=
_wait())
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
Merging regulator/for-next (bd1aa920d33d Merge remote-tracking branches 're=
gulator/topic/tps65217', 'regulator/topic/tps65910' and 'regulator/topic/vo=
ltage-ev' into regulator-next)
Merging security/next (ac60ab4b4968 Merge branch 'next' of git://git.kernel=
.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next)
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging integrity/next (a2d61ed525f3 integrity: make integrity files as 'in=
tegrity' module)
Merging selinux/next (cbe0d6e8794f selinux: make the netif cache namespace =
aware)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (9e82bf014195 Linux 3.17-rc5)
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
Merging spi/for-next (cfcf2b55263d Merge remote-tracking branches 'spi/topi=
c/rspi', 'spi/topic/sh-msiof', 'spi/topic/sirf' and 'spi/topic/xilinx' into=
 spi-next)
Merging tip/auto-latest (69843f8383fa Merge branch 'x86/uv')
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (2d34056d2768 ppc4xx_edac: Fix build error caused=
 by wrong member access)
Merging irqchip/irqchip/for-next (1633cd9aed67 Merge branch 'irqchip/gic' i=
nto irqchip/for-next)
Merging ftrace/for-next (3ddee63a099e ftrace: Only disable ftrace_enabled t=
o test buffer in selftest)
Merging rcu/rcu/next (f4821ef57470 compiler: Allow 1- and 2-byte smp_load_a=
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
Merging xen-tip/linux-next (59119fad2954 xen-scsifront: don't deadlock if t=
he ring becomes full)
Merging percpu/for-next (31ccce691f9f Merge branch 'for-3.18' into for-next)
CONFLICT (content): Merge conflict in fs/ext4/super.c
Applying: percpu_counter: fix for ext4 updates
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (aeaac098bd58 toshiba_acpi: fix and cleanup to=
shiba_kbd_bl_mode_store())
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (57cf262f025f Merge remote-tracking branch 'regmap/=
topic/dt-endian' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (3ef7de5304ed leds: Improve and export led_update_bri=
ghtness)
Merging ipmi/for-next (662d15871626 ipmi: Clear drvdata when interface is r=
emoved)
Merging driver-core/driver-core-next (9e82bf014195 Linux 3.17-rc5)
Merging tty/tty-next (882ebfc28c38 Merge 3.17-rc5 into tty-next)
Merging usb/usb-next (ce4df0b01259 Merge 3.17-rc5 into usb-next)
Merging usb-gadget/next (d9152161b4bf usb: dwc3: Add Qualcomm DWC3 glue lay=
er driver)
CONFLICT (content): Merge conflict in drivers/usb/phy/phy-mxs-usb.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/usb=
/mxs-phy.txt
Merging usb-serial/usb-next (f8c0e057b489 USB: serial: remove zte_ev driver)
Merging staging/staging-next (caf382fe31b7 Merge 3.17-rc5 into staging-next=
.)
Merging char-misc/char-misc-next (9e82bf014195 Linux 3.17-rc5)
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
Merging pinctrl/for-next (25634a37eba6 Merge branch 'devel' into for-next)
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
Merging clk/clk-next (0469a43bc320 Merge branch 'clk-next-debugfs-lock' int=
o clk-next)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging random/dev (13aa93c70e71 random: add and use memzero_explicit() for=
 clearing data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (7be141d05549 Merge branch 'x86-urgent-for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging llvmlinux/for-next (5c8f567dee83 arm64: LLVMLinux: Fix inline arm64=
 assembly for use with clang)
CONFLICT (content): Merge conflict in Makefile
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (e9cb990eff15 Documentation: update vDSO makefile to=
 build portable examples)
CONFLICT (content): Merge conflict in Documentation/networking/timestamping=
/Makefile
Merging kselftest/next (69e273c0b0a3 Linux 3.17-rc3)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
[master 6170c8030741] Revert "Documentation: update vDSO makefile to build =
portable examples"
Merging akpm-current/current (3c07507edced scripts/headers_install.sh: fix =
error handling)
CONFLICT (content): Merge conflict in mm/mmap.c
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
Merging akpm/master (af415456b2d5 mm: add strictlimit knob)

--Sig_/+6bsIuU2oMgvzLpTO5moDen
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUF+0iAAoJEMDTa8Ir7ZwVS60P/RO4v24A5FJgUAaS2xIapPQU
rGLPxpRN0tNhoseVejtV7dR/mOxSr3rr9b7mIw0YMg4lOFC37Iu6kUo0fGbl3jc4
ycl3QUPvYaZFaNRq5MRPuBTGjvJLD0TEiI9b7X126dvbzr2OtscdskcYhdIOAOL6
ZrUCmqTppIlS0rjmJwq03QDDz9D4D0q56yXmiC/f8/+4vVTv+XWUlS43NNMRqVx4
5eNqo20KxfNPGhRlU/qVKWs8rjDWpnCWH2sjNeWKwZgvtCDrVBSThZdbDrHwywNb
Z31v4U0hcSz0YOCq3PxCpxQMe9811v1SH6UF51NYmm5FW0TYf2IEkwjOs0xns80l
QNBEgCRBPVobjyuFgUyNoR8ay9PmgGJQi/Y7kw3sJDCHwdUDCpqoFtMHEPliB9oD
TBWd3G8UKxY+2NYOgoH/6XFT3i91Bdu0guJyRpNL0E2rcFpTckGOxY82GEmrrN24
O47oF9zUmktyDFP5YLRCYZirgN3uYJpLyViqCtoLaZEzM9ToXhonaDF+j6tuzZFy
swjkMH52vKMKEOWL3sne8E5pBn0XCbm0gbnMDrbcF90Cj9ew3mzq+quu6Dt4LYLH
1JnbJ+jKl1e3tbRMMQNv4OmKE67/Zk5BqCpf1RUGDfaEm/JErSQjZlYY0zt8yolz
jUrZnWmDFfZaTcdgqQaV
=j4IH
-----END PGP SIGNATURE-----

--Sig_/+6bsIuU2oMgvzLpTO5moDen--
