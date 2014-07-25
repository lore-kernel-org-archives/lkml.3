Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbaGYKMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:12:36 -0400
Received: from ozlabs.org ([103.22.144.67]:37513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaGYKM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:12:29 -0400
Date: Fri, 25 Jul 2014 20:12:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jul 25
Message-ID: <20140725201218.55ad6288@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/es3o+exXAaj6GK5c+SL_HSR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/es3o+exXAaj6GK5c+SL_HSR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140724:

New tree: hch-vfs

The arm-soc tree gained a conflict against the arm tree.

The samsung tree gained a conflict against the arm tree.

The v4l-dvb tree gained a build failure so I used the version from
next-20140724.

The tip tree gained a conflict aginst the net-next tree and a build
failure, so I used the version from next-20140724.

The security tree gained a build failure for which I applied a fix patch.

The crypto tree lost its build failure.

The driver-core tree gained a conflict against the renesas tree.

Non-merge commits (relative to Linus' tree): 8075
 7313 files changed, 291771 insertions(+), 381170 deletions(-)

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

I am currently merging 225 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (82e13c71bc65 Merge branch 'for-3.16' of git://linux-=
nfs.org/~bfields/linux)
Merging fixes/master (1795cd9b3a91 Linux 3.16-rc5)
Merging kbuild-current/rc-fixes (dd5a6752ae7d firmware: Create directories =
for external firmware)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (91942d17667a ARM: 8112/1: only select ARM_PATCH_=
PHYS_VIRT if MMU is enabled)
Merging m68k-current/for-linus (5bc8c7cdeb6e m68k: Export mach_random_get_e=
ntropy to modules)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (6f5405bc2ee0 powerpc: use _GLOBAL_TOC for memm=
ove)
Merging sparc/master (15ba2236f355 Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging net/master (11f1fb3459d7 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/klassert/ipsec)
Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
Merging sound-current/for-linus (eb12f72ee724 ALSA: bebob: Correction for r=
eturn value of special_clk_ctl_put() in error)
Merging pci-current/for-linus (bf177a1eb6d1 MAINTAINERS: Update mx6 PCI dri=
ver maintainer's email)
Merging wireless/master (c01fac1c77a0 ath9k: fix aggregation session lockup)
Merging driver-core.current/driver-core-linus (9a3c4145af32 Linux 3.16-rc6)
Merging tty.current/tty-linus (1795cd9b3a91 Linux 3.16-rc5)
Merging usb.current/usb-linus (9a3c4145af32 Linux 3.16-rc6)
Merging usb-gadget-fixes/fixes (a8a85b01d185 usb: musb/cppi41: call musb_ep=
_select() before accessing an endpoint's CSR)
Merging usb-serial-fixes/usb-linus (1795cd9b3a91 Linux 3.16-rc5)
Merging staging.current/staging-linus (4aa0abed3a2a staging: vt6655: Fix di=
sassociated messages every 10 seconds)
Merging char-misc.current/char-misc-linus (9a3c4145af32 Linux 3.16-rc6)
Merging input-current/for-linus (f62d14a8072b Input: document INPUT_PROP_TO=
PBUTTONPAD)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (e052dbf55461 hwrng: virtio - ensure reads ha=
ppen after successful probe)
Merging ide/master (15ba2236f355 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (356facff5275 of/platform: Fix =
of_platform_device_destroy iteration of devices)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (eedd10f45bdc drm/i915: Simpli=
fy i915_gem_release_all_mmaps())
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (3a5d0df211dd mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (4aba888d74cc Merge branch 'devel-stable' into for-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
Merging arm-perf/for-next/perf (4c834452aad0 Linux 3.16-rc3)
Merging arm-soc/for-next (eaada20f5515 arm-soc: document merges)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/headsmp.S
CONFLICT (modify/delete): arch/arm/mach-integrator/include/mach/memory.h de=
leted in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/ma=
ch-integrator/include/mach/memory.h left in tree.
$ git rm -f arch/arm/mach-integrator/include/mach/memory.h
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (69603fbbc479 ARM: dts: vf610: add FlexCAN node)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (f4cf18f4dedd Merge branch 'mvebu/dt' into mvebu/for=
-next)
CONFLICT (modify/delete): drivers/cpuidle/cpuidle-armada-370-xp.c deleted i=
n mvebu/for-next and modified in HEAD. Version HEAD of drivers/cpuidle/cpui=
dle-armada-370-xp.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
$ git rm -f drivers/cpuidle/cpuidle-armada-370-xp.c
Merging renesas/next (ff4a19f3dc14 Merge branches 'heads/fixes-for-v3.16', =
'heads/defconfig-for-v3.17', 'heads/clock-for-v3.17', 'heads/shdma-for-v3.1=
7' and 'cleanup-boards-for-v3.17' into next)
Merging samsung/for-next (453304652ef5 Merge branch 'v3.17-next/cleanup-sam=
sung-2' into for-next)
CONFLICT (modify/delete): arch/arm/plat-samsung/s5p-irq-eint.c deleted in s=
amsung/for-next and modified in HEAD. Version HEAD of arch/arm/plat-samsung=
/s5p-irq-eint.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/Kconfig
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-spi.c deleted in sams=
ung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/se=
tup-spi.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-sdhci-gpio.c deleted =
in samsung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5p=
v210/setup-sdhci-gpio.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-keypad.c deleted in s=
amsung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210=
/setup-keypad.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-ide.c deleted in sams=
ung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/se=
tup-ide.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-i2c2.c deleted in sam=
sung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/s=
etup-i2c2.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-i2c1.c deleted in sam=
sung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/s=
etup-i2c1.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-i2c0.c deleted in sam=
sung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/s=
etup-i2c0.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-fimc.c deleted in sam=
sung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/s=
etup-fimc.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/setup-fb-24bpp.c deleted in=
 samsung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv2=
10/setup-fb-24bpp.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/mach-smdkv210.c deleted in =
samsung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv21=
0/mach-smdkv210.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/mach-goni.c deleted in sams=
ung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/ma=
ch-goni.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/mach-aquila.c deleted in sa=
msung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/=
mach-aquila.c left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/include/mach/memory.h delet=
ed in samsung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-=
s5pv210/include/mach/memory.h left in tree.
CONFLICT (rename/delete): arch/arm/mach-s5pv210/include/mach/gpio-samsung.h=
 deleted in samsung/for-next and renamed in HEAD. Version HEAD of arch/arm/=
mach-s5pv210/include/mach/gpio-samsung.h left in tree.
CONFLICT (modify/delete): arch/arm/mach-s5pv210/dev-audio.c deleted in sams=
ung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/de=
v-audio.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/pm.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig
$ git rm -f arch/arm/mach-s5pv210/dev-audio.c arch/arm/mach-s5pv210/include=
/mach/gpio-samsung.h arch/arm/mach-s5pv210/mach-aquila.c arch/arm/mach-s5pv=
210/mach-goni.c arch/arm/mach-s5pv210/mach-smdkv210.c arch/arm/mach-s5pv210=
/setup-fb-24bpp.c arch/arm/mach-s5pv210/setup-fimc.c arch/arm/mach-s5pv210/=
setup-i2c0.c arch/arm/mach-s5pv210/setup-i2c1.c arch/arm/mach-s5pv210/setup=
-i2c2.c arch/arm/mach-s5pv210/setup-ide.c arch/arm/mach-s5pv210/setup-keypa=
d.c arch/arm/mach-s5pv210/setup-sdhci-gpio.c arch/arm/mach-s5pv210/setup-sp=
i.c arch/arm/plat-samsung/s5p-irq-eint.c
$ git rm -f arch/arm/mach-s5pv210/include/mach/memory.h
Applying: ARM: EXYNOS: fixup for code movement
Merging sunxi/sunxi/for-next (44b61dc11c6d Merge branch 'sunxi/dt-for-3.17'=
 into sunxi/for-next)
Merging tegra/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging arm64/for-next/core (05ac65305437 arm64: fix soft lockup due to lar=
ge tlb flush range)
Merging blackfin/for-linus (19ba66d4c269 blackfin: fix some bf5xx boards bu=
ild for missing <linux/gpio.h>)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (7c76bb5f7a3d RAS, extlog: Adjust init flow)
Merging m68k/for-next (47d3aef76466 m68k/sun3: Remove define statement no l=
onger needed)
Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prot=
otype for kobjsize())
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (ef264cf0c490 microblaze: Change libgcc-style funct=
ions from lib-y to obj-y)
Merging mips/mips-for-linux-next (de3d02f3906d Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9794144d5a95 parisc: Eliminate memset after all=
oc_bootmem_pages)
Merging powerpc/next (c49f63530bb6 powernv: Add OPAL tracepoints)
Merging fsl/next (cd1154770ba9 powerpc/85xx: drop hypervisor specific board=
 compatibles)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (c60d1ae4efcb s390/pci: introduce lazy IOTLB flushing=
 for DMA unmap)
Merging sparc-next/master (cfcfe22256d5 Merge branch 'sparc64_io')
Merging tile/master (ed93567c6fbc tile: Remove tile-specific _sinitdata and=
 _einitdata)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (4ed2ad38b3b4 Merge tag 'xtensa-for-next-20140715' =
of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (c7548af69d9e Btrfs: convert smp_mb__{before,after}_clea=
r_bit)
Merging ceph/master (437f2c0d0c01 rbd: fix ida/idr memory leak)
Merging cifs/for-next (bb7cd8d76356 [CIFS] Update cifs version)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (3f1be4f9c9dc udf: avoid redundant memcpy when writin=
g data in ICB)
Merging ext4/dev (83447ccb4df6 ext4: make ext4_has_inline_data() as a inlin=
e function)
Merging f2fs/dev (4b2868aa4f07 f2fs: remove the unused stat_lock)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (dec5ac00c840 GFS2: fs/gfs2/super.c: replace seq_printf=
 by seq_puts)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (e655f945cd7b Merge branch 'bugfixes' into linux-nex=
t)
Merging nfsd/nfsd-next (f9c00c3ab425 nfsd: Do not let nfs4_file pin the str=
uct inode)
CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (545f7fdf6db8 UBIFS: add a log overlap assertion)
Merging xfs/for-next (a087481811be xfs: document log sysfs attributes in te=
sting ABI)
Merging file-private-locks/linux-next (73a8f5f7e635 locks: purge fl_owner_t=
 from fs/locks.c)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging hch-vfs/vfs-for-3.17 (79a3a5cea657 cifs: support RENAME_NOREPLACE)
Merging pci/next (981c191778a4 Merge branches 'pci/host-designware', 'pci/h=
ost-mvebu' and 'pci/host-tegra' into next)
Merging hid/for-next (1d259fbdd1dc Merge branch 'for-3.17/cp2112' into for-=
next)
Merging i2c/i2c/for-next (80e2f6405074 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (2694ad066949 hwmon: (adt7411) Convert to =
devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (7ef04dfbe041 Merge IR patches from branch 'patchwor=
k' into to_next)
$ git reset --hard HEAD^
Merging next-20140724 version of v4l-dvb
Merging kbuild/for-next (9a3127682612 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (21ddb7d0c141 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging pm/linux-next (746e28b8aa21 Merge branch 'acpi-headers')
CONFLICT (content): Merge conflict in drivers/acpi/acpi_extlog.c
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
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
Merging slave-dma/next (ff4d02419ada Merge commit 'renesas-shdma-for-v3.17'=
 into for-linus)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (f6e675324481 Merge branch 'filter-move')
CONFLICT (content): Merge conflict in net/mac80211/cfg.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/mac8=
0211.c
Applying: mac80211: fix for code movement
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (bac9832076ee b43: enable 5 GHz support for N-=
PHY devices)
Merging bluetooth/master (4b9e7e751613 Bluetooth: Fix issue with ADV_IND re=
ports and auto-connection handling)
Merging infiniband/for-next (56c5333cfc84 Merge branches 'cxgb4' and 'mlx5'=
 into for-next)
Merging mtd/master (b6603fe574af Merge tag 'for-linus-20140716' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (e4e069347030 mtd: atmel_nand: NFC: support multiple =
interrupt handling)
Merging crypto/master (4839ddcaba26 crypto: ccp - Remove "select OF" from K=
config)
Merging drm/drm-next (e05444be705b drm/i915: fix initial fbdev setup warnin=
gs)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_render_=
state.c
Merging drm-panel/drm/panel/for-next (ea44739db37f drm/panel: simple: add s=
upport for InnoLux N156BGE-L21 panel)
Merging drm-intel/for-linux-next (2b8ee5710915 drm/i915: Allow overlapping =
userptr objects)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/tegra/for-next (9a9195228478 drm/tegra: dsi - Handle =
non-continuous clock flag)
Merging sound/for-next (214eef76eb86 ALSA: hda - Make vendor quirks lowest =
prio for ALC2xx)
Merging sound-asoc/for-next (e8532405d27d Merge remote-tracking branches 'a=
soc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_=
add_sgs(... GFP_NOIO) holding spinlock.)
Merging input/next (9d8dc3e529a1 Input: atmel_mxt_ts - implement T44 messag=
e handling)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a84352f82862 Merge branch 'for-3.17/core' into for-=
next)
Merging device-mapper/for-next (2ca3856b413b dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (f25c33724d15 mmc: sdhci: add DDR50 1.8V mode support f=
or BayTrail eMMC Controller)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (133d4527eab8 md: flush writes before starting a recove=
ry.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (b5fab1bfdd40 mfd: max77686: Ensure device type=
 IDs are architecture agnostic)
Merging backlight/for-backlight-next (ff9c5422d8eb backlight: pwm-backlight=
: Use devm_gpiod_get_optional())
Merging battery/master (00a588f9d27f power: add driver for battery reading =
on iPaq h3xxx)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (b1f46dd1079d video: clps711x: Fix sparse warnin=
gs)
Merging regulator/for-next (893a07b8712e Merge remote-tracking branches 're=
gulator/topic/s5m8767', 'regulator/topic/tps65217', 'regulator/topic/tps652=
18', 'regulator/topic/tps6586x' and 'regulator/topic/twl' into regulator-ne=
xt)
Merging security/next (7d8b6c63751c CAPABILITIES: remove undefined caps fro=
m all processes)
Merging integrity/next (e27319cdf468 ima: provide double buffering for hash=
 calculation)
CONFLICT (content): Merge conflict in include/linux/key.h
Merging selinux/next (615e51fdda6f selinux: reduce the number of calls to s=
ynchronize_net() when flushing caches)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (82e13c71bc65 Merge branch 'for-3.16' of git://linu=
x-nfs.org/~bfields/linux)
Merging iommu/next (d75c4ee4b06c Merge branches 'iommu/fixes', 'x86/vt-d', =
'x86/amd', 'arm/omap', 'ppc/pamu', 'arm/smmu' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt c=
ount)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (d31e373d0778 irq-gic: remove file name from headi=
ng comment)
CONFLICT (content): Merge conflict in arch/arm/mach-msm/Kconfig
CONFLICT (content): Merge conflict in Documentation/laptops/freefall.c
Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_sysca=
ll_entry() interface)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (35037eda29d5 Merge branch 'devicetree/n=
ext-overlay' into devicetree/next)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (6a497e3501a9 Merge remote-tracking branch 'spi/topic/=
topcliff-pch' into spi-next)
Merging tip/auto-latest (92ecab12a112 Merge branch 'irq/core' into auto-lat=
est)
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/hw.c
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
$ git reset --hard HEAD^
Merging next-20140724 version of tip
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (eba4bfb34d45 EDAC, MCE, AMD: Add MCE decoding fo=
r F15h M60h)
Merging irqchip/irqchip/for-next (c115d15552c0 Merge branch 'irqchip/atmel-=
aic' into irqchip/for-next)
CONFLICT (content): Merge conflict in drivers/irqchip/irq-gic.c
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
Merging ftrace/for-next (e9379e66d8bc Merge branch 'trace/ftrace/core' into=
 trace/for-next)
Merging rcu/rcu/next (56d38c6771fd rcu: Don't track sysidle state if no noh=
z_full=3D CPUs)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (9f6226a762c7 arch: x86: kvm: x86.c: Cleaning up var=
iable is set more than once)
Merging kvm-arm/next (9f6226a762c7 arch: x86: kvm: x86.c: Cleaning up varia=
ble is set more than once)
Merging kvm-ppc/kvm-ppc-next (c387936a9386 KVM: PPC: Book3S: Move vcore def=
inition to end of kvm_arch struct)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (65f513aa75b1 xen/grant: Fix compile warnings)
Merging percpu/for-next (a46e532a9145 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging workqueues/for-next (e5e115c6d38b Merge branch 'for-3.17' into for-=
next)
CONFLICT (content): Merge conflict in kernel/workqueue.c
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging hsi/for-next (0a0ea07d3dff HSI: ssi_protocol: Fix sparse non static=
 symbol warning)
Merging leds/for-next (4da498fc65de leds: add driver for the iPAQ micro)
CONFLICT (add/add): Merge conflict in drivers/hid/hid-gt683r.c
Merging driver-core/driver-core-next (0542ad88fbdd firmware loader: Fix _re=
quest_firmware_load() return val for fw load abort)
CONFLICT (content): Merge conflict in drivers/gpu/drm/armada/armada_crtc.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r7s72100=
.c
CONFLICT (modify/delete): arch/arm/mach-shmobile/board-genmai.c deleted in =
HEAD and modified in driver-core/driver-core-next. Version driver-core/driv=
er-core-next of arch/arm/mach-shmobile/board-genmai.c left in tree.
$ git rm -f arch/arm/mach-shmobile/board-genmai.c
Merging tty/tty-next (af300539def5 tty: serial: msm: Make of_device_id arra=
y const)
Merging usb/usb-next (d508d992026c Merge tag 'for_3.17' of git://git.kernel=
.org/pub/scm/linux/kernel/git/kishon/linux-phy into usb-next)
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_host.c
CONFLICT (content): Merge conflict in drivers/phy/phy-samsung-usb2.h
CONFLICT (content): Merge conflict in drivers/phy/phy-samsung-usb2.c
CONFLICT (content): Merge conflict in drivers/phy/Makefile
CONFLICT (content): Merge conflict in drivers/phy/Kconfig
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/phy=
/samsung-phy.txt
Applying: phy: fix up for devm_phy_create api change
Merging usb-gadget/next (8346b33fad01 Documentation: DocBook: elieminate do=
c build break)
Merging usb-serial/usb-next (5bc9e5933a41 USB: kl5kusb105: Remove klsi_105_=
tiocmset function)
Merging staging/staging-next (d83ba4a1f395 Staging: vt6655: remove redundan=
t comments from bssdb.h)
CONFLICT (modify/delete): drivers/staging/media/sn9c102/Kconfig deleted in =
HEAD and modified in staging/staging-next. Version staging/staging-next of =
drivers/staging/media/sn9c102/Kconfig left in tree.
CONFLICT (modify/delete): drivers/staging/dgrp/dgrp_tty.c deleted in stagin=
g/staging-next and modified in HEAD. Version HEAD of drivers/staging/dgrp/d=
grp_tty.c left in tree.
CONFLICT (modify/delete): drivers/staging/cxt1e1/linux.c deleted in staging=
/staging-next and modified in HEAD. Version HEAD of drivers/staging/cxt1e1/=
linux.c left in tree.
$ git rm -f drivers/staging/dgrp/dgrp_tty.c drivers/staging/cxt1e1/linux.c =
drivers/staging/media/sn9c102/Kconfig
Merging char-misc/char-misc-next (4dcc2ab3f869 drivers/misc/ti-st: Load fir=
mware from ti-connectivity directory.)
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging cgroup/for-next (c6aa7f03a272 Merge branch 'for-3.17' into for-next)
Merging scsi/for-next (6462762107d4 bnx2i: Update driver version to 2.7.10.=
1)
CONFLICT (content): Merge conflict in include/scsi/sg.h
CONFLICT (content): Merge conflict in drivers/scsi/cxgbi/libcxgbi.h
Merging scsi-core/core-for-3.16 (89fb4cd1f717 scsi: handle flush errors pro=
perly)
Merging scsi-drivers/drivers-for-3.16 (8faeb529b2da virtio-scsi: fix variou=
s bad behavior on aborted requests)
Merging target-updates/for-next (a497c3ba1d97 Linux 3.16-rc2)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (4c317b4ead78 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (c7caf86823c7 gpio: remove gpio_ensure_requested())
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (eae266a284f3 pwm: rockchip: document device tree bind=
ings)
Merging dma-buf/for-next (b23b35445ec8 Documentation: devres: Add devm_kmal=
loc() et al)
Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of=
 BSD accounting files)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
CONFLICT (content): Merge conflict in fs/btrfs/ioctl.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (09575693a251 Merge branch 'clk-rockchip' into clk-nex=
t)
Merging random/dev (8776f4cd083a random: limit the contribution of the hw r=
ng to at most half)
CONFLICT (content): Merge conflict in include/uapi/asm-generic/unistd.h
CONFLICT (content): Merge conflict in include/linux/syscalls.h
CONFLICT (content): Merge conflict in drivers/char/hw_random/core.c
CONFLICT (content): Merge conflict in arch/x86/syscalls/syscall_64.tbl
CONFLICT (content): Merge conflict in arch/x86/syscalls/syscall_32.tbl
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (00fefb9cf2b5 aio: use iovec array rather than the singl=
e one)
Merging llvmlinux/for-next (f9da455b93f6 Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/davem/net-next)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (1b1683691f03 I pointed some folks at this and they =
wondered why it wasn't in the kernel Documentation directory. So now it is.)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
Applying: PKCS#7: include linux-err.h for PTR_ERR and IS_ERR
Merging akpm-current/current (76e148844001 fs/dlm/debug_fs.c: remove unnece=
ssary null test before debugfs_remove)
CONFLICT (content): Merge conflict in mm/shmem.c
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: init/main.c: code clean-up
Applying: Update Roland McGrath's mail
Applying: MAINTAINERS: remove two ancient EATA sections
Applying: MAINTAINERS: update IBM ServeRAID RAID info
Applying: arch/arm/mach-omap2: replace strict_strto* with kstrto*
Applying: arch/arm/mach-pxa: replace strict_strto call with kstrto
Applying: arch/arm/mach-s3c24xx/mach-jive.c: replace strict_strto* with kst=
rto*
Applying: arch/arm/mach-w90x900/cpu.c: replace obsolete strict_strto
Applying: arch/powerpc: replace obsolete strict_strto* calls
Applying: arch/x86: replace strict_strto calls
Applying: drivers/scsi: replace strict_strto calls
Applying: include/linux: remove strict_strto* definitions
Applying: pci-dma-compat: add pci_zalloc_consistent helper
Applying: atm: use pci_zalloc_consistent
Applying: block: use pci_zalloc_consistent
Applying: crypto: use pci_zalloc_consistent
Applying: infiniband: use pci_zalloc_consistent
Applying: i810: use pci_zalloc_consistent
Applying: media: use pci_zalloc_consistent
Applying: amd: use pci_zalloc_consistent
Applying: atl1e: use pci_zalloc_consistent
Applying: enic: use pci_zalloc_consistent
Applying: sky2: use pci_zalloc_consistent
Applying: micrel: use pci_zalloc_consistent
Applying: qlogic: use pci_zalloc_consistent
Applying: irda: use pci_zalloc_consistent
Applying: ipw2100: use pci_zalloc_consistent
Applying: mwl8k: use pci_zalloc_consistent
Applying: rtl818x: use pci_zalloc_consistent
Applying: rtlwifi: use pci_zalloc_consistent
Applying: scsi: use pci_zalloc_consistent
Applying: staging: use pci_zalloc_consistent
Applying: synclink_gt: use pci_zalloc_consistent
Applying: vme: bridges: use pci_zalloc_consistent
Applying: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary=
 OOM messages
Applying: kernel/posix-timers.c: code clean-up
Applying: kernel-posix-timersc-code-clean-up-checkpatch-fixes
Applying: MAINTAINERS: update microcode patterns
Applying: MAINTAINERS: update cifs location
Applying: MAINTAINERS: use the correct efi-stub location
Applying: MAINTAINERS: update clk/sirf patterns
Applying: MAINTAINERS: fix ssbi pattern
Applying: MAINTAINERS: use correct filename for sdhci-bcm-kona
Applying: MAINTAINERS: fix PXA3xx NAND FLASH DRIVER pattern
Applying: MAINTAINERS: update picoxcell patterns
Applying: MAINTAINERS: remove section CIRRUS LOGIC EP93XX OHCI USB HOST DRI=
VER
Applying: MAINTAINERS: remove METAG imgdafs pattern
Applying: MAINTAINERS: remove unused radeon drm pattern
Applying: MAINTAINERS: remove unusd ARM/QUALCOMM MSM pattern
Applying: MAINTAINERS: remove unused NFSD pattern
Applying: bin2c: move bin2c in scripts/basic
Applying: kernel: build bin2c based on config option CONFIG_BUILD_BIN2C
Applying: kexec: rename unusebale_pages to unusable_pages
Applying: kexec: move segment verification code in a separate function
Applying: kexec: use common function for kimage_normal_alloc() and kimage_c=
rash_alloc()
Applying: resource: provide new functions to walk through resources
Applying: kexec: make kexec_segment user buffer pointer a union
Applying: kexec: new syscall kexec_file_load() declaration
Applying: kexec: implementation of new syscall kexec_file_load
Applying: kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fi=
xes
Applying: kexec: return error if file bytes are less then file size
Applying: purgatory/sha256: provide implementation of sha256 in purgaotory =
context
Applying: purgatory: core purgatory functionality
Applying: purgatory: run host built programs from objtree
Applying: kexec: load and relocate purgatory at kernel load time
Applying: kexec-load-and-relocate-purgatory-at-kernel-load-time-fix
Applying: kexec-bzImage64: support for loading bzImage using 64bit entry
Applying: kexec: fix freeing up for image loader data loading
Applying: kexec: support for kexec on panic using new system call
Applying: kexec-bzimage64: fix the ordering of registers
Applying: kexec: support kexec/kdump on EFI systems
Applying: kexec-support-kexec-kdump-on-efi-systems-fix
Applying: fs.h: remove unnecessary extern prototypes
Applying: fs.h: whitespace neatening
Applying: fs.h: a few more whitespace neatenings
Applying: fs.h: add argument names to struct file_lock_operations (*funcs)
Applying: fs.h: add member argument descriptions to lock_manager_operations
Applying: fs/dlm/plock.c: add argument descriptions to notify
Applying: dlm, lockd: remove unused conf from lm_grant
Applying: dlm: plock: reduce indentation by rearranging order
Applying: fs: dlm/lockd: convert int result to unsigned char type
Applying: kernel/kprobes.c: convert printk to pr_foo()
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: mm-replace-remap_file_pages-syscall-with-emulation-fix
Applying: mm: remap_file_pages: initialize populate before usage
Applying: mm: remap_file_pages: grab file ref to prevent race while mmaping
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
Merging akpm/master (8009dc9f03e8 mm: add strictlimit knob)

--Sig_/es3o+exXAaj6GK5c+SL_HSR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0i2JAAoJEMDTa8Ir7ZwVNzMQAItm3ebKW2hO7kiuyTdT1s/g
WLQa7XPmnb3izz+KA36FMxD2j1X5Sxy6aqNjdbSOtak52BStrZYnrHzKDiFQ1R9x
u2xFMxqXYv2fE16CF///dd2C+Z1zZVhFfHgcfstzfFzmKc7kY21JeUk5+OMzA98k
Pogg+wLxT2U1g7dBbUgw0wpegD7YpHTp3dpr4d6oVmrLjTIHTsawFsJpD/UsEPJc
McKxBpAR0ARvfEkP2xQmRgEa+R3tXO3i2S5gAaDpxbBjPRL2IhE3P26T/ON3igaK
Yszo/mGwJaIjOh9FdcmumgtdJzFxuFJyaQ5jtEqCskSatguKPXTLMNF4d1MgtnHz
UhqF6tST4Cn/+RJbRAAkosQfK8ldwQoei2gtO5oiCAWS0h8Sp64cESiZJvOQWBmX
1O8qhlZw5+Rjir4ZsBexZO3PKHk6hS4PhpqunS7icVdPAoN/SesbbQfGcBzDmmB6
Ar1JnWXxl3tbOUtEIaN+SXPWa8V9SrgLj5go1MXPAHGJwWFJmyQOQuFScRxSlpfX
uFr0evod+9DLfnM9nqH7kxZorVSZUZW2MdgdI7kiVXABAF/d/+xNUWe0p9uGjC1b
cFImPwwhGg7OQsj6StUapFLGMMY2xl120x1rYVCEbrowB/2v8Buqg6cZrXDpyDU7
ntGZw/UK7i3YG7R2a/+6
=0egr
-----END PGP SIGNATURE-----

--Sig_/es3o+exXAaj6GK5c+SL_HSR--
