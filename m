Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3GODpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 23:45:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57421 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3GODpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 23:45:38 -0400
Date: Mon, 15 Jul 2013 13:45:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jul 15
Message-Id: <20130715134528.8e4977b2c2623d749d23d5ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Jul_2013_13_45_28_+1000_4WZDP5cLD_hSyUaR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jul_2013_13_45_28_+1000_4WZDP5cLD_hSyUaR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The merge window is closed.  Time to clean up all those unclean trees.
The good among you can just fast forward to v3.11-rc1 ;-)

Changes since 20130712:

The akpm tree lost some patches that turned up elsewhere.

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

We are up to 230 trees (counting Linus' and 33 trees of patches pending
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
Merging origin/master (ad81f05 Linux 3.11-rc1)
Merging fixes/master (8177a9d lseek(fd, n, SEEK_END) does *not* go to eof -=
 n)
Merging kbuild-current/rc-fixes (42a0940 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arc-current/for-curr (6d128e1 Revert "Makefile: Fix install error w=
ith make -j option")
Merging arm-current/fixes (cbbe6f8 ARM: 7778/1: smp_twd: twd_update_frequen=
cy need be run on all online CPUs)
Merging m68k-current/for-linus (767bcb4 Merge branch 'exotic-arch-fixes' in=
to for-next)
Merging metag-fixes/fixes (d903bca metag: checksum.h: fix carry in csum_tcp=
udp_nofold)
Merging powerpc-merge/merge (ea461ab powerpc/eeh: Fix fetching bus for sing=
le-dev-PE)
Merging sparc/master (6d128e1 Revert "Makefile: Fix install error with make=
 -j option")
Merging net/master (63345b4 Merge branch 'for_linus' of git://cavan.codon.o=
rg.uk/platform-drivers-x86)
Merging ipsec/master (01cb71d net_sched: restore "overhead xxx" handling)
Merging sound-current/for-linus (42d4ab8 ALSA: usb-audio: fix regression fo=
r fixed stream quirk)
Merging pci-current/for-linus (65694c5 x86/PCI: Map PCI setup data with ior=
emap() so it can be in highmem)
Merging wireless/master (57bf744 Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/bluetooth/bluetooth)
Merging driver-core.current/driver-core-linus (ad81f05 Linux 3.11-rc1)
Merging tty.current/tty-linus (ad81f05 Linux 3.11-rc1)
Merging usb.current/usb-linus (ad81f05 Linux 3.11-rc1)
Merging staging.current/staging-linus (ad81f05 Linux 3.11-rc1)
Merging char-misc.current/char-misc-linus (ad81f05 Linux 3.11-rc1)
Merging input-current/for-linus (88ce3c3 Merge branch 'next' into for-linus)
Merging md-current/for-linus (1376512 md/raid10: fix bug which causes all R=
AID10 reshapes to move no data.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (9c23b7d crypto: caam - Fixed the memory out =
of bound overwrite issue)
Merging ide/master (6d128e1 Revert "Makefile: Fix install error with make -=
j option")
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
Merging drm-intel-fixes/drm-intel-fixes (bcf53de drm/i915: Preserve the DDI=
_A_4_LANES bit from the bios)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (6d128e1 Revert "Makefile: Fix install error with make=
 -j option")
Merging arm/for-next (dd44230 Merge branch 'fixes' into for-next)
Merging arm-perf/for-next/perf (642bd4e perf: ARM: Record the user-mode PC =
in the call chain.)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b028161 Merge branch 'for-3.11' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging arm64/upstream (aa729dc Merge branch 'for-next/hugepages' of git://=
git.linaro.org/people/stevecapper/linux into upstream-hugepages)
Merging blackfin/for-linus (150382a smp: refine bf561 smpboot code)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (9c510f7 [IA64] dmi.h: Make dmi_alloc use kzalloc)
Merging m68k/for-next (767bcb4 Merge branch 'exotic-arch-fixes' into for-ne=
xt)
Merging m68knommu/for-next (e4aa937 Linux 3.10-rc3)
Merging metag/for-next (c20eb0f metag: move EXPORT_SYMBOL(csum_partial) to =
metag_ksyms.c)
Merging microblaze/next (9903883 Merge tag 'dm-3.11-changes' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/agk/linux-dm)
Merging mips/mips-for-linux-next (075a8d5 Merge branch '3.10-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (3b02818 parisc: agp/parisc-agp: allow binding o=
f user memory to the AGP GART)
Merging powerpc/next (1d8b368 pstore: Add hsize argument in write_buf call =
of pstore_ftrace_call)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (dd0120d powerpc/mpc512x: enable USB support in defcon=
fig)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (2bec2ca s390/ptrace: PTRACE_TE_ABORT_RAND)
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (317ddd2 Linux 3.10-rc5)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0eb5afb xtensa: remove the second argument of __bi=
o_kmap_atomic())
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
Merging ceph/master (8b8cf89 libceph: fix invalid unsigned->signed conversi=
on for timespec encoding)
Merging cifs/for-next (7ca601d Do not attemp to do cifs operations reading =
symlinks with SMB2)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (cc18ec3 Use ecryptfs_dentry_to_lower_path in a coupl=
e of places)
Merging ext3/for_next (e628753 quota: Convert use of typedef ctl_table to s=
truct ctl_table)
Merging ext4/dev (e8974c3 ext4: rate limit printk in buffer_io_error())
Merging f2fs/dev (276cee5 f2fs: add proc entry to monitor current usage of =
segments)
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (e5c5f05 fuse: fix alignment in short read optimizati=
on for async_dio)
Merging gfs2/master (a01aedf GFS2: Reserve journal space for quota change i=
n do_grow)
Merging jfs/jfs-next (eb8630d jfs: Update jfs_error)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (9903883 Merge tag 'dm-3.11-changes' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/agk/linux-dm)
Merging nfsd/nfsd-next (1c327d9 lockd: protect nlm_blocked access in nlmsvc=
_retry_blocked)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (f2692ea fs/9p: Remove the unused variable "err" in v=
9fs_vfs_getattr())
Merging ubifs/linux-next (beadadf UBIFS: correct mount message)
Merging xfs/for-next (c31ad43 xfs: Fix the logic check for all quotas being=
 turned off)
Merging vfs/for-next (d405be4 ext4: ->tmpfile() support)
Merging pci/next (a0f75f9 Merge branch 'pci/misc' into next)
Merging hid/for-next (7670320 Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (97191d7 i2c-designware: use div_u64 to fix link)
Merging jdelvare-hwmon/master (6f7e0b6 hwmon: (w83792d) Update module autho=
r)
Merging hwmon-staging/hwmon-next (a50d9a4 hwmon: (ds1621) Fix temperature r=
ounding operations)
Merging v4l-dvb/master (2217438 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (cca867d Merge branch 'kbuild/kbuild' into kbuild/f=
or-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (930ed52 Merge branch 'for-3.11' into for-next)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (43ebde7 Merge branch 'acpi-cleanup-next' into linux-=
next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (817c876 Merge branch 'pm-fixes-next' into fix=
es-next)
CONFLICT (content): Merge conflict in drivers/base/power/qos.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_driver.c
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (e8d3924 thermal: cpu_cooling: fix stub function)
Merging ieee1394/for-next (bcabcfd firewire: remove support of fw_driver.dr=
iver.probe and .remove methods)
Merging ubi/linux-next (83ff59a UBI: support ubi_num on mtd.ubi command lin=
e)
Merging dlm/next (cfa805f dlm: Avoid LVB truncation)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (67eacc1 DMA: shdma: add DT support)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (63345b4 Merge branch 'for_linus' of git://cavan.co=
don.org.uk/platform-drivers-x86)
Merging ipsec-next/master (0289094 af_key: constify lookup tables)
Merging wireless-next/master (98f32f7 ath9k_htc: fix data race between requ=
est_firmware_nowait() callback and suspend())
Merging bluetooth/master (f0868e1 Bluetooth: hidp: remove wrong send_report=
 at init)
Merging infiniband/for-next (e04abfa Merge branches 'mlx5', 'qib' and 'srp'=
 into for-next)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (fb1585b mtd: nand: omap2: clean-up BCHx_HW and BCHx_=
SW ECC configurations in device_probe)
Merging crypto/master (aa2faec crypto: caam - Moved macro DESC_JOB_IO_LEN t=
o desc_constr.h)
Merging drm/drm-next (774d8e3 Merge branch 'drm-next-3.11' of git://people.=
freedesktop.org/~agd5f/linux into drm-next)
Merging drm-intel/for-linux-next (bcf53de drm/i915: Preserve the DDI_A_4_LA=
NES bit from the bios)
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (42d4ab8 ALSA: usb-audio: fix regression for fixed s=
tream quirk)
Merging sound-asoc/for-next (049f3b4 Merge remote-tracking branch 'asoc/fix=
/wm8994' into asoc-linus)
Merging modules/modules-next (9eb76d7 module: cleanup call chain.)
Merging virtio/virtio-next (c893c8d MAINTAINERS: add tools/virtio/ under vi=
rtio)
Merging input/next (46146e7 Input: nspire-keypad - replace magic offset wit=
h define)
Merging input-mt/for-next (257867d Input: MT - Specify that ABS_MT_SLOT mus=
t have a minimum of 0)
Merging cgroup/for-next (07e5c60 Merge branch 'for-3.11-fixes' into for-nex=
t)
Merging block/for-next (4841577 Merge branch 'for-3.11/core' into for-next)
Merging device-mapper/master (9903883 Merge tag 'dm-3.11-changes' of git://=
git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (bfffbea Merge tag 'mmc-updates-for-3.11-rc1' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (f267bfc Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (cbc5bdc md: raid1: use bio_rewind() before bio_copy_da=
ta())
Merging mfd/master (25f311f mfd: sec: Provide max_register to regmap)
Merging battery/master (5a6c220 charger-manager: Fix regulator_get() return=
 check)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (d416216 Merge remote-tracking branch 'regulator=
/fix/sec' into regulator-linus)
Merging security/next (572e5b0 tpm/tpm_i2c_infineon: Remove unused header f=
ile)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (d4b6739 SELinux: fix selinuxfs policy file on big en=
dian systems)
Merging watchdog/master (63345b4 Merge branch 'for_linus' of git://cavan.co=
don.org.uk/platform-drivers-x86)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (01ce784 Merge branches 'x86/vt-d', 'arm/omap', 'core', =
'x86/amd' and 'arm/smmu' into next)
Merging vfio/next (8d38ef1 vfio/type1: Fix leak on error path)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (8ecada1 doc: printk-formats: fix format specifier=
 to %p[Ii]4[hnbl])
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (aad19e5 EDAC, MCE, AMD: Add an MCE signature for=
 new Fam15h models)
Merging devicetree/devicetree/next (6dd18e4 of: Fix address decoding on Bim=
ini and js2x machines)
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the defaul=
t pin configuration)
Merging spi-mb/for-next (e99710c Merge remote-tracking branch 'spi/fix/xili=
nx' into spi-linus)
Merging tip/auto-latest (53e8bb8 Merge branch 'x86/tracing')
Merging ftrace/for-next (dcc3022 tracing: Make tracing_open_generic_{tr,tc}=
() static)
Merging rcu/rcu/next (be77f87 Merge branches 'cbnum.2013.06.10a', 'doc.2013=
.06.10a', 'fixes.2013.06.10a', 'srcu.2013.06.10a' and 'tiny.2013.06.10a' in=
to HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (6d128e1 Revert "Makefile: Fix install error with ma=
ke -j option")
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (20f7462 Merge remote-tracking branch 'cmadma/=
for-v3.12-cma-dma' into kvm-ppc-next)
CONFLICT (content): Merge conflict in mm/Kconfig
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (21f3c04 Merge branch 'stable/for-linus-3.11' in=
to linux-next)
Merging xen-arm/linux-next (176455e xen/arm and xen/arm64: implement HYPERV=
ISOR_tmem_op)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (bbe2a23 Merge branch 'for-3.10-fixes' into for=
-next)
Merging drivers-x86/linux-next (de91b53 x86 platform drivers: fix gpio leak)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (f2e055e regmap: cache: bail in regmap_async_comple=
te() for bus-less maps)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (3337b5c leds: support new LP8501 device - another LP=
55xx common)
Merging driver-core/driver-core-next (ad81f05 Linux 3.11-rc1)
Merging tty/tty-next (ad81f05 Linux 3.11-rc1)
Merging usb/usb-next (ad81f05 Linux 3.11-rc1)
Merging usb-gadget/next (b1fd6cb usb: dwc3: omap: Adds dwc3_omap_readl/writ=
el wrappers)
Merging staging/staging-next (ad81f05 Linux 3.11-rc1)
Merging char-misc/char-misc-next (ad81f05 Linux 3.11-rc1)
Merging scsi/for-next (d26911a Merge branch 'misc' into for-next)
Merging target-updates/for-next (ca40d24 iser-target: Ignore non TEXT + LOG=
OUT opcodes for discovery)
Merging target-merge/for-next-merge (317ddd2 Linux 3.10-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (8bb495e Linux 3.10)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (5b81d55 pinctrl: remove bindings for pinconf opti=
ons needing more thought)
Merging vhost/linux-next (22fa90c vhost: Remove custom vhost rcu usage)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (798f0fd irq: fix checkpatch error)
Merging gpio/gpio/next (644c8df gpio: sx150x: convert to use devm_* functio=
ns)
Merging gpio-lw/for-next (69acf2e Merge branch 'merge' into for-next)
Merging arm-soc/for-next (f681e48 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (7ec4429 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging imx-mxs/for-next (846e4b1 Merge branch 'imx/soc' into for-next)
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (d701eda ARM: dts: msm: Fix merge resolution)
Merging mvebu/for-next (04864c6 Merge branch 'mvebu/regmap' into for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/kirkwood-6281.dtsi
Merging renesas/next (4bfc0fa Merge branch 'fixes' into for-next)
Merging samsung/for-next (65ef7e0 Merge tag 'soc-exynos5420-2' into for-nex=
t)
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging tegra/for-next (7d13205 Linux 3.10-rc6)
Merging dma-mapping/dma-mapping-next (5b91a98 ARM: dma: Drop __GFP_COMP for=
 iommu dma memory allocations)
Merging pwm/for-next (b388f15 pwm: pwm-tiehrpwm: Use clk_enable/disable ins=
tead clk_prepare/unprepare.)
Merging dma-buf/for-next (8bb495e Linux 3.10)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (45e3ec3 clk: tegra: fix ifdef for tegra_periph_reset_=
assert inline)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (7f0ef02 Merge branch 'akpm' (updates from And=
rew Morton))
$ git checkout -b akpm remotes/origin/akpm/master
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: drivers/pcmcia/pd6729.c: convert to module_pci_driver
Applying: drivers/pcmcia/yenta_socket.c: convert to module_pci_driver
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: drm/cirrus: correct register values for 16bpp
Applying: drm/nouveau: make vga_switcheroo code depend on VGA_SWITCHEROO
Applying: drivers/video/acornfb.c: remove dead code
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: include/linux/interrupt.h: add dummy irq_set_irq_wake() for "!GEN=
ERIC_HARDIRQS"
Applying: hrtimer: one more expiry time overflow check in hrtimer_interrupt
Applying: drivers/infiniband/core/cm.c: convert to using idr_alloc_cyclic()
Applying: drivers/mtd/chips/gen_probe.c: refactor call to request_module()
Applying: drivers/net/ethernet/ibm/ehea/ehea_main.c: add alias entry for po=
rtN properties
Applying: mISDN: add support for group membership check
Applying: drivers/atm/he.c: convert to module_pci_driver
Applying: isdn: clean up debug format string usage
Applying: ocfs2: should call ocfs2_journal_access_di() before ocfs2_delete_=
entry() in ocfs2_orphan_del()
Applying: ocfs2: llseek requires ocfs2 inode lock for the file in SEEK_END
Applying: ocfs2: fix issue that ocfs2_setattr() does not deal with new_i_si=
ze=3D=3Di_size
Applying: ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size=
=3D=3Di_size-v2
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
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: swap: add a simple detector for inappropriate swapin readahead
Applying: swap: swapin_nr_pages() can be static
Applying: vmcore: allow user process to remap ELF note segment buffer
Applying: vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix
Applying: vmcore: disable mmap_vmcore() if CONFIG_MMU is not defined
Applying: mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-manage=
d_pages-fix
Applying: mm-correctly-update-zone-managed_pages-fix-fix-fix
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
Applying: include/linux/mmzone.h: cleanups
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: mm: add vm event counters for balloon pages compaction
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: list: remove __list_for_each()
Applying: checkpatch: warn when networking block comment lines don't start =
with *
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: autofs4: allow autofs to work outside the initial PID namespace
Applying: autofs4: translate pids to the right namespace for the daemon
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: signals: eventpoll: set ->saved_sigmask at the start
Applying: coredump: '% at the end' shouldn't bypass core_uses_pid logic
Applying: move-exit_task_namespaces-outside-of-exit_notify-fix
Applying: relay: fix timer madness
Applying: drivers/iio/inkern.c: fix iio_convert_raw_to_processed_unlocked()
Applying: staging/lustre/ldlm: convert to shrinkers to count/scan API
Applying: staging/lustre/obdclass: convert lu_object shrinker to count/scan=
 API
Applying: staging/lustre/ptlrpc: convert to new shrinker API
Applying: staging/lustre/libcfs: cleanup linux-mem.h
Applying: staging/lustre: replace num_physpages with totalram_pages
Merging akpm/master (cd27134 staging/lustre: replace num_physpages with tot=
alram_pages)
$ git checkout -b cpuinit remotes/origin/cpuinit/master
Applying: alpha: delete __cpuinit usage from all users
Applying: parisc: delete __cpuinit usage from all users
Applying: MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code
Applying: arm: delete __cpuinit/__CPUINIT usage from all ARM users
Applying: sparc: delete __cpuinit/__CPUINIT usage from all users
Applying: arm64: delete __cpuinit usage from all users
Applying: blackfin: delete __cpuinit usage from all blackfin files
Applying: s390: delete __cpuinit usage from all s390 files
Applying: sh: delete __cpuinit usage from all sh files
Applying: tile: delete __cpuinit usage from all tile files
Applying: metag: delete __cpuinit usage from all metag files
Applying: cris: delete __cpuinit usage from all cris files
Applying: frv: delete __cpuinit usage from all frv files
Applying: hexagon: delete __cpuinit usage from all hexagon files
Applying: m32r: delete __cpuinit usage from all m32r files
Applying: openrisc: delete __cpuinit usage from all openrisc files
Applying: xtensa: delete __cpuinit usage from all xtensa files
Applying: score: delete __cpuinit usage from all score files
Applying: x86: delete __cpuinit usage from all x86 files
Applying: clocksource+irqchip: delete __cpuinit usage from all related files
Applying: cpufreq: delete __cpuinit usage from all cpufreq files
Applying: hwmon: delete __cpuinit usage from all hwmon files
Applying: acpi: delete __cpuinit usage from all acpi files
Applying: net: delete __cpuinit usage from all net files
Applying: rcu: delete __cpuinit usage from all rcu files
Applying: kernel: delete __cpuinit usage from all core kernel files
Applying: drivers: delete __cpuinit usage from all remaining drivers files
Applying: block: delete __cpuinit usage from all block files
Merging cpuinit/master (da0d408 block: delete __cpuinit usage from all bloc=
k files)

--Signature=_Mon__15_Jul_2013_13_45_28_+1000_4WZDP5cLD_hSyUaR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR43BcAAoJEECxmPOUX5FE4AYQAJJsD0it9UAlxvPjK15l1aiM
PmqQugsKqWSMcbRZX+8wd1cSF73MxQlpibinawnbGkj/WGkGSPpFOk2NhJcL/P4Y
vnNLeJULByIVfCZxqRaFOkAbmZ8kgRTebn+QpKRIuZY6oXxAic0nhonRsXZYZOHi
/jpdEp8uIYMM1jfZP9pr48wj6VxES82EZxK+1+Hu14DIit0h4xcMXZYVOLW+y1VF
OgX28/Jpbd/X8QYZrJ947qG2TKPxyw9rxxgkCgxpSxFy/SGxAGNKusgaKVGbCBcx
NZQTgZciJMIkle4XWo70XX/ktnsglZGZX2uxSS33p6bOs0zetyC2tvT3VeQmJaFp
XOIgozbTOH6dGE0w5g5RjO44XpAk62jLQZW7Er1KUUqQCu7rxB4JePmo2GIKeJEJ
u9RKqEaAe+73NU0p7VMob5m4fy4PoFrDXPKUJr04Uq+aP4Vsio+bFNTzoe+hqs4l
GlxL3Wy5SI26VG1Db+zrBSkjJMKBVCeE2MJnUVslwNaOOSHcoG2f1mej7P8S5ars
ISRs0uuYTXwX/AV2RKs5w0HNA+HpOaNjokFFY00TFbjWgh0TwNbulpbQZEa2HKZz
m2pHuPTL2Eu/w4Lufz50pj4bs0gysgx7ID5d1rxUggzl2GCxLbksWn5dT2WEMe8C
yk4/ezkw9PuDjObHuSmA
=ByW9
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jul_2013_13_45_28_+1000_4WZDP5cLD_hSyUaR--
