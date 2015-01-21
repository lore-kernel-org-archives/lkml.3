Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbbAUI0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:26:24 -0500
Received: from ozlabs.org ([103.22.144.67]:48015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbbAUI0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:26:16 -0500
Date: Wed, 21 Jan 2015 19:26:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jan 21
Message-ID: <20150121192608.61062b6a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p0TF62MAgIsU+6IubyrVQsy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p0TF62MAgIsU+6IubyrVQsy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20150120:

Removed trees: (not updated for more that 1 year)
	configfs
	cpupowerutils
	dwmw2
	embedded
	ep93xx
	fbdev
	firmware
	fsnotify
	fw-nohz
	hwspinlock
	input-mt
	ixp4xx
	kconfig
	logfs
	lzo-update
	md-current
	msm
	omfs
	openrisc
	oprofile
	parisc
	pcmcia
	signal
	sysctl
	uclinux
	uml
	uprobes
	viafb
	writeback

The block tree gained a conflict against the l2-mtd tree.

The char-misc tree gained a conflict against the block tree.

The akpm-current tree gained conflicts against the block tree and a
build failure (due to an interaction with the block tree) for which I
applied a merge fix patch.

The akpm tree gained conflicts against the block tree.

Non-merge commits (relative to Linus' tree): 4107
 3917 files changed, 150610 insertions(+), 71855 deletions(-)

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

I am currently merging 205 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (b97f880c8342 Merge branch 'for-3.19-fixes' of git://=
git.kernel.org/pub/scm/linux/kernel/git/tj/libata)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (a16c5f99a28c kbuild: Fix removal of the de=
bian/ directory)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (2d9ed7406fd2 ARM: 8255/1: perf: Prevent wraparou=
nd during overflow)
Merging m68k-current/for-linus (f27bd5bfeda5 m68k: Wire up execveat)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (a87e810f61b4 powerpc: Work around gcc bug =
in current_thread_info())
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
Merging input-current/for-linus (029b18361921 Input: uinput - fix ioctl nr =
overflow for UI_GET_SYSNAME/VERSION)
Merging crypto-current/master (3e14dcf7cb80 crypto: add missing crypto modu=
le aliases)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging devicetree-current/devicetree/merge (094cb98179f1 of/fdt: memblock_=
reserve /memreserve/ regions in the case of partial overlap)
Merging rr-fixes/fixes (c749637909ee module: fix race in kallsyms resolutio=
n during module load success.)
Merging vfio-fixes/for-linus (7c2e211f3c95 vfio-pci: Fix the check on pci d=
evice type in vfio_pci_probe())
Merging kselftest-fixes/fixes (f5db310d77ef selftests/vm: fix link error fo=
r transhuge-stress test)
Merging drm-intel-fixes/for-linux-next-fixes (226e5ae9e5f9 drm/i915: Fix mu=
tex->owner inspection race under DEBUG_MUTEXES)
Merging asm-generic/master (643165c8bbc8 Merge tag 'uaccess_for_upstream' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost into asm-generic)
Merging arc/for-next (5840adceb962 arc: Remove unused prepare_to_copy())
Merging arm/for-next (6aa99fe6afee Merge branches 'fixes', 'l2c' (early par=
t), 'misc' and 'sa1100' into for-next)
Merging arm-perf/for-next/perf (97bf6af1f928 Linux 3.19-rc1)
Merging arm-soc/for-next (548f654f5558 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (8553bf8fd181 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (e799b6f37e6c ARM: zImage: add support for ARMv7-=
M)
Merging imx-mxs/for-next (395ae1400a35 Merge branch 'imx/defconfig' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging mvebu/for-next (411e0175c248 Merge branch 'mvebu/defconfig' into mv=
ebu/for-next)
Merging omap/for-next (f5a4d5d3a460 Merge branch 'omap-for-v3.20/dm816x-v2'=
 into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging omap-pending/for-next (30aa18d3bea5 MAINTAINERS: add maintainer for=
 OMAP hwmod data)
Merging renesas/next (c20c776cff55 Merge branch 'heads/sh73a0-multiplatform=
-for-v3.20' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging samsung/for-next (9663ad71912b Merge branch 'v3.20-next/update-sams=
ung' into for-next)
Merging sunxi/sunxi/for-next (e822fa3f3290 Merge branches 'sunxi/dt-for-3.2=
0' and 'sunxi/clocks-for-3.20' into sunxi/for-next)
Merging tegra/for-next (4fd40ac71480 Merge branch for-3.20/soc into for-nex=
t)
Merging arm64/for-next/core (6083fe74b7bf arm64: respect mem=3D for EFI)
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
Merging nios2/nios2-next (1b0f44923e18 nios2: Use preempt_schedule_irq)
Merging parisc-hd/for-next (b2776bf7149b Linux 3.18)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (9a4fc4eaf111 powerpc/kvm: Create proper names for=
 the kvm_host_state PMU fields)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (725908110a1f s390: add SMT support)
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
Merging ext3/for_next (c38fda3fe816 jbd: drop jbd_ENOSYS debug)
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
Merging nfs/linux-next (ec6f34e5b552 Linux 3.19-rc5)
Merging nfsd/nfsd-next (0ec016e3e02f nfsd4: tweak rd_dircount accounting)
Merging overlayfs/overlayfs-next (4330397e4e8a ovl: discard independent cur=
sor in readdir())
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (ad7df6e858ef Merge branch 'xfs-sb-logging-rework' int=
o for-next)
Merging file-locks/linux-next (3d8e560de4a0 locks: consolidate NULL i_flctx=
 checks in locks_remove_file)
Merging vfs/for-next (b1bf256afee2 VFS: Convert file->f_dentry->d_inode to =
file_inode())
Merging pci/next (75f30c3d9949 Merge branches 'pci/host-keystone', 'pci/hos=
t-layerscape', 'pci/host-rcar' and 'pci/host-tegra' into next)
Merging hid/for-next (dd2566230295 Merge branch 'for-3.20/logitech' into fo=
r-next)
Merging i2c/i2c/for-next (789d10deed25 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (927b2494498f hwmon: (jc42) Fix integer ov=
erflow when writing hysteresis value)
Merging v4l-dvb/master (2ea3258b238c Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (5ea04a1a0860 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging libata/for-next (3c58572c3a82 Merge branch 'for-3.19-fixes' into fo=
r-next)
Merging pm/linux-next (72563a34813b Merge branch 'acpi-video' into linux-ne=
xt)
Merging idle/next (f7c0e22f2d14 Merge branch 'turbostat' into release)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging thermal/next (f67744c4d91e Merge branch 'thermal-soc' of .git into =
next)
Merging thermal-soc/next (1813d8087469 thermal: rcar: Spelling/grammar: s/d=
rier use .../driver uses ...s/)
Merging ieee1394/for-next (d737d7da8e7e firewire: sbp2: replace card lock b=
y target lock)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (8686abe3553b Merge branch 'topic/rcar' into next)
Merging net-next/master (0c49087462e8 Merge tag 'mac80211-next-for-davem-20=
15-01-19' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-n=
ext)
Merging ipsec-next/master (78890ed75494 csiostor:fix sparse warnings)
Merging wireless-drivers-next/master (d0c102f70aec b43legacy: Remove unused=
 b43legacy_radio_set_tx_iq())
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/scan=
.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/wil6210/cfg8=
0211.c
Merging bluetooth/master (80cf71deb2e1 Bluetooth: btusb: Add Broadcom patch=
ram support for ASUSTek devices)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (51585778f63a mtd: atmel_nand: introduce a new compat=
ible string for sama5d4 chip)
Merging crypto/master (379dcfb40600 crypto: doc - remove colons in comments)
Merging drm/drm-next (426959c94553 drm: fix mismerge in drm_crtc.c)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_runtime_pm=
.c
Merging drm-panel/drm/panel/for-next (2d0853a33fda drm/panel: sharp: lq101r=
1sx01: Remove unneeded include)
Merging drm-intel/for-linux-next (93180785d44e drm/i915: Rename plane_confi=
g to initial_plane_config)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (2535ef6ae303 next: drm/atomic: Use copy_=
from_user to copy 64 bit data from user space)
Merging sound/for-next (b4b33f9d64c3 ALSA: hda - Enable docking station for=
 an HP machine)
Merging sound-asoc/for-next (f3ec1b8506f9 Merge remote-tracking branches 'a=
soc/topic/wm8804', 'asoc/topic/wm8960', 'asoc/topic/wm8988' and 'asoc/topic=
/xtfpga' into asoc-next)
Merging modules/modules-next (97bf6af1f928 Linux 3.19-rc1)
Merging virtio/virtio-next (bf0fe7ee7738 virtio_pci: add module param to fo=
rce legacy mode)
Merging input/next (7b2171d7c43e Input: cyapa - add acpi device id support)
Merging block/for-next (7070fe4f971f Merge branch 'for-3.20/bdi' into for-n=
ext)
CONFLICT (content): Merge conflict in drivers/mtd/mtdcore.c
Applying: disable the lustre code for now
Merging device-mapper/for-next (6a55c9861326 block: keep established cmd_fl=
ags when cloning into a blk-mq request)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (9cd0ef2b1048 Merge branch 'tmio' into next)
CONFLICT (content): Merge conflict in drivers/mmc/host/sunxi-mmc.c
Merging kgdb/kgdb-next (c7d9ebf81c45 kdb: Fix off by one error in kdb_cpu())
Merging md/for-next (f851b60db0fd md: Check MD_RECOVERY_RUNNING as well as =
->sync_thread.)
Merging mfd/for-mfd-next (a3b63979f8a3 mfd: rtsx: Add func to split u32 int=
o register)
Merging backlight/for-backlight-next (3d6969a641d0 MAINTAINERS: Remove my n=
ame from Backlight subsystem)
Merging battery/master (f8f847b51a0e MAINTAINERS: Add entry for Maxim charg=
ers on Samsung boards)
Merging omap_dss2/for-next (7efc436cd45c Merge branches '3.20/fbdev' and '3=
.20/omapdss' into for-next)
Merging regulator/for-next (4311c370311a Merge remote-tracking branches 're=
gulator/topic/pfuze100', 'regulator/topic/rk808', 'regulator/topic/rt5033' =
and 'regulator/topic/tps65023' into regulator-next)
Merging security/next (743410a03bbf tpm: fix format string error in tpm-chi=
p.c)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (0307dadc924d selinux: add security in-core xattr supp=
ort for pstore and debugfs)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
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
Merging trivial/for-next (8fc8f4d57c8d mm: fix cleancache debugfs directory=
 path)
Merging audit/next (a9df33f33a5f audit: replace getname()/putname() hacks w=
ith reference counters)
CONFLICT (content): Merge conflict in fs/exec.c
Merging devicetree/devicetree/next (c46ca3c8310b of: Delete unnecessary che=
ck before calling "of_node_put()")
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
Merging kvm-arm/next (bab5bb398273 kvm: x86: Remove kvm_make_request from l=
apic.c)
Merging kvm-ppc/kvm-ppc-next (2c4aa55a6af0 Merge tag 'signed-kvm-ppc-next' =
of git://github.com/agraf/linux-2.6 into HEAD)
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
Merging percpu/for-next (4c907baf36d8 percpu_ref: implement percpu_ref_is_d=
ying())
Merging workqueues/for-next (b5b3ab523e31 Merge branch 'for-3.19-fixes' int=
o for-next)
Merging drivers-x86/for-next (200db647112d platform/x86/acerhdf: Still depe=
nds on THERMAL)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging regmap/for-next (270ded427d7b Merge remote-tracking branch 'regmap/=
topic/core' into regmap-next)
Merging hsi/for-next (67e9a2ce6e07 hsi: nokia-modem: fix uninitialized devi=
ce pointer)
Merging leds/for-next (452bc149947b leds: leds-mc13783: Use of_get_child_by=
_name() instead of refcount hack)
Merging ipmi/for-next (1421c935df15 ipmi: Fix compile warning with tv_usec)
Merging driver-core/driver-core-next (ec6f34e5b552 Linux 3.19-rc5)
Merging tty/tty-next (61b6b7fbda1b Merge 3.19-rc5 into tty-next)
Merging usb/usb-next (0e08365f0b48 Merge 3.19-rc5 into usb-next)
Merging usb-gadget/next (d1fc4440d761 Merge tag 'v3.19-rc5' into next)
Merging usb-serial/usb-next (3e264ffc831e USB: mos7840: remove unused code)
Merging staging/staging-next (484c60e206b0 Merge 3.19-rc5 into staging-next)
Merging char-misc/char-misc-next (3542f6b1836d Merge 3.19-rc5 into char-mis=
c-next)
CONFLICT (content): Merge conflict in drivers/char/mem.c
Merging cgroup/for-next (f3ba53802eff cgroup: add dummy css_put() for !CONF=
IG_CGROUPS)
Merging scsi/for-next (cdf6f3a2ea29 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging pinctrl/for-next (5b46452f5ba2 Merge branch 'devel' into for-next)
Merging vhost/linux-next (eaa27f34e91a linux 3.19-rc4)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (b991e9abb39f Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (6a6bdf52a3c4 pwm: sunxi: document OF bindings)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
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
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
Merging access_once/linux-next (c5b19946eb76 kernel: Fix sparse warning for=
 ACCESS_ONCE)
Merging livepatching/for-next (3c33f5b99d68 livepatch: support for repatchi=
ng a function)
Merging akpm-current/current (16cfffc93532 ipc,sem: use current->state help=
ers)
CONFLICT (content): Merge conflict in mm/truncate.c
CONFLICT (content): Merge conflict in mm/swap.c
CONFLICT (content): Merge conflict in mm/filemap.c
Applying: mm: drop vm_ops->remap_pages and generic_file_remap_pages() stub =
fix
Applying: mm: account pmd page tables to the process fix
Applying: fs: remove mapping->backing_dev_info fix
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
CONFLICT (content): Merge conflict in mm/filemap_xip.c
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
CONFLICT (modify/delete): mm/filemap_xip.c deleted in vfs: remove get_xip_m=
em and modified in HEAD. Version HEAD of mm/filemap_xip.c left in tree.
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
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (84c9673cd67c mm: add strictlimit knob)

--Sig_/p0TF62MAgIsU+6IubyrVQsy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUv2KkAAoJEMDTa8Ir7ZwVb3QP/jRVpjqVMImlGl6DazdeWpAP
EIblOjlsdHSCoISMZIqApkZAhSHyua+nwhrGOvg+ccXHxYi2IBSnLKwxXMDmov7e
rnJyLn+Azohvzq8K89cD685m43uh/MAdiPsdNhgxqWlbGzlGlRy3kxojXwjaCBUu
8Oh++VmuAQp6qBVZZJwSThoZYdrSx6SMbAKBShsHhwjHFATRwOEN5bU1h+zibXmS
cQ3UNDXEFL/fG/MXRbyMxuZUPbsPgtQBb2HHEtLtEaHtc5IaIHITJVqoxpa74b49
Hr2h/20YROAqM3IxoGi0EaSL42UUHZWvesluQUSBGt5zFIm6YzvzHBlWwrbHDEob
yWcMzl7L+gy1JyZpKjD1ToSlQYndSp3Womgd3Y0wKDMq5uV2VtLNpYt+nuqyC4UW
YhNSS/I+ZoN0+K1HAcI1CpEhon5RwBXPj1cYjagL+gV2GSFI7vqV73si2VMdiAc6
DlBbCNWtf7kPxrrChWZ/bpyy0zEt7ZF8drH7I7aP+UbcvMv+xCXDAac3nr5cAEic
ujN6kJROltMnSFGzRx51+v2UnqX6cTQq9qPC7aAPIAK6yPCZ56Kk2oYfNiQfhrRk
ElNc0J4pIhcOU18WheySEInIdT2MZxKlTc7nLC4QGWRnF9paMcjvZkOMGD7kXtcs
IMzFhzRx79xtMh332zQb
=AYut
-----END PGP SIGNATURE-----

--Sig_/p0TF62MAgIsU+6IubyrVQsy--
