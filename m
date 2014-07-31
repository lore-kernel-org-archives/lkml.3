Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaGaLAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:00:15 -0400
Received: from ozlabs.org ([103.22.144.67]:49695 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaGaLAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:00:09 -0400
Date: Thu, 31 Jul 2014 21:00:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jul 31
Message-ID: <20140731210000.46f723d2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5wMSVXeM_Ipcyy26eEr00nk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5wMSVXeM_Ipcyy26eEr00nk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140730:

Removed trees: mfd-fixes, mfd

Added tree: mips-fixes

Renamed tree: mfd-lj to mfd

The net tree lost its build failure.

The modules tree still had its build failure so I used the version from
next-20140725.

The mmc-uh tree still had its build failure so I used the version from
next-20140725.

The tip tree lost its build failure.

The kvm-arm tree gained a conflict against Linus' tree.

The gpio tree still had its build failure so I used the version from
next-20140728.

The akpm-current tree gained a build failure for which I applied a
supplied patch.

Non-merge commits (relative to Linus' tree): 9437
 8349 files changed, 350443 insertions(+), 428708 deletions(-)

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

I am currently merging 223 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (26bcd8b72563 Merge tag 'devicetree-for-linus' of git=
://git.secretlab.ca/git/linux)
Merging fixes/master (1795cd9b3a91 Linux 3.16-rc5)
Merging kbuild-current/rc-fixes (dd5a6752ae7d firmware: Create directories =
for external firmware)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (a5ab9a0e748f ARM: idmap: add identity mapping us=
age node)
Merging m68k-current/for-linus (5bc8c7cdeb6e m68k: Export mach_random_get_e=
ntropy to modules)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (726d129dfdc9 MIPS: OCTEON: make get_system_t=
ype() thread-safe)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging sparc/master (31dab719fa50 Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/herbert/crypto-2.6)
Merging net/master (26bcd8b72563 Merge tag 'devicetree-for-linus' of git://=
git.secretlab.ca/git/linux)
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
Merging crypto-current/master (f3c400ef473e crypto: arm-aes - fix encryptio=
n of unaligned data)
Merging ide/master (15ba2236f355 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (f4be89cecea4 drm/i915: Fix cr=
ash when failing to parse MIPI VBT)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (3a5d0df211dd mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (740c54c889b6 Merge branch 'devel-stable' into for-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
Merging arm-perf/for-next/perf (4c834452aad0 Linux 3.16-rc3)
Merging arm-soc/for-next (1ef865ffc69f arm-soc: document merges)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/headsmp.S
CONFLICT (modify/delete): arch/arm/mach-s5pv210/include/mach/memory.h delet=
ed in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/mach-=
s5pv210/include/mach/memory.h left in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
CONFLICT (modify/delete): arch/arm/mach-integrator/include/mach/memory.h de=
leted in arm-soc/for-next and modified in HEAD. Version HEAD of arch/arm/ma=
ch-integrator/include/mach/memory.h left in tree.
$ git rm -f arch/arm/mach-integrator/include/mach/memory.h arch/arm/mach-s5=
pv210/include/mach/memory.h
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (5424d6fd48e6 Merge branch 'imx/cleanup' into for-=
next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (2e11b0361fb0 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (a0c8f334c02f Merge branch 'heads/shdma-for-v3.17' int=
o next)
Merging samsung/for-next (e46293c319fd Merge branch 'v3.17-next/dt-samsung-=
2' into for-next)
Merging sunxi/sunxi/for-next (44b61dc11c6d Merge branch 'sunxi/dt-for-3.17'=
 into sunxi/for-next)
Merging tegra/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging arm64/for-next/core (3666f88010d7 arm64: defconfig: enable devtmpfs=
 mount option)
Merging blackfin/for-linus (b76f98236a23 blackfin: vmlinux.lds.S: reserve 3=
2 bytes space at the end of data section for XIP kernel)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (6b15075c2c36 [IA64] sn: Do not needlessly convert betwee=
n pointers and integers)
Merging m68k/for-next (9117710a5997 m68k/sun3: Remove define statement no l=
onger needed)
Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prot=
otype for kobjsize())
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (ef264cf0c490 microblaze: Change libgcc-style funct=
ions from lib-y to obj-y)
Merging mips/mips-for-linux-next (815fa52f5ddd Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (64aa90f26c06 Linux 3.16-rc7)
Merging powerpc/next (ea668936b708 Add Michael Ellerman as powerpc co-maint=
ainer)
Merging fsl/next (cd1154770ba9 powerpc/85xx: drop hypervisor specific board=
 compatibles)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (26d766c60f4e s390/3215: fix hanging console issue)
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
Merging ceph/master (d1a5fb9fecd4 rbd: remove extra newlines from rbd_warn(=
) messages)
Merging cifs/for-next (bb7cd8d76356 [CIFS] Update cifs version)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (3f1be4f9c9dc udf: avoid redundant memcpy when writin=
g data in ICB)
Merging ext4/dev (3c17714e6131 ext4: fix COLLAPSE RANGE test for bigalloc f=
ile systems)
Merging f2fs/dev (33be828ada72 f2fs: remove redundant lines in allocate_dat=
a_block)
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
Merging nfsd/nfsd-next (1161312c0b33 nfsd: rename unhash_generic_stateid to=
 unhash_ol_stateid)
CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (6390e991776e Revert "UBIFS: add a log overlap ass=
ertion")
Merging xfs/for-next (c3dd0d14e34a Merge branch 'xfs-misc-fixes-3.17-1' int=
o for-next)
Merging file-private-locks/linux-next (73a8f5f7e635 locks: purge fl_owner_t=
 from fs/locks.c)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging hch-vfs/vfs-for-3.17 (f68cbb8bd2c3 dcache: d_splice_alias should de=
tect loops)
Merging pci/next (981c191778a4 Merge branches 'pci/host-designware', 'pci/h=
ost-mvebu' and 'pci/host-tegra' into next)
Merging hid/for-next (914b9e7fdb8d Merge branch 'for-3.17/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (80e2f6405074 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (f69b017bef03 hwmon: (pwm-fan) Make SENSOR=
S_PWM_FAN depend on OF)
Merging v4l-dvb/master (07178d53d61f Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (9586848e26c7 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (1eecf0052607 Merge branch 'for-3.17' into for-next)
Merging pm/linux-next (4fa82a738c6c Merge branch 'pm-cpufreq' into linux-ne=
xt)
CONFLICT (content): Merge conflict in drivers/cpuidle/Kconfig.arm
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
Merging slave-dma/next (4fbd804e009a dmaengine: sun6i: Fix memory leaks)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (2d871aa07136 net: stmmac: add platform init/exit f=
or Altera's ARM socfpga)
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (568ba389be50 brcmfmac: Fix OOB interrupt not =
working for BCM43362)
Merging bluetooth/master (8500d791c458 Bluetooth: Fix crash in the Marvell =
driver initialization codepath)
CONFLICT (content): Merge conflict in net/6lowpan/iphc.c
Merging infiniband/for-next (56c5333cfc84 Merge branches 'cxgb4' and 'mlx5'=
 into for-next)
Merging mtd/master (b6603fe574af Merge tag 'for-linus-20140716' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (2a500afe1e0e mtd: gpmi: make blockmark swapping opti=
onal)
Merging crypto/master (4839ddcaba26 crypto: ccp - Remove "select OF" from K=
config)
Merging drm/drm-next (8bed5cc765ff drm/rcar-du: Fix maximum frame buffer pi=
tch computation)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_render_=
state.c
Merging drm-panel/drm/panel/for-next (ea44739db37f drm/panel: simple: add s=
upport for InnoLux N156BGE-L21 panel)
Merging drm-intel/for-linux-next (5193109cd669 drm/i915: Align intel_dsi*.c=
 files a bit)
Merging drm-tegra/drm/tegra/for-next (9a9195228478 drm/tegra: dsi - Handle =
non-continuous clock flag)
Merging sound/for-next (27c828816d74 ALSA: firewire: trivial typo fixes in =
Kconfig)
Merging sound-asoc/for-next (f385f18d5191 Merge remote-tracking branch 'aso=
c/topic/wm8985' into asoc-next)
Merging modules/modules-next (2e3a10a1551d ARM: avoid ARM binutils leaking =
ELF local symbols)
$ git reset --hard HEAD^
Merging next-20140725 version of modules
Merging virtio/virtio-next (eeec626366ff Revert "hwrng: virtio - ensure rea=
ds happen after successful probe")
Merging input/next (9d469d033d13 Input: atmel_mxt_ts - use deep sleep mode =
when stopped)
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
Merging mmc-uh/next (25f7dadbd982 mmc: dw_mmc: change to use recommended re=
set procedure)
$ git reset --hard HEAD^
Merging next-20140725 version of mmc-uh
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (133d4527eab8 md: flush writes before starting a recove=
ry.)
Merging mfd/for-mfd-next (7caa79917ad4 MAINTAINERS: Update MFD repo locatio=
n)
Merging backlight/for-backlight-next (2188a988bb87 backlight: Add driver fo=
r iPAQ micro backlight)
Merging battery/master (5e37195f30cc ipaq_micro_battery: fix sparse non sta=
tic symbol warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (fea85621060f Merge branch '3.17/hdmi-infoframe'=
 into for-next)
Merging regulator/for-next (4f49ec6cc076 Merge remote-tracking branches 're=
gulator/topic/tps65218', 'regulator/topic/tps6586x' and 'regulator/topic/tw=
l' into regulator-next)
Merging security/next (a3d64df849bc tpm: simplify code by using %*phN speci=
fier)
Merging integrity/next (e27319cdf468 ima: provide double buffering for hash=
 calculation)
CONFLICT (content): Merge conflict in include/linux/key.h
Merging selinux/next (615e51fdda6f selinux: reduce the number of calls to s=
ynchronize_net() when flushing caches)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (64aa90f26c06 Linux 3.16-rc7)
Merging iommu/next (e2045c68c4b6 Merge branches 'x86/vt-d', 'x86/amd', 'arm=
/omap', 'ppc/pamu' and 'arm/smmu' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt c=
ount)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (51a7097426f2 doc: fix two typos in watchdog-api.t=
xt)
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
Merging devicetree/devicetree/next (2a0ef9bf3b1e Merge branch 'devicetree/n=
ext-overlay' into devicetree/next)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (e553aae1e9f3 Merge remote-tracking branch 'spi/topic/=
topcliff-pch' into spi-next)
Merging tip/auto-latest (49144c53f900 Merge branch 'x86/xsave')
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/hw.c
CONFLICT (content): Merge conflict in drivers/acpi/acpi_extlog.c
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
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/arm=
/gic.txt
Merging ftrace/for-next (6386b361ccf0 Merge branch 'trace/ftrace/core' into=
 trace/for-next)
Merging rcu/rcu/next (1c91efb24799 rcutorture: Specify CONFIG_CPUMASK_OFFST=
ACK=3Dy for TREE07)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (296f047502f1 KVM: vmx: remove duplicate vmx_mpx_sup=
ported() prototype)
Merging kvm-arm/next (d329de09333a arm64: KVM: enable trapping of all debug=
 registers)
CONFLICT (content): Merge conflict in virt/kvm/arm/vgic.c
Merging kvm-ppc/kvm-ppc-next (1287cb3fa85c KVM: PPC: Book3S: Move vcore def=
inition to end of kvm_arch struct)
CONFLICT (content): Merge conflict in Documentation/virtual/kvm/api.txt
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (28d4ce7322cf Merge branch 'devel/for-linus-3.17=
' into linux-next)
CONFLICT (content): Merge conflict in include/xen/grant_table.h
CONFLICT (content): Merge conflict in drivers/xen/grant-table.c
CONFLICT (content): Merge conflict in arch/x86/xen/grant-table.c
Merging percpu/for-next (a46e532a9145 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging workqueues/for-next (ebb48ccd98d1 Merge branch 'for-3.17' into for-=
next)
CONFLICT (content): Merge conflict in kernel/workqueue.c
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (3059bfa09df6 Merge remote-tracking branches 'regma=
p/topic/getdev' and 'regmap/topic/getreg' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (e661c8978e48 leds: ipaq-micro: fix sparse non static=
 symbol warning)
CONFLICT (add/add): Merge conflict in drivers/hid/hid-gt683r.c
Merging driver-core/driver-core-next (0542ad88fbdd firmware loader: Fix _re=
quest_firmware_load() return val for fw load abort)
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in drivers/gpu/drm/armada/armada_crtc.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r7s72100=
.c
CONFLICT (modify/delete): arch/arm/mach-shmobile/board-genmai.c deleted in =
HEAD and modified in driver-core/driver-core-next. Version driver-core/driv=
er-core-next of arch/arm/mach-shmobile/board-genmai.c left in tree.
$ git rm -f arch/arm/mach-shmobile/board-genmai.c
Merging tty/tty-next (22524b02b17b Revert "ARC: [arcfpga] stdout-path now s=
uffices for earlycon/console")
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
Merging staging/staging-next (a948318f70b4 staging: usbip: remove redundant=
 return statements)
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
Merging char-misc/char-misc-next (16eb2bfc65ef Merge tag 'extcon-next-for-3=
.17' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into c=
har-misc-next)
CONFLICT (content): Merge conflict in drivers/dma/Makefile
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in drivers/Kconfig
Merging cgroup/for-next (abdfd21809f2 Merge branch 'for-3.17' into for-next)
Merging scsi/for-next (cbf67842c3d9 scsi_debug: support scsi-mq, queues and=
 locks)
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
Merging pinctrl/for-next (e1ee5c578fb1 pinctrl: baytrail: Convert to use gp=
iolib irqchip)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (39b2bbe3d715 gpio: add flags argument to gpiod_get*(=
) functions)
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/board-paz00.c
$ git reset --hard HEAD^
Merging next-20140728 version of gpio
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
Merging clk/clk-next (d14c17b235ab clk: clps711x: Add DT bindings documenta=
tion)
CONFLICT (content): Merge conflict in drivers/base/platform.c
Merging random/dev (b65797d576be random: limit the contribution of the hw r=
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
Merging rd-docs/master (c78004d4a428 Copying to local variable is actually =
not neccessary, if all we need to do is snprintf(). This also removes probl=
em where devname could be missing zero termination.)
CONFLICT (content): Merge conflict in Documentation/laptops/freefall.c
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
Merging akpm-current/current (929c76e4e629 fs/dlm/debug_fs.c: remove unnece=
ssary null test before debugfs_remove)
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
Applying: kexec-export-free_huge_page-to-vmcoreinfo-fix
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: x86, vdso: fix vdso2c's special_pages error checking
Applying: arm64,ia64,ppc,s390,sh,tile,um,x86,mm: remove default gate area
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
Applying: mm: allow drivers to prevent new writable mappings
Applying: shm: add sealing API
Applying: shm: add memfd_create() syscall
Applying: selftests: add memfd_create() + sealing tests
Applying: selftests: add memfd/sealing page-pinning tests
Applying: shm: wait for pins to be released when sealing
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
Applying: kexec: verify the signature of signed PE bzImage
Applying: fs.h: remove unnecessary extern prototypes
Applying: fs.h: whitespace neatening
Applying: fs.h: a few more whitespace neatenings
Applying: fs.h: add argument names to struct file_lock_operations (*funcs)
Applying: fs.h: add member argument descriptions to lock_manager_operations
Applying: fs/dlm/plock.c: add argument descriptions to notify
Applying: dlm, lockd: remove unused conf from lm_grant
Applying: dlm: plock: reduce indentation by rearranging order
Applying: timer: provide an api for deferrable timeout
Applying: ksm: provide support to use deferrable timers for scanner thread
Applying: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-f=
ix
Applying: ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-f=
ix-fix-2
Applying: MAINTAINERS: update DMA BUFFER SHARING patterns
Applying: MAINTAINERS: update usb/gadget patterns
Applying: MAINTAINERS: update go7007 pattern
Applying: MAINTAINERS: update solo6x10 patterns
Applying: MAINTAINERS: update samsung pinctrl patterns
Applying: MAINTAINERS: update nomadik patterns
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
Merging akpm/master (df2802f340ae mm: add strictlimit knob)

--Sig_/5wMSVXeM_Ipcyy26eEr00nk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2iG2AAoJEMDTa8Ir7ZwVWPgP/3K8O2e6dcHY2s8N9KgXv8Hc
Llfe38fovnmrhi6zwj+waqHEBBxT+nfFyBFjV8Vb5TuCNo9sHElbdH27VXRU7YHd
ODoZh//9keB1d7FKIl7QsYjjsPfA6y9Ztl5yp2SjX56E2cU4FpYrFxCaUSi9QF42
cSwZTwcaNACx0FlVR72hDO+j9BoxAPunpkJqTzW/mzihkQRU+DmPPchkOl6r6LZ+
g5JpUt2ijEXp5Y1oWE0xdUvh/xW0achtaQkAJ8mlvC+gEii79GrITsYCLVlEAcIQ
nBbPWd1OyCdA2QJDuwP6kLQE4Kp1R7LiqeevrTPIlTFJgliMBQkCJh6Pl0MCuupE
3tBMt7WM9LTq4fJQvQQm0wY1DTAIRnPHKO/WUioV7kCbfT9lfq9hj7ihBSfVVKZT
Rah/HrSvV431HMY7/oBs2JAMrPm01xaLYd1mkG7h9UiW4nDmqgxmgpQow6kKG9Y+
7eenxKGZH69Jozfnxx78/ukSOB3/HkizC40ckZz4cGB/pA9XO/xHmetnz0YIi9TD
765++AOYAeDsmE5pNvVv2UB3MOeH6LesTosyPb0JQhOXZU3ExOfMSDinmUE3bQ4M
gaq2KuAefK/k224ZAp1KbQbvF8w8CTyRBoyPSeCobZpuEsivvULV7itzHSUnDaWm
fSNqVqexIBVuxAx8L1sT
=Dg/R
-----END PGP SIGNATURE-----

--Sig_/5wMSVXeM_Ipcyy26eEr00nk--
