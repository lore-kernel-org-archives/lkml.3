Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3A1NGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:06:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46445 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3A1NGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:06:19 -0500
Date: Tue, 29 Jan 2013 00:06:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 28
Message-Id: <20130129000610.22f0ebd13431c59c5dc8cf3d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Jan_2013_00_06_10_+1100_nKEA7h.NX7+5V8Ce"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jan_2013_00_06_10_+1100_nKEA7h.NX7+5V8Ce
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The linux-next release may be a bit sporadic over the next few days as I
attend linux.conf.au.

Changes since 20130125:

The powerpc tree still had a build failure.

The sound-asoc tree lost its build failure.

The tty tree gained a conflict against the input tree.

The usb tree gained conflicts against the tty and driver-core trees and a
build failure so I used the version from next-20130125.

The char-misc tree gained a conflict against the sound-asoc tree.

The akpm tree gained a conflict against the tip tree.

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

We are up to 213 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (949db15 Linux 3.8-rc5)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arm-current/fixes (210b184 Merge branch 'for-rmk/virt/hyp-boot/fixe=
s' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fixes)
Merging m68k-current/for-linus (91a420e xtensa: Provide dummy dma_mmap_cohe=
rent() and dma_get_sgtable())
Merging powerpc-merge/merge (e6449c9 powerpc: Add missing NULL terminator t=
o avoid boot panic on PPC40x)
Merging sparc/master (04cef49 sparc: kernel/sbus.c: fix memory leakage)
Merging net/master (1591ab6 Merge branch 'for-davem' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (5d0feaf r8169: remove the obsolete and incorrect AMD =
workaround)
Merging sound-current/for-linus (d56268f ALSA: usb-audio: fix invalid lengt=
h check for RME and other UAC 2 devices)
Merging pci-current/for-linus (444ee9b PCI: remove depends on CONFIG_EXPERI=
MENTAL)
Merging wireless/master (83f0c6d mwifiex: fix typo in PCIe adapter NULL che=
ck)
Merging driver-core.current/driver-core-linus (7d1f9ae Linux 3.8-rc4)
Merging tty.current/tty-linus (949db15 Linux 3.8-rc5)
Merging usb.current/usb-linus (ee74290 USB: EHCI: fix timer bug affecting p=
ort resume)
Merging staging.current/staging-linus (949db15 Linux 3.8-rc5)
Merging char-misc.current/char-misc-linus (949db15 Linux 3.8-rc5)
Merging input-current/for-linus (9937c02 Input: wacom - fix wacom_set_repor=
t retry logic)
Merging md-current/for-linus (a9add5d md/raid5: add blktrace calls)
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
Merging rr-fixes/fixes (b26ada9 virtio_console: Don't access uninitialized =
data.)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arm/for-next (71fc923 Merge branches 'devel-stable', 'fixes', 'misc=
' and 'mmci' into for-next)
Merging arm-perf/for-next/perf (5ef1240 Merge branches 'for-rmk/hw-breakpoi=
nt' and 'for-rmk/perf' into for-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (42ead3a arm: zynq: timer: Set clock_event cpumask)
Merging arm64/upstream (2475ff9 arm64: Add simple earlyprintk support)
Merging blackfin/for-linus (86794b4 blackfin: SEC: clean up SEC interrupt i=
nitialization)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (77c8006 UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (79b678e Merge branch 'pstore' into next)
Merging m68k/for-next (6f4855c swim: Add missing spinlock init)
Merging m68knommu/for-next (531012f m68k: fix conditional use of init_point=
er_table)
Merging microblaze/next (e232e2d microblaze: Add .gitignore entries for aut=
o-generated files)
Merging mips/mips-for-linux-next (e0c476d Merge branch 'current/for-linus' =
into mips-for-linux-next)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (7139bc1 [PARISC] Purge existing TLB entries in set=
_pte_at and ptep_set_wrprotect)
Merging powerpc/next (b9818c3 powerpc: Rename set_break to avoid naming con=
flict)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (f4ef345 mpc5121: don't check PSC ac97 using node name)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (112b9e1 s390/zcore: Add hsa file)
Merging sh/sh-latest (035688d sh: ecovec: add sample amixer settings)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (2714b26 tile: select HAVE_SYSCALL_TRACEPOINTS)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0ed93fe xtensa: avoid mmap cache aliasing)
Merging btrfs/next (fb8ec37 Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into linus-merge)
Merging ceph/master (0fa6ebc libceph: fix protocol feature mismatch failure=
 path)
Merging cifs/for-next (949db15 Linux 3.8-rc5)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (111d61a eCryptfs: Fix -Wmissing-prototypes warnings)
Merging ext3/for_next (9734c97 udf: Write LVID to disk after opening / clos=
ing)
Merging ext4/dev (a16d024 ext4: fix memory leak when quota options are spec=
ified multiple times)
Merging f2fs/dev (7745a17 f2fs: cover global locks for reserve_new_block)
Merging fuse/for-next (fb05f41 fuse: cleanup fuse_direct_io())
Merging gfs2/master (1a96a7c GFS2: Clean up freeze code)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (b719f43 Merge tag 'hwmon-for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/groeck/linux-staging)
Merging nfsd/nfsd-next (ff89be8 nfsd4: require version 4 when enabling or d=
isabling minorversion)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (3d59eeb Merge tag 'balancenuma-v11' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma)
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (ced55f3 xfs: Fix possible use-after-free with AIO)
CONFLICT (content): Merge conflict in fs/xfs/xfs_buf_item.c
Merging vfs/for-next (3a142ed Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/signal)
Merging pci/next (939de1d Merge branch 'pci/yinghai-root-bus-hotplug' into =
next)
CONFLICT (content): Merge conflict in arch/ia64/pci/pci.c
Merging hid/for-next (1ac51b8 Merge branch 'for-3.9/sony' into for-next)
CONFLICT (content): Merge conflict in drivers/hid/i2c-hid/i2c-hid.c
Merging i2c-embedded/i2c-embedded/for-next (9dd3162 i2c-designware: add mis=
sing MODULE_LICENSE)
Merging jdelvare-hwmon/master (54e37b8 Merge tag 'vfio-for-v3.8-v2' of git:=
//github.com/awilliam/linux-vfio)
Merging hwmon-staging/hwmon-next (af11918 hwmon: Driver for Texas Instrumen=
ts INA209)
Merging v4l-dvb/master (acbcb07 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (5c9e411 Merge branches 'kbuild/kbuild' and 'kbuild=
/kconfig' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (44ec657 [SCSI] remove can_power_off flag from scsi_dev=
ice)
Merging infiniband/for-next (d72623b Merge branches 'cxgb4', 'ipoib' and 'm=
lx4' into for-next)
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging pm/linux-next (0b9d032 Merge branch 'pm-cpufreq-next' into linux-ne=
xt)
Merging acpi/next (61dc7fc tools/power turbostat: fix build error due to ua=
pi changes)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (e6b438e PM: Introduce Intel PowerClamp Driver)
CONFLICT (content): Merge conflict in drivers/thermal/exynos_thermal.c
Merging ieee1394/for-next (db2cad2 firewire: net: remove unused variable in=
 fwnet_receive_broadcast())
Merging ubi/linux-next (eab7377 UBI: embed ubi_debug_info field in ubi_devi=
ce struct)
Merging dlm/next (f117228 dlm: avoid scanning unchanged toss lists)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging scsi/for-next (e3ff197 [SCSI] mpt3sas: remove unused variables)
Applying: ipr: remove new __dev* annotations
Merging target-updates/for-next (2c623c3 target: change sprintf to snprintf=
 in transport_dump_vpd_ident)
Merging target-merge/for-next-merge (d1c3ed6 Linux 3.8-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (6c5e6a3 Merge tag 'ux500-dma40' of //git.linaro.org=
/people/fabiobaltieri/linux.git)
CONFLICT (content): Merge conflict in drivers/dma/tegra20-apb-dma.c
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (031554e Merge branch 'master' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jkirsher/net-next)
CONFLICT (content): Merge conflict in arch/mips/include/uapi/asm/socket.h
Merging ipsec-next/master (93b9c1d Merge branch 'testing' of git://git.kern=
el.org/pub/scm/linux/kernel/git/klassert/ipsec-next)
Merging wireless-next/master (c5e818e ath9k_hw: remove a useless WARN_ON)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/dvm/tx.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/main.c
Merging bluetooth/master (9b008c0 Bluetooth: Add support for reading LE sup=
ported states)
Merging mtd/master (bf65aaa mtd: docg3 fix missing bitreverse lib)
Merging l2-mtd/master (5cc4747 mtd: Allow removal of partitioning modules)
Merging crypto/master (7983627 crypto: crc32-pclmul - Kill warning on x86-3=
2)
Merging drm/drm-next (735dc0d Merge branch 'drm-kms-locking' of git://peopl=
e.freedesktop.org/~danvet/drm-intel into drm-next)
Merging sound/for-next (86b2723 ALSA: Make snd_printd() and snd_printdd() i=
nline)
Merging sound-asoc/for-next (3d47748 Merge remote-tracking branch 'asoc/top=
ic/wm8993' into asoc-next)
Merging modules/modules-next (d9d8d7e MODSIGN: Add option to not sign modul=
es during modules_install)
Merging pekey/devel-pekey (736c71b PEFILE: Load the contained key if we con=
sider the container to be validly signed)
Merging virtio/virtio-next (1f80518 virtio_console: Let unconnected rproc d=
evice receive data.)
Merging input/next (21fb9f0 Input: twl6040-vibra - use system workqueue)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (6503605 Merge branch 'for-3.8-fixes' into for-next)
Merging block/for-next (c83dcb9 Merge branch 'for-3.9/core' into for-next)
Merging device-mapper/master (aa2b4e2 This patch takes advantage of the new=
 bio-prison interface where the memory is now passed in rather than using a=
 mempool in bio-prison. This allows the map function to avoid performing po=
tentially-blocking allocations that could lead to deadlocks: We want to avo=
id the cell allocation that is done in bio_detain.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (3f175a6 mmc: sdhci-esdhc-imx: remove ESDHC_CD_GPIO ha=
ndling from IO accessory)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (ce343df Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (9b80ac9 raid5: create multiple threads to handle strip=
es)
Merging mfd/for-next (d9fddb2 rtc: palmas: Add RTC driver Palmas series PMI=
C)
Merging battery/master (8fd526f qnap-poweroff: Fix license string)
CONFLICT (content): Merge conflict in drivers/power/ab8500_bmdata.c
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (b1e905e Merge remote-tracking branch 'regulator=
/topic/tps6507x' into regulator-next)
Merging security/next (a175b8b ima: forbid write access to files with digit=
al signatures)
CONFLICT (content): Merge conflict in security/integrity/ima/ima_main.c
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (604a008 Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (097e363 iommu: moving initialization earlier)
Merging vfio/next (ec1287e vfio-pci: Fix buffer overfill)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (5c8d1b6 time: x86: report_lost_ticks doesn't exis=
t any more)
CONFLICT (content): Merge conflict in drivers/devfreq/exynos4_bus.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/octeon/cvmx-hel=
per-util.h
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/executive/cvm=
x-helper-util.c
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (1c06910 i7core_edac: fix kernel crash on unloading=
 i7core_edac.)
Merging edac-amd/for-next (0f08669 EDAC, MCE, AMD: Remove unneeded exports)
Merging devicetree/devicetree/next (93c667c of: *node argument to of_parse_=
phandle_with_args should be const)
Merging dt-rh/for-next (425140a of: Add vendor prefix for Cirrus Logic)
Merging spi/spi/next (7cb9436 spi/sparc: Allow of_register_spi_devices for =
sparc)
Merging spi-mb/spi-next (5cbc7ca spi: spi-omap2-mcspi.c: Toggle CS after ea=
ch word)
Merging tip/auto-latest (ec4add7 Merge branch 'sched/core')
Merging ftrace/for-next (d41032a tracing: Fix unsigned int compare of zero =
in recursion check)
Merging rcu/rcu/next (ad70b6d rcu: Make rcu_accelerate_cbs() note need for =
future grace periods)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (3f0c3d0 KVM: x86 emulator: fix test_cc() build fail=
ure on i386)
CONFLICT (content): Merge conflict in arch/s390/kernel/irq.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/irq.h
Applying: KVM: s390: fix for IOINT_VIR name change
Merging kvm-ppc/kvm-ppc-next (b9e3e20 KVM: PPC: E500: Remove kvmppc_e500_tl=
bil_all usage from guest TLB code)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (f69c160 Merge tag 'v3.8-rc5' into linux-next)
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (26c3d00 Merge branch 'for-3.9-cleanups' into f=
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
Merging regmap/for-next (6a36a99 Merge remote-tracking branch 'regmap/topic=
/no-bus' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (4ec3365 leds-lp5521/3: use '%zu' for formatting 'siz=
e_t')
Merging driver-core/driver-core-next (422d26b Merge 3.8-rc5 into driver-cor=
e-next)
CONFLICT (content): Merge conflict in drivers/spi/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/seeq/Kconfig
CONFLICT (modify/delete): drivers/net/ethernet/racal/Kconfig deleted in HEA=
D and modified in driver-core/driver-core-next. Version driver-core/driver-=
core-next of drivers/net/ethernet/racal/Kconfig left in tree.
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/i825xx/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/fujitsu/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/8390/Kconfig
CONFLICT (content): Merge conflict in drivers/dma/dw_dmac.c
$ git rm -f drivers/net/ethernet/racal/Kconfig
Merging tty/tty-next (9f9cba8 Merge 3.8-rc5 into tty-next)
CONFLICT (content): Merge conflict in drivers/net/wan/Kconfig
CONFLICT (content): Merge conflict in drivers/lguest/Kconfig
CONFLICT (content): Merge conflict in drivers/input/keyboard/Kconfig
CONFLICT (content): Merge conflict in drivers/i2c/busses/Kconfig
Merging usb/usb-next (67635d3 Merge 3.8-rc5 into usb-next)
CONFLICT (content): Merge conflict in drivers/usb/phy/omap-usb2.c
CONFLICT (content): Merge conflict in drivers/usb/musb/omap2430.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/Kconfig
$ git reset --hard HEAD^
Merging 20130125 version of usb
CONFLICT (content): Merge conflict in drivers/usb/serial/io_ti.c
[master 81c2d93] 20130125/usb
Merging staging/staging-next (8f5f90a Merge 3.8-rc5 into staging-next)
CONFLICT (content): Merge conflict in drivers/staging/et131x/et131x.c
Merging char-misc/char-misc-next (7479014 Merge 3.8-rc5 into char-misc-next)
CONFLICT (content): Merge conflict in include/linux/mfd/arizona/pdata.h
CONFLICT (content): Merge conflict in drivers/ipack/devices/ipoctal.c
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (ed84825 Negative (setpoint-dirty) in =
bdi_position_ratio())
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (f8cac8a Merge branch 'allwinner-sunxi' into for-n=
ext)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-nomadik.c
CONFLICT (content): Merge conflict in drivers/gpio/Kconfig
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (fc13d5a gpio: Provide the STMPE GPIO driver with it=
s own IRQ Domain)
Merging gpio-lw/for-next (efebbab Merge branch 'devel' into for-next)
Merging arm-soc/for-next (19d23da Merge branch 'fixes' into for-next)
CONFLICT (content): Merge conflict in drivers/crypto/omap-sham.c
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear6xx/spear6xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear3xx/spear3xx.c
CONFLICT (content): Merge conflict in arch/arm/mach-spear13xx/spear1340.c
Merging bcm2835/for-next (5c9dd2d Merge branch 'for-3.9/defconfig' into for=
-next)
Merging cortex/for-next (2f0e7ab Cortex-M3: Add support for exception handl=
ing)
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (db5ec95 Merge branches 'heads/defconfig2', 'heads/boa=
rds', 'boards-kzm9g-reference', 'heads/soc', 'heads/pfc' and 'heads/intc-of=
' into next)
CONFLICT (content): Merge conflict in arch/arm/mach-bcm/board_bcm.c
Merging samsung/for-next (431f7d6 Merge branch 'next/fixes-samsung' into fo=
r-next)
CONFLICT (content): Merge conflict in drivers/gpio/gpio-samsung.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/dma.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/mach-exynos4-dt.c
CONFLICT (content): Merge conflict in arch/arm/common/Makefile
Merging tegra/for-next (fce9e07 Merge branch 'for-3.9/defconfig' into for-n=
ext)
CONFLICT (content): Merge conflict in drivers/clocksource/Makefile
CONFLICT (content): Merge conflict in drivers/clk/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/platsmp.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/common.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/board-dt-tegra30.c
CONFLICT (content): Merge conflict in arch/arm/mach-tegra/board-dt-tegra20.c
Merging kvmtool/master (6cb6828 kvm tools: Clean up NULL check in pci_shmem=
__init())
Merging dma-mapping/dma-mapping-next (41b8d1e ARM: iommu: Include linux/kre=
f.h in asm/dma-iommu.h)
Merging pwm/for-next (0d75c20 pwm: pwm-tiecap: Low power sleep support)
Merging dma-buf/for-next (90b6e90 dma-buf: implement vmap refcounting in th=
e interface logic)
Merging userns/for-next (2b8576c userns: Allow the userns root to mount tmp=
fs.)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (115a1dc x86: convert to ksignal)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/syscall.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal_n32.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal32.c
CONFLICT (content): Merge conflict in arch/mips/kernel/signal.c
CONFLICT (content): Merge conflict in arch/mips/kernel/scall64-o32.S
CONFLICT (content): Merge conflict in arch/mips/kernel/process.c
CONFLICT (content): Merge conflict in arch/mips/kernel/linux32.c
CONFLICT (content): Merge conflict in arch/mips/Kconfig
Merging clk/clk-next (1a3cd18 clk-divider: fix macros)
Merging random/dev (6133705 random: Mix cputime from each thread that exits=
 to the pool)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (ff027be fb: Yet another band-aid for fixing l=
ockdep mess)
$ git checkout akpm
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
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: Revert "x86, mm: Make spurious_fault check explicitly check the P=
RESENT bit"
Applying: pageattr: prevent PSE and GLOABL leftovers to confuse pmd/pte_pre=
sent and pmd_huge
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: cris: Use "int" for ssize_t to match size_t
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: timer_list: split timer_list_show_tickdevices()
Applying: timer_list: convert timer list to be a proper seq_file
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix
Applying: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix
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
Applying: mm: make madvise(MADV_WILLNEED) support swap file prefetch
Applying: mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix
Applying: mm: fix BUG on madvise early failure
Applying: mm: compaction: make __compact_pgdat() and compact_pgdat() return=
 void
Applying: mm: avoid calling pgdat_balanced() needlessly
Applying: mm: make mlockall preserve flags other than VM_LOCKED in def_flags
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
CONFLICT (content): Merge conflict in arch/x86/include/asm/pgtable_types.h
Applying: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix
Applying: Bug fix: Do not calculate direct mapping pages when freeing vmemm=
ap pagetables.
Applying: Bug fix: Do not free direct mapping pages twice.
Applying: Bug fix: Do not free page split from hugepage one by one.
Applying: Bug fix: Do not split pages when freeing pagetable pages.
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
Applying: memory-hotplug: consider compound pages when free memmap
Applying: mempolicy: fix is_valid_nodemask()
Applying: cpu_hotplug: clear apicid to node when the cpu is hotremoved
Applying: memory-hotplug: export the function try_offline_node()
Applying: cpu-hotplug, memory-hotplug: try offlining the node when hotremov=
ing a cpu
Applying: cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining th=
e node
Applying: cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-no=
de-fix
Applying: sched: do not use cpu_to_node() to find an offlined cpu's node.
Applying: mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect movab=
lecore_map in memblock_overlaps_region().
Applying: mm: don't wait on congested zones in balance_pgdat()
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
Applying: swap: add per-partition lock for swapfile
Applying: mm/rmap: rename anon_vma_unlock() =3D> anon_vma_unlock_write()
Applying: page-writeback.c: subtract min_free_kbytes from dirtyable memory
Applying: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix
Applying: page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fi=
x-fix
Applying: memcg: do not create memsw files if swap accounting is disabled
Applying: memcg: clean up swap accounting initialization code
Applying: mm: uninline page_xchg_last_nid()
Applying: mm: init: report on last-nid information stored in page->flags
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm: prevent addition of pages to swap if may_writepage is unset
Applying: bdi: allow block devices to say that they require stable page wri=
tes
Applying: mm: only enforce stable page writes if the backing device require=
s it
Applying: 9pfs: fix filesystem to wait for stable page writeback
Applying: block: optionally snapshot page contents to provide stable pages =
during write
Applying: ocfs2: wait for page writeback to provide stable pages
Applying: ubifs: wait for page writeback to provide stable pages
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: smp: make smp_call_function_many() use logic similar to smp_call_=
function_single()
CONFLICT (content): Merge conflict in kernel/smp.c
Applying: lib/Kconfig.debug: CONFIG_PANIC_ON_OOPS should be shown if DEBUG_=
KERNEL
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
CONFLICT (content): Merge conflict in kernel/smp.c
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
Applying: lib/parser.c: fix up comments for valid return values from match_=
number
Applying: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>
Applying: checkpatch: warn on unnecessary __dev<foo> section markings
Applying: checkpatch: add Joe to MAINTAINERS
Applying: checkpatch: don't emit the CamelCase warning for PageFoo
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
Applying: binfmt_elf: remove unused argument in fill_elf_header
Applying: binfmt_elf.c: use get_random_int() to fix entropy depleting
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
Applying: rtc: add support of rtc-mv for MVEBU SoCs
Applying: arm: mvebu: add RTC support for Armada 370 and Armada XP
Applying: arm: mvebu: update defconfig with Marvell RTC support
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
Applying: Documentation/DMA-API-HOWTO.txt: minor grammar corrections
Applying: Documentation/cgroups/blkio-controller.txt: fix typo
Applying: signal: allow to send any siginfo to itself
Applying: signal-allow-to-send-any-siginfo-to-itself-fix
Applying: signalfd: add ability to return siginfo in a raw format
Applying: signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix
Applying: signalfd: add ability to read siginfos without dequeuing signals
Applying: seq-file: use SEEK_ macros instead of hardcoded numbers
Applying: fs/seq_file.c:seq_lseek(): fix switch statement indenting
Applying: fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-=
fixes
Applying: fork: unshare: remove dead code
Applying: fs/exec.c: make bprm_mm_init() static
Applying: kexec: add the values related to buddy system for filtering free =
pages.
Applying: ipc/sem.c: alternatives to preempt_disable()
Applying: ipmi: remove superfluous kernel/userspace explanation
Applying: ipmi: add new kernel options to prevent automatic ipmi init
Applying: ipmi: add options to disable openfirmware and PCI scanning
Applying: drivers/char/misc.c:misc_register(): do not loop on misc_list unc=
onditionally
Applying: drivers-char-miscc-misc_register-do-not-loop-on-misc_list-uncondi=
tionally-fix
Applying: sysctl: fix null checking in bin_dn_node_address()
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Applying: w1: add support for DS2413 Dual Channel Addressable Switch
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
Applying: aio: kill ki_key
Applying: aio: kill ki_retry
Applying: aio-kill-ki_retry-fix
Applying: block, aio: batch completion for bios/kiocbs
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
Applying: Fix build error due to bio_endio_batch
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix
Applying: virtio-blk: convert to batch completion
Applying: mtip32xx: convert to batch completion
Applying: aio: smoosh struct kiocb
Applying: aio-smoosh-struct-kiocb-fix
Applying: aio: fix aio_read_events_ring() types
Applying: aio: document, clarify aio_read_events() and shadow_tail
Applying: kfifo: move kfifo.c from kernel/ to lib/
Applying: kfifo: fix kfifo_alloc() and kfifo_init()
Applying: swap-add-per-partition-lock-for-swapfile-fix-fix
Merging akpm/master (d3f0fc6 swap-add-per-partition-lock-for-swapfile-fix-f=
ix)

--Signature=_Tue__29_Jan_2013_00_06_10_+1100_nKEA7h.NX7+5V8Ce
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRBnfCAAoJEECxmPOUX5FEWbYP/1zorg9M/VpBXEvZlaZZoSF8
JVopW/H7OkBxYm4x4KK5ZKMMko55Jyox+QerFGLhy4dKMMUKCMoCCEaFXNFOFnhx
KI035nZV68W9xbKnp8/+pXsYAGXIJk7odZ0LI6HMUa3ZbeFwYaTSgEZu0GblC5N7
dJyi+9aoo7iEwONuzpcXYmQYnFuCacklsLtWGQDT9vJp6PL+YUHtNGmmPEoq4VTH
kXmpJGpJ9AXQkAnUbRilfUQO7FSmGuZxPXovTrodQ27J0z/y+y+EzaxJYVKyIKNg
uVNWP4L/ybddwg5TJVnkzz71UA3PrEFFP69mFv4aY0ngOqYQhcTcUiMdiETqw0Xp
047COXvx74mSx24hfzvAtTJ/dOA1Nl2Xw+KQUbxqjmsjbNQqLWY1w6dwzIe5S+Pk
SGHDwpjarjU1PKzMaxVuCbKYt4kecqSuD9VD3OP7vabq1Ts8WtBkRnrjOAqb9TCY
BKmkPJ5Gvz/Kds1EEq+glKQd5ZrNvzAyI/gmq1jUeIo3fLqFOWq6U6iFGL63oBgr
KFsUdyeFIMLE3XqLe2fN0pL2RlAHsWasLT1QiwAIid1NGkzYENGJvkvaCkpj+1nv
k4w7oz8v/O4Sf6Hd53g4RRXuqwuP5cQGGIV4GKmR40ggolaKcSA2ieRBZ7pL+ph+
YMdmxKjLAPlcFTo+Earj
=F4UO
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jan_2013_00_06_10_+1100_nKEA7h.NX7+5V8Ce--
