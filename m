Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaIHJxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:53:23 -0400
Received: from ozlabs.org ([103.22.144.67]:42531 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbaIHJxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:53:18 -0400
Date: Mon, 8 Sep 2014 19:53:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 8
Message-ID: <20140908195309.1d883a30@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AhyoO+gAPk+fddSg4WE3I4O"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AhyoO+gAPk+fddSg4WE3I4O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140905:

The drm tree gained a build failure for which I applied a merge fix patch.

The drm-intel tree gained a conflict against Linus' tree.

The wireless-next tree gained a build failure for which I applied a
suggested fix patch.

The integrity tree gained a conflict against the nfsd tree.

The regulator tree gained a build failure for which I reverted several
commits.

The kvm-arm tree gained a conflict against the kvm tree.

The percpu tree gained a conflict against the ext4 tree.

The usb-gadget tree with the usb.current and Linus' trees.

The staging tree lost its build failur

The rd-docs tree gained a conflict against the net-next tree.

The akpm-current tree gained a conflict against the rcu tree and a build
failure for which I applied a fix patch.

Non-merge commits (relative to Linus' tree): 3868
 3692 files changed, 113322 insertions(+), 80981 deletions(-)

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

I am currently merging 220 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (2ce7598c9a45 Linux 3.17-rc4)
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
Merging sparc/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
Merging net/master (45ce829dd010 Merge tag 'master-2014-09-04' of git://git=
.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (2d39d120781a mvneta: Add missing if_vlan.h include.)
Merging sound-current/for-linus (05244d166739 Merge tag 'asoc-v3.17-rc3' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (fd7155fc9fca Merge branch 'pci/host-imx6' in=
to for-linus)
Merging wireless/master (1bd3fa7b8c9b Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (69e273c0b0a3 Linux 3.17-rc3)
Merging tty.current/tty-linus (69e273c0b0a3 Linux 3.17-rc3)
Merging usb.current/usb-linus (6fa9e1be7f28 usb: usbip: fix usbip.h path in=
 userspace tool)
Merging usb-gadget-fixes/fixes (9ce9ec95fb9b usb: phy: tegra: Avoid use of =
sizeof(void))
Merging usb-serial-fixes/usb-linus (5b3da69285c1 USB: sierra: add 1199:68AA=
 device ID)
Merging staging.current/staging-linus (69e273c0b0a3 Linux 3.17-rc3)
Merging char-misc.current/char-misc-linus (69e273c0b0a3 Linux 3.17-rc3)
Merging input-current/for-linus (a2418fc4a13b Input: elantech - add support=
 for trackpoint found on some v3 models)
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
Merging drm-intel-fixes/for-linux-next-fixes (be71eabebaf9 Revert "drm/i915=
: Enable semaphores on BDW")
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (2a5e95d4181c mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (f58d5ede6aa0 Merge branch 'swp' (early part) into for=
-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (b9055140791c Merge fixes branch into for-next)
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
Merging mvebu/for-next (74328d67b001 Merge branch 'mvebu/defconfig' into mv=
ebu/for-next)
Merging renesas/next (f915a4a5ec39 Merge branch 'heads/soc-for-v3.18' into =
next)
Merging samsung/for-next (213e1f6f5f0b Merge branch 'v3.18-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (779b646c8102 Merge branch 'sunxi/dt-for-3.18'=
 into sunxi/for-next)
Merging tegra/for-next (264a6086e257 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (ea1719672f59 arm64: add newline to I-cache pol=
icy string)
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
Merging microblaze/next (e8bbef945111 arch/microblaze/include/asm/uaccess.h=
: Use pr_devel() instead of pr_debug())
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
Merging s390/features (3d61088c3f4e s390/ftrace: optimize mcount code)
Merging sparc-next/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git=
://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
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
Merging ext3/for_next (e6d8fb340f20 ext3: Count internal journal as bsddf o=
verhead in ext3_statfs)
Merging ext4/dev (a49058fab291 jbd/jbd2: use non-movable memory for the jbd=
 superblock)
Merging f2fs/dev (5b1cbad35380 f2fs: need fsck.f2fs if the recovery was fai=
led)
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
Merging nfs/linux-next (7505ceaf8635 Merge branch 'irq-urgent-for-linus' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging nfsd/nfsd-next (8ce9282997ff NFSD: Put export if prepare_creds() fa=
il)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (25601a3c9737 UBIFS: Add log overlap assertions)
Merging xfs/for-next (41b9d7263ea1 xfs: trim eofblocks before collapse rang=
e)
Merging file-locks/linux-next (24b496fa31b8 locks: remove lock_may_read and=
 lock_may_write)
Merging vfs/for-next (7b0527f875b1 fs: namespace: suppress 'may be used uni=
nitialized' warnings)
Merging pci/next (a2351efeb3b4 Merge branches 'pci/misc', 'pci/pm', 'pci/ho=
st-designware', 'pci/host-imx6', 'pci/host-keystone', 'pci/host-tegra' and =
'pci/host-xilinx' into next)
Merging hid/for-next (d24a153f27e1 Merge branch 'for-3.18/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (91bfe2989af0 Revert "i2c: rcar: remove spinlock")
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (ce95e1886a5f MAINTAINERS: add entry for t=
he PWM fan driver)
Merging v4l-dvb/master (d1352f268415 Merge two fixes from branch 'patchwork=
' into to_next)
Merging kbuild/for-next (c7377ed8b9eb Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (9b8a2d2b9a97 Merge branch 'for-3.17-fixes' into fo=
r-next)
Merging pm/linux-next (3a23ab231c23 Merge branches 'acpi-video-next' and 'a=
cpi-fan' into linux-next)
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
Merging net-next/master (97a13e5289ba net: phy: mdio-sun4i: don't select RE=
GULATOR)
Merging ipsec-next/master (880a6fab8f6b xfrm: configure policy hash table t=
hresholds by netlink)
Merging wireless-next/master (db906eb2101b ath5k: added debugfs file for du=
mping eeprom)
Merging bluetooth/master (7986a2c66499 Bluetooth: Fix dereferencing conn va=
riable before NULL check)
CONFLICT (content): Merge conflict in net/bluetooth/hci_event.c
CONFLICT (content): Merge conflict in net/bluetooth/hci_core.c
CONFLICT (content): Merge conflict in net/bluetooth/hci_conn.c
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
Merging drm-intel/for-linux-next (9c787942907f drm/i915: Decouple the stuck=
 pageflip on modeset)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/tegra/for-next (ef70728c7a65 drm/tegra: add MODULE_DE=
VICE_TABLEs)
Merging sound/for-next (d89c6c0c91af ALSA: hda - Add TLV_DB_SCALE_MUTE bit =
for relevant controls)
Merging sound-asoc/for-next (973ad6b22b32 Merge remote-tracking branches 'a=
soc/topic/tlv320aic31xx', 'asoc/topic/txx9', 'asoc/topic/wm8978' and 'asoc/=
topic/wm8994' into asoc-next)
Merging modules/modules-next (480cadc2b7e0 scsi: Fix qemu boot hang problem)
Merging virtio/virtio-next (480cadc2b7e0 scsi: Fix qemu boot hang problem)
Merging input/next (017f14e88bf1 Input: cros_ec_keyb - optimize ghosting al=
gorithm)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (f37513ea97f9 Merge branch 'for-linus' into for-next)
Merging device-mapper/for-next (e8531a5cbbd9 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (f01561613d79 mmc: sdhci: check 1.2v IO capability for =
SDHC host)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (90c25a429b62 md/raid5: fix init_stripe() inconsistenci=
es)
Merging mfd/for-mfd-next (c0adbe5f2774 mfd: pcf50633: Use sprintf directly)
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (5e37195f30cc ipaq_micro_battery: fix sparse non sta=
tic symbol warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (58678a77029b video: fbdev: au1200fb: delete dou=
ble assignment)
Merging regulator/for-next (922dc237d935 Merge remote-tracking branches 're=
gulator/topic/tps65910' and 'regulator/topic/voltage-ev' into regulator-nex=
t)
Merging security/next (a0cfd75fdc46 seccomp: Add reviewers to MAINTAINERS)
Merging integrity/next (e8442e203c25 ima: pass 'opened' flag to identify ne=
wly created files)
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging selinux/next (a7a91a1928fe selinux: fix a problem with IPv6 traffic=
 denials in selinux_ip_postroute())
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8083baba5e9c wdt: sunxi: Move restart code to the =
watchdog driver)
Merging iommu/next (f55c86642759 Merge branches 'iommu/fixes', 'arm/exynos'=
, 'arm/omap', 'x86/vt-d' and 'x86/amd' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (9b936c960f22 drivers/vfio: Enable VFIO if EEH is not sup=
ported)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (7d75a871888e gpio: fix 'CONFIG_GPIO_IRQCHIP' comm=
ents)
Merging audit/master (451fd72219dd Merge tag 'pwm/for-3.17-rc2' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a9ecdc0fdc54 of/irq: Fix lookup to use =
'interrupts-extended' property first)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (9e928f8a162e Merge remote-tracking branches 'spi/topi=
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
Merging percpu/for-next (7616242b3cc8 Merge branch 'for-3.18' into for-next)
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
Merging regmap/for-next (0a03509d8bcd Merge remote-tracking branch 'regmap/=
topic/dt-endian' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (3f6815f711ef leds: lp3944: fix sparse warning)
CONFLICT (content): Merge conflict in include/linux/leds.h
CONFLICT (content): Merge conflict in drivers/leds/led-core.c
CONFLICT (content): Merge conflict in drivers/leds/led-class.c
Merging driver-core/driver-core-next (69e273c0b0a3 Linux 3.17-rc3)
Merging tty/tty-next (69e273c0b0a3 Linux 3.17-rc3)
Merging usb/usb-next (69e273c0b0a3 Linux 3.17-rc3)
Merging usb-gadget/next (2c4cbe6e5a9c usb: dwc3: add tracepoints to aid deb=
ugging)
CONFLICT (modify/delete): drivers/usb/phy/phy-samsung-usb.h deleted in usb-=
gadget/next and modified in HEAD. Version HEAD of drivers/usb/phy/phy-samsu=
ng-usb.h left in tree.
CONFLICT (content): Merge conflict in drivers/usb/phy/phy-mxs-usb.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/legacy/Makefile
CONFLICT (content): Merge conflict in drivers/usb/gadget/function/Makefile
CONFLICT (content): Merge conflict in drivers/usb/gadget/Makefile
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/usb=
/mxs-phy.txt
$ git rm -f drivers/usb/phy/phy-samsung-usb.h
Merging usb-serial/usb-next (adceac14166d usb: serial: xsens_mt: always bin=
d to interface number 1)
Merging staging/staging-next (8fa74ef2fc0b staging/lustre: Different protot=
ypes between the declaration and the definition)
Merging char-misc/char-misc-next (69e273c0b0a3 Linux 3.17-rc3)
Merging cgroup/for-next (fd2443519da9 Merge branch 'for-3.17-fixes' into fo=
r-next)
Merging scsi/for-next (bc215e400856 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
Merging target-updates/for-next (df7c3d7ba056 target: target_core_ua_h: Add=
 #define of include guard)
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
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (16eeaec77922 clk: at91: fix div by zero in USB clock =
driver)
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
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
[master 64d37247bb37] Revert "regulator: RK808: Add proper input supplies f=
or rk808"
[master 1a97f328fee1] Revert "regulator: rk808: Fix n_voltages for DCDC4"
[master 2d691fceeedb] Revert "regulator: rk808: Fix memory leak"
[master 72ef12c7fc4d] Revert "regulator: rk808: remove redundant code"
[master 4f282175b294] Revert "regulator: RK808: modify for struct rk808 cha=
nge"
[master 2d728b7e66f8] Revert "regulator: rk808: Fix uninitialized value"
[master f3a50e55d03f] Revert "regulator: RK808: Add regulator driver for RK=
808"
Applying: ath5k: fix debugfs addition
Merging akpm-current/current (48bf1d725b18 scripts/headers_install.sh: fix =
error handling)
CONFLICT (content): Merge conflict in scripts/checkpatch.pl
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in drivers/clk/rockchip/clk.h
CONFLICT (content): Merge conflict in drivers/clk/rockchip/clk.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: x86, vdso: fix vdso2c's special_pages error checking
Applying: include/linux: remove strict_strto* definitions
Applying: lib / string_helpers: move documentation to c-file
Applying: lib / string_helpers: refactoring the test suite
Applying: lib / string_helpers: introduce string_escape_mem()
Applying: lib/vsprintf: add %*pE[achnops] format specifier
Applying: lib-vsprintf-add-%pe-format-specifier-fix
Applying: wireless: libertas: print esaped string via %*pE
Applying: wireless: ipw2x00: print SSID via %*pE
Applying: wireless: hostap: proc: print properly escaped SSID
Applying: lib80211: remove unused print_ssid()
Applying: staging: wlan-ng: use %*pEhp to print SN
Applying: staging: rtl8192e: use %*pEn to escape buffer
Applying: staging: rtl8192u: use %*pEn to escape buffer
Applying: kernel/watchdog.c: control hard lockup detection default
Applying: watchdog-control-hard-lockup-detection-default-fix
Applying: watchdog, nmi: Fix compile issues on sparc
Applying: kvm: ensure hard lockup detection is disabled by default
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
Merging akpm/master (ecadc1390a48 mm: add strictlimit knob)
Applying: mm: introduce dump_vma fix 2

--Sig_/AhyoO+gAPk+fddSg4WE3I4O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDXyKAAoJEMDTa8Ir7ZwVR3kP/2cR5fQMLJ5nNzbt9crUsfBn
1B0k3Bh5ryUyqI7pJYABSvnNIxPMcgmKD7iZi+tFhMKVLTqlALMj/LYqOdaqLfFx
gXcCGcgkZPXma0MgCDzGBAXlIl6NcPKm/VVwvUPFA6UkNr/ob629P/DdJR8AtcYo
Bizj2RcafZqTJExpbtRfyF0iZU73L1dWwRoxaPUoObXapgOPGYc2HiqhhDqsbC+9
I17VY0/bJkqQBMRNM7bYe4wrYEt8aOee+Fp5RJQgw2eTs0NxqORQPDqqwgvzdopf
XG01gnCNGRz3GkrAAWlCYMA2fVAUat11tSVgXVS9OPkSnf/VKCBTjM8RFjSQJ2i7
oamdUH8R6eDwfwGH7JXrE1acuZXlacEU5WakhVZ4c/4DqBm64u50eeBFbsRpU+CF
A/gtsfKojW5/MVaQGVXXXTzibOqUtihHXpYwkRuQ4J28mTbXX+ORXS0vCXi6NtF4
k7i4ijDmXoiITNLEx/f+NYpq1gtaE/CkRnxLZB3SMm9zuqUiCAsmCpSPGWfeKObx
VsujEy+K6vLeC7VWH4jIcSbw9Q34oi/Of6ZosT2OD6jHvs5Z5jmrqKmHqScKd03S
h4TGOqC1ZPPja2wuwKwCyEGKrmu/J29dIMo6sTmRzhXCEssgyn9bYUDE689d330k
Zrq6Hmk0KCkxf0Euuhvw
=0Xps
-----END PGP SIGNATURE-----

--Sig_/AhyoO+gAPk+fddSg4WE3I4O--
