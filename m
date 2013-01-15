Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3AOVAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:00:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47190 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab3AOU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:59:58 -0500
Date: Tue, 15 Jan 2013 14:37:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jan 15
Message-Id: <20130115143706.a8cad3e4eb0efb8462ab8073@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__15_Jan_2013_14_37_06_+1100_3JurewoRlBvqZjSS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jan_2013_14_37_06_+1100_3JurewoRlBvqZjSS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130114:

Dropped tree: samung (many conflicts)

The powerpc tree still had its build failures.

The pm tree lost its build failure.

The akpm tree gained a conflict against the block tree.

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

We are up to 211 trees (counting Linus' and 28 trees of patches pending
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
Merging origin/master (3152ba0 Merge tag 'dt-fixes-for-3.8' of git://source=
s.calxeda.com/kernel/linux)
Merging fixes/master (d287b87 Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/viro/vfs)
Merging kbuild-current/rc-fixes (02f3e53 Merge branch 'yem-kconfig-rc-fixes=
' of git://gitorious.org/linux-kconfig/linux-kconfig into kbuild/rc-fixes)
Merging arm-current/fixes (d106de3 ARM: 7614/1: mm: fix wrong branch from C=
ortex-A9 to PJ4b)
Merging m68k-current/for-linus (e7e29b4 m68k: Wire up finit_module)
Merging powerpc-merge/merge (e6449c9 powerpc: Add missing NULL terminator t=
o avoid boot panic on PPC40x)
Merging sparc/master (b7c13f7 sparc: remove __devinit, __devexit annotation=
s)
Merging net/master (3152ba0 Merge tag 'dt-fixes-for-3.8' of git://sources.c=
alxeda.com/kernel/linux)
Merging sound-current/for-linus (39e9515 ALSA: usb-audio: selector map for =
M-Audio FT C400)
Merging pci-current/for-linus (d712f68 Merge branch 'pci/yijing-hotplug-wor=
kqueues' into for-linus)
Merging wireless/master (4668cce ath9k: disable the tasklet before taking t=
he PCU lock)
Merging driver-core.current/driver-core-linus (f1688e0 debugfs: convert gid=
=3D argument from decimal, not octal)
Merging tty.current/tty-linus (d1c3ed6 Linux 3.8-rc2)
Merging usb.current/usb-linus (8cf65dc usb: ftdi_sio: Crucible Technologies=
 COMET Caller ID - pid added)
Merging staging.current/staging-linus (397c606 staging: zram: fix invalid m=
emory references during disk write)
Merging char-misc.current/char-misc-linus (e6028db mei: fix mismatch in mut=
ex unlock-lock in mei_amthif_read())
Merging input-current/for-linus (bec7a4b Input: lm8323 - fix checking PWM i=
nterrupt status)
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
Merging rr-fixes/fixes (52441fa module: prevent warning when finit_module a=
 0 sized file)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arm/for-next (32887f3 Merge branch 'fixes' into for-next)
Merging arm-perf/for-next/perf (711f27a Merge branch 'perf/updates' into fo=
r-next/perf)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (42ead3a arm: zynq: timer: Set clock_event cpumask)
Merging arm64/upstream (a6fadf7 arm64: mm: introduce present, faulting entr=
ies for PAGE_NONE)
Merging blackfin/for-linus (86794b4 blackfin: SEC: clean up SEC interrupt i=
nitialization)
Merging c6x/for-linux-next (93bbd0c c6x: use generic kvm_para.h)
Merging cris/for-next (77c8006 UAPI: Fix up empty files in arch/cris/)
Merging hexagon/linux-next (e1858b2 Hexagon: Copyright marking changes)
Merging ia64/next (79b678e Merge branch 'pstore' into next)
Merging m68k/for-next (6f4855c swim: Add missing spinlock init)
Merging m68knommu/for-next (d153982 m68knommu: add KMAP definitions for non=
-MMU definitions)
Merging microblaze/next (2a893f9 Merge tag 'pm+acpi-for-3.8-rc3' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging mips/mips-for-linux-next (664fb16 Merge branch 'current/for-linus' =
into mips-for-linux-next)
Merging openrisc/for-upstream (634bd40 openrisc: use kbuild.h instead of de=
fining macros in asm-offset.c)
Merging parisc/for-next (949a05d [PARISC] fix virtual aliasing issue in get=
_shared_area())
Merging powerpc/next (6138340 powerpc: Make room in exception vector area)
Applying: powerpc: rename set_break to avoid naming conflict
Applying: powerpc: Fix typo in breakpoint kgdb code.
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (9a32299 powerpc, dma: move bestcomm driver from arch/=
powerpc/sysdev to drivers/dma)
Merging galak/next (1723d90 powerpc/dma/raidengine: add raidengine device)
Merging s390/features (35b5a67 s390/modules: add relocation overflow checki=
ng)
Merging sh/sh-latest (14eae6e sh: Fix up stack debugging build.)
Merging sparc-next/master (c4271c6 NFS: Kill fscache warnings when mounting=
 without -ofsc)
Merging tile/master (548a172 arch/tile: Enable HAVE_ARCH_TRACEHOOK)
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0ed93fe xtensa: avoid mmap cache aliasing)
Merging btrfs/next (fb8ec37 Merge branch 'master' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/torvalds/linux into linus-merge)
Merging ceph/master (0fa6ebc libceph: fix protocol feature mismatch failure=
 path)
Merging cifs/for-next (2a893f9 Merge tag 'pm+acpi-for-3.8-rc3' of git://git=
.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (3702875 fs/ecryptfs/crypto.c: make ecryptfs_encode_f=
or_filename() static)
Merging ext3/for_next (1b1baff UDF: Fix a null pointer dereference in udf_s=
b_free_partitions)
Merging ext4/dev (7f51186 ext4: trigger the lazy inode table initialization=
 after resize)
Merging f2fs/dev (9eaeba7 f2fs: move f2fs_balance_fs to punch_hole)
Merging fuse/for-next (23ab0c7 cuse: do not register multiple devices with =
identical names)
Merging gfs2/master (1a96a7c GFS2: Clean up freeze code)
Merging jfs/jfs-next (9d48017 jfs: avoid undefined behavior from left-shift=
ing by 32 bits)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (b719f43 Merge tag 'hwmon-for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/groeck/linux-staging)
Merging nfsd/nfsd-next (24ffb93 nfsd4: don't leave freed stateid hashed)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (3d59eeb Merge tag 'balancenuma-v11' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma)
Merging ubifs/linux-next (a28ad42 UBIFS: fix mounting problems after power =
cuts)
Merging xfs/for-next (a17164e fs/xfs remove obsolete simple_strto<foo>)
Merging vfs/for-next (08b60f8 namei.h: include errno.h)
Merging pci/next (b704046 Merge branch 'pci/yinghai-survey-resources+acpi-s=
can' into next)
Merging hid/for-next (6ef1e89 Merge branch 'for-3.9/sony' into for-next)
Merging i2c-embedded/i2c-embedded/for-next (9931fac Linux 3.8-rc3)
Merging jdelvare-hwmon/master (54e37b8 Merge tag 'vfio-for-v3.8-v2' of git:=
//github.com/awilliam/linux-vfio)
Merging hwmon-staging/hwmon-next (8993c78 hwmon: Driver for Maxim MAX6697 a=
nd compatibles)
Merging v4l-dvb/master (acbcb07 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (252286f Merge branches 'kbuild/misc' and 'kbuild/r=
c-fixes' into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/NEXT (1757d90 libata: export host controller number thru /sy=
s)
Merging infiniband/for-next (d72623b Merge branches 'cxgb4', 'ipoib' and 'm=
lx4' into for-next)
Merging pstore/master (ebacfd1 pstore/ftrace: Adjust for ftrace_ops->func p=
rototype change)
Merging pm/linux-next (c3c65c2 Merge branch 'acpi-pm-next' into linux-next)
Merging acpi/next (61dc7fc tools/power turbostat: fix build error due to ua=
pi changes)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpuidle/cpuidle-next (d1c3ed6 Linux 3.8-rc2)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (c076fc4 thermal: db8500: Use of_match_ptr() macro in =
db8500_cpufreq_cooling.c)
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
Merging target-updates/for-next (37670c2 target: Remove never-used TMR_FABR=
IC_TMR enum value)
Merging target-merge/for-next-merge (d1c3ed6 Linux 3.8-rc2)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging slave-dma/next (3a95b9f pl080.h: moved from arm/include/asm/hardwar=
e to include/linux/amba/)
CONFLICT (content): Merge conflict in drivers/dma/tegra20-apb-dma.c
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging dmaengine/next (7f34986 dma: ipu: Drop unused spinlock)
CONFLICT (content): Merge conflict in drivers/dma/ioat/dma_v3.c
Merging net-next/master (73bf0d0 ifb: dont hard code inet_net use)
CONFLICT (content): Merge conflict in drivers/net/ethernet/broadcom/bnx2x/b=
nx2x_cmn.c
CONFLICT (content): Merge conflict in Documentation/networking/ip-sysctl.txt
Applying: qlcnic: remove new __dev* annotations
Merging wireless-next/master (660b9ca bcma: use consistent case for 'hex' c=
onstants)
Merging bluetooth/master (52e0b01 Bluetooth: Fix uuid output in debugfs)
Merging mtd/master (7a9c838 mtd: davinci_nand: fix modular build with CONFI=
G_OF=3Dy)
Merging l2-mtd/master (d4d4f1b mtd: nand: typo in nand_id_has_period() comm=
ents)
Merging crypto/master (d20fb18 crypto: omap-sham - Add SHA224 and SHA256 Su=
pport)
Merging drm/drm-next (eda85d6 drm/nouveau: fix init with agpgart-uninorth)
Merging sound/for-next (6ab3174 ALSA: hda - Allow power_save_controller opt=
ion override DCAPS)
Merging sound-asoc/for-next (124af1c Merge remote-tracking branch 'asoc/top=
ic/wm8993' into asoc-next)
Merging modules/modules-next (4a490b7 Merge branch 'drm-next' of git://peop=
le.freedesktop.org/~airlied/linux)
Merging pekey/devel-pekey (b09e984 KEYS: Add a 'trusted' flag and a 'truste=
d only' flag)
Merging virtio/virtio-next (4a490b7 Merge branch 'drm-next' of git://people=
.freedesktop.org/~airlied/linux)
Merging input/next (93d48b0 Input: tegra-kbc - remove default keymap)
Merging input-mt/for-next (6f0c058 Linux 3.7-rc2)
Merging cgroup/for-next (1ecba8f Merge branch 'for-3.9' into for-next)
Merging block/for-next (c83dcb9 Merge branch 'for-3.9/core' into for-next)
Merging device-mapper/master (412768a Rename functions involved in splittin=
g and cloning bios.)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (e352191 mmc: sdhci: introduce sdhci_update_clock help=
er to re-enable clock)
Merging kgdb/kgdb-next (58bcdf6 tty/console: fix warnings in drivers/tty/se=
rial/kgdboc.c)
Merging slab/for-next (ce343df Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (b69f085 Linux 3.7-rc8)
Merging md/for-next (50879b1 raid5: create multiple threads to handle strip=
es)
Merging mfd/for-next (1881b68 mfd: tps6507x: Convert to devm_kzalloc)
Merging battery/master (c4f3422 da9052-battery: Avoid out-of-range array ac=
cess)
CONFLICT (content): Merge conflict in drivers/power/ab8500_bmdata.c
Merging fbdev/fbdev-next (a49f0d1 Linux 3.8-rc1)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e7f5c9a Merge tag 'omapdss-for-3.8' of git://gi=
torious.org/linux-omap-dss2/linux into for-linus)
Merging regulator/for-next (dd0e4f1 Merge remote-tracking branch 'regulator=
/topic/tps51632' into regulator-next)
Merging security/next (cf9ce94 Merge tag 'v3.8-rc2' into next)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (7e27d6e Linux 2.6.35-rc3)
Merging watchdog/master (604a008 Merge branch 'master' of ../linux-watchdog)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (097e363 iommu: moving initialization earlier)
Merging vfio/next (9a92c50 vfio-pci: Enable device before attempting reset)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (92039ed of: add missing documentation for of_plat=
form_populate())
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (1c06910 i7core_edac: fix kernel crash on unloading=
 i7core_edac.)
Merging edac-amd/for-next (f7dd80d EDAC, MCE, AMD: Remove unneeded exports)
Merging devicetree/devicetree/next (93c667c of: *node argument to of_parse_=
phandle_with_args should be const)
Merging dt-rh/for-next (58fea35 arm64: Fix the dtbs target building)
Merging spi/spi/next (7cb9436 spi/sparc: Allow of_register_spi_devices for =
sparc)
Merging spi-mb/spi-next (f28037d MAINTAINERS: Add myself as a backup mainta=
iner for SPI)
Merging tip/auto-latest (c13d1ef Merge branch 'linus')
Merging ftrace/for-next (2faffc4 Merge branch 'trace/tip/perf/urgent' into =
trace/for-next)
Merging rcu/rcu/next (ec9aec2 Merge branches 'doctorture.2013.01.11a', 'fix=
es.2013.01.11a', 'idlenocb.2013.01.08b' and 'tiny.2013.01.11a' into HEAD)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (f79ed82 KVM: trace: Fix exit decoding.)
CONFLICT (content): Merge conflict in arch/s390/kernel/irq.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/irq.h
Applying: KVM: s390: fix for IOINT_VIR name change
Merging kvm-ppc/kvm-ppc-next (324b3e6 KVM: PPC: BookE: Add EPR ONE_REG sync)
Merging oprofile/for-next (4400910 oprofile, x86: Fix wrapping bug in op_x8=
6_get_ctrl())
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (9736dea Merge commit '74b84233458e9db7c160cec67=
638efdbec748ca9' into linux-next)
CONFLICT (content): Merge conflict in arch/arm/xen/enlighten.c
Merging xen-pvhvm/linux-next (b056b6a xen: suspend: remove xen_hvm_suspend)
Merging percpu/for-next (5479c78 mm, percpu: Make sure percpu_alloc early p=
arameter has an argument)
Merging workqueues/for-next (03c11b2 Merge branch 'for-3.9-cleanups' into f=
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
Merging regmap/for-next (027df64 Merge remote-tracking branch 'regmap/topic=
/24bit' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (6702e76 leds: lm3530: Ensure drvdata->enable has cor=
rect status if regulator_disable fails)
Merging driver-core/driver-core-next (9613066 Merge tag 'for-gregkh-3.9' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux into driver-core-=
next)
CONFLICT (content): Merge conflict in drivers/net/ethernet/intel/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/i825xx/Kconfig
CONFLICT (content): Merge conflict in drivers/net/ethernet/8390/Kconfig
Merging tty/tty-next (d1c3ed6 Linux 3.8-rc2)
Merging usb/usb-next (c030499 USB: ehci-mxc: remove Efika MX-specific CHRGV=
BUS hack)
Merging staging/staging-next (955e7da staging: ced1401: fix GFP_KERNEL in s=
pinlock context)
CONFLICT (content): Merge conflict in drivers/iio/adc/max1363.c
Merging char-misc/char-misc-next (8e9a4a9 mei: drop the warning when cl is =
not initialized during unlinking)
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (10ee27a vfs: re-implement writeback_i=
nodes_sb(_nr)_if_idle() and rename them)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (b208306 pinctrl: do not defer device tree hogs)
Merging vhost/linux-next (0e9ff68 vhost-blk: add eventfd dependency)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (6f0c058 Linux 3.7-rc2)
Merging irqdomain/irqdomain/next (560aa53 irqdomain: document the simple do=
main first_irq)
Merging gpio/gpio/next (fc13d5a gpio: Provide the STMPE GPIO driver with it=
s own IRQ Domain)
Merging gpio-lw/for-next (2021f8f Merge branch 'devel' into for-next)
Merging arm-soc/for-next (82fe557 Merge branch 'next/cleanup' into for-next)
CONFLICT (content): Merge conflict in drivers/crypto/omap-sham.c
CONFLICT (content): Merge conflict in arch/arm/mach-zynq/common.c
Merging bcm2835/for-next (5c9dd2d Merge branch 'for-3.9/defconfig' into for=
-next)
Merging cortex/for-next (68389fd Cortex-M3: Add support for exception handl=
ing)
CONFLICT (content): Merge conflict in arch/arm/kernel/process.c
Merging ep93xx/ep93xx-for-next (cf92d86 Merge branch 'ep93xx-fixes' into ep=
93xx-for-next)
Merging ixp4xx/next (b94740b IXP4xx: use __iomem for MMIO)
Merging msm/for-next (a0d271c Linux 3.6)
Merging renesas/next (8a15713 Merge branches 'heads/defconfig', 'heads/soc3=
', 'heads/pfc4', 'heads/clocksource' and 'heads/intc-of' into next)
CONFLICT (modify/delete): drivers/sh/pfc/gpio.c deleted in renesas/next and=
 modified in HEAD. Version HEAD of drivers/sh/pfc/gpio.c left in tree.
CONFLICT (content): Merge conflict in drivers/pinctrl/sh-pfc/pinctrl.c
$ git rm -f drivers/sh/pfc/gpio.c
Merging samsung/for-next (f9e94e0 Merge branch 'next/timer-samsung' into fo=
r-next)
CONFLICT (modify/delete): arch/arm/plat-samsung/time.c deleted in samsung/f=
or-next and modified in HEAD. Version HEAD of arch/arm/plat-samsung/time.c =
left in tree.
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/samsung-time.c
CONFLICT (modify/delete): arch/arm/plat-samsung/include/plat/s5p-time.h del=
eted in samsung/for-next and modified in HEAD. Version HEAD of arch/arm/pla=
t-samsung/include/plat/s5p-time.h left in tree.
CONFLICT (content): Merge conflict in arch/arm/plat-samsung/include/plat/cp=
u.h
CONFLICT (content): Merge conflict in arch/arm/mach-s5pv210/mach-torbreck.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5pv210/mach-smdkv210.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5pv210/mach-smdkc110.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5pv210/mach-goni.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5pv210/mach-aquila.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5pc100/mach-smdkc100.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5p64x0/mach-smdk6450.c
CONFLICT (content): Merge conflict in arch/arm/mach-s5p64x0/mach-smdk6440.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smdk6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smdk6400.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smartq7.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-smartq5.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-real6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-ncp.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-mini6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-hmt.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-crag6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/mach-anw6410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/dma.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-vstms.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-vr1000.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-tct_hammer=
.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-smdk2443.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-smdk2440.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-smdk2416.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-smdk2413.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-smdk2410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-rx3715.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-rx1950.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-qt2410.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-otom.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-osiris.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-nexcoder.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-n30.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-mini2440.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-jive.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-h1940.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-gta02.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-bast.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-at2440evb.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-anubis.c
CONFLICT (content): Merge conflict in arch/arm/mach-s3c24xx/mach-amlm5900.c
CONFLICT (content): Merge conflict in arch/arm/mach-exynos/mach-universal_c=
210.c
$ git reset --hard
Merging tegra/for-next (91f840a Merge branch 'for-3.9/defconfig' into for-n=
ext)
Merging kvmtool/master (9c49610 kvm tools: arm: align guest memory buffer t=
o maximum page size)
Merging dma-mapping/dma-mapping-next (41b8d1e ARM: iommu: Include linux/kre=
f.h in asm/dma-iommu.h)
Merging pwm/for-next (0074b49 pwm: pwm-tiehrpwm: Update the clock handling =
of pwm-tiehrpwm driver)
Merging dma-buf/for-next (90b6e90 dma-buf: implement vmap refcounting in th=
e interface logic)
Merging userns/for-next (923c753 userns: Allow unprivileged reboot)
Merging ktest/for-next (95f5783 ktest: Fix ELSE IF statements)
Merging signal/for-next (115a1dc x86: convert to ksignal)
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/powerpc/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/syscall.c
CONFLICT (content): Merge conflict in arch/mips/Kconfig
Merging clk/clk-next (8f87189 MAINTAINERS: bad email address for Mike Turqu=
ette)
Merging random/dev (6133705 random: Mix cputime from each thread that exits=
 to the pool)
Merging lzo-update/lzo-update (ba32bf9 lib/lzo: Do not leak implementation =
details in lzo1x_1_compress())
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (eb584f3 lib/rbtree.c: avoid the use of non-st=
atic __always_inline)
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
Applying: fb: rework locking to fix lock ordering on takeover
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix
Applying: fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2
Applying: compat: return -EFAULT on error in waitid()
Applying: fs/block_dev.c: page cache wrongly left invalidated after revalid=
ate_disk()
Applying: x86 numa: don't check if node is NUMA_NO_NODE
Applying: arch/x86/tools/insn_sanity.c: identify source of messages
Applying: arch/x86/platform/uv: fix incorrect tlb flush all issue
Applying: olpc: fix olpc-xo1-sci.c build errors
Applying: x86: convert update_mmu_cache() and update_mmu_cache_pmd() to fun=
ctions
Applying: x86: fix the argument passed to sync_global_pgds()
Applying: arch/x86/kernel/cpu/perf_event_p6.c: fix section warning
Applying: Revert "x86, mm: Make spurious_fault check explicitly check the P=
RESENT bit"
Applying: pageattr: prevent PSE and GLOABL leftovers to confuse pmd/pte_pre=
sent and pmd_huge
Applying: x86: make 'mem=3D' option to work for efi platform
Applying: cris: Use "int" for ssize_t to match size_t
Applying: pcmcia: move unbind/rebind into dev_pm_ops.complete
Applying: drivers/gpu/drm/drm_fb_helper.c: avoid sleeping in unblank_screen=
() if oops in progress
Applying: cyber2000fb: avoid palette corruption at higher clocks
Applying: timeconst.pl: remove deprecated defined(@array)
Applying: time: don't inline EXPORT_SYMBOL functions
Applying: lockdep: Rename print_unlock_inbalance_bug() to print_unlock_imba=
lance_bug()
Applying: block: don't select PERCPU_RWSEM
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
Applying: memory-hotplug: introduce new arch_remove_memory() for removing p=
age table
Applying: memory-hotplug: implement register_page_bootmem_info_section of s=
parse-vmemmap
Applying: mmots-memory-hotplug-implement-register_page_bootmem_info_section=
-of-sparse-vmemmap-fix
Applying: memory-hotplug: move pgdat_resize_lock into sparse_remove_one_sec=
tion()
Applying: memory-hotplug: common APIs to support page tables hot-remove
Applying: memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix
Applying: memory-hotplug: remove page table of x86_64 architecture
Applying: memory-hotplug-remove-page-table-of-x86_64-architecture-fix
Applying: memory-hotplug: remove memmap of sparse-vmemmap
Applying: memory-hotplug-remove-memmap-of-sparse-vmemmap-fix
Applying: memory-hotplug: integrated __remove_section() of CONFIG_SPARSEMEM=
_VMEMMAP.
Applying: memory_hotplug: clear zone when removing the memory
Applying: memory-hotplug: remove sysfs file of node
Applying: memory-hotplug: free node_data when a node is offlined
Applying: memory-hotplug: do not allocate pdgat if it was not freed when of=
fline.
Applying: mm: memmap_init_zone() performance improvement
Applying: drop_caches: add some documentation and info message
Applying: drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create() =
with NULL dev
Applying: mm/dmapool.c: fix null dev in dma_pool_create()
Applying: memcg: debugging facility to access dangling memcgs
Applying: memcg-debugging-facility-to-access-dangling-memcgs-fix
Applying: mm: add vm event counters for balloon pages compaction
Applying: mm: prevent addition of pages to swap if may_writepage is unset
Applying: ext3, ext4, ocfs2: remove unused macro NAMEI_RA_INDEX
Applying: scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes
Applying: scripts/tags.sh: add magic for declarations of popular kernel type
Applying: smp: make smp_call_function_many() use logic similar to smp_call_=
function_single()
Applying: include/linux/fs.h: disable preempt when acquire i_size_seqcount =
write lock
Applying: kernel/smp.c: cleanups
Applying: get_maintainer.pl: find maintainers for removed files
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
Applying: checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>
Applying: checkpatch: warn on unnecessary __dev<foo> section markings
Applying: epoll: support for disabling items, and a self-test app
Applying: epoll: stop comparing pointers with 0 in self-test app
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
Applying: mtd: mtd_nandecctest: use prandom_bytes instead of get_random_byt=
es()
Applying: mtd: mtd_oobtest: convert to use prandom library
Applying: mtd: mtd_pagetest: convert to use prandom library
Applying: mtd: mtd_speedtest: use prandom_bytes
Applying: mtd: mtd_subpagetest: convert to use prandom library
Applying: mtd: mtd_stresstest: use prandom_bytes()
Applying: Documentation/DMA-API-HOWTO.txt: fix typo
Applying: profiling: Remove unused timer hook
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
CONFLICT (content): Merge conflict in fs/bio.c
Applying: block-aio-batch-completion-for-bios-kiocbs-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix
Applying: block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix
Applying: Fix build error due to bio_endio_batch
Applying: virtio-blk: convert to batch completion
Applying: aio: smoosh struct kiocb
Applying: aio-smoosh-struct-kiocb-fix
Applying: aio: fix aio_read_events_ring() types
Applying: aio: document, clarify aio_read_events() and shadow_tail
Applying: mm: fix BUG on madvise early failure
Merging akpm/master (12dd7dc mm: fix BUG on madvise early failure)

--Signature=_Tue__15_Jan_2013_14_37_06_+1100_3JurewoRlBvqZjSS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ9M7iAAoJEECxmPOUX5FE+XcP/RoqCWbOuIL2BcVeVb4vGbIQ
pm4pDilLy3Ia5LevgZWcnzDyDpKIbnD/mIqGdGswPYVhdJ/AGR1aekdvqG6P8PeC
a6bbarkghLq0SFw3sLpLL+KwYdnrqh8iqSeWNm3UbLQ59O/fFlrkIvB4+22uusjn
Zk9VMIkW/z6KPG4mUOZemjNVYDpW2SrVMqhLJe7iTibe+p4MXI38qVTAB0XKvS1b
J8auLeknvW5N9IcxqElnb30kkeG9oPlGIbCjrdLO77PS4GpPsSaclKTtXsyGj4sv
d4vMEt+5W/ZSJG4lOtYN+98EImz+e7FFnP7cc75YrzqAdXq0ZYYU7TiE7WsCBRbY
cKbPbrfIbtj8MvOgxVqx+JQAfK8GxMz7Bz3T6vVLBIk7Y2EcK9a3wEEUKI/i/7pQ
7syPaCwcMFgyQBCuv4VgmlMZRLvzPRT4RqrvEBFv8Kdbmj4RTTFinluqiVcuBDed
q6frABWsRnWSLj19+CVJR0Uo1tezyXikLCsBdpt7LaRYWQUZNXJVVsa1diK6cAQB
mIeteuM0I2wBNDYLSUbURxIkdZmvDOwB3MgcqKsT+Qk548KX/JbT/soaqBgYue9P
uu07W4ZdkiBCoz6EnqgCPL4ZCuWqRupCWQSnm1NLFYa2DYjoGoktJWNJnVXsIzhy
25UkBr9+iU3KxZ8fVg45
=MuPp
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jan_2013_14_37_06_+1100_3JurewoRlBvqZjSS--
