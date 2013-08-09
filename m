Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967362Ab3HIGP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:15:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43752 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966056Ab3HIGPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:15:52 -0400
Date: Fri, 9 Aug 2013 16:15:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 9
Message-Id: <20130809161540.f65dd6412ac59d49a32881c8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Aug_2013_16_15_40_+1000_mwnMxM9FB02V6qVX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Aug_2013_16_15_40_+1000_mwnMxM9FB02V6qVX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130808:

*crickets*

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

We are up to 222 trees (counting Linus' and 30 trees of patches pending
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
Merging origin/master (6c2580c Merge branch 'for-linus' of git://git.kernel=
.org/pub/scm/linux/kernel/git/egtvedt/linux-avr32)
Merging fixes/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (c095ba7 Linux 3.11-rc4)
Merging arm-current/fixes (e35ac62 Merge branch 'security-fixes' into fixes)
Merging m68k-current/for-linus (ad81f05 Linux 3.11-rc1)
Merging metag-fixes/fixes (dfe248b MAINTAINERS: add linux-metag mailing lis=
t)
Merging powerpc-merge/merge (fe956a1 powerpc/windfarm: Fix noisy slots-fan =
on Xserve (rm31))
Merging sparc/master (1c2696c sparc64: Fix ITLB handler of null page)
Merging net/master (75848d3 Merge branch 'for-davem' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (01cb71d net_sched: restore "overhead xxx" handling)
Merging sound-current/for-linus (57e6dae ALSA: usb-audio: do not trust too-=
big wMaxPacketSize values)
Merging pci-current/for-linus (36dd1f3 PCI: mvebu: Disable prefetchable mem=
ory support in PCI-to-PCI bridge)
Merging wireless/master (5a6e0cf cw1200: Fix spurious BUG_ON() trigger when=
 starting AP mode.)
Merging driver-core.current/driver-core-linus (5ae90d8 Linux 3.11-rc3)
Merging tty.current/tty-linus (c095ba7 Linux 3.11-rc4)
Merging usb.current/usb-linus (444ce9d MAINTAINERS: Add separate section fo=
r USB NETWORKING DRIVERS)
Merging staging.current/staging-linus (cefe8a3 Merge tag 'iio-fixes-for-3.1=
1b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging=
-linus)
Merging char-misc.current/char-misc-linus (5ae90d8 Linux 3.11-rc3)
Merging input-current/for-linus (88ce3c3 Merge branch 'next' into for-linus)
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
Merging rr-fixes/fixes (aa52aee virtio-scsi: Fix virtqueue affinity setup)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (d24cdbf vfio-pci: Avoid deadlock on remove)
Merging drm-intel-fixes/drm-intel-fixes (3f57757 drm/i915: do not disable b=
acklight on vgaswitcheroo switch off)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (a00b92e ARC: [ASID] Optimize the threads-of-process s=
witching case)
Merging arm/for-next (bb32e3d Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (ad81f05 Linux 3.11-rc1)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b028161 Merge branch 'for-3.11' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging arm64/upstream (845ad05 arm64: Change kernel stack size to 16K)
Merging blackfin/for-linus (eb043d3 smp: blackfin: fix check error, using a=
tomic_ops to handle atomic_t type)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (9c510f7 [IA64] dmi.h: Make dmi_alloc use kzalloc)
CONFLICT (content): Merge conflict in arch/ia64/configs/xen_domu_defconfig
CONFLICT (content): Merge conflict in arch/ia64/configs/tiger_defconfig
CONFLICT (content): Merge conflict in arch/ia64/configs/gensparse_defconfig
CONFLICT (content): Merge conflict in arch/ia64/configs/generic_defconfig
Merging m68k/for-next (ad81f05 Linux 3.11-rc1)
Merging m68knommu/for-next (5fbed81 m68k: remove 16 unused boards in Kconfi=
g.machine)
Merging metag/for-next (8a69782 metag: tz1090: instantiate gpio-tz1090-pdc)
Merging microblaze/next (a9b9d22 of/pci: Use of_pci_range_parser)
Merging mips/mips-for-linux-next (3e7522b Merge branch '3.11-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (9f0f4fb parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (3b2f64d Linux 3.11-rc2)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (dd0120d powerpc/mpc512x: enable USB support in defcon=
fig)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (6d7e8d8 s390/time: clock comparator revalidation)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (bb94fb9 arch/tile: provide traceability for hypervisor=
 calls)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (3b2f64d Linux 3.11-rc2)
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
Merging ceph/master (71b4325 ceph: wake up writer if vmtruncate work get bl=
ocked)
Merging cifs/for-next (757c4f6 cifs: don't instantiate new dentries in read=
dir for inodes that need to be revalidated immediately)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging ext3/for_next (e729eac udf: Refuse RW mount of the filesystem inste=
ad of making it RO)
Merging ext4/dev (533ec0e ext4: avoid reusing recently deleted inodes in no=
 journal mode)
Merging f2fs/dev (c2d715d f2fs: fix a build failure due to missing the kobj=
ect header)
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (c7263bc fuse: readdirplus: cleanup)
Merging gfs2/master (7f59503 GFS2: don't overrun reserved revokes)
Merging jfs/jfs-next (eb8630d jfs: Update jfs_error)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (44c6a84 Merge branch 'bugfixes' into linux-next)
Merging nfsd/nfsd-next (df66e75 nfsd: nfs4_file_get_access: need to be more=
 careful with O_RDWR)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b3f8ab4 fs: 9p: use strlcpy instead of strncpy)
Merging ubifs/linux-next (beadadf UBIFS: correct mount message)
Merging xfs/for-next (7a378c9 xfs: WQ_NON_REENTRANT is meaningless and goin=
g away)
Merging vfs/for-next (d405be4 ext4: ->tmpfile() support)
CONFLICT (content): Merge conflict in mm/shmem.c
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Merging pci/next (e3ec221 Merge branch 'pci/wei-resource-cleanups' into nex=
t)
Merging hid/for-next (920dea8 Merge branch 'for-3.12/wiimote' into for-next)
Merging i2c/i2c/for-next (2806914 drivers/i2c/busses: don't check resource =
with devm_ioremap_resource)
Merging jdelvare-hwmon/master (6f7e0b6 hwmon: (w83792d) Update module autho=
r)
Merging hwmon-staging/hwmon-next (abb749c hwmon: (acpi_power_meter) Fix inc=
orrect placement of __initdata)
Merging v4l-dvb/master (e5c9146 Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (8de6aeb Merge branches 'kbuild/kconfig' and 'kbuil=
d/misc' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (3ea47c0 Merge branch 'for-3.12' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (38fcf54 Merge branch 'acpi-assorted-next' into linux=
-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (ace120d Thermal: Fix lockup of cpu_down())
Merging ieee1394/for-next (0a41981 firewire: core: typecast from gfp_t to b=
ool more safely)
Merging ubi/linux-next (83ff59a UBI: support ubi_num on mtd.ubi command lin=
e)
Merging dlm/next (ededf30 dlm: WQ_NON_REENTRANT is meaningless and going aw=
ay)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (2194971 Merge branch 'for-linus' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (09effa6 packet: Revert recent header parsing chang=
es.)
Merging ipsec-next/master (af83fde xfrm: Remove rebundant address family ch=
ecking)
Merging wireless-next/master (2952f6e ath9k: Add more PCI IDs for WB225 car=
ds)
CONFLICT (content): Merge conflict in drivers/net/ethernet/broadcom/Kconfig
Merging bluetooth/master (473c131 Bluetooth: replace strict_strtol() with k=
strtol())
Merging infiniband/for-next (569935d Merge branches 'cma', 'cxgb3', 'cxgb4'=
, 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (e79265b mtd: ofpart: add compatible check for child nod=
es)
Merging l2-mtd/master (a789b9a mtd: gpmi: set the BCH's geometry with the e=
cc info)
Merging crypto/master (032c8ca crypto: testmgr - remove double execution of=
 the same test suite)
Merging drm/drm-next (00fd78e drm: provide agp dummies for CONFIG_AGP=3Dn)
CONFLICT (content): Merge conflict in drivers/gpu/drm/qxl/qxl_release.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-intel/for-linux-next (6d2b888 drm/i915: List objects allocated =
from stolen memory in debugfs)
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (663819f ALSA: don't push static constants on stack =
for %*ph)
Merging sound-asoc/for-next (49ca8bb Merge remote-tracking branch 'asoc/top=
ic/wm8994' into asoc-next)
Merging modules/modules-next (ad81f05 Linux 3.11-rc1)
Merging virtio/virtio-next (3f0d0c9 virtio: console: cleanup an error messa=
ge)
Merging input/next (46146e7 Input: nspire-keypad - replace magic offset wit=
h define)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (f00eaaa Merge branch 'for-3.12' into for-next)
Merging block/for-next (3fe9649 Merge branch 'for-3.11/drivers' into for-ne=
xt)
Merging device-mapper/master (ad81f05 Linux 3.11-rc1)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (6d1d6b4 mmc: tmio: fix compiler warning)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (0450b0c Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (5ad58b4 md/raid5: make release_stripe lockless)
Merging mfd/master (38c4faa mfd: ucb1x00: Explicitely include linux/device.=
h)
Merging mfd-lj/for-mfd-next (ec10436 mfd: wm5110: Set FX_CTRL2 to volatile)
Merging battery/master (5a6c220 charger-manager: Fix regulator_get() return=
 check)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (fb52566 fb: backlight: HX8357: Add HX8369 suppo=
rt)
Merging regulator/for-next (4dc3ef7 Merge remote-tracking branch 'regulator=
/topic/tps65912' into regulator-next)
Merging security/next (9548906 xattr: Constify ->name member of "struct xat=
tr".)
Merging selinux/master (2be4d74 Add SELinux policy capability for always ch=
ecking packet and peer classes.)
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging lblnet/master (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (01ce784 Merge branches 'x86/vt-d', 'arm/omap', 'core', =
'x86/amd' and 'arm/smmu' into next)
Merging vfio/next (6cdd978 vfio: add external user support)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (ccb7cc0 credits: update contact information for C=
hris Cheney)
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (f0a56c4 amd64_edac: Fix single-channel setups)
Merging devicetree/devicetree/next (245d964 of/platform: Staticize of_platf=
orm_device_create_pdata())
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/for-next (300f53d Merge remote-tracking branch 'spi/topic/xilin=
x' into spi-next)
Merging tip/auto-latest (ef85938 Merge branch 'x86/urgent')
Merging ftrace/for-next (9457158 tracing: Fix reset of time stamps during t=
race_clock changes)
Merging rcu/rcu/next (4cd7ecc rcu: NFI: add diagnostics to RCU's grace-peri=
od kthread)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (bf64087 KVM: s390: Make KVM_HVA_ERR_BAD usable on s=
390)
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (20f7462 Merge remote-tracking branch 'cmadma/=
for-v3.12-cma-dma' into kvm-ppc-next)
CONFLICT (content): Merge conflict in mm/Kconfig
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen-tip/linux-next (85e5d6e Merge remote branch 'xentip/stable/for-=
linus-3.11' into xentip-linux-next)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (b84acfb Merge branch 'for-3.11-fixes' into for=
-next)
Merging drivers-x86/linux-next (de91b53 x86 platform drivers: fix gpio leak)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (9851d62 Merge remote-tracking branch 'regmap/topic=
/sparse' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (519220a leds: ss4200: Fix incorrect placement of __i=
nitdata)
Merging driver-core/driver-core-next (e70b091 tile / cpu topology: remove s=
tale Macro arch_provides_topology_pointers)
CONFLICT (content): Merge conflict in net/core/net-sysfs.c
Merging tty/tty-next (16cf48a register_console: prevent adding the same con=
sole twice)
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
Merging usb/usb-next (5b146f7 Merge 3.11-rc4 into usb-next)
Merging usb-gadget/next (941ea36 usb: dwc3: use dev_get_platdata())
CONFLICT (content): Merge conflict in drivers/usb/musb/tusb6010.c
CONFLICT (content): Merge conflict in drivers/usb/musb/omap2430.c
CONFLICT (content): Merge conflict in drivers/usb/host/ehci-tegra.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc-core.c
Merging staging/staging-next (98f62b7 staging/zcache: Fix memory leak while=
 dropping an o2net_sock_container object)
Merging char-misc/char-misc-next (d3b688c Tools: hv: check return value of =
system in hv_kvp_daemon)
Merging scsi/for-next (959823b Merge branch 'fixes' into for-next)
Merging target-updates/for-next (ca40d24 iser-target: Ignore non TEXT + LOG=
OUT opcodes for discovery)
Merging target-merge/for-next-merge (317ddd2 Linux 3.10-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (8bb495e Linux 3.10)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (0979714 Merge branch 'devel' into for-next)
Merging vhost/linux-next (8c325ee vhost: wake up worker outside spin_lock)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (b0305e9 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (8d015b7 Merge branch 'next/fixes-non-critical' in=
to for-next)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (9c59be7 Merge branch 'ep93xx-devel' into ep=
93xx-for-next)
Merging imx-mxs/for-next (d2adb32 Merge branches 'mxs/soc' and 'mxs/dt' int=
o for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (8fb0bf1 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging mvebu/for-next (97a28fb Merge branch 'mvebu/msi_mvebu' into for-nex=
t)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/i2c=
/i2c-mv64xxx.txt
Merging renesas/next (8a8c6f7 Merge tag 'renesas-defconfig-for-v3.12' into =
next)
CONFLICT (modify/delete): drivers/leds/leds-renesas-tpu.c deleted in renesa=
s/next and modified in HEAD. Version HEAD of drivers/leds/leds-renesas-tpu.=
c left in tree.
CONFLICT (content): Merge conflict in arch/arm/Makefile
$ git rm -f drivers/leds/leds-renesas-tpu.c
Merging samsung/for-next (45fd387 Merge branch 'v3.12-next/cleanup-samsung'=
 into for-next)
Merging tegra/for-next (718d932 Merge branch for-3.12/defconfig into for-ne=
xt)
Merging dma-mapping/dma-mapping-next (f7d8f1e Merge remote-tracking branch =
'dma-public/for-v3.12-cma-dma' into for-next)
Merging pwm/for-next (6d0cf4d ARM: dts: Use the PWM polarity flags)
Merging dma-buf/for-next (8bb495e Linux 3.10)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (d2127ac clk: samsung: Add EPLL and VPLL freq table fo=
r exynos5250 SoC)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging ptr-ret/PTR_RET (ad151d5 GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO)
Merging aio/master (f30d704 aio: table lookup: verify ctx pointer)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (7f9cfd1 lz4: fix compression/decompression si=
gnedness mismatch)
$ git checkout -b akpm remotes/origin/akpm/master
Applying: revert "SELinux: do not handle seclabel as a special flag"
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
Merging akpm/master (89b1cb8 staging/lustre/libcfs: cleanup linux-mem.h)

--Signature=_Fri__9_Aug_2013_16_15_40_+1000_mwnMxM9FB02V6qVX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSBIkRAAoJEECxmPOUX5FEx7MP/AjS2FbEV6LNRSgpBdHrijjU
raL/tToieCbeLS6dGYISJ2wfvRmQs5xhttO0SEjPos2OCjp/LVw6n68d38xFHI97
vdRsUp05tTkN1HJMHL2/mLHTxIFAv5SADcuQxDoOKSWYChFo+262GrWearXAElrH
n1sWxWlZwSkF/d/PFHAQLh6Gmf5i8iY0YPBE9EEWuzLiGpi0paVNH9ndJACuxlTm
Q4n64JkJxQKj1QdbugCGhxQrs+Qdy05zMO2wMsPCE7D9OUVBP2jYZqSl4q2MQ5wP
ALCKFjQxlE/yz0SimeWoj/cGCZq1IPtRVYw6airkGBMf1pIZ57YAhzdFdGEHcMvm
VCBmdpfAJeRzZbMDVrvdWnKpqaaSNkwNh67tS5VARzUhcvTtodDtP1U7q/afLWlG
arKa4sDNv0y7ADxT6XAglP+kDWIvtMu260RIhJXuBr28rfN6fWaYUEd2UXqwZIUW
W+GO/744tgiKUXD0hfAtDf+Xo2iaEPihojxPN7Yp5Wx60rch8kf2d2IPHYyh7pln
RUaFaTeQzNfTdOw+cP4pLFPP1vQAGyAOB2lgN/Tecn5wYIgOC3rrjN4Nbf0JWseG
nrzUaD5+VckJEvSNMsJNAeF4dSYJ0FUGE7Mj2axLUEArjA3qkYPWJI/kvNkbx0KM
duxZqE/M98+NRPFuLV3j
=cD4l
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Aug_2013_16_15_40_+1000_mwnMxM9FB02V6qVX--
