Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaGQIyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:54:21 -0400
Received: from ozlabs.org ([103.22.144.67]:45126 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbaGQIyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:54:08 -0400
Date: Thu, 17 Jul 2014 18:53:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jul 17
Message-ID: <20140717185358.5a245a6e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+uU9YXH.7lfy+x95zEazza_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+uU9YXH.7lfy+x95zEazza_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140716:

The mvebu tree gained conflicts against Linus' and the arm trees.

The samsung tree gained conflicts against the arm-soc tree.

The wireless-next tree lost its build failure.

The usb-gadget tree gained a conflict against Linus' tree.

The akpm tree lost its build failure.

Non-merge commits (relative to Linus' tree): 6345
 6091 files changed, 236613 insertions(+), 335198 deletions(-)

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

I am currently merging 222 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (b6603fe574af Merge tag 'for-linus-20140716' of git:/=
/git.infradead.org/linux-mtd)
Merging fixes/master (1795cd9b3a91 Linux 3.16-rc5)
Merging kbuild-current/rc-fixes (dd5a6752ae7d firmware: Create directories =
for external firmware)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (cda390bb8f0f Merge branch 'kprobes-test-fixes' o=
f git://git.linaro.org/people/tixy/kernel into fixes)
Merging m68k-current/for-linus (5bc8c7cdeb6e m68k: Export mach_random_get_e=
ntropy to modules)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (f56029410a13 powerpc/perf: Never program book3=
s PMCs with values >=3D 0x80000000)
Merging sparc/master (894e552cfaa3 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging net/master (38a4dfcf807e Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/pablo/nf)
Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
Merging sound-current/for-linus (4da63c6fc426 ALSA: hda - Fix broken PM due=
 to incomplete i915 initialization)
Merging pci-current/for-linus (8e809611be2e GenWQE: Use pci_enable_msi_rang=
e() so we can fall back to fewer MSIs)
Merging wireless/master (2c4db12ec469 rt2800usb: Don't perform DMA from sta=
ck)
Merging driver-core.current/driver-core-linus (aff008ad813c platform_get_ir=
q: Revert to platform_get_resource if of_irq_get fails)
Merging tty.current/tty-linus (1795cd9b3a91 Linux 3.16-rc5)
Merging usb.current/usb-linus (1795cd9b3a91 Linux 3.16-rc5)
Merging usb-gadget-fixes/fixes (8035691365b8 usb: musb: dsps: fix the base =
address for accessing the mode register)
Merging usb-serial-fixes/usb-linus (1795cd9b3a91 Linux 3.16-rc5)
Merging staging.current/staging-linus (9359003385a2 Merge tag 'iio-fixes-fo=
r-3.16d' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (1795cd9b3a91 Linux 3.16-rc5)
Merging input-current/for-linus (31972f6e517d Input: ti_am335x_tsc - warn a=
bout incorrect spelling)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (e052dbf55461 hwrng: virtio - ensure reads ha=
ppen after successful probe)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
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
Merging drm-intel-fixes/for-linux-next-fixes (c6930992948a Revert "drm/i915=
: reverse dp link param selection, prefer fast over wide again")
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (4c834452aad0 Linux 3.16-rc3)
Merging arm/for-next (368629cb0c2a Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (4c834452aad0 Linux 3.16-rc3)
Merging arm-soc/for-next (0b15a54c71d2 arm-soc: document merges)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/headsmp.S
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (64ef06b5e347 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (93ca3f148ed4 Merge branch 'mvebu/soc-cpuidle' into =
mvebu/for-next)
CONFLICT (modify/delete): drivers/cpuidle/cpuidle-armada-370-xp.c deleted i=
n mvebu/for-next and modified in HEAD. Version HEAD of drivers/cpuidle/cpui=
dle-armada-370-xp.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
CONFLICT (content): Merge conflict in arch/arm/Kconfig
$ git rm -f drivers/cpuidle/cpuidle-armada-370-xp.c
Merging renesas/next (1b6ff88403ad Merge branches 'heads/clock-for-v3.17' a=
nd 'cleanup-boards-for-v3.17' into next)
Merging samsung/for-next (cb588aed593a Merge branch 'v3.17-next/dt-samsung'=
 into for-next)
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
CONFLICT (rename/delete): arch/arm/mach-s5pv210/include/mach/gpio-samsung.h=
 deleted in samsung/for-neRecorded preimage for 'arch/arm/Kconfig'
CONFLICT (modify/delete): arch/arm/mach-s5pv210/dev-audio.c deleted in sams=
ung/for-next and modified in HEAD. Version HEAD of arch/arm/mach-s5pv210/de=
v-audio.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/Kconfig
$ git rm -f arch/arm/mach-s5pv210/dev-audio.c arch/arm/mach-s5pv210/include=
/mach/gpio-samsung.h arch/arm/mach-s5pv210/mach-aquila.c arch/arm/mach-s5pv=
210/mach-goni.c arch/arm/mach-s5pv210/mach-smdkv210.c arch/arm/mach-s5pv210=
/setup-fb-24bpp.c arch/arm/mach-s5pv210/setup-fimc.c arch/arm/mach-s5pv210/=
setup-i2c0.c arch/arm/mach-s5pv210/setup-i2c1.c arch/arm/mach-s5pv210/setup=
-i2c2.c arch/arm/mach-s5pv210/setup-ide.c arch/arm/mach-s5pv210/setup-keypa=
d.c arch/arm/mach-s5pv210/setup-sdhci-gpio.c arch/arm/mach-s5pv210/setup-sp=
i.c arch/arm/plat-samsung/s5p-irq-eint.c
Merging sunxi/sunxi/for-next (c37f22f01a50 Merge branches 'sunxi/core-for-3=
.17', 'sunxi/dt-for-3.17' and 'sunxi/clocks-for-3.17' into sunxi/for-next)
Merging tegra/for-next (c362210640fa Merge branch for-3.17/defconfig into f=
or-next)
Merging arm64/for-next/core (da57a369d3bc arm64: Enable TEXT_OFFSET fuzzing)
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
Merging metag/for-next (8bc613befaec metag: hugetlbpage: Remove null pointe=
r checks that could never happen)
Merging microblaze/next (08e6bbda0b48 microblaze: Wire-up renameat2 syscall)
Merging mips/mips-for-linux-next (de3d02f3906d Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (1860e379875d Linux 3.15)
Merging powerpc/next (cd1154770ba9 powerpc/85xx: drop hypervisor specific b=
oard compatibles)
Merging fsl/next (cd1154770ba9 powerpc/85xx: drop hypervisor specific board=
 compatibles)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (50cf51f19faa s390/kdump: Return NOTIFY_OK for all ac=
tions other than MEM_GOING_OFFLINE)
Merging sparc-next/master (894e552cfaa3 Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
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
Merging ext4/dev (14e4f8cecbc4 ext4: fix punch hole on files with indirect =
mapping)
Merging f2fs/dev (4b2868aa4f07 f2fs: remove the unused stat_lock)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (f2b3455e47c7 fuse: replace count*size kzalloc by kca=
lloc)
Merging gfs2/master (c04d5ee35ba6 GFS2: fs/gfs2/rgrp.c: kernel-doc warning =
fixes)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (e655f945cd7b Merge branch 'bugfixes' into linux-nex=
t)
Merging nfsd/nfsd-next (e8051c837bd9 nfsd: eliminate nfsd4_init_callback)
CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (44305ebde243 UBI: fastmap: do not miss bit-flips)
Merging xfs/for-next (a087481811be xfs: document log sysfs attributes in te=
sting ABI)
Merging file-private-locks/linux-next (73a8f5f7e635 locks: purge fl_owner_t=
 from fs/locks.c)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging pci/next (792688fde431 Merge branches 'pci/host-generic', 'pci/host=
-mvebu', 'pci/host-rcar', 'pci/host-tegra', 'pci/msi', 'pci/misc', 'pci/res=
ource' and 'pci/virtualization' into next)
Merging hid/for-next (1d259fbdd1dc Merge branch 'for-3.17/cp2112' into for-=
next)
Merging i2c/i2c/for-next (2fd6cf0523fc i2c: taos-evm: Use module_serio_driv=
er())
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (7785fea904f1 hwmon: (asc7621) Make map ta=
bles const)
Merging v4l-dvb/master (5756894cd1fe Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (cf207dde8ee1 Merge branches 'kbuild/misc' and 'kbu=
ild/kbuild' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (480296e3453d Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging pm/linux-next (0f02773c27a8 Merge branch 'pm-sleep-next' into linux=
-next)
CONFLICT (content): Merge conflict in drivers/acpi/acpi_extlog.c
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (b6902baa1fab Merge branch 'for-rc' of .git into next)
Merging ieee1394/for-next (655fc39bf403 firewire: IEEE 1394 (FireWire) supp=
ort should depend on HAS_DMA)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (dd8ecfcac66b dmaengine: dw: don't perform DMA when =
dmaengine_submit is called)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (a9f559c37b58 net: ppp: access ppp->nextseq only if=
 CONFIG_PPP_MULTILINK is defined)
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (f95f59fe5d2b mwifiex: remove redundant TDLS s=
etup action frame check and avoid leaks)
Merging bluetooth/master (46c4c941a417 Bluetooth: Fix always checking the b=
lacklist for incoming connections)
Merging infiniband/for-next (e082dbeccab6 Merge branches 'cxgb4' and 'mlx5'=
 into for-next)
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb4/device.c
Merging mtd/master (812c5fa82bae mtd: cfi_cmdset_0001.c: add support for Sh=
arp LH28F640BF NOR)
Merging l2-mtd/master (d68a5c3d2db4 mtd: denali: use 8 bytes for READID com=
mand)
Merging crypto/master (96956aef2ff5 crypto: drbg - drbg_exit() can be stati=
c)
Merging drm/drm-next (62eb3e20f8f3 drm/tilcdc: Fix build breakage)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
Merging drm-panel/drm/panel/for-next (102932b0e474 drm/panel: add support f=
or Foxlink FL500WVR00-A0T panel)
Merging drm-intel/for-linux-next (7c908fe2cad0 drm/i915: extract and improv=
e gen8_irq_power_well_post_enable)
Merging drm-tegra/drm/tegra/for-next (9a9195228478 drm/tegra: dsi - Handle =
non-continuous clock flag)
Merging sound/for-next (2d9772ef653c ALSA: hda - Add NULL check to all PM o=
ps in hda_intel.c)
Merging sound-asoc/for-next (53ca92c6b1e1 Merge remote-tracking branches 'a=
soc/topic/tlv320aic32x4', 'asoc/topic/tlv320aic3x', 'asoc/topic/wm0010', 'a=
soc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_=
add_sgs(... GFP_NOIO) holding spinlock.)
Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return f=
rom mxt_get_bootloader_version)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a84352f82862 Merge branch 'for-3.17/core' into for-=
next)
Merging device-mapper/for-next (8b2b293dc003 dm crypt: sort writes)
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
Merging mfd-lj/for-mfd-next (819b2dd1af7b mfd: arizona: Update DT binding t=
o support MICVDD init_data)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (b1f46dd1079d video: clps711x: Fix sparse warnin=
gs)
Merging regulator/for-next (1184f64dbef6 Merge remote-tracking branches 're=
gulator/topic/s5m8767', 'regulator/topic/tps65217', 'regulator/topic/tps652=
18', 'regulator/topic/tps6586x' and 'regulator/topic/twl' into regulator-ne=
xt)
Merging security/next (b6b8a371f554 Merge branch 'stable-3.16' of git://git=
.infradead.org/users/pcmoore/selinux into next)
Merging integrity/next (e27319cdf468 ima: provide double buffering for hash=
 calculation)
Merging selinux/next (615e51fdda6f selinux: reduce the number of calls to s=
ynchronize_net() when flushing caches)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (7171511eaec5 Linux 3.16-rc1)
Merging iommu/next (7ee9bd3a4990 Merge branches 'iommu/fixes', 'x86/vt-d', =
'x86/amd', 'arm/omap', 'ppc/pamu' and 'core' into next)
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
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (c9e0fb3bb3aa tty: Update hypervisor tty=
 drivers to use core stdout parsing code.)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (0b68afd9f3fd Merge remote-tracking branch 'spi/topic/=
topcliff-pch' into spi-next)
Merging tip/auto-latest (09ea0f7492ff Merge branch 'x86/xsave')
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (eba4bfb34d45 EDAC, MCE, AMD: Add MCE decoding fo=
r F15h M60h)
Merging irqchip/irqchip/for-next (ecdad51eb008 Merge branch 'irqchip/urgent=
' into irqchip/for-next)
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
Merging ftrace/for-next (d048a8c7b509 tracing: Add description of set_graph=
_notrace to tracing/README)
Merging rcu/rcu/next (ddfb3b363440 rcu: Create rcuo kthreads only for onlin=
ed CPUs)
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
Merging workqueues/for-next (8e8114ef248e Merge branch 'for-3.17' into for-=
next)
CONFLICT (content): Merge conflict in kernel/workqueue.c
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (1795cd9b3a91 Linux 3.16-rc5)
Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module re=
fcounting)
Merging leds/for-next (7e7743901b53 leds:pca963x: Update for PCA9635 and co=
rrect statement about MODE2 OUTDRV default)
CONFLICT (add/add): Merge conflict in drivers/hid/hid-gt683r.c
Merging driver-core/driver-core-next (954513551f5a staging: android: Cleanu=
p style issues)
Merging tty/tty-next (ca17749259d2 Merge 3.16-rc5 into tty-next.)
Merging usb/usb-next (46865bf3d6b4 Merge tag 'usb-serial-3.17-rc1' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb-next)
Merging usb-gadget/next (4546527350c3 usb: gadget: f_rndis: fix interface i=
d for OS descriptors)
CONFLICT (content): Merge conflict in include/uapi/linux/usb/functionfs.h
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_cppi41.c
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_core.c
Merging usb-serial/usb-next (5bc9e5933a41 USB: kl5kusb105: Remove klsi_105_=
tiocmset function)
Merging staging/staging-next (2cbc7a3fbac4 Staging: adl_pci9118: a language=
 issue fixed)
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
Merging char-misc/char-misc-next (ce05b68692f0 dma: Fix MIC X100 DMA Driver=
 Kconfig option)
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging cgroup/for-next (c6aa7f03a272 Merge branch 'for-3.17' into for-next)
Merging scsi/for-next (4944d7521bec pm8001: more fixes to honor return valu=
e)
CONFLICT (content): Merge conflict in include/scsi/sg.h
Merging scsi-core/core-for-3.16 (7bafc240e126 scsi: use the scsi data buffe=
r length to extract transfer size)
Merging scsi-drivers/drivers-for-3.16 (8faeb529b2da virtio-scsi: fix variou=
s bad behavior on aborted requests)
Merging target-updates/for-next (a497c3ba1d97 Linux 3.16-rc2)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (400f0cbd75df Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (b45d1c62672f Merge branch 'devel' into for-next)
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
Merging clk/clk-next (cdae1730d0c6 Merge branch 'clk-fixes' into clk-next)
Merging random/dev (5458c2fecbb8 hw_random: fix sparse warning (NULL vs 0 f=
or pointer))
CONFLICT (content): Merge conflict in drivers/char/hw_random/core.c
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (6e830d53717c Merge ../aio-fixes)
Merging llvmlinux/for-next (f9da455b93f6 Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/davem/net-next)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (1b1683691f03 I pointed some folks at this and they =
wondered why it wasn't in the kernel Documentation directory. So now it is.)
Merging akpm-current/current (9f5b39070c6c fs/dlm/debug_fs.c: remove unnece=
ssary null test before debugfs_remove)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: init/main.c: code clean-up
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
Merging akpm/master (aa661602d17c mm: add strictlimit knob)

--Sig_/+uU9YXH.7lfy+x95zEazza_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTx48rAAoJEMDTa8Ir7ZwVM7gP/14xw8uhVVplAVsZmdua72F0
iipSXp9FYgY3V5+jUYo3VBE30/QVomDoAUkKdR4fJzewKBjv9d3e/DPep9odFyjR
c70yoWpz3fwR+WKp75vWtAAlyd0ZRRijCbWr9qQyE79RGcuIKdt5/8f6gvbA6srK
7fxNSxVOA4F2qhxhh8F8R8MWSAmnfmpfJsnDAFCCHY4mvpsWwHpex0m7MyKMRcVA
v1DoCBMsn1vuhAj+WbuNRDJK457Ogunm9U0vjTBOrt6uFt+w6f7zN20/U5camOBZ
rmZ51ggluvE1Un2swrGLTyP2/4lGJqdMfmfk2Tu4xS3WFbfR4nrP2HcmA3vUuoPH
BVCTqBNj599AxPpZmI7QHpUtr5SutKRBucJuhmC9oiijGKEmhNxWAOQQTl1nb/2J
XULrfZG32mmadTwwFWhbHVNEysgOi0hoyGZHvud170OjZ0MEAm+uA1aYW6bVq6Wv
KOYrSKmvgWTAJNyL/F+sAnKxUHNzERpFbk4Z5TTccV99IfTIzt4mcOsNgzV16iZZ
/GBJDHYGfu4E6EtpZ5GSgObE4sPi+D/uJP8amHqxFEzC1m02kTKq1RM9gqqobW3I
AaB8KFJfiPctmDsoYmLU/8Vsy2Ox5sjItdJZ+44xyyxgQ3C/0JODoTZ5EKejWs7D
srrLt4D72aXPFWeav2t+
=eP86
-----END PGP SIGNATURE-----

--Sig_/+uU9YXH.7lfy+x95zEazza_--
