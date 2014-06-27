Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaF0FMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:12:32 -0400
Received: from ozlabs.org ([103.22.144.67]:34937 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaF0FM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:12:28 -0400
Date: Fri, 27 Jun 2014 15:12:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jun 27
Message-ID: <20140627151219.72447408@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.oxs/KeqBUPUcjwVXTZWsJX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.oxs/KeqBUPUcjwVXTZWsJX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Changes since 20140626:

New tree: usb-serial-fixes

The staging tree still had its build failure for which I disabled a driver.

The akpm-current tree its build failure (I applied a supplied patch).

Non-merge commits (relative to Linus' tree): 2430
 2378 files changed, 96549 insertions(+), 64800 deletions(-)

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
Merging origin/master (3493860c76eb Merge branch 'for-linus' of git://git.k=
ernel.dk/linux-block)
Merging fixes/master (4b660a7f5c80 Linux 3.15-rc6)
Merging kbuild-current/rc-fixes (c14105628b2e kbuild: fix a typo in a kbuil=
d document)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (b8d8772e53f8 ARM: arm925: ensure assembly sets u=
p writethrough mapping)
Merging m68k-current/for-linus (e8d6dc5ad26e m68k/hp300: Convert printk to =
pr_foo())
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (6663a4fa6711 powerpc: Don't skip ePAPR spin-ta=
ble CPUs)
Merging sparc/master (894e552cfaa3 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging net/master (d7933ab727ed Merge branch 'for-next' of git://git.samba=
.org/sfrench/cifs-2.6)
Merging ipsec/master (d7933ab727ed Merge branch 'for-next' of git://git.sam=
ba.org/sfrench/cifs-2.6)
Merging sound-current/for-linus (a07187c992be ALSA: hda - restore BCLK M/N =
values when resuming HSW/BDW display controller)
Merging pci-current/for-linus (d066c946a866 PCI: Fix unaligned access in AF=
 transaction pending test)
Merging wireless/master (e055a6e20a91 Merge branch 'ath-current' of git://g=
ithub.com/kvalo/ath)
Merging driver-core.current/driver-core-linus (206204a1162b lz4: ensure len=
gth does not wrap)
Merging tty.current/tty-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging usb.current/usb-linus (d6236f6d1d88 xhci: Fix runtime suspended xhc=
i from blocking system suspend.)
Merging usb-gadget-fixes/fixes (5d881802c407 usb: musb: core: Handle Babble=
 condition only in HOST mode)
Merging usb-serial-fixes/usb-linus (660856948664 MAINTAINERS: update e-mail=
 address)
Merging staging.current/staging-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging char-misc.current/char-misc-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging input-current/for-linus (31972f6e517d Input: ti_am335x_tsc - warn a=
bout incorrect spelling)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (cfe82d4f45c7 crypto: sha512_ssse3 - fix byte=
 count to bit count conversion)
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
Merging drm-intel-fixes/for-linux-next-fixes (8525a235c96a drm/i915: vlv_pr=
epare_pll is only needed in case of non DSI interfaces)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (2328af0c9ce8 ARC: [SMP] Enable icache coherency)
Merging arm/for-next (8b1f8b93f8f0 Merge branches 'fixes' and 'misc' into f=
or-next)
Merging arm-perf/for-next/perf (7171511eaec5 Linux 3.16-rc1)
Merging arm-soc/for-next (6c9d16178870 Merge tag 'at91-fixes' of git://gith=
ub.com/at91linux/linux-at91 into fixes)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (7b087756e28d Merge branch 'imx/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/Kconfig
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (2507b1f9c167 Merge branch 'mvebu/soc' into mvebu/fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/Kconfig
Merging renesas/next (1d8fd178f76d Merge branches 'heads/defconfig-for-v3.1=
7', 'r8a7779-multiplatform-for-v3.17', 'soc-for-v3.17' and 'soc-cleanup-for=
-v3.17' into next)
Merging samsung/for-next (053341b6993a Merge branch 'v3.16-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (e4b376f6d565 Merge branches 'sunxi/dt-for-3.1=
7' and 'sunxi/core-for-3.17' into sunxi-next)
Merging tegra/for-next (88a67395a38a Merge branch for-3.17/defconfig into f=
or-next)
Merging arm64/for-next/core (e3a920afc348 arm64: mm: remove broken &=3D ope=
rator from pmd_mknotpresent)
Merging blackfin/for-linus (51fdc6bf9880 blackfin: defconfigs: add MTD_SPI_=
NOR (new dependency for M25P80))
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (e8d6dc5ad26e m68k/hp300: Convert printk to pr_foo())
Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prot=
otype for kobjsize())
Merging metag/for-next (8bc613befaec metag: hugetlbpage: Remove null pointe=
r checks that could never happen)
Merging microblaze/next (225fba216261 microblaze: Fix typo in head.S s/subs=
tract/subtract/)
Merging mips/mips-for-linux-next (763fec3290bd Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (68986c9f0f45 Revert "offb: Add palette hack for littl=
e endian")
Merging fsl/next (087dfae3fe3f powerpc/8xx: Remove empty asm/mpc8xx.h)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (fa73eb4738fc s390/ccwgroup: use ccwgroup_ungroup wra=
pper)
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
Merging cifs/for-next (6642176bf490 cifs: replace code with free_rsp_buf())
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (19ef1229bc2e reiserfs: Fix compilation breakage with=
 CONFIG_REISERFS_CHECK)
Merging ext4/dev (14b02deff1ae [regression] fix 32-bit breakage in block de=
vice read(2))
Merging f2fs/dev (3a6a95d26cbb f2fs: reduce region of f2fs_lock_op covered =
for better concurrency)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
Merging gfs2/master (7b596840397a GFS2: Allow caching of glocks for flock)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (f15b5041440c FS/NFS: replace count*size kzalloc by =
kcalloc)
Merging nfsd/nfsd-next (a497c3ba1d97 Linux 3.16-rc2)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (380347e9ca76 UBIFS: Add an assertion for clean_zn=
_cnt)
Merging xfs/for-next (2451337dd043 xfs: global error sign conversion)
Merging file-private-locks/linux-next (a497c3ba1d97 Linux 3.16-rc2)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging pci/next (7171511eaec5 Linux 3.16-rc1)
Merging hid/for-next (acd059277df1 Merge branch 'for-3.17/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (f0b1f6442b50 Merge tag 'v3.16-rc1' into i2c/for-n=
ext)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (f719604dd06f hwmon: (lm63) Fix smatch war=
nings)
Merging v4l-dvb/master (ac35b35b30aa Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (bfbf2e950ac8 Merge branch 'kbuild/rc-fixes' into k=
build/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (2e83f386e2c9 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging pm/linux-next (3d181c42eda5 Merge branch 'acpica' into linux-next)
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (a497c3ba1d97 Linux 3.16-rc2)
Merging ieee1394/for-next (165d560bb267 Merge branch 'master' into for-next)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (7171511eaec5 Linux 3.16-rc1)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (9b8d90b963dc Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
Merging ipsec-next/master (644a918d2033 enic: Make dummy rfs functions inli=
ne to fix !CONFIG_RFS_ACCEL build)
Merging wireless-next/master (c64800e772a0 wireless: mwifiex: Use the prope=
r interfaces)
Merging bluetooth/master (6fd7571c3097 Bluetooth: Use macro instead of hard=
-coded value)
CONFLICT (content): Merge conflict in net/bluetooth/smp.c
CONFLICT (content): Merge conflict in net/bluetooth/hci_conn.c
Merging infiniband/for-next (eeaddf3670d4 Merge branches 'core', 'cxgb3', '=
cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 's=
rp' and 'usnic' into for-next)
Merging mtd/master (7171511eaec5 Linux 3.16-rc1)
Merging l2-mtd/master (7171511eaec5 Linux 3.16-rc1)
Merging crypto/master (8f312d64b5ee crypto: qat - Fix error path crash when=
 no firmware is present)
Merging drm/drm-next (bc1dfff04a5d Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-panel/drm/panel/for-next (7e40b5162b3c drm/panel: make DRM_PANE=
L_LD9040 depend on SPI)
Merging drm-intel/for-linux-next (91565c85b66d drm/i915: Don't try to look =
up object for non-existent fb)
Merging drm-tegra/drm/tegra/for-next (1f64ae7c5af0 drm/tegra: sor - Remove =
obsolete comment)
Merging sound/for-next (7e9c2eb62642 Merge branch 'for-linus' into for-next)
Merging sound-asoc/for-next (6158518db522 Merge remote-tracking branches 'a=
soc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-next)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_=
add_sgs(... GFP_NOIO) holding spinlock.)
Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return f=
rom mxt_get_bootloader_version)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (8e3c77637c65 Merge branch 'for-linus' into for-next)
Merging device-mapper/for-next (1e0a66aef542 Merge branch 'for-3.16-rcX' in=
to for-next)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (9ed6566b6c2a mmc: sdhci: Remove blank line)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (053f5b6525ae raid5: speedup sync_request processing)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (591123e5d6fd mfd: sec-core: Prepare regulators=
 for suspend state to reduce power-consumption)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (8ca900e16b2b drivers/video/fbdev/sis: Add missi=
ng else)
Merging regulator/for-next (ac034a192ea0 Merge remote-tracking branches 're=
gulator/topic/mc13xxx', 'regulator/topic/palmas' and 'regulator/topic/tps65=
86x' into regulator-next)
Merging security/next (f01387d26938 Merge commit 'v3.15' into next)
Merging integrity/next (0430e49b6e7c ima: introduce ima_kernel_read())
Merging selinux/next (f31e79945965 selinux: no recursive read_lock of polic=
y_rwlock in security_genfs_sid())
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (7171511eaec5 Linux 3.16-rc1)
Merging iommu/next (d73a6d722a67 iommu/amd: Fix small race between invalida=
te_range_end/start)
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
Merging spi/for-next (00f2075d987a Merge remote-tracking branches 'spi/topi=
c/orion', 'spi/topic/qup', 'spi/topic/rspi' and 'spi/topic/sh-msiof' into s=
pi-next)
Merging tip/auto-latest (35299db412b6 Merge branch 'x86/xsave')
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (6866b390562b EDAC, edac_module.c: Remove unneces=
sary test on unsigned value)
Merging irqchip/irqchip/for-next (ca446397462a Merge branch 'irqchip/urgent=
' into irqchip/for-next)
Merging ftrace/for-next (4d4c9cc839a3 tracing: Add __field_struct macro for=
 TRACE_EVENT())
Merging rcu/rcu/next (9c3d3e55d9d6 rcu: Fix a sparse warning in rcu_report_=
unblock_qs_rnp())
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (27e6fb5dae28 KVM: vmx: vmx instructions handling do=
es not consider cs.l)
Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support =
for Cortex-A53)
Merging kvm-ppc/kvm-ppc-next (5c02c392cd23 Merge tag 'virtio-next-for-linus=
' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (77945ca73e9a x86/xen: map foreign pfns for auto=
translated guests)
Merging percpu/for-next (807407c0a29b workqueue: stronger test in process_o=
ne_work())
Merging workqueues/for-next (4a9242884da5 Merge branch 'for-3.16-fixes' int=
o for-next)
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (a497c3ba1d97 Linux 3.16-rc2)
Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module re=
fcounting)
Merging leds/for-next (a497c3ba1d97 Linux 3.16-rc2)
Merging driver-core/driver-core-next (c9d53c0f2d23 devres: remove devm_requ=
est_and_ioremap())
Merging tty/tty-next (a497c3ba1d97 Linux 3.16-rc2)
Merging usb/usb-next (d6759133e981 usb: xhci: Correct last context entry ca=
lculation for Configure Endpoint)
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
Merging usb-serial/usb-next (a497c3ba1d97 Linux 3.16-rc2)
Merging staging/staging-next (0b913529c783 staging: lustre: fix sparse warn=
ings for static symbols)
Applying: staging: board: disable
Merging char-misc/char-misc-next (6b5fa7760835 w1: select crc16 library for=
 ds2406)
CONFLICT (content): Merge conflict in drivers/w1/masters/mxc_w1.c
Merging cgroup/for-next (391acf970d21 cpuset,mempolicy: fix sleeping functi=
on called from invalid context)
Merging scsi/for-next (eed78c36555c Merge remote-tracking branch 'scsi-queu=
e/core-for-3.17' into for-next)
Merging scsi-core/core-for-3.16 (7bafc240e126 scsi: use the scsi data buffe=
r length to extract transfer size)
Merging scsi-drivers/drivers-for-3.16 (8faeb529b2da virtio-scsi: fix variou=
s bad behavior on aborted requests)
Merging target-updates/for-next (0ed6e189e3f6 target: Fix NULL pointer dere=
ference for XCOPY in target_put_sess_cmd)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (4aba0a02ff80 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (0fb394122af4 gpio: pxa: Make of_device_id array cons=
t)
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
Merging clk/clk-next (27b8d5f723e6 clk: flatten clk tree in debugfs)
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
Merging rd-docs/master (93df5e1c88f7 These days most people use git to send=
 patches so I have added a section about that.)
Merging akpm-current/current (3e854aac314c lib/scatterlist: clean up useles=
s architecture versions of scatterlist.h)
Applying: printk-allow-increasing-the-ring-buffer-depending-on-the-number-o=
f-cpus-fix
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
Merging akpm/master (eaef71b00483 mm: add strictlimit knob)

--Sig_/.oxs/KeqBUPUcjwVXTZWsJX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTrP05AAoJEMDTa8Ir7ZwVWAAP/iHgn2huIXWydsHO97e8B1pI
BvEUaYVDBLBJaRdj4IydZuKvjNjMfbAedvdTg65/ZhbahOJifqpkrWiigzaMEd7X
OEhlxF/F5LYRiBd4zuvz+Nne1groyMwAkKickLSAUBkGz5awqcdVAAwsla5cvjSl
6Y5ioq0ZAxxH/lh4EoLkzc6WYorPDMUyJPk0Fm3P9VvqIRXr5fqt3BH343D3cABx
+kI1ItmTGZ6eWvYPVi9435YE7jO7OAuXmwb1Axz/00spBoiGKTj5WxsuJKYQPoS8
dXmeZ8lcALDQMxjc+yh2O4YowaVKJbeiYrCLgM7b9Xix1p7iXzsBVM5LnP4cRQpa
YnAccc2BNSGKtLqr/uzBz8Jk4e0T4KhgzhglELXgnT+xEuWK3e8d+9gT3yMfZ6Ac
Y7Isyf+VwztTVVwDzlnwTTWp5BshNgQ08NqeJW77eQwZbQGSy4Y10koiQ4uh8G7P
oTXhJWmLzD02jf5JR8bu6PdbgNn2QgoqqdPn3q9wq71X6RwDoOwBTRj3AAmzlTVx
ibJOCZy9ZGX/yhZx+ILiXcIWZqaiAEJ+R8zLKS3JPf/eegsK0VF2MjWDuXICSsiM
dwSbINyXGWnjLJIRHDOlJ/CCnOveD4YtatSd6U6g3FXtYCzhh1T00yufxzYBDouQ
iWowMmb4wTcesxiQ51ED
=vUIy
-----END PGP SIGNATURE-----

--Sig_/.oxs/KeqBUPUcjwVXTZWsJX--
