Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaEOHsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:48:35 -0400
Received: from ozlabs.org ([103.22.144.67]:57436 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbaEOHsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:48:30 -0400
Date: Thu, 15 May 2014 17:48:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 15
Message-ID: <20140515174811.5011b220@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uwI4ThG5mbDIS=1.x4scBAk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uwI4ThG5mbDIS=1.x4scBAk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140514:

My fixes tree contains:
	powerpc/ppc64: Allow allmodconfig to build (finally !)

The gpio tree still had its build failure for which I reverted 2 commits.

The clk tree gained a conflict against the renesas tree.

The akpm-current tree lost its build failure.

Non-merge commits (relative to Linus' tree): 5424
  5048 files changed, 183887 insertions(+), 111768 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 218 trees (counting Linus' and 29 trees of patches
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
Merging origin/master (14186fea0cb0 Merge tag 'locks-v3.15-4' of git://git.=
samba.org/jlayton/linux)
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
Merging sparc/master (e5c460f46ae7 sparc64: Don't bark so loudly about 32-b=
it tasks generating 64-bit fault addresses.)
Merging net/master (e84d2f8d2ae3 net: filter: s390: fix JIT address randomi=
zation)
Merging ipsec/master (6d004d6cc739 vti: Use the tunnel mark for lookup in t=
he error handlers.)
CONFLICT (content): Merge conflict in net/ipv4/ip_vti.c
Merging sound-current/for-linus (665ebe926e7b ALSA: sb_mixer: missing retur=
n statement)
Merging pci-current/for-linus (f5d3352b2751 PCI: tegra: Use new OF interrup=
t mapping when possible)
Merging wireless/master (faf1dc64e345 ath9k_htc: Stop ANI before doing hw_r=
eset)
Merging driver-core.current/driver-core-linus (555724a831b4 kernfs, sysfs, =
cgroup: restrict extra perm check on open to sysfs)
Merging tty.current/tty-linus (62a0d8d7c2b2 tty: Fix lockless tty buffer ra=
ce)
Merging usb.current/usb-linus (6ed07d45d09b USB: Nokia 5300 should be treat=
ed as unusual dev)
Merging usb-gadget-fixes/fixes (886c7c426d46 usb: gadget: at91-udc: fix irq=
 and iomem resource retrieval)
Merging staging.current/staging-linus (3519acb3b0c2 Merge branch 'imx-drm-f=
ixes-urgent' of git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-linu=
s)
Merging char-misc.current/char-misc-linus (d1db0eea8524 Linux 3.15-rc3)
Merging input-current/for-linus (0b5fe736fe92 Input: synaptics - add min/ma=
x quirk for the ThinkPad W540)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (3901c1124ec5 crypto: s390 - fix aes,des ctr =
mode concurrency finding.)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (58b116bce136 drivercore: defer=
ral race condition fix)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (9bbfd20abe50 drm/i915: don't =
try DP_LINK_BW_5_4 on HSW ULX)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (134aeaed08c4 ARC: Fixed spelling errors within commen=
ts)
Merging arm/for-next (c34eb07ff897 Merge branches 'fixes' and 'misc' into f=
or-next)
Merging arm-kvm-cpuresume/arm-kvm-cpuresume (91a3f6af430d arm: kernel: slee=
p: restore HYP mode configuration in cpu_resume)
Merging arm-perf/for-next/perf (d18135c126e8 ARM: perf: add support for the=
 Cortex-A17 PMU)
Merging arm-soc/for-next (4f45916bdfad Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (95e39d776f69 Merge branch 'topic/clk-driver=
' into berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (3ec7d839fb22 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17191583568 Merge branch 'for_3.16/dts' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (00a6a511a257 Merge branch 'mvebu/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/Kconfig
Merging renesas/next (7ec801bbf7fb Merge branch 'heads/dt-for-v3.16' into n=
ext)
Merging samsung/for-next (8071e23f71db Merge branch 'v3.16-next/soc-exynos'=
 into for-next)
Merging tegra/for-next (5d2a7023e1ab Merge branch for-3.16/defconfig into f=
or-next)
Merging arm64/for-next/core (dc60b777fcdd arm64: mm: use inner-shareable ba=
rriers for inner-shareable maintenance)
Merging blackfin/for-linus (c4a2c58d2095 blackfin: cleanup board files)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (50be9eba831d m68k: Update defconfigs for v3.14-rc1)
Merging m68knommu/for-next (2f91abcad994 m68k: fix a compiler warning when =
building for DragonBall)
Merging metag/for-next (2aca46ce1b5c sched: remove unused SCHED_INIT_NODE)
Merging microblaze/next (a66a626538af microblaze: Use asm-generic/io.h)
Merging mips/mips-for-linux-next (b9c9c8964f84 Merge branch '3.15-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (f4030047d92c parisc: Improve LWS-CAS performanc=
e)
Merging powerpc/next (f6869e7fe657 Merge remote-tracking branch 'anton/abiv=
2' into next)
CONFLICT (content): Merge conflict in arch/powerpc/kernel/exceptions-64s.S
Merging fsl/next (f9eb581c63b2 powerpc: fix build of epapr_paravirt on 64-b=
it book3s)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (88140456967a s390/spinlock: fix system hang with spi=
n_retry <=3D 0)
Merging sparc-next/master (bf6569988a48 Merge branch 'sparc32_generic_io_h')
Merging tile/master (e540e835f89c tile: cleanup the comment in init_pgprot)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
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
Merging gfs2/master (24972557b12c GFS2: remove transaction glock)
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
Merging xfs/for-next (2d6dcc6d7e95 Merge branch 'xfs-attr-cleanup' into for=
-next)
Merging file-private-locks/linux-next (9f234be73db8 locks: add some tracepo=
ints in the lease handling code)
Merging vfs/for-next (9bd0bc947d95 kill generic_file_splice_write())
CONFLICT (content): Merge conflict in fs/f2fs/file.c
CONFLICT (content): Merge conflict in fs/cifs/cifsfs.c
Merging pci/next (518a6a34f645 Merge branches 'pci/hotplug', 'pci/msi', 'pc=
i/virtualization' and 'pci/misc' into next)
Merging hid/for-next (41f4c19b137e Merge branch 'for-3.16/rmi4' into for-ne=
xt)
Merging i2c/i2c/for-next (d7653964c590 i2c: rcar: bail out on zero length t=
ransfers)
Merging jdelvare-hwmon/master (c9eaa447e77e Linux 3.15-rc1)
Merging hwmon-staging/hwmon-next (41c405b35491 hwmon: (emc1403) Add support=
 for emc14x2)
Merging v4l-dvb/master (89e2d4278eb8 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (5366c855e0d8 Merge branches 'kbuild/misc' and 'kbu=
ild/kbuild' into kbuild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (5d388f74d7cc Merge branch 'for-3.16' into for-next)
Merging pm/linux-next (47dc715a31df Merge branches 'pm-sleep', 'powercap' a=
nd 'pnp' into linux-next)
CONFLICT (content): Merge conflict in arch/mips/loongson/lemote-2f/clock.c
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (9477165ec525 thermal: rcar-thermal: update thermal zo=
ne only when temperature changes)
Merging ieee1394/for-next (1118f8d048dd firewire: net: fix NULL derefencing=
 in fwnet_probe())
Merging dlm/next (075f01775f53 dlm: use INFO for recovery messages)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (4d340bcee675 Merge branch 'fixes' into next)
Merging dmaengine/next (b9bf6d2e84b7 dma: mv_xor: Flush descriptors before =
activating a channel)
Merging net-next/master (eb02a272c97b driver/net/ethernet/ec_bhf.c: fix spa=
rse warnings)
CONFLICT (content): Merge conflict in net/ipv6/xfrm6_output.c
Merging ipsec-next/master (fc68086ce888 net/xfrm/xfrm_output.c: move EXPORT=
_SYMBOL)
Merging wireless-next/master (5f407acbb7d6 rsi: Changed the return value to=
 enable BA set-up)
Merging bluetooth/master (5a134faeef82 Bluetooth: Store TX power level for =
connection)
CONFLICT (content): Merge conflict in drivers/bluetooth/btusb.c
Merging infiniband/for-next (7d0a73a40c5c RDMA/cxgb4: Update Kconfig to inc=
lude Chelsio T5 adapter)
Merging mtd/master (28c015a9daab mtd: davinci-nand: disable subpage write f=
or keystone-nand)
Merging l2-mtd/master (ddd47b5704f4 mtd: eLBC NAND: fix subpage write suppo=
rt)
Merging crypto/master (0118a5521375 hwrng: n2-drv - Introduce the use of th=
e managed version of kzalloc)
CONFLICT (content): Merge conflict in drivers/crypto/caam/error.c
CONFLICT (rename/delete): drivers/crypto/bfin_crc.h deleted in HEAD and ren=
amed in crypto/master. Version crypto/master of drivers/crypto/bfin_crc.h l=
eft in tree.
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in crypto/crypto_user.c
Merging drm/drm-next (444c9a08bf78 Merge branch 'drm-init-cleanup' of git:/=
/people.freedesktop.org/~danvet/drm into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_gtt.c
Merging drm-panel/drm/panel/for-next (752a30de7318 drm/panel: ld9040: add p=
ower control sequence)
Merging drm-intel/for-linux-next (229b0489aa75 drm/i915: add null render st=
ates for gen6, gen7 and gen8)
Merging drm-tegra/drm/tegra/for-next (f00e104dc165 drm/tegra: gem - Make te=
gra_bo_import() static)
Merging sound/for-next (d576422eda7f ALSA: hda - if statement not indented)
Merging sound-asoc/for-next (f625af36b7ba Merge remote-tracking branches 'a=
soc/topic/sirf', 'asoc/topic/sta350', 'asoc/topic/tlv320dac33', 'asoc/topic=
/wm8731', 'asoc/topic/wm8804', 'asoc/topic/wm8955' and 'asoc/topic/wm8985' =
into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (08e53fbdb85c virtio-rng: support multiple virti=
o-rng devices)
Merging input/next (dc14dd3af2b2 Input: pmic8xxx-pwrkey - set sane default =
for debounce time)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (35c6b0f43b1d Merge branch 'for-3.16/drivers' into f=
or-next)
Merging device-mapper/for-next (7a60eb0511ba dm cache: simplify incrementin=
g the all_io_ds deferred_set refcount)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (197160d52e85 mmc: sdhci: remove mdelay in eMMC tuning)
Merging mmc-uh/next (0bb692d67ce7 mmc: mmci: Enforce max frequency configur=
ation through DT)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (34bf6ef94a83 mm: slab/slub: use page->list consisten=
tly instead of page->lru)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (41040c9701c2 raid5: add an option to avoid copy data f=
rom bio to stripe cache)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (06ed83a1566a mfd: sec-core: Remove duplicated =
device type from sec_pmic_dev)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (cac74bcff07d Merge branches '3.16/fbdev' and '3=
.16/fbdev-omap' into for-next)
Merging regulator/for-next (e9bf70c21cc5 Merge remote-tracking branch 'regu=
lator/topic/tps65217' into regulator-next)
CONFLICT (content): Merge conflict in drivers/regulator/tps65090-regulator.c
Merging security/next (fab71a90edda security: Convert use of typedef ctl_ta=
ble to struct ctl_table)
Merging selinux/next (626b9740fa73 selinux:  Report permissive mode in avc:=
 denied messages.)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (4a4d559006e7 watchdog: via_wdt: replace del_timer =
by del_timer_sync)
Merging iommu/next (4a40277d217d Merge branches 'iommu/fixes', 'arm/omap', =
'arm/smmu', 'arm/shmobile', 'x86/amd' and 'arm/exynos' into next)
Merging dwmw2-iommu/master (5ae0566a0fff iommu/vt-d: fix bug in matching PC=
I devices with DRHD/RMRR descriptors)
Merging vfio/next (4379d2ae1528 vfio: always select ANON_INODES)
Merging osd/linux-next (f1f6630b53e7 MAINTAINERS: Update email address for =
bhalevy)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (5835f25117ef mm: Fix printk typo in dmapool.c)
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
Merging spi/for-next (c7728f90c648 Merge remote-tracking branches 'spi/topi=
c/id-const', 'spi/topic/oom', 'spi/topic/pxa2xx', 'spi/topic/sirf' and 'spi=
/topic/workqueue' into spi-next)
Merging tip/auto-latest (1974363f7e89 Merge branch 'x86/x32')
CONFLICT (content): Merge conflict in net/ipv4/tcp_output.c
CONFLICT (content): Merge conflict in kernel/sched/idle.c
CONFLICT (content): Merge conflict in drivers/block/mtip32xx/mtip32xx.c
Merging clockevents/clockevents/next (09e15176ded1 clocksource: exynos_mct:=
 silence a static checker warning)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (aa2064d7dd35 EDAC: Fix MC scrub mode comparsion =
bug for correctable errors)
Merging irqchip/irqchip/for-next (c9eaa447e77e Linux 3.15-rc1)
Merging ftrace/for-next (b1169cc69ba9 tracing: Remove mock up poll wait fun=
ction)
Merging rcu/rcu/next (b3cc6a599870 rcu: Throttle NOCB kthread grace-period =
rate)
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
Merging xen-tip/linux-next (79390289cfeb arm,arm64/xen: introduce HYPERVISO=
R_suspend())
Merging percpu/for-next (92a82b81ba46 Merge branch 'for-3.16' into for-next)
Merging workqueues/for-next (cf416171e7e1 workqueue: Remove deprecated syst=
em_nrt[_freezable]_wq)
Merging drivers-x86/linux-next (7a70906e55bf alienware-wmi: cover some scen=
arios where memory allocations would fail)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (bf60cb3ec5fb Merge remote-tracking branches 'regma=
p/topic/le', 'regmap/topic/mmio', 'regmap/topic/rbtree' and 'regmap/topic/s=
mbus' into regmap-next)
Merging hsi/for-next (84d93b5e6053 HSI: hsi-char: fix driver for multiport =
scenarios)
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
Merging usb/usb-next (53971a86d2db Merge 3.15-rc3 into usb-next)
Merging usb-gadget/next (60b6dbeffb8c documentation: docbook: document proc=
ess of writing an musb glue layer)
CONFLICT (modify/delete): drivers/usb/phy/phy-mv-u3d-usb.c deleted in HEAD =
and modified in usb-gadget/next. Version usb-gadget/next of drivers/usb/phy=
/phy-mv-u3d-usb.c left in tree.
$ git rm -f drivers/usb/phy/phy-mv-u3d-usb.c
Merging staging/staging-next (c4784756a53f Merge branch 'imx-drm-fixes' of =
git://ftp.arm.linux.org.uk/~rmk/linux-arm into staging-next)
CONFLICT (content): Merge conflict in drivers/iio/adc/Kconfig
Merging char-misc/char-misc-next (4f0638100fe3 misc: arm-charlcd: add DT pr=
obe support)
Merging cgroup/for-next (9d755d33f0db cgroup: use cgroup->self.refcnt for c=
group refcnting)
Merging scsi/for-next (1a2184c0d747 [SCSI] More USB deadlock fixes)
Merging target-updates/for-next (d1db0eea8524 Linux 3.15-rc3)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (565bea2abdf7 Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (4d2d02703880 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
$ git am -3 ../patches/0001-Revert-gpio-stmpe-switch-to-use-gpiolib-irqchip=
-help.patch
Applying: Revert "gpio: stmpe: switch to use gpiolib irqchip helpers"
$ git am -3 ../patches/0002-Revert-mfd-stmpe-root-out-static-GPIO-and-IRQ-a=
ssign.patch
Applying: Revert "mfd: stmpe: root out static GPIO and IRQ assignments"
Merging dma-mapping/dma-mapping-next (59f0f119e85c arm: dma-mapping: Fix ma=
pping size value)
Merging pwm/for-next (9c88669c2cfc pwm: twl: Really disable twl6030 PWMs)
Merging dma-buf/for-next (dcb99fd9b08c Linux 3.14-rc7)
Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of=
 BSD accounting files)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (a97181adf150 clk: sunxi: Fixup clk_sunxi_mmc_phase_co=
ntrol to take a clk rather then a hw_clk)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging random/dev (7b878d4b48c4 random: Add arch_has_random[_seed]())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (fa88b6f8803c aio: cleanup: flatten kill_ioctx())
Merging llvmlinux/for-next (4f6d454aae03 unwind_support)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (c9e7f4124daa The sum at the beginning of line "intr=
" includes also unnumbered interrupts. It implies that the sum at the begin=
ning isn't the sum of the remainder of the line, not even an estimation.)
Merging akpm-current/current (6456b00c4f4a sysrq,rcu: suppress RCU stall wa=
rnings while sysrq runs)
CONFLICT (content): Merge conflict in mm/memcontrol.c
CONFLICT (content): Merge conflict in mm/memblock.c
CONFLICT (content): Merge conflict in arch/x86/kernel/apic/hw_nmi.c
Applying: mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets=
-fix
Applying: memcg: update for change from write_string() to write()
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
Applying: kernel/kprobes.c: convert printk to pr_foo()
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: ufs: sb mutex merge + mutex_destroy
Applying: mm: add strictlimit knob
Merging akpm/master (61f8b38204b0 mm: add strictlimit knob)

--Sig_/uwI4ThG5mbDIS=1.x4scBAk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdHFLAAoJEMDTa8Ir7ZwVsNwQAIAmOXpcHihHFgv7UNAmcxVR
RaJ49xnAKALdl4W9BGzQPLlHIvYAXlg7qt8pKSjIXvgpMXhSx/Vl7zK5Xq3ijv2q
9h+KHg1TEc+ozcJH84v1Y2i5/y6HRZFeg4ezPq5OH0KAy/36u9nEzrG3+2hKsP3l
nme1IiKTJdgWE9ZVSi7mSD+38jo7s9F/SdoDpn4ycMy0fY4fvlWI6wS6tCa2Ypac
a1DJVnJtED20fHHV6zOFGigVe1aYOK1fNZeXZP5wJglIv/bU4N1ZNeYXYIWGdUh9
bw3F4xx6C4T7wQ1fuaaS59Bnnrzad52pp5jmXOZ1mJOI3IqG9fEr5ggIleYirLil
dnaRvb/qDQsymey2HIPXw4hIrDpfLRKD1xARIpgIVgiAKgwBcbTeGiDxq42kBwku
9YDbqMMaLiGYWi2sE5Vq03UjBkKqqTp3Ru7CaHVnx2p69ID8e76Q2UrR28UV3JvA
rcj7wkvvAJbo6lI6XbWgzGpcIH1SgYxWj5b2wkfzy+UGRRIvENPOJ6gY7gOtm/YZ
ly2hRR8DDe+bC+QEezLrHa6eUtckqmQYXRST7+7S+fIK+c9Yhb9/vv9KQ3W7vJPp
fzAxaSu8b0ovfPmDPSFBXTYnbbz99caVQFDk7OofV5A8ZVi9xev0PH1RnXQcx2RO
ATOPTOJGgKMEcNI07wDz
=3IhO
-----END PGP SIGNATURE-----

--Sig_/uwI4ThG5mbDIS=1.x4scBAk--
