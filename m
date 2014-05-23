Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaEWKmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:42:54 -0400
Received: from ozlabs.org ([103.22.144.67]:38965 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbaEWKmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:42:43 -0400
Date: Fri, 23 May 2014 20:42:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 23
Message-ID: <20140523204234.6f018794@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/QbwkEj=KFhzMrVm1/AuEOaM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QbwkEj=KFhzMrVm1/AuEOaM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Changes since 20140522:

My fixes tree is empty again.

The arm-soc tree gained conflicts against the arm tree.

The samsung tree gained a conflict against the arm tree.

The pci tree lost its build failure.

The l2-mtd tree still had its build failure so I used the version from
next-20140521.

The net-next tree gained conflicts against the wireless and net trees.

The mmc tree gained a conflict against the slave-dma tree and a build
failure so I used the version from next-20140522.

The mfd-lj tree still had its build failure for which I reverted a commit.

The tip tree gained conflicts against the arm64 tree and a build
failure due to an interaction with the arm tree for which I applied a
merge fix patch.

The target-updates tree gained a conflict against the scsi tree and a
build failure so I used the version from next-20140522.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 7717
 6625 files changed, 277120 insertions(+), 156869 deletions(-)

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

I am currently merging 220 trees (counting Linus' and 29 trees of patches
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
Merging origin/master (4b660a7f5c80 Linux 3.15-rc6)
Merging fixes/master (0be9d8b61c0c powerpc/ppc64: Allow allmodconfig to bui=
ld (finally !))
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (a798c10faf62 Linux 3.15-rc2)
Merging arm-current/fixes (d93003e8e4e1 ARM: 8042/1: iwmmxt: allow to build=
 iWMMXt on Marvell PJ4B)
Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3=
.14-rc1)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (8050936caf12 powerpc: irq work racing with tim=
er interrupt can result in timer interrupt hang)
Merging sparc/master (8ecc1bad4c9b sparc64: fix format string mismatch in a=
rch/sparc/kernel/sysfs.c)
Merging net/master (b6ed5498601d batman: fix a bogus warning from batadv_is=
_on_batman_iface())
Merging ipsec/master (6d004d6cc739 vti: Use the tunnel mark for lookup in t=
he error handlers.)
Merging sound-current/for-linus (02fb05a598e9 ALSA: pcm_dmaengine: Add chec=
k during device suspend)
Merging pci-current/for-linus (d0b4cc4e3270 PCI: Wrong register used to che=
ck pending traffic)
Merging wireless/master (2c316e699fa4 Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (f5c16f29bf5e sysfs: make sur=
e read buffer is zeroed)
Merging tty.current/tty-linus (d6d211db37e7 Linux 3.15-rc5)
Merging usb.current/usb-linus (d6d211db37e7 Linux 3.15-rc5)
Merging usb-gadget-fixes/fixes (886c7c426d46 usb: gadget: at91-udc: fix irq=
 and iomem resource retrieval)
Merging staging.current/staging-linus (4b660a7f5c80 Linux 3.15-rc6)
Merging char-misc.current/char-misc-linus (d1db0eea8524 Linux 3.15-rc3)
Merging input-current/for-linus (0b5fe736fe92 Input: synaptics - add min/ma=
x quirk for the ThinkPad W540)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (3901c1124ec5 crypto: s390 - fix aes,des ctr =
mode concurrency finding.)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (e7a23fea64f1 mips: dts: Fix mi=
ssing device_type=3D"memory" property in memory nodes)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (4eda4e461109 drm/i915: Preven=
t negative relocation deltas from wrapping)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (35b960a30019 ARC: remove duplicate header exports)
Merging arm/for-next (950fe4a0d521 Merge branches 'alignment', 'l2c' (early=
 part) and 'misc' into for-next)
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (d18135c126e8 ARM: perf: add support for the=
 Cortex-A17 PMU)
Merging arm-soc/for-next (be4be96db5a1 Merge branch 'next/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/board-v7.c
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8a26730ea692 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (49a96400a142 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17191583568 Merge branch 'for_3.16/dts' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (09184e7356b1 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (d1b3562bcdfe Merge branch 'heads/r7s72100-ccf-for-v3.=
16' into next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging samsung/for-next (19307a0b41ef Merge branch 'v3.16-next/dt-samsung-=
2' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/firmware.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/exynos.c
Merging tegra/for-next (ae3caacb703d Merge branch for-3.16/defconfig into f=
or-next)
Merging arm64/for-next/core (74d2eb3cdb7b arm64: defconfig: enable a few mo=
re common/useful options in defconfig)
Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
Merging m68knommu/for-next (59906f644cdc m68knommu: Implement gpio support =
for m54xx.)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (14186fea0cb0 Merge tag 'locks-v3.15-4' of git://gi=
t.samba.org/jlayton/linux)
Merging mips/mips-for-linux-next (9637d17b052a Merge branch '3.15-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (872aa779bcdd powerpc/module: Fix stubs for BE)
[master c3bb71c351e8] Revert "powerpc/ppc64: Allow allmodconfig to build (f=
inally !)"
Merging fsl/next (e83eb028bb98 powerpc/fsl: Add fsl,portid-mapping to coren=
et1-cf chips)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (9fea3e79241e s390/oprofile: make return of 0 explici=
t)
Merging sparc-next/master (311b8935ad4e Merge branch 'sparc_sparse_fixes')
CONFLICT (content): Merge conflict in arch/sparc/include/asm/pgtable_64.h
Merging tile/master (e540e835f89c tile: cleanup the comment in init_pgprot)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (8b3864d2364b drivers: scsi: mvsas: fix compili=
ng issue by adding 'MVS_' for "enum pci_interrupt_cause")
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache r=
eaddir)
Merging cifs/for-next (0042cf22e164 [CIFS] Clarify SMB2/SMB3 create context=
 and add missing ones)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (0a9efd1f76c0 ext4: use EXT_MAX_BLOCKS in ext4_es_can_be_m=
erged())
Merging f2fs/dev (70ff5dfeb691 f2fs: use inode_init_owner() to simplify cod=
es)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
Merging gfs2/master (9dd868e1c009 GFS2: fs/gfs2/file.c: kernel-doc warning =
fixes)
Merging jfs/jfs-next (24e4a0f3de21 fs/jfs/jfs_inode.c: atomically set inode=
->i_flags)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (1f2edbe3fe21 NFS: Don't ignore suid/sgid bit change=
s after a successful write)
Merging nfsd/nfsd-next (baa597b70a45 nfsd4: fill in some missing op_name's)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging ubifs/linux-next (604b592e6fd3 UBI: fix rb_tree node comparison in =
add_map)
Merging xfs/for-next (b70f14e1ffbb Merge branch 'xfs-feature-bit-cleanup' i=
nto for-next)
Merging file-private-locks/linux-next (9f234be73db8 locks: add some tracepo=
ints in the lease handling code)
Merging vfs/for-next (9bd0bc947d95 kill generic_file_splice_write())
CONFLICT (content): Merge conflict in fs/f2fs/file.c
CONFLICT (content): Merge conflict in fs/cifs/cifsfs.c
Merging pci/next (90f97be5e1df Merge branches 'dma-api', 'pci/virtualizatio=
n', 'pci/msi', 'pci/misc' and 'pci/resource' into next)
CONFLICT (content): Merge conflict in arch/s390/pci/pci_sysfs.c
Merging hid/for-next (b6ce4a54ad18 Merge branch 'for-3.16/rmi4' into for-ne=
xt)
Merging i2c/i2c/for-next (d275545e0e22 ARM: sunxi: dt: Convert to the new i=
2c compatibles)
Merging jdelvare-hwmon/master (68ffcb02dad0 hwmon: (ntc_thermistor) Fix OF =
device ID mapping)
Merging hwmon-staging/hwmon-next (e8cba3cda44e hwmon: (ultra45_env) Introdu=
ce managed version of kzalloc)
Merging v4l-dvb/master (89e2d4278eb8 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (5366c855e0d8 Merge branches 'kbuild/misc' and 'kbu=
ild/kbuild' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (5b32c21d52cc Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (bb2cb906b117 Merge branch 'acpi-processor-next' into=
 linux-next)
CONFLICT (content): Merge conflict in drivers/cpufreq/exynos-cpufreq.h
CONFLICT (content): Merge conflict in drivers/cpufreq/exynos-cpufreq.c
CONFLICT (content): Merge conflict in arch/mips/loongson/lemote-2f/clock.c
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (63745aa72ed1 Merge branches 'armada-375-380-soc-suppo=
rt', 'eduardo-thermal-soc-fixes', 'intel-soc-dts-thermal' and 'thermal-soc-=
fixes' of .git into next)
Merging ieee1394/for-next (b3d681a4fc10 firewire: Use COMPILE_TEST for buil=
d testing)
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (9fe2419a0ab5 Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (091b64868b43 Merge branch 'mlx4-next')
CONFLICT (content): Merge conflict in net/ipv6/xfrm6_output.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/mac8=
0211.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/altera/altera_sg=
dma.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/altera/altera_ms=
gdma.c
CONFLICT (content): Merge conflict in drivers/net/bonding/bond_alb.c
Merging ipsec-next/master (fc68086ce888 net/xfrm/xfrm_output.c: move EXPORT=
_SYMBOL)
Merging wireless-next/master (ef1b075c15d5 mwifiex: use 'const' qualifier f=
or 2nd arg of mwifiex_tdls_add_ht_oper)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/mac8=
0211.c
Merging bluetooth/master (1cc6114402f8 Bluetooth: Update smp_confirm to ret=
urn a response code)
CONFLICT (content): Merge conflict in drivers/bluetooth/btusb.c
Merging infiniband/for-next (e9ca67cbc81b Merge branches 'cxgb4', 'mlx5', '=
ocrdma' and 'srp' into for-next)
Merging mtd/master (28c015a9daab mtd: davinci-nand: disable subpage write f=
or keystone-nand)
Merging l2-mtd/master (fe4fd75b827a mtd: nand: pxa3xx: Add supported ECC st=
rength and step size to the DT binding)
$ git reset --hard HEAD^
Merging next-20140521 version of l2-mtd
Merging crypto/master (5208ed2ca165 crypto: testmgr - add aead cbc des, des=
3_ede tests)
CONFLICT (content): Merge conflict in drivers/crypto/caam/error.c
CONFLICT (rename/delete): drivers/crypto/bfin_crc.h deleted in HEAD and ren=
amed in crypto/master. Version crypto/master of drivers/crypto/bfin_crc.h l=
eft in tree.
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in crypto/crypto_user.c
Merging drm/drm-next (263432b021cd Merge branch 'ast-updates' of ssh://peop=
le.freedesktop.org/~/linux into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_gtt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_execbuf=
fer.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Merging drm-panel/drm/panel/for-next (02dfc65dc905 drm/panel: add support f=
or EDT ET057090DHU panel)
Merging drm-intel/for-linux-next (f83d6518a130 drm/i915: Kill private_defau=
lt_ctx off)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.h
Merging drm-tegra/drm/tegra/for-next (f00e104dc165 drm/tegra: gem - Make te=
gra_bo_import() static)
Merging sound/for-next (0c1d1210160f Merge tag 'asoc-v3.16' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/broonie/sound into for-next)
Merging sound-asoc/for-next (cee429e5c53f Merge remote-tracking branches 'a=
soc/topic/ux500', 'asoc/topic/wm8731', 'asoc/topic/wm8804', 'asoc/topic/wm8=
955' and 'asoc/topic/wm8985' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (a17597d3b418 virtio-rng: fixes for device regis=
tration/unregistration)
Merging input/next (899fce0e73d5 Input: atmel_mxt_ts - handle multiple inpu=
t reports in one message)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (6b259469b4c5 Merge branch 'for-3.16/core' into for-=
next)
Merging device-mapper/for-next (fc3b7a70ac7c dm thin: cleanup noflush_work =
to use a proper completion)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (708dce3f0a90 MAINTAINERS: mmc: Add path to git tree)
CONFLICT (content): Merge conflict in include/linux/omap-dma.h
Applying: dmaengine: omap: fix for code movement
$ git reset --hard HEAD^
Merging next-20140522 version of mmc
Merging mmc-uh/next (5080a08d0f8a mmc: mmci: Enforce max frequency configur=
ation through DT)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (34bf6ef94a83 mm: slab/slub: use page->list consisten=
tly instead of page->lru)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (41040c9701c2 raid5: add an option to avoid copy data f=
rom bio to stripe cache)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (463eb5999297 mfd: arizona: Correct addresses o=
f always-on trigger registers)
CONFLICT (add/add): Merge conflict in drivers/mmc/host/rtsx_usb_sdmmc.c
$ git am -3 ../patches/0001-Revert-mfd-stmpe-root-out-static-GPIO-and-IRQ-a=
ssign.patch
Applying: Revert "mfd: stmpe: root out static GPIO and IRQ assignments"
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (97da2a3f2649 Merge branches '3.16/fbdev' and '3=
.16/fbdev-omap' into for-next)
Merging regulator/for-next (7c603c1c9e33 Merge remote-tracking branches 're=
gulator/topic/s5m8767', 'regulator/topic/tps65090' and 'regulator/topic/tps=
65217' into regulator-next)
Merging security/next (2fd4e6698f08 Merge branch 'smack-for-3.16' of git://=
git.gitorious.org/smack-next/kernel into next)
Merging selinux/next (47dd0b76ace9 selinux: conditionally reschedule in has=
htab_insert while loading selinux policy)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (4a4d559006e7 watchdog: via_wdt: replace del_timer =
by del_timer_sync)
Merging iommu/next (4a40277d217d Merge branches 'iommu/fixes', 'arm/omap', =
'arm/smmu', 'arm/shmobile', 'x86/amd' and 'arm/exynos' into next)
CONFLICT (content): Merge conflict in drivers/iommu/exynos-iommu.c
Merging dwmw2-iommu/master (5ae0566a0fff iommu/vt-d: fix bug in matching PC=
I devices with DRHD/RMRR descriptors)
Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (7a9e6da11c94 doc: fix incorrect formula to calcul=
ate CommitLimit value)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/arm=
/omap/omap.txt
Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_sysca=
ll_entry() interface)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (d88cf7d7b424 Merge remote-tracking bran=
ch 'robh/for-next' into devicetree/next)
Merging dt-rh/for-next (eafd370dfe48 Merge branch 'dt-bus-name' into for-ne=
xt)
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/platsmp.c
Merging spi/for-next (2bb605f037f5 Merge remote-tracking branches 'spi/topi=
c/id-const', 'spi/topic/oom', 'spi/topic/pxa2xx', 'spi/topic/sirf' and 'spi=
/topic/workqueue' into spi-next)
Merging tip/auto-latest (aec36eaab600 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in drivers/block/mtip32xx/mtip32xx.c
CONFLICT (content): Merge conflict in arch/arm64/mm/mmu.c
CONFLICT (content): Merge conflict in arch/arm64/include/asm/thread_info.h
Applying: ARM: outer cache: no need for bug.h in outercache.h
Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct:=
 silence a static checker warning)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (aa2064d7dd35 EDAC: Fix MC scrub mode comparsion =
bug for correctable errors)
Merging irqchip/irqchip/for-next (d8f17c49d3f2 irqchip: armada-370-xp: Move=
 the devicetree binding documentation)
Merging ftrace/for-next (4449bf927b61 tracing: Add __bitmask() macro to tra=
ce events to cpumasks and other bitmasks)
Merging rcu/rcu/next (61f38db3e3c0 rcu: Provide API to suppress stall warni=
ngs while sysrc runs)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (d9f89b88f510 KVM: x86: Fix CR3 reserved bits check =
in long mode)
Merging kvm-arm/next (4447a208f7fc ARM/ARM64: KVM: Advertise KVM_CAP_ARM_PS=
CI_0_2 to user space)
Merging kvm-ppc/kvm-ppc-next (0f689a33ad17 Merge branch 'for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/s390/linux)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (f59c5145dc6a x86/xen: do not use _PAGE_IOMAP in=
 xen_remap_domain_mfn_range())
Merging percpu/for-next (92a82b81ba46 Merge branch 'for-3.16' into for-next)
Merging workqueues/for-next (74b414ead113 workqueue: remove the confusing P=
OOL_FREEZING)
Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scen=
arios where memory allocations would fail)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (bf60cb3ec5fb Merge remote-tracking branches 'regma=
p/topic/le', 'regmap/topic/mmio', 'regmap/topic/rbtree' and 'regmap/topic/s=
mbus' into regmap-next)
Merging hsi/for-next (eafaebd987fc HSI: Introduce Nokia N900 modem driver)
Merging leds/for-next (0c9a03b68511 leds: Remove duplicated OOM message for=
 individual driver)
Merging driver-core/driver-core-next (d35cc56ddfc9 Merge 3.15-rc3 into stag=
ing-next)
Merging tty/tty-next (e26f1db9b8d7 tty/serial: fix generic earlycon option =
parsing)
CONFLICT (modify/delete): arch/arm64/kernel/early_printk.c deleted in tty/t=
ty-next and modified in HEAD. Version HEAD of arch/arm64/kernel/early_print=
k.c left in tree.
$ git rm -f arch/arm64/kernel/early_printk.c
Merging usb/usb-next (c311e391a7ef xhci: rework command timeout and cancell=
ation,)
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
CONFLICT (modify/delete): drivers/usb/phy/phy-mv-u3d-usb.c deleted in HEAD =
and modified in usb-gadget/next. Version usb-gadget/next of drivers/usb/phy=
/phy-mv-u3d-usb.c left in tree.
$ git rm -f drivers/usb/phy/phy-mv-u3d-usb.c
Merging staging/staging-next (69c1f05379a3 Merge 3.15-rc6 into staging-next=
.)
Merging char-misc/char-misc-next (6a57bad6e78b Merge tag 'extcon-next-for-3=
.16' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into c=
har-misc-next)
Merging cgroup/for-next (5533e0114425 cgroup: disallow debug controller on =
the default hierarchy)
Merging scsi/for-next (f0b45f2bc6f2 Merge branch 'fixes' into for-next)
Merging scsi-core/core-for-3.16 (2a863ba8f6f5 sd: medium access timeout cou=
nter fails to reset)
Merging scsi-drivers/drivers-for-3.16 (b57d7c015dd0 scsi_debug: simple shor=
t transfer injection)
Merging target-updates/for-next (4baaa7d589e2 virtio-scsi: Enable DIF/DIX m=
odes in SCSI host LLD)
CONFLICT (content): Merge conflict in drivers/scsi/virtio_scsi.c
$ git reset --hard HEAD^
Merging next-20140522 version of target-updates
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (12c2e8048190 Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (beb2c1c23fce Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging dma-mapping/dma-mapping-next (bb56d0dc23aa drivers/base/dma-contigu=
ous.c: erratum of dev_get_cma_area)
Merging pwm/for-next (54b02347d718 pwm: ab8500: Fix wrong value shift for d=
isable/enable PWM)
CONFLICT (content): Merge conflict in drivers/leds/leds-pwm.c
Merging dma-buf/for-next (f02d1e45a4c8 reservation: add suppport for read-o=
nly access using rcu)
CONFLICT (content): Merge conflict in drivers/staging/android/sync.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_dmabuf.c
Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of=
 BSD accounting files)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (6ed8eb59e53b Merge tag 'clk-hisi-for-v3.16' of https:=
//git.kernel.org/pub/scm/linux/kernel/git/hzhuang1/linux into clk-next-hisi=
licon)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging random/dev (f9c6d4987b23 random: fix BUG_ON caused by accounting si=
mplification)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (fa88b6f8803c aio: cleanup: flatten kill_ioctx())
Merging llvmlinux/for-next (4f6d454aae03 unwind_support)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (8b1cbef71a7e These days most people use git to send=
 patches so I have added a section about that.)
Merging akpm-current/current (bf01fce89bc0 kernel/seccomp.c: kernel-doc war=
ning fix)
CONFLICT (content): Merge conflict in mm/memcontrol.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: mm/page_io.c: work around gcc bug
Applying: lib/test_bpf.c: don't use gcc union shortcut
Applying: arm: convert use of typedef ctl_table to struct ctl_table
Applying: ia64: convert use of typedef ctl_table to struct ctl_table
Applying: tile: convert use of typedef ctl_table to struct ctl_table
Applying: cdrom: convert use of typedef ctl_table to struct ctl_table
Applying: random: convert use of typedef ctl_table to struct ctl_table
Applying: parport: convert use of typedef ctl_table to struct ctl_table
Applying: scsi: convert use of typedef ctl_table to struct ctl_table
Applying: coda: convert use of typedef ctl_table to struct ctl_table
Applying: fscache: convert use of typedef ctl_table to struct ctl_table
Applying: lockd: convert use of typedef ctl_table to struct ctl_table
Applying: nfs: convert use of typedef ctl_table to struct ctl_table
Applying: inotify: convert use of typedef ctl_table to struct ctl_table
Applying: ntfs: convert use of typedef ctl_table to struct ctl_table
Applying: fs: convert use of typedef ctl_table to struct ctl_table
Applying: key: convert use of typedef ctl_table to struct ctl_table
Applying: ipc: convert use of typedef ctl_table to struct ctl_table
Applying: sysctl: convert use of typedef ctl_table to struct ctl_table
Applying: mm: convert use of typedef ctl_table to struct ctl_table
Applying: mfd/rtc: sec/s5m: rename SEC* symbols to S5M
Applying: rtc: s5m: remove undocumented time init on first boot
Applying: rtc: s5m: use shorter time of register update
Applying: rtc: s5m: support different register layout
Applying: rtc: s5m: add support for S2MPS14 RTC
Applying: rtc: s5m: consolidate two device type switch statements
Applying: blackfin/ptrace: call find_vma with the mmap_sem held
Applying: kernel/watchdog.c: print traces for all cpus on lockup detection
Applying: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix
Applying: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fi=
x-2
Applying: kernel/watchdog.c: convert printk/pr_warning to pr_foo()
Applying: init/main.c: code clean-up
Applying: fs/reiserfs/bitmap.c: coding style fixes
Applying: fs/reiserfs/stree.c: remove obsolete __constant
Applying: rwsem: Support optimistic spinning
Applying: rwsem-support-optimistic-spinning-checkpatch-fixes
Applying: rwsem-support-optimistic-spinning-fix
Applying: kernel/kprobes.c: convert printk to pr_foo()
Applying: sysrq: rcu-ify __handle_sysrq
Applying: sysrq,rcu: suppress RCU stall warnings while sysrq runs
Applying: memcg, mm: introduce lowlimit reclaim
Applying: memcg-mm-introduce-lowlimit-reclaim-fix
Applying: memcg: allow setting low_limit
Applying: memcg, doc: clarify global vs. limit reclaims
Applying: memcg-doc-clarify-global-vs-limit-reclaims-fix
Applying: memcg: document memory.low_limit_in_bytes
Applying: vmscan: memcg: check whether the low limit should be ignored
Applying: vmscan: memcg: always use swappiness of the reclaimed memcg
Applying: mm/kmemleak.c: use %u to print ->checksum
Applying: mm: introduce kmemleak_update_trace()
Applying: lib/radix-tree.c: update the kmemleak stack trace for radix tree =
allocations
Applying: mm/mempool.c: update the kmemleak stack trace for mempool allocat=
ions
Applying: mm/memblock.c: call kmemleak directly from memblock_(alloc|free)
Applying: mm: memcontrol: clean up memcg zoneinfo lookup
Applying: mm: memcontrol: remove unnecessary memcg argument from soft limit=
 functions
Applying: mm: mark remap_file_pages() syscall as deprecated
Applying: mm-mark-remap_file_pages-syscall-as-deprecated-fix
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
Applying: fs/dlm/config.c: convert simple_str to kstr
Applying: fs/dlm/lockspace.c: convert simple_str to kstr
Applying: fs/dlm/debug_fs.c: replace seq_printf by seq_puts
Applying: mm/kmemleak-test.c: use pr_fmt for logging
Applying: bio: modify __bio_add_page() to accept pages that don't start a n=
ew segment
Applying: bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-s=
egment-v3
Applying: MAINTAINERS: add linux-api for review of API/ABI changes
Applying: MAINTAINERS: adi-buildroot-devel is moderated
Applying: mm: convert some level-less printks to pr_*
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: ufs: sb mutex merge + mutex_destroy
Applying: mm: add strictlimit knob
Merging akpm/master (ee5dbb76052a mm: add strictlimit knob)

--Sig_/QbwkEj=KFhzMrVm1/AuEOaM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfyYfAAoJEMDTa8Ir7ZwVAEAP/039sDvMP5MucXmMHPrpRq6Y
41HxQFzAT2JY2fX1732SRH7seYu0krqsyNQE9WBeJYnIArBN/pair19h5f6CY1mB
KOvh9xX5Of5i6SR1ehfLkXZBUocKLSav80jwtOuNrdC+KH52Dzg3iM/eFUwwdi2L
BQ9j8pzDJOoTTNccYBUpoJJ9+scyKKzHQEvviuUXTHR1mZpD5yhWvO+RPIwjthNG
ykf4PdtRNbWMG0nJkBQapClVgMTC9O4OJVGRp3AdiRO/su2YdtChOUocAvnmYucF
vxSL4ZPJyPM9qXj19JoPtNsFVTotOe2g7Ry/wVg+9EyEr3kOX5MOfhf6ky4MLR1i
QJcMh50H1KS84KAmrrUklKaOrdCdk4ztLM22bv2gUBfS1SvMyo8x8GhMEzI73lNY
o/ob2VaUeeJsyh4jwDgW3BNLNshWtIP8GlQj7PzJSOk63PdM79LWth+6gNbvLwpV
lPCQyo/N/GXurtZ1Ko34GSzOc6UpfvAeazD6C2HVGvkVQ5jGZsaydoYQXlyvnRxk
+e1N2iabjrWBHz2Ge05nr2IaQqOs4EJEFVBCsG0ao3IiTT3l2F2zEGKFSMeXSzAb
zV7h+i/tD5clIqrpK9BDTVFXCHxPRoSYmwPI6U5Q2W+mS9CJfroBs3ptwV2a0ALH
EMp1QN14vm8zzbBNlcTG
=7Ibf
-----END PGP SIGNATURE-----

--Sig_/QbwkEj=KFhzMrVm1/AuEOaM--
