Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3I0JFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 05:05:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40678 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3I0JFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 05:05:33 -0400
Date: Fri, 27 Sep 2013 19:05:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sep 27
Message-Id: <20130927190520.ab376c737166be4841ff46e4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_19_05_20_+1000_c5ovxr8LNQs1qUj6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_19_05_20_+1000_c5ovxr8LNQs1qUj6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Heads up: I will be having a 3 week break leading up to the kernel
summit.  This means that next-20130927 (today) will be the last
linux-next release until next-20131028 (or maybe 29).  I presume that
Linus will be up to v3.12-rc7 by then and -rc7 is often the last before
a release ... Please plan accordingly.

Changes since 20130926:

The ceph tree lost its build failure but had another for which I applied
a merge fix patch.

The net-next tree gained a conflict against the wireless tree.

The wireless-next tree gained a conflict against the net-next tree.

The bluetooth tree gained a conflict against the wireless tree.

The omap_dss2 tree gained a conflict against the fbdev tree.

The mmc tree gained a build failure for which I applied a patch.

The tip tree gained a conflict against the h8300-remove tree.

The tty tree gained a build failure for which I reverted 2 commits.

The char-misc tree gained a build failure for which I added a merge fix
patch and another for which I disable a driver.

The akpm-current tree gained a build failure for which I applied a merge
fix patch.

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

