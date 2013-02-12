Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3BLFKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:10:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55936 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3BLFKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:10:03 -0500
Date: Tue, 12 Feb 2013 16:09:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 12
Message-Id: <20130212160953.b80a57fec99e4bd9afb4b601@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_16_09_53_+1100_HAzIJpWhzYilXm2O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_16_09_53_+1100_HAzIJpWhzYilXm2O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130211:

The acpi tree lost its build failure.

The net-next tree gained a conflict against the net tree.

The arm-soc tree gained conflicts against the usb and metag trees.

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

We are up to 214 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (836dc9e Linux 3.8-rc7)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arm-current/fixes (79d1f5c ARM: 7641/1: memory: fix broken mmap by =
ensuring TASK_UNMAPPED_BASE is aligned)
Merging m68k-current/for-linus (836dc9e Linux 3.8-rc7)
Merging powerpc-merge/merge (eda8eeb powerpc/mm: Fix hash computation funct=
ion)
Merging sparc/master (04cef49 sparc: kernel/sbus.c: fix memory leakage)
Merging net/master (547b4e7 bridge: set priority of STP packets)
Merging ipsec/master (6642f91 dm9601: support dm9620 variant)
Merging sound-current/for-linus (602b3e0 Merge tag 'asoc-v3.8-rc6' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/broonie/sound into for-linus)
Merging pci-current/for-linus (444ee9b PCI: remove depends on CONFIG_EXPERI=
MENTAL)
Merging wireless/master (d786f67 mwl8k: fix band for supported channels)
Merging driver-core.current/driver-core-linus (949db15 Linux 3.8-rc5)
Merging tty.current/tty-linus (949db15 Linux 3.8-rc5)
Merging usb.current/usb-linus (836dc9e Linux 3.8-rc7)
Merging staging.current/staging-linus (949db15 Linux 3.8-rc5)
Merging char-misc.current/char-misc-linus (949db15 Linux 3.8-rc5)
Merging input-current/for-linus (9937c02 Input: wacom - fix wacom_set_repor=
t retry logic)
Merging md-current/for-linus (0ecfa11 md: protect against crash upon fsync =
on ro array)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (a2c0911 crypto: caam - Updated SEC-4.0 devic=
e tree binding for ERA information.)
Merging ide/master (9974e43 ide: fix generic_ide_suspend/resume Oops)
Merging dwmw2/master (084a0ec x86: add CONFIG_X86_MOVBE option)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging irqdomain-current/irqdomain/merge (a0d271c Linux 3.6)
Merging devicetree-current/devicetree/merge (ab28698 of: define struct devi=
ce in of_platform.h if !OF_DEVICE and !OF_ADDRESS)
Merging spi-current/spi/merge (d3601e5 spi/sh-hspi: fix return value check =
in hspi_probe().)
Merging gpio-current/gpio/merge (bc1008c gpio/mvebu-gpio: Make mvebu-gpio d=
epend on OF_CONFIG)
Merging rr-fixes/fixes (aded024 virtio_console: Don't access uninitialized =
data.)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/arc-next (b40a262 ARC: Ensure CONFIG_VIRT_TO_BUS is not enabled)
Merging arm/for-next (298e5a6 Merge branch 'fixes' into for-next)
Merging arm-perf/for-next/perf (5ef1240 Merge branches 'for-rmk/hw-breakpoi=
nt' and 'for-rmk/perf' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (42ead3a arm: zynq: timer: Set clock_event cpumask)
Merging arm64/upstream (ec45d1c arm64: mm: update CONTEXTIDR register to co=
ntain PID of current process)
Merging blackfin/for-linus (86794b4 blackfin: SEC: clean up SEC interrupt i=
nitialization)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (77c8006 UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (73898e7 Merge branch 'misc-3.9' into next)
CONFLICT (content): Merge conflict in init/Kconfig
Merging m68k/for-next (5618395 m68k: Sort out !CONFIG_MMU_SUN3 vs. CONFIG_H=
AS_DMA)
Merging m68knommu/for-next (8a67f21 m68knommu: fix trap on execing /bin/ini=
t)
Merging metag/for-next (a21d25e metag: min_low_pfn is now exported by gener=
ic code)
CONFLICT (content): Merge conflict in tools/perf/perf.h
Merging microblaze/next (f54a407 microblaze: Do not use module.h in files w=
hich are not modules)
Merging mips/mips-for-linux-next (38ab365 MIPS: Cleanup break and trap code=
s.)
Applying: min_low_pfn is now exported by generic code
Merging openrisc/for-upstream (7f81ea7 openrisc idle: delete pm_idle)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging powerpc/next (2468dcf powerpc: Add support for context switching th=
e TAR register)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (790f9a4 powerpc/5200: Use the gpt* labels to simplify=
 mpc5200 dts files)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (b4b9aba iucv: fix kernel panic at reboot)
Merging sh/sh-latest (035688d sh: ecovec: add sample amixer settings)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (ecc46c5 tile: support atomic64_dec_if_positive())
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0ed93fe xtensa: avoid mmap cache aliasing)
Merging btrfs/next (fb8ec37 Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into linus-merge)
Merging ceph/master (0fa6ebc libceph: fix protocol feature mismatch failure=
 path)
Merging cifs/for-next (0661732 cifs: ensure that cifs_get_root() only trave=
rses directories)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (a07c48a eCryptfs: remove unneeded checks in virt_to_=
scatterlist())
Merging ext3/for_next (712ddc5 Ext2: remove the static function release_blo=
cks to optimize the kernel)
Merging ext4/dev (17f71a7 ext4: support simple conversion of extent-mapped =
inodes to use i_blocks)
Merging f2fs/dev (1efc6d3 f2fs: add compat_ioctl to provide backward compat=
ability)
Merging fuse/for-next (23c153e fuse: bump version for READDIRPLUS)
Merging gfs2/master (d2b47cf GFS2: Get a block reservation before resizing =
a file)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (c21443c NFSv4: Fix a reboot recovery race when open=
ing a file)
Merging nfsd/nfsd-next (de0b65c sunrpc: fix comment in struct xdr_buf defin=
ition)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (b6f4bee fs/9p: Fix atomic_open)
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (311f08a xfs: memory barrier before wake_up_bit())
CONFLICT (content): Merge conflict in fs/xfs/xfs_buf_item.c
Merging vfs/for-next (3a142ed Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/signal)
Merging pci/next (f2dfcde Merge branch 'pci/misc' into next)
CONFLICT (content): Merge conflict in arch/ia64/pci/pci.c
Merging hid/for-next (1dbbd1f Merge branch 'for-3.9/multitouch' into for-ne=
xt)
Merging i2c/i2c/for-next (cb7f07a i2c: ismt: Add Seth and Myself as maintai=
ners)
Merging jdelvare-hwmon/master (54e37b8 Merge tag 'vfio-for-v3.8-v2' of git:=
//github.com/awilliam/linux-vfio)
Merging hwmon-staging/hwmon-next (4222ada hwmon: (ltc2978) Add support for =
LTC2974 and LTC3883)
Merging v4l-dvb/master (985f70d Merge /home/v4l/v4l/patchwork)
Merging kbuild/for-next (c129f9f Merge branches 'kbuild/misc' and 'kbuild/k=
config' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (44ec657 [SCSI] remove can_power_off flag from scsi_dev=
ice)
Merging infiniband/for-next (cbdba97 Merge branches 'ipoib', 'mlx4' and 'qi=
b' into for-next)
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging pm/linux-next (606f555 Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
CONFLICT (content): Merge conflict in drivers/acpi/internal.h
Merging acpi/next (385fd1c Merge branch 'idle-misc' into release)
CONFLICT (content): Merge conflict in drivers/acpi/processor_idle.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (9d185d0 Thermal: rename thermal governor Kconfig opti=
on to avoid generic naming)
CONFLICT (content): Merge conflict in drivers/thermal/exynos_thermal.c
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (eab7377 UBI: embed ubi_debug_info field in ubi_devi=
ce struct)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (52cb5cb [SCSI] fnic: Fnic Trace Utility)
Merging target-updates/for-next (4e58f5e target: Add device attribute to ex=
pose config_item_name for INQUIRY model)
Merging target-merge/for-next-merge (d1c3ed6 Linux 3.8-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (4702d52 dw_dmac: return proper residue value)
CONFLICT (content): Merge conflict in drivers/dma/tegra20-apb-dma.c
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (7e307c6 mrp: make mrp_rcv static)
CONFLICT (content): Merge conflict in drivers/net/ethernet/broadcom/bnx2x/b=
nx2x_cmn.c
CONFLICT (content): Merge conflict in arch/mips/include/uapi/asm/socket.h
Merging ipsec-next/master (8d06887 xfrm: make gc_thresh configurable in all=
 namespaces)
Merging wireless-next/master (8457703 ath6kl: provide 64-bit per-station by=
te counters)
CONFLICT (content): Merge conflict in drivers/net/wireless/ti/wlcore/spi.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ti/wlcore/sdio.c
Merging bluetooth/master (a3d0935 Bluetooth: Refactor mgmt_pending_foreach)
Merging mtd/master (0ce82b7 mtd: nand: onfi don't WARN if we are in 16 bits=
 mode)
Merging l2-mtd/master (f1a7c9d mtd: bcm47xxsflash: adjust names of bus-spec=
ific functions)
Merging crypto/master (7eb9c5d crypto: caam - Added property fsl,sec-era in=
 SEC4.0 device tree binding.)
CONFLICT (content): Merge conflict in crypto/ctr.c
Merging drm/drm-next (b9e5071 Merge branch 'for-airlied' of git://people.fr=
eedesktop.org/~mlankhorst/linux into drm-next)
Merging sound/for-next (f49a59c ALSA: rme32.c irq enabling after spin_lock_=
irq)
Merging sound-asoc/for-next (2f023a7 Merge remote-tracking branch 'asoc/top=
ic/wm8993' into asoc-next)
Merging modules/modules-next (d9d8d7e MODSIGN: Add option to not sign modul=
es during modules_install)
Merging pekey/devel-pekey (736c71b PEFILE: Load the contained key if we con=
sider the container to be validly signed)
Merging virtio/virtio-next (0d34cc2 virtio-mmio: fix wrong comment about re=
gister offset)
Merging input/next (21fb9f0 Input: twl6040-vibra - use system workqueue)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (6503605 Merge branch 'for-3.8-fixes' into for-next)
Merging block/for-next (19557da Merge branch 'for-3.9/drivers' into for-nex=
t)
Merging device-mapper/master (fc2164a Add a persistent bitset as a wrapper =
around dm-array.)
CONFLICT (content): Merge conflict in drivers/md/dm.c
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (821c0dc mmc: bcm2835: set SDHCI_QUIRK_DATA_TIMEOUT_US=
ES_SDCLK)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (b1e0541 mm/sl[au]b: correct allocation type check in=
 kmalloc_slab())
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (1060071 raid5: create multiple threads to handle strip=
es)
Merging mfd/for-next (7cdd686 Merge branch 'abx500-pinctrl-for-mfd' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl into for-nex=
t)
Merging battery/master (7e6c647 da9030_battery: Include notifier.h)
CONFLICT (content): Merge conflict in include/linux/mfd/abx500/ab8500.h
CONFLICT (content): Merge conflict in include/linux/mfd/abx500/ab8500-bm.h
CONFLICT (content): Merge conflict in drivers/power/ab8500_bmdata.c
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (b0891c2 Merge remote-tracking branch 'regulator=
/topic/tps65090' into regulator-next)
Merging security/next (6e38bfa tpm_tis: check pnp_acpi_device return code)
CONFLICT (content): Merge conflict in security/integrity/ima/ima_main.c
CONFLICT (content): Merge conflict in lib/digsig.c
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (a8eddb8 watchdog: bcm47xx_wdt.c: add hard timer)
CONFLICT (content): Merge conflict in drivers/watchdog/Makefile
CONFLICT (content): Merge conflict in drivers/watchdog/Kconfig
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (9b7a533 Merge branches 'core', 'arm/omap', 'iommu/fixes=
', 'arm/tegra', 'arm/shmobile', 'arm/exynos', 'x86/vt-d' and 'x86/amd' into=
 next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/mach-exynos5-dt.c
Merging vfio/next (e2279eb vfio-pci: Enable PCIe extended capabilities on v=
1)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (9baf64f ARM: at91/ide: remove unsused at91-ide Kc=
onfig entry)
CONFLICT (content): Merge conflict in arch/mips/include/asm/octeon/cvmx-hel=
per-util.h
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/executive/cvm=
x-helper-util.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (1c06910 i7core_edac: fix kernel crash on unloading=
 i7core_edac.)
Merging edac-amd/for-next (e7d2c21 mpc85xx_edac: Fix typo)
Merging devicetree/devicetree/next (bf41016 of: Fix locking when calling of=
_get_next_available_child())
Merging dt-rh/for-next (1421954 documentation/devicetree: Fix a typo in exy=
nos-dw-mshc.txt)
Merging spi/spi/next (095c375 spi: Document cs_gpios and cs_gpio in kernel-=
doc)
CONFLICT (content): Merge conflict in drivers/spi/spi-s3c64xx.c
Merging spi-mb/spi-next (a349685 spi/pxa2xx: add support for Lynxpoint SPI =
controllers)
Merging tip/auto-latest (cd5d978 Merge branch 'linus')
CONFLICT (content): Merge conflict in arch/s390/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/configs/pasemi_defconfig
Applying: cputime: restore CPU_ACCOUNTING config defaults for PPC64
Merging ftrace/for-next (d840f71 tracing: Init current_trace to nop_trace a=
nd remove NULL checks)
Merging rcu/rcu/next (7a6b55e srcu: use ACCESS_ONCE() to access sp->complet=
ed in srcu_read_lock())
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (b0da5be KVM: VMX: add missing exit names to VMX_EXI=
T_REASONS array)
CONFLICT (content): Merge conflict in include/uapi/linux/kvm.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/vmx.h
CONFLICT (content): Merge conflict in arch/s390/kernel/irq.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/irq.h
Applying: KVM: s390: fix for IOINT_VIR name change
Applying: x86, apicv: merge fixup for uapi include file split
Merging kvm-ppc/kvm-ppc-next (b9e3e20 KVM: PPC: E500: Remove kvmppc_e500_tl=
bil_all usage from guest TLB code)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (3f49cb3 Merge branch 'stable/pvh.v7' into linux=
-next)
Applying: xen: fix bad merge of arch/x86/xen/mmu.c
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (3b8d914 Merge branch 'for-3.9-cleanups' into f=
or-next)
Merging drivers-x86/linux-next (6710c61 asus-laptop: Fix potential invalid =
pointer dereference)
CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c
CONFLICT (content): Merge conflict in drivers/platform/x86/intel_oaktrail.c
CONFLICT (content): Merge conflict in drivers/platform/x86/ideapad-laptop.c
CONFLICT (content): Merge conflict in drivers/platform/x86/fujitsu-tablet.c
CONFLICT (content): Merge conflict in drivers/platform/x86/compal-laptop.c
CONFLICT (content): Merge conflict in drivers/platform/x86/apple-gmux.c
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (bad41e6 Merge remote-tracking branch 'regmap/topic=
/no-bus' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (4b07c5d leds: leds-sunfire: use dev_err()/pr_err() i=
nstead of printk())
Merging driver-core/driver-core-next (3213f63 backlight: fix class_find_dev=
ice() arguments)
CONFLICT (modify/delete): net/wanrouter/Kconfig deleted in HEAD and modifie=
d in driver-core/driver-core-next. Version driver-core/driver-core-next of =
net/wanrouter/Kconfig left in tree.
CONFLICT (content): Merge conflict in drivers/spi/spi-s3c64xx.c
CONFLICT (content): Merge conflict in drivers/spi/Kconfig
CONFLICT (content): Merge conflict in drivers/net/wan/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/seeq/Kconfig
CONFLICT (modify/delete): drivers/net/ethernet/racal/Kconfig deleted in HEA=
D and modified in driver-core/driver-core-next. Version driver-core/driver-=
core-next of drivers/net/ethernet/racal/Kconfig left in tree.
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/i825xx/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/fujitsu/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/8390/Kconfig
CONFLICT (content): Merge conflict in drivers/iommu/tegra-smmu.c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-s3c2410.c
CONFLICT (content): Merge conflict in drivers/dma/dw_dmac.c
CONFLICT (content): Merge conflict in drivers/acpi/Kconfig
$ git rm -f net/wanrouter/Kconfig drivers/net/ethernet/racal/Kconfig
Merging tty/tty-next (f2eca58 drivers/serial: add GENERIC_HARDIRQS dependen=
cy)
CONFLICT (content): Merge conflict in drivers/net/wan/Kconfig
CONFLICT (content): Merge conflict in drivers/net/can/Kconfig
CONFLICT (content): Merge conflict in drivers/lguest/Kconfig
CONFLICT (content): Merge conflict in drivers/i2c/busses/Kconfig
Merging usb/usb-next (5273afe drivers/usb: add missing GENERIC_HARDIRQS dep=
endencies)
CONFLICT (content): Merge conflict in drivers/usb/phy/omap-usb2.c
CONFLICT (content): Merge conflict in drivers/usb/musb/omap2430.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/Kconfig
Merging staging/staging-next (78110bb staging: Remove unnecessary OOM messa=
ges)
CONFLICT (content): Merge conflict in drivers/staging/et131x/et131x.c
Merging char-misc/char-misc-next (105cf1f Merge tag 'extcon-arizona-3.9' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc into char-misc-=
next)
CONFLICT (content): Merge conflict in include/linux/mfd/arizona/pdata.h
CONFLICT (content): Merge conflict in drivers/mfd/wm5102-tables.c
CONFLICT (content): Merge conflict in drivers/ipack/devices/ipoctal.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/synclink_cs.c
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (2e22e02 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in include/linux/mfd/abx500/ab8500.h
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
CONFLICT (content): Merge conflict in drivers/gpio/Kconfig
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (50af854 gpiolib: fix link error when sysfs is not b=
uilt)
Merging gpio-lw/for-next (a0d75dd Merge branch 'devel' into for-next)
Merging arm-soc/for-next (6b6c5ef Merge branch 'next/virt' into for-next)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
CONFLICT (content): Merge conflict in drivers/mfd/db8500-prcmu.c
CONFLICT (content): Merge conflict in drivers/crypto/omap-sham.c
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (content): Merge conflict in drivers/clocksource/Kconfig
CONFLICT (content): Merge conflict in drivers/clk/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear6xx/spear6xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear3xx/spear3xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear1340.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-r8a7740.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/dma.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/usb-host.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom-periph=
erals.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-3430sdp.c
Merging bcm2835/for-next (f9b4142 Merge branch 'for-3.9/defconfig' into for=
-next)
Merging cortex/for-next (6ebd4d0 ARM: stub out read_cpuid and read_cpuid_ex=
t for CPU_CP15=3Dn)
CONFLICT (content): Merge conflict in arch/arm/include/asm/cputype.h
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (20e70df Merge branches 'heads/soc4', 'heads/defconfig=
', 'heads/boards', 'boards-kzm9g-reference' and 'heads/pfc' into next)
Merging samsung/for-next (d324d59 Merge branch 'next/secure-exynos' into fo=
r-next)
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/mach-exynos4-dt.c
CONFLICT (content): Merge conflict in arch/arm/common/Makefile
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging tegra/for-next (6bfc166 Merge branch 'for-3.9/soc-ccf-fixes' into f=
or-next)
Merging dma-mapping/dma-mapping-next (ee06158 ARM: DMA-mapping: fix memory =
leak in IOMMU dma-mapping implementation)
Merging pwm/for-next (83cfd72 pwm_backlight: Validate dft_brightness in mai=
n probe function)
Merging dma-buf/for-next (90b6e90 dma-buf: implement vmap refcounting in th=
e interface logic)
Merging userns/for-next (bc1b69e userns: Allow the unprivileged users to mo=
unt mqueue fs)
Merging ktest/for-next (4c0b67a ktest: Ignore warnings during reboot)
Merging signal/for-next (3241b8f x86: convert to ksignal)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/s390/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/syscall.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal_n32.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal32.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal.c
CONFLICT (content): Merge conflict in arch/mips/kernel/scall64-o32.S
CONFLICT (content): Merge conflict in arch/mips/kernel/process.c
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
Merging clk/clk-next (8ae5ac5 clk: vexpress: Use common of_clk_init() funct=
ion)
CONFLICT (content): Merge conflict in include/asm-generic/vmlinux.lds.h
Merging random/dev (6133705 random: Mix cputime from each thread that exits=
 to the pool)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (4d91892 fb: Yet another band-aid for fixing l=
ockdep mess)
CONFLICT (content): Merge conflict in drivers/tty/vt/vt.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: compiler-gcc4.h: Reorder macros based upon gcc ver
Applying: compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
Applying: compiler-gcc{3,4}.h: Use GCC_VERSION macro
Applying: compiler{,-gcc4}.h, bug.h: Remove duplicate macros
Applying: bug.h: Fix BUILD_BUG_ON macro in __CHECKER__
Applying: bug.h: Prevent double evaulation of in BUILD_BUG_ON
Applying: bugh-prevent-double-evaulation-of-in-build_bug_on-fix
Applying: bug.h: Make BUILD_BUG_ON generate compile-time error
Applying: compiler.h, bug.h: Prevent double error messages with BUILD_BUG{,=
_ON}
Applying: bug.h, compiler.h: Introduce compiletime_assert & BUILD_BUG_ON_MSG
Applying: bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-chec=
kpatch-fixes
Applying: proc: avoid extra pde_put() in proc_fill_super()
Applying: compat: return -EFAULT on error in waitid()
Applying: inotify: remove broken mask checks causing unmount to be EINVAL
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: Revert "x86, mm: Make spurious_fault check explicitly check the P=
RESENT bit"
Applying: pageattr: prevent PSE and GLOABL leftovers to confuse pmd/pte_pre=
sent and pmd_huge
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: drivers/md/persistent-data/dm-transaction-manager.c: rename HASH_=
SIZE
Applying: cris: Use "int" for ssize_t to match size_t
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: mm: remove free_area_cache use in powerpc architecture
Applying: mm: use vm_unmapped_area() on powerpc architecture
Applying: drm/fb-helper: don't sleep for screen unblank when an oopps is in=
 progress
Applying: fbcon: clear the logo bitmap from the margin area
Applying: goldfish: framebuffer driver
Applying: video: mmp display subsystem
Applying: video: mmp fb support
Applying: video: mmp display controller support
Applying: video: mmp: add tpo hvga panel supported
Applying: video: mmpdisp: add spi port in display controller
Applying: ARM: mmp: added device for display controller
Applying: ARM: mmp: enable display in ttc_dkb
Applying: ARM: mmp: add display and fb support in pxa910 defconfig
Applying: drivers/video/Kconfig: specify the SoCs that make use of FB_IMX
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: timer_list: split timer_list_show_tickdevices()
Applying: timer_list: convert timer list to be a proper seq_file
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
Applying: ia64/mm: fix a bad_page bug when crash kernel booting
Applying: mm: use vm_unmapped_area() on ia64 architecture
Applying: mm: use vm_unmapped_area() in hugetlbfs on ia64 architecture
Applying: scripts/tags.sh: add ctags magic for declarations of popular kern=
el type
Applying: mm: use vm_unmapped_area() on parisc architecture
Applying: sched: /proc/sched_stat fails on very very large machines
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-fix
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-v2
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix
Applying: sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix
Applying: sched: /proc/sched_debug fails on very very large machines
Applying: sched-proc-sched_debug-fails-on-very-very-large-machines-fix
Applying: sched-proc-sched_debug-fails-on-very-very-large-machines-v2
Applying: sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix
Applying: lockdep: make lockdep_assert_held() not have a return value
Applying: block: don't select PERCPU_RWSEM
Applying: drivers/block/swim3.c: fix null pointer dereference
Applying: cfq: fix lock imbalance with failed allocations
Applying: block: use i_size_write() in bd_set_size()
Applying: block: remove redundant check to bd_openers()
Applying: loopdev: fix a deadlock
Applying: loopdev: update block device size in loop_set_status()
Applying: loopdev: move common code into loop_figure_size()
Applying: loopdev: remove an user triggerable oops
Applying: loopdev: ignore negative offset when calculate loop device size
Applying: block: restore /proc/partitions to not display non-partitionable =
removable devices
Applying: fs: change return values from -EACCES to -EPERM
Applying: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
Applying: watchdog: trigger all-cpu backtrace when locked up and going to p=
anic
Applying: memcg, oom: provide more precise dump info while memcg oom happen=
ing
Applying: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()
Applying: mm/hugetlb.c: convert to pr_foo()
Applying: CMA: make putback_lru_pages() call conditional
Applying: mm/page_alloc.c:__alloc_contig_migrate_range(): cleanup
Applying: mm: memcg: only evict file pages when we have plenty
Applying: mm: vmscan: save work scanning (almost) empty LRU lists
Applying: mm: vmscan: clarify how swappiness, highest priority, memcg inter=
act
Applying: mm: vmscan: improve comment on low-page cache handling
Applying: mm: vmscan: clean up get_scan_count()
Applying: mm-vmscan-clean-up-get_scan_count-fix
Applying: mm: vmscan: compaction works against zones, not lruvecs
Applying: mm-vmscan-compaction-works-against-zones-not-lruvecs-fix
Applying: mm: reduce rmap overhead for ex-KSM page copies created on swap f=
aults
Applying: mm/page_alloc.c:__setup_per_zone_wmarks: make min_pages unsigned =
long
Applying: mm/vmscan.c:__zone_reclaim(): replace max_t() with max()
Applying: mm: compaction: do not accidentally skip pageblocks in the migrat=
e scanner
Applying: mm/huge_memory.c: use new hashtable implementation
Applying: mm/ksm.c: use new hashtable implementation
Applying: memcg,vmscan: do not break out targeted reclaim without reclaimed=
 pages
Applying: mmotm: memcgvmscan-do-not-break-out-targeted-reclaim-without-recl=
aimed-pages.patch fix
Applying: mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-recla=
imed-pagespatch-fix-fix
Applying: mm: make madvise(MADV_WILLNEED) support swap file prefetch
Applying: mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix
Applying: mm: fix BUG on madvise early failure
Applying: mm: compaction: make __compact_pgdat() and compact_pgdat() return=
 void
Applying: mm: avoid calling pgdat_balanced() needlessly
Applying: mm: remap_file_pages() fixes
Applying: mm: introduce mm_populate() for populating new vmas
Applying: mm: use mm_populate() for blocking remap_file_pages()
Applying: mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect
Applying: mm: use mm_populate() for mremap() of VM_LOCKED vmas
Applying: mm: remove flags argument to mmap_region
Applying: mm-remove-flags-argument-to-mmap_region-fix
Applying: mm: directly use __mlock_vma_pages_range() in find_extend_vma()
Applying: mm: introduce VM_POPULATE flag to better deal with racy userspace=
 programs
Applying: mm: make do_mmap_pgoff return populate as a size in bytes, not as=
 a bool
Applying: mm: memory_hotplug: no need to check res twice in add_memory
Applying: memory-hotplug: try to offline the memory twice to avoid dependen=
ce
Applying: memory-hotplug: check whether all memory blocks are offlined or n=
ot when removing memory
Applying: memory-hotplug: remove redundant codes
Applying: memory-hotplug: remove /sys/firmware/memmap/X sysfs
Applying: Bug fix: Hold spinlock across find|remove /sys/firmware/memmap/X =
operation.
Applying: Bug fix: Fix the wrong comments of map_entries.
Applying: Bug fix: Reuse the storage of /sys/firmware/memmap/X/ allocated b=
y bootmem.
Applying: Bug fix: Fix section mismatch problem of release_firmware_map_ent=
ry().
Applying: Bug fix: Fix the doc format in drivers/firmware/memmap.c
Applying: memory-hotplug: introduce new arch_remove_memory() for removing p=
age table
Applying: memory-hotplug: implement register_page_bootmem_info_section of s=
parse-vmemmap
Applying: memory-hotplug-implement-register_page_bootmem_info_section-of-sp=
arse-vmemmap-fix
Applying: memory-hotplug: introduce CONFIG_HAVE_BOOTMEM_INFO_NODE and rever=
t register_page_bootmem_info_node() when platform not support
Applying: memory-hotplug: cleanup: removing the arch specific functions wit=
hout any implementation
Applying: memory-hotplug: mm/Kconfig: move auto selects from MEMORY_HOTPLUG=
 to MEMORY_HOTREMOVE as needed
Applying: memory-hotplug: move pgdat_resize_lock into sparse_remove_one_sec=
tion()
Applying: memory-hotplug: common APIs to support page tables hot-remove
Applying: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix
Applying: Bug fix: Do not calculate direct mapping pages when freeing vmemm=
ap pagetables.
Applying: Bug fix: Do not free direct mapping pages twice.
Applying: Bug fix: Do not free page split from hugepage one by one.
Applying: Bug fix: Do not split pages when freeing pagetable pages.
Applying: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-=
fix-fix-fix-fix-fix
Applying: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-=
fix-fix-fix-fix-fix-fix
Applying: memory-hotplug: remove page table of x86_64 architecture
Applying: memory-hotplug-remove-page-table-of-x86_64-architecture-fix
Applying: memory-hotplug: remove memmap of sparse-vmemmap
Applying: memory-hotplug-remove-memmap-of-sparse-vmemmap-fix
Applying: memory-hotplug: integrated __remove_section() of CONFIG_SPARSEMEM=
_VMEMMAP.
Applying: memory_hotplug: clear zone when removing the memory
Applying: memory-hotplug: remove sysfs file of node
Applying: memory-hotplug: free node_data when a node is offlined
Applying: memory-hotplug: do not allocate pgdat if it was not freed when of=
fline.
Applying: memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-off=
line-fix
Applying: memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-off=
line-fix-fix
Applying: memory-hotplug: consider compound pages when free memmap
Applying: mempolicy: fix is_valid_nodemask()
Applying: cpu_hotplug: clear apicid to node when the cpu is hotremoved
Applying: cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix
Applying: memory-hotplug: export the function try_offline_node()
Applying: memory-hotplug: export the function try_offline_node() fix
Applying: cpu-hotplug, memory-hotplug: try offlining the node when hotremov=
ing a cpu
Applying: cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining th=
e node
Applying: cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-no=
de-fix
Applying: sched: do not use cpu_to_node() to find an offlined cpu's node.
Applying: x86: get pg_data_t's memory from other node
Applying: page_alloc: add movable_memmap kernel parameter
Applying: page_alloc-add-movable_memmap-kernel-parameter-fix
Applying: Bug fix: Fix the doc format.
Applying: page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch=
-fixes
Applying: page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix
Applying: Rename movablecore_map to movablemem_map.
Applying: page_alloc: introduce zone_movable_limit[] to keep movable limit =
for nodes
Applying: Bug fix: Remove the unused sanitize_zone_movable_limit() definiti=
on.
Applying: page_alloc: make movablemem_map have higher priority
Applying: page_alloc: bootmem limit with movablecore_map
Applying: acpi, memory-hotplug: parse SRAT before memblock is ready
Applying: acpi, memory-hotplug: parse SRAT before memblock is ready fix
Applying: acpi, memory-hotplug: extend movablemem_map ranges to the end of =
node
Applying: acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-no=
de-fix
Applying: acpi, memory-hotplug: support getting hotplug info from SRAT
Applying: acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix
Applying: acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix
Applying: mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movab=
lecore_map in memblock_overlaps_region().
Applying: mm: use zone->present_pages instead of zone->managed_pages where =
appropriate
Applying: mm: set zone->present_pages to number of existing pages in the zo=
ne
Applying: mm: increase totalram_pages when free pages allocated by bootmem =
allocator
Applying: mm: remove MIGRATE_ISOLATE check in hotpath
Applying: memory-failure: fix an error of mce_bad_pages statistics
Applying: memory-failure: do code refactor of soft_offline_page()
Applying: memory-failure: use num_poisoned_pages instead of mce_bad_pages
Applying: memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix
Applying: mm/memory-failure.c: clean up soft_offline_page()
Applying: mm/memory-failure.c: fix wrong num_poisoned_pages in handling mem=
ory error on thp
Applying: mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memor=
y-error-on-thp-fix
Applying: mm: don't wait on congested zones in balance_pgdat()
Applying: mm: teach mm by current context info to not do I/O during memory =
allocation
Applying: pm / runtime: introduce pm_runtime_set_memalloc_noio()
Applying: block/genhd.c: apply pm_runtime_set_memalloc_noio on block devices
Applying: net/core: apply pm_runtime_set_memalloc_noio on network devices
Applying: pm / runtime: force memory allocation with no I/O during Runtime =
PM callbcack
Applying: usb: forbid memory allocation with I/O during bus reset
Applying: mm: remove unused memclear_highpage_flush()
Applying: mm: numa: fix minor typo in numa_next_scan
Applying: mm: numa: take THP into account when migrating pages for NUMA bal=
ancing
Applying: mm: numa: handle side-effects in count_vm_numa_events() for !CONF=
IG_NUMA_BALANCING
Applying: mm: move page flags layout to separate header
Applying: mm: Fold page->_last_nid into page->flags where possible
Applying: mm: numa: Cleanup flow of transhuge page migration
Applying: mm: don't inline page_mapping()
Applying: swap: make each swap partition have one address_space
Applying: swap-make-each-swap-partition-have-one-address_space-fix
Applying: swap-make-each-swap-partition-have-one-address_space-fix-fix
Applying: swap: add per-partition lock for swapfile
Applying: swap-add-per-partition-lock-for-swapfile-fix-fix
Applying: swap: fix "add per-partition lock for swapfile" for nommu
Applying: swap: add per-partition lock for swapfile fix
Applying: swap-add-per-partition-lock-for-swapfile-fix-fix-fix-fix
Applying: mm: Get rid of lockdep whinge on sys_swapon
Applying: mm/rmap: rename anon_vma_unlock() =3D> anon_vma_unlock_write()
Applying: page-writeback.c: subtract min_free_kbytes from dirtyable memory
Applying: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
Applying: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fi=
x-fix
Applying: memcg: do not create memsw files if swap accounting is disabled
Applying: memcg: clean up swap accounting initialization code
Applying: mm: uninline page_xchg_last_nid()
Applying: mm: init: report on last-nid information stored in page->flags
Applying: memcg: reduce the size of struct memcg 244-fold.
Applying: memcg-reduce-the-size-of-struct-memcg-244-fold-fix
Applying: memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix
Applying: memcg: prevent changes to move_charge_at_immigrate during task at=
tach
Applying: memcg: split part of memcg creation to css_online
Applying: memcg: fast hierarchy-aware child test
Applying: memcg-fast-hierarchy-aware-child-test-fix
Applying: memcg: replace cgroup_lock with memcg specific memcg_lock
Applying: memcg: increment static branch right after limit set
Applying: memcg: avoid dangling reference count in creation failure.
Applying: mm: memmap_init_zone() performance improvement
Applying: mm: rename page struct field helpers
Applying: mm-rename-page-struct-field-helpers-fix
Applying: ksm: allow trees per NUMA node
Applying: ksm: add sysfs ABI Documentation
Applying: ksm: trivial tidyups
Applying: ksm-trivial-tidyups-fix
Applying: ksm: reorganize ksm_check_stable_tree
Applying: ksm: get_ksm_page locked
Applying: ksm: remove old stable nodes more thoroughly
Applying: ksm: make KSM page migration possible
Applying: ksm: make !merge_across_nodes migration safe
Applying: ksm: enable KSM page migration
Applying: mm: remove offlining arg to migrate_pages
Applying: ksm: stop hotremove lockdep warning
Applying: mm: shmem: use new radix tree iterator
Applying: mm: refactor inactive_file_is_low() to use get_lru_size()
Applying: mm/mlock.c: document scary-looking stack expansion mlock chain
Applying: mm: add SECTION_IN_PAGE_FLAGS
Applying: mm: add & use zone_end_pfn() and zone_spans_pfn()
Applying: mm: add zone_is_empty() and zone_is_initialized()
Applying: mm/page_alloc: add a VM_BUG in __free_one_page() if the zone is u=
ninitialized.
Applying: mmzone: add pgdat_{end_pfn,is_empty}() helpers & consolidate.
Applying: mm/page_alloc: add informative debugging message in page_outside_=
zone_boundaries()
Applying: mm-page_alloc-add-informative-debugging-message-in-page_outside_z=
one_boundaries-fix
Applying: mm: add helper ensure_zone_is_initialized()
Applying: mm/memory_hotplug: use ensure_zone_is_initialized()
Applying: mm/memory_hotplug: use pgdat_end_pfn() instead of open coding the=
 same.
Applying: mmu_notifier_unregister NULL Pointer deref and multiple ->release=
() callouts
Applying: mm: use NUMA_NO_NODE
Applying: mm: remove free_area_cache
Applying: include/linux/mmzone.h: cleanups
Applying: include-linux-mmzoneh-cleanups-fix
Applying: mm: use up free swap space before reaching OOM kill
Applying: memcg: move mem_cgroup_soft_limit_tree_init to mem_cgroup_init
Applying: memcg: move memcg_stock initialization to mem_cgroup_init
Applying: memcg: cleanup mem_cgroup_init comment
Applying: mm: fix return type for functions nr_free_*_pages
Applying: ia64: use %ld to print pages calculated in nr_free_buffer_pages
Applying: fs/buffer.c: change type of max_buffer_heads to unsigned long
Applying: fs/nfsd: change type of max_delegations, nfsd_drc_max_mem and nfs=
d_drc_mem_used
Applying: vmscan: change type of vm_total_pages to unsigned long
Applying: net: change type of netns_ipvs->sysctl_sync_qlen_max
Applying: net: change type of virtio_chan->p9_max_pages
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm: use vm_unmapped_area() on frv architecture
Applying: bdi: allow block devices to say that they require stable page wri=
tes
Applying: mm: only enforce stable page writes if the backing device require=
s it
Applying: 9pfs: fix filesystem to wait for stable page writeback
Applying: block: optionally snapshot page contents to provide stable pages =
during write
Applying: ocfs2: wait for page writeback to provide stable pages
Applying: ubifs: wait for page writeback to provide stable pages
Applying: mm: use vm_unmapped_area() on alpha architecture
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: smp: make smp_call_function_many() use logic similar to smp_call_=
function_single()
Applying: lib/Kconfig.debug: unhide CONFIG_PANIC_ON_OOPS
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: lib/vsprintf.c: add %pa format specifier for phys_addr_t types
Applying: get_maintainer.pl: find maintainers for removed files
Applying: MAINTAINERS: mm: add additional include files to listing
Applying: backlight: add lms501kf03 LCD driver
Applying: backlight-add-lms501kf03-lcd-driver-fix
Applying: backlight-add-lms501kf03-lcd-driver-fix-fix
Applying: backlight: ld9040: use sleep instead of delay
Applying: backlight: ld9040: remove unnecessary NULL deference check
Applying: backlight: ld9040: replace EFAULT with EINVAL
Applying: backlight: ld9040: remove redundant return variables
Applying: backlight: ld9040: reorder inclusions of <linux/xxx.h>
Applying: backlight: s6e63m0: use lowercase names of structs
Applying: backlight: s6e63m0: use sleep instead of delay
Applying: backlight: s6e63m0: remove unnecessary NULL deference check
Applying: backlight: s6e63m0: replace EFAULT with EINVAL
Applying: backlight: s6e63m0: remove redundant variable 'before_power'
Applying: backlight: s6e63m0: reorder inclusions of <linux/xxx.h>
Applying: backlight: ams369fg06: use sleep instead of delay
Applying: backlight: ams369fg06: remove unnecessary NULL deference check
Applying: backlight: ams369fg06: replace EFAULT with EINVAL
Applying: backlight: ams369fg06: remove redundant variable 'before_power'
Applying: backlight: ams369fg06: reorder inclusions of <linux/xxx.h>
Applying: backlight: add new lp8788 backlight driver
Applying: backlight-add-new-lp8788-backlight-driver-checkpatch-fixes
Applying: backlight: l4f00242t03: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: ld9040: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: s6e63m0: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: ltv350qv: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: tdo24m: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: lms283gf05: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: ams369fg06: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: vgg2432a4: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: tosa: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: corgi_lcd: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: lms501kf03: use spi_get_drvdata and spi_set_drvdata
Applying: backlight: aat2870: use bl_get_data instead of dev_get_drvdata
Applying: pwm_backlight: use bl_get_data instead of dev_get_drvdata
Applying: backlight: ams369fg06: use bl_get_data instead of dev_get_drvdata
Applying: backlight: corgi_lcd: use bl_get_data instead of dev_get_drvdata
Applying: backlight: tosa: use bl_get_data instead of dev_get_drvdata
Applying: backlight: omap1: use bl_get_data instead of dev_get_drvdata
Applying: backlight: corgi_lcd: use lcd_get_data instead of dev_get_drvdata
Applying: drivers/video/backlight/lm3639_bl.c: remove ret =3D -EIO at error=
 paths of probe
Applying: drivers/video/backlight/l4f00242t03.c: convert to devm_regulator_=
get()
Applying: drivers/video/backlight/ld9040.c: use devm_regulator_bulk_get() A=
PI
Applying: fb: backlight: add the Himax HX-8357B LCD controller
Applying: drivers/video/backlight/Makefile: cleanup
Applying: backlight: add an AS3711 PMIC backlight driver
Applying: backlight: as3711: fix compilation breakage
Applying: drivers/video/backlight/88pm860x_bl.c: add missing of_node_put()
Applying: drivers/video/backlight/s6e63m0.c: report ->gamma_table_count cor=
rectly
Applying: drivers/video/backlight/lm3630_bl.c: remove ret =3D -EIO of lm363=
0_backlight_register()
Applying: drivers/leds/leds-ot200.c: fix error caused by shifted mask
Applying: lib/parser.c: fix up comments for valid return values from match_=
number
Applying: decompressors: group XZ_DEC_* symbols under an if XZ_BCJ / endif
Applying: decompressors: drop dependency on CONFIG_EXPERT
Applying: decompressors: make the default XZ_DEC_* config match the selecte=
d architecture
Applying: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>
Applying: checkpatch: warn on unnecessary __dev<foo> section markings
Applying: checkpatch: add Joe to MAINTAINERS
Applying: checkpatch: don't emit the CamelCase warning for PageFoo
Applying: checkpatch: Add check for kcalloc argument order
Applying: checkpatch: fix USLEEP_RANGE test
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: binfmt_elf: remove unused argument in fill_elf_header
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
Applying: kernel/nsproxy.c: remove duplicate task_cred_xxx for user_ns
Applying: drivers/rtc: dump small buffers via %*ph
Applying: drivers/rtc/rtc-pxa.c: fix alarm not match issue
Applying: drivers/rtc/rtc-pxa.c: fix alarm can't wake up system issue
Applying: drivers/rtc/rtc-pxa.c: fix set time sync time issue
Applying: drivers-rtc-rtc-pxac-fix-set-time-sync-time-issue-fix
Applying: drivers/rtc/rtc-ds1307.c: long block operations bugfix
Applying: rtc-ds1307-long-block-operations-bugfix-fix
Applying: rtc: max77686: add Maxim 77686 driver
Applying: rtc-max77686-add-maxim-77686-driver-fix
Applying: rtc-pcf8523: add low battery voltage support
Applying: rtc-pcf8523-add-low-battery-voltage-support-fix
Applying: drivers/rtc: use of_match_ptr() macro
Applying: drivers/rtc/rtc-twl: use of_match_ptr() macro
Applying: drivers/rtc/rtc-pxa.c: avoid cpuid checking
Applying: drivers/rtc: remove unnecessary semicolons
Applying: drivers/rtc/rtc-ds2404.c: use module_platform_driver macro
Applying: rtc: add new lp8788 rtc driver
Applying: rtc: add RTC driver for TPS80031/TPS80032
Applying: rtc-add-rtc-driver-for-tps80031-tps80032-v2
Applying: rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix
Applying: drivers/rtc/rtc-tps65910.c: enable/disable wake in suspend/resume
Applying: drivers/rtc/rtc-tps65910.c: remove unnecessary irq stat save and =
restore
Applying: drivers/rtc/rtc-tps65910.c: use sleep_pm_ops macro for initialisi=
ng suspend/resume callbacks
Applying: drivers/rtc/rtc-tps65910.c: set irq flag to IRQF_EARLY_RESUME dur=
ing irq request
Applying: rtc: add support for spi rtc rx4581
Applying: rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes
Applying: rtc rx4581: change err type from unsigned char to int in get_date=
time()
Applying: drivers/rtc/rtc-pl031.c: add wakeup support
Applying: arm: mvebu: add RTC support for Armada 370 and Armada XP
Applying: arm: mvebu: update defconfig with Marvell RTC support
Applying: drivers/rtc/rtc-s3c.c: use dev_dbg() instaed of pr_debug()
Applying: hfsplus: add osx.* prefix for handling namespace of Mac OS X exte=
nded attributes
Applying: hfsplus: add on-disk layout declarations related to attributes tr=
ee
Applying: hfsplus: add functionality of manipulating by records in attribut=
es tree
Applying: hfsplus: rework functionality of getting, setting and deleting of=
 extended attributes
Applying: hfsplus: add support of manipulation by attributes file
Applying: fat: add extended fileds to struct fat_boot_sector
Applying: fat: mark fs as dirty on mount and clean on umount
Applying: fat: eliminate iterations in fat_search_long and __fat_readdir in=
 case of EOD
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: Documentation/cgroups/blkio-controller.txt: fix typo
Applying: signal: allow to send any siginfo to itself
Applying: signal-allow-to-send-any-siginfo-to-itself-fix
Applying: signalfd: add ability to return siginfo in a raw format
Applying: signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix
Applying: coredump: remove redundant defines for dumpable states
Applying: fs/proc: clean up printks
Applying: fs-proc-clean-up-printks-fix
Applying: seq-file: use SEEK_ macros instead of hardcoded numbers
Applying: fs/seq_file.c:seq_lseek(): fix switch statement indenting
Applying: fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-=
fixes
Applying: fork: unshare: remove dead code
Applying: fs/exec.c: make bprm_mm_init() static
Applying: kexec: add the values related to buddy system for filtering free =
pages.
Applying: kexec: get rid of duplicate check for hole_end
Applying: block: fix ext_devt_idr handling
Applying: idr: fix a subtle bug in idr_get_next()
Applying: idr: make idr_destroy() imply idr_remove_all()
Applying: atm/nicstar: don't use idr_remove_all()
Applying: block/loop: don't use idr_remove_all()
Applying: firewire: don't use idr_remove_all()
Applying: drm: don't use idr_remove_all()
Applying: dm: don't use idr_remove_all()
Applying: remoteproc: don't use idr_remove_all()
Applying: rpmsg: don't use idr_remove_all()
Applying: dlm: use idr_for_each_entry() in recover_idr_clear() error path
Applying: dlm: don't use idr_remove_all()
Applying: nfs: idr_destroy() no longer needs idr_remove_all()
Applying: inotify: don't use idr_remove_all()
Applying: cgroup: don't use idr_remove_all()
Applying: nfsd: idr_destroy() no longer needs idr_remove_all()
Applying: idr: deprecate idr_remove_all()
Applying: idr: cosmetic updates to struct / initializer definitions
Applying: idr: relocate idr_for_each_entry() and reorganize id[r|a]_get_new=
()
Applying: idr: remove _idr_rc_to_errno() hack
Applying: idr: refactor idr_get_new_above()
Applying: idr: implement idr_preload[_end]() and idr_alloc()
Applying: block: fix synchronization and limit check in blk_alloc_devt()
Applying: block: convert to idr_alloc()
Applying: block/loop: convert to idr_alloc()
Applying: atm/nicstar: convert to idr_alloc()
Applying: drbd: convert to idr_alloc()
Applying: dca: convert to idr_alloc()
Applying: dmaengine: convert to idr_alloc()
Applying: firewire: add minor number range check to fw_device_init()
Applying: firewire: convert to idr_alloc()
Applying: gpio: convert to idr_alloc()
Applying: drm: convert to idr_alloc()
Applying: drm/exynos: convert to idr_alloc()
Applying: drm/i915: convert to idr_alloc()
Applying: drm/sis: convert to idr_alloc()
Applying: drm/via: convert to idr_alloc()
Applying: drm/vmwgfx: convert to idr_alloc()
Applying: i2c: convert to idr_alloc()
Applying: IB/core: convert to idr_alloc()
Applying: IB/amso1100: convert to idr_alloc()
Applying: IB/cxgb3: convert to idr_alloc()
Applying: IB/cxgb4: convert to idr_alloc()
Applying: IB/ehca: convert to idr_alloc()
Applying: IB/ipath: convert to idr_alloc()
Applying: IB/mlx4: convert to idr_alloc()
Applying: IB/ocrdma: convert to idr_alloc()
Applying: IB/qib: convert to idr_alloc()
Applying: dm: convert to idr_alloc()
Applying: memstick: convert to idr_alloc()
Applying: mfd: convert to idr_alloc()
Applying: misc/c2port: convert to idr_alloc()
Applying: misc/tifm_core: convert to idr_alloc()
Applying: mmc: convert to idr_alloc()
Applying: mtd: convert to idr_alloc()
Applying: macvtap: convert to idr_alloc()
Applying: ppp: convert to idr_alloc()
Applying: power: convert to idr_alloc()
Applying: pps: convert to idr_alloc()
Applying: remoteproc: convert to idr_alloc()
Applying: rpmsg: convert to idr_alloc()
Applying: scsi/bfa: convert to idr_alloc()
Applying: scsi: convert to idr_alloc()
Applying: target/iscsi: convert to idr_alloc()
Applying: scsi/lpfc: convert to idr_alloc()
Applying: thermal: convert to idr_alloc()
Applying: uio: convert to idr_alloc()
Applying: vfio: convert to idr_alloc()
Applying: dlm: convert to idr_alloc()
Applying: inotify: convert to idr_alloc()
Applying: ocfs2: convert to idr_alloc()
Applying: ipc: convert to idr_alloc()
Applying: cgroup: convert to idr_alloc()
Applying: events: convert to idr_alloc()
Applying: posix-timers: convert to idr_alloc()
Applying: net/9p: convert to idr_alloc()
Applying: mac80211: convert to idr_alloc()
Applying: sctp: convert to idr_alloc()
Applying: nfs4client: convert to idr_alloc()
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipmi: remove superfluous kernel/userspace explanation
Applying: ipmi: add new kernel options to prevent automatic ipmi init
Applying: ipmi: add options to disable openfirmware and PCI scanning
Applying: drivers/char/misc.c:misc_register(): do not loop on misc_list unc=
onditionally
Applying: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-uncondi=
tionally-fix
Applying: block/partition/msdos: detect AIX formatted disks even without 55=
aa
Applying: sysctl: fix null checking in bin_dn_node_address()
Applying: kernel/utsname_sysctl.c: put get/get_uts() into CONFIG_PROC_SYSCT=
L code block
Applying: kernel/utsname.c: fix wrong comment about clone_uts_ns()
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: include/linux/eventfd.h: fix incorrect filename is a comment
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Applying: w1: add support for DS2413 Dual Channel Addressable Switch
Applying: ocfs2: fix possible use-after-free with AIO
Applying: fs/direct-io.c: fix possible use-after-free with AIO
Applying: mm: remove old aio use_mm() comment
Applying: aio: remove dead code from aio.h
Applying: gadget: remove only user of aio retry
Applying: aio: remove retry-based AIO
Applying: char: add aio_{read,write} to /dev/{null,zero}
Applying: aio: kill return value of aio_complete()
Applying: aio: add kiocb_cancel()
Applying: aio-kiocb_cancel-fix
Applying: aio: move private stuff out of aio.h
Applying: aio: dprintk() -> pr_debug()
Applying: aio: do fget() after aio_get_req()
Applying: aio: make aio_put_req() lockless
Applying: aio: refcounting cleanup
Applying: wait: add wait_event_hrtimeout()
Applying: wait-add-wait_event_hrtimeout-fix
Applying: aio: make aio_read_evt() more efficient, convert to hrtimers
Applying: aio: use flush_dcache_page()
Applying: aio: use cancellation list lazily
Applying: aio-use-cancellation-list-lazily-fix
Applying: aio-use-cancellation-list-lazily-fix-fix
Applying: aio: change reqs_active to include unreaped completions
Applying: aio: kill batch allocation
Applying: aio: kill struct aio_ring_info
Applying: aio: give shared kioctx fields their own cachelines
Applying: aio-give-shared-kioctx-fields-their-own-cachelines-fix
Applying: aio: reqs_active -> reqs_available
Applying: aio: percpu reqs_available
Applying: generic dynamic per cpu refcounting
Applying: generic-dynamic-per-cpu-refcounting-fix
Applying: percpu-refcount: sparse fixes
Applying: generic-dynamic-per-cpu-refcounting-sparse-fixes-fix
Applying: generic-dynamic-per-cpu-refcounting-doc
Applying: generic-dynamic-per-cpu-refcounting-doc-fix
Applying: aio: percpu ioctx refcount
Applying: aio: use xchg() instead of completion_lock
Applying: aio: don't include aio.h in sched.h
Applying: aio-dont-include-aioh-in-schedh-fix
Applying: aio-dont-include-aioh-in-schedh-fix-fix
Applying: aio-dont-include-aioh-in-schedh-fix-3
Applying: aio-dont-include-aioh-in-schedh-fix-3-fix
Applying: aio-dont-include-aioh-in-schedh-fix-3-fix-fix
Applying: aio: kill ki_key
Applying: aio: kill ki_retry
Applying: aio-kill-ki_retry-fix
Applying: aio-kill-ki_retry-fix-fix
Applying: block, aio: batch completion for bios/kiocbs
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
Applying: Fix build error due to bio_endio_batch
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
Applying: aio: Fix a null pointer deref in batch_complete_aio
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: fix aio_read_events_ring() types
Applying: aio: document, clarify aio_read_events() and shadow_tail
Applying: kfifo: move kfifo.c from kernel/ to lib/
Applying: kfifo: fix kfifo_alloc() and kfifo_init()
Applying: hlist: drop the node parameter from iterators
Applying: hlist-drop-the-node-parameter-from-iterators-fix
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix
Applying: hlist-drop-the-node-parameter-from-iterators-fix-fix-fix
Applying: idr: implement idr_preload[_end]() and idr_alloc()
Applying: i2c-convert-to-idr_alloc-fix
Applying: ipc-convert-to-idr_alloc-fix
Applying: net/mlx4_en: fix up for hlist_for_each_entry_rcu API change
Applying: net/mlx4_en: second fix up for hlist_for_each_entry_rcu API change
Merging akpm/master (dad99cd net/mlx4_en: second fix up for hlist_for_each_=
entry_rcu API change)

--Signature=_Tue__12_Feb_2013_16_09_53_+1100_HAzIJpWhzYilXm2O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGc6hAAoJEECxmPOUX5FERKsP/iYY6nWORpPanyi+5itI/q2M
MdqaySgAIwZyYBstw7UtlvyyeMlII4+UZNdt6y3haEmWcBGGzE62GLmhnJ6irbGQ
EQUC+shUSrd80sCv7aJXFlxBWqsnSG+ymENs2IR1lmpV7zgQon2WMJdjzVP6TdtJ
tXRJ4SMSWYFFIxvfGgvM1+HV8xLLqDIfEWmKrSiIY2XdcSm2cdoIWAAqZMy+iH8E
xVFiy+qOSS8CT1eMBj7PTpNM6YXpekYHEzIJAcjZG6f+qhkOh0/etLV3PbAIn842
cM0NvgVy4qvhF48hbgbh9gPjJWinFEP1QfmEIsoGc46mLN7LPuucP4X5DkGh1bo/
Z4EG24ZeGC3QiRRNQ2pm7FH6G028xg968cfUikhdBakdpHOKAT4nDKi+0XlLY7OI
RN+KSYO2i+os68YZjTQbwqherVGnvTivmzXqkEw0M4F/fvwpfCd89b6kc836jY4R
YId31A0c07ok2Ks0HEpdYPvLCOAS7ySOr1HcqjcsGNy/IDgquFWbmPDVcIuJSV8G
x0LijXWx2uSVp+XzaQFfVDPwqmdFqW7EjpshI0orheXJXUUjyMteXSUxXCGjlCZ+
d+NrYmirmhQvqAXVER/5j9/R/21g93ab1Fnf/uOeQ5Zz9IaqkOraq8xgBpyTpDJM
A+3QYv8vUjPewAgjTpH8
=yZKM
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_16_09_53_+1100_HAzIJpWhzYilXm2O--
