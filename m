Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaBKGVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:21:50 -0500
Received: from ozlabs.org ([203.10.76.45]:41382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaBKGVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:21:45 -0500
Date: Tue, 11 Feb 2014 17:21:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Feb 11
Message-Id: <20140211172136.37976e8c5e7b81ce11f30b34@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Feb_2014_17_21_36_+1100_rRp/oid_2opwPqQ5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Feb_2014_17_21_36_+1100_rRp/oid_2opwPqQ5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This tree fails (more than usual) the powerpc allyesconfig build.

Changes since 20140210:

The powerpc tree still had its build failure.

The mfd-lj tree gained a build failure so I used the version from
next-20140210.

The tip tree gained a build failure so I used the version from
next-20140210.

The staging tree still had its build failure for which I disabled a
driver.

The pinctrl tree gained a build failure so I used the version from
next-20140210.

Non-merge commits (relative to Linus' tree): 1751
 1876 files changed, 60425 insertions(+), 28360 deletions(-)

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
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES - this fails its final
link) and i386, sparc, sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

I am currently merging 208 trees (counting Linus' and 28 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

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
Merging origin/master (b28a960c42fc Linux 3.14-rc2)
Merging fixes/master (b0031f227e47 Merge tag 's2mps11-build' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/broonie/regulator)
Merging kbuild-current/rc-fixes (38dbfb59d117 Linus 3.14-rc1)
Merging arc-current/for-curr (7e22e91102c6 Linux 3.13-rc8)
Merging arm-current/fixes (87f9260bf1fb ARM: dts: fix spdif pinmux configur=
ation)
Merging m68k-current/for-linus (7247f55381d5 m68k: Wire up sched_setattr an=
d sched_getattr)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (b3084f4db3ae powerpc/thp: Fix crash on mremap)
Merging sparc/master (9b0cd304f26b Merge branch 'drm-next' of git://people.=
freedesktop.org/~airlied/linux)
Merging net/master (bf06200e732d tcp: tsq: fix nonagle handling)
Merging ipsec/master (965cdea82569 dccp: catch failed request_module call i=
n dccp_probe init)
Merging sound-current/for-linus (ef8e39b51f24 ALSA: hda - Fix undefined sym=
bol due to builtin/module mixup)
Merging pci-current/for-linus (38dbfb59d117 Linus 3.14-rc1)
Merging wireless/master (348f7d4adee9 rtl8180: Add error check for pci_map_=
single return value in TX path)
Merging driver-core.current/driver-core-linus (9e1ccb4a7700 drivers/base: f=
ix devres handling for master device)
Merging tty.current/tty-linus (d8a5dc3033af tty: Set correct tty name in 'a=
ctive' sysfs attribute)
Merging usb.current/usb-linus (03b56329f9bb Modpost: fixed USB alias genera=
tion for ranges including 0x9 and 0xA)
Merging staging.current/staging-linus (a0f452520211 Merge tag 'iio-fixes-fo=
r-3.14b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (3b1cc9b9622a misc: mic: fix poss=
ible signed underflow (undefined behavior) in userspace API)
Merging input-current/for-linus (55df811f2066 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (ee97dc7db4cb crypto: s390 - fix des and des3=
_ede ctr concurrency issue)
Merging ide/master (9b0cd304f26b Merge branch 'drm-next' of git://people.fr=
eedesktop.org/~airlied/linux)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (6f041e99fc7b of: Fix NULL dere=
ference in unflatten_and_copy())
Merging rr-fixes/fixes (7122c3e9154b scripts/link-vmlinux.sh: only filter k=
ernel symbols for arm)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (9f77558f8512 drm/i915: Pair v=
a_copy with va_end in i915_error_vprintf)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (c61e2aee0c55 ARC: Remove ARC_HAS_COH_RTSC)
Merging arm/for-next (58b9ef24dc72 Merge branch 'cubox-i-init' into for-nex=
t)
Merging arm-perf/for-next/perf (38dbfb59d117 Linus 3.14-rc1)
Merging arm-soc/for-next (c7052babf81d Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (413541dd66d5 Linux 3.13-rc5)
Merging cortex-m/for-next (f41bfc9423aa Merge tag 'ext4_for_linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (6e5dad1f97b2 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (fb78c32fdc99 Merge branch 'old/mvebu/irqchip' into =
for-next)
Merging renesas/next (9554b6651c23 Merge branches 'heads/soc-for-v3.15' and=
 'heads/boards-for-v3.15' into devel)
Merging samsung/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging tegra/for-next (02a2aa6f9a90 Merge branch for-3.15/defconfig into f=
or-next)
Merging arm64/for-next/core (38dbfb59d117 Linus 3.14-rc1)
Merging blackfin/for-linus (58095fdaaf1c From: Eunbong Song <eunb.song@sams=
ung.com>)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (44eb66c228fe Hexagon: update CR year for elf.h)
Merging ia64/next (d52eefb47d4e ia64/xen: Remove Xen support for ia64)
Merging m68k/for-next (7247f55381d5 m68k: Wire up sched_setattr and sched_g=
etattr)
Merging m68knommu/for-next (72a8ab3cb2a5 m68knommu: fix arg types for outs*=
 functions)
Merging metag/for-next (e9a1d0165bbd metag/smp: Make boot_secondary() stati=
c)
Merging microblaze/next (a49f56eec54d microblaze: Fix a typo when disabling=
 stack protection)
Merging mips/mips-for-linux-next (fbf4766a3ae2 Merge branch '3.14-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging powerpc/next (f878f84373ae powerpc: Wire up sched_setattr and sched=
_getattr syscalls)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (e309a9da2dd5 s390/kvm: set guest page states to stab=
le on re-ipl)
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (5e01dc7b26d9 Linux 3.12)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (c0e50d41126e xtensa: fix fast_syscall_spill_regist=
ers)
Merging btrfs/next (cf93da7bcf45 Btrfs: fix spin_unlock in check_ref_cleanu=
p)
Merging ceph/master (125d725c9235 ceph: cast PAGE_SIZE to size_t in ceph_sy=
nc_write())
Merging cifs/for-next (4a5c80d7b561 [CIFS] clean up page array when uncache=
d write send fails)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (4ea7772f828a udf: Fix lockdep warning from udf_symli=
nk())
Merging ext4/dev (d7092ae2973f ext4: delete "set but not used" variables)
Merging f2fs/dev (c86f36c6458c f2fs: introduce ra_meta_pages to readahead C=
P/NAT/SIT pages)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (b2ec2778df9d fuse: Turn writeback cache on)
Merging gfs2/master (c2b0b30eddf6 GFS2: Mark functions as static in gfs2/rg=
rp.c)
Merging jfs/jfs-next (c18f7b51200c jfs: fix generic posix ACL regression)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (b28a960c42fc Linux 3.14-rc2)
Merging nfsd/nfsd-next (ed47b062ce95 nfsd: consider CLAIM_FH when handing o=
ut delegation)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (38dbfb59d117 Linus 3.14-rc1)
Merging ubifs/linux-next (5547fec74a56 UBI: fix some use after free bugs)
Merging xfs/for-next (39f30ca7eaa4 Merge branch 'xfs-async-aio-extend' into=
 for-next)
Merging file-private-locks/linux-next (1ed1950c412f locks: add new fcntl cm=
d values for handling file private locks)
Merging vfs/for-next (527d1511310a Merge branch 'next' of git://git.kernel.=
org/pub/scm/linux/kernel/git/benh/powerpc)
Merging pci/next (17f2d86f5d53 Merge branch 'pci/numa-cleanup' into next)
Merging hid/for-next (f1523dbb7e90 Merge branch 'for-3.15/sony' into for-ne=
xt)
Merging i2c/i2c/for-next (9b0cd304f26b Merge branch 'drm-next' of git://peo=
ple.freedesktop.org/~airlied/linux)
Merging jdelvare-hwmon/master (691cb804d7b3 hwmon: (lm80) Convert to use de=
vm_hwmon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (2b9afabd73ac hwmon: (lm95245) Convert to =
use devm_hwmon_device_register_with_groups)
Merging v4l-dvb/master (b215621049bd Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (ff6b9bdb6263 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (efb9e0f4f437 ata: enable quirk from jmicron JMB350=
 for JMB394)
Merging pm/linux-next (611f30d47980 Merge branch 'acpi-dock')
Merging idle/next (2d6e532279dd tools/power turbostat: simplify output, add=
 Avg_MHz)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (262afa97587b Merge branches 'soc-eduardo', 'soc', 'mi=
sc' and 'int3404-thermal' of .git into next)
CONFLICT (content): Merge conflict in drivers/thermal/Kconfig
Merging ieee1394/for-next (fcd46b34425d firewire: Enable remote DMA above 4=
 GB)
Merging dlm/next (ece35848c184 dlm: set zero linger time on sctp socket)
Merging swiotlb/linux-next (0cb637bff80d swiotlb: Don't DoS us with 'swiotl=
b buffer is full' (v2))
Merging slave-dma/next (38dbfb59d117 Linus 3.14-rc1)
Merging dmaengine/next (77873803363c net_dma: mark broken)
Merging net-next/master (77d143de7581 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/rw/uml)
Merging ipsec-next/master (abfce3ef58b6 sctp: remove the unnecessary assign=
ment)
Merging wireless-next/master (38dbfb59d117 Linus 3.14-rc1)
Merging bluetooth/master (e3719086ff57 Bluetooth: Use connection parameters=
 if any)
Merging infiniband/for-next (fb1b5034e498 Merge branch 'ip-roce' into for-n=
ext)
Merging mtd/master (0e47c969c65e Merge tag 'for-linus-20140127' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (87a8b7ea1e3f mtd: nand: don't use read_buf for 8-bit=
 ONFI transfers)
Merging crypto/master (883619a931e9 crypto: caam - fix ERA retrieval functi=
on)
Merging drm/drm-next (ef64cf9d0604 Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-intel/for-linux-next (b5c65b6e5b76 drm/i915: split aligned heig=
ht calculation out v2)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_dp.c
Merging drm-tegra/drm/for-next (13411ddd3190 drm/tegra: Obtain head number =
from DT)
Merging sound/for-next (a8dca4604a13 ALSA: hda - Make snd_hda_gen_spec_free=
() static)
Merging sound-asoc/for-next (6e9b9efcf499 Merge remote-tracking branches 'a=
soc/topic/wm8741', 'asoc/topic/wm8962', 'asoc/topic/wm8988' and 'asoc/topic=
/wm8991' into asoc-next)
Merging modules/modules-next (22e669568d51 module: Add missing newline in p=
rintk call.)
Merging virtio/virtio-next (05c54de8c88c drivers: virtio: Mark function vir=
tballoon_migratepage() as static in virtio_balloon.c)
Merging input/next (50fe03da82b4 Input: uinput - add UI_GET_SYSNAME ioctl t=
o retrieve the sysfs path)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (2a53fee6859b Merge branch 'for-3.14/core' into for-=
next)
Merging device-mapper/for-next (d3cd022521ed dm thin: avoid metadata commit=
 if a pool's thin devices haven't changed)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (38dbfb59d117 Linus 3.14-rc1)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (26e4f2057516 slub: Fix possible format string bug.)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (1877db75589a md/raid1: restore ability for check and r=
epair to fix read errors.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (86351d035461 mfd: Delete non-required instance=
s of include <linux/init.h>)
$ git reset --hard HEAD^
Merging next-20140210 version of mfd-lj
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (cb1fbad7ec25 Merge branches '3.14/fbdev', '3.14=
/dss-misc' and '3.14/dss-fclk' into for-next)
Merging regulator/for-next (83172d6be4c4 Merge remote-tracking branches 're=
gulator/topic/da9055', 'regulator/topic/doc', 'regulator/topic/gpio', 'regu=
lator/topic/max14577', 'regulator/topic/s5m8767', 'regulator/topic/ti-abb' =
and 'regulator/topic/tps6507x' into regulator-next)
Merging security/next (e0238b4ced90 selinux: fix the output of ./scripts/ge=
t_maintainer.pl for SELinux)
Merging selinux/next (81c94e76ce8e selinux: fix the output of ./scripts/get=
_maintainer.pl for SELinux)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (41c91d637e86 watchdog: w83697hf_wdt: return ENODEV=
 if no device was found)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (dd1a175695ed Merge branches 'arm/smmu', 'core', 'x86/vt=
-d', 'arm/shmobile', 'x86/amd', 'ppc/pamu', 'iommu/fixes' and 'arm/msm' int=
o next)
Merging vfio/next (3be3a074cf5b vfio-pci: Don't use device_lock around AER =
interrupt setup)
Merging osd/linux-next (19350e7627a6 exofs: Print less in r4w)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (8cc7212a0361 idr: remove unused prototype of idr_=
free())
Merging audit/master (f3411cb2b2e3 audit: whitespace fix in kernel-paramete=
rs.txt)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (b66548e2a9ba of: Increase MAX_PHANDLE_A=
RGS)
Merging dt-rh/for-next (860a445c25aa DT: Add vendor prefix for Spansion Inc=
.)
Merging spi/for-next (ed425ccdbe47 Merge remote-tracking branches 'spi/topi=
c/sunxi', 'spi/topic/tegra114' and 'spi/topic/xfer' into spi-next)
Merging tip/auto-latest (bad95cfc18a4 Merge branch 'x86/x32')
$ git reset --hard HEAD^
Merging next-20140210 version of tip
Merging clockevents/clockevents/next (00e2bcd6d35f clocksource: Timer-sun5i=
: Switch to sched_clock_register())
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (9d0e8d8348d5 amd64_edac: Fix logic to determine =
channel for F15 M30h processors)
Merging ftrace/for-next (3132e107d608 tracing: Check if tracing is enabled =
in trace_puts())
Merging rcu/rcu/next (a9b5bb435cce locktorture: Add kvm-recheck.sh plug-in =
for locktorture)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (b73117c49364 Merge branch 'kvm-ppc-next' of git://g=
ithub.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-arm/kvm-arm-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging kvm-ppc/kvm-ppc-next (b73117c49364 Merge branch 'kvm-ppc-next' of g=
it://github.com/agraf/linux-2.6 into kvm-queue)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (62d33bf5f056 Merge branch 'stable/for-linus-3.1=
4' into linux-next)
Merging percpu/for-next (d5f2deed588b Merge branch 'for-3.14' into for-next)
Merging workqueues/for-next (9af16df84f0c Merge branch 'for-3.14' into for-=
next)
Merging drivers-x86/linux-next (b4b0b4a9e039 ipc: add intel-mid's pci id ma=
cros)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (f37d0b3b106a Merge remote-tracking branch 'regmap/=
topic/irq' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (59e35a9e5315 drivers/leds: delete non-required insta=
nces of include <linux/init.h>)
Merging driver-core/driver-core-next (9561a8961c70 kernfs: fix hash calcula=
tion in kernfs_rename_ns())
CONFLICT (content): Merge conflict in fs/kernfs/dir.c
Merging tty/tty-next (38dbfb59d117 Linus 3.14-rc1)
Merging usb/usb-next (22f6a0f0e354 usb: move hub init and LED blink work to=
 power efficient workqueue)
Merging usb-gadget/next (836a2164491b usb: phy: keystone: remove redundant =
return value check of platform_get_resource())
Merging staging/staging-next (7ca363f6872b Merge branch 'staging-linus' int=
o staging-work)
Applying: staging: r8188eu: diable driver due to breakage
Merging char-misc/char-misc-next (7841b647b9c1 Revert ds1wm.c from "w1: hol=
d bus_mutex in netlink and search")
Merging cgroup/for-next (f7cef064aa01 Merge branch 'driver-core-next' into =
cgroup/for-3.15)
Merging scsi/for-next (3ce438df1068 [SCSI] hpsa: allow SCSI mid layer to ha=
ndle unit attention)
Merging target-updates/for-next (5259a06ef970 target: Fix percpu_ref_put ra=
ce in transport_lun_remove_cmd)
Merging target-merge/for-next-merge (374b105797c3 Linux 3.13-rc3)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (f3f527607718 pinctrl: sh-pfc: r8a7790: Break out =
USB0 OVC/VBUS)
$ git reset --hard HEAD^
Merging next-20140210 version of pinctrl
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (a3485d088516 gpio: consumer.h: Move forward declarat=
ions outside #ifdef)
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (6691a19966f0 pwm: tiecap: Remove duplicate put_sync c=
all)
Merging dma-buf/for-next (f546ca46faa1 dma-buf: update debugfs output)
Merging userns/for-next (f58437f1f916 MIPS: VPE: Remove vpe_getuid and vpe_=
getgid)
Merging ktest/for-next (961d9caceea2 ktest: Add BISECT_TRIES to bisect test)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (fd3fdaf09f26 clk: sort Makefile)
Merging random/dev (a9f069e38cc3 random: use the architectural HWRNG for th=
e SHA's IV in extract_buf())
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (8e321fefb0e6 aio/migratepages: make aio migrate pages s=
ane)
Merging akpm-current/current (1fc69fa0b91f drivers/misc/sgi-gru/grukdump.c:=
 cleanup gru_dump_context() a little)
CONFLICT (content): Merge conflict in mm/slub.c
CONFLICT (content): Merge conflict in arch/x86/include/asm/pgtable.h
$ git checkout -b akpm remotes/origin/akpm/master
Applying: fs/udf/super.c: add __init to init_inodecache()
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: arm: move arm_dma_limit to setup_dma_zone
Applying: mm: add strictlimit knob
Merging akpm/master (674adcf8f23e mm: add strictlimit knob)

--Signature=_Tue__11_Feb_2014_17_21_36_+1100_rRp/oid_2opwPqQ5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+cF1AAoJEMDTa8Ir7ZwVdm4P/jgjr49VvwIyucSmpGHTxukv
/Hcq0s6qwIRm5PeH2Scpb1UtnIxn3X8H40eyx5TLhpw+4epj0bgCCPkiAyWokTkv
JyavJGhIPDFnOUSncLPOQqlEkc4/FInOKejwV8vGaBFuZgg6Jh0YRkysuEIqSuv8
mGj6P0PcompS9wr+ErYcP/DXMmr5H1YFNBhJ+8QIRDRHtEEyy44incSs2dr5diwr
yQLT7aNeWDbu7Jew+VTdoGX6vQ7OGpx2FaEL6MlIp8vjRKxnSCJFCaWiDYgMSaCO
OKE/crwh4bA8fLkd4OpBKaVEFopF6Sgb4xVgWjPwPeJOJW/1pycHHvakDfCOmYce
M2FSMRO/n3HLAETgRjnhO2NVbacvhc/0cH232hJvc5YyaFTpPKsYzOl9asFQWTP4
g15xVJAiV1H6g7y1sIISB74pOGcWPYkEFlPsDRwFyo7XPG5e0LR3Kxrzeg2/qKqA
lgPXkAew9V2HPeZzcqVWGdH3ee5xA2JpyOpOjW6RMWqssIZDmKbiRifRUAQ3IbWO
+YWcwoBWhoN01fsq6IwJSRpu6monwLUJo3cF70bVr9oaHfW0BOnMQEKmA9rMr0HP
nqby9lz0JZtyJfQJXJ0DMwqGU3sgXWj2DQwjoMUe7ZZ2A/hyoQXqq8bPhTnsvQRa
iaLe3pFtOefUVCKWNDDe
=ziwt
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Feb_2014_17_21_36_+1100_rRp/oid_2opwPqQ5--
