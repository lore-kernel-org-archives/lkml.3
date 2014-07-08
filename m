Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaGHG7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 02:59:21 -0400
Received: from ozlabs.org ([103.22.144.67]:52208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaGHG7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 02:59:16 -0400
Date: Tue, 8 Jul 2014 16:59:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jul 8
Message-ID: <20140708165908.39dad0d8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/shATnSHx+I/Eg_xiXXVIlrQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/shATnSHx+I/Eg_xiXXVIlrQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140707:

My fixes tree contains:
	powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

The net tree still had its build failure for which I reverted a commit.

The regulator tree gained a build failure so I used the version from
next-20140707.

The iommu tree gained a build failure so I used the version from
next-20140707.

The staging tree still had its build failure for which I disabled a driver.

The akpm-current tree still had its build failure for which I applied a
patch.

Non-merge commits (relative to Linus' tree): 3916
 3692 files changed, 146203 insertions(+), 190637 deletions(-)

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
Merging origin/master (448bfad8a185 Merge branch 'for-rc' of git://git.kern=
el.org/pub/scm/linux/kernel/git/rzhang/linux)
Merging fixes/master (b8accbbce667 powerpc: Disable RELOCATABLE for COMPILE=
_TEST with PPC64)
Merging kbuild-current/rc-fixes (c79624c1a698 kbuild: Fix packaging targets=
 with relative $(srctree))
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (9a2c33a422d6 ARM: l2c: fix revision checking)
Merging m68k-current/for-linus (e8d6dc5ad26e m68k/hp300: Convert printk to =
pr_foo())
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (6663a4fa6711 powerpc: Don't skip ePAPR spin-ta=
ble CPUs)
Merging sparc/master (894e552cfaa3 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging net/master (68b7107b6298 ipv4: icmp: Fix pMTU handling for rare cas=
e)
$ git am -3 ../patches/0001-Revert-net-stmmac-add-platform-init-exit-for-Al=
tera-.patch
Applying: Revert "net: stmmac: add platform init/exit for Altera's ARM socf=
pga"
Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
Merging sound-current/for-linus (525549d7342f ALSA: hda: Fix build warning)
Merging pci-current/for-linus (bf177a1eb6d1 MAINTAINERS: Update mx6 PCI dri=
ver maintainer's email)
Merging wireless/master (2c4db12ec469 rt2800usb: Don't perform DMA from sta=
ck)
Merging driver-core.current/driver-core-linus (cd3de83f1476 Linux 3.16-rc4)
Merging tty.current/tty-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging usb.current/usb-linus (e4adcff09ca3 usb: chipidea: udc: delete td f=
rom req's td list at ep_dequeue)
Merging usb-gadget-fixes/fixes (8035691365b8 usb: musb: dsps: fix the base =
address for accessing the mode register)
Merging usb-serial-fixes/usb-linus (3d28bd840b2d usb: option: Add ID for Te=
lewell TW-LTE 4G v2)
Merging staging.current/staging-linus (6b64168de843 Merge tag 'iio-fixes-fo=
r-3.16b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging input-current/for-linus (31972f6e517d Input: ti_am335x_tsc - warn a=
bout incorrect spelling)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (cfe82d4f45c7 crypto: sha512_ssse3 - fix byte=
 count to bit count conversion)
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
Merging drm-intel-fixes/for-linux-next-fixes (ad952a8f0cb9 drm/i915: Don't =
clobber the GTT when it's within stolen memory)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (4c834452aad0 Linux 3.16-rc3)
Merging arm/for-next (588601ec693e Merge branches 'fixes' and 'misc' into f=
or-next)
Merging arm-perf/for-next/perf (037e79aa958d arm: perf: krait: stop using s=
ingleton PMU)
CONFLICT (content): Merge conflict in arch/arm/kernel/perf_event_cpu.c
Merging arm-soc/for-next (29720ffb93f1 arm-soc: document merges)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (3a426a906aac Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (121d24bab476 Merge branch 'mvebu/fixes' into mvebu/=
for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/headsmp-a9.S
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/Kconfig
Merging renesas/next (d29413991478 Merge branches 'heads/dt-for-v3.17' and =
'soc-for-v3.17' into next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/headsmp.S
Merging samsung/for-next (b468ba0ec8e1 Merge branch 'v3.17-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (a2aa371b1d53 Merge branches 'sunxi/dt-for-3.1=
7' and 'sunxi/clocks-for-3.17' into sunxi/for-next)
Merging tegra/for-next (545617fb69e4 Merge branch for-3.17/defconfig into f=
or-next)
Merging arm64/for-next/core (a497c3ba1d97 Linux 3.16-rc2)
Merging blackfin/for-linus (51fdc6bf9880 blackfin: defconfigs: add MTD_SPI_=
NOR (new dependency for M25P80))
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (f4ea0a48c63e m68k/sun3: Remove define statement no l=
onger needed)
Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prot=
otype for kobjsize())
Merging metag/for-next (8bc613befaec metag: hugetlbpage: Remove null pointe=
r checks that could never happen)
Merging microblaze/next (225fba216261 microblaze: Fix typo in head.S s/subs=
tract/subtract/)
Merging mips/mips-for-linux-next (de3d02f3906d Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (68986c9f0f45 Revert "offb: Add palette hack for littl=
e endian")
Merging fsl/next (cd1154770ba9 powerpc/85xx: drop hypervisor specific board=
 compatibles)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (c60d0baa40f9 s390/3270: correct size detection with =
the read-partition command)
Merging sparc-next/master (894e552cfaa3 Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging tile/master (8dfb6948f7d8 tile: use ARRAY_SIZE)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (c7548af69d9e Btrfs: convert smp_mb__{before,after}_clea=
r_bit)
Merging ceph/master (437f2c0d0c01 rbd: fix ida/idr memory leak)
Merging cifs/for-next (4b26c7b1fc36 cifs: Split lanman auth from CIFS_SessS=
etup())
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (27199b15e4f0 ecryptfs: Remove unnecessary include of=
 syscall.h in keystore.c)
Merging ext3/for_next (19ef1229bc2e reiserfs: Fix compilation breakage with=
 CONFIG_REISERFS_CHECK)
Merging ext4/dev (14b02deff1ae [regression] fix 32-bit breakage in block de=
vice read(2))
Merging f2fs/dev (a4e3519092d0 f2fs: check bdi->dirty_exceeded when trying =
to skip data writes)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (c55a01d360af fuse: avoid scheduling while atomic)
Merging gfs2/master (c04d5ee35ba6 GFS2: fs/gfs2/rgrp.c: kernel-doc warning =
fixes)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (2fc193cf924e SUNRPC: Handle EPIPE in xprt_connect_s=
tatus)
Merging nfsd/nfsd-next (412b72a56aff nfsd: Convert nfs4_check_open_reclaim(=
) to work with lookup_clientid())
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (e9110361a9a4 UBI: fix the volumes tree sorting cr=
iteria)
Merging xfs/for-next (2451337dd043 xfs: global error sign conversion)
Merging file-private-locks/linux-next (a497c3ba1d97 Linux 3.16-rc2)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging pci/next (7171511eaec5 Linux 3.16-rc1)
Merging hid/for-next (1d259fbdd1dc Merge branch 'for-3.17/cp2112' into for-=
next)
Merging i2c/i2c/for-next (2fd6cf0523fc i2c: taos-evm: Use module_serio_driv=
er())
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (0b06e14a229c hwmon: (pmbus) Add tps40422 =
front-end driver)
Merging v4l-dvb/master (ac35b35b30aa Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (6296fcc8a669 Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (4e0449c81db9 Merge branch 'for-3.17' into for-next)
Merging pm/linux-next (b4031d7b095f Merge branch 'acpi-pnp')
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (b6902baa1fab Merge branch 'for-rc' of .git into next)
Merging ieee1394/for-next (165d560bb267 Merge branch 'master' into for-next)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (d1a792f3b407 Update imx-sdma cyclic handling to rep=
ort residue)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (0b88e7042a22 Merge branch 'tlan-next')
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (f473832fece1 bcma: add driver for PCIe Gen 2 =
core)
Merging bluetooth/master (a70f4b5f14a0 Bluetooth: Don't try background scan=
ning if LE is not enabled)
Merging infiniband/for-next (eeaddf3670d4 Merge branches 'core', 'cxgb3', '=
cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 's=
rp' and 'usnic' into for-next)
Merging mtd/master (6938ad40cb97 mtd: devices: elm: fix elm_context_save() =
and elm_context_restore() functions)
Merging l2-mtd/master (89384f646287 mtd: phram: replace kmalloc/strcpy by k=
strdup)
Merging crypto/master (f2c89a10de4f crypto: drbg - Use Kconfig to ensure at=
 least one RNG option is set)
Merging drm/drm-next (bc1dfff04a5d Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-panel/drm/panel/for-next (7e40b5162b3c drm/panel: make DRM_PANE=
L_LD9040 depend on SPI)
Merging drm-intel/for-linux-next (f7d2323c181e drm/i915: correct BLC vs PWM=
 enable/disable ordering)
Merging drm-tegra/drm/tegra/for-next (1f64ae7c5af0 drm/tegra: sor - Remove =
obsolete comment)
Merging sound/for-next (549d87823564 ALSA: hda - Add several entries for en=
abling HP mute led)
Merging sound-asoc/for-next (e31272c0727d Merge remote-tracking branches 'a=
soc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_=
add_sgs(... GFP_NOIO) holding spinlock.)
Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return f=
rom mxt_get_bootloader_version)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (49b3f10e2cf5 Merge branch 'for-3.17/core' into for-=
next)
Merging device-mapper/for-next (cbc228137bbf dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (9f98586a0b9d mmc: sdhci: avoid double-delay while tran=
sitioning to 1.8V)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (133d4527eab8 md: flush writes before starting a recove=
ry.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (53a1cf27c450 mfd: cros_ec: Use the proper size=
 when looking at the cros_ec_i2c result)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (b1f46dd1079d video: clps711x: Fix sparse warnin=
gs)
Merging regulator/for-next (4244cbc4ed47 Merge remote-tracking branches 're=
gulator/topic/tps65218', 'regulator/topic/tps6586x' and 'regulator/topic/tw=
l' into regulator-next)
$ git reset --hard HEAD^
Merging next-20140707 version of regulator
Merging security/next (f01387d26938 Merge commit 'v3.15' into next)
Merging integrity/next (a0f9fd9d6d8a ima: define '.ima' as a builtin 'trust=
ed' keyring)
Merging selinux/next (615e51fdda6f selinux: reduce the number of calls to s=
ynchronize_net() when flushing caches)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (7171511eaec5 Linux 3.16-rc1)
Merging iommu/next (355c27cab0f8 Merge branches 'iommu/fixes', 'x86/vt-d', =
'arm/omap', 'ppc/pamu' and 'core' into next)
$ git reset --hard HEAD^
Merging next-20140707 version of iommu
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt c=
ount)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (d31e373d0778 irq-gic: remove file name from headi=
ng comment)
CONFLICT (content): Merge conflict in arch/arm/mach-msm/Kconfig
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
Merging spi/for-next (f83f69de66d3 Merge remote-tracking branch 'spi/topic/=
rspi' into spi-next)
Merging tip/auto-latest (ae072dca7a35 Merge branch 'locking/core')
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (7ee40b897d18 ie31200_edac: Introduce the driver)
Merging irqchip/irqchip/for-next (885d078bfe92 Merge branch 'irqchip/crossb=
ar' into irqchip/core)
Merging ftrace/for-next (099ed151675c tracing: Remove ftrace_stop/start() f=
rom reading the trace file)
Merging rcu/rcu/next (cd4775e7e74c rcu: Change rcu_dereference_check(c) to =
check "c" first)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (9f6226a762c7 arch: x86: kvm: x86.c: Cleaning up var=
iable is set more than once)
Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support =
for Cortex-A53)
Merging kvm-ppc/kvm-ppc-next (c387936a9386 KVM: PPC: Book3S: Move vcore def=
inition to end of kvm_arch struct)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (77945ca73e9a x86/xen: map foreign pfns for auto=
translated guests)
Merging percpu/for-next (a46e532a9145 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging workqueues/for-next (51cb2603aed0 Merge branch 'for-3.16-fixes' int=
o for-next)
CONFLICT (content): Merge conflict in kernel/workqueue.c
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (cd3de83f1476 Linux 3.16-rc4)
Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module re=
fcounting)
Merging leds/for-next (7e7743901b53 leds:pca963x: Update for PCA9635 and co=
rrect statement about MODE2 OUTDRV default)
CONFLICT (add/add): Merge conflict in drivers/hid/hid-gt683r.c
Merging driver-core/driver-core-next (64c720add08e Merge 3.16-rc4 into driv=
er-core-next)
Merging tty/tty-next (a497c3ba1d97 Linux 3.16-rc2)
Merging usb/usb-next (d6759133e981 usb: xhci: Correct last context entry ca=
lculation for Configure Endpoint)
Merging usb-gadget/next (527b570c8427 usb: gadget: s3c2410: Move to clk_pre=
pare_enable/clk_disable_unprepare)
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_cppi41.c
Merging usb-serial/usb-next (5bc9e5933a41 USB: kl5kusb105: Remove klsi_105_=
tiocmset function)
Merging staging/staging-next (14b596c9d80b staging: cxt1e1: remove driver)
Applying: staging: board: disable
Merging char-misc/char-misc-next (6b5fa7760835 w1: select crc16 library for=
 ds2406)
CONFLICT (content): Merge conflict in drivers/w1/masters/mxc_w1.c
Merging cgroup/for-next (76bb5ab8f6e3 cpuset: break kernfs active protectio=
n in cpuset_write_resmask())
Merging scsi/for-next (eed78c36555c Merge remote-tracking branch 'scsi-queu=
e/core-for-3.17' into for-next)
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
Merging pinctrl/for-next (b637046d3e9a Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (ad19d116bc16 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (39fd3f99aba3 pwm: fsl-ftm: set pwm_chip can_sleep fla=
g)
Merging dma-buf/for-next (dfb945473ae8 Merge git://www.linux-watchdog.org/l=
inux-watchdog)
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
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (855ef0dec727 aio: kill the misleading rcu read locks in=
 ioctx_add_table() and kill_ioctx())
Merging llvmlinux/for-next (f9da455b93f6 Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/davem/net-next)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (f2cd9cedff78 This patch fixed spelling typo in vari=
ous template files within Documentation/Docbook.)
Merging akpm-current/current (0ffdd21bf650 fs/dlm/debug_fs.c: remove unnece=
ssary null test before debugfs_remove)
CONFLICT (content): Merge conflict in mm/shmem.c
Applying: purgatory: run host built programs from objtree
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
Applying: net/sunrpc: replace strict_strto calls
Applying: drivers/staging/emxx_udc/emxx_udc.c: replace strict_strto() with =
kstrto()
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
Applying: kernel/kprobes.c: convert printk to pr_foo()
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
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (265627ba259a mm: add strictlimit knob)

--Sig_/shATnSHx+I/Eg_xiXXVIlrQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTu5bBAAoJEMDTa8Ir7ZwVfywP+QHLwf1XJaxTB+KZhPuNJF3P
ruVvdPiJM3Ww4Mu4wk1HC2DZk+TDz7rw1yvduNCS2gGF3dM7H4zUX/UBHzWNnZ7s
xeP5uQ6bBfr0z9Nk2r6eOnASc+Oa0/49XjYywZLdl60LfQUIPKdMLXs3xOjUn3e3
dd/X/mp2DhceP1IfqsJT7jfzW98DSQjYEdoR07J3vVqnJfmmFV5RzL/pPZ3jwkkR
R5XntB1XUZpelIB0rgV5Jmq+XpfrKg4WogodMivwRlZK7AXHdSxfFT4AMzQlzXi2
LRU+HBW2vg/OK6ghQci4qH4KcxJOaW6OmZtXfjhfCkr6y4mCiEp94pa3XxwL/04p
jQ64ydPfsEpBKTAHDmlPyny3ELm2ouYyZtC67KbU03t0jxpkkLy9XpaaNNoqtDjQ
pn0quLRK8baYEuJNRRwq8fJSd00bdiI8XGJWw/127i7LeexlovJsvaZcB0gD0Vj8
GTAnkXp4Bn4aM3Ujmxz715WAKuVpFWqgT/FWLtL0uA8rwjXDYnCD8gOYglmkP0pk
VmPun0p7YvO57LOCB64WHvdudLWffV63e6divu6cLfMvwtmwc9izjvNWS5vB4heL
tdoc8uc5vYPUnux/cFpie/ZKtJ1wJPPS+KhWc5nQDND/SRMOd4rr009gJ8/iPQdX
PlzkZPZQrKVdD+iomkIa
=TBVs
-----END PGP SIGNATURE-----

--Sig_/shATnSHx+I/Eg_xiXXVIlrQ--
