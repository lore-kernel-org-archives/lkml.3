Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbbAWHKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:10:42 -0500
Received: from ozlabs.org ([103.22.144.67]:40566 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbbAWHKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:10:38 -0500
Date: Fri, 23 Jan 2015 18:10:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jan 23
Message-ID: <20150123181029.35e688d1@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ut3+mZZFb6AaYHUW6z_5xsD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ut3+mZZFb6AaYHUW6z_5xsD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

There will be no linux-next release on Monday (next-20150126).

Changes since 20150122:

Added tree:	kvms390
Removed tree:	documentation (at maintainers request)

The vfs tree gained a conflict against Linus' tree.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 4500
 4390 files changed, 174556 insertions(+), 78123 deletions(-)

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

I am currently merging 206 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (f8de05ca38b7 Merge branch 'for-linus' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/s390/linux)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (a16c5f99a28c kbuild: Fix removal of the de=
bian/ directory)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (909ba297beb5 ARM: 8292/1: mm: fix size rounding-=
down of arm_add_memory() function)
Merging m68k-current/for-linus (f27bd5bfeda5 m68k: Wire up execveat)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (0eb13208aa16 powerpc/powernv: Restore LPCR=
 with LPCR_PECE1 cleared)
Merging sparc/master (66d0f7ec9f10 sparc32: destroy_context() and switch_mm=
() needs to disable interrupts.)
Merging net/master (06efe0e54018 Merge tag 'pinctrl-v3.19-3' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl)
Merging ipsec/master (f855691975bb xfrm6: Fix the nexthdr offset in _decode=
_session6.)
Merging sound-current/for-linus (6455931186bf ALSA: usb-audio: Add mic volu=
me fix quirk for Logitech Webcam C210)
Merging pci-current/for-linus (d63e2e1f3df9 sparc/PCI: Clip bridge windows =
to fit in upstream windows)
Merging wireless-drivers/master (e3f31175a3ee ath9k: fix race condition in =
irq processing during hardware reset)
Merging driver-core.current/driver-core-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging tty.current/tty-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging usb.current/usb-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging usb-gadget-fixes/fixes (0df8fc37f6e4 usb: phy: never defer probe in=
 non-OF case)
Merging usb-serial-fixes/usb-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging staging.current/staging-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging char-misc.current/char-misc-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging input-current/for-linus (1d90d6d5522b Input: i8042 - add noloop qui=
rk for Medion Akoya E7225 (MD98857))
Merging crypto-current/master (3e14dcf7cb80 crypto: add missing crypto modu=
le aliases)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging devicetree-current/devicetree/merge (15204ab1ebc5 of/platform: Hand=
le of_populate drivers in notifier)
Merging rr-fixes/fixes (d5db139ab376 module: make module_refcount() a signe=
d integer.)
Merging vfio-fixes/for-linus (7c2e211f3c95 vfio-pci: Fix the check on pci d=
evice type in vfio_pci_probe())
Merging kselftest-fixes/fixes (f5db310d77ef selftests/vm: fix link error fo=
r transhuge-stress test)
Merging drm-intel-fixes/for-linux-next-fixes (78f4e4767cdd drm/i915: BDW Fi=
x Halo PCI IDs marked as ULT.)
Merging asm-generic/master (643165c8bbc8 Merge tag 'uaccess_for_upstream' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost into asm-generic)
Merging arc/for-next (5840adceb962 arc: Remove unused prepare_to_copy())
Merging arm/for-next (292c11f80cc8 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (97bf6af1f928 Linux 3.19-rc1)
Merging arm-soc/for-next (2519b215acdb arm-soc: document merges)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (8553bf8fd181 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (e799b6f37e6c ARM: zImage: add support for ARMv7-=
M)
Merging imx-mxs/for-next (395ae1400a35 Merge branch 'imx/defconfig' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging mvebu/for-next (cd3892730fbc Merge branch 'mvebu/defconfig' into mv=
ebu/for-next)
Merging omap/for-next (1c8bb3d4958b Merge tag 'omap-for-v3.20/dt-pt2' into =
for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging omap-pending/for-next (30aa18d3bea5 MAINTAINERS: add maintainer for=
 OMAP hwmod data)
Merging renesas/next (a2ff84f3871a Merge branches 'heads/soc-fixes-for-v3.1=
9', 'heads/soc-for-v3.20', 'heads/dt-for-v3.20', 'heads/dt-cleanups2-for-v3=
.20' and 'heads/sh73a0-ccf-for-v3.20' into next)
Merging samsung/for-next (9663ad71912b Merge branch 'v3.20-next/update-sams=
ung' into for-next)
Merging sunxi/sunxi/for-next (16e8c17e18d6 Merge branch 'sunxi/clocks-for-3=
.20' into sunxi/for-next)
Merging tegra/for-next (4fd40ac71480 Merge branch for-3.20/soc into for-nex=
t)
Merging arm64/for-next/core (60305db98845 arm64/efi: move virtmap init to e=
arly initcall)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (79a8480adf0e CRIS: Fix missing NR_CPUS in menuconfig)
Merging hexagon/linux-next (8914d7e85780 Hexagon: fix signal delivery for d=
ebug traps)
Merging ia64/next (a6b8978c54b7 pstore: Fix sprintf format specifier in pst=
ore_dump())
Merging m68k/for-next (87511d09206d m68k/atari: Remove obsolete IRQ_TYPE_*)
Merging m68knommu/for-next (8d84d4aaf311 arch: m68k: 68360: config: Remove =
unused function)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (51cae8bfe7dd microblaze: Remove generated *.dtb fi=
les from dts)
Merging mips/mips-for-linux-next (86f9f1e287be Merge branch '3.19-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (d24c8163b755 nios2: fix kuser trampoline address)
Merging parisc-hd/for-next (b2776bf7149b Linux 3.18)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (62fa19d4b4fd cxl: Add ability to reset the card)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (55b5eb75e7cc s390/tape: remove redundant if statemen=
t)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (b9f705758a4f tile: enable sparse checks for get/put_us=
er)
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
Merging cifs/for-next (ca7df8e0bb2a Complete oplock break jobs before closi=
ng file handle)
Merging ecryptfs/next (e7a823be2adc Merge tag 'linux-kselftest-3.19-rc-5' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest)
Merging ext3/for_next (a39427007e7c xfs: Remove some pointless quota checks)
Merging ext4/dev (4033d19d28ab ext4: add optimization for the lazytime moun=
t option)
Merging f2fs/dev (3857cef8022d f2fs: update memory footprint information)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (9759bd518994 fuse: add memory barrier to INIT)
Merging gfs2/master (3566c9647678 GFS2: fix sprintf format specifier)
Merging jfs/jfs-next (e1f1fe798d2f jfs: get rid of homegrown endianness hel=
pers)
Merging nfs/linux-next (2ef47eb1aee1 NFS: Fix use of nfs_attr_use_mounted_o=
n_fileid())
Merging nfsd/nfsd-next (0ec016e3e02f nfsd4: tweak rd_dircount accounting)
Merging overlayfs/overlayfs-next (4330397e4e8a ovl: discard independent cur=
sor in readdir())
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (438c3c8d2bb9 Merge branch 'xfs-buf-type-fixes' into f=
or-next)
Merging file-locks/linux-next (8116bf4cb62d locks: update comments that ref=
er to inode->i_flock)
Merging vfs/for-next (9ee4c48a1ec6 Merge branch 'getname' into for-next)
CONFLICT (content): Merge conflict in kernel/auditsc.c
Merging pci/next (75f30c3d9949 Merge branches 'pci/host-keystone', 'pci/hos=
t-layerscape', 'pci/host-rcar' and 'pci/host-tegra' into next)
Merging hid/for-next (8f8ccef0d168 Merge branch 'for-3.20/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (789d10deed25 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (100b661929a0 hwmon: (abx500) Fix format s=
tring warnings)
Merging v4l-dvb/master (a5f23e34da02 Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (5ea04a1a0860 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (b2a6e50231ef Merge branch 'for-3.20' into for-next)
Merging pm/linux-next (a0442ec0b0ab Merge branch 'pnp' into linux-next)
Merging idle/next (f7c0e22f2d14 Merge branch 'turbostat' into release)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging thermal/next (f67744c4d91e Merge branch 'thermal-soc' of .git into =
next)
Merging thermal-soc/next (1813d8087469 thermal: rcar: Spelling/grammar: s/d=
rier use .../driver uses ...s/)
Merging ieee1394/for-next (b625a825955e firewire: ohci: Remove unused funct=
ion)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (8686abe3553b Merge branch 'topic/rcar' into next)
Merging net-next/master (0c49087462e8 Merge tag 'mac80211-next-for-davem-20=
15-01-19' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-n=
ext)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/stih410.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/stih407-family.dtsi
Merging ipsec-next/master (78890ed75494 csiostor:fix sparse warnings)
Merging wireless-drivers-next/master (6b03e32d5759 Merge commit 'c1e140bf79=
d817d4a7aa9932eb98b0359c87af33' from mac80211-next)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/scan=
.c
Merging bluetooth/master (ed93ec69c7e0 Bluetooth: Require SSP enabling befo=
re BR/EDR Secure Connections)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (240181fd0ffa mtd: nand: default bitflip-reporting th=
reshold to 75% of correction strength)
Merging crypto/master (379dcfb40600 crypto: doc - remove colons in comments)
Merging drm/drm-next (281d1bbd34b7 Merge remote-tracking branch 'origin/mas=
ter' into drm-next)
Merging drm-panel/drm/panel/for-next (2d0853a33fda drm/panel: sharp: lq101r=
1sx01: Remove unneeded include)
Merging drm-intel/for-linux-next (db1612734398 drm/i915: Change VLV WIZ has=
hing mode to 16x4)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (b77037262511 drm/probe-helper: clamp unk=
nown connector status in the poll work)
Merging sound/for-next (b4b33f9d64c3 ALSA: hda - Enable docking station for=
 an HP machine)
Merging sound-asoc/for-next (f3ec1b8506f9 Merge remote-tracking branches 'a=
soc/topic/wm8804', 'asoc/topic/wm8960', 'asoc/topic/wm8988' and 'asoc/topic=
/xtfpga' into asoc-next)
Merging modules/modules-next (97bf6af1f928 Linux 3.19-rc1)
Merging virtio/virtio-next (76545f066d2a virtio_pci_modern: drop an unused =
function)
Merging input/next (e719963c4a71 Input: elantech - remove stale comment fro=
m Kconfig)
Merging block/for-next (7ff161aaf12a Merge branch 'for-3.20/bdi' into for-n=
ext)
CONFLICT (content): Merge conflict in drivers/mtd/mtdcore.c
Merging device-mapper/for-next (6a55c9861326 block: keep established cmd_fl=
ags when cloning into a blk-mq request)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (fe1922d5d4d0 mmc: pwrseq_simple: Add support for a res=
et GPIO pin)
CONFLICT (content): Merge conflict in drivers/mmc/host/sunxi-mmc.c
Merging kgdb/kgdb-next (c7d9ebf81c45 kdb: Fix off by one error in kdb_cpu())
Merging md/for-next (f851b60db0fd md: Check MD_RECOVERY_RUNNING as well as =
->sync_thread.)
Merging mfd/for-mfd-next (bb400d2120bd mfd: rtsx_usb: Defer autosuspend whi=
le card exists)
Merging backlight/for-backlight-next (3d6969a641d0 MAINTAINERS: Remove my n=
ame from Backlight subsystem)
Merging battery/master (24d3b15a1844 Add devicetree binding documentation f=
or the LTC2941/LTC2943 driver)
Merging omap_dss2/for-next (7efc436cd45c Merge branches '3.20/fbdev' and '3=
.20/omapdss' into for-next)
Merging regulator/for-next (4311c370311a Merge remote-tracking branches 're=
gulator/topic/pfuze100', 'regulator/topic/rk808', 'regulator/topic/rt5033' =
and 'regulator/topic/tps65023' into regulator-next)
Merging security/next (961be7ef6963 tpm/tpm_tis: Add missing ifdef CONFIG_A=
CPI for pnp_acpi_device)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (0307dadc924d selinux: add security in-core xattr supp=
ort for pstore and debugfs)
Merging lblnet/next (b2776bf7149b Linux 3.18)
Merging watchdog/master (e0c3e00f4045 watchdog: drop owner assignment from =
platform_drivers)
Merging iommu/next (9bbb0ea981e9 Merge branches 'arm/renesas' and 'core' in=
to next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (174236285cf8 Merge branch 'doc/sp-update' into d=
ocs-next)
Merging trivial/for-next (2d04ed422d38 MODSIGN: /proc/keys is not unconditi=
onally available)
Merging audit/next (2fded7f44b8f audit: remove vestiges of vers_ops)
Merging devicetree/devicetree/next (fca8ba4ee24d of/unittest: Remove obsole=
te code)
Merging dt-rh/for-next (e94fbe607f8c dt-bindings: use isil prefix for Inter=
sil in vendor-prefixes.txt)
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (2cdb41c84a4e Merge remote-tracking branches 'spi/topi=
c/sirf' and 'spi/topic/st-ssc' into spi-next)
Merging tip/auto-latest (4692b98fe5dc Merge branch 'x86/ras')
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
Merging rcu/rcu/next (0cf8c85d7791 rcu_tree: Avoid touching rnp->completed =
when a new GP is started)
Merging kvm/linux-next (bab5bb398273 kvm: x86: Remove kvm_make_request from=
 lapic.c)
Merging kvm-arm/next (4fa96afd94a9 arm/arm64: KVM: force alignment of VGIC =
dist/CPU/redist addresses)
CONFLICT (content): Merge conflict in arch/arm64/kvm/handle_exit.c
CONFLICT (content): Merge conflict in arch/arm64/kvm/Kconfig
CONFLICT (content): Merge conflict in arch/arm64/include/asm/kvm_arm.h
CONFLICT (content): Merge conflict in arch/arm/kvm/Kconfig
Applying: linux-next: manual merge of the kvm-arm tree with the arm64 tree
Merging kvm-ppc/kvm-ppc-next (2c4aa55a6af0 Merge tag 'signed-kvm-ppc-next' =
of git://github.com/agraf/linux-2.6 into HEAD)
Merging kvms390/next (fa124d35ba19 KVM: s390: remove redundant setting of i=
nterrupt type)
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
Merging percpu/for-next (4c907baf36d8 percpu_ref: implement percpu_ref_is_d=
ying())
Merging workqueues/for-next (b5b3ab523e31 Merge branch 'for-3.19-fixes' int=
o for-next)
Merging drivers-x86/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging regmap/for-next (270ded427d7b Merge remote-tracking branch 'regmap/=
topic/core' into regmap-next)
Merging hsi/for-next (67e9a2ce6e07 hsi: nokia-modem: fix uninitialized devi=
ce pointer)
Merging leds/for-next (452bc149947b leds: leds-mc13783: Use of_get_child_by=
_name() instead of refcount hack)
Merging ipmi/for-next (b942c653ae26 Merge tag 'trace-sh-3.19' of git://git.=
kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging driver-core/driver-core-next (ec6f34e5b552 Linux 3.19-rc5)
Merging tty/tty-next (61b6b7fbda1b Merge 3.19-rc5 into tty-next)
Merging usb/usb-next (0e08365f0b48 Merge 3.19-rc5 into usb-next)
Merging usb-gadget/next (d1fc4440d761 Merge tag 'v3.19-rc5' into next)
Merging usb-serial/usb-next (3e264ffc831e USB: mos7840: remove unused code)
Merging staging/staging-next (484c60e206b0 Merge 3.19-rc5 into staging-next)
Merging char-misc/char-misc-next (3542f6b1836d Merge 3.19-rc5 into char-mis=
c-next)
CONFLICT (content): Merge conflict in drivers/char/mem.c
Merging cgroup/for-next (8abba61bcfd4 Merge branch 'for-3.19-fixes' into fo=
r-next)
Merging scsi/for-next (7f258fb2288a Merge branch 'fixes' into for-next)
Merging target-updates/for-next (ecc3f3edbfb6 ib_srpt: wait_for_completion_=
timeout does not return negative status)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging pinctrl/for-next (5b46452f5ba2 Merge branch 'devel' into for-next)
Merging vhost/linux-next (eaa27f34e91a linux 3.19-rc4)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (ecc8fb35a6a2 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (6a6bdf52a3c4 pwm: sunxi: document OF bindings)
Merging dma-buf/for-next (4eb2440ed60f reservation: Remove shadowing local =
variable 'ret')
Merging userns/for-next (db86da7cb76f userns: Unbreak the unprivileged remo=
unt tests)
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging clk/clk-next (ec6415dc4160 ARM: clk: add clk-asm9260 driver)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging aio/master (5f785de58873 aio: Skip timer for io_getevents if timeou=
t=3D0)
Merging llvmlinux/for-next (25d4aee23af2 arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging kselftest/next (97bf6af1f928 Linux 3.19-rc1)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
Merging luto-misc/next (188c901941ef Merge branch 'leds-fixes-for-3.19' of =
git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging access_once/linux-next (c5b19946eb76 kernel: Fix sparse warning for=
 ACCESS_ONCE)
Merging livepatching/for-next (dbed7ddab967 livepatch: fix uninitialized re=
turn value)
Merging akpm-current/current (237fd69c2a5f ipc,sem: use current->state help=
ers)
CONFLICT (content): Merge conflict in mm/swap.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: rtc: isl12022: deprecate use of isl in compatible string for isil
Applying: rtc: isl12057: deprecate use of isl in compatible string for isil
Applying: staging: iio: isl29028: deprecate use of isl in compatible string=
 for isil
Applying: arm: dts: zynq: update isl9305 compatible string to use isil vend=
or prefix
Applying: MAINTAINERS: add git url entry for UIO
Applying: mm: fix XIP fault vs truncate race
Applying: mm-fix-xip-fault-vs-truncate-race-fix
Applying: mm-fix-xip-fault-vs-truncate-race-fix-fix
Applying: mm: allow page fault handlers to perform the COW
Applying: mm-allow-page-fault-handlers-to-perform-the-cow-fix
Applying: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3
Applying: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix
Applying: vfs,ext2: introduce IS_DAX(inode)
Applying: dax,ext2: replace XIP read and write with DAX I/O
Applying: dax,ext2: replace ext2_clear_xip_target with dax_clear_blocks
Applying: dax,ext2: replace the XIP page fault handler with the DAX page fa=
ult handler
Applying: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-faul=
t-handler-fix
Applying: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-faul=
t-handler-fix-2
Applying: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-faul=
t-handler-fix-3
Applying: dax,ext2: replace xip_truncate_page with dax_truncate_page
Applying: dax: replace XIP documentation with DAX documentation
Applying: vfs: remove get_xip_mem
Applying: ext2: remove ext2_xip_verify_sb()
Applying: ext2: remove ext2_use_xip
Applying: ext2: remove xip.c and xip.h
Applying: vfs,ext2: remove CONFIG_EXT2_FS_XIP and rename CONFIG_FS_XIP to C=
ONFIG_FS_DAX
Applying: ext2: remove ext2_aops_xip
Applying: ext2: get rid of most mentions of XIP in ext2
Applying: dax: add dax_zero_page_range
Applying: dax-add-dax_zero_page_range-fix
Applying: ext4: add DAX functionality
Applying: ext4-add-dax-functionality-fix
Applying: brd: rename XIP to DAX
Applying: MAINTAINERS: fix spelling mistake & remove trailing WS
Applying: ocfs2: eliminate the static flag of some functions
Applying: ocfs2: add functions to add and remove inode in orphan dir
Applying: ocfs2: add orphan recovery types in ocfs2_recover_orphans
Applying: ocfs2: implement ocfs2_direct_IO_write
Applying: ocfs2-implement-ocfs2_direct_io_write-fix
Applying: ocfs2: allocate blocks in ocfs2_direct_IO_get_blocks
Applying: ocfs2: do not fallback to buffer I/O write if appending
Applying: ocfs2: do not fallback to buffer I/O write if fill holes
Applying: ocfs2: fix leftover orphan entry caused by append O_DIRECT write =
crash
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (a826527e35af mm: add strictlimit knob)

--Sig_/Ut3+mZZFb6AaYHUW6z_5xsD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUwfPrAAoJEMDTa8Ir7ZwVLI4P/2e6poOarq/GFmT+V0lvbeFp
95uhvFmVQwgsDQf8LCyrU/STYQcB0QUc+a3hfnaDgu8XvLy0izptr5Ey9QEdZ9tO
8I6WjFffJHRtmBrE1qglBhR9zD7mF08lxNR6wZtGBVXeRKNnrzBhBl1XZu+Dli1+
7Ay5R2OSQE7y0BlwiQljh/EpYm7TKnkfKM7xFLFdS+n0QvmKzJDEvQLNbsTbZWBh
dGmW58+6VyofYDYx2OLT3XmoZIqqiR0N1PNc2dK54sREmLancL739s7QxuMZRSZs
pLdWt/aBdnBHlvz9TZL6p9+W+Qw5aJOgGeUsKaOiydyS/okdamy/FBL+HOd8K0lQ
lRS1BgkJoOz2Dqm8eQ6Vw+CrVU7UY55/hXuAV112G5mXgQ/u10u7EJh89ykHlfuV
PW0QM5Ue24iuFAMIPx937vTEkHR36Kq1gaaGHsx7L7YWZWxjlf/yUz8pqWYCO1ov
qeEJcAm5WzTLkQPK1y4QTQZfoal8oj+b6ConBuIoVXv0EMAfawMdePg+88BVaBsg
a0OGxD/oxgOnwcIbL/XxnUjh8ql1ZV+GY8CiSjJ7Rn1b3C5+vbXKRjqKdE212t+X
bP8lDUGOiwtK6hIpQCmQWUYPpzdbKSWV0hJZ2Ym9HabPjmrBciTZaC7rKd1o8KBP
gUfD8wJ+lVQfUqCuMgtb
=uG1L
-----END PGP SIGNATURE-----

--Sig_/Ut3+mZZFb6AaYHUW6z_5xsD--
