Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaIYIeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:34:31 -0400
Received: from ozlabs.org ([103.22.144.67]:44405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaIYIeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:34:16 -0400
Date: Thu, 25 Sep 2014 18:34:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 25
Message-ID: <20140925183406.6ac3420d@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/C0LijmJNNbW3xo5wI.2xqf."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/C0LijmJNNbW3xo5wI.2xqf.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140924:

My fixes tree is empty again.

The samsung tree lost its build failures.

The net-next tree gained a conflict against the arm-soc tree.

The mfd tree gained a conflict against the hwmon-staging tree.

The kvm-arm tree gained a conflict againste the kvm tree but lost its
build failure.

The tty tree gained a build failure so I used the version from
next-20140924.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 7659
 6700 files changed, 272952 insertions(+), 147695 deletions(-)

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
Merging origin/master (005f800508eb Merge branch 'drm-fixes' of git://peopl=
e.freedesktop.org/~airlied/linux)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (505013bc9065 ARM: 8149/1: perf: Don't sleep whil=
e atomic when enabling per-cpu interrupts)
Merging m68k-current/for-linus (4ed7800987b1 m68k: Wire up memfd_create)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/for-linus (7d59deb50aaf powerpc: Wire up sys_secc=
omp(), sys_getrandom() and sys_memfd_create())
Merging sparc/master (c21c4ab0d692 sparc64: Move request_irq() from ldc_bin=
d() to ldc_alloc())
Merging net/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec/master (b8c203b2d2fc xfrm: Generate queueing routes only from=
 route lookup functions)
Merging sound-current/for-linus (e76bf634870e ALSA: snd-usb-caiaq: Fix LED =
commands for Kore controller)
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
Merging input-current/for-linus (3049683eafdb Input: i8042 - fix Asus X450L=
CP touchpad detection)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (7da4b29d496b crypto: aesni - disable "by8" A=
VX CTR optimization)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (ce6a144a0d01 selftests/memfd: Run test on al=
l architectures)
Merging drm-intel-fixes/for-linux-next-fixes (c84db7701087 drm/i915/hdmi: f=
ix hdmi audio state readout)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (3a6755c85f2d ARC: [arcfpga] Get rid of ARC_BOARD_ANGE=
L4 and ARC_BOARD_ML509)
Merging arm/for-next (18cdbcb74636 Merge branches 'fiq' (early part), 'fixe=
s' and 'misc' into for-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (449171ae5a79 Merge branch 'next/drivers' into for=
-next)
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
Merging samsung/for-next (225a81cb54c7 Merge branch 'v3.18-next/dt-samsung-=
3' into for-next)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging sunxi/sunxi/for-next (429823087fec Merge branches 'sunxi/dt-for-3.1=
8' and 'sunxi/drivers-for-3.18' into sunxi/for-next)
Merging tegra/for-next (5599b9197647 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (1059c6bf8534 arm64: debug: don't re-enable deb=
ug exceptions on return from el1_dbg)
CONFLICT (content): Merge conflict in Documentation/networking/filter.txt
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0f33be009b89 Linux 3.17-rc6)
Merging m68k/for-next (9aa59cacdf22 m68k/atari - stram: Add missing #includ=
e <linux/ioport.h>)
Merging m68knommu/for-next (016371190da6 m68knommu: add missing ioport_map(=
) and ioport_unmap())
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (554336c714f4 microblaze: Use empty asm-generic/lin=
kage.h)
Merging mips/mips-for-linux-next (4b050ba7a66c MIPS: pgtable.h: Implement t=
he pgprot_writecombine function for MIPS)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (0f33be009b89 Linux 3.17-rc6)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging fsl/next (cb0446c1b625 Revert "powerpc/fsl_msi: spread msi ints acr=
oss different MSIRs")
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (722d92d38b22 s390/uprobes: architecture backend for =
uprobes)
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
Merging btrfs/next (1d52c78afbbf Btrfs: try not to ENOSPC on log replay)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (dbb6ba16f387 [SMB3] add defines for two new file att=
ributes)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (52362810bec8 ocfs2: Don't use MAXQUOTAS value)
Merging ext4/dev (f6e63f908099 ext4: fold ext4_nojournal_sops into ext4_sop=
s)
Merging f2fs/dev (9a41533c77ae f2fs: refactor flush_nat_entries to remove c=
ostly reorganizing ops)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (00a158be8383 GFS2: fix bad inode i_goal values during =
block allocation)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (5466112f0935 pnfs/blocklayout: Fix a 64-bit divisio=
n/remainder issue in bl_map_stripe)
Merging nfsd/nfsd-next (9d137dc5a4cb NFSD: Implement SEEK)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (b91671bb23a7 UBI: Fix livelock in produce_free_pe=
b())
Merging xfs/for-next (33044dc408e6 Merge branch 'xfs-misc-fixes-for-3.18-2'=
 into for-next)
Merging file-locks/linux-next (30d2cb15b781 locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
CONFLICT (content): Merge conflict in fs/locks.c
Merging vfs/for-next (bb4623448d40 vfs: move getname() from callers to do_m=
ount())
Merging pci/next (05cee99088e3 Merge branch 'pci/host-designware' into next)
Merging hid/for-next (968d080261db Merge branch 'for-3.18/wacom' into for-n=
ext)
Merging i2c/i2c/for-next (87b4a1dc4525 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (7ad8966f4f0a Merge tag 'mfd-hwmon-leds-wa=
tchdog-v3.18' into hwmon-next)
Merging v4l-dvb/master (204732b84f4b Merge soc_camera stuff from branch 'to=
pic/devel-3.17-rc6' into to_next)
Merging kbuild/for-next (04d29c44a5c9 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (ec489eb8e027 Merge branch 'for-3.18' into for-next)
Merging pm/linux-next (a5e05dbf2f33 Merge branch 'pm-sleep' into linux-next)
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
Merging slave-dma/next (7102fc6e82d3 Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (4daaab4f0c2b Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3xxx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188-radxarock.dts
Merging ipsec-next/master (689f1c9de2ab ipsec: Remove obsolete MAX_AH_AUTH_=
LEN)
Merging wireless-next/master (7a0a260a0f6f ath9k: enable ext channel pulse =
detection)
Merging bluetooth/master (c7da579763f2 Bluetooth: Add retransmission effort=
 into SCO parameter table)
Merging infiniband/for-next (3bdad2d13fa6 Merge branches 'core', 'ipoib', '=
iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (6d178ef2fd5e mtd: nand: Move ELM driver and rename a=
s omap_elm)
Merging crypto/master (26c3af6c1580 crypto: qat - Removed unneeded partial =
state)
Merging drm/drm-next (d743ecf36063 drm/doc: Fixup drm_irq kerneldoc include=
s.)
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (d37cf5f7e1b3 drm/i915/bdw: Cleanup pre pr=
od workarounds)
Merging drm-tegra/drm/tegra/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging sound/for-next (7a7686bd0d15 ALSA: ctxfi: sparse warning)
Merging sound-asoc/for-next (3fe316bb1da0 Merge remote-tracking branches 'a=
soc/topic/wm8978' and 'asoc/topic/wm8994' into asoc-next)
Merging modules/modules-next (184c3fc3f52f moduleparam: Resolve missing-fie=
ld-initializer warning)
Merging virtio/virtio-next (7ec62d421bdf Merge branch 'for_linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging input/next (042e1c79166b Input: soc_button_array - convert to platf=
orm bus)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (d9fdbe7c26ad fix merge error)
Merging device-mapper/for-next (bf6ee77f38b0 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (517bf80fe744 mmc: rtsx_pci: Set power related cap2 mac=
ros)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (b8cb6b4c121e md/raid1: fix_read_error should act on al=
l non-faulty devices.)
Merging mfd/for-mfd-next (420795acbd11 mfd: twl4030-power: Use 'ti,system-p=
ower-controller' as alternative way to support system power off)
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (fd642bb94c75 Merge tag 'tags/mfd-power-charger-regu=
lator-v3.18' into next)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (30296f61159e video: fbdev: use %*ph specifier t=
o dump small buffers)
Merging regulator/for-next (af14afaa4b64 Merge remote-tracking branch 'regu=
lator/topic/voltage-ev' into regulator-next)
Merging security/next (35e1efd25a9e Merge tag 'keys-next-20140922' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into next)
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging integrity/next (1b68bdf9cded ima: detect violations for mmaped file=
s)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (4c7c9da51c09 devicetree: Add Cadence WDT devicetre=
e bindings documentation)
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
Merging audit/master (9eab339b197a audit: get comm using lock to avoid race=
 in string printing)
CONFLICT (content): Merge conflict in arch/arm64/kernel/ptrace.c
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a9ecdc0fdc54 of/irq: Fix lookup to use =
'interrupts-extended' property first)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging mailbox/mailbox-for-next (29de0a1d6aa4 dt: mailbox: add generic bin=
dings)
Merging spi/for-next (3447e7e5b21d Merge remote-tracking branches 'spi/topi=
c/sh-msiof', 'spi/topic/sirf' and 'spi/topic/xilinx' into spi-next)
Merging tip/auto-latest (522606112014 Merge branch 'x86/vdso')
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdm.c deleted in HEA=
D and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/blockl=
ayout/blocklayoutdm.c left in tree.
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdev.c deleted in HE=
AD and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/block=
layout/blocklayoutdev.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_64.S
$ git rm -f fs/nfs/blocklayout/blocklayoutdev.c fs/nfs/blocklayout/blocklay=
outdm.c
Applying: pnfs: merge fixup for sched cleanup of set_current_state(TASK_RUN=
NING)
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (7981a28f1ab5 amd64_edac: Modify usage of amd64_r=
ead_dct_pci_cfg())
Merging irqchip/irqchip/for-next (1633cd9aed67 Merge branch 'irqchip/gic' i=
nto irqchip/for-next)
Merging tiny/tiny/next (3cf6b0151ba5 Merge branches 'tiny/bloat-o-meter-no-=
SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x=
86-boot-compressed-use-yn' into tiny/next)
Merging ftrace/for-next (7cbfb5eed983 Merge branch 'trace/ftrace/testing' i=
nto trace/for-next)
Merging rcu/rcu/next (dd56af42bd82 rcu: Eliminate deadlock between CPU hotp=
lug and expedited grace periods)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (3c3c29fd0d7c kvm-vfio: do not use module_init)
Merging kvm-arm/next (a98f26f18380 arm/arm64: KVM: vgic: make number of irq=
s a configurable attribute)
CONFLICT (content): Merge conflict in virt/kvm/eventfd.c
Merging kvm-ppc/kvm-ppc-next (8d0eff638564 KVM: PPC: Pass enum to kvmppc_ge=
t_last_inst)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (59119fad2954 xen-scsifront: don't deadlock if t=
he ring becomes full)
Merging percpu/for-next (92f4f5286667 Merge branch 'for-3.18' into for-next)
CONFLICT (content): Merge conflict in fs/ext4/super.c
Applying: percpu_counter: fix for ext4 updates
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (557b45497145 eeepc-laptop: clean up control f=
low in *_rfkill_notifier)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (402dd4061206 Merge remote-tracking branch 'regmap/=
topic/cache' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (0a2b4a843d32 Merge tag 'mfd-hwmon-leds-watchdog-v3.1=
8' into devel)
Merging ipmi/for-next (662d15871626 ipmi: Clear drvdata when interface is r=
emoved)
Merging driver-core/driver-core-next (bef59c5024be devres: Improve devm_kas=
printf()/kvasprintf() support)
Merging tty/tty-next (99416322dd16 tty: Workaround Alpha non-atomic byte st=
orage in tty_struct)
$ git reset --hard HEAD^
Merging next-20140924 version of tty
Merging usb/usb-next (638139eb95d2 usb: hub: allow to process more usb hub =
events in parallel)
CONFLICT (content): Merge conflict in drivers/usb/gadget/function/f_fs.c
Merging usb-gadget/next (72a65a0d19c1 Revert "usb: gadget: composite: deque=
ue cdev->req before free its buffer")
Merging usb-serial/usb-next (f8c0e057b489 USB: serial: remove zte_ev driver)
Merging staging/staging-next (368c75b98bdf staging: rtl8188eu: odm.h: Remov=
e unused struct dyn_primary_cca)
Merging char-misc/char-misc-next (046c7911b224 Drivers: hv: vmbus: Enable i=
nterrupt driven flow control)
Merging cgroup/for-next (4e1024b53102 Merge branch 'for-3.18' into for-next)
Merging scsi/for-next (a36a9a7ea09e Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
Merging target-updates/for-next (c435285df112 target: fix unused shift in c=
ore_scsi3_pri_report_capabilities)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (d3d6f7a8ad05 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (8c3270e13eb1 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (70145f87139f pwm: Fix uninitialized warnings in pwm_g=
et())
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (fee9d3e61d04 ktest: add ability to skip during BISE=
CT_MANUAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (a52ae5a755d9 Merge branch 'clk-fixes' into clk-next)
Merging random/dev (13aa93c70e71 random: add and use memzero_explicit() for=
 clearing data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (7be141d05549 Merge branch 'x86-urgent-for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging llvmlinux/for-next (7d4cd0ef629a arm64: LLVMLinux: Fix inline arm64=
 assembly for use with clang)
CONFLICT (content): Merge conflict in Makefile
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (68c7ed167ef5 Documentation: disable vdso_test to av=
oid breakage with old glibc)
CONFLICT (content): Merge conflict in Documentation/networking/timestamping=
/Makefile
Merging kselftest/next (69e273c0b0a3 Linux 3.17-rc3)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
Merging powerpc-mpe/next (fd0af3889b26 powerpc: Fix build failure when CONF=
IG_USB=3Dy)
Merging akpm-current/current (ff22a6f914a0 scripts/sortextable: suppress wa=
rning: `relocs_size' may be used uninitialized)
CONFLICT (content): Merge conflict in include/asm-generic/pgtable.h
CONFLICT (content): Merge conflict in drivers/clk/Kconfig
CONFLICT (content): Merge conflict in arch/arm64/mm/dma-mapping.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: arch/x86/kernel/cpu/common.c: fix unused symbol warning
Applying: lib/string.c: remove duplicated function
Applying: lib: string: Make all calls to strnicmp into calls to strncasecmp
Applying: ARM: replace strnicmp with strncasecmp
Applying: block: replace strnicmp with strncasecmp
Applying: netfilter: replace strnicmp with strncasecmp
Applying: video: fbdev: replace strnicmp with strncasecmp
Applying: cifs: replace strnicmp with strncasecmp
Applying: ocfs2: replace strnicmp with strncasecmp
Applying: isofs: replace strnicmp with strncasecmp
Applying: batman-adv: replace strnicmp with strncasecmp
Applying: ACPI/battery: replace strnicmp with strncasecmp
Applying: cpufreq: replace strnicmp with strncasecmp
Applying: cpuidle: replace strnicmp with strncasecmp
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
Applying: frv: remove unused declarations of __start___ex_table and __stop_=
__ex_table
Applying: ia64: remove duplicate declarations of __per_cpu_start[] and __pe=
r_cpu_end[]
Applying: kernel/param: consolidate __{start,stop}___param[] in <linux/modu=
leparam.h>
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
Merging akpm/master (48100ca81dfc mm: add strictlimit knob)

--Sig_/C0LijmJNNbW3xo5wI.2xqf.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUI9OFAAoJEMDTa8Ir7ZwV/qwP/2xt0SZyWS3Rd48ubyq/8VSf
nNDJIKkVecfVa/on++hOYSUtomN9+NvsnlXcn/d3NalPYqvE6ywKAQAf0wfOOL2W
L8iRE77j4T5VA3G57KdeRUj7PyvXJQ4RCn/j240sZ9iSg/qe85TxEgT699fnlXi5
/VByf6f/J5d84h2CNicn3Fmo+nwkAvuw+RZI3HWD+bPkHggFcNznMM9eIHxSRENS
9yFlpfwSCyajgNYIFBTulQATkqHsfWXjNA8qVdmt0wHEegDIGHTWqLSkf1+/OCMC
k3+EpSsj6dxYE8soG0UImb1ZHeIIOzYg6YEfhUwne2j8yiG3MuxK5bObvHD/ilN6
kRm6cnsTl0x9ozLXLu3Z4yD1g3k4RMX0oCGRqz73l/23zEMcp+bPK6H3ORMOFYbG
8S2HqV2why+J2vwLvxsaODVZTf8Flt0udkQSeOuwDVOeYnkKA3UxMgGlZR2bWLNt
2A/wB7b4pF2ifaOerTdO7M3tmuEYWDHQS9Tpv52eZyyWRIu5PoVmXbxNkxup/lji
SLKBAGfe27BfEAMoGE4hlLKNuMhwj/hsyYkqzTZ75269w+FiMZMsQx/vMcO6KFoF
aZjRYVbOirUMGGIPFZWWvysnLAYNgeJGvf26QqLDIDyEW/w3FIjTAaspw8+RL2N6
lhW4pMwVO7GNBe3ANWj6
=uyOX
-----END PGP SIGNATURE-----

--Sig_/C0LijmJNNbW3xo5wI.2xqf.--
