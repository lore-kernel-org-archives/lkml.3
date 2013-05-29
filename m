Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab3E2Flq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 01:41:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53115 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3E2Flm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 01:41:42 -0400
Date: Wed, 29 May 2013 15:41:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 29
Message-Id: <20130529154122.e310a0576bb943f8c9060a99@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_May_2013_15_41_22_+1000_gNMMgxS/o_0x=ATA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_May_2013_15_41_22_+1000_gNMMgxS/o_0x=ATA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130528:

The trivial tree gained a conflict against the net-next tree.

The xen-arm tree gained a build failure so I used the version from
next-20130528.

The staging tree gained a conflict against the net-next tree.

The net-next tree added the following build warning for some
configurations:

In file included from include/net/tcp.h:44:0,
                 from net/core/sock.c:139:
include/net/inet_ecn.h: In function 'INET_ECN_set_ce':
include/net/inet_ecn.h:137:50: warning: comparison between pointer and inte=
ger [enabled by default]
include/net/inet_ecn.h:142:52: warning: comparison between pointer and inte=
ger [enabled by default]

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

We are up to 227 trees (counting Linus' and 31 trees of patches pending
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
Merging origin/master (58f8bbd Merge branch 'drm-fixes' of git://people.fre=
edesktop.org/~airlied/linux)
Merging fixes/master (0279b3c Merge branch 'sched-urgent-for-linus' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging kbuild-current/rc-fixes (ad06156 kbuild: Don't assume dts files liv=
e in arch/*/boot/dts)
Merging arc-current/for-curr (e4aa937 Linux 3.10-rc3)
Merging arm-current/fixes (f27d6e1 ARM: 7729/1: vfp: ensure VFP_arch is non=
-zero when VFP is not supported)
Merging m68k-current/for-linus (37c14e8 m68k: Update defconfigs for v3.9)
Merging powerpc-merge/merge (f1dd153 powerpc/pseries: Make 32-bit MSI quirk=
 work on systems lacking firmware support)
Merging sparc/master (de9c9f8 Merge tag 'remoteproc-3.10' of git://git.kern=
el.org/pub/scm/linux/kernel/git/ohad/remoteproc)
Merging net/master (f96ef98 ipv4: fix redirect handling for TCP packets)
Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging sound-current/for-linus (d47333d ALSA: usb-6fire: Modify firmware v=
ersion check)
Merging pci-current/for-linus (f3f0117 Revert "x86/pci/mrst: Use configurat=
ion mechanism 1 for 00:00.0, 00:02.0, 00:03.0")
Merging wireless/master (add295a ath9k: use correct OTP register offsets fo=
r AR9550)
Merging driver-core.current/driver-core-linus (e4aa937 Linux 3.10-rc3)
Merging tty.current/tty-linus (e4aa937 Linux 3.10-rc3)
Merging usb.current/usb-linus (e4aa937 Linux 3.10-rc3)
Merging staging.current/staging-linus (e4aa937 Linux 3.10-rc3)
Merging char-misc.current/char-misc-linus (e4aa937 Linux 3.10-rc3)
Merging input-current/for-linus (c73a1af Input: wacom - add an eraser to DT=
H2242/DTK2241)
Merging md-current/for-linus (32f9f57 MD: ignore discard request for hard d=
isks of hybid raid1/raid10 array)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (de614e5 crypto: sha256_ssse3 - fix stack cor=
ruption with SSSE3 and AVX implementations)
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
Merging arc/for-next (41dbd63 ARC: Trim arcregs.h)
Merging arm/for-next (b59c112 Merge branches 'devel-stable', 'fixes', 'misc=
' and 'mmci' into for-next)
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
Merging arm64/upstream (6427ae7 arm64: Provide default implementation for d=
ma_{alloc,free}_attrs)
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
Merging m68knommu/for-next (e4aa937 Linux 3.10-rc3)
Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB=
 =3D> 128KiB)
Merging microblaze/next (f6a12a7 microblaze: Reversed logic in futex cmpxch=
g)
Merging mips/mips-for-linux-next (324fe08f Merge branch '3.10-fixes' into m=
ips-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (1c92ce8 parisc: use arch_spinlock_t instead of =
raw_spinlock_t in irqstacks)
CONFLICT (content): Merge conflict in arch/parisc/kernel/irq.c
CONFLICT (content): Merge conflict in arch/parisc/include/asm/processor.h
Merging powerpc/next (519fe2e Merge branch 'leds-fixes-3.10' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (a4f4124 powerpc/mpc512x: initialize board restart ear=
lier)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (e6b51d5 s390/kvm: Provide function for setting the g=
uest storage key)
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
Merging ceph/testing (5c19349 ceph: improve error handling in ceph_mdsmap_d=
ecode)
Merging cifs/for-next (1c8da2c cifs: throw a warning if negotiate or sess_s=
etup ops are passed NULL server or session pointers)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (c15cddd ecryptfs: fixed msync to flush data)
Merging ext3/for_next (e162b2f jbd: use kmem_cache_zalloc instead of kmem_c=
ache_alloc/memset)
Merging ext4/dev (822a976 [PATCH] ext4: suppress ext4 orphan messages on mo=
unt)
Merging f2fs/dev (83d5d6f f2fs: cover cp_file information with ilock)
Merging fscache/fscache (ccce57f FS-Cache: Don't use spin_is_locked() in as=
sertions)
Merging fuse/for-next (bee6c30 fuse: update inode size and invalidate attri=
butes on fallocate)
Merging gfs2/master (6509813 GFS2: Set log descriptor type for jdata blocks)
Merging jfs/jfs-next (95bbb82 fs/jfs: Add check if journaling to disk has b=
een disabled in lbmRead())
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (088499a SUNRPC: Remove redundant call to rpc_set_ru=
nning() in __rpc_execute())
Merging nfsd/nfsd-next (ba4e55b nfsd4: fix compile in !CONFIG_NFSD_V4_SECUR=
ITY_LABEL case)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (2315cb1 9p: Add rest of 9p files to MAINTAINERS entr=
y)
Merging ubifs/linux-next (c1be5a5 Linux 3.9)
Merging xfs/for-next (ad1858d xfs: rework remote attr CRCs)
CONFLICT (content): Merge conflict in fs/xfs/xfs_attr_leaf.c
Merging vfs/for-next (ac3e3c5 don't bother with deferred freeing of fdtable=
s)
Merging pci/next (b194dbf Merge branch 'pci/kevin-bus-to-resource' into nex=
t)
Merging hid/for-next (0e22906 Merge branch 'for-3.11/elo' into for-next)
Merging i2c/i2c/for-next (e9b526f i2c: suppress lockdep warning on delete_d=
evice)
Merging jdelvare-hwmon/master (1aaf6d3 Merge git://git.kernel.org/pub/scm/l=
inux/kernel/git/davem/net)
Merging hwmon-staging/hwmon-next (a63243b hwmon: (ds1621) Add ds1631 chip s=
upport to ds1621 driver and documentation)
Merging v4l-dvb/master (f6b831f Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (cdb5ffd Merge branch 'kbuild/rc-fixes' into kbuild=
/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (0aa632b Merge branch 'for-3.11' into for-next)
Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into =
for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (fe453dd Merge branch 'acpi-assorted-next' into linux=
-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (fa91ac6 Merge branch 'for-rc' of .git into next)
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
Merging slave-dma/next (77eb140 Merge branch 'topic/of-imx' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (06ecf24 net: Fix build warnings after mac_header a=
nd transport_header became __u16.)
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (bbf71a8 mwl8k: Fix the firmware hang issue fo=
r 8764)
Merging bluetooth/master (f639dcd Bluetooth: Add missing reset_resume dev_p=
m_ops)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (fc228fa mtd: increase max OOB size to 744)
Merging crypto/master (bbb85b2 crypto: ux500 - Cocci spatch "resource_size.=
spatch")
Merging drm/drm-next (e9ced8e drm/radeon: restore nomodeset operation (v2))
Merging drm-intel/for-linux-next (8707eac drm/i915: add basic pipe config d=
ump support)
Merging drm-tegra/drm/for-next (d81692b drm/tegra: Fix return value)
Merging sound/for-next (4059a42 ALSA: hda - Enable mic-mute LED on more HP =
laptops)
Merging sound-asoc/for-next (f3e1e29 Merge remote-tracking branch 'asoc/top=
ic/x86' into asoc-next)
Merging modules/modules-next (06df44e modpost.c: Add .text.unlikely to TEXT=
_SECTIONS)
Merging virtio/virtio-next (b3087e4 virtio: remove virtqueue_add_buf().)
Merging input/next (737f644 Input: navpoint - pass correct pointer to free_=
irq())
Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in co=
re)
Merging cgroup/for-next (d9ed7c6 Merge branch 'for-3.10-fixes' into for-nex=
t)
Merging block/for-next (48668c2 Merge branch 'for-linus' into for-next)
Merging device-mapper/master (11531a4 Fix detection of the need to resize t=
he dm thin metadata device.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (7396e31 mmc: sdhci-pci: support runtime PM for BYT SD=
 cards)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (8a965b3 mm, slab_common: Fix bootstrap creation of k=
malloc caches)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (ae59b84 dm-raid: silence compiler warning on rebuilds_=
per_group.)
Merging mfd/master (57d5b9c Merge tag 'mfd-arizona-v3.10-rc2' of git://git.=
kernel.org/pub/scm/linux/kernel/git/broonie/misc)
CONFLICT (content): Merge conflict in drivers/mfd/intel_msic.c
Merging battery/master (dccab60 pm2301_charger: Fix module alias prefix)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (8b98eb9 Merge remote-tracking branch 'regulator=
/topic/lp872x' into regulator-next)
Merging security/next (5b88e27 maintainers: Remove Kent from maintainers)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (64da82b watchdog: core: don't try to stop device i=
f not running)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (0c4513b Merge branches 'iommu/fixes', 'x86/vt-d', 'x86/=
amd', 'ppc/pamu', 'core' and 'arm/tegra' into next)
Merging vfio/next (664e938 vfio: Set container device mode)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (360603a sprintf: hex_string(): fix comment)
CONFLICT (content): Merge conflict in Documentation/networking/netlink_mmap=
.txt
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
Merging spi-mb/for-next (941662a Merge remote-tracking branch 'spi/topic/si=
rf' into spi-next)
Merging tip/auto-latest (e4aa937 Linux 3.10-rc3)
Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being=
 added)
Merging rcu/rcu/next (fb28198 trace: Allow idle-safe tracepoints to be call=
ed from irq)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (e47a5f5 KVM: x86 emulator: convert XADD to fastop)
CONFLICT (content): Merge conflict in arch/s390/include/asm/pgtable.h
Merging kvm-arm/kvm-arm-next (f0e1418 ARM: KVM: get rid of S2_PGD_SIZE)
Merging kvm-ppc/kvm-ppc-next (5975a2e KVM: PPC: Book3S: Add API for in-kern=
el XICS emulation)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (f0dbb34 Merge branch 'stable/for-linus-3.10' in=
to linux-next)
Merging xen-arm/linux-next (9af1553 xen/arm: account for stolen ticks)
$ git reset --hard HEAD^
Merging next-20130528 version of xen-arm
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
Merging regmap/for-next (d52bd3b Merge remote-tracking branch 'regmap/topic=
/debugfs' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (3234e11 leds: use platform_{get,set}_drvdata())
Merging driver-core/driver-core-next (4993632 Merge 3.10-rc3 into driver-co=
re-next)
CONFLICT (content): Merge conflict in drivers/base/cpu.c
Merging tty/tty-next (8095e4e Merge 3.10-rc3 into tty-next)
Merging usb/usb-next (45f6bc5 Merge 3.10-rc3 into usb-next)
Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
Merging staging/staging-next (829455b Merge 3.10-rc3 into staging-next)
CONFLICT (content): Merge conflict in drivers/staging/silicom/bpctl_mod.c
Merging char-misc/char-misc-next (f35c69b Merge 3.10-rc3 into char-misc-nex=
t)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (8f6b018 Merge branch 'devel' into for-next)
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
Merging mailbox/dbx500-prcmu-mailbox (c497eba mailbox: fix invalid use of s=
izeof in mailbox_msg_send())
Merging arm-soc/for-next (f56e45c Merge branch 'next/cleanup' into for-next)
Merging bcm2835/for-next (ee8056f Merge branch 'for-3.11/defconfig' into fo=
r-next)
Merging cortex/for-next (6fae9cd ARM: ARMv7-M: implement read_cpuid_ext)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (77f1590 Merge branches 'imx/soc' and 'imx/dt' int=
o for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (1df357a Merge branch 'msm-defconfig' into for-next)
Merging mvebu/for-next (d83ac13 Merge branch 'mvebu/seb_clk' into for-next)
Merging renesas/next (b068496 Merge branches 'heads/soc-common', 'heads/soc=
-emev2', 'heads/soc-r8a73a4', 'heads/soc-r8a7779', 'heads/soc-sh7372', 'hea=
ds/soc-sh73a0', 'heads/defconfig-armadillo800eva', 'heads/defconfig-bockw',=
 'heads/defconfig-kzm9g', 'heads/boards-kzm9d', 'heads/boards-kzm9g', 'head=
s/boards-marzen-fixes', 'heads/boards-ape6evm', 'heads/boards-bockw', 'head=
s/boards-lager', 'heads/boards-marzen', 'heads/boards-armadillo800eva', 'he=
ads/intc-external-irq' and 'heads/gpio-rcar' into next)
Merging samsung/for-next (924fd92 Revert "ARM: SAMSUNG: don't check resourc=
e with devm_ioremap_resource")
Merging tegra/for-next (f2c3e05 Merge branch 'for-3.11/defconfig' into for-=
next)
Merging dma-mapping/dma-mapping-next (c1be5a5 Linux 3.9)
Merging pwm/for-next (e792714 pwm: mxs: Let device core handle pinctrl)
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
Applying: shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugep=
age-size-fix
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
Merging akpm/master (db337d9 scripts/sortextable.c: fix building on non-Lin=
ux systems)
Applying: jfs: fix up for batch completion API change

--Signature=_Wed__29_May_2013_15_41_22_+1000_gNMMgxS/o_0x=ATA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRpZUMAAoJEECxmPOUX5FEgtwP+wSpEAObr4iE4n3C8CVmzs7o
w7wE63HXvinKd1xz1y5Pu0D3d7X2c843toH52eJNvjiWMoLFFjJcrDazl2AZfg3A
7OeOypod3Gz3RZ1wkrn75KafJ6P2Psu+PhwmYMpjHOmGOgwIhIsP4CbgciPIZf50
bBSGY9jmXL7T4UyGCfWpTMbbDBEE9FxBSk9aa6/oU4fVusBy3ieiJOkm6hX+6gxQ
cmiTRvozrEX71OhEjiwTudDMiQhzcM09A0XIfsrIII3KmDrnABpSBs9Zn5smd6Sk
xXBqVibDZKt7tQ/KS+c5udq/5kiNx7mgiVXsAArFvMYF84FGmDO/zaM4nT0dLv0t
8dmk2g7tCJ9ZZUg2UY9RdGEKSPiXMbPtXiY9KxM0+5R+ofx0rtf0yOpqbid6k9cb
dH0eDwCesxAzBGxgeBvritJLGJqLhnjCjkvp0e1scEAtfXiayDQ8J/QzoNlwbZuT
FRB4x3SNMhsErc2pGXWnPxSk4IRyf78jvvaHIrcjzC0Vl3OpAjZxpTFosc/qlQ6L
q1LQVCbS8CPIBaUYDerjwlgBqIz8gb2DOQrT/MS+fhZuxynzPFdeiXTcc7qrbBjP
ga9VzeDXwPFvvKtrN3iUdZHQwXlX5Bl63Z4eO6fmEOxP240Vvc4K2D282SrJT/Gj
4mnqC9EsmkYKEl/V19W7
=Y2LW
-----END PGP SIGNATURE-----

--Signature=_Wed__29_May_2013_15_41_22_+1000_gNMMgxS/o_0x=ATA--
