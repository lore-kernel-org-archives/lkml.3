Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3GIHCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:02:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33630 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3GIHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:02:05 -0400
Date: Tue, 9 Jul 2013 17:01:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jul 9
Message-Id: <20130709170155.a212513b3a95d78e404e70db@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Jul_2013_17_01_55_+1000_mQtKCLe2S_iSkpO+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jul_2013_17_01_55_+1000_mQtKCLe2S_iSkpO+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130708:

The v4l-dvb tree lost its build failure.

The tip tree gained a conflict against Linus' tree.

The akpm tree lost a patch that turned up elsewhere.

The cpuinit tree lost some patches that turned up in Linus' tree.

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
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 228 trees (counting Linus' and 31 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (d2b4a64 Merge branch 'for-linus' of git://git.infrad=
ead.org/users/vkoul/slave-dma)
Merging fixes/master (8177a9d lseek(fd, n, SEEK_END) does *not* go to eof -=
 n)
Merging kbuild-current/rc-fixes (42a0940 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arc-current/for-curr (baadb8f ARC: warn on improper stack unwind FD=
E entries)
Merging arm-current/fixes (3e0a07f ARM: 7773/1: PJ4B: Add support for errat=
a 4742)
Merging m68k-current/for-linus (767bcb4 Merge branch 'exotic-arch-fixes' in=
to for-next)
Merging powerpc-merge/merge (ea461ab powerpc/eeh: Fix fetching bus for sing=
le-dev-PE)
Merging sparc/master (c069114 mn10300: Fix include dependency in irqflags.h=
 et al.)
Merging net/master (8bb495e Linux 3.10)
Merging ipsec/master (01cb71d net_sched: restore "overhead xxx" handling)
Merging sound-current/for-linus (cd63a5f ALSA: hda - Keep halting ALC5505 D=
SP)
Merging pci-current/for-linus (65694c5 x86/PCI: Map PCI setup data with ior=
emap() so it can be in highmem)
Merging wireless/master (57bf744 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/bluetooth/bluetooth)
Merging driver-core.current/driver-core-linus (fc76a25 Merge tag 'driver-co=
re-3.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver=
-core)
Merging tty.current/tty-linus (9e895ac Linux 3.10-rc7)
Merging usb.current/usb-linus (fc76a25 Merge tag 'driver-core-3.11-rc1' of =
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging staging.current/staging-linus (fc76a25 Merge tag 'driver-core-3.11-=
rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging char-misc.current/char-misc-linus (fc76a25 Merge tag 'driver-core-3=
.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-cor=
e)
Merging input-current/for-linus (62f548d Input: cyttsp4 - use 16bit address=
 for I2C/SPI communication)
Merging md-current/for-linus (1376512 md/raid10: fix bug which causes all R=
AID10 reshapes to move no data.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (02c0241 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/herbert/crypto)
Merging ide/master (bf6b438 ide: gayle: use module_platform_driver_probe())
Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (d94ea3f irqchip: Return -EPERM f=
or reserved IRQs)
Merging devicetree-current/devicetree/merge (706b78f dtc: ensure #line dire=
ctives don't consume data from the next line)
Merging spi-current/spi/merge (0d2d0cc spi/davinci: fix module build error)
Merging gpio-current/gpio/merge (397eada gpio/omap: don't use linear domain=
 mapping for OMAP1)
Merging rr-fixes/fixes (6407d75 virtio_console: fix uapi header)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (7d13205 Linux 3.10-rc6)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (723e2b8 ARC: [TB10x] Updates for irqchip driver)
Merging arm/for-next (3c0c01a Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (642bd4e perf: ARM: Record the user-mode PC =
in the call chain.)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b028161 Merge branch 'for-3.11' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging arm64/upstream (aa729dc Merge branch 'for-next/hugepages' of git://=
git.linaro.org/people/stevecapper/linux into upstream-hugepages)
Merging blackfin/blackfin-linus (5ae89ee bfin cache: dcplb map: add 16M dcp=
lb map for BF60x)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (27d7181 Merge branch 'pstore' into next)
Merging m68k/for-next (767bcb4 Merge branch 'exotic-arch-fixes' into for-ne=
xt)
Merging m68knommu/for-next (e4aa937 Linux 3.10-rc3)
Merging metag/for-next (c20eb0f metag: move EXPORT_SYMBOL(csum_partial) to =
metag_ksyms.c)
Merging microblaze/next (c421cee microblaze: Enable KGDB in defconfig)
Merging mips/mips-for-linux-next (075a8d5 Merge branch '3.10-fixes' into mi=
ps-for-linux-next)
CONFLICT (content): Merge conflict in kernel/irq/irqdomain.c
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (c069114 mn10300: Fix include dependency in irqf=
lags.h et al.)
Merging powerpc/next (1d8b368 pstore: Add hsize argument in write_buf call =
of pstore_ftrace_call)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (dd0120d powerpc/mpc512x: enable USB support in defcon=
fig)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (2bec2ca s390/ptrace: PTRACE_TE_ABORT_RAND)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (317ddd2 Linux 3.10-rc5)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0eb5afb xtensa: remove the second argument of __bi=
o_kmap_atomic())
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
CONFLICT (content): Merge conflict in fs/btrfs/free-space-cache.c
Merging ceph/master (bf09339 ceph: Reconstruct the func ceph_reserve_caps.)
Merging cifs/for-next (6658b9f [CIFS] use sensible file nlink values if unp=
rovided)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0df5ed6 eCryptfs: Make extent and scatterlist crypt =
function parameters similar)
Merging ext3/for_next (e628753 quota: Convert use of typedef ctl_table to s=
truct ctl_table)
Merging ext4/dev (96eaeed ext4: fix ext4_get_group_number())
Merging f2fs/dev (5dea536 f2fs: add proc entry to monitor current usage of =
segments)
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (e5c5f05 fuse: fix alignment in short read optimizati=
on for async_dio)
Merging gfs2/master (a01aedf GFS2: Reserve journal space for quota change i=
n do_grow)
Merging jfs/jfs-next (eb8630d jfs: Update jfs_error)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (959d921 Merge branch 'labeled-nfs' into linux-next)
Merging nfsd/nfsd-next (0bebc63 sunrpc: Don't schedule an upcall on a repla=
ced cache entry.)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (f2692ea fs/9p: Remove the unused variable "err" in v=
9fs_vfs_getattr())
Merging ubifs/linux-next (beadadf UBIFS: correct mount message)
Merging xfs/for-next (83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and=
 XFS_OQUOTA_CHKD)
CONFLICT (content): Merge conflict in fs/xfs/xfs_log_recover.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_log_cil.c
Merging vfs/for-next (d405be4 ext4: ->tmpfile() support)
Merging pci/next (a0f75f9 Merge branch 'pci/misc' into next)
Merging hid/for-next (d750045 Merge branch 'for-3.11/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (97191d7 i2c-designware: use div_u64 to fix link)
Merging jdelvare-hwmon/master (1aaf6d3 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging hwmon-staging/hwmon-next (a50d9a4 hwmon: (ds1621) Fix temperature r=
ounding operations)
Merging v4l-dvb/master (0d90a9c Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (cca867d Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (930ed52 Merge branch 'for-3.11' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (d8851b4 Merge branch 'pm-tools')
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (9d1968f Merge branch 'cpu-package-thermal' of .git in=
to next)
CONFLICT (content): Merge conflict in drivers/thermal/ti-soc-thermal/ti-the=
rmal-common.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/the=
rmal/ti_soc_thermal.txt
Merging ieee1394/for-next (bcabcfd firewire: remove support of fw_driver.dr=
iver.probe and .remove methods)
Merging ubi/linux-next (83ff59a UBI: support ubi_num on mtd.ubi command lin=
e)
Merging dlm/next (cfa805f dlm: Avoid LVB truncation)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (67eacc1 DMA: shdma: add DT support)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (c7e8e8a bridge: fix some kernel warning in multica=
st timer)
CONFLICT (content): Merge conflict in fs/select.c
CONFLICT (content): Merge conflict in drivers/staging/silicom/bpctl_mod.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/clock-r8a7778.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/clock-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/mach-mxs.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/Kconfig
CONFLICT (content): Merge conflict in arch/arm/boot/dts/sun4i-a10.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am335x-evmsk.dts
CONFLICT (content): Merge conflict in Documentation/networking/netlink_mmap=
.txt
Merging ipsec-next/master (0289094 af_key: constify lookup tables)
Merging wireless-next/master (98f32f7 ath9k_htc: fix data race between requ=
est_firmware_nowait() callback and suspend())
Merging bluetooth/master (31e0500 Bluetooth: Fix simple whitespace vs tab s=
tyle issue)
Merging infiniband/for-next (0eba551 Merge branches 'af_ib', 'cxgb4', 'misc=
', 'mlx5', 'ocrdma', 'qib' and 'srp' into for-next)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (fb1585b mtd: nand: omap2: clean-up BCHx_HW and BCHx_=
SW ECC configurations in device_probe)
Merging crypto/master (02c0241 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/herbert/crypto)
Merging drm/drm-next (774d8e3 Merge branch 'drm-next-3.11' of git://people.=
freedesktop.org/~agd5f/linux into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_vm.c
Merging drm-intel/for-linux-next (8bbbb45 drm/i915: fix up ring cleanup for=
 the i830/i845 CS tlb w/a)
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (cd63a5f ALSA: hda - Keep halting ALC5505 DSP)
Merging sound-asoc/for-next (005fb5e Merge remote-tracking branch 'asoc/fix=
/wm8962' into asoc-linus)
Merging modules/modules-next (9eb76d7 module: cleanup call chain.)
Merging virtio/virtio-next (c5ace91 MAINTAINERS: add tools/virtio/ under vi=
rtio)
Merging input/next (46146e7 Input: nspire-keypad - replace magic offset wit=
h define)
Merging input-mt/for-next (257867d Input: MT - Specify that ABS_MT_SLOT mus=
t have a minimum of 0)
Merging cgroup/for-next (9109d44 Merge branch 'for-3.11' into for-next)
CONFLICT (content): Merge conflict in include/linux/cgroup.h
Merging block/for-next (4841577 Merge branch 'for-3.11/core' into for-next)
CONFLICT (content): Merge conflict in include/linux/cgroup.h
Merging device-mapper/master (7cf5960 dm-switch is a new target that maps I=
O to underlying block devices efficiently when there are a large number of =
fixed-sized address regions but there is no simple pattern to allow for a c=
ompact mapping representation such as dm-stripe.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (01ebea1 mmc: bcm281xx SDHCI driver)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (dee864d Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (c9a3dcd md: fix dev_sectors when data_offset changes.)
Merging mfd/master (25f311f mfd: sec: Provide max_register to regmap)
CONFLICT (content): Merge conflict in include/linux/mfd/davinci_voicecodec.h
CONFLICT (modify/delete): arch/arm/mach-exynos/mach-universal_c210.c delete=
d in HEAD and modified in mfd/master. Version mfd/master of arch/arm/mach-e=
xynos/mach-universal_c210.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am33xx.dtsi
$ git rm -f arch/arm/mach-exynos/mach-universal_c210.c
Merging battery/master (5a6c220 charger-manager: Fix regulator_get() return=
 check)
Merging fbdev/for-next (19fd744 Merge tag 'fbdev-3.11-2' of git://gitorious=
.org/linux-omap-dss2/linux into fbdev/for-next)
CONFLICT (content): Merge conflict in drivers/video/omap2/displays/panel-n8=
x0.c
CONFLICT (content): Merge conflict in drivers/video/of_display_timing.c
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (37c3f01 Merge remote-tracking branch 'regulator=
/fix/sec' into regulator-linus)
Merging security/next (572e5b0 tpm/tpm_i2c_infineon: Remove unused header f=
ile)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (6db3654 SELinux: Enable setting security contexts on=
 rootfs inodes.)
Merging watchdog/master (6dfc6f8 watchdog: New watchdog driver for MEN A21 =
watchdogs)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (01ce784 Merge branches 'x86/vt-d', 'arm/omap', 'core', =
'x86/amd' and 'arm/smmu' into next)
CONFLICT (content): Merge conflict in drivers/iommu/Kconfig
Merging vfio/next (8d38ef1 vfio/type1: Fix leak on error path)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (8ecada1 doc: printk-formats: fix format specifier=
 to %p[Ii]4[hnbl])
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (aad19e5 EDAC, MCE, AMD: Add an MCE signature for=
 new Fam15h models)
Merging devicetree/devicetree/next (6dd18e4 of: Fix address decoding on Bim=
ini and js2x machines)
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the defaul=
t pin configuration)
Merging spi-mb/for-next (ed89355 Merge remote-tracking branch 'spi/topic/xi=
linx' into spi-next)
Merging tip/auto-latest (53e8bb8 Merge branch 'x86/tracing')
CONFLICT (content): Merge conflict in kernel/irq/generic-chip.c
Merging ftrace/for-next (dcc3022 tracing: Make tracing_open_generic_{tr,tc}=
() static)
Merging rcu/rcu/next (be77f87 Merge branches 'cbnum.2013.06.10a', 'doc.2013=
.06.10a', 'fixes.2013.06.10a', 'srcu.2013.06.10a' and 'tiny.2013.06.10a' in=
to HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (03617c1 KVM: VMX: mark unusable segment as nonprese=
nt)
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (20f7462 Merge remote-tracking branch 'cmadma/=
for-v3.12-cma-dma' into kvm-ppc-next)
CONFLICT (content): Merge conflict in mm/Kconfig
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (21f3c04 Merge branch 'stable/for-linus-3.11' in=
to linux-next)
Merging xen-arm/linux-next (176455e xen/arm and xen/arm64: implement HYPERV=
ISOR_tmem_op)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (bbe2a23 Merge branch 'for-3.10-fixes' into for=
-next)
Merging drivers-x86/linux-next (80c8c7a toshiba_acpi: Add dependency on SER=
IO_I8042)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (f2e055e regmap: cache: bail in regmap_async_comple=
te() for bus-less maps)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (cf3b1c2 leds: mc13783: Fix "uninitialized variable" =
warning)
Merging driver-core/driver-core-next (fc76a25 Merge tag 'driver-core-3.11-r=
c1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging tty/tty-next (828c6a1 Revert "serial: 8250_pci: add support for ano=
ther kind of NetMos Technology PCI 9835 Multi-I/O Controller")
Merging usb/usb-next (fc76a25 Merge tag 'driver-core-3.11-rc1' of git://git=
.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging usb-gadget/next (b1fd6cb usb: dwc3: omap: Adds dwc3_omap_readl/writ=
el wrappers)
Merging staging/staging-next (fc76a25 Merge tag 'driver-core-3.11-rc1' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging char-misc/char-misc-next (fc76a25 Merge tag 'driver-core-3.11-rc1' =
of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core)
Merging scsi/for-next (8c0eb59 [SCSI] qla2xxx: Fix a memory leak in an erro=
r path of qla2x00_process_els())
Merging target-updates/for-next (ca40d24 iser-target: Ignore non TEXT + LOG=
OUT opcodes for discovery)
Merging target-merge/for-next-merge (317ddd2 Linux 3.10-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (5b81d55 pinctrl: remove bindings for pinconf opti=
ons needing more thought)
Merging vhost/linux-next (9a0c128 MAINTAINERS: add tools/virtio/ under virt=
io)
CONFLICT (content): Merge conflict in drivers/vhost/scsi.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (798f0fd irq: fix checkpatch error)
Merging gpio/gpio/next (644c8df gpio: sx150x: convert to use devm_* functio=
ns)
Merging gpio-lw/for-next (69acf2e Merge branch 'merge' into for-next)
Merging arm-soc/for-next (4bfc0fa Merge branch 'fixes' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/Kconfig
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (0fe2ea9 Merge branches 'mxs/dt', 'imx/weim', 'imx=
/soc', 'imx/fixes' and 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (d701eda ARM: dts: msm: Fix merge resolution)
Merging mvebu/for-next (04864c6 Merge branch 'mvebu/regmap' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/kirkwood-6281.dtsi
Merging renesas/next (c5cf440 Merge branch 'heads/phy-rcar-usb' into next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/r=
8a7778.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/clock-r8a7778.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/Kconfig
Merging samsung/for-next (65ef7e0 Merge tag 'soc-exynos5420-2' into for-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging tegra/for-next (7d13205 Linux 3.10-rc6)
Merging dma-mapping/dma-mapping-next (5b91a98 ARM: dma: Drop __GFP_COMP for=
 iommu dma memory allocations)
Merging pwm/for-next (b388f15 pwm: pwm-tiehrpwm: Use clk_enable/disable ins=
tead clk_prepare/unprepare.)
Merging dma-buf/for-next (8bb495e Linux 3.10)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (45e3ec3 clk: tegra: fix ifdef for tegra_periph_reset_=
assert inline)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (7f0ef02 Merge branch 'akpm' (updates from And=
rew Morton))
$ git checkout -b akpm remotes/origin/akpm/master
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: fix mq_open and mq_unlink to add the MQ root as a hidden p=
arent audit_names record
Applying: kernel/auditfilter.c: fixing build warning
Applying: kernel/auditfilter.c: fix leak in audit_add_rule() error path
Applying: audit: Fix decimal constant description
Applying: drivers/pcmcia/pd6729.c: convert to module_pci_driver
Applying: drivers/pcmcia/yenta_socket.c: convert to module_pci_driver
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: drm/cirrus: correct register values for 16bpp
Applying: drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO
Applying: drivers/video/acornfb.c: remove dead code
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: fanotify: info leak in copy_event_to_user()
Applying: fanotify: fix races when adding/removing marks
Applying: fanotify: put duplicate code for adding vfsmount/inode marks into=
 an own function
Applying: dnotify: replace dnotify_mark_mutex with mark mutex of dnotify_gr=
oup
Applying: inotify: fix race when adding a new watch
Applying: fsnotify: update comments concerning locking scheme
Applying: drivers/iommu/msm_iommu_dev.c: fix leak and clean up error paths
Applying: drivers-iommu-msm_iommu_devc-fix-leak-and-clean-up-error-paths-fix
Applying: include/linux/interrupt.h: add dummy irq_set_irq_wake() for "!GEN=
ERIC_HARDIRQS"
Applying: hrtimer: one more expiry time overflow check in hrtimer_interrupt
Applying: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
Applying: drivers/ide/delkin_cb.c: convert to module_pci_driver
Applying: drivers/mtd/chips/gen_probe.c: refactor call to request_module()
Applying: drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for po=
rtN properties
Applying: mISDN: add support for group membership check
Applying: drivers/atm/he.c: convert to module_pci_driver
Applying: isdn: clean up debug format string usage
Applying: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_=
entry() in ocfs2_orphan_del()
Applying: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END
Applying: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_si=
ze=3D=3Di_size
Applying: ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size=
=3D=3Di_size-v2
Applying: include/linux/sched.h: don't use task->pid/tgid in same_thread_gr=
oup/has_group_leader_pid
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: drivers/scsi/a100u2w.c: convert to module_pci_driver
Applying: drivers/scsi/dc395x.c: convert to module_pci_driver
Applying: drivers/scsi/dmx3191d.c: convert to module_pci_driver
Applying: drivers/scsi/initio.c: convert to module_pci_driver
Applying: drivers/scsi/mvumi.c: convert to module_pci_driver
Applying: drivers/net/irda/donauboe.c: convert to module_pci_driver
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs/file_table.c:fput(): add comment
Applying: fput: turn "list_head delayed_fput_list" into llist_head
Applying: llist: fix/simplify llist_add() and llist_add_batch()
Applying: llist: llist_add() can use llist_add_batch()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: mm: remove free_area_cache
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap: swapin_nr_pages() can be static
Applying: vmcore: allow user process to remap ELF note segment buffer
Applying: vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix
Applying: vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
Applying: mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-manage=
d_pages-fix
Applying: mm-correctly-update-zone-managed_pages-fix-fix-fix
Applying: fs: bump inode and dentry counters to long
Applying: super: fix calculation of shrinkable objects for small numbers
Applying: dcache: convert dentry_stat.nr_unused to per-cpu counters
Applying: dentry: move to per-sb LRU locks
Applying: dcache: remove dentries from LRU before putting on dispose list
Applying: mm: new shrinker API
Applying: shrinker: convert superblock shrinkers to new API
Applying: shrinker-convert-superblock-shrinkers-to-new-api-fix
Applying: list: add a new LRU list type
Applying: inode: convert inode lru list to generic lru list code.
Applying: inode: move inode to a different list inside lock
Applying: dcache: convert to use new lru list infrastructure
Applying: list_lru: per-node list infrastructure
Applying: list_lru: per-node list infrastructure fix
Applying: list_lru: per-node API
Applying: list_lru: remove special case function list_lru_dispose_all.
Applying: shrinker: add node awareness
Applying: vmscan: per-node deferred work
Applying: fs: convert inode and dentry shrinking to be node aware
Applying: xfs: convert buftarg LRU to generic code
Applying: xfs-convert-buftarg-lru-to-generic-code-fix
Applying: xfs: rework buffer dispose list tracking
Applying: xfs: convert dquot cache lru to list_lru
Applying: xfs-convert-dquot-cache-lru-to-list_lru-fix
Applying: fs: convert fs shrinkers to new scan/count API
Applying: fs-convert-fs-shrinkers-to-new-scan-count-api-fix
Applying: UBIFS: signedness bug in ubifs_shrink_count()
Applying: drivers: convert shrinkers to new count/scan API
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix-2
Applying: i915: bail out earlier when shrinker cannot acquire mutex
Applying: shrinker: convert remaining shrinkers to count/scan API
Applying: shrinker-convert-remaining-shrinkers-to-count-scan-api-fix
Applying: hugepage: convert huge zero page shrinker to new shrinker API
Applying: hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix
Applying: shrinker: Kill old ->shrink API.
Applying: shrinker-kill-old-shrink-api-fix
Applying: list_lru: dynamically adjust node arrays
Applying: super: fix for destroy lrus
Applying: mm: mremap: validate input before taking lock
Applying: memcg: clean up memcg->nodeinfo
Applying: mm: invoke oom-killer from remaining unconverted page fault handl=
ers
Applying: mm: remove duplicated call of get_pfn_range_for_nid
Applying: mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2
Applying: mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix
Applying: mm/vmalloc.c: unbreak __vunmap()
Applying: mm/vmalloc.c: remove dead code in vb_alloc
Applying: mm/vmalloc.c: remove unused purge_fragmented_blocks_thiscpu
Applying: mm/vmalloc.c: remove alloc_map from vmap_block
Applying: mm/vmalloc.c: emit the failure message before return
Applying: mm/vmalloc.c: rename VM_UNLIST to VM_UNINITIALIZED
Applying: mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead of sh=
ow_numa_info
Applying: memcg: also test for skip accounting at the page allocation level
Applying: memcg: do not account memory used for cache creation
Applying: include/linux/gfp.h: fix the comment for GFP_ZONE_TABLE
Applying: zbud: add to mm/
Applying: zswap: init under_reclaim
Applying: zswap: add to mm/
Applying: zswap: fix Kconfig to depend on CRYPTO=3Dy
Applying: zswap: add documentation
Applying: MAINTAINERS: add zswap and zbud maintainer
Applying: mm/page_alloc.c: remove zone_type argument of build_zonelists_node
Applying: mm: remove unused functions is_{normal_idx, normal, dma32, dma}
Applying: mm/page_alloc.c: remove unlikely() from the current_order test
Applying: vfree: don't schedule free_work() if llist_add() returns false
Applying: mm: remove unused __put_page()
Applying: mm/sparse.c: put clear_hwpoisoned_pages within CONFIG_MEMORY_HOTR=
EMOVE
Applying: fs/fs-writeback.c: : make wb_do_writeback() as static
Applying: mm/writeback: remove wb_reason_name
Applying: mm/writeback: don't check force_wait to handle bdi->work_list
Applying: mm/writeback: commit reason of WB_REASON_FORKER_THREAD mismatch n=
ame
Applying: mm/page_alloc: fix doc for numa_zonelist_order
Applying: mm/thp: fix doc for transparent huge zero page
Applying: mm/pgtable: don't accumulate addr during pgd prepopulate pmd
Applying: mm: remove unused VM_<READfoo> macros and expand other in-place
Applying: mm/vmalloc.c: fix an overflow bug in alloc_vmap_area()
Applying: page migration: fix wrong comment in address_space_operations.mig=
ratepage()
Applying: mm/memblock.c: fix wrong comment in __next_free_mem_range()
Applying: mm/memory_hotplug.c: fix a comment typo in register_page_bootmem_=
info_node()
Applying: mm: vmscan: do not continue scanning if reclaim was aborted for c=
ompaction
Applying: mm: vmscan: do not scale writeback pages when deciding whether to=
 set ZONE_WRITEBACK
Applying: mmap: allow MAP_HUGETLB for hugetlbfs files v2
Applying: Revert "memcg: avoid dangling reference count in creation failure"
Applying: memcg, kmem: fix reference count handling on the error path
Applying: memcg: use css_get() in sock_update_memcg()
Applying: memcg: don't use mem_cgroup_get() when creating a kmemcg cache
Applying: memcg: use css_get/put when charging/uncharging kmem
Applying: memcg: use css_get/put for swap memcg
Applying: memcg: don't need to get a reference to the parent
Applying: memcg: kill memcg refcnt
Applying: memcg: don't need to free memcg via RCU or workqueue
Applying: include/linux/mmzone.h: cleanups
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: mm: add vm event counters for balloon pages compaction
Applying: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
Applying: panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: list: remove __list_for_each()
Applying: checkpatch: warn when networking block comment lines don't start =
with *
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: autofs4: allow autofs to work outside the initial PID namespace
Applying: autofs4: translate pids to the right namespace for the daemon
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: ptrace/x86: revert "hw_breakpoints: Fix racy access to ptrace bre=
akpoints"
Applying: ptrace/powerpc: revert "hw_breakpoints: Fix racy access to ptrace=
 breakpoints"
Applying: ptrace/arm: revert "hw_breakpoints: Fix racy access to ptrace bre=
akpoints"
Applying: ptrace/sh: revert "hw_breakpoints: Fix racy access to ptrace brea=
kpoints"
Applying: ptrace: revert "Prepare to fix racy accesses on task breakpoints"
Applying: ptrace/x86: simplify the "disable" logic in ptrace_write_dr7()
Applying: ptrace/x86: dont delay "disable" till second pass in ptrace_write=
_dr7()
Applying: ptrace/x86: introduce ptrace_register_breakpoint()
Applying: ptrace/x86: ptrace_write_dr7() should create bp if !disabled
Applying: ptrace/x86: cleanup ptrace_set_debugreg()
Applying: ptrace: PTRACE_DETACH should do flush_ptrace_hw_breakpoint(child)
Applying: ptrace/x86: flush_ptrace_hw_breakpoint() shoule clear the virtual=
 debug registers
Applying: signals: eventpoll: set ->saved_sigmask at the start
Applying: coredump: '% at the end' shouldn't bypass core_uses_pid logic
Applying: move-exit_task_namespaces-outside-of-exit_notify-fix
Applying: ipc/shmc.c: eliminate ugly 80-col tricks
Applying: ipc: move rcu lock out of ipc_addid
Applying: ipc: restore rcu locking in ipc_addid
Applying: ipc: introduce ipc object locking helpers
Applying: ipc: close open coded spin lock calls
Applying: ipc: move locking out of ipcctl_pre_down_nolock
Applying: ipc,msg: shorten critical region in msgctl_down
Applying: ipc,msg: introduce msgctl_nolock
Applying: ipc,msg: introduce lockless functions to obtain the ipc object
Applying: ipc,msg: make msgctl_nolock lockless
Applying: ipc,msg: shorten critical region in msgsnd
Applying: ipc,msg: shorten critical region in msgrcv
Applying: ipc,msq: fix race in msgrcv(2)
Applying: ipc: remove unused functions
Applying: ipc/util.c, ipc_rcu_alloc: cacheline align allocation
Applying: ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation-checkpatch-fix=
es
Applying: ipc/sem.c: cacheline align the semaphore structures
Applying: ipc/sem: separate wait-for-zero and alter tasks into seperate que=
ues
Applying: ipc/sem.c: scan complex wait-for-zero after undefined updates
Applying: ipc/sem.c: always use only one queue for alter operations
Applying: ipc/sem.c: replace shared sem_otime with per-semaphore value
Applying: ipc/sem.c: rename try_atomic_semop() to perform_atomic_semop(), d=
ocu update
Applying: mwave: fix info leak in mwave_ioctl()
Applying: partitions/msdos.c: end-of-line whitespace and semicolon cleanup
Applying: partitions: add aix lvm partition support files
Applying: partitions-add-aix-lvm-partition-support-files-v2
Applying: partitions-add-aix-lvm-partition-support-files-checkpatch-fixes
Applying: partitions-add-aix-lvm-partition-support-files: compile aix.c if =
configured
Applying: partitions-add-aix-lvm-partition-support-files: add the AIX_PARTI=
TION entry
Applying: partitions/msdos: enumerate also AIX LVM partitions
Applying: relay: fix timer madness
Applying: reboot: remove -stable friendly PF_THREAD_BOUND define
Applying: reboot: move shutdown/reboot related functions to kernel/reboot.c
Applying: reboot: checkpatch.pl the new kernel/reboot.c file
Applying: reboot: x86: prepare reboot_mode for moving to generic kernel code
Applying: reboot: unicore32: prepare reboot_mode for moving to generic kern=
el code
Applying: reboot: arm: remove unused restart_mode fields from some arm suba=
rchs
Applying: reboot: arm: prepare reboot_mode for moving to generic kernel code
Applying: reboot: arm: change reboot_mode to use enum reboot_mode
Applying: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix
Applying: reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix
Applying: reboot: move arch/x86 reboot=3D handling to generic kernel
Applying: lib: add weak clz/ctz functions
Applying: decompressor: add LZ4 decompressor module
Applying: lib: add support for LZ4-compressed kernel
Applying: kbuild: fix for updated LZ4 tool with the new streaming format
Applying: arm: add support for LZ4-compressed kernel
Applying: arm: Remove enforced Os flag for LZ4 decompressor
Applying: x86: add support for LZ4-compressed kernel
Applying: x86, doc: Add LZ4 magic number for the new compression
Applying: lib: add lz4 compressor module
Applying: lib-add-lz4-compressor-module-fix
Applying: crypto: add lz4 Cryptographic API
Applying: crypto-add-lz4-cryptographic-api-fix
Applying: drivers/iio/inkern.c: fix iio_convert_raw_to_processed_unlocked()
Applying: lib/scatterlist: factor out sg_miter_get_next_page() from sg_mite=
r_next()
Applying: lib/scatterlist: introduce sg_pcopy_from_buffer() and sg_pcopy_to=
_buffer()
Applying: crypto: talitos: use sg_pcopy_to_buffer()
Applying: scsi_debug: fix do_device_access() with wrap around range
Applying: lib/scatterlist: error handling in __sg_alloc_table()
Applying: staging/lustre/ldlm: convert to shrinkers to count/scan API
Applying: staging/lustre/obdclass: convert lu_object shrinker to count/scan=
 API
Applying: staging/lustre/ptlrpc: convert to new shrinker API
Applying: staging/lustre/libcfs: cleanup linux-mem.h
Applying: staging/lustre: replace num_physpages with totalram_pages
Merging akpm/master (e9b7201 staging/lustre: replace num_physpages with tot=
alram_pages)
$ git checkout -b cpuinit remotes/origin/cpuinit/master
Applying: alpha: delete __cpuinit usage from all users
Applying: parisc: delete __cpuinit usage from all users
Applying: MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code
Applying: arm: delete __cpuinit/__CPUINIT usage from all ARM users
Applying: sparc: delete __cpuinit/__CPUINIT usage from all users
Applying: arm64: delete __cpuinit usage from all users
Applying: blackfin: delete __cpuinit usage from all blackfin files
Applying: s390: delete __cpuinit usage from all s390 files
Applying: sh: delete __cpuinit usage from all sh files
Applying: tile: delete __cpuinit usage from all tile files
Applying: metag: delete __cpuinit usage from all metag files
Applying: cris: delete __cpuinit usage from all cris files
Applying: frv: delete __cpuinit usage from all frv files
Applying: hexagon: delete __cpuinit usage from all hexagon files
Applying: m32r: delete __cpuinit usage from all m32r files
Applying: openrisc: delete __cpuinit usage from all openrisc files
Applying: xtensa: delete __cpuinit usage from all xtensa files
Applying: score: delete __cpuinit usage from all score files
Applying: x86: delete __cpuinit usage from all x86 files
Applying: clocksource+irqchip: delete __cpuinit usage from all related files
Applying: cpufreq: delete __cpuinit usage from all cpufreq files
Applying: hwmon: delete __cpuinit usage from all hwmon files
Applying: acpi: delete __cpuinit usage from all acpi files
Applying: net: delete __cpuinit usage from all net files
Applying: rcu: delete __cpuinit usage from all rcu files
Applying: kernel: delete __cpuinit usage from all core kernel files
Applying: drivers: delete __cpuinit usage from all remaining drivers files
Applying: block: delete __cpuinit usage from all block files
Merging cpuinit/master (f68506e block: delete __cpuinit usage from all bloc=
k files)

--Signature=_Tue__9_Jul_2013_17_01_55_+1000_mQtKCLe2S_iSkpO+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR27VnAAoJEECxmPOUX5FELEcQAKQiSrmeE8onxVRfWKwuji9W
YZIsVLukD0KtSvcRUZXOVT9mSSAqbNY3MJWm3tdzmv2si4yCKwZm0/42WIxiMtPZ
Q/6QfX0zRZAJX+J5a9ZiND2bELfhb6pqjIu4NFEcA5l5tvgNzuRYvgeIbfcD/1HV
LwKjHhBBxlRnVQLwJA3PKrjtWkVxFidohvNvANw6MPhNS1JyVnPwgvvke07ZuEpJ
QTLwWeaFbH4mLHknjNPg8NTgSu3Vmyvvf5n1cuWZuYtkticJR7QAHXc1j9pHKYl9
rPIIV884K8pOB57+tnztPsDa7B/9y1Y4Qc0GXXcVkif5Q9EtKhDrMoeqq1sYSK+2
taTU+S1B/MU4qU739bRfWospkNxstxmscCTILcJaBqyETLctzoaShyistuxVZsEY
RIUCPUAe7LGi+75Nbh5F4cUmwGGwV6mOiXT3hA8jgz7e9hZrj162a1TI+A/Y3KMx
c7zkABlQUyGs65TgzvgfdesmYeikQkvSKV/e9Psb7MzWzzl0uROW5XTG4IrhdohY
HjAPGwgVArB2SuCWtbBmHbB5BK41CUQT5Q17PHLLSnGWZcTh2ZtEOLLrR1qUJHWl
tIQjMT7K350qLW1zMXQHbfUwN5Rl/Hmh5LXmbAL+9qLyijSHZcqn2xHLOyK8dK2i
JRJXOpQBDy4MgqHGBx7p
=mYnB
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jul_2013_17_01_55_+1000_mQtKCLe2S_iSkpO+--
