Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab3KOFZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:25:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33516 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3KOFZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:25:05 -0500
Date: Fri, 15 Nov 2013 16:24:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 15
Message-Id: <20131115162455.b45631434f6417b221f2a4d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Nov_2013_16_24_55_+1100_uQcnYOhtOzjlhOkQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Nov_2013_16_24_55_+1100_uQcnYOhtOzjlhOkQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do *not* add any v3.14 material to linux-next until after
v3.13-rc1 is released.

Changes since 20131114:

The idle tree gained a conflict against the pm tree.

The dmaengine tree gained a conflict against the slave-dma tree.

The akpm tree gained a conflict against the sparc-next tree.

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

I am currently merging 210 trees (counting Linus' and 29 trees of patches
pending for Linus' tree), more are welcome (even if they are currently
empty). Thanks to those who have contributed, and to those who haven't,
please do.

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
Merging origin/master (4fbf888accb3 Merge tag 'ext4_for_linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging fixes/master (fa8218def1b1 Merge tag 'regmap-v3.11-rc7' of git://gi=
t.kernel.org/pub/scm/linux/kernel/git/broonie/regmap)
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (737d5b980be8 ARC: [plat-arcfpga] defconfig up=
date)
Merging arm-current/fixes (6ecf830e5029 ARM: 7880/1: Clear the IT state ind=
ependent of the Thumb-2 mode)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (8b5ede69d24d powerpc/irq: Don't switch to irq =
stack from softirq stack)
Merging sparc/master (6d15ee492809 Merge git://git.kernel.org/pub/scm/virt/=
kvm/kvm)
Merging net/master (c9e9042994d3 ipv4: fix possible seqlock deadlock)
Merging ipsec/master (be408cd3e1fe Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging sound-current/for-linus (32b8544296b9 ALSA: jack: Unregister input =
device at disconnection)
Merging pci-current/for-linus (d43ed14b737c PCI: Fix whitespace, capitaliza=
tion, and spelling errors)
Merging wireless/master (8e3ffa471091 prism54: set netdev type to "wlan")
Merging driver-core.current/driver-core-linus (31d141e3a666 Linux 3.12-rc6)
Merging tty.current/tty-linus (6e757ad2c92c tty/serial: at91: fix uart/usar=
t selection for older products)
Merging usb.current/usb-linus (e1466ad5b1ae USB: serial: ftdi_sio: add id f=
or Z3X Box device)
Merging staging.current/staging-linus (31d141e3a666 Linux 3.12-rc6)
Merging char-misc.current/char-misc-linus (31d141e3a666 Linux 3.12-rc6)
Merging input-current/for-linus (5beea882e641 Input: ALPS - add support for=
 model found on Dell XT2)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (f262f0f5cad0 crypto: s390 - Fix aes-cbc IV c=
orruption)
CONFLICT (content): Merge conflict in drivers/crypto/caam/jr.c
Merging ide/master (64110c16e012 ide: sgiioc4: Staticize ioc4_ide_attach_on=
e())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (f6537f2f0eba scripts/kallsyms: filter symbols not i=
n kernel address space)
Merging mfd-fixes/master (d0e639c9e06d Linux 3.12-rc4)
Merging vfio-fixes/for-linus (d93b3ac0edb8 VFIO: vfio_iommu_type1: fix bug =
caused by break in nested loop)
Merging drm-intel-fixes/for-linux-next-fixes (1fbc0d789d12 drm/i915: Fix th=
e PPT fdi lane bifurcate state handling on ivb)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (d6a7f73db712 ARC: Add documentation on DT binding for=
 ARC700 PMU)
Merging arm/for-next (fb95742a4a4f Merge branch 'unstable/dma-for-next' int=
o for-next)
Merging arm-perf/for-next/perf (15c03dd4859a Linux 3.12-rc3)
Merging arm-soc/for-next (89285754ff25 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (7d132055814e Linux 3.10-rc6)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (bbf38d4e5e2e Merge branches 'imx/soc' and 'imx/dt=
' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/mach-imx6q.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (b91cf40516e0 Merge branch 'mvebu/dt' into for-next)
Merging renesas/next (597472bb771b Merge branch 'heads/clock' into next)
CONFLICT (content): Merge conflict in drivers/clk/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-bockw.c
Merging samsung/for-next (d2287944920d Merge branch 'v3.13-next/samsung' in=
to for-next)
Merging tegra/for-next (1ebd0d6a0589 Merge branch for-3.13/maintainers into=
 for-next)
Merging arm64/upstream (67317c268956 ARM64: /proc/interrupts: display IPIs =
of online CPUs only)
Merging blackfin/for-linus (08b67faa23fd blackfin: Ignore generated uImages)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
CONFLICT (content): Merge conflict in drivers/parport/Kconfig
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging cris/for-next (be8cb7f42ab9 CRIS: drop unused Kconfig symbols)
Merging h8300-remove/h8300-remove (b400126add8f CREDITS: Add Yoshinori Sato=
 for h8300)
Merging hexagon/linux-next (de44443a45e3 HEXAGON: Remove non existent refer=
ence to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (959f58544b7f Linux 3.12-rc7)
Merging m68k/for-next (77a42796786c m68k: Remove deprecated IRQF_DISABLED)
Merging m68knommu/for-next (959f58544b7f Linux 3.12-rc7)
Merging metag/for-next (51387306b5c2 metag: off by one in setup_bootmem_nod=
e())
Merging microblaze/next (a1dd107fcafa microblaze: Remove duplicate declarat=
ions of _stext[] and _etext[])
Merging mips/mips-for-linux-next (723ff7943249 MIPS: remove duplicate defin=
e)
Merging openrisc/for-upstream (56aea88df7b3 openrisc: Refactor 16-bit const=
ant relocation)
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (10d0c9705e80 Merge tag 'devicetree-for-3.13' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux)
Merging powerpc/next (0c4888ef1d8a powerpc: Fix fatal SLB miss when restori=
ng PPR)
Merging mpc5xxx/next (7e198197ec87 powerpc/mpc512x: remove unnecessary #if)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (b445cb4eb403 s390/boot: Install bzImage as default k=
ernel image)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (812cb83a56a9 sparc64: Implement HAVE_CONTEXT_TRA=
CKING)
Merging tile/master (9248053f80fd tile: Remove tile-specific _sinitdata and=
 _einitdata)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (8872366df396 xtensa: Fix broken allmodconfig build)
Merging btrfs/next (91aef86f3b8a Btrfs: rename btrfs_start_all_delalloc_ino=
des)
Merging ceph/master (53d028160f1a ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (41c1358e9181 CIFS: SMB2/SMB3 Copy offload support (r=
efcopy) phase 1)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (2000f5beabc9 eCryptfs: file->private_data is always =
valid)
Merging ext3/for_next (7ba3ec5749dd ext2: Fix fs corruption in ext2_get_xip=
_mem())
Merging ext4/dev (3f61c0cc706d ext4: add prototypes for macro-generated fun=
ctions)
Merging f2fs/dev (29e59c14ae5c f2fs: issue more large discard command)
Merging fscache/fscache (7c604e5d6e56 FS-Cache: Fix handling of an attempt =
to store a page that is now beyond EOF)
Merging fuse/for-next (ce128de6260f fuse: writepages: protect secondary req=
uests from fuse file release)
Merging gfs2/master (2147dbfd059e GFS2: Use generic list_lru for quota)
Merging jfs/jfs-next (8660998608cf jfs: fix error path in ialloc)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (6d769f1e1420 nfs: don't retry detect_trunking with =
RPC_AUTH_UNIX more than once)
Merging nfsd/nfsd-next (aea240f4162d nfsd: export proper maximum file size =
to the client)
CONFLICT (content): Merge conflict in fs/nfsd/nfsfh.c
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (e8a3a0fc13fe Squashfs: Check stream is not NULL in=
 decompressor_multi.c)
Merging v9fs/for-next (3b1288170cfe net/9p: remove virtio default hack and =
set appropriate bits instead)
CONFLICT (content): Merge conflict in fs/9p/vfs_inode_dotl.c
CONFLICT (content): Merge conflict in fs/9p/vfs_inode.c
CONFLICT (content): Merge conflict in fs/9p/vfs_file.c
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (359d992bcd39 xfs: simplify kmem_{zone_}zalloc)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (eaaeb1cb3331 Merge branch 'pci/misc' into next)
Merging hid/for-next (bceac5d94bbe Merge branch 'for-3.13/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (2dc9688a1068 i2c: wmt: add missing clk_disable_un=
prepare() on error)
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging jdelvare-hwmon/master (13af18ff79f9 Documentation: dt: hwmon: Add O=
F document for LM90)
Merging hwmon-staging/hwmon-next (26336c8a36c0 hwmon: (w83793) Clean up a s=
ignedness issue)
Merging v4l-dvb/master (52eca34d5e35 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (44a6ba71de03 Merge branches 'kbuild/kbuild' and 'k=
build/misc' into kbuild/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (1ca953d5f992 Merge branch 'for-3.13' into for-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (b3ce7ce6abea Merge branch 'acpi-hotplug')
Merging idle/next (8de8187d167c Merge branches 'acpi-blacklist-year' and 'a=
vn-upstream' into release)
CONFLICT (content): Merge conflict in drivers/idle/intel_idle.c
Merging apm/for-next (fb9d78aca709 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (86e0a0bdf81c Merge branches 'intel_powerclamp', 'tmon=
' and 'misc' of .git into next)
Merging ieee1394/for-next (db9ae8fec7b1 firewire: ohci: Fix deadlock at bus=
 reset)
Merging ubi/linux-next (ae0d14695566 UBI: Add some asserts to ubi_attach_fa=
stmap())
Merging dlm/next (a97f4a66d8ee dlm: Avoid that dlm_release_lockspace() inco=
rrectly returns -EBUSY)
Merging swiotlb/linux-next (af51a9f1848f swiotlb: Do not export swiotlb_bou=
nce since there are no external consumers)
Merging slave-dma/next (2f986ec6fa57 dma: pl330: silence a compile warning)
Merging dmaengine/next (82a1402eaee5 dma: mv_xor: Fix mis-usage of mmio 'ba=
se' and 'high_base' registers)
CONFLICT (content): Merge conflict in drivers/dma/dmatest.c
Merging net-next/master (42a2d923cc34 Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net-next)
Merging ipsec-next/master (9bb8ca86075f virtio-net: switch to use XPS to ch=
oose txq)
Merging wireless-next/master (3c57e865cfb2 ath9k: enable DFS for IBSS mode)
Merging bluetooth/master (11af3838c853 Bluetooth: Enable autosuspend for In=
tel Bluetooth device)
Merging infiniband/for-next (f74ec7f70808 Merge branches 'cma', 'cxgb4', 'i=
poib', 'misc', 'mlx5', 'nes', 'ocrdma', 'qib' and 'srp' into for-next)
Merging mtd/master (82cb6acea4d1 Merge tag 'for-linus-20131112' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (82cb6acea4d1 Merge tag 'for-linus-20131112' of git:/=
/git.infradead.org/linux-mtd)
Merging crypto/master (f262f0f5cad0 crypto: s390 - Fix aes-cbc IV corruptio=
n)
Merging drm/drm-next (ad40f83f5a89 Merge branch 'drm-next-3.13' of git://pe=
ople.freedesktop.org/~agd5f/linux into drm-next)
Merging drm-intel/for-linux-next (7bd40c16ccb2 x86/early quirk: use gen6 st=
olen detection for VLV)
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
Merging sound/for-next (32b8544296b9 ALSA: jack: Unregister input device at=
 disconnection)
Merging sound-asoc/for-next (6f06cc204294 Merge remote-tracking branch 'aso=
c/fix/wm8962' into asoc-linus)
Merging modules/modules-next (b6568b1a19ad modpost: fix bogus 'exported twi=
ce' warnings.)
Merging virtio/virtio-next (cdd77e87eae5 x86, asmlinkage, lguest: Pass in g=
lobals into assembler statement)
Merging input/next (2c027b7c48a8 arm: dts: am335x sk: add touchscreen suppo=
rt)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/am335x-evmsk.dts
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (0d60e6cd793e Merge branch 'for-3.13' into for-next)
Merging block/for-next (6decb5fa33f8 Merge branch 'for-3.13/drivers' into f=
or-next)
Merging aio-direct/for-next (bb6f7be48318 tmpfs: add support for read_iter =
and write_iter)
CONFLICT (content): Merge conflict in include/linux/blk_types.h
CONFLICT (content): Merge conflict in fs/read_write.c
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/btrfs/inode.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/nandsim.c
Applying: ceph: Fix up for iov_iter changes
Merging device-mapper/for-next (7b6b2bc98c03 dm cache: resolve small nits a=
nd improve Documentation)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (e395c4387c74 mmc: wbsd: Silence compiler warning)
CONFLICT (content): Merge conflict in drivers/mmc/host/mvsdio.c
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
CONFLICT (content): Merge conflict in kernel/debug/debug_core.h
Merging slab/for-next (a8c0b0837359 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (00c1c37c1c75 md/raid5: Before freeing old multi-thread=
 worker, it should flush them.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
CONFLICT (content): Merge conflict in sound/soc/codecs/mc13783.c
Merging mfd-lj/for-mfd-next (9a46847aeac1 Documentation: mfd: Update s2mps1=
1.txt)
Merging battery/master (c8024234c20e pm2301-charger: Remove unneeded NULL c=
hecks)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (3a41c5dbe8bc fb: reorder the lock sequence to f=
ix potential dead lock)
Merging regulator/for-next (eebb1457e2fc Merge remote-tracking branch 'regu=
lator/fix/pfuze100' into regulator-linus)
Merging security/next (217091dd7a7a ima: define '_ima' as a builtin 'truste=
d' keyring)
CONFLICT (content): Merge conflict in crypto/Makefile
Merging selinux/master (94851b18d4eb Merge tag 'v3.12')
Merging lblnet/master (07bc9dc1b01b Merge branch 'merge' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/benh/powerpc)
Merging watchdog/master (99e57a4dc2e0 watchdog: sirf: don't depend on dummy=
 value of CLOCK_TICK_RATE)
Merging dwmw2-iommu/master (e5d0c874391a Merge tag 'iommu-updates-v3.12' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu)
Merging iommu/next (e6ca48d995e4 Merge branches 'iommu/fixes', 'tracing', '=
core', 'arm/tegra' and 'x86/vt-d' into next)
Merging vfio/next (15c03dd4859a Linux 3.12-rc3)
Merging osd/linux-next (861d66601acd exofs: don't leak io_state and pages o=
n read error)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (2bb9936beac2 doc: usb: Fix typo in Documentation/=
usb/gadget_configs.txt)
CONFLICT (content): Merge conflict in net/netfilter/xt_set.c
Merging audit/master (9175c9d2aed5 audit: fix type of sessionid in audit_se=
t_loginuid())
CONFLICT (content): Merge conflict in fs/exec.c
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (c11eede69b6a powerpc: add missing explicit OF inclu=
des for ppc)
Merging spi/for-next (f8ce25620cdc Merge remote-tracking branch 'spi/topic/=
wr' into spi-next)
Merging tip/auto-latest (04e387210855 Merge branch 'x86/uaccess')
CONFLICT (content): Merge conflict in arch/x86/kernel/reboot.c
Merging edac/linux_next (3e45588825c1 cell_edac: fix missing of_node_put)
Merging edac-amd/for-next (c3e511e4c4d9 amd64_edac: Remove superfluous cond=
ition check.)
Merging ftrace/for-next (20b72e76c42b Merge branch 'trace/ftrace/core' into=
 trace/for-next)
Merging rcu/rcu/next (4102adab9189 rcu: Move RCU-related source code to ker=
nel/rcu directory)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (ede582224231 Merge tag 'kvm-arm64/for-3.13-1' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms into kvm-next)
CONFLICT (content): Merge conflict in arch/powerpc/kernel/traps.c
CONFLICT (content): Merge conflict in arch/powerpc/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/processor.h
Merging kvm-arm/kvm-arm-next (79c648806f90 arm/arm64: KVM: PSCI: use MPIDR =
to identify a target CPU)
Merging kvm-ppc/kvm-ppc-next (a78b55d1c021 kvm: powerpc: book3s: drop is_hv=
_enabled)
Merging oprofile/for-next (8884754b2534 Merge branch 'edac' into for-next)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (71183d3be111 Merge tag 'stable/for-linus-3.13-r=
c0-tag' into linux-next)
CONFLICT (content): Merge conflict in arch/arm/include/asm/dma-mapping.h
Merging percpu/for-next (90f2492cf9c8 x86: remove this_cpu_xor() implementa=
tion)
Merging workqueues/for-next (016564d41b35 workqueue: fix pool ID allocation=
 leakage and remove BUILD_BUG_ON() in init_workqueues)
Merging drivers-x86/linux-next (5c07eae979df platform/x86: panasonic-laptop=
: reuse module_acpi_driver)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (04bc9ac163a2 Merge remote-tracking branch 'regmap/=
topic/spmi' into regmap-next)
Merging hsi/for-next (43139a61fc68 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (30dae2f98612 leds: lp55xx: handle enable pin in driv=
er)
Merging driver-core/driver-core-next (0cae60f91494 sysfs: rename sysfs_asso=
c_lock and explain what it's about)
Merging tty/tty-next (80d8611dd076 serial: omap: fix missing comma)
Merging usb/usb-next (7d49f0bac41e USB: Maintainers change for usb serial d=
rivers)
Merging usb-gadget/next (80d7d8a768cd usb: phy: twl6030-usb: Include linux/=
of.h header)
Merging staging/staging-next (ed5d6ca0038f staging: drm/imx: fix return val=
ue check in ipu_add_subdevice_pdata())
Merging char-misc/char-misc-next (425792266a40 misc: mic: Fixes for randcon=
fig build errors and warnings.)
Merging scsi/for-next (2aee240c68ed Merge branch 'misc' into for-next)
Merging target-updates/for-next (3e07395441c8 iscsi-target: Convert iscsi_s=
ession statistics to atomic_long_t)
CONFLICT (content): Merge conflict in lib/percpu-refcount.c
Merging target-merge/for-next-merge (15c03dd4859a Linux 3.12-rc3)
Merging writeback/writeback-for-next (a8855990e382 writeback: Do not sort b=
_io list only because of block device inode)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (9da8312048ed pinctrl: imx50: add pinctrl support =
code for the IMX50 SoC)
Merging vhost/linux-next (d3d665a654a3 vhost-scsi: whitespace tweak)
Merging remoteproc/for-next (b9777859ec01 remoteproc: fix kconfig dependenc=
ies for VIRTIO)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (993571273275 gpio: gpio-mxs: Remove unneeded dt chec=
ks)
Merging dma-mapping/dma-mapping-next (0df651a0740c Merge branch 'parisc-3.1=
2' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux)
Merging pwm/for-next (702e304f198f Documentation/pwm: Fix trivial typos)
CONFLICT (modify/delete): arch/arm/mach-omap2/board-zoom-peripherals.c dele=
ted in HEAD and modified in pwm/for-next. Version pwm/for-next of arch/arm/=
mach-omap2/board-zoom-peripherals.c left in tree.
$ git rm -f arch/arm/mach-omap2/board-zoom-peripherals.c
Merging dma-buf/for-next (19e8697ba45e dma-buf: Expose buffer size to users=
pace (v2))
Merging userns/for-next (40216baa0101 vfs: Lazily remove mounts on unlinked=
 files and directories. v2)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/mount.h
CONFLICT (content): Merge conflict in fs/fuse/dir.c
CONFLICT (content): Merge conflict in fs/dcache.c
Applying: vfs: merge fixup for __lookup_mnt() API change
Applying: vfs: fixup for vfsmount_lock change
Merging ktest/for-next (df5f7c66013c ktest: Reset grub menu cache with diff=
erent machines)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (9ed9c07d9b7d clk: new driver for efm32 SoC)
Merging random/dev (392a546dc836 random: add debugging code to detect early=
 use of get_random_bytes())
CONFLICT (content): Merge conflict in drivers/char/random.c
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484863e0 ARM64: mm: THP sup=
port.)
Merging aio/master (13fd8a5dc3cf Merge branch 'aio-fix' of http://evilpiepi=
rate.org/git/linux-bcache)
Merging akpm-current/current (7c5598d4c874 scripts/bloat-o-meter: use .star=
tswith rather than fragile slicing)
CONFLICT (content): Merge conflict in scripts/bloat-o-meter
CONFLICT (content): Merge conflict in mm/swapfile.c
CONFLICT (add/add): Merge conflict in lib/percpu_test.c
CONFLICT (content): Merge conflict in kernel/Makefile
CONFLICT (content): Merge conflict in include/linux/lglock.h
CONFLICT (content): Merge conflict in fs/cramfs/Kconfig
CONFLICT (content): Merge conflict in fs/autofs4/inode.c
CONFLICT (content): Merge conflict in fs/anon_inodes.c
CONFLICT (content): Merge conflict in arch/x86/mm/init.c
Applying: lglock: fixup for code movement
Applying: mm: fix bad merge of mmap.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: mm: drop actor argument of do_generic_file_read()
Applying: mm: avoid increase sizeof(struct page) due to split page table lo=
ck
Applying: mm: rename USE_SPLIT_PTLOCKS to USE_SPLIT_PTE_PTLOCKS
Applying: mm: convert mm->nr_ptes to atomic_long_t
Applying: mm: introduce api for split page table lock for PMD level
Applying: mm, thp: change pmd_trans_huge_lock() to return taken lock
Applying: mm, thp: move ptl taking inside page_check_address_pmd()
Applying: mm, thp: do not access mm->pmd_huge_pte directly
Applying: mm, hugetlb: convert hugetlbfs to use split pmd lock
Applying: mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fix=
es
Applying: mm: convert the rest to new page table lock api
Applying: mm: implement split page table lock for PMD level
Applying: x86, mm: enable split page table lock for PMD level
Applying: x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes
Applying: x86: add missed pgtable_pmd_page_ctor/dtor calls for preallocated=
 pmds
Applying: cris: fix potential NULL-pointer dereference
Applying: m32r: fix potential NULL-pointer dereference
Applying: xtensa: fix potential NULL-pointer dereference
Applying: mm: allow pgtable_page_ctor() to fail
Applying: microblaze: add missing pgtable_page_ctor/dtor calls
Applying: mn10300: add missing pgtable_page_ctor/dtor calls
Applying: openrisc: add missing pgtable_page_ctor/dtor calls
Applying: alpha: handle pgtable_page_ctor() fail
Applying: arc: handle pgtable_page_ctor() fail
Applying: arm: handle pgtable_page_ctor() fail
Applying: arm64: handle pgtable_page_ctor() fail
Applying: avr32: handle pgtable_page_ctor() fail
Applying: cris: handle pgtable_page_ctor() fail
Applying: frv: handle pgtable_page_ctor() fail
Applying: hexagon: handle pgtable_page_ctor() fail
Applying: ia64: handle pgtable_page_ctor() fail
Applying: m32r: handle pgtable_page_ctor() fail
Applying: m68k: handle pgtable_page_ctor() fail
Applying: m68k-handle-pgtable_page_ctor-fail-fix
Applying: m68k-handle-pgtable_page_ctor-fail-fix-fix
Applying: metag: handle pgtable_page_ctor() fail
Applying: mips: handle pgtable_page_ctor() fail
Applying: parisc: handle pgtable_page_ctor() fail
Applying: powerpc: handle pgtable_page_ctor() fail
Applying: s390: handle pgtable_page_ctor() fail
Applying: score: handle pgtable_page_ctor() fail
Applying: sh: handle pgtable_page_ctor() fail
Applying: sparc: handle pgtable_page_ctor() fail
CONFLICT (content): Merge conflict in arch/sparc/mm/init_64.c
Applying: tile: handle pgtable_page_ctor() fail
Applying: um: handle pgtable_page_ctor() fail
Applying: unicore32: handle pgtable_page_ctor() fail
Applying: x86: handle pgtable_page_ctor() fail
Applying: xtensa: handle pgtable_page_ctor() fail
Applying: iommu/arm-smmu: handle pgtable_page_ctor() fail
Applying: xtensa: use buddy allocator for PTE table
Applying: mm: dynamically allocate page->ptl if it cannot be embedded to st=
ruct page
Applying: seq_file: introduce seq_setwidth() and seq_pad()
Applying: seq_file: remove "%n" usage from seq_file users
Applying: vsprintf: ignore %n again
Applying: drivers/rtc/rtc-hid-sensor-time.c: use dev_get_platdata()
Applying: drivers/rtc/rtc-hid-sensor-time.c: enable HID input processing ea=
rly
Applying: sched: replace INIT_COMPLETION with reinit_completion
Applying: tree-wide: use reinit_completion instead of INIT_COMPLETION
Applying: tree-wide-use-reinit_completion-instead-of-init_completion-fix
Applying: sched: remove INIT_COMPLETION
Applying: drivers/w1/masters/w1-gpio.c: use dev_get_platdata()
Applying: revert "softirq: Add support for triggering softirq work on softi=
rqs"
Applying: kernel: remove CONFIG_USE_GENERIC_SMP_HELPERS
Applying: kernel: provide a __smp_call_function_single stub for !CONFIG_SMP
Applying: kernel-provide-a-__smp_call_function_single-stub-for-config_smp-f=
ix
Applying: kernel: fix generic_exec_single indentation
Applying: llists: move llist_reverse_order from raid5 to llist.c
Applying: llists-move-llist_reverse_order-from-raid5-to-llistc-fix
Applying: kernel: use lockless list for smp_call_function_single
Applying: blk-mq: use __smp_call_function_single directly
Applying: sound/core/memalloc.c: use gen_pool_dma_alloc() to allocate iram =
buffer
Applying: kfifo: kfifo_copy_{to,from}_user: fix copied bytes calculation
Applying: kfifo API type safety
Applying: kfifo-api-type-safety-checkpatch-fixes
Merging akpm/master (6e8884c7ebfe kfifo-api-type-safety-checkpatch-fixes)

--Signature=_Fri__15_Nov_2013_16_24_55_+1100_uQcnYOhtOzjlhOkQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJShbAsAAoJEMDTa8Ir7ZwV5lAP/14XkPWrjLzgMzI+i26e7Bjn
bZas6OHd/PsfLcewB9Bt9Wwwqkq4KL0e6eCWbeaGK1ljXHbWruUGuHh/SdFKiRpa
0eI1InMb2UezKmZIDDXp2t4g60kiot8XSTBuszmAV5+PTyeaD6CGaI0XzzCnZwYQ
em1IXemSiGGuYxbTxSGxvqYPqh+q+28gcaf+hcINXo1RIV4gBdcPLKWrK3d3TN0N
yodOhr9Zl7nXG9j7n6T+xq3ti6qs+cmpK6hYHiewRl/vCFXJ7q2DvH9JKKaavJI2
jcEBij6iGCe/8CFWDp0rlkpE/O+fSs+Q3o8kQNMu+Kp8FCOkVICWkXDBgumzf90q
jfapRJdvcqAyV0lqtas/UO2zO/b6StMb2cxFjOPHXjc6ONjysfGKU1rO0SGdFGrf
RcHplUy/HL424CSuP5naBpn+P/zL/tp2CP3Q7oY5F9y9exAyW7fvr8QD8Kxkay6J
kH7NgkJcrX5O/w66tcV+loKH0tPNSusHW8rLsF00ZP5rEiu1ObxQt98IAaMYwIxu
9YD/eP23+vJzqvTAFaYmaMtLAySg/Z2Gudoap9T/Zb7+I6ltEVqwGpNBkwvBQbZo
tdkLh6vA8RN24mbfo/kq1y8b32JofcwQ1Ei0OKg/uA8mcmZPWBQW9RuLJ5YM47J8
kTtfnk6bA1YjI/xYAweo
=YezE
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Nov_2013_16_24_55_+1100_uQcnYOhtOzjlhOkQ--
