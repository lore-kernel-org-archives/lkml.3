Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3EMCyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:54:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45962 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab3EMCyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:54:31 -0400
Date: Mon, 13 May 2013 12:54:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 13
Message-Id: <20130513125420.cbc818aa74b71ecf944ec091@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_12_54_20_+1000_gO=yoE_dgwy3SDnd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_12_54_20_+1000_gO=yoE_dgwy3SDnd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130510:

The akpm tree gained a conflict against Linus' tree.

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

We are up to 225 trees (counting Linus' and 31 trees of patches pending
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
Merging origin/master (f722406 Linux 3.10-rc1)
Merging fixes/master (0279b3c Merge branch 'sched-urgent-for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging kbuild-current/rc-fixes (a54292f kbuild: generate generic headers b=
efore recursing into scripts)
Merging arc-current/for-curr (e7d5bab ARC: [TB10x] Remove GENERIC_GPIO)
Merging arm-current/fixes (1783d45 ARM: 7700/2: Make cpu_init() notrace)
Merging m68k-current/for-linus (e00c73e m68k: Remove inline strlen() implem=
entation)
Merging powerpc-merge/merge (5737789 powerpc: Make hard_irq_disable() do th=
e right thing vs. irq tracing)
Merging sparc/master (de9c9f8 Merge tag 'remoteproc-3.10' of git://git.kern=
el.org/pub/scm/linux/kernel/git/ohad/remoteproc)
Merging net/master (84c4a9d xfrm6: release dev before returning error)
Applying: drivers:net: fix up for code movement from rt2x00pci.c
Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging sound-current/for-linus (6c35ae3 Revert "ALSA: hda - Don't set up a=
ctive streams twice")
Merging pci-current/for-linus (e253aaf PCI: Delay final fixups until resour=
ces are assigned)
Merging wireless/master (ccd384b mwifiex: fix setting of multicast filter)
Merging driver-core.current/driver-core-linus (9affd6b arm: fix mismerge of=
 arch/arm/mach-omap2/timer.c)
Merging tty.current/tty-linus (f722406 Linux 3.10-rc1)
Merging usb.current/usb-linus (f722406 Linux 3.10-rc1)
Merging staging.current/staging-linus (f722406 Linux 3.10-rc1)
Merging char-misc.current/char-misc-linus (f722406 Linux 3.10-rc1)
Merging input-current/for-linus (f0aacea Input: wacom - add a few new styli=
 for Cintiq series)
Merging md-current/for-linus (32f9f57 MD: ignore discard request for hard d=
isks of hybid raid1/raid10 array)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (3862de1 crypto: caam - fix job ring cleanup =
code)
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
Merging rr-fixes/fixes (c1be5a5 Linux 3.9)
Merging mfd-fixes/master (51a26ae Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/davem/net)
Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overfl=
ow)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (07961ac Linux 3.9-rc5)
Merging arm/for-next (0d240c9 Merge branch 'cleanup' into for-next)
Merging arm-perf/for-next/perf (ab87304 Merge branches 'perf/fixes' and 'hw=
-breakpoint' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (add/add): Merge conflict in arch/arm/mach-zynq/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
CONFLICT (content): Merge conflict in arch/arm/mach-highbank/highbank.c
Merging arm64/upstream (420c158d arm64: Treat the bitops index argument as =
an 'int')
Merging blackfin/blackfin-linus (5ae89ee bfin cache: dcplb map: add 16M dcp=
lb map for BF60x)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
Merging m68k/for-next (e00c73e m68k: Remove inline strlen() implementation)
Merging m68knommu/for-next (2842e5b0 m68knommu: enable Timer on coldfire 53=
2x)
Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB=
 =3D> 128KiB)
Merging microblaze/next (a047775 microblaze: Enable IRQ in arch_cpu_idle)
Merging mips/mips-for-linux-next (b22d1b6 Merge branch 'mti-next' of git://=
git.linux-mips.org/pub/scm/sjhill/linux-sjhill into mips-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (c1be5a5 Linux 3.9)
Merging powerpc/next (5737789 powerpc: Make hard_irq_disable() do the right=
 thing vs. irq tracing)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fdeaf0e powerpc/512x: add ifm ac14xx board)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (617e164 s390: disable pfmf for clear page instructio=
n)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (9fc1894 arch/tile: Fix syscall return value passed to =
tracepoint)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (b341d84 xtensa: Switch to asm-generic/linkage.h)
Merging btrfs/next (667e7d9 Btrfs: allow superblock mismatch from older mkf=
s)
Merging ceph/testing (b5b09be rbd: fix image request leak on parent read)
Merging cifs/for-next (c2b93e0 cifs: only set ops for inodes in I_NEW state)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
Merging ext3/for_next (e162b2f jbd: use kmem_cache_zalloc instead of kmem_c=
ache_alloc/memset)
Merging ext4/dev (a549984 ext4: revert "ext4: use io_end for multiple bios")
Merging f2fs/dev (f722406 Linux 3.10-rc1)
Merging fuse/for-next (60b9df7 fuse: add flag to turn on async direct IO)
Merging gfs2/master (222cb53 GFS2: Flush work queue before clearing glock h=
ash tables)
Merging jfs/jfs-next (73aaa22 jfs: fix a couple races)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (f722406 Linux 3.10-rc1)
Merging nfsd/nfsd-next (7255e71 nfsd: fix oops when legacy_recdir_name_erro=
r is passed a -ENOENT error)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (c1be5a5 Linux 3.9)
Merging ubifs/linux-next (c1be5a5 Linux 3.9)
Merging xfs/for-next (7dfbcbe xfs: fallback to vmalloc for large buffers in=
 xfs_compat_attrlist_by_handle)
Merging vfs/for-next (ac3e3c5 don't bother with deferred freeing of fdtable=
s)
Merging pci/next (d4f09c5 Merge branch 'pci/gavin-msi-cleanup' into next)
Merging hid/for-next (46b1897 Merge branch 'for-3.10/hid-debug' into for-ne=
xt)
Merging i2c/i2c/for-next (f722406 Linux 3.10-rc1)
Merging jdelvare-hwmon/master (1aaf6d3 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging hwmon-staging/hwmon-next (4fd72d8 hwmon: w83627ehf: Remove redundan=
t platform_set_drvdata())
Merging v4l-dvb/master (1d62caa Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (abc88a2 Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (3d9b935 libata: change maintainer)
Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into =
for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (16dde86 Merge branch 'pm-fixes-next' into linux-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (de6558d Merge branch 'MAINTAINERS-update' of .git int=
o next)
Merging ieee1394/for-next (6fe9efb firewire: ohci: dump_stack() for PHY reg=
s read/write failures)
Merging ubi/linux-next (f6161aa Linux 3.9-rc2)
Merging dlm/next (9000831 dlm: avoid unnecessary posix unlock)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (297b8a0 Merge branch 'postmerge' into for-linus)
Merging target-updates/for-next (04b59ba tcm_vhost: Enable VIRTIO_SCSI_F_HO=
TPLUG)
Merging target-merge/for-next-merge (b8d26b3 iser-target: Add iSCSI Extensi=
ons for RDMA (iSER) target driver)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (f722406 Linux 3.10-rc1)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (de9c9f8 Merge tag 'remoteproc-3.10' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/ohad/remoteproc)
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (a8a48e6 Merge tag 'nfc-next-3.10-4' of git://=
git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next)
Merging bluetooth/master (26b5afc Bluetooth: Mgmt Device Found Event)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (0d1ae36 mtd: nand: reword nand_chip bad block interf=
ace comments)
Merging crypto/master (3862de1 crypto: caam - fix job ring cleanup code)
Merging drm/drm-next (b9434d0 drm: Use names of ioctls in debug traces)
Merging drm-intel/for-linux-next (1ffc528 drm/i915: clear the stolen fb bef=
ore resuming)
Merging sound/for-next (6c35ae3 Revert "ALSA: hda - Don't set up active str=
eams twice")
Merging sound-asoc/for-next (dc1b018 Merge remote-tracking branch 'asoc/top=
ic/x86' into asoc-next)
Merging modules/modules-next (a53a11f3 modpost: fix unwanted VMLINUX_SYMBOL=
_STR expansion)
Merging virtio/virtio-next (01d779a caif_virtio: Remove bouncing email addr=
esses)
Merging input/next (d520145 Input: w90p910_keypad - remove redundant platfo=
rm_set_drvdata())
Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in co=
re)
Merging cgroup/for-next (2a0010a cpuset: fix compile warning when CONFIG_SM=
P=3Dn)
Merging block/for-next (410fa26 Merge branch 'for-3.10/drivers' into for-ne=
xt)
Merging device-mapper/master (2bb1cc4 Share configuration option processing=
 code between the dm cache ctr and message functions.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (f722406 Linux 3.10-rc1)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (8a965b3 mm, slab_common: Fix bootstrap creation of k=
malloc caches)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (ae59b84 dm-raid: silence compiler warning on rebuilds_=
per_group.)
Merging mfd/master (d7ab730 Merge tag 'mfd-3.10-1' of git://git.kernel.org/=
pub/scm/linux/kernel/git/sameo/mfd-next)
Merging battery/master (237a1b0 lp8788-charger: Fix kconfig dependency)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (0eeca66 Merge remote-tracking branch 'regulator=
/topic/isl6271a' into regulator-next)
Merging security/next (4726e8f security: clarify cap_inode_getsecctx descri=
ption)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (ded9d06 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/torvalds/linux)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (0c4513b Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/=
amd', 'ppc/pamu', 'core' and 'arm/tegra' into next)
Merging vfio/next (664e938 vfio: Set container device mode)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (071361d mm: Convert print_symbol to %pSR)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (9713fae EDAC: Merge mci.mem_is_per_rank with mci=
.csbased)
Merging devicetree/devicetree/next (3132f62 Merge branch 'for-next' of git:=
//sources.calxeda.com/kernel/linux into HEAD)
Merging dt-rh/for-next (a2b9ea7 Documentation/devicetree: make semantic of =
initrd-end more explicit)
Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the defaul=
t pin configuration)
Merging spi-mb/for-next (bdba7ad Merge remote-tracking branch 'spi/fix/gran=
t' into spi-linus)
Merging tip/auto-latest (57e87c1 Merge branch 'timers/urgent')
Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being=
 added)
Merging rcu/rcu/next (a9be854 Merge commit '6d87669357936bffa1e8fea7a4e7743=
e76905736' into next.2013.10.22a)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (f722406 Linux 3.10-rc1)
Merging kvm-arm/kvm-arm-next (b8022d7 arm: kvm: arch_timer: use symbolic co=
nstants)
CONFLICT (content): Merge conflict in arch/arm/kvm/arm.c
CONFLICT (content): Merge conflict in arch/arm/include/asm/kvm_host.h
Merging kvm-ppc/kvm-ppc-next (5975a2e KVM: PPC: Book3S: Add API for in-kern=
el XICS emulation)
Merging oprofile/for-next (23995bb oprofile, s390: Add support for IBM zEnt=
erprise EC12)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (0cd81a4 Merge branch 'stable/for-linus-3.10' in=
to linux-next)
Merging xen-arm/linux-next (47ae186 xen: rename xen_secondary_init and run =
it on every online cpu)
Merging percpu/for-next (a1b2a55 percpu: add documentation on this_cpu oper=
ations)
Merging workqueues/for-next (d325185 workqueue: workqueue_congested() shoul=
dn't translate WORK_CPU_UNBOUND into node number)
Merging drivers-x86/linux-next (a1ec56e Add support for fan button on Ideap=
ad Z580)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (0c62677 Merge remote-tracking branch 'regmap/topic=
/debugfs' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (5abef69 leds: lp5562: Properly setup of_device_id ta=
ble)
Merging driver-core/driver-core-next (9affd6b arm: fix mismerge of arch/arm=
/mach-omap2/timer.c)
Merging tty/tty-next (f722406 Linux 3.10-rc1)
Merging usb/usb-next (f722406 Linux 3.10-rc1)
Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
Merging staging/staging-next (999d594 STAGING: rtl8192u: fix checkpatch err=
or about pointer position in r8192U_dm.c)
Merging char-misc/char-misc-next (f722406 Linux 3.10-rc1)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (d463f82 pinctrl: fix mutex deadlock in get_pinctr=
l_dev_from_of_node())
Merging vhost/linux-next (0107b9b x86: uaccess s/might_sleep/might_fault/)
CONFLICT (content): Merge conflict in drivers/vhost/test.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (08ffb22 gpio: grgpio: Add irq support)
Merging gpio-lw/for-next (ab6ec0f gpio/omap: ensure gpio context is initial=
ised)
Merging gen-gpio/for_next (f4c5405 gpio: update gpio Chinese documentation)
Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of s=
izeof in mailbox_msg_send())
Merging arm-soc/for-next (a0cdbee Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (31880c3 Linux 3.9-rc6)
Merging cortex/for-next (4477ca4 ARM: ARMv7-M: Allow the building of new ke=
rnel port)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (3795b56 Merge branches 'mxs/dt-3.11' and 'imx/dt-=
3.11' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (1df357a Merge branch 'msm-defconfig' into for-next)
Merging renesas/next (46cd683 Merge branch 'heads/soc-sh73a0' into next)
CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/Kconfig
CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in renesa=
s/next and modified in HEAD. Version HEAD of drivers/leds/leds-renesas-tpu.=
c left in tree.
CONFLICT (content): Merge conflict in drivers/leds/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadill=
o800eva.c
$ git rm -f drivers/leds/leds-renesas-tpu.c
Merging samsung/for-next (e0f8f91 Merge branch 'next/late-exynos' into for-=
next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/cpuidle.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/exynos5250.dtsi
Merging tegra/for-next (c1be5a5 Linux 3.9)
Merging dma-mapping/dma-mapping-next (c1be5a5 Linux 3.9)
Merging pwm/for-next (affb923 pwm: lpc32xx: Don't change PWM_ENABLE bit in =
lpc32xx_pwm_config)
Merging dma-buf/for-next (b89e356 dma-buf: Add debugfs support)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (1e43525 clk: add clk_ignore_unused option to keep boo=
t clocks on)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (e0fd9af Merge tag 'rdma-for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/roland/infiniband)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/block/xsysace.c: fix id with missing port-number
Applying: rapidio: make enumeration/discovery configurable
Applying: rapidio: add enumeration/discovery start from user space
Applying: rapidio: documentation update for enumeration changes
Applying: fat: fix possible overflow for fat_clusters
Applying: wait: fix false timeouts when using wait_event_timeout()
Applying: mm: mmu_notifier: re-fix freed page still mapped in secondary MMU
Applying: mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-f=
ix
Applying: ocfs2: unlock rw lock if inode lock failed
Applying: drivers/video: implement a simple framebuffer driver
Applying: mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in unc=
harge
Applying: hfs: avoid crash in hfs_bnode_create
Applying: CPU hotplug: provide a generic helper to disable/enable CPU hotpl=
ug
Applying: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplu=
g-fix
Applying: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplu=
g-fix-fix
Applying: reboot: rigrate shutdown/reboot to boot cpu
Applying: shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugep=
age-size-fix
Applying: rapidio/tsi721: fix bug in MSI interrupt handling
Applying: mm compaction: fix of improper cache flush in migration code
Applying: kernel/audit_tree.c:audit_add_tree_rule(): protect `rule' from ki=
ll_rules()
Applying: ipcsem-fix-semctl-getzcnt-fix
Applying: ipcsem-fix-semctl-getncnt-fix
Applying: MAINTAINERS: update Hyper-V file list
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix
Applying: drivers/char/random.c: fix priming of last_data
Applying: random: fix accounting race condition with lockless irq entropy_c=
ount update
Applying: x86: mm: add missing comments for initial kernel direct mapping
Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: fix mq_open and mq_unlink to add the MQ root as a hidden p=
arent audit_names record
CONFLICT (content): Merge conflict in kernel/auditsc.c
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: posix_cpu_timer: consolidate expiry time type
Applying: posix_cpu_timers: consolidate timer list cleanups
Applying: posix_cpu_timers: consolidate expired timers check
Applying: selftests: add basic posix timers selftests
Applying: posix-timers: correctly get dying task time sample in posix_cpu_t=
imer_schedule()
Applying: posix_timers: Fix racy timer delta caching on task exit
Applying: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
Applying: configfs: use capped length for ->store_attribute()
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: clear_refs: sanitize accepted commands declaration
Applying: clear_refs: introduce private struct for mm_walk
Applying: pagemap: introduce pagemap_entry_t without pmshift bits
Applying: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
Applying: mm: soft-dirty bits for user memory changes tracking
Applying: pagemap: prepare to reuse constant bits with page-shift
Applying: mm/thp: use the correct function when updating access flags
Applying: mm, memcg: don't take task_lock in task_in_mem_cgroup
Applying: mm: remove free_area_cache
Applying: mm: remove compressed copy from zram in-memory
Applying: mm-remove-compressed-copy-from-zram-in-memory-fix
Applying: mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
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
Applying: err.h: IS_ERR() can accept __user pointers
Applying: dump_stack: serialize the output from dump_stack()
Applying: dump_stack-serialize-the-output-from-dump_stack-fix
Applying: panic: add cpu/pid to warn_slowpath_common in WARNING printk()s
Applying: panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: backlight: atmel-pwm-bl: remove unnecessary platform_set_drvdata()
Applying: backlight: ep93xx: remove unnecessary platform_set_drvdata()
Applying: backlight: lp8788: remove unnecessary platform_set_drvdata()
Applying: backlight: pcf50633: remove unnecessary platform_set_drvdata()
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/bitmap.c: speed up bitmap_find_free_region
Applying: lib-bitmapc-speed-up-bitmap_find_free_region-fix
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: init: remove permanent string buffer from do_one_initcall()
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
Applying: reiserfs: fix deadlock with nfs racing on create/lookup
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: idr: print a stack dump after ida_remove warning
Applying: idr-print-a-stack-dump-after-ida_remove-warning-fix
Applying: mwave: fix info leak in mwave_ioctl()
Applying: rapidio/switches: remove tsi500 driver
Applying: drivers/parport/share.c: use kzalloc
Applying: drivers/w1/slaves/w1_ds2408.c: add magic sequence to disable P0 t=
est mode
Applying: drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-tes=
t-mode-fix
Applying: relay: fix timer madness
Applying: aio: reqs_active -> reqs_available
Applying: aio: percpu reqs_available
Applying: generic dynamic per cpu refcounting
Applying: aio: percpu ioctx refcount
Applying: aio: use xchg() instead of completion_lock
Applying: block: prep work for batch completion
Applying: block-prep-work-for-batch-completion-fix-2
Applying: block-prep-work-for-batch-completion-fix-3
Applying: block-prep-work-for-batch-completion-fix-3-fix
Applying: block-prep-work-for-batch-completion-fix-99
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: block, aio: batch completion for bios/kiocbs
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: fix kioctx not being freed after cancellation at exit time
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
Applying: seccomp: add generic code for jitted seccomp filters.
Applying: ARM: net: bpf_jit: make code generation less dependent on struct =
sk_filter.
Applying: ARM: bpf_jit: seccomp filtering: fixup merge conflict
Applying: ARM: net: bpf_jit: add support for jitted seccomp filters.
Applying: bpf: add comments explaining the schedule_work() operation
Merging akpm/master (123905d bpf: add comments explaining the schedule_work=
() operation)

--Signature=_Mon__13_May_2013_12_54_20_+1000_gO=yoE_dgwy3SDnd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkFXcAAoJEECxmPOUX5FEMhkQAKfufNxdj2PhT8vX9tS0T79K
aCB1p6QLzOpish6bwAzIy91D8ylP5n5E+ToRmvn0xaI1Csax5g7McYA7i3w1wCFI
+XAUNbDv2BbKNomuT2DkLvuwsK9/3kCJLHyPg/AU3z7NDG5kwT367YaCB0VMI1aW
fuKC6oVc4rSR0+zCMCJANlO+Ei0+1zOBPikoqZw+8x3U0Hk02RT+FV10klCYfQAd
J0Gt88cvTUH0RstG4T2EOoDkv207fLVtv2uZ+GDnnga99D5QzK7O7k59LBx/7Igy
5hYrXNSeeOvRMBULquI6cDlCaeRo9locQ0RKeM+ttkqmIt300sFvN1OJnJDuCLDJ
ovl1ZTrXCUNKAUIf4PELe7McNtdNJ4xv+ic/0JgDHMcKI2Luz9wLb5aSZrC1cer0
DsG/Lnscfjjxo+DjfSQ2Pyaodyfa6VT0z5yskQEuv977l4D0IhR3w4VWZb8Ut9fu
bQTvsDh0Z5Q2VfYi8hV0dyyjJ13w+UvzROFaMGFD8PQkDdZ1c3CsaaV4f/w4PxUL
8x0Yox/ly+04T6sSSZjS5jnNp2s4R1Z+rKz77oLWTc4P9fyGV+n5pC+5aOnZ0zz4
ufeU9GRQ0eik2PhquAePoVMf0302r8ydI0yAvbPEaAFi8FRZGfr9p8nLZynr5zQN
QyuF6y9oiUNY1ZSm42Bq
=6yeW
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_12_54_20_+1000_gO=yoE_dgwy3SDnd--
