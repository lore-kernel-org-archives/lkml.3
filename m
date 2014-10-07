Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaJGIpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:45:16 -0400
Received: from ozlabs.org ([103.22.144.67]:57356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbaJGIpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:45:03 -0400
Date: Tue, 7 Oct 2014 19:44:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Oct 7
Message-ID: <20141007194454.10502188@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Up0gY4QJR9iAsUFkAcrCe3R"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Up0gY4QJR9iAsUFkAcrCe3R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141003:

The kbuild tree gained a conflict against the arm-soc tree.

The kvm tree gained a conflict against the s390 tree.

The percpu gained conflicts against the s390 tree.

The target-updates lost its build failure.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 9555
 8163 files changed, 377877 insertions(+), 274667 deletions(-)

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

I am currently merging 227 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (bfe01a5ba249 Linux 3.17)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (ad684dce87fa ARM: 8179/1: kprobes-test: Fix comp=
ile error "bad immediate value for offset")
Merging m68k-current/for-linus (24cae7934cf1 m68k: Reformat arch/m68k/mm/hw=
test.c)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/for-linus (7d59deb50aaf powerpc: Wire up sys_secc=
omp(), sys_getrandom() and sys_memfd_create())
Merging sparc/master (d195b71bad43 sparc64: Kill unnecessary tables and inc=
rease MAX_BANKS.)
Merging net/master (bdf6fa52f01b sctp: handle association restarts when the=
 socket is closed.)
Merging ipsec/master (b8c203b2d2fc xfrm: Generate queueing routes only from=
 route lookup functions)
Merging sound-current/for-linus (b7c2dc8e684a Merge tag 'asoc-v3.17-rc7' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (7cbeb9f90db8 PCI: pciehp: Fix pcie_wait_cmd(=
) timeout)
Merging wireless/master (f8adaf0ae978 brcmfmac: Fix off by one bug in brcmf=
_count_20mhz_channels())
Merging driver-core.current/driver-core-linus (9e82bf014195 Linux 3.17-rc5)
Merging tty.current/tty-linus (9e82bf014195 Linux 3.17-rc5)
Merging usb.current/usb-linus (0f33be009b89 Linux 3.17-rc6)
Merging usb-gadget-fixes/fixes (0b93a4c838fa usb: dwc3: fix TRB completion =
when multiple TRBs are started)
Merging usb-serial-fixes/usb-linus (dee80ad12d2b USB: cp210x: add support f=
or Seluxit USB dongle)
Merging staging.current/staging-linus (0f33be009b89 Linux 3.17-rc6)
Merging char-misc.current/char-misc-linus (9e82bf014195 Linux 3.17-rc5)
Merging input-current/for-linus (447a8b858e4b Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (7da4b29d496b crypto: aesni - disable "by8" A=
VX CTR optimization)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (e66c98c7a0ea of: Fix NULL dere=
ference in selftest removal code)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (ce6a144a0d01 selftests/memfd: Run test on al=
l architectures)
Merging drm-intel-fixes/for-linux-next-fixes (bfe01a5ba249 Linux 3.17)
Merging asm-generic/master (f3670394c29f Revert "x86/efi: Fixup GOT in all =
boot code paths")
Merging arc/for-next (517eefb5de44 ARC: unbork FPU save/restore)
Merging arm/for-next (d5d16892243e Merge branches 'fiq' (early part), 'fixe=
s', 'l2c' (early part) and 'misc' into for-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (cdb98444ab65 bus: arm-ccn: Fix spurious warning m=
essage)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8d4f3361e05c Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (2b2244a3e7c3 ARM: dts: imx6: make gpt per clock c=
an be from OSC)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (65a3bb88bb33 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (cc38f02b87ef Merge branches 'heads/dt-for-v3.18' and =
'heads/soc-for-v3.18' into next)
Merging samsung/for-next (a84aaa7556a5 ARM: cacheflush: Fix v7_exit_coheren=
cy_flush exynos build breakage on ARMv6)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging sunxi/sunxi/for-next (429823087fec Merge branches 'sunxi/dt-for-3.1=
8' and 'sunxi/drivers-for-3.18' into sunxi/for-next)
Merging tegra/for-next (5599b9197647 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (0a6479b0ffad arm64: Remove unneeded extern key=
word)
CONFLICT (content): Merge conflict in Documentation/networking/filter.txt
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0f33be009b89 Linux 3.17-rc6)
Merging m68k/for-next (24cae7934cf1 m68k: Reformat arch/m68k/mm/hwtest.c)
Merging m68knommu/for-next (e803d4bd3118 m68k: Fix typo 'COFNIG_MBAR')
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (554336c714f4 microblaze: Use empty asm-generic/lin=
kage.h)
Merging mips/mips-for-linux-next (31d6f57d3c65 MIPS: ralink: remove depreca=
ted IRQF_DISABLED)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (7575e4d56f6f Merge tag 'sound-3.17' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/tiwai/sound)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging powerpc-mpe/next (75d43b2d0a32 Merge branch 'next' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/scottwood/linux.git)
Merging fsl/next (cb0446c1b625 Revert "powerpc/fsl_msi: spread msi ints acr=
oss different MSIRs")
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (2eb9fcc6b565 s390/kdump: add support for vector exte=
nsion)
Merging sparc-next/master (619df5d2870b Merge tag 'microblaze-3.17-rc5' of =
git://git.monstr.eu/linux-2.6-microblaze)
Merging tile/master (78410af51146 tile: add clock_gettime support to vDSO)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (f2589bff1ce8 xtensa/uapi: Add definition of TIOC[S=
G]RS485)
Merging btrfs/next (1d52c78afbbf Btrfs: try not to ENOSPC on log replay)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (4f927ed143fc Remap reserved posix characters by defa=
ult (part 3/3))
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (35425ea24921 ecryptfs: avoid to access NULL pointer =
when write metadata in xattr)
Merging ext3/for_next (c53f755d339b ocfs2: Back out change to use OCFS2_MAX=
QUOTAS in ocfs2_setattr())
Merging ext4/dev (1c8944cbe1b7 ext4: add ext4_iget_normal() which is to be =
used for dir tree lookups)
Merging f2fs/dev (171f109dd326 f2fs: support atomic operations for database)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (d24e0569e046 GFS2: Use gfs2_rbm_incr in rgblk_free)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (b4b56796fe63 Merge branch 'client-4.2' into linux-n=
ext)
Merging nfsd/nfsd-next (34549ab09e62 nfsd: eliminate "to_delegation" define)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (91401a34038e UBI: Fastmap: Calc fastmap size corr=
ectly)
Merging xfs/for-next (bdb119bb6e9d Merge branch 'xfs-misc-fixes-for-3.18-3'=
 into for-next)
Merging file-locks/linux-next (c68f11db3d2f locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
CONFLICT (content): Merge conflict in fs/locks.c
Merging vfs/for-next (bb4623448d40 vfs: move getname() from callers to do_m=
ount())
Merging pci/next (f92d9ee3ab39 Merge branch 'pci/host-xgene' into next)
Merging hid/for-next (3fd9127d236c Merge branch 'for-3.18/uhid' into for-ne=
xt)
Merging i2c/i2c/for-next (a4ce47f108a6 i2c-imx: Disable the clock on probe =
failure)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (3afb57fa721f hwmon: (ab8500) Call kernel_=
power_off instead of pm_power_off)
Merging v4l-dvb/master (8f2f28bac3d1 Merge branch 'topic/si2165' into to_ne=
xt)
Merging kbuild/for-next (62684d75bf61 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
CONFLICT (content): Merge conflict in scripts/tags.sh
CONFLICT (content): Merge conflict in arch/arm/mach-at91/Makefile
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (a823c2a62712 Merge branch 'for-3.18' into for-next)
Merging pm/linux-next (f4f34459d53f Merge branch 'pm-clk')
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-ape6evm-=
reference.c
CONFLICT (content): Merge conflict in arch/arm/configs/mvebu_v7_defconfig
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (dd634666793e Merge branches 'eduardo-soc' and 'bang-b=
ang-governor' of .git into next)
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (ade4a2a8e6e4 Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (1ff0dc9499b2 net: validate_xmit_vlan() is static)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3xxx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188-radxarock.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/berlin2q-marvell-dm=
p.dts
Merging ipsec-next/master (689f1c9de2ab ipsec: Remove obsolete MAX_AH_AUTH_=
LEN)
Merging wireless-next/master (3f08e4729187 rtlwifi: Fix static checker warn=
ings for various drivers)
Merging bluetooth/master (6709fa71153d ieee802154: mrf24j40: Add support fo=
r MRF24J40MC)
Merging infiniband/for-next (3bdad2d13fa6 Merge branches 'core', 'ipoib', '=
iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (32f1b7c8352f mtd: move support for struct flash_plat=
form_data into m25p80)
Merging crypto/master (be34c4ef693f crypto: sha - Handle unaligned input da=
ta in generic sha256 and sha512.)
CONFLICT (content): Merge conflict in arch/arm64/boot/dts/apm-storm.dtsi
Merging drm/drm-next (7a42e83d36d2 Merge branch 'for-airlied-next' of git:/=
/people.freedesktop.org/~mlankhorst/linux into drm-next)
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (ebb69c951756 drm/i915: Enable pixel repli=
cated modes on BDW and HSW.)
Merging drm-tegra/drm/tegra/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging sound/for-next (8df22a4d6f5b Merge tag 'asoc-v3.18' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/broonie/sound into for-next)
Merging sound-asoc/for-next (bb63de076fd9 Merge remote-tracking branches 'a=
soc/topic/txx9', 'asoc/topic/wm8978' and 'asoc/topic/wm8994' into asoc-next)
Merging modules/modules-next (184c3fc3f52f moduleparam: Resolve missing-fie=
ld-initializer warning)
Merging virtio/virtio-next (7ec62d421bdf Merge branch 'for_linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging input/next (042e1c79166b Input: soc_button_array - convert to platf=
orm bus)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (31cdd72b70bf Merge branch 'for-3.18/drivers' into f=
or-next)
Merging device-mapper/for-next (010b788c73c9 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (8024379e0ae4 mmc: sdhci-acpi: Fix Braswell eMMC timeou=
t clock frequency)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (86143256d202 md/bitmap: remove bev_logical_block_size =
rounding where not needed.)
Merging mfd/for-mfd-next (d86c21fd3111 mfd: cros_ec: wait for completion of=
 commands that return IN_PROGRESS)
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (7881c64716f3 power: ab8500_fg: Fix build warning)
CONFLICT (content): Merge conflict in drivers/power/reset/Makefile
CONFLICT (content): Merge conflict in drivers/power/reset/Kconfig
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (2d6054564313 video/atmel_lcdfb: Introduce regul=
ator support)
Merging regulator/for-next (ad21edcdb217 Merge remote-tracking branches 're=
gulator/topic/tps65217', 'regulator/topic/tps65910' and 'regulator/topic/vo=
ltage-ev' into regulator-next)
Merging security/next (c867d07e3c86 Merge branch 'next' of git://git.kernel=
.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next)
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging integrity/next (1b68bdf9cded ima: detect violations for mmaped file=
s)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (dc423adb304e watchdog: sunxi: Add A31 watchdog sup=
port)
Merging iommu/next (09b5269a1b3d Merge branches 'arm/exynos', 'arm/omap', '=
arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (93899a679fd6 vfio-pci: Fix remove path locking)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (7bb38d57fd75 Remove MN10300_PROC_MN2WS0038)
CONFLICT (content): Merge conflict in block/blk-core.c
Merging audit/master (29075feaf1f5 next: openrisc: Fix build)
CONFLICT (content): Merge conflict in arch/arm64/kernel/ptrace.c
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (669a36302641 To remove non-ascii charac=
ters in of_selftest.txt)
Merging dt-rh/for-next (d22e9131187d of: add vendor prefix for Chipidea)
Merging mailbox/mailbox-for-next (168e92ba5ec7 dt: mailbox: add generic bin=
dings)
Merging spi/for-next (a2285b8c75bf Merge remote-tracking branch 'spi/topic/=
xilinx' into spi-next)
Merging tip/auto-latest (6dcc548541d3 Merge branch 'x86/vdso')
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdm.c deleted in HEA=
D and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/blockl=
ayout/blocklayoutdm.c left in tree.
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdev.c deleted in HE=
AD and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/block=
layout/blocklayoutdev.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_64.S
CONFLICT (modify/delete): arch/arm/mach-omap2/irq.c deleted in HEAD and mod=
ified in tip/auto-latest. Version tip/auto-latest of arch/arm/mach-omap2/ir=
q.c left in tree.
$ git rm -f fs/nfs/blocklayout/blocklayoutdev.c fs/nfs/blocklayout/blocklay=
outdm.c arch/arm/mach-omap2/irq.c
Applying: pnfs: merge fixup for sched cleanup of set_current_state(TASK_RUN=
NING)
Applying: arm: omap: irq: fixup for new handle_domain_irq method
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (a18c3f16a907 mpc85xx_edac: Make L2 interrupt sha=
red too)
Merging irqchip/irqchip/for-next (3bbccffba8d5 Merge branch 'irqchip/core' =
into irqchip/for-next)
Merging tiny/tiny/next (d45461ff03ad Merge branches 'tiny/bloat-o-meter-no-=
SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x=
86-boot-compressed-use-yn' into tiny/next)
CONFLICT (content): Merge conflict in arch/x86/boot/compressed/Makefile
Merging ftrace/for-next (382f43516812 Merge branch 'trace/ftrace/testing' i=
nto trace/for-next)
Merging rcu/rcu/next (3e28e377204b workqueue: Use cond_resched_rcu_qs macro)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (f439ed27f8b8 kvm: do not handle APIC access page if=
 in-kernel irqchip is not in use)
CONFLICT (content): Merge conflict in arch/s390/mm/pgtable.c
Merging kvm-arm/next (0496daa5cf99 arm/arm64: KVM: Report correct FSC for u=
nsupported fault types)
Merging kvm-ppc/kvm-ppc-next (8d0eff638564 KVM: PPC: Pass enum to kvmppc_ge=
t_last_inst)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (6283da500f5d xen: remove DEFINE_XENBUS_DRIVER()=
 macro)
Merging percpu/for-next (92f4f5286667 Merge branch 'for-3.18' into for-next)
CONFLICT (content): Merge conflict in fs/ext4/super.c
CONFLICT (content): Merge conflict in arch/s390/kernel/vtime.c
CONFLICT (content): Merge conflict in arch/s390/kernel/processor.c
CONFLICT (content): Merge conflict in arch/s390/kernel/irq.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/cputime.h
Applying: percpu_counter: fix for ext4 updates
Applying: s390: fixup for Replace __get_cpu_var uses
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (893f3f62dc7a toshiba_acpi: Change HCI/SCI fun=
ctions return code type)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (f5b313a2bcd4 Merge remote-tracking branch 'regmap/=
topic/cache' into regmap-next)
Merging hsi/for-next (a26a42508157 HSI: remove deprecated IRQF_DISABLED)
Merging leds/for-next (a4c84e6aafda leds: gpio: cleanup the leds-gpio drive=
r)
Merging ipmi/for-next (bfe01a5ba249 Linux 3.17)
Merging driver-core/driver-core-next (906d201530f2 dynamic_debug: change __=
dynamic_<foo>_dbg return types to void)
Merging tty/tty-next (69784fa539ef Revert "serial/core: Initialize the cons=
ole pm state")
CONFLICT (content): Merge conflict in drivers/tty/serial/8250/8250_pci.c
Merging usb/usb-next (4ed9a3d45555 USB: host: st: fix typo 'CONFIG_USB_EHCI=
_HCD_ST')
CONFLICT (content): Merge conflict in drivers/usb/gadget/function/f_fs.c
Merging usb-gadget/next (72a65a0d19c1 Revert "usb: gadget: composite: deque=
ue cdev->req before free its buffer")
Merging usb-serial/usb-next (f8c0e057b489 USB: serial: remove zte_ev driver)
Merging staging/staging-next (e603984823a9 staging: et131x: Remove et131x d=
river from drivers/staging)
Merging char-misc/char-misc-next (480bd3c4ad30 mei: mei_txe_fw_sts can be s=
tatic)
Merging cgroup/for-next (55e8955e6eba Merge branch 'for-3.18' into for-next)
Merging scsi/for-next (20c5ec4e6d71 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (0d0f660d882c iser-target: Disable TX compl=
etion interrupt coalescing)
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (2cdef8f4e1ac pinctrl: specify bindings for pins a=
nd groups)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (a092e19b688b gpio: pch: Build context save/restore o=
nly for PM)
CONFLICT (content): Merge conflict in drivers/pinctrl/qcom/pinctrl-msm.c
CONFLICT (content): Merge conflict in drivers/gpio/gpiolib.c
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (e2e08970100d pwm: atmel: Fix calculation of prescale =
value)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (fee9d3e61d04 ktest: add ability to skip during BISE=
CT_MANUAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (98d147f50eb0 clk: pxa clocks build system fix)
Merging random/dev (13aa93c70e71 random: add and use memzero_explicit() for=
 clearing data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (668044a5d632 aio: Make it possible to remap aio ring)
Merging llvmlinux/for-next (977104ece156 arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
CONFLICT (content): Merge conflict in Documentation/networking/timestamping=
/Makefile
Merging kselftest/next (49296470830a selftests/timers: change test to use k=
sft framework)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
CONFLICT (content): Merge conflict in arch/s390/kernel/signal.c
CONFLICT (content): Merge conflict in arch/s390/kernel/compat_signal.c
Merging akpm-current/current (833628771769 scripts/sortextable: suppress wa=
rning: `relocs_size' may be used uninitialized)
CONFLICT (content): Merge conflict in mm/page_alloc.c
CONFLICT (content): Merge conflict in drivers/clk/Kconfig
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: arch/x86/kernel/cpu/common.c: fix unused symbol warning
Applying: lib/string.c: remove duplicated function
Applying: lib: string: Make all calls to strnicmp into calls to strncasecmp
Applying: ARM: replace strnicmp with strncasecmp
Applying: netfilter: replace strnicmp with strncasecmp
Applying: video: fbdev: replace strnicmp with strncasecmp
Applying: cifs: replace strnicmp with strncasecmp
Applying: ocfs2: replace strnicmp with strncasecmp
Applying: isofs: replace strnicmp with strncasecmp
Applying: batman-adv: replace strnicmp with strncasecmp
Applying: scsi: replace strnicmp with strncasecmp
Applying: ib_srpt: replace strnicmp with strncasecmp
Applying: input: edt-ft5x06: replace strnicmp with strncasecmp
Applying: altera-stapl: replace strnicmp with strncasecmp
Applying: thinkpad_acpi: replace strnicmp with strncasecmp
Applying: PNP: replace strnicmp with strncasecmp
Applying: s390/cio: replace strnicmp with strncasecmp
Applying: staging: r8188eu: replace strnicmp with strncasecmp
Applying: thermal: replace strnicmp with strncasecmp
Applying: kdb: replace strnicmp with strncasecmp
Applying: fs: check bh blocknr earlier when searching lru
Applying: arch/x86/mm/numa.c: fix boot failure when all nodes are hotplugga=
ble
Applying: mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggabl=
e-checkpatch-fixes
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
Applying: wireless-hostap-proc-print-properly-escaped-ssid-fix-2
Applying: lib80211: remove unused print_ssid()
Applying: staging: wlan-ng: use %*pEhp to print SN
Applying: staging: rtl8192e: use %*pEn to escape buffer
Applying: staging: rtl8192u: use %*pEn to escape buffer
Applying: kernel/watchdog.c: control hard lockup detection default
Applying: watchdog-control-hard-lockup-detection-default-fix
Applying: watchdog, nmi: Fix compile issues on sparc
Applying: kvm: ensure hard lockup detection is disabled by default
Applying: frv: remove unused declarations of __start___ex_table and __stop_=
__ex_table
Applying: ia64: remove duplicate declarations of __per_cpu_start[] and __pe=
r_cpu_end[]
Applying: kernel/param: consolidate __{start,stop}___param[] in <linux/modu=
leparam.h>
Applying: mm: softdirty: enable write notifications on VMAs after VM_SOFTDI=
RTY cleared
Applying: mm-softdirty-enable-write-notifications-on-vmas-after-vm_softdirt=
y-cleared-fix
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: skip cluster allocation on fallocated region
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (783b488150f0 mm: add strictlimit knob)

--Sig_/Up0gY4QJR9iAsUFkAcrCe3R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUM6gLAAoJEMDTa8Ir7ZwVrWoP/3T4aJwG0snScUFED6dn7oql
CcCP1PzV8WiBR0KJ+JvKYwNHBWqZPkYg+Y5xc+tQJjiCmnhelEq9qvXPKCx5lcKw
ByxEqw5BPtSjP3WRRLquEVJ7SSpyQfTgxs+ThobOjZovY2cBKKzz3xBfwUK2IlAN
ZJsh9wNgc/CDSqZPpL0w4bECY74999tqJMxCtt2rABKfvAiqzpOrRQL10Jn0qGbY
hEZJQn+DKFwDPEXGJZBtiqpJjos7OwyZqkTR40kK4REWaXFcQ1ECe+OFXXkcG0kW
7DdJhgfeOB2ubiHDl/uVuH9HXBVw6jL3iGFnwYoc2KWz0894sz/ALWmDXXLBLULr
SLxidnLWO+O2DUkh62ArYiEuJbTHEJKRcxMC7z7eRan8+qSBppR1U5ADVHFBpvi/
KXbu9m4T5lIngxt+Vo6M8i25APRrqVpPu9oVlnuA9GXOxY4oNE4zlXmS24+PD1h1
c5aOkDmKFSAFR8DXnd639Z80gS4n9/MzKHB4Y6ZyiGc8ZG4aIcxxDYSTsvjYjFtT
FOW0WsLdAr7+MTDksyXtdR+68Q+tGpDQiOzE985cgel3R5Y/iT2q5WHN7+CcgR+x
7O/9r656XNLE+t5fR6f7OXkk3araitx0iLAd9Ye/clEELOLTcbxzWrXq2pRooexo
xZwy313YM8wcmAAslbo4
=yZpX
-----END PGP SIGNATURE-----

--Sig_/Up0gY4QJR9iAsUFkAcrCe3R--
