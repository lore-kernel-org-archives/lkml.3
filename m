Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3KSDkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:40:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50317 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3KSDkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:40:05 -0500
Date: Tue, 19 Nov 2013 14:39:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Nov 19
Message-Id: <20131119143954.74186994a2e977f244ac95e0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Nov_2013_14_39_54_+1100_TDUmy/4IF/078cv3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Nov_2013_14_39_54_+1100_TDUmy/4IF/078cv3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do *not* add any v3.14 material to linux-next until after
v3.13-rc1 is released.

Changes since 20131118:

The nfs tree lost its build failure but gained another for which I
reverted a commit.

The gpio tree gained a conflict against the pm tree.

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
Merging origin/master (2d3c627502f2 Revert "init/Kconfig: add option to dis=
able kernel compression")
Merging fixes/master (2d3c627502f2 Revert "init/Kconfig: add option to disa=
ble kernel compression")
Merging kbuild-current/rc-fixes (19514fc665ff arm, kbuild: make "make insta=
ll" not depend on vmlinux)
Merging arc-current/for-curr (737d5b980be8 ARC: [plat-arcfpga] defconfig up=
date)
Merging arm-current/fixes (9170217510cd ARM: 7888/1: seccomp: not compatibl=
e with ARM OABI)
Merging m68k-current/for-linus (77a42796786c m68k: Remove deprecated IRQF_D=
ISABLED)
Merging metag-fixes/fixes (3b2f64d00c46 Linux 3.11-rc2)
Merging powerpc-merge/merge (8b5ede69d24d powerpc/irq: Don't switch to irq =
stack from softirq stack)
Merging sparc/master (6a328f3fe042 sparc64: merge fix)
Merging net/master (d11a347de3f5 be2net: Delete secondary unicast MAC addre=
sses during be_close)
Merging ipsec/master (be408cd3e1fe Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging sound-current/for-linus (2793769f4450 ALSA: hda - Enable mute/mic-m=
ute LEDs for more Thinkpads with Realtek codec)
Merging pci-current/for-linus (a2c8f94ffa84 Revert "workqueue: allow work_o=
n_cpu() to be called recursively")
Merging wireless/master (3b1bace9960b brcmfmac: fix possible memory leak)
Merging driver-core.current/driver-core-linus (31d141e3a666 Linux 3.12-rc6)
Merging tty.current/tty-linus (6e757ad2c92c tty/serial: at91: fix uart/usar=
t selection for older products)
Merging usb.current/usb-linus (e1466ad5b1ae USB: serial: ftdi_sio: add id f=
or Z3X Box device)
Merging staging.current/staging-linus (31d141e3a666 Linux 3.12-rc6)
Merging char-misc.current/char-misc-linus (31d141e3a666 Linux 3.12-rc6)
Merging input-current/for-linus (42249094f794 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (f262f0f5cad0 crypto: s390 - Fix aes-cbc IV c=
orruption)
CONFLICT (content): Merge conflict in drivers/crypto/caam/jr.c
Merging ide/master (c2f7d1e103ef ide: pmac: remove unnecessary pci_set_drvd=
ata())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (44033109e99c SH: Convert out[bwl] ma=
cros to inline functions)
Merging devicetree-current/devicetree/merge (1931ee143b0a Revert "drivers: =
of: add initialization code for dma reserved memory")
Merging rr-fixes/fixes (f6537f2f0eba scripts/kallsyms: filter symbols not i=
n kernel address space)
Merging mfd-fixes/master (ed2fe55fd91e mfd: ti-ssp: Fix build)
Merging vfio-fixes/for-linus (d93b3ac0edb8 VFIO: vfio_iommu_type1: fix bug =
caused by break in nested loop)
Merging drm-intel-fixes/for-linux-next-fixes (1fbc0d789d12 drm/i915: Fix th=
e PPT fdi lane bifurcate state handling on ivb)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (cd5dfd0e1685 ARC: [plat-arcfpga] Add defconfig withou=
t initramfs location)
Merging arm/for-next (9170217510cd ARM: 7888/1: seccomp: not compatible wit=
h ARM OABI)
Merging arm-perf/for-next/perf (15c03dd4859a Linux 3.12-rc3)
Merging arm-soc/for-next (ed06ce4d7f8e Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (7d132055814e Linux 3.10-rc6)
Merging cortex-m/for-next (9c031a483646 ARM: v7-M: drop using mach/entry-ma=
cro.S)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (8a58ffd6f70e Merge branches 'imx/fixes', 'imx/soc=
' and 'imx/dt' into for-next)
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
CONFLICT (content): Merge conflict in MAINTAINERS
Merging arm64/upstream (67317c268956 ARM64: /proc/interrupts: display IPIs =
of online CPUs only)
Merging blackfin/for-linus (36855dcfc980 blackfin: fix build warning for un=
used variable)
Merging c6x/for-linux-next (546153d75a48 c6x: fix build failure caused by c=
ache.h)
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
Merging mips/mips-for-linux-next (6ca0bf323c14 Merge branch '3.13-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (60a9dd5a10a1 openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (582c42ae14c4 parisc: improve SIGBUS/SIGSEGV err=
or reporting)
Merging powerpc/next (0c4888ef1d8a powerpc: Fix fatal SLB miss when restori=
ng PPR)
Merging mpc5xxx/next (7e198197ec87 powerpc/mpc512x: remove unnecessary #if)
Merging galak/next (9e2ecdbba3b0 powerpc/fsl-booke: add the reg prop for pc=
i bridge device node for T4/B4)
Merging s390/features (d795ddad36cb s390/pci: implement hotplug notificatio=
ns)
Merging sh/sh-latest (37284bd93103 Merge branches 'sh/hw-breakpoints' and '=
sh/serial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in drivers/tty/serial/sh-sci.c
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (049ffa8ab33a Merge branch 'drm-next' of git://pe=
ople.freedesktop.org/~airlied/linux)
Merging tile/master (9248053f80fd tile: Remove tile-specific _sinitdata and=
 _einitdata)
Merging unicore32/unicore32 (c284464658ac arch/unicore32: remove CONFIG_EXP=
ERIMENTAL)
Merging xtensa/for_next (8872366df396 xtensa: Fix broken allmodconfig build)
Merging btrfs/next (91aef86f3b8a Btrfs: rename btrfs_start_all_delalloc_ino=
des)
Merging ceph/master (53d028160f1a ceph: implement readv/preadv for sync ope=
ration)
Merging cifs/for-next (7d3fb24bce87 Removed duplicated (and unneeded) goto)
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
Merging nfs/linux-next (c7a153886d9c NFS: Fix a warning in nfs_setsecurity)
[master 6b83b9174ef7] Revert "NFS: Enabling v4.2 should not recompile nfsd =
and lockd"
Merging nfsd/nfsd-next (aea240f4162d nfsd: export proper maximum file size =
to the client)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (481335b4a8e9 Squashfs: Check stream is not NULL in=
 decompressor_multi.c)
Merging v9fs/for-next (3b1288170cfe net/9p: remove virtio default hack and =
set appropriate bits instead)
CONFLICT (content): Merge conflict in fs/9p/vfs_inode_dotl.c
CONFLICT (content): Merge conflict in fs/9p/vfs_inode.c
CONFLICT (content): Merge conflict in fs/9p/vfs_file.c
Merging ubifs/linux-next (58a4e23703b2 UBIFS: correct data corruption range)
Merging xfs/for-next (2fe8c1c08b3f xfs: open code inc_inode_iversion when l=
ogging an inode)
Merging vfs/for-next (27ac0ffeac80 locks: break delegations on any attribut=
e modification)
Merging pci/next (eaaeb1cb3331 Merge branch 'pci/misc' into next)
Merging hid/for-next (bceac5d94bbe Merge branch 'for-3.13/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (cfff1f4a9367 i2c: bcm-kona: fix error return code=
 in bcm_kona_i2c_probe())
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Applying: i2c: bcm-kona: fix for INIT_COMPLETION -> reinit_completion API c=
hange
Merging jdelvare-hwmon/master (f63c4824aa1b Don't try to compile shmobile-i=
ommu outside of ARM)
Merging hwmon-staging/hwmon-next (308c91dd83a2 hwmon: (nct6775) NCT6791 sup=
ports weight control only for CPUFAN)
Merging v4l-dvb/master (52eca34d5e35 Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (e6483a58eca6 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (4eae518d4b01 localmodconfig: Fix localyesconfig t=
o set to 'y' not 'm')
Merging libata/for-next (1ca953d5f992 Merge branch 'for-3.13' into for-next)
Merging pstore/master (bd08ec33b5c2 pstore/ram: Restore ecc information blo=
ck)
Merging pm/linux-next (7072d0aa29ce Merge branch 'pm-sleep')
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
Merging slave-dma/next (df12a3178d34 Merge commit 'dmaengine-3.13-v2' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine)
Merging dmaengine/next (82a1402eaee5 dma: mv_xor: Fix mis-usage of mmio 'ba=
se' and 'high_base' registers)
Merging net-next/master (42a2d923cc34 Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net-next)
Merging ipsec-next/master (9bb8ca86075f virtio-net: switch to use XPS to ch=
oose txq)
Merging wireless-next/master (3c57e865cfb2 ath9k: enable DFS for IBSS mode)
Merging bluetooth/master (c2e1182218ac Bluetooth: Enable autosuspend for In=
tel Bluetooth device)
Merging infiniband/for-next (b4fdf52b3fc8 Merge branches 'cma', 'cxgb4', 'f=
lowsteer', 'ipoib', 'misc', 'mlx4', 'mlx5', 'nes', 'ocrdma', 'qib' and 'srp=
' into for-next)
Merging mtd/master (82cb6acea4d1 Merge tag 'for-linus-20131112' of git://gi=
t.infradead.org/linux-mtd)
Merging l2-mtd/master (82cb6acea4d1 Merge tag 'for-linus-20131112' of git:/=
/git.infradead.org/linux-mtd)
Merging crypto/master (f262f0f5cad0 crypto: s390 - Fix aes-cbc IV corruptio=
n)
Merging drm/drm-next (a3483353ca4e drm: check for !kdev in drm_unplug_minor=
())
Merging drm-intel/for-linux-next (1d37b689b1c0 drm/i915: encoder->get_confi=
g is no longer optional)
Merging drm-tegra/drm/for-next (977386a04bae drm/tegra: Reserve syncpoint b=
ase for gr3d)
Merging sound/for-next (2793769f4450 ALSA: hda - Enable mute/mic-mute LEDs =
for more Thinkpads with Realtek codec)
Merging sound-asoc/for-next (a190f7867e18 Merge remote-tracking branch 'aso=
c/fix/wm8962' into asoc-linus)
Merging modules/modules-next (b6568b1a19ad modpost: fix bogus 'exported twi=
ce' warnings.)
Merging virtio/virtio-next (cdd77e87eae5 x86, asmlinkage, lguest: Pass in g=
lobals into assembler statement)
Merging input/next (87c542daf6c9 Input: add sur40 driver for Samsung SUR40 =
(aka MS Surface 2.0/Pixelsense))
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging cgroup/for-next (0d60e6cd793e Merge branch 'for-3.13' into for-next)
Merging block/for-next (6decb5fa33f8 Merge branch 'for-3.13/drivers' into f=
or-next)
Merging aio-direct/for-next (bb6f7be48318 tmpfs: add support for read_iter =
and write_iter)
CONFLICT (content): Merge conflict in mm/filemap.c
CONFLICT (content): Merge conflict in include/linux/blk_types.h
CONFLICT (content): Merge conflict in fs/read_write.c
CONFLICT (content): Merge conflict in fs/nfs/file.c
CONFLICT (content): Merge conflict in fs/nfs/direct.c
CONFLICT (content): Merge conflict in fs/btrfs/inode.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/nandsim.c
Applying: ceph: Fix up for iov_iter changes
Merging device-mapper/for-next (c00c25d0b694 dm cache policy mq: use list_d=
el_init instead of list_del + INIT_LIST_HEAD)
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
Merging md/for-next (401c6ed7752f md/raid5: Use conf->device_lock protect c=
hanging of multi-thread resources.)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (ab73a59c0db8 mfd: cros ec: spi: Fix debug outp=
ut)
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
Merging watchdog/master (cb81b125733d watchdog: w83627hf: Use helper functi=
ons to access superio registers)
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
Merging audit/master (9175c9d2aed5 audit: fix type of sessionid in audit_se=
t_loginuid())
CONFLICT (content): Merge conflict in fs/exec.c
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (355e62f5ad12 of/irq: Fix potential buff=
er overflow)
Merging dt-rh/for-next (c11eede69b6a powerpc: add missing explicit OF inclu=
des for ppc)
Merging spi/for-next (aaeef765f79f Merge remote-tracking branch 'spi/fix/tx=
x9' into spi-linus)
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
Merging kvm/linux-next (f08048048802 Merge tag 'for-linus' of git://git.ker=
nel.org/pub/scm/virt/kvm/kvm)
Merging kvm-arm/kvm-arm-next (ede582224231 Merge tag 'kvm-arm64/for-3.13-1'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms into kv=
m-next)
Merging kvm-ppc/kvm-ppc-next (a78b55d1c021 kvm: powerpc: book3s: drop is_hv=
_enabled)
Merging oprofile/for-next (8884754b2534 Merge branch 'edac' into for-next)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (99df053439f5 Merge branch 'xentip-3.13-2' into =
linux-next-2)
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
Merging target-updates/for-next (a6b232ca31d6 percpu-refcount: Add percpu-r=
efcount.o to obj-y)
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
Merging gpio/for-next (143163367f57 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in drivers/gpio/gpiolib.c
Merging dma-mapping/dma-mapping-next (5e01dc7b26d9 Linux 3.12)
Merging pwm/for-next (1b3f25ce991d Documentation/pwm: Update supported SoC =
name for pwm-samsung)
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
CONFLICT (content): Merge conflict in mm/huge_memory.c
CONFLICT (add/add): Merge conflict in lib/percpu_test.c
CONFLICT (content): Merge conflict in kernel/Makefile
CONFLICT (content): Merge conflict in include/linux/lglock.h
CONFLICT (content): Merge conflict in fs/hfsplus/xattr.c
CONFLICT (content): Merge conflict in fs/cramfs/Kconfig
CONFLICT (content): Merge conflict in fs/autofs4/inode.c
CONFLICT (content): Merge conflict in fs/anon_inodes.c
CONFLICT (content): Merge conflict in drivers/memstick/core/ms_block.c
CONFLICT (content): Merge conflict in arch/x86/mm/init.c
Applying: lglock: fixup for code movement
Applying: mm: fix bad merge of mmap.c
$ git checkout -b akpm remotes/origin/akpm/master
Merging akpm/master (748b7b2ba21d Merge branch 'akpm-current/current')

--Signature=_Tue__19_Nov_2013_14_39_54_+1100_TDUmy/4IF/078cv3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSit2OAAoJEMDTa8Ir7ZwVYX4P/iJuI41r1N6dSZrCVMV3bBVu
SR0od3QP1MF45LEHFNr4xYqw5F6OMaFsRuQQ4IJxmvKYam9gUIxSeqO4xxsuB+cs
oPBCOzlVKaEbJmyBhIjrK5vxgOf/eBNwZZ2PxqC55pvYCygawjSyAKJZPzjzsPql
PadE0g7keioEpOb+Jj+q4mpinw67NJZEfuqDSin7hHHVRrx/Z/umR5qdXymZjX3+
rSxx5Zhrr4e8zL6pnI2XqDHt9PS+P7aE5l7KDMgaSkNF7xdgCxXOrVb0A/MM6QOB
VYlggwjms/DkchcwsrWRYc+LPh5CHFHKSFsABY9bbg1ccqnFjZr2kS1HcCvchpV/
n1U0kBj4gK4K7Bcj0HvoYc2QEi+HsQZDa01J1w6XItyd5C97XnwZqFsDOkWpuOFo
tGknnEew24+jx8Qb5+ZqsoSsA8+80Oa3t3L2uA0typ9DN6oGTTbJFCWeNVM6Tkui
itBn2OsPkthhY4RwQHQ0y3duiCE1pVvaaBCL09eKpT0pb/IhcN2PJerGAGrZXCWP
wNu3j2LmnFcbPQ6QAr/x/gZLCWhLUwlBhlbkVvM9nvsc4t29ClVglUlpX2UVGIzX
dvREaOfoO0FbK7gjEHFzNUq6FGAZHLo1L1/WsnkLXa14IeTgFmpWZTtu7WrajKr1
KX8LdOn1xqOo6wqearZ4
=Lfl3
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Nov_2013_14_39_54_+1100_TDUmy/4IF/078cv3--
