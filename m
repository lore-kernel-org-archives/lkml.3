Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3F0JYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:24:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44643 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3F0JY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:24:27 -0400
Date: Thu, 27 Jun 2013 19:24:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jun 27
Message-Id: <20130627192416.d37a51646a5317892298609e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_19_24_16_+1000_bZbiMos=PbC.EugH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_19_24_16_+1000_bZbiMos=PbC.EugH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130626:

Removed tree: arm-mpidr (served its purpose)

The pm tree gained a conflict against the pci tree.

The net-next tree gained a conflict against the net tree and lost its
build failure.

The wireless-next tree gained a conflict against the net-next tree.

The driver-core tree gained a conflict against the pm tree.

The cpuinit tree gained a conflict against the mips tree.

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
Merging origin/master (34a0868 Merge tag 'regulator-v3.10-rc7' of git://git=
.kernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging fixes/master (8177a9d lseek(fd, n, SEEK_END) does *not* go to eof -=
 n)
Merging kbuild-current/rc-fixes (42a0940 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arc-current/for-curr (0b5e7bc ARC: warn on improper stack unwind FD=
E entries)
Merging arm-current/fixes (3e0a07f ARM: 7773/1: PJ4B: Add support for errat=
a 4742)
Merging m68k-current/for-linus (7d13205 Linux 3.10-rc6)
Merging powerpc-merge/merge (b37e161 powerpc/pci: Fix boot panic on mpc83xx=
 (regression))
Merging sparc/master (c069114 mn10300: Fix include dependency in irqflags.h=
 et al.)
Merging net/master (578a131 dlci: validate the net device in dlci_del())
Merging ipsec/master (01cb71d net_sched: restore "overhead xxx" handling)
Merging sound-current/for-linus (1c6770a Merge tag 'asoc-v3.10-rc7' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (65694c5 x86/PCI: Map PCI setup data with ior=
emap() so it can be in highmem)
Merging wireless/master (57bf744 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/bluetooth/bluetooth)
Merging driver-core.current/driver-core-linus (9e895ac Linux 3.10-rc7)
Merging tty.current/tty-linus (9e895ac Linux 3.10-rc7)
Merging usb.current/usb-linus (9e895ac Linux 3.10-rc7)
Merging staging.current/staging-linus (7d13205 Linux 3.10-rc6)
Merging char-misc.current/char-misc-linus (7d13205 Linux 3.10-rc6)
Merging input-current/for-linus (be66227 Input: xpad - fix for "Mad Catz St=
reet Fighter IV FightPad" controllers)
Merging md-current/for-linus (32f9f57 MD: ignore discard request for hard d=
isks of hybid raid1/raid10 array)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (939e177 crypto: algboss - Hold ref count on =
larval)
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
Merging arc/for-next (beaff50 arch/arc: angel4.dts - add description for "a=
rc_emac")
Merging arm/for-next (df56077 Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (642bd4e perf: ARM: Record the user-mode PC =
in the call chain.)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (add/add): Merge conflict in arch/arm/mach-zynq/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
CONFLICT (content): Merge conflict in arch/arm/mach-highbank/highbank.c
Merging arm64/upstream (ee877b5 arm64: Add initial DTS for APM X-Gene Storm=
 SOC and APM Mustang board)
CONFLICT (content): Merge conflict in include/uapi/linux/kvm.h
Merging blackfin/blackfin-linus (5ae89ee bfin cache: dcplb map: add 16M dcp=
lb map for BF60x)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (38f847b Merge branch 'pstore' into next)
Merging m68k/for-next (365afba Merge branch 'exotic-arch-fixes' into for-ne=
xt)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging m68knommu/for-next (e4aa937 Linux 3.10-rc3)
Merging metag/for-next (24283cd metag: tz1090: select and instantiate pinct=
rl-tz1090-pdc)
Merging microblaze/next (c421cee microblaze: Enable KGDB in defconfig)
Merging mips/mips-for-linux-next (e6d254a Merge branch '3.10-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (c069114 mn10300: Fix include dependency in irqf=
lags.h et al.)
Merging powerpc/next (3766a1a mm/thp: define HPAGE_PMD_* constants as BUILD=
_BUG() if !THP)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (0875a88 powerpc/mpc512x: add MPC5125 reset module sup=
port for system restart)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (2ab1461 s390/appldata_net_sum: do not use static dat=
a)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (317ddd2 Linux 3.10-rc5)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0756a12 xtensa: tell git to ignore copied zlib sou=
rce files)
Merging btrfs/next (667e7d9 Btrfs: allow superblock mismatch from older mkf=
s)
Merging ceph/master (60fc6ea ceph: Free mdsc if alloc mdsc->mdsmap failed.)
CONFLICT (content): Merge conflict in drivers/block/rbd.c
Merging cifs/for-next (f87ab88 [CIFS] Do not set DFS flag on SMB2 open)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (0df5ed6 eCryptfs: Make extent and scatterlist crypt =
function parameters similar)
Merging ext3/for_next (7ea2177 quota: Convert use of typedef ctl_table to s=
truct ctl_table)
Merging ext4/dev (03d5b8b ext4: optimize starting extent in ext4_ext_rm_lea=
f())
Merging f2fs/dev (5dfc229 f2fs: code cleanup and simplify in func {find/add=
}_gc_inode)
Merging fscache/fscache (bbd645c FS-Cache: Don't use spin_is_locked() in as=
sertions)
Merging fuse/for-next (e5c5f05 fuse: fix alignment in short read optimizati=
on for async_dio)
Merging gfs2/master (6a98c33 GFS2: Fix fstrim boundary conditions)
Merging jfs/jfs-next (eb8630d jfs: Update jfs_error)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (0a8c08f Merge branch 'labeled-nfs' into linux-next)
Merging nfsd/nfsd-next (1a9357f nfsd: avoid undefined signed overflow)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (7a0d932 fs/9p: xattr: add trusted and security names=
paces)
Merging ubifs/linux-next (c1be5a5 Linux 3.9)
Merging xfs/for-next (80a4049 xfs: Remove dead function prototype xfs_sync_=
inode_grab())
Merging vfs/for-next (756476e vfs: export lseek_execute() to modules)
Merging pci/next (a0f75f9 Merge branch 'pci/misc' into next)
CONFLICT (content): Merge conflict in include/linux/aer.h
CONFLICT (content): Merge conflict in drivers/pci/probe.c
CONFLICT (content): Merge conflict in drivers/acpi/pci_root.c
CONFLICT (content): Merge conflict in arch/ia64/sn/kernel/io_init.c
Merging hid/for-next (d196fb9 Merge branch 'for-3.11/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (4c730a0 i2c: mv64xxx: Set bus frequency to 100kHz=
 if clock-frequency is not provided)
Merging jdelvare-hwmon/master (1aaf6d3 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging hwmon-staging/hwmon-next (f857a0b Add support for GMT G762/G763 PWM=
 fan controllers)
Merging v4l-dvb/master (6245dc9 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (0d8ab18 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (930ed52 Merge branch 'for-3.11' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (6c685e7 Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
CONFLICT (content): Merge conflict in MAINTAINERS
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
Merging ieee1394/for-next (bcabcfd firewire: remove support of fw_driver.dr=
iver.probe and .remove methods)
Merging ubi/linux-next (584d462 UBI: fastmap break out of used PEB search)
Merging dlm/next (cfa805f dlm: Avoid LVB truncation)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (1cd54e4 Merge branch 'misc' into for-next)
Merging target-updates/for-next (634d1e2 iscsi-target: missing kfree() on e=
rror path)
Merging target-merge/for-next-merge (317ddd2 Linux 3.10-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (469fd0d DMA: shdma: add DT support)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (38ae92d fec: Add support for reading RMON register=
s)
CONFLICT (content): Merge conflict in fs/select.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/renesas/sh_eth.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/freescale/fec_ma=
in.c
Merging ipsec-next/master (4c4d41f xfrm: add LINUX_MIB_XFRMACQUIREERROR sta=
tistic counter)
Merging wireless-next/master (59731bb Merge branch 'for-john' of git://git.=
kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next)
CONFLICT (content): Merge conflict in net/wireless/nl80211.c
Merging bluetooth/master (2237c82 Bluetooth: Add support for Atheros [0cf3:=
e003])
Merging infiniband/for-next (dae0041 Merge branches 'af_ib', 'cxgb4', 'misc=
', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (449e74c mtd: tests: don't print error messages when =
out-of-memory)
Merging crypto/master (02c0241 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/herbert/crypto)
Merging drm/drm-next (4bf8e19 drm: Renesas R-Car Display Unit DRM driver)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_sdvo.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_vm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_prime.c
Merging drm-intel/for-linux-next (6dd8224 drm/i915: Mask out hardware statu=
s bits from VLV DPLL register)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_sdvo.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_fb.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (bd5fe73 ALSA: ak4xx-adda: info leak in ak4xxx_captu=
re_source_info())
Merging sound-asoc/for-next (833d277 Merge remote-tracking branch 'asoc/top=
ic/x86' into asoc-next)
Merging modules/modules-next (06df44e modpost.c: Add .text.unlikely to TEXT=
_SECTIONS)
Merging virtio/virtio-next (b3087e4 virtio: remove virtqueue_add_buf().)
Merging input/next (8855f30 Input: wacom_i2c - implement hovering capabilit=
y)
Merging input-mt/for-next (257867d Input: MT - Specify that ABS_MT_SLOT mus=
t have a minimum of 0)
Merging cgroup/for-next (e5f1e96 Merge branch 'for-3.11' into for-next)
Merging block/for-next (c40a7a1 Merge branch 'for-3.11/drivers' into for-ne=
xt)
CONFLICT (content): Merge conflict in include/linux/cgroup.h
Merging device-mapper/master (644e888 This reorder actually improves perfor=
mance by 20% (from 39.1s to 32.8s) on x86-64 quad core Opteron.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (b9ec274 mmc: tmio: reset the controller after power-u=
p)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (c55d728 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (25e3903 raid5: make release_stripe lockless)
Merging mfd/master (43620a1 mfd: Kontron PLD mfd driver)
Merging battery/master (b52eafc power/reset: Make the vexpress driver optio=
nal on arm and arm64)
Merging fbdev/for-next (8ea2c86 Merge branch 'fbdev-3.11' of git://gitoriou=
s.org/linux-omap-dss2/linux into fbdev/for-next)
CONFLICT (content): Merge conflict in drivers/video/of_display_timing.c
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (1b3b968 Merge remote-tracking branch 'regulator=
/topic/tps62360' into regulator-next)
Merging security/next (9b97b6c evm: audit integrity metadata failures)
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (5bfd379 selinux: remove the BUG_ON() from selinux_sk=
b_xfrm_sid())
Merging watchdog/master (28b7e09 watchdog: wdrtas: don't use custom version=
 of print_hex_dump)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (01ce784 Merge branches 'x86/vt-d', 'arm/omap', 'core', =
'x86/amd' and 'arm/smmu' into next)
CONFLICT (content): Merge conflict in drivers/iommu/Kconfig
Merging vfio/next (6d6768c vfio: Limit group opens)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (a15e419 Documentation/cgroups/memory.txt: fix sta=
t file documentation)
CONFLICT (content): Merge conflict in Documentation/networking/netlink_mmap=
.txt
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (aad19e5 EDAC, MCE, AMD: Add an MCE signature for=
 new Fam15h models)
Merging devicetree/devicetree/next (ba166e9 of: remove CONFIG_OF_DEVICE)
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the defaul=
t pin configuration)
Merging spi-mb/for-next (ed89355 Merge remote-tracking branch 'spi/topic/xi=
linx' into spi-next)
Merging tip/auto-latest (a199194 Merge branch 'x86/uv')
CONFLICT (content): Merge conflict in kernel/futex.c
CONFLICT (content): Merge conflict in arch/arm/kernel/Makefile
Merging ftrace/for-next (52d85d7 ftrace: Fix stddev calculation in function=
 profiler)
Merging rcu/rcu/next (be77f87 Merge branches 'cbnum.2013.06.10a', 'doc.2013=
.06.10a', 'fixes.2013.06.10a', 'srcu.2013.06.10a' and 'tiny.2013.06.10a' in=
to HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (87d41fb KVM: s390: Fixed priority of execution in S=
TSI)
CONFLICT (content): Merge conflict in arch/s390/include/asm/pgtable.h
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (5975a2e KVM: PPC: Book3S: Add API for in-kern=
el XICS emulation)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (5abd2cb Merge branch 'stable/for-linus-3.11' in=
to linux-next)
Merging xen-arm/linux-next (e4aa937 Linux 3.10-rc3)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (bbe2a23 Merge branch 'for-3.10-fixes' into for=
-next)
Merging drivers-x86/linux-next (a1ec56e Add support for fan button on Ideap=
ad Z580)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (9adaa24 Merge remote-tracking branch 'regmap/topic=
/field' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (73e1ab4 leds: Convert led class driver from legacy p=
m ops to dev_pm_ops)
Merging driver-core/driver-core-next (bfd63cd driver core: device.h: fix do=
c compilation warnings)
CONFLICT (content): Merge conflict in include/linux/platform_device.h
CONFLICT (content): Merge conflict in include/linux/device.h
CONFLICT (content): Merge conflict in drivers/base/memory.c
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (29692d0 pch_uart: Add uart_clk selection for the Minn=
owBoard)
Merging usb/usb-next (3a0ddc7 usb: musb: omap2430: make it compile again)
CONFLICT (content): Merge conflict in drivers/usb/chipidea/Makefile
Merging usb-gadget/next (b1fd6cb usb: dwc3: omap: Adds dwc3_omap_readl/writ=
el wrappers)
Merging staging/staging-next (0ad1ea6 Revert "Revert "Revert "staging/lustr=
e: drop CONFIG_BROKEN dependency""")
CONFLICT (content): Merge conflict in drivers/thermal/ti-soc-thermal/ti-the=
rmal-common.c
CONFLICT (content): Merge conflict in drivers/staging/silicom/bpctl_mod.c
CONFLICT (content): Merge conflict in drivers/staging/serqt_usb2/serqt_usb2=
.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/the=
rmal/ti_soc_thermal.txt
Applying: staging/lustre: fix for invalidatepage() API change
Merging char-misc/char-misc-next (3806726 Revert "char: misc: assign file->=
private_data in all cases")
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
CONFLICT (content): Merge conflict in drivers/pinctrl/Makefile
CONFLICT (content): Merge conflict in drivers/net/ethernet/ti/davinci_mdio.c
Merging vhost/linux-next (f722406 Linux 3.10-rc1)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (798f0fd irq: fix checkpatch error)
CONFLICT (content): Merge conflict in kernel/irq/irqdomain.c
Merging gpio/gpio/next (644c8df gpio: sx150x: convert to use devm_* functio=
ns)
Merging gpio-lw/for-next (3bae481 gpiolib: remove warnning of allocations w=
ith IRQs disabled)
Merging arm-soc/for-next (685f726 ARM: Make multi_v7_defconfig usable on ha=
rdware)
CONFLICT (content): Merge conflict in include/linux/mfd/davinci_voicecodec.h
CONFLICT (content): Merge conflict in drivers/usb/phy/phy-rcar-usb.c
CONFLICT (content): Merge conflict in drivers/usb/Kconfig
CONFLICT (content): Merge conflict in drivers/tty/serial/xilinx_uartps.c
CONFLICT (content): Merge conflict in drivers/clocksource/dw_apb_timer_of.c
CONFLICT (content): Merge conflict in arch/arm/mach-u300/timer.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/clock-r8a7778.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/clock-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-mxs/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-integrator/integrator_a=
p.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/sun4i-a10.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am33xx.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am335x-evmsk.dts
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (951edd3 Merge branches 'imx/soc-3.12' and 'imx/dt=
-3.12' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (d701eda ARM: dts: msm: Fix merge resolution)
Merging mvebu/for-next (04864c6 Merge branch 'mvebu/regmap' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/kirkwood-6281.dtsi
Merging renesas/next (f664a2b Merge branch 'heads/phy-rcar-usb' into next)
CONFLICT (content): Merge conflict in include/uapi/linux/serial_core.h
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/r=
8a7778.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/clock-r8a7778.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
Merging samsung/for-next (565ac91 Merge branch 'v3.11-next/soc-exynos5420-c=
lk' into for-next)
CONFLICT (content): Merge conflict in drivers/clk/samsung/clk-exynos5250.c
CONFLICT (modify/delete): arch/arm/plat-samsung/samsung-time.c deleted in s=
amsung/for-next and modified in HEAD. Version HEAD of arch/arm/plat-samsung=
/samsung-time.c left in tree.
CONFLICT (content): Merge conflict in arch/arm/Kconfig
$ git rm -f arch/arm/plat-samsung/samsung-time.c
Merging tegra/for-next (7d13205 Linux 3.10-rc6)
Merging dma-mapping/dma-mapping-next (75fa1f2 ARM: dma: Drop __GFP_COMP for=
 iommu dma memory allocations)
Merging pwm/for-next (b388f15 pwm: pwm-tiehrpwm: Use clk_enable/disable ins=
tead clk_prepare/unprepare.)
Merging dma-buf/for-next (844ce9f Merge tag 'mmc-fixes-for-3.10-rc5' of git=
://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (7064f6b clk: tegra: provide tegra_periph_reset_assert=
 alternative)
CONFLICT (content): Merge conflict in drivers/clk/tegra/clk-tegra114.c
CONFLICT (content): Merge conflict in drivers/clk/samsung/clk-exynos5250.c
CONFLICT (content): Merge conflict in drivers/clk/samsung/clk-exynos4.c
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
CONFLICT (content): Merge conflict in arch/arm64/include/asm/pgtable.h
CONFLICT (content): Merge conflict in arch/arm64/include/asm/pgtable-hwdef.h
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (17858ca Merge tag 'please-pull-fixia64' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: fput-task_work_add-can-fail-if-the-caller-has-passed-exit_task_wo=
rk-fix
Applying: include/linux/smp.h:on_each_cpu(): switch back to a macro
Applying: drivers/platform/x86/intel_ips.c: convert to module_pci_driver
Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: fix mq_open and mq_unlink to add the MQ root as a hidden p=
arent audit_names record
Applying: kernel/auditfilter.c: fixing build warning
Applying: kernel/auditfilter.c: fix leak in audit_add_rule() error path
Applying: drivers/pcmcia/pd6729.c: convert to module_pci_driver
Applying: drivers/pcmcia/yenta_socket.c: convert to module_pci_driver
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: drm/cirrus: correct register values for 16bpp
Applying: drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO
Applying: drivers/video/smscufx.c: use NULL instead of 0
Applying: drivers/video/udlfb.c: use NULL instead of 0
Applying: drivers/video/udlfb.c: make local symbol static
Applying: drivers/video/imxfb.c: make local symbols static
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
Applying: posix_cpu_timer: consolidate expiry time type
Applying: posix_cpu_timers: consolidate timer list cleanups
Applying: posix_cpu_timers: consolidate expired timers check
Applying: selftests: add basic posix timers selftests
Applying: posix-timers: correctly get dying task time sample in posix_cpu_t=
imer_schedule()
Applying: posix_timers: fix racy timer delta caching on task exit
Applying: kernel/timer.c: fix jiffies wrap behavior of round_jiffies*()
Applying: hrtimer: one more expiry time overflow check in hrtimer_interrupt
Applying: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
Applying: drivers/ide/delkin_cb.c: convert to module_pci_driver
Applying: drivers/mtd/chips/gen_probe.c: refactor call to request_module()
Applying: virtio_balloon: leak_balloon(): only tell host if we got pages de=
flated
Applying: configfs: use capped length for ->store_attribute()
Applying: drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for po=
rtN properties
Applying: mISDN: add support for group membership check
Applying: drivers/atm/he.c: convert to module_pci_driver
Applying: isdn: clean up debug format string usage
Applying: fs/ocfs2/dlm/dlmrecovery.c: remove duplicate declarations
Applying: fs/ocfs2/dlm/dlmrecovery.c:dlm_request_all_locks(): ret should be=
 int instead of enum
Applying: ocfs2: should not use le32_add_cpu to set ocfs2_dinode i_flags
Applying: ocfs2: add missing dlm_put() in dlm_begin_reco_handler()
Applying: ocfs2: remove unecessary variable needs_checkpoint
Applying: ocfs2: fix mutex_unlock and possible memory leak in ocfs2_remove_=
btree_range
Applying: fs/ocfs2/journal.h: add bits_wanted while calculating credits in =
ocfs2_calc_extend_credits
Applying: fs/ocfs2/cluster/tcp.c: free sc->sc_page in sc_kref_release()
Applying: softirq: use _RET_IP_
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
Applying: drivers/cdrom/gdrom.c: fix device number leak
Applying: block/compat_ioctl.c: do not leak info to user-space
Applying: drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
Applying: block: do not pass disk names as format strings
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fput: turn "list_head delayed_fput_list" into llist_head
Applying: llist: fix/simplify llist_add() and llist_add_batch()
Applying: llist: llist_add() can use llist_add_batch()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: crypto: sanitize argument for format string
Applying: clear_refs: sanitize accepted commands declaration
Applying: clear_refs: introduce private struct for mm_walk
Applying: pagemap: introduce pagemap_entry_t without pmshift bits
Applying: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
Applying: mm: soft-dirty bits for user memory changes tracking
Applying: soft-dirty: call mmu notifiers when write-protecting ptes
Applying: pagemap: prepare to reuse constant bits with page-shift
Applying: mm, memcg: don't take task_lock in task_in_mem_cgroup
Applying: mm: remove free_area_cache
Applying: mm: remove compressed copy from zram in-memory
Applying: mm-remove-compressed-copy-from-zram-in-memory-fix
Applying: non-swapcache pages in end_swap_bio_read()
Applying: mm-remove-compressed-copy-from-zram-in-memory-fix-2-fix
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap: swapin_nr_pages() can be static
Applying: mm: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
Applying: ncpfs: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHI=
FT
Applying: uio: use vma_pages() to replace (vm_end - vm_start) >> PAGE_SHIFT
Applying: mm/page_alloc: factor out setting of pcp->high and pcp->batch
Applying: mm/page_alloc: prevent concurrent updaters of pcp ->batch and ->h=
igh
Applying: mm/page_alloc: insert memory barriers to allow async update of pc=
p batch and high
Applying: mm/page_alloc: protect pcp->batch accesses with ACCESS_ONCE
Applying: mm/page_alloc: convert zone_pcp_update() to rely on memory barrie=
rs instead of stop_machine()
Applying: mm/page_alloc: when handling percpu_pagelist_fraction, don't unne=
edly recalulate high
Applying: mm/page_alloc: factor setup_pageset() into pageset_init() and pag=
eset_set_batch()
Applying: mm/page_alloc: relocate comment to be directly above code it refe=
rs to.
Applying: mm/page_alloc: factor zone_pageset_init() out of setup_zone_pages=
et()
Applying: mm/page_alloc: in zone_pcp_update(), uze zone_pageset_init()
Applying: mm/page_alloc: rename setup_pagelist_highmark() to match naming o=
f pageset_set_batch()
Applying: mm/page_alloc: don't re-init pageset in zone_pcp_update()
Applying: mm: vmscan: limit the number of pages kswapd reclaims at each pri=
ority
Applying: mm: vmscan: obey proportional scanning requirements for kswapd
Applying: mm: vmscan: flatten kswapd priority loop
Applying: mm: vmscan: decide whether to compact the pgdat based on reclaim =
progress
Applying: mm: vmscan: do not allow kswapd to scan at maximum priority
Applying: mm: vmscan: have kswapd writeback pages based on dirty pages enco=
untered, not priority
Applying: mm: vmscan: block kswapd if it is encountering pages under writeb=
ack
Applying: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writebac=
k-fix
Applying: mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writebac=
k-fix-2
Applying: mm: vmscan: check if kswapd should writepage once per pgdat scan
Applying: mm: vmscan: move logic from balance_pgdat() to kswapd_shrink_zone=
()
Applying: mm: vmscan: stall page reclaim and writeback pages based on dirty=
/writepage pages encountered
Applying: mm: vmscan: stall page reclaim after a list of pages have been pr=
ocessed
Applying: mm: vmscan: set zone flags before blocking
Applying: mm: vmscan: move direct reclaim wait_iff_congested into shrink_li=
st
Applying: mm: vmscan: treat pages marked for immediate reclaim as zone cong=
estion
Applying: mm: vmscan: take page buffers dirty and locked state into account
Applying: fs: nfs: inform the VM about pages being committed or unstable
Applying: mm: fix comment referring to non-existent size_seqlock, change to=
 span_seqlock
Applying: mmzone: note that node_size_lock should be manipulated via pgdat_=
resize_lock()
Applying: memory_hotplug: use pgdat_resize_lock() in online_pages()
Applying: memory_hotplug: use pgdat_resize_lock() in __offline_pages()
Applying: memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix
Applying: include/linux/mm.h: add PAGE_ALIGNED() helper
Applying: vmcore: clean up read_vmcore()
Applying: vmcore: allocate buffer for ELF headers on page-size alignment
Applying: vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix
Applying: vmcore: treat memory chunks referenced by PT_LOAD program header =
entries in page-size boundary in vmcore_list
Applying: vmalloc: make find_vm_area check in range
Applying: vmalloc: introduce remap_vmalloc_range_partial
Applying: vmalloc-introduce-remap_vmalloc_range_partial-fix
Applying: vmcore: allocate ELF note segment in the 2nd kernel vmalloc memory
Applying: vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory=
-fix
Applying: vmcore: allow user process to remap ELF note segment buffer
Applying: vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix
Applying: vmcore: calculate vmcore file size from buffer size and total siz=
e of vmcore objects
Applying: vmcore: support mmap() on /proc/vmcore
Applying: vmcore-support-mmap-on-proc-vmcore-fix
Applying: vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
Applying: memcg: update TODO list in Documentation
Applying: mm: add tracepoints for LRU activation and insertions
Applying: mm: pagevec: defer deciding which LRU to add a page to until page=
vec drain time
Applying: mm: activate !PageLRU pages on mark_page_accessed if page is on l=
ocal pagevec
Applying: mm: remove lru parameter from __pagevec_lru_add and remove parts =
of pagevec API
Applying: mm: remove lru parameter from __lru_cache_add and lru_cache_add_l=
ru
Applying: mm: Clear page active before releasing pages
Applying: mm/page_alloc.c: add additional checking and return value for the=
 'table->data'
Applying: mm/nommu.c: add additional check for vread() just like vwrite() h=
as done
Applying: mm/memory-failure.c: fix memory leak in successful soft offlining
Applying: mm/memory_hotplug.c: change normal message to use pr_debug
Applying: mm/memory-hotplug: fix lowmem count overflow when offline pages
Applying: mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix
Applying: mm/pageblock: remove get/set_pageblock_flags
Applying: mm/hugetlb: remove hugetlb_prefault
Applying: mm/hugetlb: use already existing interface huge_page_shift
Applying: mm: tune vm_committed_as percpu_counter batching size
Applying: mm-tune-vm_committed_as-percpu_counter-batching-size-fix
Applying: swap: discard while swapping only if SWAP_FLAG_DISCARD_PAGES
Applying: swap-discard-while-swapping-only-if-swap_flag_discard_pages-fix
Applying: mm: change signature of free_reserved_area() to fix building warn=
ings
Applying: mm: enhance free_reserved_area() to support poisoning memory with=
 zero
Applying: mm/ARM64: kill poison_init_mem()
Applying: mm/x86: use free_reserved_area() to simplify code
Applying: mm/tile: use common help functions to free reserved pages
Applying: mm: fix some trivial typos in comments
Applying: mm: use managed_pages to calculate default zonelist order
Applying: mm: accurately calculate zone->managed_pages for highmem zones
Applying: mm: use a dedicated lock to protect totalram_pages and zone->mana=
ged_pages
Applying: mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-manage=
d_pages-fix
Applying: mm: make __free_pages_bootmem() only available at boot time
Applying: mm: correctly update zone->managed_pages
Applying: mm-correctly-update-zone-managed_pages-fix
Applying: mm-correctly-update-zone-managed_pages-fix-fix
Applying: mm-correctly-update-zone-managed_pages-fix-fix-fix
Applying: mm: concentrate modification of totalram_pages into the mm core
Applying: mm: report available pages as "MemTotal" for each NUMA node
Applying: memcg: Kconfig info update
Applying: mm: Fix the TLB range flushed when __tlb_remove_page() runs out o=
f slots
Applying: vmlinux.lds: add comments for global variables and clean up usele=
ss declarations
Applying: avr32: normalize global variables exported by vmlinux.lds
Applying: c6x: normalize global variables exported by vmlinux.lds
Applying: h8300: normalize global variables exported by vmlinux.lds
Applying: score: normalize global variables exported by vmlinux.lds
Applying: tile: normalize global variables exported by vmlinux.lds
Applying: UML: normalize global variables exported by vmlinux.lds
Applying: mm: introduce helper function mem_init_print_info() to simplify m=
em_init()
Applying: mm: use totalram_pages instead of num_physpages at runtime
Applying: mm/hotplug: prepare for removing num_physpages
Applying: mm/alpha: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/ARC: prepare for removing num_physpages and simplify mem_init()
Applying: mm/ARM: prepare for removing num_physpages and simplify mem_init()
Applying: mm/ARM64: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/AVR32: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/blackfin: prepare for removing num_physpages and simplify mem_=
init()
Applying: mm/c6x: prepare for removing num_physpages and simplify mem_init()
Applying: mm/cris: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/frv: prepare for removing num_physpages and simplify mem_init()
Applying: mm/h8300: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/hexagon: prepare for removing num_physpages and simplify mem_i=
nit()
Applying: mm/IA64: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/m32r: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/m68k: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/metag: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/microblaze: prepare for removing num_physpages and simplify me=
m_init()
Applying: mm, arch: fix two errors in calling mem_init_print_info()
Applying: mm/MIPS: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/mn10300: prepare for removing num_physpages and simplify mem_i=
nit()
Applying: mm/openrisc: prepare for removing num_physpages and simplify mem_=
init()
Applying: mm/PARISC: prepare for removing num_physpages and simplify mem_in=
it()
Applying: mm/ppc: prepare for removing num_physpages and simplify mem_init()
Applying: mm/s390: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/score: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/SH: prepare for removing num_physpages and simplify mem_init()
Applying: mm/SPARC: prepare for removing num_physpages and simplify mem_ini=
t()
Applying: mm/tile: prepare for removing num_physpages and simplify mem_init=
()
Applying: mm/um: prepare for removing num_physpages and simplify mem_init()
Applying: mm/unicore32: prepare for removing num_physpages and simplify mem=
_init()
Applying: mm/x86: prepare for removing num_physpages and simplify mem_init()
Applying: mm/xtensa: prepare for removing num_physpages and simplify mem_in=
it()
Applying: mm: kill global variable num_physpages
Applying: mm: introduce helper function set_max_mapnr()
Applying: mm/AVR32: prepare for killing free_all_bootmem_node()
Applying: mm/IA64: prepare for killing free_all_bootmem_node()
Applying: mm/m32r: prepare for killing free_all_bootmem_node()
Applying: mm/m68k: prepare for killing free_all_bootmem_node()
Applying: mm/metag: prepare for killing free_all_bootmem_node()
Applying: mm/MIPS: prepare for killing free_all_bootmem_node()
Applying: mm/PARISC: prepare for killing free_all_bootmem_node()
Applying: mm/PPC: prepare for killing free_all_bootmem_node()
Applying: mm/SH: prepare for killing free_all_bootmem_node()
Applying: mm: kill free_all_bootmem_node()
Applying: mm/alpha: unify mem_init() for both UMA and NUMA architectures
Applying: mm/m68k: fix build warning of unused variable
Applying: mm/ALPHA: clean up unused VALID_PAGE()
Applying: mm/ARM: fix stale comment about VALID_PAGE()
Applying: mm/CRIS: clean up unused VALID_PAGE()
Applying: mm/microblaze: clean up unused VALID_PAGE()
Applying: mm/unicore32: fix stale comment about VALID_PAGE()
Applying: sparsemem: add BUILD_BUG_ON when sizeof mem_section is non-power-=
of-2
Applying: documentation: update address_space_operations
Applying: documentation: document the is_dirty_writeback aops callback
Applying: fs/fs-writeback.c: : make wb_do_writeback() as static
Applying: mm, vmalloc: only call setup_vmalloc_vm() only in __get_vm_area_n=
ode()
Applying: mm, vmalloc: call setup_vmalloc_vm() instead of insert_vmalloc_vm=
()
Applying: mm, vmalloc: remove insert_vmalloc_vm()
Applying: mm, vmalloc: use clamp() to simplify code
Applying: mm: memcontrol: factor out reclaim iterator loading and updating
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
Applying: dcache: convert to use new lru list infrastructure
Applying: list_lru: per-node list infrastructure
Applying: list_lru: per-node API
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
Applying: zswap: add documentation
Applying: MAINTAINERS: add zswap and zbud maintainer
Applying: mm/page_alloc.c: remove zone_type argument of build_zonelists_node
Applying: mm: remove unused functions is_{normal_idx, normal, dma32, dma}
Applying: mm/page_alloc.c: remove unlikely() from the current_order test
Applying: vfree: don't schedule free_work() if llist_add() returns false
Applying: mm: remove unused __put_page()
Applying: mm/sparse.c: put clear_hwpoisoned_pages within CONFIG_MEMORY_HOTR=
EMOVE
Applying: include/linux/mmzone.h: cleanups
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: mm: add vm event counters for balloon pages compaction
Applying: arch/frv/kernel/traps.c: using vsnprintf() instead of vsprintf()
Applying: arch/frv/kernel/setup.c: use strncmp() instead of memcmp()
Applying: err.h: IS_ERR() can accept __user pointers
Applying: clean up scary strncpy(dst, src, strlen(src)) uses
Applying: clean-up-scary-strncpydst-src-strlensrc-uses-fix
Applying: drivers: avoid format string in dev_set_name
Applying: drivers: avoid format strings in names passed to alloc_workqueue()
Applying: drivers: avoid parsing names as kthread_run() format strings
Applying: dump_stack: serialize the output from dump_stack()
Applying: dump_stack-serialize-the-output-from-dump_stack-fix
Applying: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
Applying: panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix
Applying: kernel/sys.c: sys_reboot(): fix malformed panic message
Applying: kernel/sys.c:do_sysinfo(): use get_monotonic_boottime()
Applying: dmi: add support for exact DMI matches in addition to substring m=
atching
Applying: drm/i915: quirk away phantom LVDS on Intel's D510MO mainboard
Applying: drm/i915: quirk away phantom LVDS on Intel's D525MW mainboard
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: drivers/misc/sgi-gru/grufault.c: fix a sanity test in gru_set_con=
text_option()
Applying: MAINTAINERS: fix tape driver file mappings
Applying: backlight: atmel-pwm-bl: remove unnecessary platform_set_drvdata()
Applying: backlight: ep93xx: remove unnecessary platform_set_drvdata()
Applying: backlight: lp8788: remove unnecessary platform_set_drvdata()
Applying: backlight: pcf50633: remove unnecessary platform_set_drvdata()
Applying: backlight: add devm_backlight_device_{register,unregister}()
Applying: lcd: add devm_lcd_device_{register,unregister}()
Applying: MAINTAINERS: add Backlight subsystem co-maintainer
Applying: backlight: convert from legacy pm ops to dev_pm_ops
Applying: backlight: add CONFIG_PM_SLEEP to suspend/resume functions
Applying: rbtree: remove unneeded include
Applying: rbtree-remove-unneeded-include-fix
Applying: radeon: remove redundant __list_for_each definition from mkregtab=
le.c
Applying: ipw2200: convert __list_for_each usage to list_for_each
Applying: list: remove __list_for_each()
Applying: checkpatch: change CamelCase test and make it --strict
Applying: checkpatch: warn when using gcc's binary constant ("0b") extension
Applying: checkpatch: add --strict preference for p =3D kmalloc(sizeof(*p).=
..
Applying: checkpatch: remove quote from CamelCase test
Applying: checkpatch: improve network block comment test and message
Applying: checkpatch: warn when networking block comment lines don't start =
with *
Applying: checkpatch: warn on comparisons to jiffies
Applying: checkpatch: warn on comparisons to get_jiffies_64()
Applying: checkpatch: reduce false positive rate of "complex macros"
Applying: checkpatch: add a placeholder to check blank lines before declara=
tions
Applying: checkpatch: don't warn on blank lines before/after braces as often
Applying: checkpatch: add a --strict test for comparison to true/false
Applying: checkpatch: improve "no space after cast" test
Applying: checkpatch: create an EXPERIMENTAL --fix option to correct patches
Applying: checkpatch: move test for space before semicolon after operator s=
pacing
Applying: checkpatch: ignore SI unit CamelCase variants like "_uV"
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: init: remove permanent string buffer from do_one_initcall()
Applying: insert missing space in printk line of root_delay
Applying: kprobes: handle empty/invalid input to debugfs "enabled" file
Applying: autofs4: allow autofs to work outside the initial PID namespace
Applying: autofs4: translate pids to the right namespace for the daemon
Applying: rtc: rtc-88pm80x: remove unnecessary platform_set_drvdata()
Applying: drivers/rtc/rtc-v3020.c: remove redundant goto
Applying: drivers/rtc/interface.c: fix checkpatch errors
Applying: drivers/rtc/rtc-at32ap700x.c: fix checkpatch error
Applying: drivers/rtc/rtc-at91rm9200.c: include <linux/uaccess.h>
Applying: drivers/rtc/rtc-cmos.c: fix whitespace related errors
Applying: drivers/rtc/rtc-davinci.c: fix whitespace warning
Applying: drivers/rtc/rtc-ds1305.c: add missing braces around sizeof
Applying: drivers/rtc/rtc-ds1374.c: fix spacing related issues
Applying: drivers/rtc/rtc-ds1511.c: fix issues related to spaces and braces
Applying: drivers/rtc/rtc-ds3234.c: fix whitespace issue
Applying: drivers/rtc/rtc-fm3130.c: fix whitespace related issue
Applying: drivers/rtc/rtc-m41t80.c: fix spacing related issue
Applying: drivers/rtc/rtc-max6902.c: remove unwanted spaces
Applying: drivers/rtc/rtc-max77686.c: remove space before semicolon
Applying: drivers/rtc/rtc-max8997.c: remove space before semicolon
Applying: drivers/rtc/rtc-mpc5121.c: remove space before tab
Applying: drivers/rtc/rtc-msm6242.c: use pr_warn
Applying: drivers/rtc/rtc-mxc.c: fix checkpatch error
Applying: drivers/rtc/rtc-omap.c: include <linux/io.h> instead of <asm/io.h>
Applying: drivers/rtc/rtc-pcf2123.c: remove space before tabs
Applying: drivers/rtc/rtc-pcf8583.c: move assignment outside if condition
Applying: drivers/rtc/rtc-rs5c313.c: include <linux/io.h> instead of <asm/i=
o.h>
Applying: drivers/rtc/rtc-rs5c313.c: fix spacing related issues
Applying: drivers/rtc/rtc-v3020.c: fix spacing issues
Applying: drivers/rtc/rtc-vr41xx.c: fix spacing issues
Applying: drivers/rtc/rtc-x1205.c: fix checkpatch issues
Applying: rtc: rtc-88pm860x: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-ab3100: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-ab8500: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-at32ap700x: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-at91rm9200: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-at91sam9: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-au1xxx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-bfin: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-bq4802: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-coh901331: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-da9052: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-da9055: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-davinci: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-dm355evm: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-ds1302: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-ep93xx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-jz4740: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-lp8788: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-lpc32xx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-ls1x: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-m48t59: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-max8925: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-max8998: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-mc13xxx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-msm6242: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-mxc: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-nuc900: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-pcap: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-pm8xxx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-s3c: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-sa1100: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-sh: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-spear: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-stmp3xxx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-twl: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-vr41xx: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-vt8500: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-m48t86: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-puv3: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-rp5c01: remove unnecessary platform_set_drvdata()
Applying: rtc: rtc-tile: remove unnecessary platform_set_drvdata()
Applying: drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
Applying: drivers/rtc/rtc-m48t86.c: remove empty function
Applying: drivers/rtc/rtc-tile.c: remove empty function
Applying: drivers/rtc/rtc-nuc900.c: remove empty function
Applying: drivers/rtc/rtc-msm6242.c: remove empty function
Applying: drivers/rtc/rtc-max8998.c: remove empty function
Applying: drivers/rtc/rtc-max8925.c: remove empty function
Applying: drivers/rtc/rtc-ls1x.c: remove empty function
Applying: drivers/rtc/rtc-lp8788.c: remove empty function
Applying: drivers/rtc/rtc-ds1302.c: remove empty function
Applying: drivers/rtc/rtc-dm355evm.c: remove empty function
Applying: drivers/rtc/rtc-da9055.c: remove empty function
Applying: drivers/rtc/rtc-da9052.c: remove empty function
Applying: drivers/rtc/rtc-bq4802.c: remove empty function
Applying: drivers/rtc/rtc-au1xxx.c: remove empty function
Applying: drivers/rtc/rtc-ab3100.c: remove empty function
Applying: rtc: rtc-hid-sensor-time: allow full years (16bit) in HID reports
Applying: rtc: rtc-hid-sensor-time: allow 16 and 32 bit values for all attr=
ibutes.
Applying: rtc: add ability to push out an existing wakealarm using sysfs
Applying: drivers/rtc/rtc-vr41xx.c: fix error return code in rtc_probe()
Applying: rtc: rtc-ds1307: use devm_*() functions
Applying: rtc: rtc-jz4740: use devm_*() functions
Applying: rtc: rtc-mpc5121: use devm_*() functions
Applying: rtc: rtc-m48t59: use devm_*() functions
Applying: rtc: rtc-pm8xxx: use devm_*() functions
Applying: rtc: rtc-pxa: use devm_*() functions
Applying: rtc: rtc-rx8025: use devm_*() functions
Applying: rtc: rtc-sh: use devm_*() functions
Applying: rtc: rtc-coh901331: use platform_{get,set}_drvdata()
Applying: rtc: rtc-rc5t583: use platform_{get,set}_drvdata()
Applying: drivers/rtc/rtc-bq32k.c: remove empty function
Applying: drivers/rtc/rtc-ds1216.c: remove empty function
Applying: drivers/rtc/rtc-ds1286.c: remove empty function
Applying: drivers/rtc/rtc-ds1672.c: remove empty function
Applying: drivers/rtc/rtc-ds3234.c: remove empty function
Applying: drivers/rtc/rtc-ds1390.c: remove empty function
Applying: drivers/rtc/rtc-efi.c: remove empty function
Applying: drivers/rtc/rtc-em3027.c: remove empty function
Applying: drivers/rtc/rtc-fm3130.c: remove empty function
Applying: drivers/rtc/rtc-isl12022.c: remove empty function
Applying: drivers/rtc/rtc-m41t93.c: remove empty function
Applying: drivers/rtc/rtc-m48t35.c: remove empty function
Applying: drivers/rtc/rtc-generic.c: remove empty function
Applying: drivers/rtc/rtc-m41t94.c: remove empty function
Applying: drivers/rtc/rtc-max6902.c: remove empty function
Applying: drivers/rtc/rtc-max6900.c: remove empty function
Applying: drivers/rtc/rtc-max8907.c: remove empty function
Applying: drivers/rtc/rtc-max77686.c: remove empty function
Applying: drivers/rtc/rtc-max8997.c: remove empty function
Applying: drivers/rtc/rtc-pcf8523.c: remove empty function
Applying: drivers/rtc/rtc-pcf8563.c: remove empty function
Applying: drivers/rtc/rtc-pcf8583.c: remove empty function
Applying: drivers/rtc/rtc-ps3.c: remove empty function
Applying: drivers/rtc/rtc-rs5c313.c: remove empty function
Applying: drivers/rtc/rtc-rv3029c2.c: remove empty function
Applying: drivers/rtc/rtc-rx4581.c: remove empty function
Applying: drivers/rtc/rtc-rs5c348.c: remove empty function
Applying: drivers/rtc/rtc-rx8581.c: remove empty function
Applying: drivers/rtc/rtc-snvs.c: remove empty function
Applying: drivers/rtc/rtc-starfire.c: remove empty function
Applying: drivers/rtc/rtc-sun4v.c: remove empty function
Applying: drivers/rtc/rtc-tps80031.c: remove empty function
Applying: drivers/rtc/rtc-wm831x.c: remove empty function
Applying: drivers/rtc/rtc-ab8500.c: add second resolution to rtc driver
Applying: drivers/rtc/rtc-ds1302.c: handle write protection
Applying: drivers/rtc/rtc-mpc5121.c: use platform_{get,set}_drvdata()
Applying: drivers/rtc/rtc-da9052.c: use PTR_RET()
Applying: drivers/rtc/rtc-isl12022.c: use PTR_RET()
Applying: drivers/rtc/rtc-m48t35.c: use PTR_RET()
Applying: drivers/rtc/rtc-pcf8563.c: use PTR_RET()
Applying: drivers/rtc/rtc-pcf8583.c: use PTR_RET()
Applying: drivers/rtc/rtc-twl.c: ensure IRQ is wakeup enabled
Applying: drivers/rtc/rtc-cmos.c: work around bios clearing rtc control
Applying: drivers/rtc/rtc-twl.c: fix rtc_reg_map initialization
Applying: drivers/rtc/rtc-twl.c: cleanup with module_platform_driver() conv=
ersion
Applying: drivers/rtc/interface.c: return -EBUSY, not -EACCES when device i=
s busy
Applying: drivers/rtc/rtc-pcf2123.c: replace strict_strtoul() with kstrtoul=
()
Applying: drivers/rtc/class: convert from Legacy pm ops to dev_pm_ops
Applying: nilfs2: implement calculation of free inodes count
Applying: ] nilfs2: use atomic64_t type for inodes_count and blocks_count f=
ields in nilfs_root struct
Applying: fs/fat: use fat_msg() to replace printk() in __fat_fs_error()
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: Documentation/CodingStyle: allow multiple return statements per f=
unction
Applying: docbook: add futexes to kernel-locking docbook
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
Applying: x86: kill TIF_DEBUG
Applying: ptrace: add ability to get/set signal-blocked mask
Applying: ptrace-add-ability-to-get-set-signal-blocked-mask-fix
Applying: usermodehelper: kill the sub_info->path[0] check
Applying: coredump: format_corename() can leak cn->corename
Applying: coredump: introduce cn_vprintf()
Applying: coredump: cn_vprintf() has no reason to call vsnprintf() twice
Applying: coredump: kill cn_escape(), introduce cn_esc_printf()
Applying: coredump: kill call_count, add core_name_size
Applying: coredump: '% at the end' shouldn't bypass core_uses_pid logic
Applying: coredump: avoid the uninitialized cn->corename if core_pattern is=
 empty
Applying: fs/exec.c:de_thread(): use change_pid() rather than detach_pid/at=
tach_pid
Applying: move-exit_task_namespaces-outside-of-exit_notify-fix
Applying: exit.c: unexport __set_special_pids()
Applying: fs/proc/uptime.c:uptime_proc_show(): use get_monotonic_boottime()
Applying: fork: reorder permissions when violating number of processes limi=
ts
Applying: kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_=
leader code
Applying: kernel/fork.c:copy_process(): don't add the uninitialized child t=
o thread/task/pid lists
Applying: kernel/fork.c:copy_process(): consolidate the lockless CLONE_THRE=
AD checks
Applying: fs/exec.c: do_execve_common(): use current_user()
Applying: fs/exec.c:de_thread: mt-exec should update ->real_start_time
Applying: /dev/oldmem: Remove the interface
Applying: dev-oldmem-remove-the-interface-fix
Applying: Documentation/kdump/kdump.txt: remove /dev/oldmem description
Applying: mips: remove savemaxmem parameter setup
Applying: powerpc: Remove savemaxmem parameter setup
Applying: ia64: remove setting for saved_max_pfn
Applying: s390: remove setting for saved_max_pfn
Applying: idr: print a stack dump after ida_remove warning
Applying: idr-print-a-stack-dump-after-ida_remove-warning-fix
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
Applying: rapidio/switches: remove tsi500 driver
Applying: drivers/rapidio/rio-scan.c: make functions static
Applying: kernel/pid.c: move statement
Applying: nbd: remove bogus BUG_ON in NBD_CLEAR_QUE
Applying: Documentation/accounting/getdelays.c: avoid strncpy in accounting=
 tool
Applying: documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-t=
ool-fix
Applying: drivers/parport/share.c: use kzalloc
Applying: drivers/pps/clients/pps-gpio.c: convert to devm_* helpers
Applying: drivers/pps/clients/pps-gpio.c: convert to module_platform_driver
Applying: pps-gpio: add device-tree binding and support
Applying: drivers/memstick/host/jmb38x_ms: convert to module_pci_driver
Applying: drivers/memstick/host/r592.c: convert to module_pci_driver
Applying: drivers/w1/slaves/w1_ds2408.c: add magic sequence to disable P0 t=
est mode
Applying: drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-tes=
t-mode-fix
Applying: relay: fix timer madness
Applying: kernel/resource.c: remove the unneeded assignment in function __f=
ind_resource
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
Applying: scripts/sortextable.c: fix building on non-Linux systems
Applying: staging/lustre/ldlm: convert to shrinkers to count/scan API
Applying: staging/lustre/obdclass: convert lu_object shrinker to count/scan=
 API
Applying: staging/lustre/ptlrpc: convert to new shrinker API
Applying: staging/lustre/libcfs: cleanup linux-mem.h
Applying: staging/lustre: replace num_physpages with totalram_pages
Merging akpm/master (258e93a staging/lustre: replace num_physpages with tot=
alram_pages)
Merging cpuinit/master (47d52b2e block: delete __cpuinit usage from all blo=
ck files)

--Signature=_Thu__27_Jun_2013_19_24_16_+1000_bZbiMos=PbC.EugH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRzATFAAoJEECxmPOUX5FEoZMP/1/Lg23vIky5BR74Q9P3vxVJ
0l+dCFHXblVdGkEi7FwTeYCl715tZfFShTxuZov8ujXNLCBFhIHSiJa8tAoJyG1X
hUngqfiyQVginqn6VHOQybsVf0LrpsnTpz34ADNzSFIm+oFbg7D0Zu1GzKGVmHgs
2QAJsd22N/0ZbDzPcXl7Jaznpmkc/Yjb8EXUwgXixGxGctoMdrD/aoDrJzntfe23
pT1qS0bsrEBlk1GwEtehBeeo6kvK5v3HOnB8bNL0+etaP1SkD8t0PQyh+3v0R7WT
+6G+YM1O+w7ENG6X1oP13NshO6X6PFyDCeNq7ll111tOZANbza2SwegDrdw3RN0j
C6cA/cCvAWA719MmbaZ4ThZlXvJiZEfHJKq/kp2orzvXIbOWCpiTTDqiFpa1Gbbr
MsaI2zYMtkLI6eW04RL5fmFh5P041HB43weyz5kCowa8jA1ZpqjaBkndBl7+BSaL
iAChF2uAbS1AGtTZkzEig/esCC6pZp31n7zoy3oGB4PUeH7Z4rkQnh5K0DYL55GM
sLW6hWulpG9c0G+kdZnim3Keb/hRNL4OYU4ZOAQFQU7wA6KXc9t8AEL+CZULcPjS
2QO4BKJgAdCz0hydEyeVd3caMPOj9uAhaVXyNoS1nRoPEqnoQWSaVIMdSESfV7D2
P2xEx8T+t+c3/a+o87/o
=oLMI
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_19_24_16_+1000_bZbiMos=PbC.EugH--
