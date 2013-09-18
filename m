Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab3IRFHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 01:07:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53032 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRFHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 01:07:40 -0400
Date: Wed, 18 Sep 2013 15:07:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Sep 18
Message-Id: <20130918150729.558687602f350b5aa4bacd95@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_15_07_29_+1000_B3JIXZdDbOvJCYoo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_15_07_29_+1000_B3JIXZdDbOvJCYoo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130917:

Removed trees: davinci, 4xx, hwpoison, ptr-ret (all finished with)

The vfs tree gained a conflict against the aio-direct tree.

The drm-intel tree gained conflicts against Linus' tree.

The gpio tree gained a build failure so I used the version from
next-20130917.

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

We are up to 218 trees (counting Linus' and 30 trees of patches pending
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
Merging origin/master (de0bc3d Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/cmetcalf/linux-tile)
Merging fixes/master (fa8218d Merge tag 'regmap-v3.11-rc7' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (272b98c Linux 3.12-rc1)
Merging arm-current/fixes (272b98c Linux 3.12-rc1)
Merging m68k-current/for-linus (21e884b m68k/m68knommu: Implement __get_use=
r_unaligned/__put_user_unaligned())
Merging metag-fixes/fixes (3b2f64d Linux 3.11-rc2)
Merging powerpc-merge/merge (363edbe powerpc: Default arch idle could cede =
processor on pseries)
Merging sparc/master (4de9ad9 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/cmetcalf/linux-tile)
Merging net/master (269aa75 tcp: fix RTO calculated from cached RTT)
Merging ipsec/master (73a695f cxgb4: remove workqueue when driver registrat=
ion fails)
Merging sound-current/for-linus (3d0049e Merge tag 'asoc-v3.12-4' of git://=
git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (a923874 Merge tag 'pci-v3.12-changes' of git=
://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging wireless/master (f4e1a4d rt2800: change initialization sequence to =
fix system freeze)
Merging driver-core.current/driver-core-linus (272b98c Linux 3.12-rc1)
Merging tty.current/tty-linus (93a8d41 n_tty: Fix EOF push index when termi=
os changes)
Merging usb.current/usb-linus (42f4891 Merge tag 'fixes-for-v3.12-rc2' of g=
it://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging staging.current/staging-linus (c3cb718 staging: line6: add bounds c=
heck in snd_toneport_source_put())
Merging char-misc.current/char-misc-linus (272b98c Linux 3.12-rc1)
Merging input-current/for-linus (c7dc657 Input: evdev - add EVIOCREVOKE ioc=
tl)
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
Merging drm-intel-fixes/for-linux-next-fixes (571c608 drm/i915: kill set_ne=
ed_resched)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (d8dfad3 Linux 3.11-rc7)
Merging arm/for-next (7f63037 Merge branch 'iks_for_rmk' of git://git.linar=
o.org/people/nico/linux into devel-stable)
Merging arm-perf/for-next/perf (e65c630 Merge branch 'for-arm-soc/cci-pmu-v=
2' into for-next/perf)
Merging arm64/upstream (4d5e0b1 Documentation/arm64: clarify requirements f=
or DTB placement)
Merging blackfin/for-linus (08b67fa blackfin: Ignore generated uImages)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (be8cb7f CRIS: drop unused Kconfig symbols)
Merging h8300-remove/h8300-remove (e9783b0 Revert "drivers: parport: Kconfi=
g: exclude h8300 for PARPORT_PC")
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (d37bbb3 Merge branch 'pstore' into next)
Merging m68k/for-next (21e884b m68k/m68knommu: Implement __get_user_unalign=
ed/__put_user_unaligned())
Merging m68knommu/for-next (c065edd m68k: remove 16 unused boards in Kconfi=
g.machine)
Merging metag/for-next (b6ef916 irq-imgpdc: add ImgTec PDC irqchip driver)
Merging microblaze/next (d5d04bb Bye, bye, WfW flag)
Merging mips/mips-for-linux-next (8c3014f Merge branch '3.12-fixes' into mi=
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
Merging s390/features (044aa01 s390/krobes: allow kprobes only on known ins=
tructions)
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
Merging aio-direct/for-next (285503d tmpfs: add support for read_iter and w=
rite_iter)
Merging btrfs/next (d7396f0 Btrfs: optimize key searches in btrfs_search_sl=
ot)
Merging ceph/master (9c89d62 fscache: check consistency does not decrement =
refcount)
Merging cifs/for-next (272b98c Linux 3.12-rc1)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (3cc69b6 Merge tag 'fixes-for-linus' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/arm/arm-soc)
Merging ext3/for_next (97a2847 Merge branch 'for-3.12' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jeffm/linux-reiserfs into for_next_testing)
Merging ext4/dev (ad4eec6 ext4: allow specifying external journal by pathna=
me mount option)
Merging f2fs/dev (26b0332 Merge tag 'dmaengine-3.12' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/djbw/dmaengine)
Merging fscache/fscache (19ce0a7 CIFS: FS-Cache: Uncache unread pages in ci=
fs_readpages() before freeing them)
Merging fuse/for-next (58111cc fuse: fix race in fuse_writepages())
Merging gfs2/master (b870890 GFS2: Do not reset flags on active reservation=
s)
Merging jfs/jfs-next (8660998 jfs: fix error path in ialloc)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (272b98c Linux 3.12-rc1)
Merging nfsd/nfsd-next (d4a5165 rpc: let xdr layer allocate gssproxy receie=
ve pages)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (9e01242 Squashfs: add corruption check for type in=
 squashfs_readdir())
Merging v9fs/for-next (50192ab fs/9p: avoid accessing utsname after namespa=
ce has been torn down)
Merging ubifs/linux-next (c23e9b7 UBIFS: remove invalid warn msg with tst_r=
ecovery enabled)
Merging xfs/for-next (08474ed xfs: remove dead code from xlog_recover_inode=
_pass2)
Merging vfs/for-next (12afe8c 9p: don't forget to destroy inode cache if fs=
cache registration fails)
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
Merging pci/next (a923874 Merge tag 'pci-v3.12-changes' of git://git.kernel=
.org/pub/scm/linux/kernel/git/helgaas/pci)
Merging hid/for-next (2f39579 Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (b720423 i2c: rcar: add rcar-H2 support)
Merging jdelvare-hwmon/master (e5c832d vfs: fix dentry RCU to refcounting p=
ossibly sleeping dput())
Merging hwmon-staging/hwmon-next (947d907 hwmon: (jc42) Convert to use devm=
_hwmon_device_register_with_groups)
Merging v4l-dvb/master (d6cd75e Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in drivers/media/platform/s5p-mfc/s5p_mf=
c_dec.c
Merging kbuild/for-next (1e1a5f4 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (062728a Merge branch 'for-3.12' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (032fb7d Merge branch 'acpi-pci-next' into linux-next)
Merging idle/next (d7b0a1b intel_idle: Support Intel Atom Processor C2000 P=
roduct Family)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (50e66c7 drivers: thermal: add check when unregisterin=
g cpu cooling)
Merging ieee1394/for-next (db9ae8f firewire: ohci: Fix deadlock at bus rese=
t)
Merging ubi/linux-next (8930fa5 UBI: Fix invalidate_fastmap())
Merging dlm/next (c6ca7bc dlm: remove signal blocking)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (f88a747 Merge branch 'for-linus' into next)
Merging dmaengine/next (4a43f39 dmaengine: dma_sync_wait and dma_find_chann=
el undefined)
Merging net-next/master (e7d33bb lockref: add ability to mark lockrefs "dea=
d")
Merging ipsec-next/master (aba8269 {ipv4,xfrm}: Introduce xfrm_tunnel_notif=
ier for xfrm tunnel mode callback)
CONFLICT (content): Merge conflict in include/net/xfrm.h
Merging wireless-next/master (f212781 net: ipv6: mld: document force_mld_ve=
rsion in ip-sysctl.txt)
Merging bluetooth/master (52de599 Bluetooth: Only schedule raw queue when u=
ser channel is active)
Merging infiniband/for-next (82af24a Merge branches 'cxgb4', 'flowsteer', '=
ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (ef9a61b Merge tag 'for-linus-20130909' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (3de6054 mtd: onenand: omap: remove two unused functi=
ons)
Merging crypto/master (1005bcc crypto: caam - enable instantiation of all R=
NG4 state handles)
Merging drm/drm-next (86a7e12 Merge branch 'exynos-drm-next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos into drm-next)
Merging drm-intel/for-linux-next (507c1a4 drm/i915: check for more ASLC int=
errupts)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_drv.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Merging drm-tegra/drm/for-next (03da0e7 drm/tegra: Parse device tree earlie=
r)
Merging sound/for-next (bf69aa9 ALSA: rme9652: Remove redundant break)
Merging sound-asoc/for-next (7bd3eee Merge remote-tracking branch 'asoc/top=
ic/wm8400' into asoc-next)
Merging modules/modules-next (942e443 module: Fix mod->mkobj.kobj potential=
ly freed too early)
Merging virtio/virtio-next (9e266ec virtio_pci: pm: Use CONFIG_PM_SLEEP ins=
tead of CONFIG_PM)
Merging input/next (52764fe Input: add SYN_MAX and SYN_CNT constants)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (58b79a9 cgroup: fix cgroup post-order descendant w=
alk of empty subtree)
Merging block/for-next (0cf6343 Merge branch 'for-3.12/core' into for-next)
Merging device-mapper/for-next (7fff5e8 dm stripe: silence a couple sparse =
warnings)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (272b98c Linux 3.12-rc1)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (23774a2 slab: Use correct GFP_DMA constant)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (bfc90cb raid5: only wakeup necessary threads)
Merging mfd/master (9c31e88 Merge tag 'mfd-lee-3.12-2' of git://git.linaro.=
org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (cb28a30 mfd: wm8994: Remove unused irq_lock)
Merging battery/master (db15e63 rx51_battery: Fix channel number when readi=
ng adc value)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (6f001cc Merge branch '3.12/dss-legacy-removal' =
into for-next)
Merging regulator/for-next (bb9a6a2 Merge remote-tracking branch 'regulator=
/topic/stw481x' into regulator-next)
Merging security/next (7320336 Merge branch 'smack-for-3.12' of git://git.g=
itorious.org/smack-next/kernel into ra-next)
Merging selinux/master (0b4bdb3 Revert "SELinux: do not handle seclabel as =
a special flag")
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (272b98c Linux 3.12-rc1)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (d6a60fc Merge branches 'arm/exynos', 'ppc/pamu', 'arm/s=
mmu', 'x86/amd' and 'iommu/fixes' into next)
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
Merging spi/for-next (3a59add Merge remote-tracking branch 'spi/topic/tegra=
' into spi-next)
Merging tip/auto-latest (3ef354f Merge branch 'x86/urgent')
CONFLICT (modify/delete): include/linux/time-armada-370-xp.h deleted in HEA=
D and modified in tip/auto-latest. Version tip/auto-latest of include/linux=
/time-armada-370-xp.h left in tree.
$ git rm -f include/linux/time-armada-370-xp.h
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (75a9551 cpc925_edac: Use proper array terminatio=
n)
Merging ftrace/for-next (a0a5a05 ftrace/rcu: Do not trace debug_lockdep_rcu=
_enabled())
Merging rcu/rcu/next (25f27ce Merge branches 'doc.2013.08.19a', 'fixes.2013=
.08.20a', 'sysidle.2013.08.31a' and 'torture.2013.08.20a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (272b98c Linux 3.12-rc1)
Merging kvm-arm/kvm-arm-next (1fe40f6 ARM: KVM: Add newlines to panic strin=
gs)
Merging kvm-ppc/kvm-ppc-next (6b9e4fa Merge tag 'kvm-arm-for-3.12' of git:/=
/git.linaro.org/people/cdall/linux-kvm-arm into queue)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (5582c05 Merge remote branch 'xentip/stable/for-=
linus-3.12' into linux-next)
Merging percpu/for-next (abec1a8 percpu: Make __verify_pcu_ptr handle per c=
pu pointers to arrays)
Merging workqueues/for-next (016564d workqueue: fix pool ID allocation leak=
age and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (5c07eae platform/x86: panasonic-laptop: reu=
se module_acpi_driver)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (fdf2002 regmap: add regmap_field_update_bits())
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (bf178f3 leds: lp55xx: enable setting default trigger)
Merging driver-core/driver-core-next (272b98c Linux 3.12-rc1)
Merging tty/tty-next (272b98c Linux 3.12-rc1)
Merging usb/usb-next (c8f2efc usbcore: fix read of usbdevfs_ctrltransfer fi=
elds in proc_control())
Merging usb-gadget/next (272b98c Linux 3.12-rc1)
Merging staging/staging-next (9076b09 staging/lustre: fix coccinelle warnin=
gs)
Merging char-misc/char-misc-next (272b98c Linux 3.12-rc1)
Merging scsi/for-next (fc85799 [SCSI] fnic: fnic Driver Tuneables Exposed t=
hrough CLI)
Merging target-updates/for-next (2999ee7 target/iscsi: Bump versions to v4.=
1.0)
Merging target-merge/for-next-merge (d4e4ab8 Linux 3.11-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (a885599 writeback: Do not sort b_io l=
ist only because of block device inode)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (bb15cb1 pinctrl: tegra114: Remove MODULE_ALIAS)
Merging vhost/linux-next (d3d665a vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (524c108 gpiolib-acpi: convert acpi_evaluate_object()=
 to acpi_execute_simple_method())
$ git reset --hard HEAD^
Merging next-20130917 version of gpio
Merging arm-soc/for-next (ab5c3b6 Merge tag 'imx-fixes-3.12' of git://git.l=
inaro.org/people/shawnguo/linux-2.6 into fixes)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (6868a89 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (092448e Merge branches 'imx/fixes', 'imx/soc' and=
 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
Merging mvebu/for-next (5202179 Merge branch 'mvebu/dove_pcie-mbus-dt' into=
 for-next)
Merging renesas/next (63c9972 Merge branch 'clocksource-fixes-for-v3.12' in=
to next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a7790.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a73a4.dtsi
Merging samsung/for-next (28ca23d Merge branch 'v3.13-next/dt-s3c64xx' into=
 for-next)
Merging tegra/for-next (7373012 Merge branch for-3.13/defconfig into for-ne=
xt)
Merging dma-mapping/dma-mapping-next (d5d04bb Bye, bye, WfW flag)
Merging pwm/for-next (1e185c7 pwm: pxa: Use module_platform_driver)
Merging dma-buf/for-next (19e8697 dma-buf: Expose buffer size to userspace =
(v2))
Merging userns/for-next (c7b96ac userns:  Kill nsown_capable it makes the w=
rong thing easy)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (12d29886 clk: only call get_parent if there is one)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging aio/master (d9b2c87 aio: rcu_read_lock protection for new rcu_deref=
erence calls)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (ea8adca mm-page-writebackc-add-strictlimit-fe=
ature-fix)
CONFLICT (content): Merge conflict in scripts/checkpatch.pl
CONFLICT (content): Merge conflict in mm/swap.c
CONFLICT (content): Merge conflict in mm/sparse.c
CONFLICT (content): Merge conflict in mm/mlock.c
CONFLICT (content): Merge conflict in mm/mempolicy.c
CONFLICT (content): Merge conflict in mm/filemap.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in include/linux/smp.h
CONFLICT (content): Merge conflict in include/linux/interrupt.h
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-hid-sensor-time.c
CONFLICT (content): Merge conflict in drivers/block/aoe/aoeblk.c
CONFLICT (content): Merge conflict in arch/s390/kernel/kprobes.c
CONFLICT (add/add): Merge conflict in Documentation/block/cmdline-partition=
.txt
Applying: fat: fix up for lockref changes
$ git checkout -b akpm remotes/origin/akpm/master
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Merging akpm/master (72d7e5a mm-drop-actor-argument-of-do_generic_file_read=
-fix)

--Signature=_Wed__18_Sep_2013_15_07_29_+1000_B3JIXZdDbOvJCYoo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSOTUWAAoJEECxmPOUX5FEj5sQAKdEmK+I0FZ3rw4Q+MJ5sRAx
+QoUzgHS7g7ZWNqRtyTKiiBZHiT7sUMEuxhNvuTBnwXzB78qu5kiMNhtdL/CSDer
4oAGhIZd5SiioGQxkh44H7c/fJmCfBXz2bI+YTGQ7tJ6+c0EO10+ZFDC3ubWwT2Z
Z7ZDPj9Nll0VxTZ2erdii/eCRl94/HHV97ROMGdkYa2VhUPnpVYNJ/msgDTwfwFX
P8DQJIHIS+5Qb+SChgdHfwx5DYN0KgLipJaJ3+ZcmnfFayrt5jUqG+1yaYcxeCge
d/uNnVPwdbtUsbVho66Z01tt6A5X8HZptvmN9XnZyJicj7TJIKC2OGAOc0IkYODd
5C0zGmj2gcfFYgw2RwS3swzItbuZScIVNarIXd2s0r3rP8URG+6dt7UcNV7R5kHN
lNX6pbNRC9Fwzzhn5joefVggW47PpElEazzSwCiZsKPu/wqlQVPXkMgGTuxCb677
hgAd4mKMC57vSJnxcpykoiNjx5MiKX0ZRyhvnEKtiv5FSJJB//WFX8RnYk0v8WVo
e4+2nW2whRwDhb/l1cSF/U3CcK0R9ow6R3lXS27F1CMvIVygsOZofWISWF8a0lYX
wzddvsKVs1NuPpmZiEkImslX5Zv3sfO82yir+wSYL9Wp95PiiuPKsg88milOyMyq
NFWHsK3Qv8ZUZcy2msxe
=PUpL
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_15_07_29_+1000_B3JIXZdDbOvJCYoo--