We are up to 214 trees (counting Linus' and 30 trees of patches pending
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
Merging origin/master (4b97280 Merge tag 'stable/for-linus-3.12-rc2-tag' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip)
Merging fixes/master (fa8218d Merge tag 'regmap-v3.11-rc7' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (272b98c Linux 3.12-rc1)
Merging arm-current/fixes (40190c8 ARM: 7837/3: fix Thumb-2 bug in AES asse=
mbler code)
Merging m68k-current/for-linus (5549005 m68k/atari: ARAnyM - Always use phy=
sical addresses in NatFeat calls)
Merging metag-fixes/fixes (3b2f64d Linux 3.11-rc2)
Merging powerpc-merge/merge (dbe78b4 powerpc/pseries: Do not start secondar=
ies in Open Firmware)
Merging sparc/master (4de9ad9 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/cmetcalf/linux-tile)
Merging net/master (207070f via-rhine: fix VLAN priority field (PCP, IEEE 8=
02.1p))
Merging ipsec/master (cd808fc xfrm: Fix aevent generation for each received=
 packet)
Merging sound-current/for-linus (f82d7d1 ALSA : hda - not use assigned conv=
erters for all unused pins)
Merging pci-current/for-linus (4a10c2a Linux 3.12-rc2)
Merging wireless/master (c7515d2 brcmsmac: call bcma_core_pci_power_save() =
from non-atomic context)
Merging driver-core.current/driver-core-linus (f123db8 driver core : Fix us=
e after free of dev->parent in device_shutdown)
Merging tty.current/tty-linus (2332575 tty: ar933x_uart: move devicetree bi=
nding documentation)
Merging usb.current/usb-linus (85601f8 usb: dwc3: add support for Merrifiel=
d)
Merging staging.current/staging-linus (df3f4ed staging: r8188eu: Add new de=
vice ID)
Merging char-misc.current/char-misc-linus (8bbf9f4 Drivers: hv: vmbus: Term=
inate vmbus version negotiation on timeout)
Merging input-current/for-linus (2f0d260 Input: i8042 - i8042_flush fix for=
 a full 8042 buffer)
Merging md-current/for-linus (f94c0b6 md/raid5: fix interaction of 'replace=
' and 'recovery'.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (26052f9 crypto: crct10dif - Add fallback for=
 broken initrds)
Merging ide/master (64110c1 ide: sgiioc4: Staticize ioc4_ide_attach_one())
Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging devicetree-current/devicetree/merge (cf9e236 of/irq: init struct re=
source to 0 in of_irq_to_resource())
Merging rr-fixes/fixes (6c2580c Merge branch 'for-linus' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (d24cdbf vfio-pci: Avoid deadlock on remove)
Merging drm-intel-fixes/for-linux-next-fixes (d322704 drm/i915: Fix up usag=
e of SHRINK_STOP)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (d8dfad3 Linux 3.11-rc7)
Merging arm/for-next (87b8156 Merge branches 'devel-stable', 'fixes', 'misc=
' and 'mmci' into for-next)
Merging arm-perf/for-next/perf (fee4f2c drivers: CCI: fix the error handle =
in cci_pmu_probe())
Merging arm64/upstream (fc18047 arm64: use correct register width when retr=
ieving ASID)
Merging blackfin/for-linus (08b67fa blackfin: Ignore generated uImages)
Merging c6x/for-linux-next (1a81b94 c6x: remove unused parameter in Kconfig)
Merging cris/for-next (be8cb7f CRIS: drop unused Kconfig symbols)
Merging h8300-remove/h8300-remove (e9783b0 Revert "drivers: parport: Kconfi=
g: exclude h8300 for PARPORT_PC")
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d37bbb3 Merge branch 'pstore' into next)
Merging m68k/for-next (77a4279 m68k: Remove deprecated IRQF_DISABLED)
Merging m68knommu/for-next (272b98c Linux 3.12-rc1)
Merging metag/for-next (b6ef916 irq-imgpdc: add ImgTec PDC irqchip driver)
Merging microblaze/next (d5d04bb Bye, bye, WfW flag)
Merging mips/mips-for-linux-next (3b9731e Merge branch '3.12-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9f0f4fb parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (8d7551e Merge tag 'cris-for-3.12' of git://jni.nu/cri=
s)
Merging mpc5xxx/next (f2110cb dts: mpc512x: prepare for preprocessor suppor=
t)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (04dead2 s390/uaccess: always run the kernel in home =
space)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (e823acc tile: remove stray blank space)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (8872366 xtensa: Fix broken allmodconfig build)
Merging aio-direct/for-next (85f8fb7 tmpfs: add support for read_iter and w=
rite_iter)
Merging btrfs/next (d7396f0 Btrfs: optimize key searches in btrfs_search_sl=
ot)
Merging ceph/master (d4ce96d ceph: Implement writev/pwritev for sync operat=
ion.)
Applying: ceph: fix up for iov_iter changes
Merging cifs/for-next (ffe67b5 [CIFS] update cifs.ko version)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (3cc69b6 Merge tag 'fixes-for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging ext3/for_next (721a769 reiserfs: fix race with flush_used_journal_l=
ists and flush_journal_list)
Merging ext4/dev (ad4eec6 ext4: allow specifying external journal by pathna=
me mount option)
Merging f2fs/dev (2c371a6 remount - don't error on xattr and acl options)
Merging fscache/fscache (996a249 NFS: Use i_writecount to control whether t=
o get an fscache cookie in nfs_open())
Merging fuse/for-next (dd4726a vfs: introduce d_instantiate_no_diralias())
Merging gfs2/master (5ca1db4 GFS2: fix dentry leaks)
Merging jfs/jfs-next (8660998 jfs: fix error path in ialloc)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (4a10c2a Linux 3.12-rc2)
Merging nfsd/nfsd-next (d4a5165 rpc: let xdr layer allocate gssproxy receie=
ve pages)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (9e01242 Squashfs: add corruption check for type in=
 squashfs_readdir())
Merging v9fs/for-next (50192ab fs/9p: avoid accessing utsname after namespa=
ce has been torn down)
Merging ubifs/linux-next (c23e9b7 UBIFS: remove invalid warn msg with tst_r=
ecovery enabled)
Merging xfs/for-next (566055d xfs: log recovery lsn ordering needs uuid che=
ck)
Merging vfs/for-next (dc03a60 do_remount(): pull touch_mnt_namespace() up)
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
Merging pci/next (63495ff Merge branch 'pci/yijing-pci_is_pcie-v2' into nex=
t)
Merging hid/for-next (ebd9995 Merge branch 'for-3.13/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (272b98c Linux 3.12-rc1)
Merging jdelvare-hwmon/master (e5c832d vfs: fix dentry RCU to refcounting p=
ossibly sleeping dput())
Merging hwmon-staging/hwmon-next (fc2c4cc hwmon: (lm70) Remove redundant sp=
i_set_drvdata)
Merging v4l-dvb/master (92852b8 Merge branch 'patchwork' into to_next: gspc=
a and vb2 patches)
Merging kbuild/for-next (1e1a5f4 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (5748aea pata_isapnp: Don't use invalid I/O ports)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (aaa8522 Merge branch 'acpi-fixes-next' into linux-ne=
xt)
Merging idle/next (d7b0a1b intel_idle: Support Intel Atom Processor C2000 P=
roduct Family)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (74ae45a Merge branches 'x86_pkg_temp' and 'misc' of .=
git into next)
Merging ieee1394/for-next (db9ae8f firewire: ohci: Fix deadlock at bus rese=
t)
Merging ubi/linux-next (8930fa5 UBI: Fix invalidate_fastmap())
Merging dlm/next (c6ca7bc dlm: remove signal blocking)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (9be1d5a Merge branch 'for-linus' into next)
Merging dmaengine/next (4a43f39 dmaengine: dma_sync_wait and dma_find_chann=
el undefined)
Merging net-next/master (aae8c28 Merge branch 'bonding_neighbours')
CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/brcmfm=
ac/dhd_bus.h
Merging ipsec-next/master (aba8269 {ipv4,xfrm}: Introduce xfrm_tunnel_notif=
ier for xfrm tunnel mode callback)
CONFLICT (content): Merge conflict in include/net/xfrm.h
Merging wireless-next/master (772eb43 rt2x00: Fix rf register for RT3070)
CONFLICT (content): Merge conflict in drivers/net/wireless/rtlwifi/rtl8192c=
e/phy.h
Merging bluetooth/master (4375f10 Bluetooth: Add new mgmt_set_advertising c=
ommand)
CONFLICT (content): Merge conflict in net/bluetooth/hci_core.c
Merging infiniband/for-next (4a10c2a Linux 3.12-rc2)
Merging mtd/master (ef9a61b Merge tag 'for-linus-20130909' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (7a88659 mtd: nand: correct extemded param page error=
 handling)
Merging crypto/master (48e6dc1 crypto: dcp - Fix the path for releasing the=
 resources)
Merging drm/drm-next (86a7e12 Merge branch 'exynos-drm-next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next)
Merging drm-intel/for-linux-next (cd29830 drm/i915: Restore global mappings=
 upon resume)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_display.c
Merging drm-tegra/drm/for-next (03da0e7 drm/tegra: Parse device tree earlie=
r)
Merging sound/for-next (e84841f ALSA: firewire-lib: use inlune function to =
calculate frame bytes)
Merging sound-asoc/for-next (a56d586 Merge remote-tracking branch 'asoc/top=
ic/wm8400' into asoc-next)
Merging modules/modules-next (942e443 module: Fix mod->mkobj.kobj potential=
ly freed too early)
Merging virtio/virtio-next (9e266ec virtio_pci: pm: Use CONFIG_PM_SLEEP ins=
tead of CONFIG_PM)
Merging input/next (9a35c41 Input: wacom - add support for three new Intuos=
 Pro devices)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (7dc1502 Merge branch 'for-3.13' into for-next)
CONFLICT (content): Merge conflict in mm/memcontrol.c
Merging block/for-next (808854a Merge branch 'for-3.12/core' into for-next)
CONFLICT (content): Merge conflict in drivers/md/bcache/writeback.c
CONFLICT (content): Merge conflict in drivers/md/bcache/request.c
CONFLICT (content): Merge conflict in drivers/md/bcache/journal.c
CONFLICT (content): Merge conflict in drivers/md/bcache/bset.c
CONFLICT (content): Merge conflict in drivers/md/bcache/bcache.h
Merging device-mapper/for-next (e860313 dm: add reserved_bio_based_ios modu=
le parameter)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (5327990 mmc: sdhci-esdhc-imx: set actual_clock in clo=
ck setting)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (23774a2 slab: Use correct GFP_DMA constant)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (bfc90cb raid5: only wakeup necessary threads)
Merging mfd/master (9c31e88 Merge tag 'mfd-lee-3.12-2' of git://git.linaro.=
org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (0b67865 Merge branch 'mfd-asoc' into for-mfd-n=
ext)
Merging battery/master (db15e63 rx51_battery: Fix channel number when readi=
ng adc value)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (16bf90f Merge branches '3.13/fbdev-misc' and '3=
.13/hdmi-regs' into for-next)
CONFLICT (content): Merge conflict in drivers/video/atmel_lcdfb.c
Merging regulator/for-next (5f6d777 Merge remote-tracking branch 'regulator=
/topic/tps6524x' into regulator-next)
Merging security/next (5a5f2ac selinux: add Paul Moore as a SELinux maintai=
ner)
Merging selinux/master (42d64e1 selinux: correct locking in selinux_netlbl_=
socket_connect))
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (3cbf548 watchdog: hpwdt: Patch to ignore auxilary =
iLO devices)
Merging dwmw2-iommu/master (e5d0c87 Merge tag 'iommu-updates-v3.12' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (6796ec4 Merge branches 'iommu/fixes', 'tracing', 'core'=
 and 'arm/tegra' into next)
Merging vfio/next (dac09b5 vfio: fix documentation)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (2e515bf Merge branch 'for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/jikos/trivial)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging devicetree/devicetree/next (2bc552d of/platform: add error reportin=
g to of_amba_device_create())
Merging dt-rh/for-next (8851b9f include: dt-binding: input: create a DT hea=
der defining key codes.)
Merging spi/for-next (03010d5 Merge remote-tracking branch 'spi/topic/topcl=
iff' into spi-next)
Merging tip/auto-latest (9d80645 Merge branch 'x86/uv')
CONFLICT (modify/delete): arch/h8300/include/asm/Kbuild deleted in HEAD and=
 modified in tip/auto-latest. Version tip/auto-latest of arch/h8300/include=
/asm/Kbuild left in tree.
$ git rm -f arch/h8300/include/asm/Kbuild
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (75a9551 cpc925_edac: Use proper array terminatio=
n)
Merging ftrace/for-next (a0a5a05 ftrace/rcu: Do not trace debug_lockdep_rcu=
_enabled())
Merging rcu/rcu/next (3153e8c Merge branch 'idle.2013.09.25a' into HEAD)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (6a3f95a KVM: s390: Intercept SCK instruction)
Merging kvm-arm/kvm-arm-next (1fe40f6 ARM: KVM: Add newlines to panic strin=
gs)
Merging kvm-ppc/kvm-ppc-next (6b9e4fa Merge tag 'kvm-arm-for-3.12' of git:/=
/git.linaro.org/people/cdall/linux-kvm-arm into queue)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (5efadb4 Merge branch 'stable/for-linus-3.12' in=
to linux-next)
Merging percpu/for-next (f851c8d percpu: fix bootmem error handling in pcpu=
_page_first_chunk())
Merging workqueues/for-next (016564d workqueue: fix pool ID allocation leak=
age and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (5c07eae platform/x86: panasonic-laptop: reu=
se module_acpi_driver)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (dfa6f4c Merge remote-tracking branch 'regmap/topic=
/range' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (271c111 leds: dac124s085: Remove redundant spi_set_d=
rvdata)
Merging driver-core/driver-core-next (9d3fde8 backlight: atmel-pwm-bl: fix =
deferred probe from __init)
Merging tty/tty-next (3415097 vt: properly ignore xterm-256 colour codes)
Merging usb/usb-next (6741448 usb: wusbcore: set pointers to NULL after fre=
eing in error cases)
Merging usb-gadget/next (272b98c Linux 3.12-rc1)
Merging staging/staging-next (cb9cfd7 staging: comedi: 8253.h: tidy up the =
i8253_cascade_ns_to_timer*() users)
Merging char-misc/char-misc-next (33b0693 hv: vmbus: fix vmbus_recvpacket_r=
aw() return code)
Applying: Intel MIC Host Driver: fix for sysfs_get_dirent API change
Merging scsi/for-next (fc85799 [SCSI] fnic: fnic Driver Tuneables Exposed t=
hrough CLI)
Merging target-updates/for-next (2999ee7 target/iscsi: Bump versions to v4.=
1.0)
Merging target-merge/for-next-merge (d4e4ab8 Linux 3.11-rc5)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging writeback/writeback-for-next (a885599 writeback: Do not sort b_io l=
ist only because of block device inode)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (cfa8b3f Merge branch 'devel' into for-next)
Merging vhost/linux-next (d3d665a vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (63f57cd gpio: pcf857x: Add OF support)
Merging arm-soc/for-next (e4f7a53 NEXT: ARM: add arm-soc-for-next-contents.=
txt)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (6868a89 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (9e6b28e Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
Merging mvebu/for-next (67f6928 Merge branch 'mvebu/dove_pcie-mbus-dt' into=
 for-next)
Merging renesas/next (1730b36 Merge branch 'heads/boards' into next)
Merging samsung/for-next (28ca23d Merge branch 'v3.13-next/dt-s3c64xx' into=
 for-next)
Merging tegra/for-next (2b6d21a Merge branch for-3.13/maintainers into for-=
next)
Merging dma-mapping/dma-mapping-next (d5d04bb Bye, bye, WfW flag)
Merging pwm/for-next (ceb12f9 pwm: atmel-tcb: fix max time computation for =
slow clk source)
Merging dma-buf/for-next (19e8697 dma-buf: Expose buffer size to userspace =
(v2))
Merging userns/for-next (c7b96ac userns:  Kill nsown_capable it makes the w=
rong thing easy)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (12d29886 clk: only call get_parent if there is one)
Merging random/dev (45ee64e random: adjust the generator polynomials in the=
 mixing function slightly)
CONFLICT (content): Merge conflict in init/main.c
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging aio/master (4b97280 Merge tag 'stable/for-linus-3.12-rc2-tag' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/xen/tip)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (73612ff ipc/util.c: remove unnecessary work p=
ending test)
CONFLICT (content): Merge conflict in arch/x86/mm/init.c
Applying: x86/mem-hotplug: fix for bad merge
$ git checkout -b akpm remotes/origin/akpm/master
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Merging akpm/master (fe79026 mm-drop-actor-argument-of-do_generic_file_read=
-fix)
[master 1d81f7b] Revert "serial: 8250_dw: provide a filter for DMA channel =
detection"
[master 0d618d1] Revert "serial: 8250_dw: don't limit DMA support to ACPI"
Applying: mmc: sdhci-esdhc: temporary build fix
Applying: disable broken Intel MIC Card Driver for X100 family for now
Applying: disable broken Intel MIC Card Driver for X100 family for now

--Signature=_Fri__27_Sep_2013_19_05_20_+1000_c5ovxr8LNQs1qUj6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRUpVAAoJEMDTa8Ir7ZwVFgkP/2BNucJ7cv770QUjak+swI3J
1lF5txdvKwzaTDmkFTC5/F2nlfTJQIQ1eAZ6B3iZpoCv2W2FBaaqbW8tIPTK4pcn
pgJy3ioLaaolSKepv0W08FWJLocSONEZHbDZxW8PXRGT+wA8Ym+Sqa6gfzPw9Wkq
sR7fVjmUzJqxaZX8MFr0cTvuKKze6vdESfj+BRvJ7V2FNBcUKdJhspbTtvmeK8u8
X8N/5Mw5fPctU91EHPeqFSoEXeaxl2Sa7CypUzH/v13hVLgSY8RbnFRpDpB/4XlU
/OS1xaFAaB7oSJQvzmx2FvdM2I4G0fgNUwRXI/wN9LFGovoq8iLQi/d6G8V5bjq+
wAojH9A+fjZs0zIxwZdQa3Ok511TgCjJOTfNRhciYnBiOJr4wU198mNhGCqwa0iT
20tBSqmfNbR5Unrjk5m3HF7iNRDyvtjUCwpuZHeQgtT0Ldo3YfkXNXsnCyBMPkVM
DV2g6V60hdoAW4RwHNUVIlFcbJJXYRG1cXUrkOz2sIRcJxYR8aA4OfY8bozGZ82Q
TlAgE35crg89qH+f0mBZNEJyueIgoQu/J3T6d2hgrKu23Zr3Ve6x3EEjG1UGkFi7
sZT2Thdx79aaoG6F2PVxZxLL6c8tJwYepSJOOyeAt8OV5PCfpwFYmoxSJFm2AJuW
7ayembBtnywN+rVowktr
=Hn7A
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_19_05_20_+1000_c5ovxr8LNQs1qUj6--
