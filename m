Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3EBHf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:35:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55933 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3EBHfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:35:48 -0400
Date: Thu, 2 May 2013 17:35:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 2
Message-Id: <20130502173537.c8aa671a1b22abe2ec341b87@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_May_2013_17_35_37_+1000_vsg7yGSlKrSQqWU."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_May_2013_17_35_37_+1000_vsg7yGSlKrSQqWU.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add any v3.11 destined work to your linux-next included
branches until after v3.10-rc1 is released.

Changes since 20130501:

The vfs tree gained conflicts against Linus' tree.

The akpm tree gained a conflict against Linus' tree and lost a lot of
patches that turned up elsewhere.

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
Merging origin/master (b9394d8 Merge branch 'x86-efi-for-linus' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging fixes/master (96d8683 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/sage/ceph-client)
Merging kbuild-current/rc-fixes (a54292f kbuild: generate generic headers b=
efore recursing into scripts)
Merging arc-current/for-curr (561daec ARC: [mm] Lazy D-cache flush (non ali=
asing VIPT))
Merging arm-current/fixes (1783d45 ARM: 7700/2: Make cpu_init() notrace)
Merging m68k-current/for-linus (e00c73e m68k: Remove inline strlen() implem=
entation)
Merging powerpc-merge/merge (5676005 powerpc/pseries/lparcfg: Fix possible =
overflow are more than 1026)
Merging sparc/master (0fbd067 Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/sparc)
Merging net/master (79f632c unix/stream: fix peeking with an offset larger =
than data in queue)
Merging ipsec/master (da241ef Merge git://git.kernel.org/pub/scm/linux/kern=
el/git/davem/net)
Merging sound-current/for-linus (c5a4698 Merge tag 'asoc-maintainers-v3.9-r=
c6' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for=
-linus)
Merging pci-current/for-linus (d46fc8b x86/pci/mrst: Use configuration mech=
anism 1 for 00:00.0, 00:02.0, 00:03.0)
Merging wireless/master (a8a48e6 Merge tag 'nfc-next-3.10-4' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/sameo/nfc-next)
Merging driver-core.current/driver-core-linus (c1be5a5 Linux 3.9)
Merging tty.current/tty-linus (c1be5a5 Linux 3.9)
Merging usb.current/usb-linus (c1be5a5 Linux 3.9)
Merging staging.current/staging-linus (c1be5a5 Linux 3.9)
Merging char-misc.current/char-misc-linus (c1be5a5 Linux 3.9)
Merging input-current/for-linus (bf61c88 Merge branch 'next' into for-linus)
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
Merging mfd-fixes/master (31880c3 Linux 3.9-rc6)
Merging vfio-fixes/for-linus (904c680 vfio-pci: Fix possible integer overfl=
ow)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (07961ac Linux 3.9-rc5)
Merging arm/for-next (4b6cce6 Merge branches 'devel-stable', 'entry', 'fixe=
s', 'mach-types', 'misc' and 'smp-hotplug' into for-next)
CONFLICT (content): Merge conflict in arch/arm/kvm/arm.c
Merging arm-perf/for-next/perf (ab87304 Merge branches 'perf/fixes' and 'hw=
-breakpoint' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (64e3fd3 arm: zynq: Add support for pmu)
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
Merging arm64/upstream (16c85a1 arm64: Use acquire/release semantics instea=
d of explicit DMB)
Merging blackfin/for-linus (f656c24 blackfin: time-ts: Remove duplicate ass=
ignment)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
Merging hexagon/linux-next (426d29c Hexagon: add v4 CS regs to core copyout=
 macro)
Merging ia64/next (797f6a6 Add size restriction to the kdump documentation)
Merging m68k/for-next (e00c73e m68k: Remove inline strlen() implementation)
Merging m68knommu/for-next (2842e5b0 m68knommu: enable Timer on coldfire 53=
2x)
Merging metag/for-next (164c013 metag: defconfigs: increase log buffer 8KiB=
 =3D> 128KiB)
Merging microblaze/next (01cc2cb microblaze: intc: set the default irq_doma=
in)
Merging mips/mips-for-linux-next (8303692 Merge branch 'next/kvm' into mips=
-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (1f6aaac powerpc: Update tlbie/tlbiel as per ISA doc)
CONFLICT (content): Merge conflict in arch/powerpc/mm/numa.c
CONFLICT (content): Merge conflict in arch/metag/mm/Kconfig
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (fdeaf0e powerpc/512x: add ifm ac14xx board)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (1c21351 s390/pci: use pci_scan_root_bus)
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
Merging ceph/testing (17e4749 rbd: kill off the snapshot list)
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
Merging f2fs/dev (42e49df f2fs: avoid deadlock during evict after f2fs_gc)
Merging fuse/for-next (60b9df7 fuse: add flag to turn on async direct IO)
Merging gfs2/master (222cb53 GFS2: Flush work queue before clearing glock h=
ash tables)
Merging jfs/jfs-next (73aaa22 jfs: fix a couple races)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (9c9a7f0 SUNRPC: Don't spam syslog with "Pseudoflavo=
r not found" messages)
Merging nfsd/nfsd-next (c8c797f nfsd: make symbol nfsd_reply_cache_shrinker=
 static)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (adf96e6 sysrq: don't depend on weak undefined arrays=
 to have an address that compares as NULL)
Merging ubifs/linux-next (c1be5a5 Linux 3.9)
Merging xfs/for-next (123887e xfs: Teach dquot recovery about CONFIG_XFS_QU=
OTA)
CONFLICT (content): Merge conflict in fs/xfs/xfs_iomap.c
Merging vfs/for-next (3c3a685 minimal !CONFIG_PROC_FS fixes)
CONFLICT (content): Merge conflict in ipc/util.c
CONFLICT (content): Merge conflict in ipc/msgutil.c
CONFLICT (content): Merge conflict in fs/read_write.h
CONFLICT (content): Merge conflict in fs/read_write.c
CONFLICT (content): Merge conflict in fs/proc/internal.h
CONFLICT (content): Merge conflict in fs/coredump.c
CONFLICT (content): Merge conflict in fs/compat.c
CONFLICT (content): Merge conflict in drivers/staging/vt6655/device_main.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_specproc.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_ports_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_net_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_mon_ops.c
CONFLICT (content): Merge conflict in drivers/staging/dgrp/dgrp_dpa_ops.c
CONFLICT (modify/delete): drivers/staging/ccg/rndis.c deleted in HEAD and m=
odified in vfs/for-next. Version vfs/for-next of drivers/staging/ccg/rndis.=
c left in tree.
CONFLICT (modify/delete): drivers/staging/ccg/f_fs.c deleteRecorded preimag=
e for 'fs/compat.c'
CONFLICT (modify/delete): drivers/firmware/efivars.c deleted in HEAD and mo=
dified in vfs/for-next. Version vfs/for-next of drivers/firmware/efivars.c =
left in tree.
CONFLICT (content): Merge conflict in arch/powerpc/kernel/rtas_flash.c
$ git rm -f drivers/firmware/efivars.c drivers/staging/ccg/f_fs.c drivers/s=
taging/ccg/rndis.c
Applying: fs: fix up for changes to proc_fs include files
Applying: SUNRPC: update for PDE removal
Applying: efivars: Include missing linux/magic.h inclusions
Applying: efivars: use of kmalloc etc requires the inclusion of slab.h
Merging pci/next (d4f09c5 Merge branch 'pci/gavin-msi-cleanup' into next)
Merging hid/for-next (46b1897 Merge branch 'for-3.10/hid-debug' into for-ne=
xt)
Merging i2c/i2c/for-next (c39e8e4 i2c: xiic: must always write 16-bit words=
 to TX_FIFO)
CONFLICT (content): Merge conflict in drivers/staging/media/go7007/go7007-d=
river.c
CONFLICT (content): Merge conflict in drivers/media/pci/bt8xx/bttv-input.c
Applying: i2c: fixup for code movement from bttv_input.c
Merging jdelvare-hwmon/master (c662b7a hwmon: (lm75) Add support for the Da=
llas/Maxim DS7505)
Merging hwmon-staging/hwmon-next (6445e66 hwmon: (nct6775) Fix coding style=
 problems)
Merging v4l-dvb/master (1d62caa Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (1567364 Merge branch 'kbuild/kconfig' into kbuild/=
for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (2cc1144 sata_highbank: Rename proc_name to the module =
name)
Merging infiniband/for-next (f1258ea Merge branches 'misc' and 'mlx4' into =
for-next)
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb4/qp.c
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (371deb9 Merge branch 'pm-cpufreq')
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
Merging scsi/for-next (73b22ec Merge branch 'misc' into for-next)
Merging target-updates/for-next (04b59ba tcm_vhost: Enable VIRTIO_SCSI_F_HO=
TPLUG)
Merging target-merge/for-next-merge (b8d26b3 iser-target: Add iSCSI Extensi=
ons for RDMA (iSER) target driver)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (0b03930 Merge branch 'for-linus' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (20074f3 filter: fix va_list build error)
Applying: drivers:net: fix up for code movement from rt2x00pci.c
Merging ipsec-next/master (05600a7 xfrm_user: constify netlink dispatch tab=
le)
Merging wireless-next/master (a8a48e6 Merge tag 'nfc-next-3.10-4' of git://=
git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next)
Merging bluetooth/master (975aba3 Bluetooth: Fix multiple LE socket handlin=
g)
Merging mtd/master (cdb6404 mtd: omap2: Use module_platform_driver())
Merging l2-mtd/master (98927a2 mtd: get the ECC info from the parameter pag=
e for ONFI nand)
Merging crypto/master (3862de1 crypto: caam - fix job ring cleanup code)
Merging drm/drm-next (b11b88e drm/i915: fix dmabuf vmap support)
Merging drm-intel/drm-intel-next-queued (dce3271 drm/i915: reference count =
for i915_hw_contexts)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_reg.h
Merging sound/for-next (4ca231b ALSA: usb-audio: caiaq: fix endianness bug =
in snd_usb_caiaq_maschine_dispatch)
Merging sound-asoc/for-next (615973d Merge remote-tracking branch 'asoc/fix=
/wm8994' into asoc-linus)
Merging modules/modules-next (a53a11f3 modpost: fix unwanted VMLINUX_SYMBOL=
_STR expansion)
CONFLICT (content): Merge conflict in include/asm-generic/unistd.h
Merging virtio/virtio-next (01d779a caif_virtio: Remove bouncing email addr=
esses)
CONFLICT (content): Merge conflict in drivers/char/virtio_console.c
CONFLICT (modify/delete): Documentation/virtual/virtio-spec.txt deleted in =
virtio/virtio-next and modified in HEAD. Version HEAD of Documentation/virt=
ual/virtio-spec.txt left in tree.
$ git rm -f Documentation/virtual/virtio-spec.txt
Merging input/next (0c6a616 Input: trackpoint - Optimize trackpoint init to=
 use power-on reset)
Merging input-mt/for-next (194664e Input: MT - handle semi-mt devices in co=
re)
Merging cgroup/for-next (2a0010a cpuset: fix compile warning when CONFIG_SM=
P=3Dn)
Merging block/for-next (410fa26 Merge branch 'for-3.10/drivers' into for-ne=
xt)
CONFLICT (content): Merge conflict in include/linux/blk_types.h
CONFLICT (content): Merge conflict in drivers/block/drbd/drbd_proc.c
Merging device-mapper/master (adf9566 Fix some typos in dm-space-map-metada=
ta.c error messages.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (e4404fa mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (14e50c6 mm: slab: Verify the nodeid passed to ____ca=
che_alloc_node)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (1fef8be raid5: make release_stripe lockless)
Merging mfd/master (99f4c6b mfd: si476x: Don't use 0bNNN)
CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-ux500/cpuidle.c
Merging battery/master (6b17080 pm2301-charger: Fix suspend/resume)
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (bee5465 Merge remote-tracking branch 'regulator=
/topic/wm8994' into v3.9-rc8)
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
Merging devicetree/devicetree/next (d347bc5 Merge branch 'robherring/for-ne=
xt' from git://sources.calxeda.com/kernel/linux.git)
Merging dt-rh/for-next (a2b9ea7 Documentation/devicetree: make semantic of =
initrd-end more explicit)
Merging spi/spi/next (00ab539 spi/s3c64xx: let device core setup the defaul=
t pin configuration)
Merging spi-mb/for-next (cd8d984 spi-topcliff-pch: fix to use list_for_each=
_entry_safe() when delete list items)
Merging tip/auto-latest (979830a Merge branch 'x86/urgent')
CONFLICT (content): Merge conflict in drivers/firmware/efi/efivars.c
CONFLICT (content): Merge conflict in drivers/firmware/efi/efi-pstore.c
Merging ftrace/for-next (4c69e6e tracepoints: Prevent null probe from being=
 added)
Merging rcu/rcu/next (a9be854 Merge commit '6d87669357936bffa1e8fea7a4e7743=
e76905736' into next.2013.10.22a)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (4cee4b7 kvm: KVM_CAP_IOMMU only available with devi=
ce assignment)
CONFLICT (content): Merge conflict in drivers/s390/kvm/virtio_ccw.c
CONFLICT (content): Merge conflict in arch/s390/mm/pgtable.c
Merging kvm-arm/kvm-arm-next (b8022d7 arm: kvm: arch_timer: use symbolic co=
nstants)
Merging kvm-ppc/kvm-ppc-next (8b78645 KVM: PPC: Book3S: Facilities to save/=
restore XICS presentation ctrler state)
Merging oprofile/for-next (23995bb oprofile, s390: Add support for IBM zEnt=
erprise EC12)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (6461b07 Merge branch 'stable/for-linus-3.10' in=
to linux-next)
Merging xen-arm/linux-next (9bc25a1 xen/arm: remove duplicated include from=
 enlighten.c)
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
Merging tty/tty-next (45efcb2 tty/serial/sirf: fix MODULE_DEVICE_TABLE)
Merging usb/usb-next (4626b8d USB: ehci-msm: USB_MSM_OTG needs USB_PHY)
Merging usb-gadget/next (added5f ARM: mxs_defconfig: add CONFIG_USB_PHY)
Merging staging/staging-next (a0eeed4 staging: comedi: ni_labpc: fix legacy=
 driver build)
Merging char-misc/char-misc-next (0e27263 Tools: hv: Fix a checkpatch warni=
ng)
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
Merging vhost/linux-next (6713ce9 vhost: fix error handling in RESET_OWNER =
ioctl)
CONFLICT (content): Merge conflict in drivers/vhost/tcm_vhost.c
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
CONFLICT (content): Merge conflict in drivers/remoteproc/Kconfig
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (753c598 gpio/em: Add Device Tree support)
Merging gpio-lw/for-next (ab6ec0f gpio/omap: ensure gpio context is initial=
ised)
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
Merging arm-soc/for-next (d664025 Merge branch 'next/multiplatform' into fo=
r-next)
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
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/hotplug.c
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
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
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
Merging renesas/next (cda9c03 Merge branch 'heads/soc-sh73a0' into next)
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
Merging dma-buf/for-next (b89e356 dma-buf: Add debugfs support)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (99e621f syscalls.h: slightly reduce the jungles of=
 macros)
Applying: cond_syscall and SYSCALL_ALIAS merge fixup
Merging clk/clk-next (1e43525 clk: add clk_ignore_unused option to keep boo=
t clocks on)
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
CONFLICT (content): Merge conflict in ipc/msg.c
Applying: drivers/char/random.c: fix priming of last_data
Applying: sound/soc/codecs/si476x.c: don't use 0bNNN
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: kernel/auditfilter.c: tree and watch will memory leak when failur=
e occurs
Applying: kernel/audit_tree.c: tree will leak memory when failure occurs in=
 audit_trim_trees()
Applying: drm/fb-helper: don't sleep for screen unblank when an oops is in =
progress
Applying: drivers/video: implement a simple framebuffer driver
Applying: drivers-video-implement-a-simple-framebuffer-driver-fix
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: posix_cpu_timer: consolidate expiry time type
Applying: posix_cpu_timers: consolidate timer list cleanups
Applying: posix_cpu_timers: consolidate expired timers check
Applying: selftests: add basic posix timers selftests
CONFLICT (content): Merge conflict in tools/testing/selftests/Makefile
Applying: posix-timers: correctly get dying task time sample in posix_cpu_t=
imer_schedule()
Applying: posix_timers: Fix racy timer delta caching on task exit
Applying: ipvs: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: lockdep: introduce lock_acquire_exclusive/shared helper macros
Applying: lglock: update lockdep annotations to report recursive local locks
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: vm: adjust ifdef for TINY_RCU
Applying: mm/SPARC: use common help functions to free reserved pages
Applying: mm, vmalloc: export vmap_area_list, instead of vmlist
Applying: mm, vmalloc: remove list management of vmlist after initializing =
vmalloc
Applying: clear_refs: sanitize accepted commands declaration
Applying: clear_refs-sanitize-accepted-commands-declaration-fix
Applying: clear_refs: introduce private struct for mm_walk
Applying: pagemap: introduce pagemap_entry_t without pmshift bits
Applying: pagemap: introduce the /proc/PID/pagemap2 file
Applying: mm: soft-dirty bits for user memory changes tracking
Applying: mem-soft-dirty: Reshuffle CONFIG_ options to be more Arch-friendly
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
Applying: smp: Give WARN()ing when calling smp_call_function_many()/single(=
) in serving irq
Applying: kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: drivers/rtc/rtc-v3020.c: use gpio_request_array()
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-pxa.c: use devm_* APIs
Applying: fat: additions to support fat_fallocate
Applying: fat-additions-to-support-fat_fallocate-fix
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: mwave: fix info leak in mwave_ioctl()
Applying: rapidio: make enumeration/discovery configurable
Applying: rapidio: add enumeration/discovery start from user space
Applying: rapidio: documentation update for enumeration changes
Applying: drivers/net: rename random32() to prandom_u32()
Applying: drivers-net-rename-random32-to-prandom_u32-fix
Applying: brcm80211: fix the misaligned indentation
Applying: remove unused random32() and srandom32()
Applying: random: fix accounting race condition with lockless irq entropy_c=
ount update
Applying: relay: fix timer madness
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
Applying: decompressor: add LZ4 decompressor module
Applying: lib: add support for LZ4-compressed kernel
Applying: arm: add support for LZ4-compressed kernel
Applying: x86: add support for LZ4-compressed kernel
Applying: lib: add lz4 compressor module
Applying: lib-add-lz4-compressor-module-fix
Applying: crypto: add lz4 Cryptographic API
Applying: crypto-add-lz4-cryptographic-api-fix
Applying: seccomp: add generic code for jitted seccomp filters.
Applying: ARM: net: bpf_jit: make code generation less dependent on struct =
sk_filter.
Applying: ARM: net: bpf_jit: add support for jitted seccomp filters.
Applying: bpf: add comments explaining the schedule_work() operation
Merging akpm/master (a32e382 bpf: add comments explaining the schedule_work=
() operation)

--Signature=_Thu__2_May_2013_17_35_37_+1000_vsg7yGSlKrSQqWU.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRghdJAAoJEECxmPOUX5FEFH4P/2lqnTGfLVsthysYXz00HSyq
cXU297mIXtG3gn6gvkyX9geY8M4SoN5Xp/2dOwxgyfdkmTh6res5FuqP9mOyzUjq
UkxtpNLaS02V6s6v49XBRPM7xMvvNqMB3uJhnawWJ+xj33xEQeoGSzyRSYI7Tc8J
9rXuvmS5OeDCBkZM2rspeaBBcSb7aiXuYGblbgyz1tnTwRr8yFfu+bkBF3Nquwqj
Fq8wbyea07gY6xNUy4aenrw5FmC7RQIECLExYmO4SY2/ncWSYB/LEAc4N3gS2JBw
7bFT9KSxZ51IZyJ5vsH2ZqB/T/j1UABKUcoTgzykkqvXSAi1BacUMObeQb0Bx2Oe
Cg1Q5rCvdkexkSKPePuXLnlN0lsNR7rlOcgESUlwGx3O2NDPZ3BNFXY3T812OAVN
3musustdBlEEYMMkB7BC0XUY2KuqhzjZzzQmCgp74N+SWVt8cpdHu+PrObhSXwDW
tmnNHvT9WKkVSLOE3xBWArVJix317WCcXLURqoJNUNcK2j1b0R3ZKe5ZNrEaT+OK
H61W8OcS3JjP12fPUX+J0PJV/plC4AdefjEVR2LEvN0Cnt79RG+qEg5/7Yx0Burs
gEparvGl3bIVV+yNrQyxs/sVi4B9Ghp0vFcCUfTdk9dWkOKKuIzCgv+syotLq251
V/eYPdSKdj+EmUDAxYsl
=tlym
-----END PGP SIGNATURE-----

--Signature=_Thu__2_May_2013_17_35_37_+1000_vsg7yGSlKrSQqWU.--
