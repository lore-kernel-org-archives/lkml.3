Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbbAFD5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 22:57:09 -0500
Received: from ozlabs.org ([103.22.144.67]:56493 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbbAFD5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 22:57:06 -0500
Date: Tue, 6 Jan 2015 14:56:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jan 6
Message-ID: <20150106145657.157df8be@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2SavFLyEOh5Xs7U=ydCwu_H"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2SavFLyEOh5Xs7U=ydCwu_H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20150105:

Removed trees: wireless, wireless-next at maintainers request

Non-merge commits (relative to Linus' tree): 1137
 1253 files changed, 33175 insertions(+), 19114 deletions(-)

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
Merging origin/master (79b8cb973734 Merge tag 'powerpc-3.19-3' of git://git=
.kernel.org/pub/scm/linux/kernel/git/mpe/linux)
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
Merging net/master (7ce67a38f799 net: ethernet: cpsw: fix hangs with interr=
upts)
Merging ipsec/master (f855691975bb xfrm6: Fix the nexthdr offset in _decode=
_session6.)
Merging sound-current/for-linus (49cdd5b64193 ALSA: snd-usb-caiaq: fix stre=
am count check)
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
Merging usb-serial-fixes/usb-linus (b5122236bba8 USB: keyspan: fix null-der=
ef at probe)
Merging staging.current/staging-linus (b7392d2247cf Linux 3.19-rc2)
Merging char-misc.current/char-misc-linus (b7392d2247cf Linux 3.19-rc2)
Merging input-current/for-linus (cceeb872d60f Input: hil_kbd - fix incorrec=
t use of init_completion)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (0b8c960cf6de crypto: sha-mb - Add avx2_suppo=
rted check.)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (094cb98179f1 of/fdt: memblock_=
reserve /memreserve/ regions in the case of partial overlap)
Merging rr-fixes/fixes (3438cf549d2f param: fix crash on bad kernel argumen=
ts)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (92c7a602236e selftests/exec: allow shell ret=
urn code of 126)
Merging drm-intel-fixes/for-linux-next-fixes (26acf418e613 drm/i915: Ban Ha=
swell from using RCS flips)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging arm/for-next (e9f2d6d66037 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (cac7f2429872 Linux 3.18-rc2)
Merging arm-soc/for-next (d6ad36913083 clocksource: arch_timer: Only use th=
e virtual counter (CNTVCT) on arm64)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging cortex-m/for-next (e799b6f37e6c ARM: zImage: add support for ARMv7-=
M)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (27e772b488f9 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (f50900ef7cf2 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (340337ad530d Merge branches 'heads/soc-fixes-for-v3.1=
9', 'heads/defconfig-for-v3.20', 'heads/soc-for-v3.20', 'heads/dt-for-v3.20=
', 'heads/dt-cleanups-for-v3.20', 'heads/sh-drivers-for-v3.20', 'heads/lage=
r-board-removal-for-v3.20' and 'heads/sh73a0-ccf-for-v3.20' into next)
Merging samsung/for-next (1eeec807bf64 Merge branch 'v3.20-next/dt-samsung-=
64' into for-next)
Merging sunxi/sunxi/for-next (5e4f17a2dcfd Merge branch 'sunxi/fixes-for-3.=
19' into sunxi/for-next)
Merging tegra/for-next (fa047e01365d Merge branch for-3.19/soc into for-nex=
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
Merging m68knommu/for-next (7be2ac625bb0 arch: m68k: 68360: config: Remove =
unused function)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (3a8e3265179b microblaze: Fix mmap for cache cohere=
nt memory)
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
Merging s390/features (fa0d0b064d55 s390/signal: add sys_sigreturn and sys_=
rt_sigreturn declarations)
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
Merging ext3/for_next (3ee3039c5b4d udf: Reduce repeated dereferences)
Merging ext4/dev (363307e6e561 ext4: remove spurious KERN_INFO from ext4_wa=
rning call)
Merging f2fs/dev (987b52e65709 f2fs: reuse inode_entry_slab in gc procedure=
 for using slab more effectively)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (1c68271cf1bf fuse: use file_inode() in fuse_file_fal=
locate())
Merging gfs2/master (ec7d879c4576 GFS2: gfs2_atomic_open(): simplify the us=
e of finish_no_open())
Merging jfs/jfs-next (e1f1fe798d2f jfs: get rid of homegrown endianness hel=
pers)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (b7392d2247cf Linux 3.19-rc2)
Merging nfsd/nfsd-next (87409a834dfb nfsd: fi_delegees doesn't need to be a=
n atomic_t)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (2b7a8f36f092 ovl: add testsuite to docs)
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (efdca7aa3c41 Merge branch 'xfs-misc-fixes-for-3.20-1'=
 into for-next)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (88174fd2c8fb kill d_validate())
Merging pci/next (75f30c3d9949 Merge branches 'pci/host-keystone', 'pci/hos=
t-layerscape', 'pci/host-rcar' and 'pci/host-tegra' into next)
Merging hid/for-next (3bc80f8b09bd Merge branch 'for-3.20/betop' into for-n=
ext)
Merging i2c/i2c/for-next (523c5b89640e i2c: Remove support for legacy PM)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (907a6d582459 hwmon: (tmp401) Detect TMP43=
5 on all addresses it supports)
Merging v4l-dvb/master (2ea3258b238c Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (25417114d3fa Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (340e94c06f59 Merge branch 'for-3.19-fixes' into fo=
r-next)
Merging pm/linux-next (2640836260b1 Merge branches 'acpi-pm', 'acpi-process=
or' and 'acpi-video' into linux-next)
Merging idle/next (f7c0e22f2d14 Merge branch 'turbostat' into release)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (693a30b8f19a Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/rw/uml)
Merging thermal-soc/next (5a723e819234 MAINTAINERS: update ti-soc-thermal s=
tatus)
Merging ieee1394/for-next (d737d7da8e7e firewire: sbp2: replace card lock b=
y target lock)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (3e8ec65e62df Merge branch 'topic/rcar' into next)
Merging net-next/master (a3449ded128d list_nulls: fix missing header)
Merging ipsec-next/master (fbe68ee87522 vti6: Add a lookup method for tunne=
ls with wildcard endpoints.)
Merging wireless-drivers-next/master (dd9553988879 Merge branch 'timecounte=
r-next')
Merging bluetooth/master (661cf88acd84 Bluetooth: Use HCI_QUIRK_FIXUP_INQUI=
RY_MODE for Silicon Wave devices)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (ed0215cc3b52 mtd: gpmi: Remove "We support only one =
NAND chip" from bindings doc)
Merging crypto/master (28c29f5657e8 crypto: bfin_crc - Remove unnecessary K=
ERN_ERR in bfin_crc.c)
Merging drm/drm-next (4e0cd6811562 drm: sti: fix module compilation issue)
Merging drm-panel/drm/panel/for-next (54cbc4e298ea drm/mipi-dsi: Avoid pote=
ntial NULL pointer dereference)
Merging drm-intel/for-linux-next (5d77d9c5e177 drm/i915: add missing rpm re=
f to i915_gem_pwrite_ioctl)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (b710d754bd4f drm: Make drm_read() more r=
obust against multithreaded races)
Merging sound/for-next (ff6defa6a8fa ALSA: Deletion of checks before the fu=
nction call "iounmap")
Merging sound-asoc/for-next (92d9815cf236 Merge remote-tracking branches 'a=
soc/topic/sh', 'asoc/topic/txx9', 'asoc/topic/wm8804' and 'asoc/topic/wm898=
8' into asoc-next)
Merging modules/modules-next (b0a65b0cccd4 param: do not set store func wit=
hout write perm)
Merging virtio/virtio-next (c91c2a63913b mic/host: initial virtio 1.0 suppo=
rt)
CONFLICT (content): Merge conflict in drivers/virtio/virtio_pci_common.c
Merging input/next (aa104b1aaaa3 Input: synaptics - remove duplicated code)
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
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
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
Merging regulator/for-next (4d450bccaadc Merge remote-tracking branches 're=
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
Merging spi/for-next (b47ed8d2ab07 Merge remote-tracking branches 'spi/topi=
c/pxa2xx', 'spi/topic/qup', 'spi/topic/sh-msiof' and 'spi/topic/st-ssc' int=
o spi-next)
Merging tip/auto-latest (caa523dc2242 Merge branch 'x86/urgent')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (775c503f6567 mpc85xx_edac: Fix a typo in comment=
s)
Merging irqchip/irqchip/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (d716ff71dd12 tracing: Remove taking of trace_types=
_lock in pipe files)
Merging rcu/rcu/next (940c6c7fb5ec Documentation/memory-barriers.txt: Fix s=
mp typo)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (2c4aa55a6af0 Merge tag 'signed-kvm-ppc-next' of git=
://github.com/agraf/linux-2.6 into HEAD)
Merging kvm-arm/next (05971120fca4 arm/arm64: KVM: Require in-kernel vgic f=
or the arch timers)
Merging kvm-ppc/kvm-ppc-next (476ce5ef09b2 KVM: PPC: Book3S: Enable in-kern=
el XICS emulation by default)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
Merging percpu/for-next (bfaa047a9415 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging workqueues/for-next (008847f66c38 workqueue: allow rescuer thread t=
o do more work.)
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
Merging usb-gadget/next (b7392d2247cf Linux 3.19-rc2)
Merging usb-serial/usb-next (b7392d2247cf Linux 3.19-rc2)
Merging staging/staging-next (b7392d2247cf Linux 3.19-rc2)
Merging char-misc/char-misc-next (b7392d2247cf Linux 3.19-rc2)
Merging cgroup/for-next (f595f76defe2 Update of Documentation/cgroups/00-IN=
DEX)
Merging scsi/for-next (6bf850aa7ff6 Merge branch 'fixes' into for-next)
Merging target-updates/for-next (ae450e246e85 target: Allow AllRegistrants =
to re-RESERVE existing reservation)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (96dfdff694ae pinctrl: rockchip: Fix enable/disabl=
e/mask/unmask)
Merging vhost/linux-next (5d9a07b0de51 vhost: relax used address alignment)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (170680abd1eb gpio: mcp23s08: fix up compilation erro=
r)
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
Merging access_once/linux-next (5de72a2247ac s390/kvm: REPLACE barrier fixu=
p with READ_ONCE)
Merging omap/for-next (b2776bf7149b Linux 3.18)
Merging omap-pending/for-next (99d076b74745 MAINTAINERS: add maintainer for=
 OMAP hwmod data)
Merging livepatching/for-next (700a3048aaa3 livepatch: samples: fix usage e=
xample comments)
Merging akpm-current/current (350b61c87ab5 metag: Align thread_info::superv=
isor_stack)
CONFLICT (modify/delete): mm/fremap.c deleted in akpm-current/current and m=
odified in HEAD. Version HEAD of mm/fremap.c left in tree.
CONFLICT (content): Merge conflict in fs/ocfs2/aops.c
$ git rm -f mm/fremap.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (33f12dadf85f mm: add strictlimit knob)

--Sig_/2SavFLyEOh5Xs7U=ydCwu_H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUq10OAAoJEMDTa8Ir7ZwVGwEP/2mzeZqCC5FrrARjnWU0p9aP
mKQWNQF6VoYBRAqsG161a0+pvGU3A05o5YdCOj1BdEPl+z0BBlBm2W7VhObmGzFa
BlWdZEmWJcFPd9JENfeDk51kzQmbKfE31J4v3R554KCMAYviONrtocsrgBqK2mJn
LRVIZNXniRf7sqRV2A4Bxq1DO1QDxwlak0/yVX6/EPOWwPHL+pOl3N7VD+OgY8T/
R9bUqh86YAQ8294j56Fo3fMyZABP7kSmVB1KRruPyR8sYN99XXb5DjfQivIqo23J
WsEwjtQQj/bXGhlpMcf+DXHPcAyoEr+0pu3fEZWNsr+cL2+jAaQ+nZEcGeDzdV31
OZPley8KIKR6CwzZF6V5hVa/iZSvnoVJGYk5GZjUqIXH+vlSD3EUXzjcvxLKvEbH
NRpDkCSE0MRegtgI7eABO+0+D5RYJr1jKkFj1Zorbx3JiVG9559fVixf0rxxut8l
6tH6Q7GCbAkn743TKXRt6Ejm1gF2QN/jIzCQsm7y5n4PG4OvpBXJL6R/XK1hByiF
L4Vv3xriNhD8IfL5XY2WlMveJJdWNE96rOf35t5Dv8HDaQoQeM7TEp0KXKQYaQek
gp/x2eGIJoVoMr1p+jJrZ6QpIcBgoVFJ7VAB98vfhZ8fbRitII+7cxtQjSi0kQz4
4HQev0AyvgLQOqqKo/eb
=bqir
-----END PGP SIGNATURE-----

--Sig_/2SavFLyEOh5Xs7U=ydCwu_H--
