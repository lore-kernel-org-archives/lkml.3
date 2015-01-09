Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbbAIFeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 00:34:01 -0500
Received: from ozlabs.org ([103.22.144.67]:49610 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbbAIFd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 00:33:57 -0500
Date: Fri, 9 Jan 2015 16:33:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jan 9
Message-ID: <20150109163348.37072b63@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/h/TxlA6t8pc2svseKCOJZ+I"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/h/TxlA6t8pc2svseKCOJZ+I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20150108:

The drm-intel tree gained a conflict against the drm-intel-fixes tree.

Non-merge commits (relative to Linus' tree): 1880
 1970 files changed, 54585 insertions(+), 33090 deletions(-)

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
Merging origin/master (11c8f01b423b Merge branch 'rc-fixes' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/mmarek/kbuild)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (a16c5f99a28c kbuild: Fix removal of the de=
bian/ directory)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (3f4aa45ceea5 ARM: 8226/1: cacheflush: get rid of=
 restarting block)
Merging m68k-current/for-linus (f0b99a643e96 m68k/mm: Eliminate memset afte=
r alloc_bootmem_pages)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (1be6f10f6f9c Revert "powerpc: Secondary CP=
Us must set cpu_callin_map after setting active and online")
Merging sparc/master (66d0f7ec9f10 sparc32: destroy_context() and switch_mm=
() needs to disable interrupts.)
Merging net/master (bdec41963890 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec/master (f855691975bb xfrm6: Fix the nexthdr offset in _decode=
_session6.)
Merging sound-current/for-linus (92cb46584e10 ALSA: fireworks: fix an endia=
nness bug for transaction length)
Merging pci-current/for-linus (97bf6af1f928 Linux 3.19-rc1)
Merging wireless-drivers/master (c702674f99e6 Merge tag 'iwlwifi-for-kalle-=
2015-01-05' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlw=
ifi-fixes)
Merging driver-core.current/driver-core-linus (b7392d2247cf Linux 3.19-rc2)
Merging tty.current/tty-linus (68ed7e1c3d23 serial: fix parisc boot hang)
Merging usb.current/usb-linus (b3ee8bdcd243 Merge tag 'fixes-for-v3.19-rc2'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging usb-gadget-fixes/fixes (6785a1034461 usb: gadget: udc: atmel: fix p=
ossible IN hang issue)
Merging usb-serial-fixes/usb-linus (d80c0d141835 USB: qcserial/option: make=
 AT URCs work for Sierra Wireless MC73xx)
Merging staging.current/staging-linus (b7392d2247cf Linux 3.19-rc2)
Merging char-misc.current/char-misc-linus (b7392d2247cf Linux 3.19-rc2)
Merging input-current/for-linus (9333caeaeae4 Input: I8042 - add Acer Aspir=
e 7738 to the nomux list)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (0b8c960cf6de crypto: sha-mb - Add avx2_suppo=
rted check.)
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
Merging drm-intel-fixes/for-linux-next-fixes (e3e6efcd638d drm/i915: Fix mu=
tex->owner inspection race under DEBUG_MUTEXES)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (5840adceb962 arc: Remove unused prepare_to_copy())
Merging arm/for-next (e9f2d6d66037 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (97bf6af1f928 Linux 3.19-rc1)
Merging arm-soc/for-next (28f644c37bff Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (8553bf8fd181 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (e799b6f37e6c ARM: zImage: add support for ARMv7-=
M)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (bc8127e027df Merge branch 'imx/defconfig' into fo=
r-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (f50900ef7cf2 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging omap/for-next (c99e7d84d810 Merge branch 'omap-for-v3.20/defconfig'=
 into for-next)
Merging omap-pending/for-next (99d076b74745 MAINTAINERS: add maintainer for=
 OMAP hwmod data)
Merging renesas/next (57816675569d Merge branch 'heads/dt-for-v3.20' into n=
ext)
Merging samsung/for-next (4ac72232f810 Merge branch 'samsung-fixes' into fo=
r-next)
Merging sunxi/sunxi/for-next (1363ad23197b Merge branches 'sunxi/dt-for-3.2=
0', 'sunxi/clocks-for-3.20' and 'sunxi/defconfig-for-3.20' into sunxi/for-n=
ext)
Merging tegra/for-next (7edb2751f1c9 Merge branch for-3.20/soc into for-nex=
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
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (9ebaf8bb9107 arch: m68k: 68360: config: Remove =
unused function)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (132d5dfc0469 microblaze: whitespace fix)
Merging mips/mips-for-linux-next (a682437a894d Merge branch '3.19-fixes' in=
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
Merging tile/master (c47b15c4928c arch/tile: update MAINTAINERS email to EZ=
chip)
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
Merging cifs/for-next (0891605dd763 Initialize salt value for negotiate con=
text)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (942080643bce eCryptfs: Remove buggy and unnecessary =
write in file name decode routine)
Merging ext3/for_next (e4a93be6cb28 isofs: Fix bug in the way to check if t=
he year is a leap year)
Merging ext4/dev (363307e6e561 ext4: remove spurious KERN_INFO from ext4_wa=
rning call)
Merging f2fs/dev (ebb0d36e21a0 f2fs: pids_lock can be static)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (9759bd518994 fuse: add memory barrier to INIT)
Merging gfs2/master (ec7d879c4576 GFS2: gfs2_atomic_open(): simplify the us=
e of finish_no_open())
Merging jfs/jfs-next (e1f1fe798d2f jfs: get rid of homegrown endianness hel=
pers)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (4e379d36c050 NFSv4: Remove incorrect check in can_o=
pen_delegated())
Merging nfsd/nfsd-next (0ec016e3e02f nfsd4: tweak rd_dircount accounting)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (6d900f5a3339 ovl: document lower layer or=
dering)
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (efdca7aa3c41 Merge branch 'xfs-misc-fixes-for-3.20-1'=
 into for-next)
Merging file-locks/linux-next (9edbdddff524 locks: keep a count of locks on=
 the flctx lists)
Merging vfs/for-next (88174fd2c8fb kill d_validate())
Merging pci/next (75f30c3d9949 Merge branches 'pci/host-keystone', 'pci/hos=
t-layerscape', 'pci/host-rcar' and 'pci/host-tegra' into next)
Merging hid/for-next (20241892629e Merge branch 'for-3.20/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (523c5b89640e i2c: Remove support for legacy PM)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (dae00e414efc hwmon: (ina2xx) make shunt r=
esistance configurable at run-time)
Merging v4l-dvb/master (2ea3258b238c Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (bdb36b57523e Merge branches 'kbuild/kbuild' and 'k=
build/misc' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (7847cdc3b977 Merge branch 'for-3.19-fixes' into fo=
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
Merging thermal-soc/next (9477e18dd5d6 Documentation: thermal: document of_=
cpufreq_cooling_register())
Merging ieee1394/for-next (d737d7da8e7e firewire: sbp2: replace card lock b=
y target lock)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (3e8ec65e62df Merge branch 'topic/rcar' into next)
Merging net-next/master (44d84d7272e5 Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
Merging ipsec-next/master (fbe68ee87522 vti6: Add a lookup method for tunne=
ls with wildcard endpoints.)
Merging wireless-drivers-next/master (8a40084e7bb8 mwifiex: Add support for=
 wowlan disconnect)
Merging bluetooth/master (bc6efeeeb5a2 ieee802154: 6lowpan: fix Makefile en=
try)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (72ea403669c7 mtd: nand: added nand_shutdown)
Merging crypto/master (8155330aad47 lib: memzero_explicit: add comment for =
its usage)
Merging drm/drm-next (c93546a5e32b Merge tag 'topic/atomic-core-2015-01-05'=
 of git://anongit.freedesktop.org/drm-intel into drm-next)
Merging drm-panel/drm/panel/for-next (54cbc4e298ea drm/mipi-dsi: Avoid pote=
ntial NULL pointer dereference)
Merging drm-intel/for-linux-next (7226572d8ed4 drm/i915: Reserve shadow bat=
ch VMA analogue to others)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_runtime_pm=
.c
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (b710d754bd4f drm: Make drm_read() more r=
obust against multithreaded races)
Merging sound/for-next (e9f49369722b ALSA: usb-audio: Add support for Akai =
MPC Element USB MIDI controller)
Merging sound-asoc/for-next (e4cb6c106480 Merge remote-tracking branch 'aso=
c/topic/xtfpga' into asoc-next)
Merging modules/modules-next (97bf6af1f928 Linux 3.19-rc1)
Merging virtio/virtio-next (97bf6af1f928 Linux 3.19-rc1)
Merging input/next (b388de88308f Input: axp20x-pek - switch over to using a=
ttribute group)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (177ccd2f8f39 Merge branch 'for-3.20/drivers' into f=
or-next)
Merging device-mapper/for-next (af66c8489d6d dm table: train hybrid target =
type detection to select blk-mq if appropriate)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (60000f69a57a mmc: Add SDIO function devicetree subnode=
 parsing)
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
Merging regulator/for-next (1c3ceaf42f13 Merge remote-tracking branches 're=
gulator/topic/mt6397', 'regulator/topic/rk808', 'regulator/topic/rt5033' an=
d 'regulator/topic/tps65023' into regulator-next)
Merging security/next (b2d1965dcea1 Merge branch 'next' of git://git.infrad=
ead.org/users/pcmoore/selinux into next)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (566075875a84 selinux: Remove unused function avc_sidc=
mp())
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
Merging dt-rh/for-next (a0e27f51ba8a documentation: pinctrl bindings: Fix t=
rivial typo 'abitrary')
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (52052f9b7ea1 Merge remote-tracking branches 'spi/topi=
c/pxa2xx', 'spi/topic/qup', 'spi/topic/sirf' and 'spi/topic/st-ssc' into sp=
i-next)
Merging tip/auto-latest (caa523dc2242 Merge branch 'x86/urgent')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (ae9b56e3996d EDAC, synps: Add EDAC support for z=
ynq ddr ecc controller)
Merging irqchip/irqchip/for-next (91d117921216 irqchip: atmel-aic-common: P=
revent clobbering of priority when changing IRQ type)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (d716ff71dd12 tracing: Remove taking of trace_types=
_lock in pipe files)
Merging rcu/rcu/next (7cf4667519a5 Merge branches 'doc.2015.01.06a', 'fixes=
.2015.01.06a', 'preempt.2015.01.06a', 'srcu.2015.01.06a', 'stall.2015.01.06=
a' and 'torture.2015.01.06a' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (b1940cd21c0f Linux 3.19-rc3)
Merging kvm-arm/next (05971120fca4 arm/arm64: KVM: Require in-kernel vgic f=
or the arch timers)
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
Merging tty/tty-next (b7392d2247cf Linux 3.19-rc2)
Merging usb/usb-next (b7392d2247cf Linux 3.19-rc2)
Merging usb-gadget/next (b1940cd21c0f Linux 3.19-rc3)
Merging usb-serial/usb-next (b7392d2247cf Linux 3.19-rc2)
Merging staging/staging-next (b7392d2247cf Linux 3.19-rc2)
Merging char-misc/char-misc-next (b7392d2247cf Linux 3.19-rc2)
Merging cgroup/for-next (f3ba53802eff cgroup: add dummy css_put() for !CONF=
IG_CGROUPS)
Merging scsi/for-next (f7ca37fa0ddd Merge branch 'misc' into for-next)
Merging target-updates/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (fce7fcc78599 pinctrl: st: Add irq_disable hook to=
 st_gpio_irqchip)
Merging vhost/linux-next (99975cc6ada0 vhost/net: length miscalculation)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (5afb287a06ce gpio: dln2: Fix gpio output value in dl=
n2_gpio_direction_output())
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
Merging luto-misc/next (bced35b65aef x86, traps: Add ist_begin_non_atomic a=
nd ist_end_non_atomic)
Merging access_once/linux-next (29bde09065b7 next: sh: Fix compile error)
Merging livepatching/for-next (83ac237a950e livepatch: kconfig: use bool in=
stead of boolean)
Merging akpm-current/current (1d9e76e2eb3f fs/affs/file.c: replace if/BUG b=
y BUG_ON)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: livepatching: handle ancient compilers with more grace
Applying: livepatching-handle-ancient-compilers-with-more-grace-checkpatch-=
fixes
Applying: dt-bindings: use isil prefix for Intersil
Applying: rtc: isl12022: deprecate use of isl in compatible string for isil
Applying: rtc: isl12057: deprecate use of isl in compatible string for isil
Applying: staging: iio: isl29028: deprecate use of isl in compatible string=
 for isil
Applying: arm: dts: zynq: update isl9305 compatible string to use isil vend=
or prefix
Applying: arm: dts: tegra: update isl29028 compatible string to use isil ve=
ndor prefix
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (b6bc02ba0876 mm: add strictlimit knob)

--Sig_/h/TxlA6t8pc2svseKCOJZ+I
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUr2hBAAoJEMDTa8Ir7ZwVGN8P/iz13le+3sKrjW8pt5+FSE0g
Y1pRs1KEt7xBNPGQhoctIBNvpLpO8TOEApV7vwpWJ7pHoNjBWXfxqzibdpQ9KAT5
T31oGLYvE3u9+oIq8RSzyfLPGyEJtETe9SmKipLOFNUz5c0ogT60+4XyIFDcfAYc
j+3VLHseXD/EC5SHrox4mbuU1kG06y16EicLw33++mBZSHjmfgCvOY5slFs03Jk9
dbngOtDgY8U9VOXEPS0EgRutHYKRtqrYK8/3RrFd87mMCK/QS1uvTpD+mtKWhF/r
1n4dgJHa/XnQkAVvqnn9xOo1ICPQMTrX7BoynzKOc0rkyJifth3JJw9H1u39aCqO
qcakCfgjhmAhyu1gQ5SS/sbUnntVjj7eYqz/C0fS2aBCgIEEAhcX8ti1LaDz0uOl
9Q4vyRnlwEjSc1ZJyy8NFzLnuNR/ekQH++OoOKHIrFu7LImPQhDZm1gLPFmJspIp
82gmAwstq/oE7/5QyAVZKtb8BzGKQJjBBD5Uk601xuT4TfsQ0MEPY380uH53sHaT
/cKxRzB/OA3YN/DvEw9qXZY5vp2fobvcrbeN/CFxhuoZ00X88+fFsCHgjKryExdf
amt2Tx+RESLnvt4A95xhWAHBBtJ8sUz+kAIalyJSkhswA+6kJl3fFZ11ipvML8Z+
7p+M/8c8b6AH0G78R/6p
=NhIL
-----END PGP SIGNATURE-----

--Sig_/h/TxlA6t8pc2svseKCOJZ+I--
