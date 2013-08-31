Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3HaAs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:48:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36798 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3HaAsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:48:50 -0400
Date: Sat, 31 Aug 2013 10:48:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 30
Message-Id: <20130831104839.d677415c96e1aa4b0e3aacb0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__31_Aug_2013_10_48_39_+1000_3n5UzFjJ0lvXIC_b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__31_Aug_2013_10_48_39_+1000_3n5UzFjJ0lvXIC_b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Sorry for the late announcement - I wrote a draft and then forgot to send i=
t.

Changes since 20130829:

The sound tree gained a conflict against the drm tree.

The driver-core tree gained a conflict against the pm tree.

The dma-mapping tree gained a conflict against the kvm-ppc tree.

The aio tree gained a build failure for which I applied a merge fix patch.

The akpm-current tree gained a build failure for which I reverted a commit.

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

We are up to 221 trees (counting Linus' and 30 trees of patches pending
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
Merging origin/master (c95389b Merge branch 'akpm' (patches from Andrew Mor=
ton))
Merging fixes/master (fa8218d Merge tag 'regmap-v3.11-rc7' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (c095ba7 Linux 3.11-rc4)
Merging arm-current/fixes (e1f0203 Merge branch 'security-fixes' into fixes)
Merging m68k-current/for-linus (ea077b1 m68k: Truncate base in do_div())
Merging metag-fixes/fixes (3b2f64d Linux 3.11-rc2)
Merging powerpc-merge/merge (d220980 powerpc/hvsi: Increase handshake timeo=
ut from 200ms to 400ms.)
Merging sparc/master (63d4996 sparc64: Fix off by one in trampoline TLB map=
ping installation loop.)
Merging net/master (79f9ab7 Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/klassert/ipsec)
Merging ipsec/master (302a50b xfrm: Fix potential null pointer dereference =
in xdst_queue_output)
Merging sound-current/for-linus (fb61549 ALSA: opti9xx: Fix conflicting dri=
ver object name)
Merging pci-current/for-linus (36dd1f3 PCI: mvebu: Disable prefetchable mem=
ory support in PCI-to-PCI bridge)
Merging wireless/master (19c3616 ath9k: Enable PLL fix only for AR9340/AR93=
30)
Merging driver-core.current/driver-core-linus (5ae90d8 Linux 3.11-rc3)
Merging tty.current/tty-linus (c095ba7 Linux 3.11-rc4)
Merging usb.current/usb-linus (d347404 USB: OHCI: fix build error related t=
o ohci_suspend/resume)
Merging staging.current/staging-linus (d8dfad3 Linux 3.11-rc7)
Merging char-misc.current/char-misc-linus (b36f4be Linux 3.11-rc6)
Merging input-current/for-linus (fa46c79 Input: i8042 - disable the driver =
on ARC platforms)
Merging md-current/for-linus (f94c0b6 md/raid5: fix interaction of 'replace=
' and 'recovery'.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (e70308e Revert "crypto: crct10dif - Wrap crc=
_t10dif function all to use crypto transform framework")
Merging ide/master (6d128e1 Revert "Makefile: Fix install error with make -=
j option")
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
Merging drm-intel-fixes/drm-intel-fixes (77fa4cb drm/i915: ivb: fix edp vol=
tage swing reg val)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (8c5af8e ARC: No need to flush the TLB in early boot)
Merging arm/for-next (936fa05 Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (ad81f05 Linux 3.11-rc1)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging arm64/upstream (e25208f arm64: Fix mapping of memory banks not endi=
ng on a PMD_SIZE boundary)
Merging blackfin/for-linus (eb043d3 smp: blackfin: fix check error, using a=
tomic_ops to handle atomic_t type)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (174a9a0 Merge branch 'misc-3.12' into next)
Merging m68k/for-next (5549005 m68k/atari: ARAnyM - Always use physical add=
resses in NatFeat calls)
Merging m68knommu/for-next (c065edd m68k: remove 16 unused boards in Kconfi=
g.machine)
Merging metag/for-next (b6ef916 irq-imgpdc: add ImgTec PDC irqchip driver)
Merging microblaze/next (a9b9d22 of/pci: Use of_pci_range_parser)
Merging mips/mips-for-linux-next (0ab12c9 Merge branch '3.11-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9f0f4fb parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (83c93e2 powerpc/pseries: Move lparcfg.c to platforms/=
pseries)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f2110cb dts: mpc512x: prepare for preprocessor suppor=
t)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (0944fe3 s390/mm: implement software referenced bits)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (e86b818 tile: add null check for kzalloc in tile/kerne=
l/setup.c)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (3b2f64d Linux 3.11-rc2)
Merging aio-direct/for-next (b080082 tmpfs: add support for read_iter and w=
rite_iter)
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
Merging ceph/master (7d6e1f5 ceph: use vfs __set_page_dirty_nobuffers inter=
face instead of doing it inside filesystem)
Merging cifs/for-next (de09ae6 cifs: Move and expand MAX_SERVER_SIZE defini=
tion)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging ext3/for_next (97a2847 Merge branch 'for-3.12' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jeffm/linux-reiserfs into for_next_testing)
Merging ext4/dev (ad4eec6 ext4: allow specifying external journal by pathna=
me mount option)
Merging f2fs/dev (749ebfd f2fs: use strncasecmp() simplify the string compa=
rison)
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (c7263bc fuse: readdirplus: cleanup)
Merging gfs2/master (9d35814 GFS2: Merge ordered and writeback writepage)
Merging jfs/jfs-next (4451244 jfs: fix readdir cookie incompatibility with =
NFSv4)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (6443c6a Merge branch 'bugfixes' into linux-next)
Merging nfsd/nfsd-next (2f74f97 sunrpc: prepare NFS for 2038)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (28d7b56 Squashfs: sanity check information from di=
sk)
Merging v9fs/for-next (50192ab fs/9p: avoid accessing utsname after namespa=
ce has been torn down)
Merging ubifs/linux-next (c23e9b7 UBIFS: remove invalid warn msg with tst_r=
ecovery enabled)
Merging xfs/for-next (0d0ab12 xfs: check for underflow in xfs_iformat_fork(=
))
CONFLICT (content): Merge conflict in fs/xfs/xfs_inode.c
Merging vfs/for-next (d405be4 ext4: ->tmpfile() support)
CONFLICT (content): Merge conflict in mm/shmem.c
CONFLICT (content): Merge conflict in fs/ext4/namei.c
CONFLICT (content): Merge conflict in fs/ceph/file.c
Merging pci/next (e89c331 Merge branch 'pci/misc' into next)
Merging hid/for-next (f8709e7 Merge branch 'for-3.12/multitouch-win8' into =
for-next)
Merging i2c/i2c/for-next (617da00 i2c: sirf: retry 3 times as sometimes we =
get random noack and timeout)
Merging jdelvare-hwmon/master (d9d5701 hwmon: (emc6w201) Do not declare enu=
m variable)
Merging hwmon-staging/hwmon-next (5407e051 hwmon: Change my email address.)
Merging v4l-dvb/master (b068ac9 Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
Merging kbuild/for-next (0ce4d3f Merge branches 'kbuild/kbuild' and 'kbuild=
/misc' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (38af2b4 Merge branch 'for-3.12' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (f107999 Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
CONFLICT (content): Merge conflict in arch/powerpc/kernel/prom.c
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (f61d5b4d Merge branch 'fixes' of .git into next)
Merging ieee1394/for-next (db9ae8f firewire: ohci: Fix deadlock at bus rese=
t)
Merging ubi/linux-next (8930fa5 UBI: Fix invalidate_fastmap())
Merging dlm/next (c6ca7bc dlm: remove signal blocking)
CONFLICT (content): Merge conflict in fs/dlm/user.c
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (20ddb3c Merge branch 'for-linus' into next)
Merging dmaengine/next (e6a5fa6 ioatdma: silence GCC warnings)
Merging net-next/master (7ec06da net: packet: document available fanout pol=
icies)
CONFLICT (content): Merge conflict in net/mac80211/ibss.c
Merging ipsec-next/master (0806ae4 xfrm: announce deleation of temporary SA)
Merging wireless-next/master (076f0d2 cw1200: When debug is enabled, displa=
y all wakeup conditions for the wait_event_interruptible_timeout() call.)
CONFLICT (content): Merge conflict in net/mac80211/ibss.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/pcie/tra=
ns.c
Merging bluetooth/master (2dea632 Bluetooth: Add SCO connection fallback)
Merging infiniband/for-next (74b15c3 Merge branches 'cxgb4', 'flowsteer', '=
ipoib', 'iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Applying: cxgb4: fix up for bond_for_each_slave API change
Merging mtd/master (e79265b mtd: ofpart: add compatible check for child nod=
es)
Merging l2-mtd/master (bd2e8b1 mtd: ofpart: use for_each_child_of_node() ma=
cro)
Merging crypto/master (b8b4a41 padata - Register hotcpu notifier after init=
ialization)
Merging drm/drm-next (efa27f9 Merge tag 'drm-intel-next-2013-08-23' of git:=
//people.freedesktop.org/~danvet/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem_dmabuf.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-intel/for-linux-next (ee75f95 x86: add early quirk for reservin=
g Intel graphics stolen memory v5)
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_crtc.c
Merging drm-tegra/drm/for-next (745cecc gpu: host1x: returning success inst=
ead of -ENOMEM)
Merging sound/for-next (1c9a341 ALSA: hda - Simplify CONFIG_SND_HDA_I915 co=
ndition)
CONFLICT (content): Merge conflict in sound/pci/hda/hda_intel.c
Merging sound-asoc/for-next (d1aeaaa Merge remote-tracking branch 'asoc/top=
ic/wm8994' into asoc-next)
Merging modules/modules-next (f4940ab kernel/params.c: use scnprintf() inst=
ead of sprintf())
Merging virtio/virtio-next (3b868a4 virtio: console: prevent use-after-free=
 of port name in port unplug)
Merging input/next (52764fe Input: add SYN_MAX and SYN_CNT constants)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (66c144c Merge branch 'for-3.11-fixes' into for-nex=
t)
CONFLICT (content): Merge conflict in include/net/netprio_cgroup.h
Merging block/for-next (3fe9649 Merge branch 'for-3.11/drivers' into for-ne=
xt)
Merging device-mapper/for-next (a97fd45 dm: allow error target to replace i=
mmutable target)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (490104a mmc: esdhc: add support to get voltage from d=
evice-tree)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (9de1bc8 mm, slab_common: add 'unlikely' to size chec=
k of kmalloc_slab())
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (4d77e3b md/raid5: flush out all pending requests befor=
e proceeding with reshape.)
CONFLICT (content): Merge conflict in lib/raid6/test/Makefile
CONFLICT (content): Merge conflict in lib/raid6/Makefile
Merging mfd/master (828fa1e Merge tag 'mfd-lee-3.12-1' of git://git.linaro.=
org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (8a105ca mfd: pcf50633-adc: Use devm_*() functi=
ons)
Merging battery/master (d24fed3 bq24190_charger: Workaround SS definition p=
roblem on i386 builds)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (7976ecc Merge branch '3.12/dss-legacy-removal' =
into for-next)
Merging regulator/for-next (9b61d44 Merge remote-tracking branch 'regulator=
/topic/tps65912' into regulator-next)
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq-cpu0.c
Merging security/next (7320336 Merge branch 'smack-for-3.12' of git://git.g=
itorious.org/smack-next/kernel into ra-next)
Merging selinux/master (0b4bdb3 Revert "SELinux: do not handle seclabel as =
a special flag")
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (2c859fe watchdog: hpwdt: Patch to ignore auxilary =
iLO devices)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (f098cc4 Merge branches 'arm/exynos', 'ppc/pamu', 'arm/s=
mmu', 'x86/amd' and 'iommu/fixes' into next)
Merging vfio/next (20e7745 vfio-pci: Use fdget() rather than eventfd_fget())
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (9cf510a Fix comment typo for init_cma_reserved_pa=
geblock)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/mvm/time=
-event.c
CONFLICT (content): Merge conflict in drivers/net/ethernet/qlogic/qlcnic/ql=
cnic_83xx_hw.c
CONFLICT (content): Merge conflict in drivers/crypto/ux500/hash/hash_core.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging devicetree/devicetree/next (92d3161 of/fdt: Remove duplicate memory=
 clearing on FDT unflattening)
Merging dt-rh/for-next (8851b9f include: dt-binding: input: create a DT hea=
der defining key codes.)
Merging spi/for-next (439ae56 Merge remote-tracking branch 'spi/topic/txx9'=
 into spi-next)
Merging tip/auto-latest (a369d0c Merge branch 'x86/urgent')
CONFLICT (content): Merge conflict in drivers/video/simplefb.c
CONFLICT (content): Merge conflict in arch/x86/include/asm/processor.h
Applying: simplefb: merge conflict fix
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (75a9551 cpc925_edac: Use proper array terminatio=
n)
Merging ftrace/for-next (fc30f13 Merge branch 'trace/ftrace/core-tpstring' =
into trace/for-next)
Merging rcu/rcu/next (aa915cd Merge branches 'doc.2013.08.19a', 'fixes.2013=
.08.18a', 'sysidle.2013.08.18b' and 'torture.2013.08.19b' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (cc2df20 KVM: x86: Update symbolic exit codes)
Applying: s390: fix tlb_gather_mmu fallout
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (bf550fc Merge remote-tracking branch 'origin/=
next' into kvm-ppc-next)
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (e0fc7de ARM: xen: only set pm function ptrs for=
 Xen guests)
Merging percpu/for-next (abec1a8 percpu: Make __verify_pcu_ptr handle per c=
pu pointers to arrays)
Merging workqueues/for-next (5f6b2bb Merge branch 'for-3.11-fixes' into for=
-next)
CONFLICT (content): Merge conflict in kernel/workqueue.c
Merging drivers-x86/linux-next (41c8bd1 Revert "hp-wmi: Enable hotkeys on s=
ome systems")
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (3939f59 Merge remote-tracking branch 'regmap/topic=
/sparse' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (c945cbc leds: trigger: ledtrig-backlight: Fix invali=
d memory access in fb_event notification callback)
Merging driver-core/driver-core-next (7315f0c drivers/base/memory.c: introd=
uce help macro to_memory_block)
CONFLICT (content): Merge conflict in net/core/net-sysfs.c
CONFLICT (content): Merge conflict in drivers/base/core.c
Merging tty/tty-next (9dfe59f1 ARM: dts: msm: Update uartdm compatible stri=
ngs)
CONFLICT (content): Merge conflict in include/uapi/linux/serial_core.h
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in drivers/tty/serial/Makefile
Merging usb/usb-next (2d17f7f dma: cppi41: off by one in desc_to_chan())
CONFLICT (content): Merge conflict in include/linux/usb/usbnet.h
CONFLICT (content): Merge conflict in drivers/dma/Makefile
Merging usb-gadget/next (0f2aa8c usb: musb: ux500: Add check for NULL board=
 data)
Merging staging/staging-next (f5adda3 Merge tag 'iio-for-3.12c' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next)
CONFLICT (content): Merge conflict in Documentation/driver-model/devres.txt
Merging char-misc/char-misc-next (e83736c misc: vmw_balloon: Remove braces =
to fix build for clang.)
Merging scsi/for-next (bb1ebe0 Merge branch 'misc' into for-next)
CONFLICT (content): Merge conflict in drivers/infiniband/ulp/iser/iser_init=
iator.c
Merging target-updates/for-next (0b67e68 target: Enable global EXTENDED_COP=
Y setup/release)
Merging target-merge/for-next-merge (d4e4ab8 Linux 3.11-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (8bb495e Linux 3.10)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (eb9c3ce pinctrl: sunxi: drop lock on error path)
Merging vhost/linux-next (8c325ee vhost: wake up worker outside spin_lock)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (d9facd2 of: add vendor prefix for Microchip Technolo=
gy Inc)
Merging arm-soc/for-next (ce5ed8d Merge branch 'late/all' into for-next)
CONFLICT (content): Merge conflict in drivers/pci/host/Makefile
CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in arm-so=
c/for-next and modified in HEAD. Version HEAD of drivers/leds/leds-renesas-=
tpu.c left in tree.
CONFLICT (content): Merge conflict in drivers/cpuidle/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7779.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7778.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/r=
8a7779.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/include/mach/r=
8a7778.h
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-marzen.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/omap5.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am335x-evmsk.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am335x-evm.dts
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am335x-bone.dts
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
$ git rm -f drivers/leds/leds-renesas-tpu.c
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (9c59be7 Merge branch 'ep93xx-devel' into ep=
93xx-for-next)
Merging imx-mxs/for-next (c418b7e Merge branches 'imx/fixes-3.12', 'imx/soc=
-3.13' and 'imx/dt-3.13' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
Merging mvebu/for-next (3f7d5bc Merge branch 'mvebu/dove_pcie-mbus-dt' into=
 for-next)
CONFLICT (content): Merge conflict in drivers/pci/host/pci-mvebu.c
CONFLICT (content): Merge conflict in drivers/pci/host/Kconfig
Merging renesas/next (552035a Merge branch 'boards3' into next)
CONFLICT (content): Merge conflict in arch/arm/configs/marzen_defconfig
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a7790.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/r8a73a4.dtsi
Merging samsung/for-next (e56406b Merge branch 'v3.12-next/dt-s3c64xx' into=
 for-next)
Merging tegra/for-next (d8dfad3 Linux 3.11-rc7)
Merging dma-mapping/dma-mapping-next (10bcdfb ARM: init: add support for re=
served memory defined by device tree)
CONFLICT (content): Merge conflict in mm/Kconfig
CONFLICT (content): Merge conflict in drivers/base/dma-contiguous.c
Merging pwm/for-next (984d131 ARM: pxa: make pwm driver module_platform_dri=
ver)
Merging dma-buf/for-next (8bb495e Linux 3.10)
Merging userns/for-next (7dc5dbc sysfs: Restrict mounting sysfs)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (aa514ce clk: wrap I/O access for improved portability)
CONFLICT (content): Merge conflict in drivers/clk/zynq/clkc.c
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging ptr-ret/PTR_RET (ad151d5 GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO)
CONFLICT (modify/delete): drivers/staging/zcache/zcache-main.c deleted in H=
EAD and modified in ptr-ret/PTR_RET. Version ptr-ret/PTR_RET of drivers/sta=
ging/zcache/zcache-main.c left in tree.
$ git rm -f drivers/staging/zcache/zcache-main.c
Merging aio/master (f30d704 aio: table lookup: verify ctx pointer)
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/block_dev.c
Applying: aio: semantic fixup
Applying: aio: another semantic merge fix
Applying: aio: fixup for lockref changes
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (ea8adca mm-page-writebackc-add-strictlimit-fe=
ature-fix)
CONFLICT (content): Merge conflict in kernel/fork.c
[master e4d4301] Revert "fat-additions-to-support-fat_fallocate-fix"
[master 7eb80db] Revert "fat: additions to support fat_fallocate"
$ git checkout -b akpm remotes/origin/akpm/master
Applying: memcg: remove redundant code in mem_cgroup_force_empty_write()
Applying: memcg, vmscan: integrate soft reclaim tighter with zone shrinking=
 code
Applying: memcg: get rid of soft-limit tree infrastructure
Applying: vmscan, memcg: do softlimit reclaim also for targeted reclaim
Applying: memcg: enhance memcg iterator to support predicates
Applying: mm: fix memcg-less page reclaim
Applying: memcg: track children in soft limit excess to improve soft limit
Applying: memcg, vmscan: do not attempt soft limit reclaim if it would not =
scan anything
Applying: memcg: track all children over limit in the root
Applying: memcg, vmscan: do not fall into reclaim-all pass too quickly
Applying: memcg: trivial cleanups
Applying: arch: mm: remove obsolete init OOM protection
Applying: arch: mm: do not invoke OOM killer on kernel fault OOM
Applying: arch: mm: pass userspace fault flag to generic fault handler
Applying: x86: finish user fault error path with fatal signal
Applying: mm: memcg: enable memcg OOM killer only for user faults
Applying: mm: memcg: rework and document OOM waiting and wakeup
Applying: mm: memcg: do not trap chargers with full callstack on OOM
Applying: memcg: correct RESOURCE_MAX to ULLONG_MAX
Applying: memcg: rename RESOURCE_MAX to RES_COUNTER_MAX
Applying: memcg: avoid overflow caused by PAGE_ALIGN
Applying: memcg: reduce function dereference
Applying: memcg: remove MEMCG_NR_FILE_MAPPED
Applying: memcg: check for proper lock held in mem_cgroup_update_page_stat
Applying: memcg: add per cgroup writeback pages accounting
Applying: memcg: document cgroup dirty/writeback memory statistics
Applying: mm: make lru_add_drain_all() selective
Applying: truncate: drop 'oldsize' truncate_pagecache() parameter
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm-drop-actor-argument-of-do_generic_file_read-fix
Applying: thp: account anon transparent huge pages into NR_ANON_PAGES
Applying: mm: cleanup add_to_page_cache_locked()
Applying: thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
Applying: thp: do_huge_pmd_anonymous_page() cleanup
Applying: thp: consolidate code between handle_mm_fault() and do_huge_pmd_a=
nonymous_page()
Applying: mm, thp: count thp_fault_fallback anytime thp fault fails
Applying: kernel: replace strict_strto*() with kstrto*()
Applying: fs: bump inode and dentry counters to long
Applying: super: fix calculation of shrinkable objects for small numbers
Applying: dcache: convert dentry_stat.nr_unused to per-cpu counters
Applying: dentry: move to per-sb LRU locks
Applying: dcache: remove dentries from LRU before putting on dispose list
CONFLICT (content): Merge conflict in fs/dcache.c
Applying: mm: new shrinker API
Applying: shrinker: convert superblock shrinkers to new API
Applying: shrinker-convert-superblock-shrinkers-to-new-api-fix
Applying: list: add a new LRU list type
Applying: inode: convert inode lru list to generic lru list code.
Applying: inode: move inode to a different list inside lock
Applying: dcache: convert to use new lru list infrastructure
Applying: list_lru: per-node list infrastructure
Applying: list_lru: per-node list infrastructure fix
Applying: list_lru: fix broken LRU_RETRY behaviour
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
Applying: xfs: fix dquot isolation hang
Applying: fs: convert fs shrinkers to new scan/count API
Applying: fs-convert-fs-shrinkers-to-new-scan-count-api-fix
Applying: UBIFS: signedness bug in ubifs_shrink_count()
Applying: fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2
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
Applying: staging/lustre/ldlm: convert to shrinkers to count/scan API
Applying: staging/lustre/obdclass: convert lu_object shrinker to count/scan=
 API
Applying: staging/lustre/ptlrpc: convert to new shrinker API
Applying: staging/lustre/libcfs: cleanup linux-mem.h
Applying: mm/Kconfig: add MMU dependency for MIGRATION.
Applying: dcache: fix up for lockref changes
Merging akpm/master (3430d60 dcache: fix up for lockref changes)

--Signature=_Sat__31_Aug_2013_10_48_39_+1000_3n5UzFjJ0lvXIC_b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIT1sAAoJEECxmPOUX5FEkrEQAJfpSxD+3IyK5eie5vVFnT+W
wtHebnYgUZWZkH31jqDmLytlLev7zV65aHPV/t/hkoQUnnQr6gVggwS+2wUp5mxr
wuU5gjS6oV9reeEW1dmJK0g3VZ2It4PyZOzQ5tV/A6qawig6tJWd9iKGy+U/+fYY
EYRjbUE3vgHMZhJgZFVhzDw5axAw/qyr+gRxwGsp+IS5HgBuFonVXFpP6ZmsVZGH
oPENoUeFYK89+5j3J82JA18CbyrU6fDVw78VX8TUAkIvrY3RyQdcb1gAAim8tKBf
cN4NjU6NQbcUcZdrvr3MT6Epe27TGY4sbSv37nQ/OUiD8nPNDWtSFL3QXEAnnPhh
eMg9d7bXA6/jIL/2S/8bOU26GTMoqtEgFFxZ6IP2bjXuS55OzUcn7Bwt26dOaUOF
WYr9z87EJjxVbwJJFU03Aqb3E7s/oUTaePsKrZ/FY61LHSLXih63kfHjC2QkfeO+
LHiLS0woLj77+u4Tw+KZgnnvo1pB66DvUyoMn1iUuYB+A5W7/BksCMySP49bGzDT
PO562HYeyDa+Da1flsFDI/UJRkDysGHRSADo6cWEoI1XoIRJ9h3RW4EKSNBdI2aX
Xith1c2UuF/0WNRA2AtrjQrmSNNNIpImmj0VQCpNWajljxBdqjHVw2oQDsTwI2Ta
8455VUY4Da5XdMG77VoO
=NRXd
-----END PGP SIGNATURE-----

--Signature=_Sat__31_Aug_2013_10_48_39_+1000_3n5UzFjJ0lvXIC_b--
