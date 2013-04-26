Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab3DZIEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:04:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46640 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3DZIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:04:07 -0400
Date: Fri, 26 Apr 2013 18:03:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Apr 26
Message-Id: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_18_03_57_+1000_WsbRG=KMMICT4EG7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_18_03_57_+1000_WsbRG=KMMICT4EG7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130424:

Removed tree: ppc-temp (remerged into powerpc)

The net-next tree gained conflicts against the net and pci trees and a
build failure for which I applied a merge fix patch.

The omap_dss2 tree gained a build failure so I used the version from
next-20130424.

The trivial tree gained a conflict against the arm tree.

The staging tree still had its build failure for which I applied a
supplied patch.

The arm-soc tree gained a conflict against the spi-mb tree.

The renesas tree gained a conflict against the input tree.

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

We are up to 224 trees (counting Linus' and 31 trees of patches pending
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
Merging origin/master (697dfd8 Merge tag 'efi-urgent' into x86/urgent)
Merging fixes/master (96d8683 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/sage/ceph-client)
Merging kbuild-current/rc-fixes (a54292f kbuild: generate generic headers b=
efore recursing into scripts)
Merging arc-current/for-curr (ce797e9 ARC: [mm] Lazy D-cache flush (non ali=
asing VIPT))
Merging arm-current/fixes (60d509f Linux 3.9-rc8)
Merging m68k-current/for-linus (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs.=
 CONFIG_HAS_DMA)
Merging powerpc-merge/merge (5676005 powerpc/pseries/lparcfg: Fix possible =
overflow are more than 1026)
Merging sparc/master (0fbd067 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/sparc)
Merging net/master (c6cdcf6 bonding: fix locking in enslave failure path)
Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging sound-current/for-linus (c5a4698 Merge tag 'asoc-maintainers-v3.9-r=
c6' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for=
-linus)
Merging pci-current/for-linus (de7d5f7 PCI/PM: Disable runtime PM of PCIe p=
orts)
Merging wireless/master (f09a878 ath9k_hw: change AR9580 initvals to fix a =
stability issue)
Merging driver-core.current/driver-core-linus (41ef2d5 Linux 3.9-rc7)
Merging tty.current/tty-linus (41ef2d5 Linux 3.9-rc7)
Merging usb.current/usb-linus (31880c3 Linux 3.9-rc6)
Merging staging.current/staging-linus (41ef2d5 Linux 3.9-rc7)
Merging char-misc.current/char-misc-linus (41ef2d5 Linux 3.9-rc7)
Merging input-current/for-linus (5846115 Input: wacom - fix "can not retrie=
ve extra class descriptor" for DTH2242)
Merging md-current/for-linus (238f590 md: remove CONFIG_MULTICORE_RAID456 e=
ntirely)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (72a763d crypto: algif - suppress sending sou=
rce address information in recvmsg)
Merging ide/master (bf6b438 ide: gayle: use module_platform_driver_probe())
Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (ab28698 of: define struct devi=
ce in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
Merging spi-current/spi/merge (0d2d0cc spi/davinci: fix module build error)
Merging gpio-current/gpio/merge (e97f9b5 gpio/gpio-ich: fix ichx_gpio_check=
_available() return what callers expect)
Merging rr-fixes/fixes (9ba5c80 virtio: console: add locking around c_ovq o=
perations)
Merging mfd-fixes/master (31880c3 Linux 3.9-rc6)
Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overfl=
ow)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (07961ac Linux 3.9-rc5)
Merging arm/for-next (1b189b0 Merge branches 'devel-stable', 'entry', 'fixe=
s', 'mach-types' and 'misc' into for-next)
Merging arm-perf/for-next/perf (ab87304 Merge branches 'perf/fixes' and 'hw=
-breakpoint' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
Merging arm64/upstream (39a90ca arm64: Survive invalid cpu enable-methods)
Merging blackfin/for-linus (f656c24 blackfin: time-ts: Remove duplicate ass=
ignment)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (90712ac CRIS: remove unused current_regs)
Merging hexagon/linux-next (e0e34de Hexagon: add v4 CS regs to core copyout=
 macro)
Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
Merging m68k/for-next (e00c73e m68k: Remove inline strlen() implementation)
Merging m68knommu/for-next (4f24620 m68k: define a local gpio_request_one()=
 function)
Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB=
 =3D> 128KiB)
Merging microblaze/next (01cc2cb microblaze: intc: set the default irq_doma=
in)
Merging mips/mips-for-linux-next (6eac6e6 Merge branches 'next/3.9-fixes', =
'next/kvm' and 'next/micromips' into mips-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (6263fb3 powerpc/powernv: Fix missing Kconfig dependen=
cy for MSIs)
CONFLICT (content): Merge conflict in arch/metag/mm/Kconfig
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (0d76b3d3 powerpc/512x: add ifm ac14xx board)
Merging galak/next (f0b0b48 powerpc/85xx: Fix MPC8536DS 36-bit device tree)
Applying: powerpc: fix usage of setup_pci_atmu()
Merging s390/features (b8668fd s390/uapi: change struct statfs[64] member t=
ypes to unsigned values)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
Merging sparc-next/master (07df841 sparc64: Do not save/restore interrupts =
in get_new_mmu_context())
Merging tile/master (9fc1894 arch/tile: Fix syscall return value passed to =
tracepoint)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (4e34bf6 xtensa: provide default platform_pcibios_i=
nit implementation)
Merging btrfs/next (6aec51f Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into for-linus-3.9)
Merging ceph/testing (42c6070 libceph: fix byte order mismatch)
CONFLICT (content): Merge conflict in net/ceph/osdmap.c
CONFLICT (content): Merge conflict in fs/ceph/addr.c
CONFLICT (content): Merge conflict in drivers/block/rbd.c
Merging cifs/for-next (bf81710 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/nab/target-pending)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
Merging ext3/for_next (e162b2f jbd: use kmem_cache_zalloc instead of kmem_c=
ache_alloc/memset)
Merging ext4/dev (0d606e2 ext4: fix type-widening bug in inode table readah=
ead code)
Merging f2fs/dev (2af4bd6 f2fs: add tracepoints to debug checkpoint request)
Merging fuse/for-next (efb9fa9 fuse: truncate file if async dio failed)
Merging gfs2/master (7bd8b2e GFS2: Add origin indicator to glock demote tra=
cing)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (b0212b8 Merge branch 'bugfixes' into linux-next)
Merging nfsd/nfsd-next (bf8d909 nfsd: Decode and send 64bit time values)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
Merging ubifs/linux-next (67e753c UBIFS: make space fixup work in the remou=
nt case)
Merging xfs/for-next (7fe3258 xfs: Update xfs_log_commit_cil() comments)
CONFLICT (content): Merge conflict in fs/xfs/xfs_iomap.c
Merging vfs/for-next (05c0ae2 try a saner locking for pde_opener...)
Merging pci/next (d4f09c5 Merge branch 'pci/gavin-msi-cleanup' into next)
Merging hid/for-next (2c84fa4 Merge branch 'for-3.10/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (c39e8e4 i2c: xiic: must always write 16-bit words=
 to TX_FIFO)
Merging jdelvare-hwmon/master (c662b7a hwmon: (lm75) Add support for the Da=
llas/Maxim DS7505)
Merging hwmon-staging/hwmon-next (6445e66 hwmon: (nct6775) Fix coding style=
 problems)
Merging v4l-dvb/master (0007da6 Merge /home/v4l/v4l/patchwork)
CONFLICT (content): Merge conflict in drivers/staging/media/go7007/go7007-d=
river.c
CONFLICT (content): Merge conflict in drivers/media/platform/Kconfig
CONFLICT (content): Merge conflict in drivers/media/pci/bt8xx/bttv-input.c
Applying: i2c: fixup for code movement from bttv_input.c
Merging kbuild/for-next (c67dcb4 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (3f1317a2b [libata] SCSI: really use SATL version in VP=
D)
Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into =
for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (c69a76b Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
CONFLICT (content): Merge conflict in drivers/acpi/scan.c
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (07273d2 Merge branch 'cpu_cooling-doc-comments-update=
' of .git into next)
Merging ieee1394/for-next (6dbe51c Linux 3.9-rc1)
Merging ubi/linux-next (f6161aa Linux 3.9-rc2)
Merging dlm/next (9000831 dlm: avoid unnecessary posix unlock)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (73b22ec Merge branch 'misc' into for-next)
Merging target-updates/for-next (04b59ba tcm_vhost: Enable VIRTIO_SCSI_F_HO=
TPLUG)
Merging target-merge/for-next-merge (b8d26b3 iser-target: Add iSCSI Extensi=
ons for RDMA (iSER) target driver)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (0b03930 Merge branch 'for-linus' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (37fe066 net: fix address check in rtnl_fdb_del)
CONFLICT (content): Merge conflict in include/net/tcp.h
CONFLICT (content): Merge conflict in include/linux/pci.h
CONFLICT (content): Merge conflict in drivers/net/ethernet/emulex/benet/be.h
CONFLICT (content): Merge conflict in drivers/net/ethernet/broadcom/bnx2x/b=
nx2x_main.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb4/qp.c
Applying: drivers:net: fix up for code movement from rt2x00pci.c
Applying: tcp: merge fixup for movemenet of tcp_prequeue
Applying: be2net: merge fix for __vlan_put_tag() API change
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (b006ed5 mwifiex: rework round robin schedulin=
g of bss nodes.)
Merging bluetooth/master (69676b1 Bluetooth: btmrvl: report error if verify=
_fw_download times out)
Merging mtd/master (cdb6404 mtd: omap2: Use module_platform_driver())
Merging l2-mtd/master (98927a2 mtd: get the ECC info from the parameter pag=
e for ONFI nand)
Merging crypto/master (3862de1 crypto: caam - fix job ring cleanup code)
Merging drm/drm-next (17f0efc drm/shmobile: Fix race condition between page=
 flip request and handler)
Merging drm-intel/drm-intel-next-queued (ab3e67f drm/i915: warn about inval=
id pfit modes)
Merging sound/for-next (2fc565e Merge tag 'asoc-v3.10-3' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/broonie/sound into for-next)
Merging sound-asoc/for-next (5cc50fc8 Merge remote-tracking branch 'asoc/to=
pic/ux500' into asoc-next)
Merging modules/modules-next (04b00bd X.509: Support parse long form of len=
gth octets in Authority Key Identifier)
Merging virtio/virtio-next (6b39271 lguest: map Switcher below fixmap.)
CONFLICT (content): Merge conflict in drivers/char/virtio_console.c
Merging input/next (0c6a616 Input: trackpoint - Optimize trackpoint init to=
 use power-on reset)
Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in co=
re)
Merging cgroup/for-next (712317a cgroup: fix broken file xattrs)
CONFLICT (content): Merge conflict in include/linux/res_counter.h
Merging block/for-next (d9e60e8 Merge branch 'for-3.10/core' into for-next)
CONFLICT (content): Merge conflict in drivers/block/drbd/drbd_proc.c
Merging device-mapper/master (f8efabf This patch uses memalloc_noio_save to=
 avoid a possible deadlock in dm-bufio.  (it could happen only with large b=
lock size, at most PAGE_SIZE << MAX_ORDER (typically 8MiB).)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (e4404fa mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (7cccd80 slub: tid must be retrieved from the percpu =
area of the current processor)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (3a25a39 md: raid1/raid10 md devices leak memory when s=
topping)
Merging mfd/master (4adedc5 mfd: si476x: Fix i2c warning)
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpuidle.c
Merging battery/master (6b17080 pm2301-charger: Fix suspend/resume)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (c4d95b9 Merge branch '3.10/fb-mmap' into for-ne=
xt)
$ git reset --hard HEAD^
Merging 20130424 version of omap_dss2
CONFLICT (content): Merge conflict in drivers/video/fbmon.c
Merging regulator/for-next (e7ecd16 Merge remote-tracking branch 'regulator=
/topic/wm8994' into regulator-next)
Merging security/next (b7ae9f0 Merge branch 'tpmdd-04-17-13' of git://githu=
b.com/shpedoikal/linux into my-next)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (69c6612 watchdog: Fix race condition in registrati=
on code)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (d4df35e2 Merge branches 'iommu/fixes', 'x86/vt-d', 'x86=
/amd', 'ppc/pamu' and 'core' into next)
Merging vfio/next (aa2cba5 PCI/VFIO: use pcie_flags_reg instead of access P=
CI-E Capabilities Register)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (7f5281a x86 cmpxchg.h: fix wrong comment)
CONFLICT (content): Merge conflict in arch/arm/kvm/arm.c
CONFLICT (modify/delete): Documentation/virtual/virtio-spec.txt deleted in =
HEAD and modified in trivial/for-next. Version trivial/for-next of Document=
ation/virtual/virtio-spec.txt left in tree.
$ git rm -f Documentation/virtual/virtio-spec.txt
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (b076989 i5100_edac: convert to use simple_open())
Merging edac-amd/for-next (9713fae EDAC: Merge mci.mem_is_per_rank with mci=
.csbased)
Merging devicetree/devicetree/next (d347bc5 Merge branch 'robherring/for-ne=
xt' from git://sources.calxeda.com/kernel/linux.git)
Merging dt-rh/for-next (a2b9ea7 Documentation/devicetree: make semantic of =
initrd-end more explicit)
Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the defaul=
t pin configuration)
CONFLICT (content): Merge conflict in MAINTAINERS
Merging spi-mb/for-next (0113f22 spi-topcliff-pch: missing platform_driver_=
unregister() on error in pch_spi_init())
Merging tip/auto-latest (f3ecdf1 Merge branch 'x86/ras')
CONFLICT (content): Merge conflict in tools/Makefile
CONFLICT (content): Merge conflict in include/linux/clockchips.h
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being=
 added)
CONFLICT (content): Merge conflict in kernel/trace/trace.c
CONFLICT (content): Merge conflict in kernel/trace/ftrace.c
Merging rcu/rcu/next (a9be854 Merge commit '6d87669357936bffa1e8fea7a4e7743=
e76905736' into next.2013.10.22a)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (660696d KVM: X86 emulator: fix source operand decod=
ing for 8bit mov[zs]x instructions)
CONFLICT (content): Merge conflict in drivers/s390/kvm/virtio_ccw.c
CONFLICT (content): Merge conflict in arch/s390/mm/pgtable.c
Merging kvm-arm/kvm-arm-next (b8022d7 arm: kvm: arch_timer: use symbolic co=
nstants)
Merging kvm-ppc/kvm-ppc-next (be28a27 kvm/ppc: don't call complete_mmio_loa=
d when it's a store)
Merging oprofile/for-next (23995bb oprofile, s390: Add support for IBM zEnt=
erprise EC12)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (6461b07 Merge branch 'stable/for-linus-3.10' in=
to linux-next)
Merging xen-arm/linux-next (6abb749 xen/arm: use sched_op hypercalls for ma=
chine reboot and power off)
Merging percpu/for-next (a1b2a55 percpu: add documentation on this_cpu oper=
ations)
Merging workqueues/for-next (46aed11 Merge branch 'for-3.10' into for-next)
Merging drivers-x86/linux-next (e6e5224 ideapad-laptop: Depend on BACKLIGHT=
_CLASS_DEVICE instead of selecting it)
CONFLICT (content): Merge conflict in drivers/platform/x86/chromeos_laptop.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (38a8179 Merge remote-tracking branch 'regmap/topic=
/range' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (df92d5f leds: leds-asic3: switch to using SIMPLE_DEV=
_PM_OPS)
Merging driver-core/driver-core-next (0d1d392 Merge 3.9-rc7 into driver-cor=
e-next)
CONFLICT (content): Merge conflict in kernel/rtmutex-tester.c
Merging tty/tty-next (45efcb2 tty/serial/sirf: fix MODULE_DEVICE_TABLE)
Merging usb/usb-next (4626b8d USB: ehci-msm: USB_MSM_OTG needs USB_PHY)
CONFLICT (content): Merge conflict in drivers/usb/serial/usb-serial.c
Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
Merging staging/staging-next (a0eeed4 staging: comedi: ni_labpc: fix legacy=
 driver build)
CONFLICT (content): Merge conflict in drivers/staging/vt6655/device_main.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_specproc.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_ports_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_net_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_mon_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_dpa_ops.c
CONFLICT (modify/delete): drivers/staging/ccg/rndis.c deleted in staging/st=
aging-next and modified in HEAD. Version HEAD of drivers/staging/ccg/rndis.=
c left in tree.
CONFLICT (modify/delete): drivers/staging/ccg/f_fs.c deleted in staging/sta=
ging-next and modified in HEAD. Version HEAD of drivers/staging/ccg/f_fs.c =
left in tree.
$ git rm -f drivers/staging/ccg/f_fs.c drivers/staging/ccg/rndis.c
Applying: staging: comedi: ni_labpc: fix build when VIRT_TO_BUS is not defi=
ned
Merging char-misc/char-misc-next (0e27263 Tools: hv: Fix a checkpatch warni=
ng)
CONFLICT (content): Merge conflict in drivers/misc/mei/interrupt.c
CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
Merging bcon/master (06c6942 blockconsole: Mark a local work struct static)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (bffa963 Merge branch 'devel' into for-next)
Merging vhost/linux-next (4697e2c kvm: add PV MMIO EVENTFD)
CONFLICT (content): Merge conflict in virt/kvm/eventfd.c
CONFLICT (content): Merge conflict in include/uapi/linux/kvm.h
CONFLICT (content): Merge conflict in include/linux/kvm_host.h
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
CONFLICT (content): Merge conflict in drivers/remoteproc/Kconfig
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (753c598 gpio/em: Add Device Tree support)
Merging gpio-lw/for-next (d350de5 Merge branch 'next' into for-next)
Merging gen-gpio/for_next (f4c5405 gpio: update gpio Chinese documentation)
CONFLICT (modify/delete): drivers/usb/otg/Kconfig deleted in HEAD and modif=
ied in gen-gpio/for_next. Version gen-gpio/for_next of drivers/usb/otg/Kcon=
fig left in tree.
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
$ git rm -f drivers/usb/otg/Kconfig
Applying: gen-gpio: GPIOLIB merge fix up
Applying: merge fix for Convert selectors of GENERIC_GPIO to GPIOLIB
Applying: merge fix 2 for Convert selectors of GENERIC_GPIO to GPIOLIB
Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of s=
izeof in mailbox_msg_send())
Merging arm-soc/for-next (c4c618f Merge branch 'next/drivers' into for-next)
CONFLICT (content): Merge conflict in drivers/usb/host/ohci-exynos.c
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-samsung.h
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-samsung.c
CONFLICT (content): Merge conflict in drivers/pinctrl/Makefile
CONFLICT (modify/delete): drivers/gpio/gpio-vt8500.c deleted in arm-soc/for=
-next and modified in HEAD. Version HEAD of drivers/gpio/gpio-vt8500.c left=
 in tree.
CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (content): Merge conflict in arch/arm/plat-orion/Makefile
CONFLICT (add/add): Merge conflict in arch/arm/mach-zynq/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/tegra.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadill=
o800eva.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2443.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2440.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2412.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/dma-s3c2410.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/omap_hwmod.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
CONFLICT (modify/delete): arch/arm/mach-imx/cpufreq.c deleted in arm-soc/fo=
r-next and modified in HEAD. Version HEAD of arch/arm/mach-imx/cpufreq.c le=
ft in tree.
CONFLICT (content): Merge conflict in arch/arm/mach-highbank/highbank.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/at91sam9x5.dtsi
$ git rm -f drivers/gpio/gpio-vt8500.c arch/arm/mach-imx/cpufreq.c
Merging bcm2835/for-next (31880c3 Linux 3.9-rc6)
Merging cortex/for-next (4477ca4 ARM: ARMv7-M: Allow the building of new ke=
rnel port)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (3795b56 Merge branches 'mxs/dt-3.11' and 'imx/dt-=
3.11' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (1df357a Merge branch 'msm-defconfig' into for-next)
Merging renesas/next (0eabbd4 Merge branch 'heads/soc-sh73a0' into next)
CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadill=
o800eva.c
Merging samsung/for-next (e0f8f91 Merge branch 'next/late-exynos' into for-=
next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/cpuidle.c
Merging tegra/for-next (c0c1cb1 Merge branch 'for-3.10/defconfig' into for-=
next)
Merging dma-mapping/dma-mapping-next (a937536 Linux 3.9-rc3)
Merging pwm/for-next (affb923 pwm: lpc32xx: Don't change PWM_ENABLE bit in =
lpc32xx_pwm_config)
Merging dma-buf/for-next (5320c97 dma-buf: double unlock in debugfs code)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of=
 macros)
CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
CONFLICT (content): Merge conflict in fs/splice.c
CONFLICT (content): Merge conflict in fs/read_write.h
CONFLICT (content): Merge conflict in fs/read_write.c
CONFLICT (content): Merge conflict in fs/compat.c
CONFLICT (content): Merge conflict in arch/tile/kernel/compat.c
CONFLICT (content): Merge conflict in arch/tile/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
Applying: cond_syscall and SYSCALL_ALIAS merge fixup
Merging clk/clk-next (c700835 clk: ux500: fix mismatched types)
CONFLICT (content): Merge conflict in drivers/clk/mvebu/clk-core.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (0fbd067 Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/sparc)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: revert "ipc: don't allocate a copy larger than max"
Applying: drivers/char/random.c: fix priming of last_data
Applying: kthread: introduce to_live_kthread()
Applying: kthread: kill task_get_live_kthread()
Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: kernel/auditsc.c: use kzalloc instead of kmalloc+memset
Applying: auditsc-use-kzalloc-instead-of-kmallocmemset-fix
Applying: audit: don't check if kauditd is valid every time
Applying: audit: remove duplicate export of audit_enabled
Applying: audit: remove unnecessary #if CONFIG_AUDIT
Applying: kernel/auditfilter.c: tree and watch will memory leak when failur=
e occurs
Applying: kernel/audit_tree.c: tree will leak memory when failure occurs in=
 audit_trim_trees()
Applying: kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-a=
udit_trim_trees-fix
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: matroxfb: convert struct i2c_msg initialization to C99 format
Applying: drivers/video/console/fbcon_cw.c: fix compiler warning in cw_upda=
te_attr
Applying: drivers/video: add Hyper-V Synthetic Video Frame Buffer Driver
Applying: video: fix a type warning in hyperv_fb.c
Applying: drivers/video/exynos/exynos_mipi_dsi.c: convert to devm_ioremap_r=
esource()
Applying: drivers/video/ep93xx-fb.c: fix section mismatch and use module_pl=
atform_driver
Applying: drivers/video/mmp: remove legacy hw definitions
Applying: drivers/video: implement a simple framebuffer driver
Applying: drivers-video-implement-a-simple-framebuffer-driver-fix
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: fs/fscache/stats.c: fix memory leak
Applying: inotify: invalid mask should return a error number but not set it
Applying: inotify-invalid-mask-should-return-a-error-number-but-not-set-it-=
fix
Applying: posix_cpu_timer: consolidate expiry time type
Applying: posix_cpu_timers: consolidate timer list cleanups
Applying: posix_cpu_timers: consolidate expired timers check
Applying: selftests: add basic posix timers selftests
Applying: posix-timers: correctly get dying task time sample in posix_cpu_t=
imer_schedule()
Applying: posix_timers: Fix racy timer delta caching on task exit
Applying: mkcapflags.pl: convert to mkcapflags.sh
Applying: scripts/decodecode: make faulting insn ptr more robust
Applying: include/linux/mfd/si476x-core.h: don't use 0bNNN
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: ocfs2: delay inode update transactions after verifying the input =
flags
Applying: ocfs2: fix error return code in ocfs2_info_handle_freefrag()
Applying: ocfs2: fix error handling in ocfs2_ioctl_move_extents()
Applying: ocfs2: fix NULL dereference for moving extents
Applying: debug_locks.h: make warning more verbose
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: drivers/block/mg_disk.c: add CONFIG_PM_SLEEP to suspend/resume fu=
nctions
Applying: fs/block_dev.c: fix iov_shorten() criteria in blkdev_aio_read()
Applying: cciss: add cciss_allow_hpsa module parameter
Applying: cciss: bug fix to prevent cciss from loading in kdump crash kernel
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: fs/dcache.c: add cond_resched() to shrink_dcache_parent()
Applying: fs/read_write.c: fix generic_file_llseek() comment
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: HWPOISON: check dirty flag to match against clean page
Applying: mm: trace filemap add and del
Applying: mm-trace-filemap-add-and-del-v2
Applying: mm, show_mem: suppress page counts in non-blockable contexts
Applying: mm/shmem.c: remove an ifdef
Applying: vm: adjust ifdef for TINY_RCU
Applying: mm: frontswap: lazy initialization to allow tmem backends to buil=
d/run as modules
Applying: frontswap: make frontswap_init use a pointer for the ops
Applying: mm: frontswap: cleanup code
Applying: frontswap: get rid of swap_lock dependency
Applying: mm: cleancache: lazy initialization to allow tmem backends to bui=
ld/run as modules
Applying: cleancache: Make cleancache_init use a pointer for the ops
Applying: mm: cleancache: clean up cleancache_enabled
Applying: xen: tmem: enable Xen tmem shim to be built/loaded as a module
Applying: xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix
Applying: zcache/tmem: Better error checking on frontswap_register_ops retu=
rn value.
Applying: staging: zcache: enable ramster to be built/loaded as a module
Applying: staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix
Applying: staging: zcache: enable zcache to be built/loaded as a module
Applying: rmap: recompute pgoff for unmapping huge page
Applying: memblock: add assertion for zero allocation alignment
Applying: mm: walk_memory_range(): fix typo in comment
Applying: direct-io: fix boundary block handling
Applying: direct-io: submit bio after boundary buffer is added to it
Applying: mm/vmscan.c: minor cleanup for kswapd
Applying: mm: introduce common help functions to deal with reserved/managed=
 pages
Applying: mm/alpha: use common help functions to free reserved pages
Applying: mm/ARM: use common help functions to free reserved pages
Applying: mm/avr32: use common help functions to free reserved pages
Applying: mm/blackfin: use common help functions to free reserved pages
Applying: mm/c6x: use common help functions to free reserved pages
Applying: mm/cris: use common help functions to free reserved pages
Applying: mm/FRV: use common help functions to free reserved pages
Applying: mm/h8300: use common help functions to free reserved pages
Applying: mm/IA64: use common help functions to free reserved pages
Applying: mm/m32r: use common help functions to free reserved pages
Applying: mm/m68k: use common help functions to free reserved pages
Applying: mm/microblaze: use common help functions to free reserved pages
Applying: mm/MIPS: use common help functions to free reserved pages
Applying: mm/mn10300: use common help functions to free reserved pages
Applying: mm/openrisc: use common help functions to free reserved pages
Applying: mm/parisc: use common help functions to free reserved pages
Applying: mm/ppc: use common help functions to free reserved pages
Applying: mm/s390: use common help functions to free reserved pages
Applying: mm/score: use common help functions to free reserved pages
Applying: mm/SH: use common help functions to free reserved pages
Applying: mm/SPARC: use common help functions to free reserved pages
Applying: mm/um: use common help functions to free reserved pages
Applying: mm/unicore32: use common help functions to free reserved pages
Applying: mm/x86: use common help functions to free reserved pages
Applying: mm/xtensa: use common help functions to free reserved pages
Applying: mm/arc: use common help functions to free reserved pages
Applying: mm/metag: use common help functions to free reserved pages
Applying: mm,kexec: use common help functions to free reserved pages
Applying: mm: introduce free_highmem_page() helper to free highmem pages in=
to buddy system
Applying: mm/ARM: use free_highmem_page() to free highmem pages into buddy =
system
Applying: mm/FRV: use free_highmem_page() to free highmem pages into buddy =
system
Applying: mm/metag: use free_highmem_page() to free highmem pages into budd=
y system
Applying: mm/microblaze: use free_highmem_page() to free highmem pages into=
 buddy system
Applying: mm/MIPS: use free_highmem_page() to free highmem pages into buddy=
 system
Applying: mm/PPC: use free_highmem_page() to free highmem pages into buddy =
system
Applying: mm/SPARC: use free_highmem_page() to free highmem pages into budd=
y system
Applying: mm/um: use free_highmem_page() to free highmem pages into buddy s=
ystem
Applying: mm/x86: use free_highmem_page() to free highmem pages into buddy =
system
Applying: memcg: keep prev's css alive for the whole mem_cgroup_iter
Applying: memcg: rework mem_cgroup_iter to use cgroup iterators
Applying: memcg: relax memcg iter caching
Applying: memcg-relax-memcg-iter-caching-checkpatch-fixes
Applying: memcg: simplify mem_cgroup_iter
Applying: memcg: further simplify mem_cgroup_iter
Applying: cgroup: remove css_get_next
Applying: fs: don't compile in drop_caches.c when CONFIG_SYSCTL=3Dn
Applying: mm/hugetlb: add more arch-defined huge_pte functions
Applying: mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix
Applying: mm: make snapshotting pages for stable writes a per-bio operation
Applying: mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-=
v3
Applying: mm, vmalloc: change iterating a vmlist to find_vm_area()
Applying: mm, vmalloc: move get_vmalloc_info() to vmalloc.c
Applying: mm, vmalloc: protect va->vm by vmap_area_lock
Applying: mm, vmalloc: iterate vmap_area_list, instead of vmlist in vread/v=
write()
Applying: mm, vmalloc: iterate vmap_area_list in get_vmalloc_info()
Applying: mm, vmalloc: iterate vmap_area_list, instead of vmlist, in vmallo=
cinfo()
Applying: mm, vmalloc: export vmap_area_list, instead of vmlist
Applying: mm, vmalloc: remove list management of vmlist after initializing =
vmalloc
Applying: kexec, vmalloc: export additional vmalloc layer information
Applying: kexec-vmalloc-export-additional-vmalloc-layer-information-fix
Applying: mmap: find_vma: remove the WARN_ON_ONCE(!mm) check
Applying: memcg: do not check for do_swap_account in mem_cgroup_{read,write=
,reset}
Applying: mm: allow arch code to control the user page table ceiling
Applying: arm: set the page table freeing ceiling to TASK_SIZE
Applying: mm: merging memory blocks resets mempolicy
Applying: mm, hugetlb: include hugepages in meminfo
Applying: mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes
Applying: mm: try harder to allocate vmemmap blocks
Applying: sparse-vmemmap: specify vmemmap population range in bytes
Applying: sparse-vmemmap-specify-vmemmap-population-range-in-bytes-fix
Applying: x86-64: remove dead debugging code for !pse setups
Applying: x86-64: use vmemmap_populate_basepages() for !pse setups
Applying: x86-64: use vmemmap_populate_basepages() for !pse setups fix
Applying: x86-64: fall back to regular page vmemmap on allocation failure
Applying: mm: page_alloc: avoid marking zones full prematurely after zone_r=
eclaim()
Applying: mm-page_alloc-avoid-marking-zones-full-prematurely-after-zone_rec=
laim-fix
Applying: mm/migrate: fix comment typo syncronous->synchronous
Applying: mm: speedup in __early_pfn_to_nid
Applying: mm-speedup-in-__early_pfn_to_nid-fix
Applying: page_alloc: make setup_nr_node_ids() usable for arch init code
Applying: x86/mm/numa: use setup_nr_node_ids() instead of opencoding.
Applying: powerpc/mm/numa: use setup_nr_node_ids() instead of opencoding.
Applying: powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix
Applying: include/linux/memory.h: implement register_hotmemory_notifier()
Applying: ipc/util.c: use register_hotmemory_notifier()
Applying: mm/slub.c: use register_hotmemory_notifier()
Applying: drivers/base/node.c: switch to register_hotmemory_notifier()
Applying: fs/proc/kcore.c: use register_hotmemory_notifier()
Applying: kernel/cpuset.c: use register_hotmemory_notifier()
Applying: mm: limit growth of 3% hardcoded other user reserve
Applying: mm: replace hardcoded 3% with admin_reserve_pages knob
Applying: mm: reinititalise user and admin reserves if memory is added or r=
emoved
Applying: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-re=
moved-v9
Applying: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-re=
moved-v9-checkpatch-fixes
Applying: mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-re=
moved-v9-checkpatch-fixes-fix
Applying: mm/memcontrol.c: remove unnecessary ;
Applying: mm: remove CONFIG_HOTPLUG ifdefs
Applying: THP: fix comment about memory barrier
Applying: mm: Rewrite the comment over migrate_pages() more comprehensibly
Applying: resource: add __adjust_resource() for internal use
Applying: resource: add release_mem_region_adjustable()
Applying: resource-add-release_mem_region_adjustable-fix
Applying: resource-add-release_mem_region_adjustable-fix-fix
Applying: resource-add-release_mem_region_adjustable-fix-fix-fix
Applying: resource: update config option of release_mem_region_adjustable()
Applying: mm: change __remove_pages() to call release_mem_region_adjustable=
()
Applying: mm, hotplug: avoid compiling memory hotremove functions when disa=
bled
Applying: mm: madvise: complete input validation before taking lock
Applying: mm-madvise-complete-input-validation-before-taking-lock-fix
Applying: clear_refs: sanitize accepted commands declaration
Applying: clear_refs-sanitize-accepted-commands-declaration-fix
Applying: clear_refs: introduce private struct for mm_walk
Applying: pagemap: introduce pagemap_entry_t without pmshift bits
Applying: pagemap: introduce the /proc/PID/pagemap2 file
Applying: mm: soft-dirty bits for user memory changes tracking
Applying: mem-soft-dirty: Reshuffle CONFIG_ options to be more Arch-friendly
Applying: selftest: add simple test for soft-dirty bit
Applying: memcg: Add memory.pressure_level events
Applying: memcg-add-memorypressure_level-events-checkpatch-fixes
Applying: memcg-add-memorypressure_level-events-fix
Applying: mm/mmap: check for RLIMIT_AS before unmapping
Applying: mm: break up swap_writepage() for frontswap backends
Applying: mm: allow for outstanding swap writeback accounting
Applying: mm: thp: add split tail pages to shrink page list in page reclaim
Applying: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-f=
ix
Applying: mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-f=
ix-fix
Applying: mm/vmstat: add note on safety of drain_zonestat
Applying: firmware, memmap: fix firmware_map_entry leak
Applying: mm: Remove unused parameter of pages_correctly_reserved()
Applying: memblock: fix missing comment of memblock_insert_region()
Applying: fs: fix fsync() error reporting
Applying: memcg: avoid accessing memcg after releasing reference
Applying: thp: fix huge zero page logic for page with pfn =3D=3D 0
Applying: thp-fix-huge-zero-page-logic-for-page-with-pfn-=3D=3D-0-fix
Applying: mm, memcg: give exiting processes access to memory reserves
Applying: swap: redirty page if page write fails on swap file
Applying: mm: swap: Mark swap pages writeback before queueing for direct IO
Applying: mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-f=
ix
Applying: mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-f=
ix-fix
Applying: mm: fix memory_hotplug.c printk format warning
Applying: numa, cpu hotplug: change links of CPU and node when changing nod=
e number by onlining CPU
Applying: fs/buffer.c: remove unnecessary init operation after allocating b=
uffer_head.
Applying: mm, nobootmem: clean-up of free_low_memory_core_early()
Applying: mm, nobootmem: do memset() after memblock_reserve()
Applying: mmKconfig: add an option to disable bounce
Applying: mem hotunplug: fix kfree() of bootmem memory
Applying: mem-hotunplug-fix-kfree-of-bootmem-memory-fix
Applying: memcg: take reference before releasing rcu_read_lock
Applying: mm: remove free_area_cache
Applying: include/linux/mmzone.h: cleanups
Applying: include-linux-mmzoneh-cleanups-fix
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: drivers/rpmsg/virtio_rpmsg_bus.c: fix error return code in rpmsg_=
probe()
Applying: genalloc: add devres support, allow to find a managed pool by dev=
ice
Applying: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-devic=
e-fix
Applying: genalloc-add-devres-support-allow-to-find-a-managed-pool-by-devic=
e-fix-fix
Applying: misc: generic on-chip SRAM allocation driver
Applying: misc-generic-on-chip-sram-allocation-driver-fix
Applying: media: coda: use genalloc API
Applying: gcc4: disable __compiletime_object_size for GCC 4.6+
Applying: kernel/range.c: subtract_range: fix the broken phrase issued by p=
rintk
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: x86: don't show trace beyond show_stack(NULL, NULL)
Applying: sparc32: make show_stack() acquire %fp if @_ksp is not specified
Applying: dump_stack: consolidate dump_stack() implementations and unify th=
eir behaviors
Applying: dmi: morph dmi_dump_ids() into dmi_format_ids() which formats int=
o a buffer
Applying: dump_stack: implement arch-specific hardware description in task =
dumps
Applying: dump_stack: unify debug information printed by show_regs()
Applying: arc, print-fatal-signals: reduce duplicated information
Applying: kthread: implement probe_kthread_data()
Applying: workqueue: include workqueue info when printing debug dump of a w=
orker task
Applying: writeback: set worker desc to identify writeback workers in task =
dumps
Applying: kernel/smp.c: use '|=3D' for csd_lock
Applying: kernel/smp.c: remove 'priv' of call_single_data
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: printk/tracing: rework console tracing
Applying: early_printk: consolidate random copies of identical code
Applying: early_printk: consolidate random copies of identical code
Applying: early_printk-consolidate-random-copies-of-identical-code-v3-fix
Applying: sh4: make the bios early console support depend on EARLY_PRINTK
Applying: include/linux/printk.h: include stdarg.h
Applying: printk: fix failure to return error in devkmsg_poll()
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: get_maintainer: use filename-only regex match for Tegra
Applying: get_maintainer-use-filename-only-regex-match-for-tegra-fix
Applying: MAINTAINERS: i8k driver is orphan
Applying: MAINTAINERS: Petko has moved
Applying: drivers/video/backlight/ams369fg06.c: convert ams369fg06 to dev_p=
m_ops
Applying: drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_=
ops-fix
Applying: drivers/video/backlight/platform_lcd.c: remove unnecessary ifdefs
Applying: drivers/video/backlight/ep93xx_bl.c: remove incorrect __init anno=
tation
Applying: drivers/video/backlight/atmel-pwm-bl.c: use module_platform_drive=
r_probe()
Applying: drivers/video/backlight/atmel-pwm-bl.c: add __init annotation
Applying: drivers/video/backlight/lp855x_bl.c: fix compiler warning in lp85=
5x_probe
Applying: drivers/video/backlight/jornada720_*.c: use dev_err()/dev_info() =
instead of pr_err()/pr_info()
Applying: drivers/video/backlight/omap1_bl.c: use dev_info() instead of pr_=
info()
Applying: drivers/video/backlight/generic_bl.c: use dev_info() instead of p=
r_info()
Applying: drivers/video/backlight/adp8870_bl.c: add missing braces
Applying: drivers/video/backlight/l4f00242t03.c: check return value of regu=
lator_enable()
Applying: drivers-video-backlight-l4f00242t03c-check-return-value-of-regula=
tor_enable-fix
Applying: backlight: ld9040: convert ld9040 to dev_pm_ops
Applying: backlight: lms501kf03: convert lms501kf03 to dev_pm_ops
Applying: backlight: s6e63m0: convert s6e63m0 to dev_pm_ops
Applying: backlight: adp5520: convert adp5520_bl to dev_pm_ops
Applying: backlight: adp8860: convert adp8860 to dev_pm_ops
Applying: backlight: adp8870: convert adp8870 to dev_pm_ops
Applying: backlight: corgi_lcd: convert corgi_lcd to dev_pm_ops
Applying: backlight: ep93xx: convert ep93xx to dev_pm_ops
Applying: backlight: hp680_bl: convert hp680bl to dev_pm_ops
Applying: backlight: kb3886_bl: convert kb3886bl to dev_pm_ops
Applying: backlight: lm3533_bl: convert lm3533_bl to dev_pm_ops
Applying: backlight: locomolcd: convert locomolcd to dev_pm_ops
Applying: backlight: ltv350qv: convert ltv350qv to dev_pm_ops
Applying: backlight: tdo24m: convert tdo24m to dev_pm_ops
Applying: drivers/video/backlight/Kconfig: fix typo "MACH_SAM9...EK" three =
times
Applying: drivers/video/backlight/adp5520_bl.c: fix compiler warning in adp=
5520_show()
Applying: video: backlight: add ili922x lcd driver
Applying: backlight: da903x_bl: use BL_CORE_SUSPENDRESUME option
Applying: drivers/video/backlight/lp855x_bl.c: use PAGE_SIZE for the sysfs =
read operation
Applying: drivers/video/backlight/adp8860_bl.c: fix error return code in ad=
p8860_led_probe()
Applying: drivers/video/backlight/adp8870_bl.c: fix error return code in ad=
p8870_led_probe()
Applying: drivers/video/backlight/as3711_bl.c: add OF support
Applying: backlight: ili9320: use spi_set_drvdata()
Applying: backlight: ili922x: use spi_set_drvdata()
Applying: drivers/video/backlight/platform_lcd.c: introduce probe callback
Applying: backlight: omap1: convert omapbl to dev_pm_ops
Applying: backlight: tosa: convert tosa to dev_pm_ops
Applying: backlight: vgg2432a4: convert vgg2432a4_driver to dev_pm_ops
Applying: backlight: lp855x: convert a type of device name
Applying: backlight: lp855x: move backlight mode platform data
Applying: backlight: lp855x: fix initial brightness type
Applying: backlight: lp855x: remove duplicate platform data
Applying: backlight: lp855x: add a device tree structure
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/int_sqrt.c: optimize square root algorithm
Applying: argv_split(): teach it to handle mutable strings
Applying: argv_split-teach-it-to-handle-mutable-strings-fix
Applying: argv_split-teach-it-to-handle-mutable-strings-fix-2
Applying: lib, net: make isodigit() public and use it
Applying: lib/string_helpers: introduce generic string_unescape
Applying: lib-string_helpers-introduce-generic-string_unescape-fix
Applying: staging: speakup: remove custom string_unescape_any_inplace
Applying: dynamic_debug: reuse generic string_unescape function
Applying: binfmt_misc: reuse string_unescape_inplace()
Applying: kernel/compat.c: make do_sysinfo() static
Applying: kernel/timer.c: convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFI=
NE
Applying: kernel/timer.c: move some non timer related syscalls to kernel/sy=
s.c
Applying: kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-=
checkpatch-fixes
Applying: checkpatch: add check for reuse of krealloc arg
Applying: checkpatch: Prefer seq_puts to seq_printf
Applying: checkpatch: Complain about executable files
Applying: checkpatch: warn on space before semicolon
Applying: checkpatch: only warn for empty lines before closing braces by th=
emselves
Applying: checkpatch: add Suggested-by as a standard signature
Applying: epoll: trim epitem by one cache line
Applying: epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
Applying: epoll: comment + BUILD_BUG_ON to prevent epitem bloat
Applying: epoll: use RCU to protect wakeup_source in epitem
Applying: epoll: fix suspicious RCU usage in ep_poll_callback
Applying: epoll: lock ep->mtx in ep_free to silence lockdep
Applying: epoll: cleanup: hoist out f_op->poll calls
Applying: epoll: cleanup: use RCU_INIT_POINTER when nulling
Applying: fs: make binfmt support for #! scripts modular and removable
Applying: binfmt_elf: PIE: make PF_RANDOMIZE check comment more accurate
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: init: scream bloody murder if interrupts are enabled too early
Applying: init: raise log level
Applying: init/main.c: convert to pr_foo()
Applying: init-mainc-convert-to-pr_foo-fix
Applying: init-mainc-convert-to-pr_foo-fix-fix
Applying: dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()
Applying: dmi_scan: proper buf type in dmi_present()
Applying: i2o: check copy_from_user() size parameter
Applying: rtc: rtc-mv: add __init annotation
Applying: rtc: rtc-davinci: add __exit annotation
Applying: rtc: rtc-ds1302: add __exit annotation
Applying: rtc: rtc-imxdi: add __init/__exit annotation
Applying: rtc: rtc-nuc900: add __init/__exit annotation
Applying: rtc: rtc-pcap: add __init/__exit annotation
Applying: rtc: rtc-tegra: add __init/__exit annotation
Applying: rtc: add devm_rtc_device_{register,unregister}()
Applying: drivers/rtc/rtc-max77686.c: use module_platform_driver()
Applying: drivers/rtc/rtc-max77686.c: add missing module author name
Applying: drivers/rtc/rtc-max77686.c: use devm_kzalloc()
Applying: drivers/rtc/rtc-max77686.c: fix indentation of bit definitions
Applying: drivers/rtc/rtc-max77686.c: use dev_info()/dev_emerg() instead of=
 pr_info()/pr_emerg()
Applying: drivers/rtc/rtc-v3020.c: use gpio_request_array()
Applying: drivers/rtc/class.c: use struct device as the first argument for =
devm_rtc_device_register()
Applying: rtc: rtc-ab3100: use module_platform_driver_probe()
Applying: rtc: rtc-at32ap700x: use module_platform_driver_probe()
Applying: rtc: rtc-at91rm9200: use module_platform_driver_probe()
Applying: rtc: rtc-au1xxx: use module_platform_driver_probe()
Applying: rtc: rtc-coh901331: use module_platform_driver_probe()
Applying: rtc: rtc-davinci: use module_platform_driver_probe()
Applying: rtc: rtc-ds1302: use module_platform_driver_probe()
Applying: rtc: rtc-efi: use module_platform_driver_probe()
Applying: rtc: rtc-generic: use module_platform_driver_probe()
Applying: rtc: rtc-imxdi: use module_platform_driver_probe()
Applying: rtc: rtc-mc13xxx: use module_platform_driver_probe()
Applying: rtc: rtc-msm6242: use module_platform_driver_probe()
Applying: rtc: rtc-mv: use module_platform_driver_probe()
Applying: rtc: rtc-nuc900: use module_platform_driver_probe()
Applying: rtc: rtc-omap: use module_platform_driver_probe()
Applying: rtc: rtc-pcap: use module_platform_driver_probe()
Applying: rtc: rtc-ps3: use module_platform_driver_probe()
Applying: rtc: rtc-pxa: use module_platform_driver_probe()
Applying: rtc: rtc-rp5c01: use module_platform_driver_probe()
Applying: rtc: rtc-sh: use module_platform_driver_probe()
Applying: rtc: rtc-starfire: use module_platform_driver_probe()
Applying: rtc: rtc-sun4v: use module_platform_driver_probe()
Applying: rtc: rtc-tegra: use module_platform_driver_probe()
Applying: rtc: rtc-tx4939: use module_platform_driver_probe()
Applying: rtc: rtc-88pm80x: use devm_rtc_device_register()
Applying: rtc: rtc-coh90133: use devm_rtc_device_register()
Applying: rtc: rtc-da9052: use devm_rtc_device_register()
Applying: rtc: rtc-da9055: use devm_rtc_device_register()
Applying: rtc: rtc-davinci: use devm_rtc_device_register()
Applying: rtc: rtc-ds1511: use devm_rtc_device_register()
Applying: rtc: rtc-ds1553: use devm_rtc_device_register()
Applying: rtc: rtc-ds1742: use devm_rtc_device_register()
Applying: rtc: rtc-ep93xx: use devm_rtc_device_register()
Applying: rtc: rtc-imxdi: use devm_rtc_device_register()
Applying: rtc: rtc-lp8788: use devm_rtc_device_register()
Applying: rtc: rtc-lpc32xx: use devm_rtc_device_register()
Applying: rtc: rtc-max77686: use devm_rtc_device_register()
Applying: rtc: rtc-max8907: use devm_rtc_device_register()
Applying: rtc: rtc-max8997: use devm_rtc_device_register()
Applying: rtc: rtc-mv: use devm_rtc_device_register()
Applying: rtc: rtc-mxc: use devm_rtc_device_register()
Applying: rtc: rtc-palmas: use devm_rtc_device_register() and devm_request_=
threaded_irq()
Applying: rtc: rtc-pcf8523: use devm_rtc_device_register()
Applying: rtc: rtc-s3c: use devm_rtc_device_register()
Applying: rtc: rtc-snvs: use devm_rtc_device_register()
Applying: rtc: rtc-spear: use devm_rtc_device_register()
Applying: rtc: rtc-stk17ta8: use devm_rtc_device_register()
Applying: rtc: rtc-tps6586x: use devm_rtc_device_register()
Applying: rtc: rtc-tps65910: use devm_rtc_device_register()
Applying: rtc: rtc-tps80031: use devm_rtc_device_register()
Applying: rtc: rtc-tx4939: use devm_rtc_device_register()
Applying: rtc: rtc-vt8500: use devm_rtc_device_register()
Applying: rtc: rtc-wm831x: use devm_rtc_device_register()
Applying: below is the warning reported with the gcc (gcc (GCC) 4.7.2 20121=
109 (Red
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-tegra.c: protect suspend/resume callbacks with CO=
NFIG_PM_SLEEP
Applying: drivers/rtc/rtc-tegra.c: use struct dev_pm_ops for power manageme=
nt
Applying: drivers/rtc/rtc-tegra.c: set irq name as device name
Applying: drivers/rtc/rtc-tegra.c: use managed rtc_device_register()
Applying: drivers/rtc/rtc-tegra.c: fix build warning
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: drivers/rtc/rtc-s3c.c: convert s3c_rtc to dev_pm_ops
Applying: rtc: rtc-ds1307: use dev_dbg() instead of pr_debug()
Applying: rtc: rtc-fm3130: use dev_dbg() instead of pr_debug()
Applying: rtc: rtc-ab3100: use devm_rtc_device_register()
Applying: rtc: rtc-au1xxx: use devm_rtc_device_register()
Applying: rtc: rtc-bq32k: use devm_rtc_device_register()
Applying: rtc: rtc-dm355evm: use devm_rtc_device_register()
Applying: rtc: rtc-ds1302: use devm_rtc_device_register()
Applying: rtc: rtc-ds1672: use devm_rtc_device_register()
Applying: rtc: rtc-ds3234: use devm_rtc_device_register()
Applying: rtc: rtc-efi: use devm_rtc_device_register()
Applying: rtc: rtc-em3027: use devm_rtc_device_register()
Applying: rtc: rtc-generic: use devm_rtc_device_register()
Applying: rtc: hid-sensor-time: use devm_rtc_device_register()
Applying: rtc: rtc-ls1x: use devm_rtc_device_register()
Applying: rtc: rtc-m41t93: use devm_rtc_device_register()
Applying: rtc: rtc-m41t94: use devm_rtc_device_register()
Applying: rtc: rtc-m48t86: use devm_rtc_device_register()
Applying: rtc: rtc-max6900: use devm_rtc_device_register()
Applying: rtc: rtc-max6902: use devm_rtc_device_register()
Applying: rtc: rtc-ps3: use devm_rtc_device_register()
Applying: rtc: rtc-r9701: use devm_rtc_device_register()
Applying: rtc: rtc-rc5t583: use devm_rtc_device_register()
Applying: rtc: rtc-rs5c313: use devm_rtc_device_register()
Applying: rtc: rtc-rv3029c2: use devm_rtc_device_register()
Applying: rtc: rtc-rx4581: use devm_rtc_device_register()
Applying: rtc: rtc-rx8581: use devm_rtc_device_register()
Applying: rtc: rtc-starfire: use devm_rtc_device_register()
Applying: rtc: rtc-sun4v: use devm_rtc_device_register()
Applying: rtc: rtc-test: use devm_rtc_device_register()
Applying: rtc: rtc-tile: use devm_rtc_device_register()
Applying: rtc: rtc-wm8350: use devm_rtc_device_register()
Applying: rtc: rtc-x1205: use devm_rtc_device_register()
Applying: rtc: rtc-at91rm9200: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-mxc: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-pxa: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-rc5t583: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-sa1100: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-sh: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-wm8350: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-tps6586x: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-tps65910: switch to using SIMPLE_DEV_PM_OPS
Applying: rtc: rtc-tps80031: switch to using SIMPLE_DEV_PM_OPS
Applying: drivers/rtc/rtc-omap.c: update to devm_* API
Applying: drivers/rtc/rtc-palmas.c: add dt support
Applying: drivers/rtc/rtc-ds1374.c: add CONFIG_PM_SLEEP to suspend/resume f=
unctions
Applying: drivers/rtc/rtc-88pm80x.c: add CONFIG_PM_SLEEP to suspend/resume =
functions
Applying: drivers/rtc/rtc-tps6586x.c: remove incorrect use of rtc_device_un=
register
Applying: drivers/rtc/rtc-tps65910.c: fix incorrect return value on error
Applying: drivers/rtc/rtc-max8997.c: fix incorrect return value on error
Applying: drivers/rtc/rtc-max77686.c: fix incorrect return value on error
Applying: drivers/rtc/rtc-max8907.c: remove redundant code
Applying: drivers/rtc/rtc-at91rm9200.c: add DT support
Applying: drivers/rtc/rtc-ds1307.c: change sysfs function pointer assignment
Applying: rtc: rtc-rx4581: use spi_set_drvdata()
Applying: rtc: rtc-m41t94: use spi_set_drvdata()
Applying: rtc: rtc-r9701: use spi_set_drvdata()
Applying: rtc: rtc-ds3234: use spi_set_drvdata()
Applying: rtc: rtc-ds1390: use spi_set_drvdata()
Applying: rtc: rtc-m41t93: use spi_set_drvdata()
Applying: rtc: rtc-max6902: use spi_set_drvdata()
Applying: drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend
Applying: drivers/rtc/rtc-s3c.c: use clk_prepare_enable and clk_disable_unp=
repare
Applying: drivers/rtc/rtc-max77686.c: use devm_regmap_init_i2c()
Applying: drivers/rtc/rtc-88pm860x.c: use devm_* APIs
Applying: drivers/rtc/rtc-at32ap700x.c: use devm_* APIs
Applying: drivers/rtc/rtc-ds1305.c: use devm_* APIs
Applying: drivers/rtc/rtc-ds1374.c: use devm_* APIs
Applying: drivers/rtc/rtc-ds3232.c: use devm_* APIs
Applying: drivers/rtc/rtc-m48t35.c: use devm_* APIs
Applying: drivers/rtc/rtc-max8925.c: use devm_* APIs
Applying: drivers/rtc/rtc-pxa.c: use devm_* APIs
Applying: rtc: rtc-ab8500: use devm_*() functions
Applying: rtc: rtc-at91sam9: use devm_*() functions
Applying: rtc: rtc-bfin: use devm_*() functions
Applying: rtc: rtc-bq4802: use devm_*() functions
Applying: rtc: rtc-ds1216: use devm_*() functions
Applying: rtc: rtc-ds1286: use devm_*() functions
Applying: rtc: rtc-ds1390: use devm_*() functions
Applying: rtc: rtc-ds2404: use devm_*() functions
Applying: rtc: rtc-fm3130: use devm_*() functions
Applying: rtc: rtc-isl12022: use devm_*() functions
Applying: rtc: rtc-m41t80: use devm_*() functions
Applying: rtc: rtc-max8998: use devm_*() functions
Applying: rtc: rtc-mc13xxx: use devm_*() functions
Applying: rtc: rtc-msm6242: use devm_*() functions
Applying: rtc: rtc-nuc900: use devm_*() functions
Applying: rtc: rtc-pcap: use devm_*() functions
Applying: rtc: rtc-pcf2123: use devm_*() functions
Applying: rtc: rtc-pcf50633: use devm_*() functions
Applying: rtc: rtc-pcf8563: use devm_*() functions
Applying: rtc: rtc-pcf8583: use devm_*() functions
Applying: rtc: rtc-rp5c01: use devm_*() functions
Applying: rtc: rtc-rs5c348: use devm_*() functions
Applying: rtc: rtc-rs5c372: use devm_*() functions
Applying: rtc: rtc-s35390a: use devm_*() functions
Applying: rtc: rtc-sa1100: use devm_*() functions
Applying: rtc: rtc-stmp3xxx: use devm_*() functions
Applying: rtc: rtc-v3020: use devm_*() functions
Applying: drivers/rtc/rtc-max6902.c: use register defines instead of magic =
numbers
Applying: rtc: rtc-at91sam9: convert at91_rtc_driver to dev_pm_ops
Applying: rtc: rtc-bfin: convert bfin_rtc_driver to dev_pm_ops
Applying: rtc: rtc-coh901331: convert coh901331_driver to dev_pm_ops
Applying: rtc: rtc-omap: convert omap_rtc_driver to dev_pm_ops
Applying: rtc: rtc-puv3: convert puv3_rtc_driver to dev_pm_ops
Applying: rtc: rtc-spear: convert spear_rtc_driver to dev_pm_ops
Applying: rtc: rtc-stmp3xxx: convert stmp3xxx_rtcdrv to dev_pm_ops
Applying: rtc: rtc-twl: convert twl4030rtc_driver to dev_pm_ops
Applying: drivers/rtc/rtc-at91rm9200.c: fix missing iounmap
Applying: drivers/rtc/rtc-isl12022.c: Remove rtc8564 from isl12022_id
Applying: drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe=
()
Applying: nilfs2: fix issue with flush kernel thread after remount in RO mo=
de because of driver's internal error or metadata corruption
Applying: nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mod=
e-because-of-drivers-internal-error-or-metadata-corruption-fix
Applying: nilfs2: fix using of PageLocked() in nilfs_clear_dirty_page()
Applying: nilfs2: remove unneeded test in nilfs_writepage()
Applying: hfs: add error checking for hfs_find_init()
Applying: hfsplus: fix warnings in fs/hfsplus/bfind.c
Applying: hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1s=
t_rec_by_cnid-fix
Applying: hfs/hfsplus: convert dprint to hfs_dbg
Applying: hfs/hfsplus: convert printks to pr_<level>
Applying: hfsplus: add error propagation to __hfsplus_ext_write_extent()
Applying: hfsplus: remove duplicated message prefix in hfsplus_block_free()
Applying: fat: introduce 2 new values for the -o nfs mount option
Applying: fat: move fat_i_pos_read to fat.h
Applying: fat: introduce a helper fat_get_blknr_offset()
Applying: fat: restructure export_operations
Applying: fat (exportfs): rebuild inode if ilookup() fails
Applying: fat (exportfs): rebuild directory-inode if fat_dget()
Applying: Documentation: update nfs option in filesystem/vfat.txt
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: ptrace: add ability to retrieve signals without removing from a q=
ueue (v4)
Applying: selftest: add a test case for PTRACE_PEEKSIGINFO
Applying: usermodehelper: export call_usermodehelper_exec() and call_usermo=
dehelper_setup()
Applying: usermodehelper-export-_exec-and-_setup-functions-fix
Applying: kmod: split call to call_usermodehelper_fns()
Applying: KEYS: split call to call_usermodehelper_fns()
Applying: coredump: remove trailling whitespace
Applying: usermodehelper: split remaining calls to call_usermodehelper_fns()
Applying: kmod: remove call_usermodehelper_fns()
Applying: coredump: only SIGKILL should interrupt the coredumping task
Applying: coredump: ensure that SIGKILL always kills the dumping thread
Applying: coredump: sanitize the setting of signal->group_exit_code
Applying: coredump: introduce dump_interrupted()
Applying: coredump: factor out the setting of PF_DUMPCORE
Applying: coredump: change wait_for_dump_helpers() to use wait_event_interr=
uptible()
Applying: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN b=
ytes
Applying: set_task_comm: kill the pointless memset() + wmb()
Applying: exec: do not abuse ->cred_guard_mutex in threadgroup_lock()
Applying: kexec: fix wrong types of some local variables
Applying: kexec: Use min() and min_t() to simplify logic
Applying: kexec-use-min_t-to-simplify-logic-fix
Applying: idr: introduce idr_alloc_cyclic()
Applying: drivers/infiniband/hw/amso1100: convert to using idr_alloc_cyclic
Applying: drivers/infiniband/hw/mlx4: convert to using idr_alloc_cyclic()
Applying: nfsd: convert nfs4_alloc_stid() to use idr_alloc_cyclic()
Applying: inotify: convert inotify_add_to_idr() to use idr_alloc_cyclic()
Applying: sctp: convert sctp_assoc_set_id() to use idr_alloc_cyclic()
Applying: ipc: clamp with min()
Applying: ipc: separate msg allocation from userspace copy
Applying: ipc: tighten msg copy loops
Applying: ipc: set EFAULT as default error in load_msg()
Applying: ipc: remove msg handling from queue scan
Applying: ipc: implement MSG_COPY as a new receive mode
Applying: ipc: simplify msg list search
Applying: ipc: refactor msg list search into separate function
Applying: ipc: find_msg can be static
Applying: ipc/msgutil.c: use linux/uaccess.h
Applying: ipc: remove bogus lock comment for ipc_checkid
Applying: ipc: introduce obtaining a lockless ipc object
Applying: ipc-introduce-obtaining-a-lockless-ipc-object-fix
Applying: ipc: introduce lockless pre_down ipcctl
Applying: ipc,sem: do not hold ipc lock more than necessary
Applying: ipc,sem: prevent releasing RCU read lock twice in semctl_main
Applying: ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fi=
xes
Applying: ipc,sem: open code and rename sem_lock
Applying: ipcsem-open-code-and-rename-sem_lock-fix
Applying: ipc,sem: have only one list in struct sem_queue
Applying: ipc,sem: fine grained locking for semtimedop
Applying: fix for sem_lock
Applying: ipc, sem: prevent possible deadlock
Applying: ipc,sem: fix locking in semctl_main
Applying: ipc,sem: untangle RCU locking with find_alloc_undo
Applying: ipc, sem: do not call sem_lock when bogus sma
Applying: ipc: make refcounter atomic
Applying: ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-at=
omic-fix
Applying: ipc,sem: fix lockdep false positive
Applying: ipc/msg.c: use list_for_each_entry_[safe] for list traversing
Applying: ipc: sysv shared memory limited to 8TiB
Applying: ipc-sysv-shared-memory-limited-to-8tib-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: mwave: fix info leak in mwave_ioctl()
Applying: rapidio: make enumeration/discovery configurable
Applying: rapidio: add enumeration/discovery start from user space
Applying: rapidio: documentation update for enumeration changes
Applying: rbtree_test: add extra rbtree integrity check
Applying: rbtree_test: add __init/__exit annotations
Applying: kernel/pid.c: improve flow of a loop inside alloc_pidmap.
Applying: kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix
Applying: pid_namespace.c/.h: simplify defines
Applying: pid_namespacec-h-simplify-defines-fix
Applying: nbd: increase default and max request sizes
Applying: aoe: replace kmalloc and then memcpy with kmemdup
Applying: raid6test: use prandom_bytes()
Applying: uuid: use prandom_bytes()
Applying: x86: pageattr-test: remove srandom32 call
Applying: x86: rename random32() to prandom_u32()
Applying: lib/: rename random32() to prandom_u32()
Applying: mm/: rename random32() to prandom_u32()
Applying: kernel/: rename random32() to prandom_u32()
Applying: drbd: rename random32() to prandom_u32()
Applying: mmc: rename random32() to prandom_u32()
Applying: video/uvesafb: rename random32() to prandom_u32()
Applying: uwb: rename random32() to prandom_u32()
Applying: lguest: rename random32() to prandom_u32()
Applying: scsi: rename random32() to prandom_u32()
Applying: drivers/net: rename random32() to prandom_u32()
Applying: drivers-net-rename-random32-to-prandom_u32-fix
Applying: brcm80211: fix the misaligned indentation
Applying: net/sunrpc: rename random32() to prandom_u32()
Applying: net/sched: rename random32() to prandom_u32()
Applying: net/netfilter: rename random32() to prandom_u32()
Applying: net/core: rename random32() to prandom_u32()
Applying: net/core: remove duplicate statements by do-while loop
Applying: net: rename random32 to prandom
Applying: remove unused random32() and srandom32()
Applying: random: fix accounting race condition with lockless irq entropy_c=
ount update
Applying: pps: hide more configuration symbols behind CONFIG_PPS
Applying: pps: pps_kc_hardpps_lock can be static
Applying: semaphore: use unlikely() for down's timeout
Applying: semaphore: use `bool' type for semaphore_waiter's up
Applying: drivers/memstick/host/r592.c: make r592_pm_ops static
Applying: kernel/relay.c: remove unused function argument actor
Applying: kernel/relay.c: move FIX_SIZE macro into relay.c
Applying: relay: use macro PAGE_ALIGN instead of FIX_SIZE
Applying: relay: fix timer madness
Applying: kernel/relay.c: move remove_buf_file inside relay_close_buf()
Applying: mm: remove old aio use_mm() comment
Applying: aio: remove dead code from aio.h
Applying: gadget: remove only user of aio retry
Applying: gadget-remove-only-user-of-aio-retry-checkpatch-fixes
Applying: aio: remove retry-based AIO
Applying: aio-remove-retry-based-aio-checkpatch-fixes
Applying: char: add aio_{read,write} to /dev/{null,zero}
Applying: aio: kill return value of aio_complete()
Applying: aio: add kiocb_cancel()
Applying: aio: move private stuff out of aio.h
Applying: aio: dprintk() -> pr_debug()
Applying: aio: do fget() after aio_get_req()
Applying: aio: make aio_put_req() lockless
Applying: aio-make-aio_put_req-lockless-checkpatch-fixes
Applying: aio: refcounting cleanup
Applying: aio-refcounting-cleanup-checkpatch-fixes
Applying: wait: add wait_event_hrtimeout()
Applying: aio: make aio_read_evt() more efficient, convert to hrtimers
Applying: aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpat=
ch-fixes
Applying: aio: use flush_dcache_page()
Applying: aio: use cancellation list lazily
Applying: aio: change reqs_active to include unreaped completions
Applying: aio: kill batch allocation
Applying: aio: kill struct aio_ring_info
Applying: aio: give shared kioctx fields their own cachelines
Applying: aio: reqs_active -> reqs_available
Applying: aio: percpu reqs_available
Applying: generic dynamic per cpu refcounting
Applying: generic-dynamic-per-cpu-refcounting-checkpatch-fixes
Applying: generic-dynamic-per-cpu-refcounting-fix
Applying: aio: percpu ioctx refcount
Applying: aio: use xchg() instead of completion_lock
Applying: aio: don't include aio.h in sched.h
Applying: aio-dont-include-aioh-in-schedh-fix
Applying: aio: kill ki_key
Applying: aio: kill ki_retry
Applying: aio-kill-ki_retry-fix
Applying: aio-kill-ki_retry-checkpatch-fixes
Applying: block: prep work for batch completion
Applying: block-prep-work-for-batch-completion-checkpatch-fixes
Applying: block-prep-work-for-batch-completion-checkpatch merge fixes
Applying: block-prep-work-for-batch-completion-fix-2
Applying: block-prep-work-for-batch-completion-fix-3
Applying: block-prep-work-for-batch-completion-fix-3-fix
Applying: block-prep-work-for-batch-completion-fix-4
Applying: block-prep-work-for-batch-completion-fix-99
Applying: block, aio: batch completion for bios/kiocbs
Applying: block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: fix kioctx not being freed after cancellation at exit time
Applying: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Applying: kconfig-consolidate-config_debug_strict_user_copy_checks-fix
Applying: kconfig menu: move Virtualization drivers near other virtualizati=
on options
Applying: init/Kconfig: re-order CONFIG_EXPERT options to fix menuconfig di=
splay
Applying: UAPI: remove empty Kbuild files
Applying: kernel/sys.c: make prctl(PR_SET_MM) generally available
Applying: notifier-error-inject: fix module names in Kconfig
Applying: decompressor: add LZ4 decompressor module
Applying: lib: add support for LZ4-compressed kernel
Applying: arm: add support for LZ4-compressed kernel
Applying: x86: add support for LZ4-compressed kernel
Applying: lib: add lz4 compressor module
Applying: lib-add-lz4-compressor-module-fix
Applying: crypto: add lz4 Cryptographic API
Applying: crypto-add-lz4-cryptographic-api-fix
Applying: lib/decompress.c: fix initconst
Applying: seccomp: add generic code for jitted seccomp filters.
Applying: ARM: net: bpf_jit: make code generation less dependent on struct =
sk_filter.
Applying: ARM: net: bpf_jit: add support for jitted seccomp filters.
Applying: bpf: add comments explaining the schedule_work() operation
Applying: kgdb/sysrq: fix inconstistent help message of sysrq key
Applying: power/sysrq: fix inconstistent help message of sysrq key
Applying: ARM/etm/sysrq: fix inconstistent help message of sysrq key
Applying: powerpc/xmon/sysrq: fix inconstistent help message of sysrq key
Applying: sparc/sysrq: fix inconstistent help message of sysrq key
Applying: ethernet/emac/sysrq: fix inconstistent help message of sysrq key
Applying: Documentation/sysrq: fix inconstistent help message of sysrq key
Merging akpm/master (a3949d8 Documentation/sysrq: fix inconstistent help me=
ssage of sysrq key)

--Signature=_Fri__26_Apr_2013_18_03_57_+1000_WsbRG=KMMICT4EG7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRejTtAAoJEECxmPOUX5FEZpUP+wZvi8Hk1+V7UQvcO+PmkWiV
q1EjqPy589OF7BOFe5A2N+gSqUN5FAMnnc0RugMmKViERHQiew8ZVBGn11eiUaKq
jQyR9y9OKDqKisy45iYxvq9Owl9uq6xVGJnGqxQhKoKIJp9crgucPdx6tjQ7WVnp
Kzu8dSzyJcV3XuiRdA+Q1q3rAX5f+T5dZjrVMTPJT6iox+Lc2judFkqgBDJipnLh
evjeXhP6SfaAxaBzZPdj8wv3f1BRWbMEZzqlWFmaxaRCGla7SPaqAqWAQzl0j3VN
14cfWlEUuTrW8ZH+5dvF7N2t/5Sm7XMaQNt/c4USmnX0QjZJ0Zc3EAZAuhfv8fvW
tsG4PnuftelE/6rsCRxGST1yl1i85IliNXgYAY4pG9sGow/dWvYJPulW3WeGDTj1
hLAvuaTwk3ucjxfo6idrp3vV9tC4b7WcNdaAbhlZn/LdxfkoZjI6qB8XGXHUdW+G
dKdsfAHnW5iiQb6eTpcFYgD1fdrFS07uG9gmRIBSbqGhYWraEzYk29PxuhIwyc29
LXv0oja1VeC8TeWvs8d/uFbwtsDYVyoUzV5H2kX+vPW8bOTE9ApGEEcyVsDYj5su
gHoxsSsmNuTFYI0fP6oVDJWb4WFN7zMqIDrm7bus5/lzU/SgpDHt5KgiO7Z/Lgwl
RsO1+KTlVycxSoidqN+2
=YKaf
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_18_03_57_+1000_WsbRG=KMMICT4EG7--
