Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaHDLYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:24:42 -0400
Received: from ozlabs.org ([103.22.144.67]:37818 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaHDLYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:24:38 -0400
Date: Mon, 4 Aug 2014 21:24:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Aug 4
Message-ID: <20140804212428.7773ee50@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QJmJiDAjO8n/XTtZLkEbQtV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QJmJiDAjO8n/XTtZLkEbQtV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Pease do not add code intended for v3.18 until after v3.17-rc1 is
released.

Changes since 20140801:

The net-next tree gained a conflict against the net tree.

The infiniband tree gained a conflict against the net-next tree.

The drm-tegra tree gained a build failure, so I used the version from
next-20140801.

The modules tree still had its build failure so I used the version from
next-20140725.

The mmc-uh tree still had its build failure so I used the version from
next-20140725.

The security tree gained a conflict against the net-next tree.

The tip tree gained conflicts against the pm and nfs trees.

The kvm-ppc tree gained a conflict against the kvm tree and a build
failure for which I reverted a commit.

The gpio tree lost its build failure after I applied a supplied patch.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 10267
 8849 files changed, 382415 insertions(+), 441105 deletions(-)

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
Merging origin/master (19583ca584d6 Linux 3.16)
Merging fixes/master (1795cd9b3a91 Linux 3.16-rc5)
Merging kbuild-current/rc-fixes (dd5a6752ae7d firmware: Create directories =
for external firmware)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (6bf755db4d5e ARM: 8124/1: don't enter kgdb when =
userspace executes a kgdb break instruction)
Merging m68k-current/for-linus (5bc8c7cdeb6e m68k: Export mach_random_get_e=
ntropy to modules)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (08a9c3c9afcf MIPS: OCTEON: make get_system_t=
ype() thread-safe)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging sparc/master (31dab719fa50 Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/herbert/crypto-2.6)
Merging net/master (4f933f414bf6 r8152: add missing Makefile rule)
Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
Merging sound-current/for-linus (7440850c20b6 ALSA: hda - fix an external m=
ic jack problem on a HP machine)
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
Merging crypto-current/master (4c63f83c2c2e crypto: af_alg - properly label=
 AF_ALG socket)
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
Merging arm/for-next (3d3e6a9e1ae7 Merge branch 'devel-stable' into for-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
Merging arm-perf/for-next/perf (4c834452aad0 Linux 3.16-rc3)
Merging arm-soc/for-next (f8aee52350a8 Merge branch 'next/defconfig' into f=
or-next)
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
Merging renesas/next (b869bc06bc67 Merge branch 'heads/shdma-for-v3.17' int=
o next)
Merging samsung/for-next (d5e49aabb545 Merge branch 'v3.17-next/dt-samsung-=
2' into for-next)
Merging sunxi/sunxi/for-next (44b61dc11c6d Merge branch 'sunxi/dt-for-3.17'=
 into sunxi/for-next)
Merging tegra/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging arm64/for-next/core (ea1719672f59 arm64: add newline to I-cache pol=
icy string)
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
Merging fsl/next (78eb9094ca08 powerpc/t2080rdb: Add T2080RDB board support)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (152125b7a882 s390/mm: implement dirty bits for large=
 segment table entries)
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
Merging cifs/for-next (59b04c5df75b [CIFS] Fix incorrect hex vs. decimal in=
 some debug print statements)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (3f1be4f9c9dc udf: avoid redundant memcpy when writin=
g data in ICB)
Merging ext4/dev (e7c22a2e7d23 ext4: fix ext4_discard_allocated_blocks() if=
 we can't allocate the pa struct)
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
Merging nfs/linux-next (f682a398b2e2 NFS: allow lockless access to access_c=
ache)
Merging nfsd/nfsd-next (03adc840085e nfsd: add some comments to the nfsd4 o=
bject definitions)
CONFLICT (content): Merge conflict in fs/nfsd/nfs4xdr.c
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (25601a3c9737 UBIFS: Add log overlap assertions)
Merging xfs/for-next (c3dd0d14e34a Merge branch 'xfs-misc-fixes-3.17-1' int=
o for-next)
Merging file-private-locks/linux-next (73a8f5f7e635 locks: purge fl_owner_t=
 from fs/locks.c)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging hch-vfs/vfs-for-3.17 (4f3620546893 fs: mark __d_obtain_alias static)
Merging pci/next (981c191778a4 Merge branches 'pci/host-designware', 'pci/h=
ost-mvebu' and 'pci/host-tegra' into next)
Merging hid/for-next (914b9e7fdb8d Merge branch 'for-3.17/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (ca44efb00e11 Merge branch 'i2c/for-3.17' into i2c=
/for-next)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (f69b017bef03 hwmon: (pwm-fan) Make SENSOR=
S_PWM_FAN depend on OF)
Merging v4l-dvb/master (50b8879ed699 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (9586848e26c7 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (1824be15f7a4 Merge branch 'for-3.17' into for-next)
Merging pm/linux-next (193455830d31 Merge branch 'acpi-pnp' into linux-next)
CONFLICT (content): Merge conflict in drivers/cpuidle/Kconfig.arm
Merging idle/next (24153da3e88d intel_idle: Disable BYT Core and Module C6 =
auto-demotion)
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
Merging slave-dma/next (ed64610f2941 dmaengine: edma: Do not register secon=
d device when booted with DT)
CONFLICT (content): Merge conflict in drivers/dma/sh/Kconfig
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (e6b92c25d20c cxgb4i : remove spurious use of rcu)
CONFLICT (content): Merge conflict in net/ipv6/sysctl_net_ipv6.c
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (dc6be9f54a4e bcma: use NS prefix for names of=
 Northstar specific cores)
CONFLICT (content): Merge conflict in net/6lowpan/iphc.c
Merging bluetooth/master (dc6be9f54a4e bcma: use NS prefix for names of Nor=
thstar specific cores)
Merging infiniband/for-next (e2a7ee8f2f25 Merge branches 'core', 'cxgb4', '=
iser', 'ocrdma' and 'srp' into for-next)
CONFLICT (content): Merge conflict in include/linux/mlx4/device.h
Merging mtd/master (b6603fe574af Merge tag 'for-linus-20140716' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (2a500afe1e0e mtd: gpmi: make blockmark swapping opti=
onal)
Merging crypto/master (ce5481d01f67 crypto: drbg - fix failure of generatin=
g multiple of 2**16 bytes)
Merging drm/drm-next (08d645c181e9 agp: remove read/write stubs)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_render_=
state.c
Merging drm-panel/drm/panel/for-next (1ef86eb3985b drm/exynos: dp: Modify d=
river to support drm_panel)
Merging drm-intel/for-linux-next (17c58fe801f5 drm/i915: Align intel_dsi*.c=
 files a bit)
Merging drm-tegra/drm/tegra/for-next (1b61cde4890b drm/tegra: add MODULE_DE=
VICE_TABLEs)
$ git reset --hard HEAD^
Merging next-20140801 version of drm-tegra
Merging sound/for-next (00ef99408b6c ALSA: hda - add mic mute led hook for =
dell machines)
Merging sound-asoc/for-next (344d5eb2cbd4 Merge remote-tracking branches 'a=
soc/topic/wm0010', 'asoc/topic/wm8904', 'asoc/topic/wm8962' and 'asoc/topic=
/wm8985' into asoc-next)
Merging modules/modules-next (2e3a10a1551d ARM: avoid ARM binutils leaking =
ELF local symbols)
$ git reset --hard HEAD^
Merging next-20140725 version of modules
Merging virtio/virtio-next (eeec626366ff Revert "hwrng: virtio - ensure rea=
ds happen after successful probe")
Merging input/next (e179d5fa8d6d Input: imx_keypad - remove ifdef round PM =
methods)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a84352f82862 Merge branch 'for-3.17/core' into for-=
next)
Merging device-mapper/for-next (18debb0e53f5 dm crypt: sort writes)
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
Merging md/for-next (af5628f05db6 md: disable probing for md devices 512 an=
d over.)
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
Merging regulator/for-next (e38dc0902f68 Merge remote-tracking branches 're=
gulator/topic/tps65217', 'regulator/topic/tps65218', 'regulator/topic/tps65=
86x' and 'regulator/topic/twl' into regulator-next)
Merging security/next (103ae675b12d Merge branch 'next' of git://git.infrad=
ead.org/users/pcmoore/selinux into next)
CONFLICT (content): Merge conflict in kernel/seccomp.c
Merging integrity/next (e27319cdf468 ima: provide double buffering for hash=
 calculation)
CONFLICT (content): Merge conflict in include/linux/key.h
Merging selinux/next (4fbe63d1c773 netlabel: shorter names for the NetLabel=
 catmap funcs/structs)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8083baba5e9c wdt: sunxi: Move restart code to the =
watchdog driver)
Merging iommu/next (4c5e9d9f0ddf Merge branches 'x86/vt-d', 'x86/amd', 'arm=
/omap', 'ppc/pamu', 'arm/smmu', 'arm/exynos' and 'core' into next)
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
Merging devicetree/devicetree/next (6a31c02b3311 Merge branch 'devicetree/n=
ext-overlay' into devicetree/next)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (4a0921d86446 Merge remote-tracking branches 'spi/topi=
c/sh', 'spi/topic/sh-msiof' and 'spi/topic/topcliff-pch' into spi-next)
Merging tip/auto-latest (30e8e851f9c5 Merge branch 'x86/xsave')
CONFLICT (content): Merge conflict in fs/nfs/pagelist.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/hw.c
CONFLICT (content): Merge conflict in drivers/acpi/acpi_extlog.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
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
Merging kvm/linux-next (42cbc04fd3b5 x86/kvm: Resolve shadow warnings in ma=
cro expansion)
CONFLICT (content): Merge conflict in arch/x86/kvm/mmutrace.h
Merging kvm-arm/next (dedf97e8ff2c arm64: KVM: fix 64bit CP15 VM access for=
 32bit guests)
CONFLICT (content): Merge conflict in virt/kvm/arm/vgic.c
Applying: merge fixup provided by Marc Zyngier <marc.zyngier@arm.com>
Merging kvm-ppc/kvm-ppc-next (8e6afa36e754 KVM: PPC: PR: Handle FSCR featur=
e deselects)
CONFLICT (content): Merge conflict in Documentation/virtual/kvm/api.txt
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (e38230eb3789 xen/pciback: Remove tons of derefe=
rences)
CONFLICT (content): Merge conflict in include/xen/grant_table.h
CONFLICT (content): Merge conflict in drivers/xen/grant-table.c
CONFLICT (content): Merge conflict in arch/x86/xen/grant-table.c
Merging percpu/for-next (1e59e00cdf4d Merge branch 'for-3.17' into for-next)
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
Merging driver-core/driver-core-next (4e3a25b0274b ARM: imx: Remove referen=
ces to platform_bus in mxc code)
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in drivers/gpu/drm/armada/armada_crtc.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r7s72100=
.c
Merging tty/tty-next (5a64096700dc tty/n_gsm.c: fix a memory leak in gsmld_=
open)
Merging usb/usb-next (d310d05f1225 USB: devio: fix issue with log flooding)
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
Merging staging/staging-next (b9aaea39f65e staging: comedi: addi_apci_1564:=
 remove diagnostic interrupt support code)
CONFLICT (modify/delete): drivers/staging/media/sn9c102/Kconfig deleted in =
HEAD and modified in staging/staging-next. Version staging/staging-next of =
drivers/staging/media/sn9c102/Kconfig left in tree.
CONFLICT (modify/delete): drivers/staging/dgrp/dgrp_tty.c deleted in stagin=
g/staging-next and modified in HEAD. Version HEAD of drivers/staging/dgrp/d=
grp_tty.c left in tree.
CONFLICT (modify/delete): drivers/staging/cxt1e1/linux.c deleted in staging=
/staging-next and modified in HEAD. Version HEAD of drivers/staging/cxt1e1/=
linux.c left in tree.
CONFLICT (content): Merge conflict in MAINTAINERS
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
Merging target-updates/for-next (45f6c5b576b9 target/configfs: Remove unnec=
essary null test)
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
Applying: gpio: add missing includes in machine.h
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (eae266a284f3 pwm: rockchip: document device tree bind=
ings)
Merging dma-buf/for-next (b23b35445ec8 Documentation: devres: Add devm_kmal=
loc() et al)
Merging userns/for-next (2d913c3d8271 proc: Point /proc/mounts at /proc/thr=
ead-self/mounts instead of /proc/self/mounts)
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (d7d3d26fa544 Merge tag 'for_3.17/samsung-clk' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tfiga/samsung-clk into clk-next-s=
amsung)
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
Merging llvmlinux/for-next (7380100aa7ce arm64: LLVMLinux: Use current_stac=
k_pointer in kernel/traps.c)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (da8a7613e7ef Maintainers often repeat the same feed=
back on poorly written changelogs - describe the problem, justify your chan=
ges, quantify optimizations, describe user-visible changes - but our docume=
ntation on writing changelogs doesn't include these things.  Fix that.)
CONFLICT (content): Merge conflict in Documentation/laptops/freefall.c
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
[master 27d6e5ca9c32] Revert "KVM: PPC: HV: Remove generic instruction emul=
ation"
Merging akpm-current/current (929c76e4e629 fs/dlm/debug_fs.c: remove unnece=
ssary null test before debugfs_remove)
CONFLICT (content): Merge conflict in kernel/kexec.c
CONFLICT (content): Merge conflict in drivers/rapidio/devices/tsi721_dma.c
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
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
Merging akpm/master (0a0724d0f5d2 mm: add strictlimit knob)

--Sig_/QJmJiDAjO8n/XTtZLkEbQtV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT321xAAoJEMDTa8Ir7ZwVTsgP/0uNFwCcsecpX3XhdgCoqMrM
Mfs1xlu42cLt4MdOpSH78y9X6/J4N7BO409hFQrF2Rnyjys+qgqdesGvDzCLtK85
H0BGXs+s/m+BNEdKvcT2R1rUBRCkyOQMVwBSODSw5vaBaC54JzHXb2PvDTfowOSO
WMh80pOI7Cf7CqtUWeWMFPm6jCBiiWDa2Z3CiQvdQj1E8DcXZ9O+D2+Z2giC5CX8
fvmSyeFijJD9mVSvCyAftLqHRU9EBm+qb1HlNTiAIlHOR2Qn9nI+S0cM4PGGe98U
p9u7PEM4NyJxPHnwwVVyFHfpD9TBO2qqbjML5u8EInMwE3jXoFcIjqtjDmlmhrJs
T63kOI0VFOAxzEC6AFVTwiwPHF3i6wP0DQczKsTg/E88qBqZFhfOlHjz/LL2Rqcf
bPkabJVDL9i/LpxN5sUqXC3DBw40uwzlI6HGuSOCJ7MuDe1yJ64ARbaoPhq45dfM
Wsj/duEatnRQeTxfKFPO5GDsTHMyG7uaYYle+QzpW36Cmm3KpR3L4woWIxodnQgi
8n2EBVYKll+r42Bf+GGd8P9aGnYCdOzx57oetKO/rivRf9+GOSUP1bU6PXYznqvg
JfA+wX0TRyLYfMRPzmMcmJ22Ql6SbE4i82IPXp2jbOOcUFTSesPPr/D5GnyebQFd
+83En8ZD6cCMaGumFf+r
=YmnJ
-----END PGP SIGNATURE-----

--Sig_/QJmJiDAjO8n/XTtZLkEbQtV--
