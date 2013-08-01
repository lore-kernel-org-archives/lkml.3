Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3HAHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:25:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49536 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3HAHZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:25:53 -0400
Date: Thu, 1 Aug 2013 17:25:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Aug 1
Message-Id: <20130801172544.3129b9e0d0e3c855f5b6d5ba@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Aug_2013_17_25_44_+1000_pQLz3RSCQ09uOdPw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Aug_2013_17_25_44_+1000_pQLz3RSCQ09uOdPw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130731:

Removed trees: xen-arm (merged into the xen-tip tree)

The ext4 tree still has its build failure so I used the version from
next-20130726.

The driver-core tree gained a conflict against the net-next tree.

The usb-gadget tree lost its build failure but gained conflicts against
Linus' tree.

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
Merging origin/master (06693f3 Merge git://git.kernel.org/pub/scm/linux/ker=
nel/git/davem/net)
Merging fixes/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (4ffd9e2 ARC: SMP build breakage)
Merging arm-current/fixes (cd717a2 ARM: Add .text annotations where require=
d after __CPUINIT removal)
Merging m68k-current/for-linus (ad81f05 Linux 3.11-rc1)
Merging metag-fixes/fixes (dfe248b MAINTAINERS: add linux-metag mailing lis=
t)
Merging powerpc-merge/merge (ff3d79d powerpc/perf: BHRB filter configuratio=
n should follow the task)
Merging sparc/master (6d128e1 Revert "Makefile: Fix install error with make=
 -j option")
Merging net/master (cf3c4c0 8139cp: Add dma_mapping_error checking)
Merging ipsec/master (01cb71d net_sched: restore "overhead xxx" handling)
Merging sound-current/for-linus (a8d3060 ALSA: compress: fix the return val=
ue for SNDRV_COMPRESS_VERSION)
Merging pci-current/for-linus (aa914f5 PCI: Retry allocation of only the re=
source type that failed)
Merging wireless/master (11a4582 Merge tag 'nfc-fixes-3.11-2' of git://git.=
kernel.org/pub/scm/linux/kernel/git/sameo/nfc-fixes)
Merging driver-core.current/driver-core-linus (5ae90d8 Linux 3.11-rc3)
Merging tty.current/tty-linus (d5a12ea serial: arc_uart: Fix module alias)
Merging usb.current/usb-linus (fed1f1e USB: serial: ftdi_sio: add more RT S=
ystems ftdi devices)
Merging staging.current/staging-linus (0207379 staging: zcache: fix "zcache=
=3D" kernel parameter)
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
Merging rr-fixes/fixes (96f97a8 virtio: console: return -ENODEV on all read=
 operations after unplug)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (d24cdbf vfio-pci: Avoid deadlock on remove)
Merging drm-intel-fixes/drm-intel-fixes (61c2542 drm/i915: fix gen4 digital=
 port hotplug definitions)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (524a105 ARC: [ASID] Optimize the threads-of-process s=
witching case)
Merging arm/for-next (7616732 Merge branch 'devel-stable' into for-next)
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
Merging m68knommu/for-next (703b943 m68k/coldfire: flush cache when creatin=
g the signal stack frame)
Merging metag/for-next (8a69782 metag: tz1090: instantiate gpio-tz1090-pdc)
Merging microblaze/next (a9b9d22 of/pci: Use of_pci_range_parser)
Merging mips/mips-for-linux-next (d0e4912 Merge branch '3.11-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (06693f3 Merge git://git.kernel.org/pub/scm/linu=
x/kernel/git/davem/net)
Merging powerpc/next (3b2f64d Linux 3.11-rc2)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (dd0120d powerpc/mpc512x: enable USB support in defcon=
fig)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (83b6bcd s390/sclp: reword cpu capability change mess=
age)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (9ae8480 tile: convert uses of "inv" to "finv")
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (3b2f64d Linux 3.11-rc2)
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
Merging ceph/master (71b4325 ceph: wake up writer if vmtruncate work get bl=
ocked)
Merging cifs/for-next (66ffd11 cifs: set sb->s_d_op before calling d_make_r=
oot())
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (07bc9dc Merge branch 'merge' of git://git.kernel.org=
/pub/scm/linux/kernel/git/benh/powerpc)
Merging ext3/for_next (e729eac udf: Refuse RW mount of the filesystem inste=
ad of making it RO)
Merging ext4/dev (4a8603e ext4: avoid reusing recently deleted inodes in no=
 journal mode)
$ git reset --hard HEAD^
Merging next-20130726 version of ext4
Merging f2fs/dev (cbd56e7 f2fs: fix handling orphan inodes)
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (c7263bc fuse: readdirplus: cleanup)
Merging gfs2/master (6daf3e6 GFS2: WQ_NON_REENTRANT is meaningless and goin=
g away)
Merging jfs/jfs-next (eb8630d jfs: Update jfs_error)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (55b5929 NFSv4: Fix nfs4_init_uniform_client_string =
for net namespaces)
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
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Merging pci/next (b7c75de PCI: Claim ACS support for AMD southbridge device=
s)
Merging hid/for-next (093aba1 Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (3b2f64d Linux 3.11-rc2)
Merging jdelvare-hwmon/master (6f7e0b6 hwmon: (w83792d) Update module autho=
r)
Merging hwmon-staging/hwmon-next (d8df13e hwmon: (nct6775) Fix size of data=
->temp array)
Merging v4l-dvb/master (2217438 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (8de6aeb Merge branches 'kbuild/kconfig' and 'kbuil=
d/misc' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (3ea47c0 Merge branch 'for-3.12' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (abe513f Merge branch 'acpi-sleep-next' into linux-ne=
xt)
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
Merging slave-dma/next (8f48475 Merge branch 'for-linus' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (49dfe76 Documentation: add networking/netdev-FAQ.t=
xt)
Merging ipsec-next/master (0289094 af_key: constify lookup tables)
Merging wireless-next/master (2cdf359 mwifiex: code rearrangement in sdio.c)
CONFLICT (content): Merge conflict in drivers/net/ethernet/broadcom/Kconfig
Merging bluetooth/master (473c131 Bluetooth: replace strict_strtol() with k=
strtol())
Merging infiniband/for-next (569935d Merge branches 'cma', 'cxgb3', 'cxgb4'=
, 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (fb1585b mtd: nand: omap2: clean-up BCHx_HW and BCHx_=
SW ECC configurations in device_probe)
Merging crypto/master (aa2faec crypto: caam - Moved macro DESC_JOB_IO_LEN t=
o desc_constr.h)
Merging drm/drm-next (aed2c03 drm/gem: fix mmap vma size calculations)
CONFLICT (content): Merge conflict in drivers/gpu/drm/qxl/qxl_release.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-intel/for-linux-next (fae5cbf drm/i915: clean up crtc timings c=
omputation)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (da96fb5 ALSA: hda - Fix invalid multi-io creation o=
n VAIO-Z laptops)
Merging sound-asoc/for-next (49605b3 Merge remote-tracking branch 'asoc/top=
ic/wm8994' into asoc-next)
Merging modules/modules-next (ad81f05 Linux 3.11-rc1)
Merging virtio/virtio-next (314081f virtio: console: fix locking around sen=
d_sigio_to_port())
Merging input/next (46146e7 Input: nspire-keypad - replace magic offset wit=
h define)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (d29cae9 Merge branch 'for-3.12' into for-next)
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
Merging battery/master (5a6c220 charger-manager: Fix regulator_get() return=
 check)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (3b2f64d Linux 3.11-rc2)
Merging regulator/for-next (ac6b916 Merge remote-tracking branch 'regulator=
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
Merging vfio/next (47188d3 Merge tag 'ext4_for_linus' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/tytso/ext4)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (a24a4b9 include/linux/coda.h: remove useless '#el=
se')
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (f0a56c4 amd64_edac: Fix single-channel setups)
Merging devicetree/devicetree/next (245d964 of/platform: Staticize of_platf=
orm_device_create_pdata())
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/for-next (39e5a3f Merge remote-tracking branch 'spi/topic/xilin=
x' into spi-next)
Merging tip/auto-latest (4b8c6f8 Merge branch 'x86/urgent')
Merging ftrace/for-next (1c80c43 ftrace: Consolidate some duplicate code fo=
r updating ftrace ops)
Merging rcu/rcu/next (0f791c9 nohz_full: Force RCU's grace-period kthreads =
onto timekeeping CPU)
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
Merging xen-tip/linux-next (eea3e0b Merge tag 'stable/for-linus-3.11-rc3-ta=
g' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen into linux-n=
ext)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (1315b5c Merge branch 'for-3.12' into for-next)
Merging drivers-x86/linux-next (de91b53 x86 platform drivers: fix gpio leak)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (f021e63 Merge remote-tracking branch 'regmap/topic=
/sparse' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (077e91f leds: use dev_get_platdata())
Merging driver-core/driver-core-next (e70b091 tile / cpu topology: remove s=
tale Macro arch_provides_topology_pointers)
CONFLICT (content): Merge conflict in net/core/net-sysfs.c
Merging tty/tty-next (e26439c serial: pch_uart: Fix signed-ness and casting=
 of uartclk related fields)
Merging usb/usb-next (7d50195 usb: host: Faraday fotg210-hcd driver)
Merging usb-gadget/next (f074245 usb: renesas: use dev_get_platdata())
CONFLICT (content): Merge conflict in drivers/usb/musb/tusb6010.c
CONFLICT (content): Merge conflict in drivers/usb/musb/omap2430.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc-core.c
Merging staging/staging-next (b9b9b35 staging: gdm724x: depend on CONFIG_TT=
Y)
Merging char-misc/char-misc-next (9c5891b Merge 3.11-rc3 into char-misc-nex=
t.)
Merging scsi/for-next (2cb6e5f [SCSI] st: convert class code to use dev_gro=
ups)
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
Merging pinctrl/for-next (fa8ec8f Merge branch 'devel' into for-next)
Merging vhost/linux-next (22fa90c vhost: Remove custom vhost rcu usage)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (b0305e9 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (c53414f Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (9c59be7 Merge branch 'ep93xx-devel' into ep=
93xx-for-next)
Merging imx-mxs/for-next (184b94c Merge branches 'mxs/dt', 'imx/fixes', 'im=
x/weim', 'imx/soc' and 'imx/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (28fd577 Merge branch 'for-3.12/msm-cleanup2' into for=
-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging mvebu/for-next (5c0f737 Merge branches 'mvebu/fixes-non-critical', =
'mvebu/boards', 'mvebu/defconfig' and 'mvebu/dt' into for-next)
Merging renesas/next (833574a Merge tag 'renesas-clocksource-for-v3.12' int=
o next)
Merging samsung/for-next (abba936 Merge branch 'v3.11-samsung-fixes-2' into=
 for-next)
Merging tegra/for-next (c8cd3e7 Merge branch for-3.12/defconfig into for-ne=
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
Merging clk/clk-next (406c598 clk: exynos5250: Add G2D gate clock)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging ptr-ret/PTR_RET (ad151d5 GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO)
Merging aio/master (6878ea7 aio: be defensive to ensure request batching is=
 non-zero instead of BUG_ON())
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (36313f8 lz4: fix compression/decompression si=
gnedness mismatch)
CONFLICT (content): Merge conflict in fs/binfmt_elf.c
$ git checkout -b akpm remotes/origin/akpm/master
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
Merging akpm/master (d6c1238 staging/lustre/libcfs: cleanup linux-mem.h)

--Signature=_Thu__1_Aug_2013_17_25_44_+1000_pQLz3RSCQ09uOdPw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+g19AAoJEECxmPOUX5FEqFAP/RGp0QAhRRuPPS8WX+HxWT4k
f557Kd+GXszK3NVxj3d1FcvdheH0AO12jrIb+u5jZ46nypxPPF333qUSOJD9f8Pp
DKvGv4RRC93WDgjYjRrE6cklnDkHXxC5ERtTnEJuk/XVJDTjfhyhLntOwlPFxrcK
h8JyH5XFhUNVhxCCHCBpWCR9hrF96I8rnRWaiXWMnQ89INJfhe8hy+dE3+vplCv9
amUcYXmQ7y6zd37e/qJx+N42JonmYo9cJ6PpqJ5a1kjTkNtylaNmbX3L/DMEyGon
rrH78oOsTDVbwSFz7m1/bacqR69wBFUclPsfuiLikC1q4IKoCU86FEMoq0Ny3DZL
dwaik1UFS54p6xF184p1gca6NeBEZJp6um4yYwLGY9G8seiLlH5PmStLwS0lttpM
SLiMg8OJ2Q9F6VOKY+hiMVpMtC5pP0yfRpHsihbCqo2T4umwKutr9fz5UuDvXzq2
ZSS7oU+C0+0G6mE8jaJLUaOOmJnIgCD7yxTKvOmZqgR7zfJsL1dROLTpC2Ji9iPq
+r8AXcXHPIcTR/C93FzOqWX1jWO1cNLPzl4qWV2cyph2aSU0jYPmEMENlVxGCwpQ
VoVcaeDTSb708E+k2TWKeQfbsHybXTrhVMclSRfU8ZrYCiiNF45cDLLY+1ydYCSJ
k9IyruXuGHlqwJicx8Ex
=wmF7
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Aug_2013_17_25_44_+1000_pQLz3RSCQ09uOdPw--
