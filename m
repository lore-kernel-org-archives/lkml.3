Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587Ab3EWFtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 01:49:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49665 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3EWFth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 01:49:37 -0400
Date: Thu, 23 May 2013 15:49:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 23
Message-Id: <20130523154924.db69d92fe88f9d22a87e822d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__23_May_2013_15_49_24_+1000_65Oujcv/MNua2Xbt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_May_2013_15_49_24_+1000_65Oujcv/MNua2Xbt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

There will be no linux-next release tomorrow.

Changes since 20130522:

The crypto tree still had its build failure so I used the version from
next-20130520.

The vhost tree lost its build failure.

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

We are up to 226 trees (counting Linus' and 31 trees of patches pending
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
Merging origin/master (bb3ec6b mm: Fix virt_to_page() warning)
Merging fixes/master (0279b3c Merge branch 'sched-urgent-for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging kbuild-current/rc-fixes (f66ba56 package: Makefile: unbreak binrpm-=
pkg target)
Merging arc-current/for-curr (89509ae ARC: [mm] Brown paper bag bug in macr=
o for checking cache color)
Merging arm-current/fixes (6eabb33 ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn=
't clear upper 32 bits of the old/new value)
Merging m68k-current/for-linus (e4f2dfb m68k: implement futex.h to support =
userspace robust futexes and PI mutexes)
Merging powerpc-merge/merge (e34166a powerpc: Set show_unhandled_signals to=
 1 by default)
Merging sparc/master (de9c9f8 Merge tag 'remoteproc-3.10' of git://git.kern=
el.org/pub/scm/linux/kernel/git/ohad/remoteproc)
Merging net/master (bcef9a8 qmi_wwan: Added support for Cinterion's PLxx WW=
AN Interface)
Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging sound-current/for-linus (e6135fe ALSA: usb-audio: proc: use found s=
yncmaxsize to determine feedback format)
Merging pci-current/for-linus (f3f0117 Revert "x86/pci/mrst: Use configurat=
ion mechanism 1 for 00:00.0, 00:02.0, 00:03.0")
Merging wireless/master (beaee9c atmel: printing bogus information)
Merging driver-core.current/driver-core-linus (ac5a296 klist: del waiter fr=
om klist_remove_waiters before wakeup waitting process)
Merging tty.current/tty-linus (e037f95 tty: mxser: Fix build warning introd=
uced by dfc7b837c7f9 (Re: linux-next: build warning after merge of the tty.=
current tree))
Merging usb.current/usb-linus (2a0ebf8 USB: cxacru: potential underflow in =
cxacru_cm_get_array())
CONFLICT (content): Merge conflict in drivers/usb/host/ohci-nxp.c
Merging staging.current/staging-linus (0797c3a staging: dwc2: remove compil=
e warning for USB_DWC2_TRACK_MISSED_SOFS)
Merging char-misc.current/char-misc-linus (b5325a0 ttyprintk: Fix NULL poin=
ter deref by setting tty_port ops after initializing port)
Merging input-current/for-linus (f0aacea Input: wacom - add a few new styli=
 for Cintiq series)
Merging md-current/for-linus (32f9f57 MD: ignore discard request for hard d=
isks of hybid raid1/raid10 array)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (286233e crypto: caam - fix inconsistent asso=
c dma mapping direction)
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
Merging rr-fixes/fixes (6407d75 virtio_console: fix uapi header)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overfl=
ow)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (9064e34 ARC: Trim arcregs.h)
CONFLICT (content): Merge conflict in arch/arc/mm/tlb.c
Merging arm/for-next (47aa03d Merge branches 'fixes', 'misc' and 'mmci' int=
o for-next)
Merging arm-perf/for-next/perf (c778879 Linux 3.10-rc2)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
CONFLICT (content): Merge conflict in drivers/clocksource/tegra20_timer.c
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (add/add): Merge conflict in arch/arm/mach-zynq/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/v2m.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear/spear13xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
CONFLICT (content): Merge conflict in arch/arm/mach-highbank/highbank.c
Merging arm64/upstream (c778879 Linux 3.10-rc2)
Merging blackfin/blackfin-linus (5ae89ee bfin cache: dcplb map: add 16M dcp=
lb map for BF60x)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
Merging m68k/for-next (f2c23a7 m68k/sun3: remove inline marking of EXPORT_S=
YMBOL functions)
Merging m68knommu/for-next (2842e5b0 m68knommu: enable Timer on coldfire 53=
2x)
Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB=
 =3D> 128KiB)
Merging microblaze/next (972be32 microblaze: Initialize temp variable to re=
move compilation warning)
Merging mips/mips-for-linux-next (1ce72f0 Merge branch '3.10-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (1c92ce8 parisc: use arch_spinlock_t instead of =
raw_spinlock_t in irqstacks)
Merging powerpc/next (674825d Merge tag 'fixes-for-3.10-rc2-tag' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (a4f4124 powerpc/mpc512x: initialize board restart ear=
lier)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (67ddde6 s390/smp: get rid of generic_smp_call_functi=
on_interrupt)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (9fc1894 arch/tile: Fix syscall return value passed to =
tracepoint)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (51fc41a xtensa: fix fast_store_prohibited _PAGE_WR=
ITABLE_BIT test)
Merging btrfs/next (667e7d9 Btrfs: allow superblock mismatch from older mkf=
s)
Merging ceph/testing (cb53a7e rbd: drop original request earlier for existe=
nce check)
Merging cifs/for-next (c2b93e0 cifs: only set ops for inodes in I_NEW state)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (f6161aa Linux 3.9-rc2)
Merging ext3/for_next (e162b2f jbd: use kmem_cache_zalloc instead of kmem_c=
ache_alloc/memset)
Merging ext4/dev (e2555fd jbd,jbd2: fix oops in jbd2_journal_put_journal_he=
ad())
Merging f2fs/dev (e8c6ab0 f2fs: use ihold)
Merging fuse/for-next (bee6c30 fuse: update inode size and invalidate attri=
butes on fallocate)
Merging gfs2/master (9e443a3 GFS2: Eliminate gfs2_rg_lops)
Merging jfs/jfs-next (73aaa22 jfs: fix a couple races)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (c5f4d15 SUNRPC: Remove redundant call to rpc_set_ru=
nning() in __rpc_execute())
Merging nfsd/nfsd-next (ba4e55b nfsd4: fix compile in !CONFIG_NFSD_V4_SECUR=
ITY_LABEL case)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (c1be5a5 Linux 3.9)
Merging ubifs/linux-next (c1be5a5 Linux 3.9)
Merging xfs/for-next (e461fcb xfs: remote attribute lookups require the val=
ue length)
Merging vfs/for-next (ac3e3c5 don't bother with deferred freeing of fdtable=
s)
Merging pci/next (755bda3 Merge branch 'pci/misc' into next)
Merging hid/for-next (09dd14b Merge branch 'for-3.11/multitouch' into for-n=
ext)
Merging i2c/i2c/for-next (e9b526f i2c: suppress lockdep warning on delete_d=
evice)
Merging jdelvare-hwmon/master (1aaf6d3 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging hwmon-staging/hwmon-next (21d2302 hwmon: (ds1621) Add ds1631 chip s=
upport to ds1621 driver and documentation)
Merging v4l-dvb/master (f6b831f Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (9639217 Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (126dd77 Merge branch 'for-3.11' into for-next)
Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into =
for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (e4c3af6 Merge branch 'pm-cpufreq-fixes-next' into li=
nux-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (3a9d1f1 Thermal: core: Ask .get_trip_temp() to regist=
er thermal zone device.)
Merging ieee1394/for-next (6fe9efb firewire: ohci: dump_stack() for PHY reg=
s read/write failures)
Merging ubi/linux-next (1557b9e UBI: do not abort init when ubi.mtd devices=
 cannot be found)
Merging dlm/next (9000831 dlm: avoid unnecessary posix unlock)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (222ab59 [SCSI] ipr: Avoid target_destroy accessing m=
emory after it was freed)
Merging target-updates/for-next (c778879 Linux 3.10-rc2)
Merging target-merge/for-next-merge (c778879 Linux 3.10-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (9562f83 DMA: AT91: Get residual bytes in dma buffer)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (1cdbcb7 net: Loosen constraints for recalculating =
checksum in skb_segment())
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (f91f5f0 drivers/net/wireless/brcm80211/brcmfm=
ac: add missing platform_driver owner)
Merging bluetooth/master (f639dcd Bluetooth: Add missing reset_resume dev_p=
m_ops)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (fc228fa mtd: increase max OOB size to 744)
Merging crypto/master (52188b6 crypto: sahara - remove dependency on EXPERI=
MENTAL)
$ git reset --hard HEAD^
Merging 20130520 version of crypto
Merging drm/drm-next (e9ced8e drm/radeon: restore nomodeset operation (v2))
Merging drm-intel/for-linux-next (69dc79f drm/i915: Workaround incoherence =
with fence updates on Valleyview)
Merging sound/for-next (e44007e ALSA: hda - add PCI IDs for Intel BayTrail)
Merging sound-asoc/for-next (36960f1 Merge remote-tracking branch 'asoc/top=
ic/x86' into asoc-next)
Merging modules/modules-next (06df44e modpost.c: Add .text.unlikely to TEXT=
_SECTIONS)
Merging virtio/virtio-next (b3087e4 virtio: remove virtqueue_add_buf().)
Merging input/next (d520145 Input: w90p910_keypad - remove redundant platfo=
rm_set_drvdata())
Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in co=
re)
Merging cgroup/for-next (e691100 Merge branch 'for-3.11' into for-next)
Merging block/for-next (3ba25f6 Merge branch 'for-linus' into for-next)
Merging device-mapper/master (11531a4 Fix detection of the need to resize t=
he dm thin metadata device.)
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
Merging mfd/master (43d61ee MAINTAINERS: Add Lee Jones as the MFD co-mainta=
iner)
CONFLICT (content): Merge conflict in drivers/mfd/intel_msic.c
Merging battery/master (237a1b0 lp8788-charger: Fix kconfig dependency)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (645a7e3 Merge remote-tracking branch 'regulator=
/topic/lp872x' into regulator-next)
Merging security/next (5b88e27 maintainers: Remove Kent from maintainers)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (f722406 Linux 3.10-rc1)
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
Merging spi-mb/for-next (f638ed6 Merge remote-tracking branch 'spi/topic/si=
rf' into spi-next)
Merging tip/auto-latest (57e87c1 Merge branch 'timers/urgent')
Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being=
 added)
Merging rcu/rcu/next (4573e86 rcu: Switch to exedited grace periods for sus=
pend as well as hibernation)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (f722406 Linux 3.10-rc1)
Merging kvm-arm/kvm-arm-next (24fd0fd Merge remote-tracking branch 'kvm/nex=
t' into kvm-arm-next)
Merging kvm-ppc/kvm-ppc-next (5975a2e KVM: PPC: Book3S: Add API for in-kern=
el XICS emulation)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (f722406 Linux 3.10-rc1)
Merging xen-arm/linux-next (3cc8e40 xen/arm: rename xen_secondary_init and =
run it on every online cpu)
Merging percpu/for-next (a1b2a55 percpu: add documentation on this_cpu oper=
ations)
Merging workqueues/for-next (bbe2a23 Merge branch 'for-3.10-fixes' into for=
-next)
Merging drivers-x86/linux-next (a1ec56e Add support for fan button on Ideap=
ad Z580)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (3615b6e Merge remote-tracking branch 'regmap/topic=
/debugfs' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (c17b9f9 leds: leds-gpio: Let device core handle pinc=
trl)
Merging driver-core/driver-core-next (1c4e2d7 cpu: make sure that cpu/onlin=
e file created before KOBJ_ADD is emitted)
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (6b5f146 TTY:console: update document console.txt)
Merging usb/usb-next (3138887 usb: uwb: use correct locking calls for rc da=
ta)
Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
Merging staging/staging-next (7c10f1c staging: speakup: fix warnings by add=
ing __user annotations)
CONFLICT (content): Merge conflict in drivers/staging/nvec/nvec_kbd.c
Merging char-misc/char-misc-next (cd43739 uio/uio_pci_generic: Use module_p=
ci_driver to register driver)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (a72737d Merge branch 'devel' into for-next)
Merging vhost/linux-next (f722406 Linux 3.10-rc1)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (08ffb22 gpio: grgpio: Add irq support)
Merging gpio-lw/for-next (cfb1089 gpio: Don't override the error code in pr=
obe error handling)
Merging gen-gpio/for_next (f4c5405 gpio: update gpio Chinese documentation)
Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of s=
izeof in mailbox_msg_send())
Merging arm-soc/for-next (9619228 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (ee8056f Merge branch 'for-3.11/defconfig' into fo=
r-next)
Merging cortex/for-next (6fae9cd ARM: ARMv7-M: implement read_cpuid_ext)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (c15431e Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (1df357a Merge branch 'msm-defconfig' into for-next)
Merging mvebu/for-next (1555040 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (c482a65 Merge branch 'heads/soc-sh73a0' into next)
CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/Kconfig
CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in renesa=
s/next and modified in HEAD. Version HEAD of drivers/leds/leds-renesas-tpu.=
c left in tree.
CONFLICT (content): Merge conflict in drivers/leds/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-lager.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-armadill=
o800eva.c
$ git rm -f drivers/leds/leds-renesas-tpu.c
Merging samsung/for-next (924fd92 Revert "ARM: SAMSUNG: don't check resourc=
e with devm_ioremap_resource")
Merging tegra/for-next (3f23f9c Merge branch 'for-3.11/defconfig' into for-=
next)
Merging dma-mapping/dma-mapping-next (c1be5a5 Linux 3.9)
Merging pwm/for-next (c71a985 MAINTAINERS: Update PWM subsystem entry)
Merging dma-buf/for-next (b89e356 dma-buf: Add debugfs support)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (fa079b9 clk: sun5i: Add compatibles for Allwinner A13)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (bb3ec6b mm: Fix virt_to_page() warning)
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
Applying: shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugep=
age-size-fix
Applying: rapidio/tsi721: fix bug in MSI interrupt handling
Applying: mm compaction: fix of improper cache flush in migration code
Applying: linux/kernel.h: fix kernel-doc warning
Applying: mm/THP: use pmd_populate() to update the pmd with pgtable_t point=
er
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: revert "selftest: add simple test for soft-dirty bit"
Applying: aio: fix io_getevents documentation
Applying: auditfilter.c: fix kernel-doc warnings
Applying: drivers/rtc/rtc-pl031.c: pass correct pointer to free_irq()
Applying: fbdev: FB_GOLDFISH should depend on HAS_DMA
Applying: drivers/block/brd.c: fix brd_lookup_page() race
Applying: nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF bound=
ary
Applying: mm/memory_hotplug.c: fix printk format warnings
Applying: CPU hotplug: provide a generic helper to disable/enable CPU hotpl=
ug
Applying: cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplu=
g-v11
Applying: reboot: rigrate shutdown/reboot to boot cpu
Applying: migrate-shutdown-reboot-to-boot-cpu-v11
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix
Applying: kernel/audit_tree.c:audit_add_tree_rule(): protect `rule' from ki=
ll_rules()
Applying: drivers/char/random.c: fix priming of last_data
Applying: random: fix accounting race condition with lockless irq entropy_c=
ount update
Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: audit: fix mq_open and mq_unlink to add the MQ root as a hidden p=
arent audit_names record
Applying: kernel/auditfilter.c: fix leak in audit_add_rule() error path
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: drivers/video/smscufx.c: use NULL instead of 0
Applying: drivers/video/udlfb.c: use NULL instead of 0
Applying: drivers/video/udlfb.c: make local symbol static
Applying: drivers/video/imxfb.c: make local symbols static
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: posix_cpu_timer: consolidate expiry time type
Applying: posix_cpu_timers: consolidate timer list cleanups
Applying: posix_cpu_timers: consolidate expired timers check
Applying: selftests: add basic posix timers selftests
Applying: posix-timers: correctly get dying task time sample in posix_cpu_t=
imer_schedule()
Applying: posix_timers: fix racy timer delta caching on task exit
Applying: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
Applying: configfs: use capped length for ->store_attribute()
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: fs/ocfs2/namei.c: remove unecessary ERROR when removing non-empty=
 directory
Applying: softirq: use _RET_IP_
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: drivers/cdrom/gdrom.c: fix device number leak
Applying: block/compat_ioctl.c: do not leak info to user-space
Applying: block: remove refs to XD disks from documentation
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: vfs: fix invalid ida_remove() call
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: clear_refs: sanitize accepted commands declaration
Applying: clear_refs: introduce private struct for mm_walk
Applying: pagemap: introduce pagemap_entry_t without pmshift bits
Applying: pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4
Applying: mm: soft-dirty bits for user memory changes tracking
Applying: soft-dirty: call mmu notifiers when write-protecting ptes
Applying: pagemap: prepare to reuse constant bits with page-shift
Applying: mm/thp: use the correct function when updating access flags
Applying: mm, memcg: don't take task_lock in task_in_mem_cgroup
Applying: mm: remove free_area_cache
Applying: mm: remove compressed copy from zram in-memory
Applying: mm-remove-compressed-copy-from-zram-in-memory-fix
Applying: mm/page_alloc.c: fix watermark check in __zone_watermark_ok()
Applying: swap: add a simple detector for inappropriate swapin readahead
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
Applying: mm/THP: add pmd args to pgtable deposit and withdraw APIs
Applying: mm/THP: withdraw the pgtable after pmdp related operations
Applying: mm/THP: don't use HPAGE_SHIFT in transparent hugepage code
Applying: mm/THP: deposit the transpare huge pgtable before set_pmd
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
Applying: mm: vmscan: check if kswapd should writepage once per pgdat scan
Applying: mm: vmscan: move logic from balance_pgdat() to kswapd_shrink_zone=
()
Applying: mm: fix comment referring to non-existent size_seqlock, change to=
 span_seqlock
Applying: mmzone: note that node_size_lock should be manipulated via pgdat_=
resize_lock()
Applying: memory_hotplug: use pgdat_resize_lock() in online_pages()
Applying: memory_hotplug: use pgdat_resize_lock() in __offline_pages()
Applying: memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix
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
Applying: lib/bitmap.c: speed up bitmap_find_free_region
Applying: lib-bitmapc-speed-up-bitmap_find_free_region-fix
Applying: rbtree: remove unneeded include
Applying: rbtree-remove-unneeded-include-fix
Applying: checkpatch: change CamelCase test and make it --strict
Applying: checkpatch: warn when using gcc's binary constant ("0b") extension
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: init: remove permanent string buffer from do_one_initcall()
Applying: insert missing space in printk line of root_delay
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
Applying: rtc: rtc-hid-sensor-time: add option hctosys to set time at boot
Applying: rtc: rtc-hid-sensor-time: add support for milliseconds
Applying: rtc: add ability to push out an existing wakealarm using sysfs
Applying: drivers/rtc/rtc-tps6586x.c: device wakeup flags correction
Applying: reiserfs: fix deadlock with nfs racing on create/lookup
Applying: fs/fat: use fat_msg() to replace printk() in __fat_fs_error()
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: Documentation/CodingStyle: allow multiple return statements per f=
unction
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
Applying: fork: reorder permissions when violating number of processes limi=
ts
Applying: idr: print a stack dump after ida_remove warning
Applying: idr-print-a-stack-dump-after-ida_remove-warning-fix
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
Applying: drivers/parport/share.c: use kzalloc
Applying: drivers/pps/clients/pps-gpio.c: convert to devm_* helpers
Applying: drivers/pps/clients/pps-gpio.c: convert to module_platform_driver
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
Applying: block-prep-work-for-batch-completion-fix-4
Applying: block-prep-work-for-batch-completion-fix-101
Applying: block, aio: batch completion for bios/kiocbs
Applying: aio: fix kioctx not being freed after cancellation at exit time
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: convert the ioctx list to radix tree
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
Merging akpm/master (1fdb14b scripts/sortextable.c: fix building on non-Lin=
ux systems)

--Signature=_Thu__23_May_2013_15_49_24_+1000_65Oujcv/MNua2Xbt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRna3pAAoJEECxmPOUX5FEThMP/i+mC2RWyqiufX4C2YeQhLcK
6bLlfce4ka9RX0esiDDZ/QviggY1cvHmMcnXIGs1OyfCDT/73uK/S1gXL4oGkqzf
4u9DUa9SV6UpHmsLEiQXb2+eNs+raULvjMgpG2uZmecXs7J//PDfOMcER5BIqPSg
9C/SZfPYTjd9+CIZ4Xn+CQ2vf0/vhuupGb66mvURDizrWi2KI5HsjeuoQyyhiY9V
l8posL3e7HUD5waPGmcPJDmGXG1F6Au5V0xcaHHITFoflNxTjCQwFPsciQryELEQ
wm0kFTyIGszv2fEfj2On8n4LRlEYfsbGByTVJIg4k0OJJaBUUHStfgIPZRlCm6Pf
PgQyJpLUr6c+t+uMXo2EWO/2jW/ceqE1WK/IkIR0KRAzt2Dgo59HsmQoWuMPEOA2
hYZCAbWThpTePJjCsMil9EX0DuqCUZJH1Q6HFICrr0gzqkL7UWFGCr+hbfsplYv9
4XI1jNIVkYfXGIYY5Qjp+Xs6xjkSDF8QvkHhJpBsSD/ytkDFDBST+GPZUSEyPxKr
2UzYJI5g1Fx3O68v6hB3YTg3sXbCjxPhJPBL5/45km5/WdLgvvoRQwJyeakR+YCb
KCz2PDZo7CtEW1qs2ABb68EzcINvhpdtZlRtOrSZGxKV04hxJePidMQiBex20UFq
sHjZh/egoZdhY3c+cUec
=gDfd
-----END PGP SIGNATURE-----

--Signature=_Thu__23_May_2013_15_49_24_+1000_65Oujcv/MNua2Xbt--
