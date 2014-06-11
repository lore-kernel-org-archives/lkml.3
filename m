Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaFKFPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:15:09 -0400
Received: from ozlabs.org ([103.22.144.67]:49311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaFKFPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:15:04 -0400
Date: Wed, 11 Jun 2014 15:14:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jun 11
Message-ID: <20140611151455.5dc83f61@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hCZ0A1f=3fEXjVP.sjJHXj/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hCZ0A1f=3fEXjVP.sjJHXj/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Changes since 20140610:

Dropped tree: drm-intel-fixes (build problems)

The drm-intel-fixes still had its build failure so I dropped it at the
maintainers request.

The pci tree gained a build failure so I used the version from
next-20140610.

The akpm tree lost several patches that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 3911
 3097 files changed, 122540 insertions(+), 56951 deletions(-)

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

I am currently merging 219 trees (counting Linus' and 29 trees of patches
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
Merging origin/master (2937f5efa575 Merge branch 'for_linus' of git://cavan=
.codon.org.uk/platform-drivers-x86)
Merging fixes/master (4b660a7f5c80 Linux 3.15-rc6)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (3f8517e7937d ARM: 8063/1: bL_switcher: fix indiv=
idual online status reporting of removed CPUs)
Merging m68k-current/for-linus (e8d6dc5ad26e m68k/hp300: Convert printk to =
pr_foo())
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (8212f58a9b15 powerpc: Wire renameat2() syscall)
Merging sparc/master (8ecc1bad4c9b sparc64: fix format string mismatch in a=
rch/sparc/kernel/sysfs.c)
Merging net/master (87757a917b0b net: force a list_del() in unregister_netd=
evice_many())
Merging ipsec/master (6d004d6cc739 vti: Use the tunnel mark for lookup in t=
he error handlers.)
Merging sound-current/for-linus (6538de03a98f ALSA: hda - Add quirk for ABi=
t AA8XE)
Merging pci-current/for-linus (d0b4cc4e3270 PCI: Wrong register used to che=
ck pending traffic)
Merging wireless/master (2c316e699fa4 Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (4b660a7f5c80 Linux 3.15-rc6)
Merging tty.current/tty-linus (d6d211db37e7 Linux 3.15-rc5)
Merging usb.current/usb-linus (5dc2808c4729 xhci: delete endpoints from ban=
dwidth list before freeing whole device)
Merging usb-gadget-fixes/fixes (886c7c426d46 usb: gadget: at91-udc: fix irq=
 and iomem resource retrieval)
Merging staging.current/staging-linus (9326c5ca0982 staging: r8192e_pci: fi=
x htons error)
Merging char-misc.current/char-misc-linus (d1db0eea8524 Linux 3.15-rc3)
Merging input-current/for-linus (a292241cccb7 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (3901c1124ec5 crypto: s390 - fix aes,des ctr =
mode concurrency finding.)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (4b660a7f5c80 Linux 3.15-rc6)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (15d24aa5602f drm/i915: BDW: A=
dding missing cursor offsets.)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_gtt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_execbuf=
fer.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_crtc_helper.c
$ git reset --hard HEAD^
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (ef680cdc2437 ARC: Disable caches in early boot if so =
configured)
Merging arm/for-next (bd63ce27d9d6 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (c9eaa447e77e Linux 3.15-rc1)
Merging arm-soc/for-next (c96fa31fb251 arm-soc: document keystone fix)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8a26730ea692 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (ba0ec8db3543 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (0a847a5b6ebe Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (94da9af459c1 Merge branch 'sh-drivers-for-v3.16' into=
 next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a7790-lager.dts
Merging samsung/for-next (7fa3239311b0 Merge branch 'v3.16-next/non-critica=
l-fixes' into for-next)
Merging tegra/for-next (ae3caacb703d Merge branch for-3.16/defconfig into f=
or-next)
Merging arm64/for-next/core (9358d755bd5c arm64: kernel: initialize broadca=
st hrtimer based clock event device)
Merging blackfin/for-linus (12423bf0479d Revert "blackfin: dma: current cou=
nt mmr is read only")
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (e8d6dc5ad26e m68k/hp300: Convert printk to pr_foo())
Merging m68knommu/for-next (83c6bdb827c9 m68knommu: Implement gpio support =
for m54xx.)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (225fba216261 microblaze: Fix typo in head.S s/subs=
tract/subtract/)
Merging mips/mips-for-linux-next (64b2d1fbbfda Merge tag 'for-f2fs-3.16' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (0c0a3e5a100b powerpc/powernv: Add missing include to =
LPC code)
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/topology.h
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/sections.h
Merging fsl/next (e83eb028bb98 powerpc/fsl: Add fsl,portid-mapping to coren=
et1-cf chips)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (0eb69a0c584d s390/airq: silence lockdep warning)
Merging sparc-next/master (311b8935ad4e Merge branch 'sparc_sparse_fixes')
CONFLICT (content): Merge conflict in arch/sparc/include/asm/pgtable_64.h
Merging tile/master (50b9ac1813f7 arch: tile: kernel: unaligned.c: Cleaning=
 up uninitialized variables)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (8c76c188d498 unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (c7548af69d9e Btrfs: convert smp_mb__{before,after}_clea=
r_bit)
Merging ceph/master (437f2c0d0c01 rbd: fix ida/idr memory leak)
Merging cifs/for-next (64b2d1fbbfda Merge tag 'for-f2fs-3.16' of git://git.=
kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (f8409abdc592 Merge tag 'ext4_for_linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging f2fs/dev (9ab701349247 f2fs: support f2fs_fiemap)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
Merging gfs2/master (0e48e055a7df GFS2: Prevent recovery before the local j=
ournal is set)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (a914722f333b NFS: populate ->net in mount data when=
 remounting)
Merging nfsd/nfsd-next (48385408b455 nfsd4: fix FREE_STATEID lockowner leak)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (380347e9ca76 UBIFS: Add an assertion for clean_zn=
_cnt)
Merging xfs/for-next (7691283d0561 Merge branch 'xfs-misc-fixes-3-for-3.16'=
 into for-next)
Merging file-private-locks/linux-next (7dfeba1f206f locks: set fl_owner for=
 leases back to current->files)
Merging vfs/for-next (9bd0bc947d95 kill generic_file_splice_write())
CONFLICT (content): Merge conflict in fs/splice.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/f2fs/file.c
CONFLICT (content): Merge conflict in fs/f2fs/data.c
Merging pci/next (5f9d18c282a6 Merge branches 'pci/iommu' and 'pci/cleanup'=
 into next)
$ git reset --hard HEAD^
Merging next-20140610 version of pci
Merging hid/for-next (81ba992689ce HID: usbhid: remove unneeded initializat=
ion of quirks_param[])
Merging i2c/i2c/for-next (642653d16a0f i2c: pca954x: Fix compilation withou=
t CONFIG_GPIOLIB)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (9d311eddf356 hwmon: (nct6775) Fix probe u=
nwind paths to properly unregister platform devices)
Merging v4l-dvb/master (656111f4b9cb Merge branch 'topic/omap3isp' into to_=
next)
Merging kbuild/for-next (9202d5309f34 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (7113d2940956 Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (e89a22514309 Merge branch 'pm-cpufreq')
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (63745aa72ed1 Merge branches 'armada-375-380-soc-suppo=
rt', 'eduardo-thermal-soc-fixes', 'intel-soc-dts-thermal' and 'thermal-soc-=
fixes' of .git into next)
Merging ieee1394/for-next (165d560bb267 Merge branch 'master' into for-next)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (dd59d3b36369 Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (b78370c021c9 Merge branch 'for-davem' of git://git=
.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next)
CONFLICT (content): Merge conflict in drivers/staging/rtl8821ae/core.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/mellanox/mlx4/cm=
d.c
CONFLICT (content): Merge conflict in drivers/hv/channel_mgmt.c
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging ipsec-next/master (fc68086ce888 net/xfrm/xfrm_output.c: move EXPORT=
_SYMBOL)
Merging wireless-next/master (34d2b749ea10 b43: fix typo in Kconfig (make B=
43_BUSES_BCMA_AND_SSB the default for real))
Merging bluetooth/master (986603b8949d Bluetooth: Reuse hci_stop_discovery =
function when cleaning up HCI state)
Merging infiniband/for-next (eeaddf3670d4 Merge branches 'core', 'cxgb3', '=
cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 's=
rp' and 'usnic' into for-next)
Merging mtd/master (28c015a9daab mtd: davinci-nand: disable subpage write f=
or keystone-nand)
Merging l2-mtd/master (91f5498ebfb2 mtd: gpmi: add gpmi support for imx6sx)
Merging crypto/master (5208ed2ca165 crypto: testmgr - add aead cbc des, des=
3_ede tests)
Merging drm/drm-next (b06c47a13c52 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-panel/drm/panel/for-next (a333f7ad1db5 drm/panel: simple - Add =
AUO B133XTN01 panel support)
Merging drm-intel/for-linux-next (60671f01a626 drm/i915: fix possible refco=
unt leak when resetting forcewake)
Merging drm-tegra/drm/tegra/for-next (1f64ae7c5af0 drm/tegra: sor - Remove =
obsolete comment)
Merging sound/for-next (6538de03a98f ALSA: hda - Add quirk for ABit AA8XE)
Merging sound-asoc/for-next (47ce335fa2f1 Merge remote-tracking branches 'a=
soc/fix/fsl-spdif', 'asoc/fix/pxa' and 'asoc/fix/sigmadsp' into asoc-linus)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (a17597d3b418 virtio-rng: fixes for device regis=
tration/unregistration)
Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return f=
rom mxt_get_bootloader_version)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a2d445d44000 block: add __init to blkcg_policy_regi=
ster)
Merging device-mapper/for-next (dd1eb7ce3e98 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (8c3a05b489ef mmc: mmci: Enforce DMA configuration thro=
ugh DT)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (2844dc32ea67 md/raid5: deadlock between retry_aligned_=
read with barrier io)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (89abd4df28c6 mfd: wm5102: Correct default for =
LDO Control 2 register)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (e1f0cbfb4603 Merge branches '3.16/fbdev', '3.16=
/fbdev-omap' and '3.16/omap-dss-dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am437x-gp-evm.dts
Merging regulator/for-next (8e564bfb64ec Merge remote-tracking branches 're=
gulator/fix/as3722' and 'regulator/fix/palmas' into regulator-linus)
Merging security/next (2fd4e6698f08 Merge branch 'smack-for-3.16' of git://=
git.gitorious.org/smack-next/kernel into next)
Merging integrity/next (87514cea7590 ima: introduce ima_kernel_read())
Merging selinux/next (47dd0b76ace9 selinux: conditionally reschedule in has=
htab_insert while loading selinux policy)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (6103c763759d x86: intel-mid: add watchdog platform=
 code for Merrifield)
Merging iommu/next (c0981b863a31 Merge branches 'iommu/fixes', 'arm/omap', =
'arm/smmu', 'arm/shmobile', 'x86/amd', 'arm/exynos', 'arm/renesas', 'ppc/pa=
mu' and 'arm/msm' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt c=
ount)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (31789538e3ba staging: go7007: remove reference to=
 CONFIG_KMOD)
Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_sysca=
ll_entry() interface)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (3c19ca6ae6a4 of: handle NULL node in ne=
xt_child iterators)
Merging dt-rh/for-next (728dd198aa54 Merge branch 'earlycon-dt' into for-ne=
xt)
Merging spi/for-next (d63944c8b9b2 Merge remote-tracking branch 'spi/fix/px=
a2xx' into spi-linus)
Merging tip/auto-latest (2154afaef9ed Merge branch 'locking/core')
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (aa2064d7dd35 EDAC: Fix MC scrub mode comparsion =
bug for correctable errors)
Merging irqchip/irqchip/for-next (3203bea71513 Documentation: add Broadcom =
STB Level-2 interrupt controller binding)
Merging ftrace/for-next (a9fcaaac37b3 tracing: Fix memory leak on instance =
deletion)
Merging rcu/rcu/next (61f38db3e3c0 rcu: Provide API to suppress stall warni=
ngs while sysrc runs)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (820b3fcdeb80 KVM: add missing cleanup_srcu_struct)
Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support =
for Cortex-A53)
Merging kvm-ppc/kvm-ppc-next (820b3fcdeb80 KVM: add missing cleanup_srcu_st=
ruct)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (77945ca73e9a x86/xen: map foreign pfns for auto=
translated guests)
Merging percpu/for-next (315c5554c406 Merge branch 'for-3.15-fixes' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git into for-3.16)
Merging workqueues/for-next (015af06e103f kernel/workqueue.c: pr_warning/pr=
_warn & printk/pr_info)
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (cd6c5693c9c7 Merge tag 'regmap-v3.16' into regmap-=
linus)
Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module re=
fcounting)
Merging leds/for-next (0c9a03b68511 leds: Remove duplicated OOM message for=
 individual driver)
Merging driver-core/driver-core-next (cda43576afa6 crypto/nx/nx-842: dev_se=
t_drvdata can no longer fail)
Merging tty/tty-next (9ce4f8f3f454 Revert "serial: imx: remove the DMA wait=
 queue")
Merging usb/usb-next (4a95b1fce977 usb: hub_handle_remote_wakeup() only exi=
sts for CONFIG_PM=3Dy)
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
Merging staging/staging-next (7eb843aa5050 staging: skein: fix sparse warni=
ng for static declarations)
Merging char-misc/char-misc-next (a100d88df1e9 hv: use correct order when f=
reeing monitor_pages)
Merging cgroup/for-next (c731ae1d0f02 cgroup: disallow disabled controllers=
 on the default hierarchy)
Merging scsi/for-next (11a5dc7ff2fb Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.16-2' into for-next)
Merging scsi-core/core-for-3.16 (63ff05910d96 include/scsi/osd_protocol.h: =
remove unnecessary __constant)
Merging scsi-drivers/drivers-for-3.16 (e90b25fa40a4 mvsas: Recognise device=
/subsystem 9485/9485 as 88SE9485)
Merging target-updates/for-next (8deae32d2ea1 Target/iscsi: Fix sendtargets=
 response pdu for iser transport)
CONFLICT (content): Merge conflict in drivers/scsi/virtio_scsi.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (ff4e41904b42 pinctrl: sunxi: Fix potential null p=
ointer dereference)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
Applying: vhost/scsi: fixup for acked_features move
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (963649d735c8 Merge tag 'for-linus-3.16-merge-window'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs)
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (39fd3f99aba3 pwm: fsl-ftm: set pwm_chip can_sleep fla=
g)
CONFLICT (content): Merge conflict in drivers/leds/leds-pwm.c
Merging dma-buf/for-next (68f965a6028f DRM: Armada: update dma_buf_export u=
se)
CONFLICT (content): Merge conflict in drivers/staging/android/sync.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_dmabuf.c
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
Merging clk/clk-next (3cbcb16095f9 mmc: sunxi: Add driver for SD/MMC hosts =
found on Allwinner sunxi SoCs)
Merging random/dev (f9c6d4987b23 random: fix BUG_ON caused by accounting si=
mplification)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (fa88b6f8803c aio: cleanup: flatten kill_ioctx())
Merging llvmlinux/for-next (4062a9436654 arm, unwind, LLVMLinux: Enable cla=
ng to be used for unwinding the stack)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (8b1cbef71a7e These days most people use git to send=
 patches so I have added a section about that.)
Merging akpm-current/current (5e19bfb5fbc1 mm-compaction-properly-signal-an=
d-act-upon-lock-and-need_sched-contention-fix-2)
CONFLICT (content): Merge conflict in mm/vmscan.c
CONFLICT (content): Merge conflict in mm/page_alloc.c
CONFLICT (content): Merge conflict in mm/mempolicy.c
CONFLICT (content): Merge conflict in mm/memory-failure.c
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in mm/memblock.c
CONFLICT (content): Merge conflict in kernel/sysctl.c
CONFLICT (content): Merge conflict in kernel/smp.c
CONFLICT (content): Merge conflict in kernel/printk/printk.c
CONFLICT (content): Merge conflict in kernel/kexec.c
CONFLICT (content): Merge conflict in ipc/sem.c
CONFLICT (content): Merge conflict in fs/proc/task_mmu.c
CONFLICT (content): Merge conflict in fs/jfs/super.c
CONFLICT (content): Merge conflict in fs/hugetlbfs/inode.c
CONFLICT (content): Merge conflict in fs/hpfs/super.c
CONFLICT (content): Merge conflict in fs/hpfs/name.c
CONFLICT (content): Merge conflict in fs/hpfs/map.c
CONFLICT (content): Merge conflict in fs/hpfs/inode.c
CONFLICT (content): Merge conflict in fs/hpfs/ea.c
CONFLICT (content): Merge conflict in fs/hpfs/dnode.c
CONFLICT (content): Merge conflict in fs/hpfs/dir.c
CONFLICT (content): Merge conflict in fs/hpfs/buffer.c
CONFLICT (content): Merge conflict in fs/hfsplus/hfsplus_fs.h
CONFLICT (content): Merge conflict in fs/hfsplus/dir.c
CONFLICT (content): Merge conflict in fs/ext4/page-io.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-at91rm9200.c
CONFLICT (content): Merge conflict in arch/x86/mm/init_64.c
CONFLICT (content): Merge conflict in arch/arm/include/asm/Kbuild
CONFLICT (content): Merge conflict in Documentation/cgroups/memory.txt
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: mm/page_io.c: work around gcc bug
Applying: kernel/watchdog.c: print traces for all cpus on lockup detection
Applying: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
Applying: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fi=
x-2
Applying: kernel/watchdog.c: convert printk/pr_warning to pr_foo()
Applying: init/main.c: code clean-up
Applying: kernel/kprobes.c: convert printk to pr_foo()
Applying: memcg, mm: introduce lowlimit reclaim
Applying: memcg-mm-introduce-lowlimit-reclaim-fix
Applying: memcg: allow setting low_limit
Applying: memcg, doc: clarify global vs. limit reclaims
Applying: memcg-doc-clarify-global-vs-limit-reclaims-fix
Applying: memcg: document memory.low_limit_in_bytes
Applying: vmscan: memcg: check whether the low limit should be ignored
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: mm-replace-remap_file_pages-syscall-with-emulation-fix
Applying: mm: remap_file_pages: initialize populate before usage
Applying: mm: remap_file_pages: grab file ref to prevent race while mmaping
Applying: memcg: deprecate memory.force_empty knob
Applying: memcg-deprecate-memoryforce_empty-knob-fix
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: zero out seek range on _fat_get_block
Applying: fat: fallback to buffered write in case of fallocated region on d=
irect IO
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: nmi: provide the option to issue an NMI back trace to every cpu b=
ut current
Applying: nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every-cpu-bu=
t-current-fix
Applying: bio: modify __bio_add_page() to accept pages that don't start a n=
ew segment
Applying: bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-s=
egment-v3
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (2bac75cc2228 mm: add strictlimit knob)

--Sig_/hCZ0A1f=3fEXjVP.sjJHXj/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTl+XUAAoJEMDTa8Ir7ZwVi24P/jS4TvSavttKlqF2yP2xWc4U
92ioN+Cj9LWXDNAWchfe6XnQUbaEDIQZJlW+ClXMGlaL61ujVgxfb2dbnBdQGRIQ
tQmHR1VZkh/nmx1gf6YQbkTRuk0Nq/rurtbiXO+aUXU1I70nGxMECSBrCLtJcAIO
Hf8mkgt4ziyIW/wZ26IUr6uvsAl9OgIoJSNHsXghs8RTWy1yiti1EDdLuYTjUB3V
8WU7DfHbUEHwJdy+Nxy5Y3Wa4QF0HlG8mTaMlxY58DxUkG24q0KnFfUPy2THnFa2
GciBL9+C/mQj3hBeXf9yjBX3AuqYbVTwF4rmMCkgXGqXc/4IkG+Xp1c+E1aziyx5
E5TsHVwA9/xis5ulEJz8R+BoZlDJa7/ASnz5AZ6wDMbebgQfCaFI5U0qO97jalpx
Ze6tMp+VHYb9j1ww3EzD2GN1dhkjFBTDLhgq4uybKvT7XaqyVt7S0NuUilELUNaS
rDOqggtyS/HLmC3O89fDWhlyKfMky2trwT1v4R6D6W515WyKYijJ4qI1PGHXtnEh
2UroANA9+MG7ogHX8aNlYv6SHbRSFUpT+EJ19E9urX7304Qv/cuI8liATgPIWgAp
OjNfB1FlBypK4p06oNoHsgdiItJSVTeouZLKlte56WPgv2DHiIgrD7PF7gWAT9Mi
3rruJC7TekVUS08DV9jV
=T+UD
-----END PGP SIGNATURE-----

--Sig_/hCZ0A1f=3fEXjVP.sjJHXj/--
