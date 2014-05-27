Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaE0JK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:10:59 -0400
Received: from ozlabs.org ([103.22.144.67]:52428 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaE0JKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:10:49 -0400
Date: Tue, 27 May 2014 19:10:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for May 27
Message-ID: <20140527191041.761b514d@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6Di=iS3AJkvvZi.vVYqICWy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6Di=iS3AJkvvZi.vVYqICWy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Changes since 20140526:

The arm-soc tree gained conflicts against the arm tree.

The nfsd tree still had its build failure so I used the version from
next-20140523.

The vfs tree gained a conflict against the ext4 tree.

The l2-mtd tree lost its build failure.

The mmc tree still had its its build failure so I used the version from
next-20140522.

The regulator tree gained a build failure so I used the version form
next-20140526.

The trivial tree gained a conflict against the arm-soc tree.

The clockevents tree lost its build failure.

The tty tree gained a conflict against the m68k tree.

he akpm-current tree gained a conflict against the ext4 tree.

Non-merge commits (relative to Linus' tree): 8945
 7538 files changed, 344090 insertions(+), 210293 deletions(-)

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
Merging origin/master (c7208164e66f Linux 3.15-rc7)
Merging fixes/master (4b660a7f5c80 Linux 3.15-rc6)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (a798c10faf62 Linux 3.15-rc2)
Merging arm-current/fixes (483a6c9d447f ARM: 8064/1: fix v7-M signal return)
Merging m68k-current/for-linus (50be9eba831d m68k: Update defconfigs for v3=
.14-rc1)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (8050936caf12 powerpc: irq work racing with tim=
er interrupt can result in timer interrupt hang)
Merging sparc/master (8ecc1bad4c9b sparc64: fix format string mismatch in a=
rch/sparc/kernel/sysfs.c)
Merging net/master (8646224cdb94 Merge branch 'for-davem' of git://git.kern=
el.org/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (6d004d6cc739 vti: Use the tunnel mark for lookup in t=
he error handlers.)
Merging sound-current/for-linus (77f07800cb45 ALSA: hda - Fix onboard audio=
 on Intel H97/Z97 chipsets)
Merging pci-current/for-linus (d0b4cc4e3270 PCI: Wrong register used to che=
ck pending traffic)
Merging wireless/master (2c316e699fa4 Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes)
Merging driver-core.current/driver-core-linus (4b660a7f5c80 Linux 3.15-rc6)
Merging tty.current/tty-linus (d6d211db37e7 Linux 3.15-rc5)
Merging usb.current/usb-linus (8ef42ddd9a53 USB: Avoid runtime suspend loop=
s for HCDs that can't handle suspend/resume)
Merging usb-gadget-fixes/fixes (886c7c426d46 usb: gadget: at91-udc: fix irq=
 and iomem resource retrieval)
Merging staging.current/staging-linus (28a821c30688 Staging: speakup: Updat=
e __speakup_paste_selection() tty (ab)usage to match vt)
Merging char-misc.current/char-misc-linus (d1db0eea8524 Linux 3.15-rc3)
Merging input-current/for-linus (0f68f39c393b Input: synaptics - change min=
/max quirk table to pnp-id matching)
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
Merging drm-intel-fixes/for-linux-next-fixes (c1240bd2842f drm/i915: Preven=
t negative relocation deltas from wrapping)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (35b960a30019 ARC: remove duplicate header exports)
Merging arm/for-next (38206255d7c8 Merge branch 'devel-stable' into for-nex=
t)
Applying: ARM: outer cache: no need for bug.h in outercache.h
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (d18135c126e8 ARM: perf: add support for the=
 Cortex-A17 PMU)
Merging arm-soc/for-next (f10ccd599d54 arm: soc: document merges)
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-rockchip/rockchip.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/omap-mpuss-lowpow=
er.c
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
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (0a847a5b6ebe Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (f807d60faf6c Merge branch 'sh-drivers-for-v3.16' into=
 next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
Merging samsung/for-next (6e799d8c5794 Merge branch 'v3.16-next/soc-exynos-=
2' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/firmware.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/exynos.c
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging tegra/for-next (ae3caacb703d Merge branch for-3.16/defconfig into f=
or-next)
Merging arm64/for-next/core (af885f402262 arm64: Fix linker script entry po=
int)
Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (aa1a21df651c m68k/hp300: Convert printk to pr_foo())
Merging m68knommu/for-next (83c6bdb827c9 m68knommu: Implement gpio support =
for m54xx.)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (14186fea0cb0 Merge tag 'locks-v3.15-4' of git://gi=
t.samba.org/jlayton/linux)
Merging mips/mips-for-linux-next (19f6403cedba Merge branch '3.15-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (872aa779bcdd powerpc/module: Fix stubs for BE)
Merging fsl/next (e83eb028bb98 powerpc/fsl: Add fsl,portid-mapping to coren=
et1-cf chips)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (9fea3e79241e s390/oprofile: make return of 0 explici=
t)
Merging sparc-next/master (311b8935ad4e Merge branch 'sparc_sparse_fixes')
CONFLICT (content): Merge conflict in arch/sparc/include/asm/pgtable_64.h
Merging tile/master (ba159fd387a4 tile: Update comments for generic idle co=
nversion)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d7de15786d1a arch:unicore32:mm: add devmem_is_=
allowed() to support STRICT_DEVMEM)
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (00fdf13a2e9f Btrfs: fix a crash of clone with inline ex=
tents's split)
Merging ceph/master (a30be7cb2ccb ceph: skip invalid dentry during dcache r=
eaddir)
Merging cifs/for-next (08b37d518af3 cifs: ensure that vol->username is not =
NULL before running strlen on it)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (01d8885785a6 reiserfs: fix race in readdir)
Merging ext4/dev (30f902f3886f ext4: fix wrong assert in ext4_mb_normalize_=
request())
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
Merging nfs/linux-next (7a9a7b774fd5 SUNRPC: Fix a module reference issue i=
n rpcsec_gss)
Merging nfsd/nfsd-next (a676de9e22b4 nfsd4: allow encoding across page boun=
daries)
$ git reset --hard HEAD^
Merging next-20140523 version of nfsd
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
CONFLICT (content): Merge conflict in fs/ext4/file.c
Merging pci/next (e5558d1a516f Merge branches 'dma-api', 'pci/virtualizatio=
n', 'pci/msi', 'pci/misc' and 'pci/resource' into next)
CONFLICT (content): Merge conflict in arch/s390/pci/pci_sysfs.c
Merging hid/for-next (17b101cfc0a9 Merge branch 'for-3.16/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (d275545e0e22 ARM: sunxi: dt: Convert to the new i=
2c compatibles)
Merging jdelvare-hwmon/master (5d0b6b341687 hwmon: (ntc_thermistor) Fix OF =
device ID mapping)
Merging hwmon-staging/hwmon-next (e8cba3cda44e hwmon: (ultra45_env) Introdu=
ce managed version of kzalloc)
Merging v4l-dvb/master (656111f4b9cb Merge branch 'topic/omap3isp' into to_=
next)
Merging kbuild/for-next (5366c855e0d8 Merge branches 'kbuild/misc' and 'kbu=
ild/kbuild' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (5b32c21d52cc Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (523bac961a41 Merge branch 'pnp' into linux-next)
CONFLICT (content): Merge conflict in drivers/cpufreq/exynos-cpufreq.h
CONFLICT (content): Merge conflict in drivers/cpufreq/exynos-cpufreq.c
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
Merging net-next/master (3bea8eddfebe Merge branch 'net-sysfs-docs')
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/mac8=
0211.c
Merging ipsec-next/master (fc68086ce888 net/xfrm/xfrm_output.c: move EXPORT=
_SYMBOL)
Merging wireless-next/master (ef1b075c15d5 mwifiex: use 'const' qualifier f=
or 2nd arg of mwifiex_tdls_add_ht_oper)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/mac8=
0211.c
Merging bluetooth/master (d7b2545023ec Bluetooth: Clearly distinguish mgmt =
LTK type from authenticated property)
CONFLICT (content): Merge conflict in drivers/bluetooth/btusb.c
Merging infiniband/for-next (e9ca67cbc81b Merge branches 'cxgb4', 'mlx5', '=
ocrdma' and 'srp' into for-next)
Merging mtd/master (28c015a9daab mtd: davinci-nand: disable subpage write f=
or keystone-nand)
Merging l2-mtd/master (897f3a18b0bb mtd: lpddr: fix Kconfig dependency, for=
 I/O accessors)
Merging crypto/master (5208ed2ca165 crypto: testmgr - add aead cbc des, des=
3_ede tests)
CONFLICT (content): Merge conflict in drivers/crypto/caam/error.c
CONFLICT (rename/delete): drivers/crypto/bfin_crc.h deleted in HEAD and ren=
amed in crypto/master. Version crypto/master of drivers/crypto/bfin_crc.h l=
eft in tree.
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in crypto/crypto_user.c
Merging drm/drm-next (59201052dff1 drm/ttm: fix kerneldoc of ttm_bo_create)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_gtt.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_execbuf=
fer.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Merging drm-panel/drm/panel/for-next (02dfc65dc905 drm/panel: add support f=
or EDT ET057090DHU panel)
Merging drm-intel/for-linux-next (dbf0001f5cf7 drm/i915: Keep vblank interr=
upts enabled while enabling/disabling planes)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.h
Merging drm-tegra/drm/tegra/for-next (f00e104dc165 drm/tegra: gem - Make te=
gra_bo_import() static)
Merging sound/for-next (033b0a7ca9ca ALSA: hda - Pop noises fix for XPS13 9=
333)
Merging sound-asoc/for-next (bd0c2ba265d2 Merge remote-tracking branches 'a=
soc/topic/sta350', 'asoc/topic/tegra', 'asoc/topic/tlv320dac33', 'asoc/topi=
c/ux500', 'asoc/topic/wm8731', 'asoc/topic/wm8804', 'asoc/topic/wm8955' and=
 'asoc/topic/wm8985' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (a17597d3b418 virtio-rng: fixes for device regis=
tration/unregistration)
Merging input/next (899fce0e73d5 Input: atmel_mxt_ts - handle multiple inpu=
t reports in one message)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (aaa327806988 Merge branch 'for-3.16/core' into for-=
next)
Merging device-mapper/for-next (2bb4781998b1 dm cache: always split discard=
s on cache block boundaries)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (06732b84b4cf mmc: sdhci-of-esdhc: Fixup compile error)
CONFLICT (content): Merge conflict in include/linux/omap-dma.h
Applying: dmaengine: omap: fix for code movement
$ git reset --hard HEAD^
Merging next-20140522 version of mmc
Merging mmc-uh/next (5080a08d0f8a mmc: mmci: Enforce max frequency configur=
ation through DT)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (41040c9701c2 raid5: add an option to avoid copy data f=
rom bio to stripe cache)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (790adb198f58 mfd: abx500-core: Remove unused f=
unction abx500_dump_all_banks())
CONFLICT (add/add): Merge conflict in drivers/mmc/host/rtsx_usb_sdmmc.c
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (5e8c0b91d3ec Merge branches '3.16/fbdev' and '3=
.16/fbdev-omap' into for-next)
Merging regulator/for-next (6cb498090993 Merge remote-tracking branches 're=
gulator/topic/tps65218' and 'regulator/topic/tps6586x' into regulator-next)
$ git reset --hard HEAD^
Merging next-20140526 version of regulator
Merging security/next (2fd4e6698f08 Merge branch 'smack-for-3.16' of git://=
git.gitorious.org/smack-next/kernel into next)
Merging selinux/next (47dd0b76ace9 selinux: conditionally reschedule in has=
htab_insert while loading selinux policy)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (ce7f15b26c9d watchdog: sp805: Set watchdog_device-=
>timeout from ->set_timeout())
Merging iommu/next (8005d3942e6f Merge branches 'iommu/fixes', 'arm/omap', =
'arm/smmu', 'arm/shmobile', 'x86/amd', 'arm/exynos', 'arm/renesas' and 'ppc=
/pamu' into next)
CONFLICT (content): Merge conflict in drivers/iommu/exynos-iommu.c
Merging dwmw2-iommu/master (5ae0566a0fff iommu/vt-d: fix bug in matching PC=
I devices with DRHD/RMRR descriptors)
Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (31789538e3ba staging: go7007: remove reference to=
 CONFIG_KMOD)
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
Merging devicetree/devicetree/next (ad69674e73a1 of/irq: do irq resolution =
in platform_get_irq_byname())
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/platsmp.c
Applying: of: fix bad merge of drivers/of/base.c
Merging dt-rh/for-next (eafd370dfe48 Merge branch 'dt-bus-name' into for-ne=
xt)
Merging spi/for-next (4bc9db0cac38 Merge remote-tracking branches 'spi/topi=
c/id-const', 'spi/topic/oom', 'spi/topic/pxa2xx', 'spi/topic/rspi', 'spi/to=
pic/sirf' and 'spi/topic/workqueue' into spi-next)
Merging tip/auto-latest (aec36eaab600 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in drivers/block/mtip32xx/mtip32xx.c
CONFLICT (content): Merge conflict in arch/arm64/mm/mmu.c
CONFLICT (content): Merge conflict in arch/arm64/include/asm/thread_info.h
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/vf610.dtsi
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (aa2064d7dd35 EDAC: Fix MC scrub mode comparsion =
bug for correctable errors)
Merging irqchip/irqchip/for-next (3203bea71513 Documentation: add Broadcom =
STB Level-2 interrupt controller binding)
Merging ftrace/for-next (4449bf927b61 tracing: Add __bitmask() macro to tra=
ce events to cpumasks and other bitmasks)
Merging rcu/rcu/next (61f38db3e3c0 rcu: Provide API to suppress stall warni=
ngs while sysrc runs)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (1f854112553a KVM: vmx: DR7 masking on task switch e=
mulation is wrong)
Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support =
for Cortex-A53)
Merging kvm-ppc/kvm-ppc-next (0f689a33ad17 Merge branch 'for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/s390/linux)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (78734483f071 Merge branch 'devel/for-linus-3.16=
' into linux-next)
Merging percpu/for-next (92a82b81ba46 Merge branch 'for-3.16' into for-next)
Merging workqueues/for-next (74b414ead113 workqueue: remove the confusing P=
OOL_FREEZING)
Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scen=
arios where memory allocations would fail)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (d126a4dba4f5 Merge remote-tracking branches 'regma=
p/topic/irq', 'regmap/topic/le', 'regmap/topic/mmio', 'regmap/topic/rbtree'=
 and 'regmap/topic/smbus' into regmap-next)
Merging hsi/for-next (eafaebd987fc HSI: Introduce Nokia N900 modem driver)
Merging leds/for-next (0c9a03b68511 leds: Remove duplicated OOM message for=
 individual driver)
Merging driver-core/driver-core-next (5cbb00cc4aae lib/devres.c: fix checkp=
atch warnings)
Merging tty/tty-next (e26f1db9b8d7 tty/serial: fix generic earlycon option =
parsing)
CONFLICT (modify/delete): arch/arm64/kernel/early_printk.c deleted in tty/t=
ty-next and modified in HEAD. Version HEAD of arch/arm64/kernel/early_print=
k.c left in tree.
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
$ git rm -f arch/arm64/kernel/early_printk.c
Merging usb/usb-next (2ea7b1487f97 usb: phy: msm: fix bug in probe())
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
Merging staging/staging-next (a61a9390500b staging: rtl8188eu: Remove empty=
 file odm_interface.h)
Merging char-misc/char-misc-next (6a57bad6e78b Merge tag 'extcon-next-for-3=
.16' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into c=
har-misc-next)
Merging cgroup/for-next (5533e0114425 cgroup: disallow debug controller on =
the default hierarchy)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Merging scsi/for-next (f0b45f2bc6f2 Merge branch 'fixes' into for-next)
Merging scsi-core/core-for-3.16 (2a863ba8f6f5 sd: medium access timeout cou=
nter fails to reset)
Merging scsi-drivers/drivers-for-3.16 (b57d7c015dd0 scsi_debug: simple shor=
t transfer injection)
Merging target-updates/for-next (ed6849ff4921 qla2xxx: Convert to percpu_id=
a session tag pre-allocation)
CONFLICT (content): Merge conflict in drivers/scsi/virtio_scsi.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_target.c
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
Merging gpio/for-next (51caa05a82df Documentation / ACPI: Fix location of G=
PIO documentation)
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging dma-mapping/dma-mapping-next (bb56d0dc23aa drivers/base/dma-contigu=
ous.c: erratum of dev_get_cma_area)
Merging pwm/for-next (39fd3f99aba3 pwm: fsl-ftm: set pwm_chip can_sleep fla=
g)
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
Merging clk/clk-next (42dd880e6780 Merge branch 'clk-fixes' into clk-next)
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
CONFLICT (content): Merge conflict in fs/ext4/page-io.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: mm/page_io.c: work around gcc bug
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
Merging akpm/master (ca1139488da3 mm: add strictlimit knob)

--Sig_/6Di=iS3AJkvvZi.vVYqICWy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThFaWAAoJEMDTa8Ir7ZwVGYIQAIx2U+ZHrle5iJpJzWGKzUP6
TILnLXDAUp6Dm9FSWA6uVuYnXEd2zssEgHs7B+ZZbSguqEmYzWNkbtsKyyW7QBmL
ccf+3U2V2IxM2izwLyLswOZyB9grmzK1qdUmiMOXjQiYqJw6GV6AxKUaGXk3JSUE
3yrCHnx6fSb90EfiQqqXzor98B1Sf8STeyfXoo9EDCdcRcfMcZiSyv9rj9Hv7xIO
7KdWhSparbISP97ycM1adDIvn5u6i/lny2EjCNaOruYogcotkZAmazCWXqo7NBno
48e/zFxpaNeRO9huGMrFpOsXXMVgXFYU+rOntPMx0n5XsM2u1YZM27RepItwHS0C
+ZqScSumhA3Zd1VIU5cGLk0tXBaxo6Ef4xU5qr3vOLnQxFMBU697thTMwYQXq8/d
xiKu8+BHoCopwd1NQYfWb8mhV/N8mYVDjjY6lb+YJdvZLc4UvWHLnMtn1zdV7xrh
FGArstaUpGj4KH1haNmMbAFWXfzmyvPzskZGjs26ngx+fiJgPXcRb88gx8SPaLHk
TdIgoj4wR1DenTe6tGAtWknnFb0ezYwNY3c06/rkjekwXBsmIEgDvJ+/p4ObDGWg
kt6mJnxem0VEOE1jsp3kUhBuM27W+gGUPVmHE67F7mvdX7yFZTQMflmSYtKrZrim
cNp+mgk94HLTg0bZmPBR
=8T1S
-----END PGP SIGNATURE-----

--Sig_/6Di=iS3AJkvvZi.vVYqICWy--
