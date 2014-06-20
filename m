Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaFTFgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:36:25 -0400
Received: from ozlabs.org ([103.22.144.67]:60284 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbaFTFgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:36:21 -0400
Date: Fri, 20 Jun 2014 15:36:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jun 20
Message-ID: <20140620153604.08c2490f@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wePNCO/sf/vkP_nzLop_s9H"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wePNCO/sf/vkP_nzLop_s9H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Changes since 20140619:

The mfd-lj tree lost its build failure.

The staging tree gained a build failure for which I disabled a driver.

The akpm-current tree gained a build failure for which I reverted some
commits.

Non-merge commits (relative to Linus' tree): 1729
 1581 files changed, 51622 insertions(+), 28729 deletions(-)

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
Merging origin/master (894e552cfaa3 Merge branch 'for-linus' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging fixes/master (4b660a7f5c80 Linux 3.15-rc6)
Merging kbuild-current/rc-fixes (c14105628b2e kbuild: fix a typo in a kbuil=
d document)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (6a78371acebf ARM: perf: fix compiler warning wit=
h gcc 4.6.4 (and tidy code))
Merging m68k-current/for-linus (e8d6dc5ad26e m68k/hp300: Convert printk to =
pr_foo())
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (68986c9f0f45 Revert "offb: Add palette hack fo=
r little endian")
Merging sparc/master (8ecc1bad4c9b sparc64: fix format string mismatch in a=
rch/sparc/kernel/sysfs.c)
Merging net/master (6f9a093b66ce net: filter: fix upper BPF instruction lim=
it)
Merging ipsec/master (7171511eaec5 Linux 3.16-rc1)
Merging sound-current/for-linus (8d42fda9ea98 Merge branch 'topic/core-vuln=
-fixes' into for-linus)
Merging pci-current/for-linus (d066c946a866 PCI: Fix unaligned access in AF=
 transaction pending test)
Merging wireless/master (616a8394b5df rt2x00: fix rfkill regression on rt25=
00pci)
Merging driver-core.current/driver-core-linus (7171511eaec5 Linux 3.16-rc1)
Merging tty.current/tty-linus (60efcf0414be tty/serial: fix 8250 early cons=
ole option passing to regular console)
Merging usb.current/usb-linus (32b36eeae6a8 USB: usbtest: add a timeout for=
 scatter-gather tests)
Merging usb-gadget-fixes/fixes (5d881802c407 usb: musb: core: Handle Babble=
 condition only in HOST mode)
Merging staging.current/staging-linus (88513624be04 staging: comedi: addi_a=
pci_1564: add addi_watchdog dependency)
Merging char-misc.current/char-misc-linus (b29f680c4fe3 Revert "uio: fix vm=
a io range check in mmap")
Merging input-current/for-linus (31972f6e517d Input: ti_am335x_tsc - warn a=
bout incorrect spelling)
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
Merging drm-intel-fixes/for-linux-next-fixes (4a11e398b39b drm/i915: cache =
hw power well enabled state)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (230a15f171ba ARC: remove checks for CONFIG_ARC_MMU_V4)
Merging arm/for-next (85ca7a934873 Merge branches 'fixes' and 'misc' into f=
or-next)
Merging arm-perf/for-next/perf (7171511eaec5 Linux 3.16-rc1)
Merging arm-soc/for-next (f2592714cddc ARM: use menuconfig for sub-arch men=
us)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (1bee3d4b1624 Merge branch 'imx/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/Kconfig
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (7171511eaec5 Linux 3.16-rc1)
Merging renesas/next (44751c65eb0a Merge branch 'soc-cleanup-for-v3.17' int=
o devel)
Merging samsung/for-next (c0c3c3590d0d ARM: EXYNOS: fix pm code to check fo=
r cortex A9 rather than the SoC)
Merging tegra/for-next (3236c55e33e9 Merge branch for-3.17/defconfig into f=
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
Merging m68knommu/for-next (83c6bdb827c9 m68knommu: Implement gpio support =
for m54xx.)
Merging metag/for-next (8bc613befaec metag: hugetlbpage: Remove null pointe=
r checks that could never happen)
Merging microblaze/next (225fba216261 microblaze: Fix typo in head.S s/subs=
tract/subtract/)
Merging mips/mips-for-linux-next (2879f1360851 Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (68986c9f0f45 Revert "offb: Add palette hack for littl=
e endian")
Merging fsl/next (e83eb028bb98 powerpc/fsl: Add fsl,portid-mapping to coren=
et1-cf chips)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (fa73eb4738fc s390/ccwgroup: use ccwgroup_ungroup wra=
pper)
Merging sparc-next/master (311b8935ad4e Merge branch 'sparc_sparse_fixes')
Merging tile/master (8dfb6948f7d8 tile: use ARRAY_SIZE)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (8c76c188d498 unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (c7548af69d9e Btrfs: convert smp_mb__{before,after}_clea=
r_bit)
Merging ceph/master (437f2c0d0c01 rbd: fix ida/idr memory leak)
Merging cifs/for-next (08bc03539d38 cifs: revalidate mapping prior to satis=
fying read_iter request with cache=3Dloose)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (19ef1229bc2e reiserfs: Fix compilation breakage with=
 CONFIG_REISERFS_CHECK)
Merging ext4/dev (f8409abdc592 Merge tag 'ext4_for_linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging f2fs/dev (395fd9094524 f2fs: avoid to truncate non-updated page par=
tially)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
Merging gfs2/master (0e48e055a7df GFS2: Prevent recovery before the local j=
ournal is set)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (886023c676af NFSv4: test SECINFO RPC_AUTH_GSS pseud=
oflavors for support)
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
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging pci/next (7171511eaec5 Linux 3.16-rc1)
Merging hid/for-next (8e4cfb08c532 Merge branch 'for-3.17/hid-gt683r' into =
for-next)
Merging i2c/i2c/for-next (f0b1f6442b50 Merge tag 'v3.16-rc1' into i2c/for-n=
ext)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (2a3c653051b1 hwmon: (gpio-fan) Convert to=
 devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (656111f4b9cb Merge branch 'topic/omap3isp' into to_=
next)
Merging kbuild/for-next (bfbf2e950ac8 Merge branch 'kbuild/rc-fixes' into k=
build/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (2e83f386e2c9 Merge branch 'for-3.16-fixes' into fo=
r-next)
Merging pm/linux-next (85e1ab79ec13 Merge branch 'pm-cpuidle' into linux-ne=
xt)
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
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (7171511eaec5 Linux 3.16-rc1)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (e0f802fbcaa3 tcp: move ir_mark initialization to t=
cp_openreq_init)
Merging ipsec-next/master (7171511eaec5 Linux 3.16-rc1)
Merging wireless-next/master (2e91606f5e1e PCMCIA_HERMES: ioport_map/unmap =
relies on HAS_IOPORT_MAP)
Merging bluetooth/master (34b3b37155d8 Bluetooth: Fix checking for master L=
TKs)
CONFLICT (content): Merge conflict in net/bluetooth/smp.c
Merging infiniband/for-next (eeaddf3670d4 Merge branches 'core', 'cxgb3', '=
cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 's=
rp' and 'usnic' into for-next)
Merging mtd/master (7171511eaec5 Linux 3.16-rc1)
Merging l2-mtd/master (7171511eaec5 Linux 3.16-rc1)
Merging crypto/master (5208ed2ca165 crypto: testmgr - add aead cbc des, des=
3_ede tests)
Merging drm/drm-next (bc1dfff04a5d Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-panel/drm/panel/for-next (7e40b5162b3c drm/panel: make DRM_PANE=
L_LD9040 depend on SPI)
Merging drm-intel/for-linux-next (9c33baa6b3bb drivers/i915: Fix unnoticed =
failure of init_ring_common())
Merging drm-tegra/drm/tegra/for-next (1f64ae7c5af0 drm/tegra: sor - Remove =
obsolete comment)
Merging sound/for-next (7f0f20486f4d ALSA: Use dma_zalloc_coherent)
Merging sound-asoc/for-next (e1f422c43498 Merge remote-tracking branches 'a=
soc/topic/spdif', 'asoc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-nex=
t)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_=
add_sgs(... GFP_NOIO) holding spinlock.)
Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return f=
rom mxt_get_bootloader_version)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (a2d445d44000 block: add __init to blkcg_policy_regi=
ster)
Merging device-mapper/for-next (a27595b04b91 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (e9c729860d84 mmc: core: Fix DT documentation of eMMC h=
igh-speed DDR 1.8/1.2V bindings)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (053f5b6525ae raid5: speedup sync_request processing)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (f4fc540b6633 mfd: Add driver for Maxim 77802 P=
ower Management IC)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (7171511eaec5 Linux 3.16-rc1)
Merging regulator/for-next (b753a93f7437 Merge remote-tracking branch 'regu=
lator/topic/tps6586x' into regulator-next)
Merging security/next (2fd4e6698f08 Merge branch 'smack-for-3.16' of git://=
git.gitorious.org/smack-next/kernel into next)
Merging integrity/next (0430e49b6e7c ima: introduce ima_kernel_read())
Merging selinux/next (5c7001b84be5 SELinux: use ARRAY_SIZE)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (7171511eaec5 Linux 3.16-rc1)
Merging iommu/next (c0981b863a31 Merge branches 'iommu/fixes', 'arm/omap', =
'arm/smmu', 'arm/shmobile', 'x86/amd', 'arm/exynos', 'arm/renesas', 'ppc/pa=
mu' and 'arm/msm' into next)
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
Merging spi/for-next (0d6c97f4e585 Merge remote-tracking branches 'spi/topi=
c/cleanup' and 'spi/topic/rspi' into spi-next)
Merging tip/auto-latest (01e47cc27060 Merge branch 'x86/xsave')
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
Merging edac/linux_next (49856dc973cd sb_edac: mark MCE messages as KERN_DE=
BUG)
Merging edac-amd/for-next (aa2064d7dd35 EDAC: Fix MC scrub mode comparsion =
bug for correctable errors)
Merging irqchip/irqchip/for-next (7171511eaec5 Linux 3.16-rc1)
Merging ftrace/for-next (72fa1a896d8e tracing: syscall_regfunc() should not=
 skip kernel threads)
Merging rcu/rcu/next (61f38db3e3c0 rcu: Provide API to suppress stall warni=
ngs while sysrc runs)
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
Merging workqueues/for-next (61d0fbb4b6f7 workqueue: use "pool->cpu < 0" to=
 stand for an unbound pool)
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (7171511eaec5 Linux 3.16-rc1)
Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module re=
fcounting)
Merging leds/for-next (0c9a03b68511 leds: Remove duplicated OOM message for=
 individual driver)
Merging driver-core/driver-core-next (7171511eaec5 Linux 3.16-rc1)
Merging tty/tty-next (7171511eaec5 Linux 3.16-rc1)
Merging usb/usb-next (7171511eaec5 Linux 3.16-rc1)
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
Merging staging/staging-next (32c3f470ec7e staging: alarm-dev: Support to C=
ompile as Module)
Merging char-misc/char-misc-next (343fcb8c70d7 thunderbolt: Fix nontrivial =
endpoint devices.)
Merging cgroup/for-next (99bae5f94185 cgroup: fix broken css_has_online_chi=
ldren())
Merging scsi/for-next (11a5dc7ff2fb Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.16-2' into for-next)
Merging scsi-core/core-for-3.16 (63ff05910d96 include/scsi/osd_protocol.h: =
remove unnecessary __constant)
Merging scsi-drivers/drivers-for-3.16 (e90b25fa40a4 mvsas: Recognise device=
/subsystem 9485/9485 as 88SE9485)
Merging target-updates/for-next (0ed6e189e3f6 target: Fix NULL pointer dere=
ference for XCOPY in target_put_sess_cmd)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (4aba0a02ff80 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
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
Merging clk/clk-next (b640a6037c9e Merge tag 'sunxi-clk-for-3.16-2' of http=
s://github.com/mripard/linux into clk-next)
Merging random/dev (5458c2fecbb8 hw_random: fix sparse warning (NULL vs 0 f=
or pointer))
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (fa88b6f8803c aio: cleanup: flatten kill_ioctx())
Merging llvmlinux/for-next (f9da455b93f6 Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/davem/net-next)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (93df5e1c88f7 These days most people use git to send=
 patches so I have added a section about that.)
Applying: staging: board: disable
Merging akpm-current/current (ec11f8c81fbc lib/scatterlist: clean up useles=
s architecture versions of scatterlist.h)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: init/main.c: code clean-up
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
Applying: bio: modify __bio_add_page() to accept pages that don't start a n=
ew segment
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (24f24433598d mm: add strictlimit knob)
[master fdcd54013af6] Revert "mm, CMA: clean-up log message"
[master df2c04c68831] Revert "mm, CMA: change cma_declare_contiguous() to o=
bey coding convention"
[master 276152ec2b40] Revert "mm, CMA: clean-up CMA allocation error path"
[master 4548cd4c2703] Revert "PPC, KVM, CMA: use general CMA reserved area =
management framework"
[master 955a2337989c] Revert "CMA: generalize CMA reserved area management =
functionality"

--Sig_/wePNCO/sf/vkP_nzLop_s9H
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo8hLAAoJEMDTa8Ir7ZwV3acP/iFRWbat7BUBnwnp7gZ6EsjV
3+bHksEL4yJc3RX9AHs8cfJC+Kdza5cLwx+s2Y0++elw3JYf2a/GXVx+yGGJfmry
OYgQkAQ6Ne8yWO7PsTFkgZ8+aNkR7Peb3+n6DMRlOPZ9yvRTvRGSYvbb0WaNojCB
l0q7G4dVTEvN2UnFEgWTT8zSs8AdoHK03rTJ+Jaw+j1enP5lYSLvbWNxRHoUh0xX
DkPD/kwtA5ROX4h7wdTkQ4veCTqPjEvn3bfh/Aj03T83ySOa5q3QsH7cpfvwTaeg
HbXAUO6fTqL+LIETimprtmW3Qwda1o0ZqlPwYNSybuSTB+2ynRCdhqzE65pEC+od
ksDTOn1W6mhNItty075W8dSC2bcWobon09Md18iHzoLZv4JzH6iMXbUwh4eAzPhH
IvXmrl62NsjFLi/eyZoaEbffhiRPF4AX7TcOIRDAmGLBSsLrIbWHLYvPgYqbiRBV
p7q/p0gQjnWE4AQMqVQ+UDe1KdTHvfQ9uxk3s7i8RruJC8G+WcbiG2nTGthMH7qH
yLgS1OR0i7axcnEsS3i7x8QjAs+c4uZu0V9YN3OLNlE54WC9bFmXwXkkpCG8f/pf
W21nuTaw8L7tAhyNE+A4jLwq31fyFgylcQG7Dgt6woOM5x/7pu3cxOr0eaMCs3QE
4RLDx8cCD1vtqgzX9Adp
=uR/5
-----END PGP SIGNATURE-----

--Sig_/wePNCO/sf/vkP_nzLop_s9H--
