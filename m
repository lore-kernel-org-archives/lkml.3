Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaGAFm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:42:26 -0400
Received: from ozlabs.org ([103.22.144.67]:51206 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaGAFmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:42:22 -0400
Date: Tue, 1 Jul 2014 15:42:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jul 1
Message-ID: <20140701154214.311e726c@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mNbOwf1S0SR5BP8xI6KhpUH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mNbOwf1S0SR5BP8xI6KhpUH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The powerpc allyesconfig is again broken more than usual.

Changes since 20140630:

My fixes tree contains:
	powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

The net-next tree lost its build failure.

The staging tree still had its build failure for which I disabled a driver.

Non-merge commits (relative to Linus' tree): 2945
 2734 files changed, 108975 insertions(+), 100427 deletions(-)

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/next/ ).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" and checkout or reset to the new
master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64 and a
multi_v7_defconfig for arm. After the final fixups (if any), it is also
built with powerpc allnoconfig (32 and 64 bit), ppc44x_defconfig and
allyesconfig (this fails its final link) and i386, sparc, sparc64 and arm
defconfig.

Below is a summary of the state of the merge.

I am currently merging 222 trees (counting Linus' and 30 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Randy Dunlap for doing many randconfig builds.  And to Paul
Gortmaker for triage and bug fixes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master (16874b2cb867 Merge tag 'ext4_for_linus_stable' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4)
Merging fixes/master (b8accbbce667 powerpc: Disable RELOCATABLE for COMPILE=
_TEST with PPC64)
Merging kbuild-current/rc-fixes (c14105628b2e kbuild: fix a typo in a kbuil=
d document)
Merging arc-current/for-curr (89ca3b881987 Linux 3.15-rc4)
Merging arm-current/fixes (42309ab450b6 ARM: 8087/1: ptrace: reload syscall=
 number after secure_computing() check)
Merging m68k-current/for-linus (e8d6dc5ad26e m68k/hp300: Convert printk to =
pr_foo())
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging powerpc-merge/merge (6663a4fa6711 powerpc: Don't skip ePAPR spin-ta=
ble CPUs)
Merging sparc/master (894e552cfaa3 Merge branch 'for-linus' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging net/master (dba63115ce0c powerpc: bpf: Fix the broken LD_VLAN_TAG_P=
RESENT test)
Merging ipsec/master (a0e5ef53aac8 xfrm: Fix installation of AH IPsec SAs)
Merging sound-current/for-linus (a12137e779e1 ALSA: hda - Add a fixup for T=
hinkpad T540p)
Merging pci-current/for-linus (d066c946a866 PCI: Fix unaligned access in AF=
 transaction pending test)
Merging wireless/master (e055a6e20a91 Merge branch 'ath-current' of git://g=
ithub.com/kvalo/ath)
Merging driver-core.current/driver-core-linus (4c834452aad0 Linux 3.16-rc3)
Merging tty.current/tty-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging usb.current/usb-linus (8ecd93ab84ce Merge tag 'usb-serial-3.16-rc3'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/johan/usb-serial into usb=
-linus)
Merging usb-gadget-fixes/fixes (8035691365b8 usb: musb: dsps: fix the base =
address for accessing the mode register)
Merging usb-serial-fixes/usb-linus (660856948664 MAINTAINERS: update e-mail=
 address)
Merging staging.current/staging-linus (6b64168de843 Merge tag 'iio-fixes-fo=
r-3.16b' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (a497c3ba1d97 Linux 3.16-rc2)
Merging input-current/for-linus (31972f6e517d Input: ti_am335x_tsc - warn a=
bout incorrect spelling)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (cfe82d4f45c7 crypto: sha512_ssse3 - fix byte=
 count to bit count conversion)
Merging ide/master (5b40dd30bbfa ide: Fix SC1200 dependencies)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (4b660a7f5c80 Linux 3.15-rc6)
Merging rr-fixes/fixes (79465d2fd48e module: remove warning about waiting m=
odule removal.)
Merging mfd-fixes/master (73beb63d290f mfd: rtsx_pcr: Disable interrupts be=
fore cancelling delayed works)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging drm-intel-fixes/for-linux-next-fixes (84b4e042c470 drm/i915: only a=
pply crt_present check on VLV)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (4c834452aad0 Linux 3.16-rc3)
Merging arm/for-next (43132894a1d3 Merge branches 'fixes' and 'misc' into f=
or-next)
Merging arm-perf/for-next/perf (7171511eaec5 Linux 3.16-rc1)
Merging arm-soc/for-next (3464a486dcc1 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (251f72d06c59 Merge branch 'berlin/soc' into=
 berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (63be6d54de54 Merge branch 'imx/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-imx/Kconfig
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (afc3458c9e48 Merge branch 'mvebu/fixes' into mvebu/=
for-next)
CONFLICT (content): Merge conflict in arch/arm/mach-mvebu/Kconfig
Merging renesas/next (52e97c7257a8 Merge branch 'heads/dt-for-v3.17' into n=
ext)
Merging samsung/for-next (053341b6993a Merge branch 'v3.16-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (e4b376f6d565 Merge branches 'sunxi/dt-for-3.1=
7' and 'sunxi/core-for-3.17' into sunxi-next)
Merging tegra/for-next (8eec8a12841a Merge branch for-3.17/defconfig into f=
or-next)
Merging arm64/for-next/core (e3a920afc348 arm64: mm: remove broken &=3D ope=
rator from pmd_mknotpresent)
Merging blackfin/for-linus (51fdc6bf9880 blackfin: defconfigs: add MTD_SPI_=
NOR (new dependency for M25P80))
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (e32634f5d57f pstore: Fix memory leak when decompress usi=
ng big_oops_buf)
Merging m68k/for-next (e8d6dc5ad26e m68k/hp300: Convert printk to pr_foo())
Merging m68knommu/for-next (9a1a1aea7572 m68knommu: Remove unnecessary prot=
otype for kobjsize())
Merging metag/for-next (8bc613befaec metag: hugetlbpage: Remove null pointe=
r checks that could never happen)
Merging microblaze/next (225fba216261 microblaze: Fix typo in head.S s/subs=
tract/subtract/)
Merging mips/mips-for-linux-next (763fec3290bd Merge branch '3.16-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (455c6fdbd219 Linux 3.14)
Merging powerpc/next (68986c9f0f45 Revert "offb: Add palette hack for littl=
e endian")
Merging fsl/next (087dfae3fe3f powerpc/8xx: Remove empty asm/mpc8xx.h)
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (c60d0baa40f9 s390/3270: correct size detection with =
the read-partition command)
Merging sparc-next/master (894e552cfaa3 Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging tile/master (8dfb6948f7d8 tile: use ARRAY_SIZE)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (55b441be5cd6 xtensa: ISS: don't depend on CONFIG_T=
TY)
Merging btrfs/next (c7548af69d9e Btrfs: convert smp_mb__{before,after}_clea=
r_bit)
Merging ceph/master (437f2c0d0c01 rbd: fix ida/idr memory leak)
Merging cifs/for-next (24094fc715a4 cifs: Split lanman auth from CIFS_SessS=
etup())
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (9e78d14a9f64 Use %pd in eCryptFS)
Merging ext3/for_next (19ef1229bc2e reiserfs: Fix compilation breakage with=
 CONFIG_REISERFS_CHECK)
Merging ext4/dev (14b02deff1ae [regression] fix 32-bit breakage in block de=
vice read(2))
Merging f2fs/dev (c232989475f6 f2fs: check bdi->dirty_exceeded when trying =
to skip data writes)
Merging fscache/fscache (fe02fb3ec109 FS-Cache: Handle removal of unadded o=
bject to the fscache_object_list rb tree)
Merging fuse/for-next (1560c974dcd4 fuse: add renameat2 support)
Merging gfs2/master (7b596840397a GFS2: Allow caching of glocks for flock)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (f15b5041440c FS/NFS: replace count*size kzalloc by =
kcalloc)
Merging nfsd/nfsd-next (044305d1cb10 nfsd: Avoid taking state_lock while ho=
lding inode lock in nfsd_break_one_deleg)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (a497c3ba1d97 Linux 3.16-rc2)
Merging xfs/for-next (2451337dd043 xfs: global error sign conversion)
Merging file-private-locks/linux-next (a497c3ba1d97 Linux 3.16-rc2)
Merging vfs/for-next (cd67b9ac44ea switch iov_iter_get_pages() to passing m=
aximal number of pages)
Merging pci/next (7171511eaec5 Linux 3.16-rc1)
Merging hid/for-next (0ee3e1aef4f2 Merge branch 'for-3.17/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (2fd6cf0523fc i2c: taos-evm: Use module_serio_driv=
er())
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (f719604dd06f hwmon: (lm63) Fix smatch war=
nings)
Merging v4l-dvb/master (ac35b35b30aa Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (bfbf2e950ac8 Merge branch 'kbuild/rc-fixes' into k=
build/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (848d71cd1183 Merge branch 'for-3.17' into for-next)
Merging pm/linux-next (8c8f4a5571e4 Merge branch 'acpica' into linux-next)
Merging idle/next (23a299cd9378 Merge branches 'turbostat' and 'intel_idle'=
 into release)
Merging apm/for-next (158204397034 apm-emulation: add hibernation APM event=
s to support suspend2disk)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (a497c3ba1d97 Linux 3.16-rc2)
Merging ieee1394/for-next (165d560bb267 Merge branch 'master' into for-next)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (4c834452aad0 Linux 3.16-rc3)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (4135ab820804 tcp: tcp_conn_request: fix build erro=
r when IPv6 is disabled)
Merging ipsec-next/master (1759389e8af4 xfrm4: Remove duplicate semicolon)
Merging wireless-next/master (c64800e772a0 wireless: mwifiex: Use the prope=
r interfaces)
Merging bluetooth/master (70dddb56d491 Bluetooth: constify seq_operations)
CONFLICT (content): Merge conflict in net/bluetooth/smp.c
CONFLICT (content): Merge conflict in net/bluetooth/mgmt.c
CONFLICT (content): Merge conflict in net/bluetooth/hci_conn.c
Merging infiniband/for-next (eeaddf3670d4 Merge branches 'core', 'cxgb3', '=
cxgb4', 'iser', 'iwpm', 'misc', 'mlx4', 'mlx5', 'noio', 'ocrdma', 'qib', 's=
rp' and 'usnic' into for-next)
Merging mtd/master (7171511eaec5 Linux 3.16-rc1)
Merging l2-mtd/master (7171511eaec5 Linux 3.16-rc1)
Merging crypto/master (8f312d64b5ee crypto: qat - Fix error path crash when=
 no firmware is present)
Merging drm/drm-next (bc1dfff04a5d Merge branch 'drm-nouveau-next' of git:/=
/anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next)
Merging drm-panel/drm/panel/for-next (7e40b5162b3c drm/panel: make DRM_PANE=
L_LD9040 depend on SPI)
Merging drm-intel/for-linux-next (91565c85b66d drm/i915: Don't try to look =
up object for non-existent fb)
Merging drm-tegra/drm/tegra/for-next (1f64ae7c5af0 drm/tegra: sor - Remove =
obsolete comment)
Merging sound/for-next (e8750940ce34 ALSA: hda - Fix invalid function call =
in snd_hda_add_vmaster())
Merging sound-asoc/for-next (1ee4fbc85523 Merge remote-tracking branches 'a=
soc/topic/wm0010', 'asoc/topic/wm8904' and 'asoc/topic/wm8985' into asoc-ne=
xt)
Merging modules/modules-next (4982223e51e8 module: set nx before marking mo=
dule MODULE_STATE_COMING.)
Merging virtio/virtio-next (c77fba9ab058 virtio_scsi: don't call virtqueue_=
add_sgs(... GFP_NOIO) holding spinlock.)
Merging input/next (68807a0c2015 Input: atmel_mxt_ts - fix invalid return f=
rom mxt_get_bootloader_version)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (8e3c77637c65 Merge branch 'for-linus' into for-next)
Merging device-mapper/for-next (cbc228137bbf dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (9ed6566b6c2a mmc: sdhci: Remove blank line)
Merging kgdb/kgdb-next (6bedf31c25dd kdb: Remove unhandled ssb command)
Merging slab/for-next (201ed0edb712 Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (053f5b6525ae raid5: speedup sync_request processing)
Merging mfd/master (90b128ed1557 Merge tag 'mfd-lee-3.13-3' of git://git.li=
naro.org/people/ljones/mfd)
Merging mfd-lj/for-mfd-next (c46f5d80d101 mfd: ab8500-debugfs.c: Cleaning u=
p values that are never used)
Merging battery/master (ac323d8d8070 power: max17040: Fix NULL pointer dere=
ference when there is no platform_data)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (8ca900e16b2b drivers/video/fbdev/sis: Add missi=
ng else)
Merging regulator/for-next (fc65170b7c15 Merge remote-tracking branches 're=
gulator/topic/tps6586x' and 'regulator/topic/twl' into regulator-next)
Merging security/next (f01387d26938 Merge commit 'v3.15' into next)
Merging integrity/next (0430e49b6e7c ima: introduce ima_kernel_read())
Merging selinux/next (f31e79945965 selinux: no recursive read_lock of polic=
y_rwlock in security_genfs_sid())
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (7171511eaec5 Linux 3.16-rc1)
Merging iommu/next (d73a6d722a67 iommu/amd: Fix small race between invalida=
te_range_end/start)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (fd49c81f080a drivers/vfio/pci: Fix wrong MSI interrupt c=
ount)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (d31e373d0778 irq-gic: remove file name from headi=
ng comment)
CONFLICT (content): Merge conflict in arch/arm/mach-msm/Kconfig
Merging audit/master (3efe33f5d2da audit: x86: drop arch from __audit_sysca=
ll_entry() interface)
CONFLICT (content): Merge conflict in kernel/audit.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/mips/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/mips/include/asm/syscall.h
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (c9e0fb3bb3aa tty: Update hypervisor tty=
 drivers to use core stdout parsing code.)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging spi/for-next (e2aff4c029d1 Merge remote-tracking branches 'spi/topi=
c/orion', 'spi/topic/qup' and 'spi/topic/rspi' into spi-next)
Merging tip/auto-latest (35299db412b6 Merge branch 'x86/xsave')
Merging clockevents/clockevents/next (2529c3a33079 clocksource: Add Freesca=
le FlexTimer Module (FTM) timer support)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (6866b390562b EDAC, edac_module.c: Remove unneces=
sary test on unsigned value)
Merging irqchip/irqchip/for-next (49891eec2937 Merge branch 'irqchip/crossb=
ar' into irqchip/for-next)
Merging ftrace/for-next (fb6bab6a5ad4 tracing/uprobes: Fix the usage of upr=
obe_buffer_enable() in probe_event_enable())
Merging rcu/rcu/next (cd4775e7e74c rcu: Change rcu_dereference_check(c) to =
check "c" first)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (9f6226a762c7 arch: x86: kvm: x86.c: Cleaning up var=
iable is set more than once)
Merging kvm-arm/next (1252b3313642 arm64: KVM: Enable minimalistic support =
for Cortex-A53)
Merging kvm-ppc/kvm-ppc-next (5c02c392cd23 Merge tag 'virtio-next-for-linus=
' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (77945ca73e9a x86/xen: map foreign pfns for auto=
translated guests)
Merging percpu/for-next (2d7227828e14 percpu-refcount: implement percpu_ref=
_reinit() and percpu_ref_is_zero())
Merging workqueues/for-next (4a9242884da5 Merge branch 'for-3.16-fixes' int=
o for-next)
Merging drivers-x86/linux-next (f82bdd0d77b6 hp-wmi: Enable hotkeys on some=
 systems)
Merging chrome-platform/for-next (2b8454a75b90 platform/chrome: unregister =
platform driver/device when module exit)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (4c834452aad0 Linux 3.16-rc3)
Merging hsi/for-next (b357d7b58f37 hsi: omap_ssi_port: use normal module re=
fcounting)
Merging leds/for-next (44a1255b03ae leds: lp55xx-common: fix attribute-crea=
tion race)
Merging driver-core/driver-core-next (c9d53c0f2d23 devres: remove devm_requ=
est_and_ioremap())
Merging tty/tty-next (a497c3ba1d97 Linux 3.16-rc2)
Merging usb/usb-next (d6759133e981 usb: xhci: Correct last context entry ca=
lculation for Configure Endpoint)
Merging usb-gadget/next (7751b6fb0586 usb: musb: tusb6010: Use musb->tusb_r=
evision instead of tusb_get_revision call.)
Merging usb-serial/usb-next (4c834452aad0 Linux 3.16-rc3)
Merging staging/staging-next (c047b443ac33 staging: gdm72xx: use lower case=
 for variable names for consistency)
Applying: staging: board: disable
Merging char-misc/char-misc-next (6b5fa7760835 w1: select crc16 library for=
 ds2406)
CONFLICT (content): Merge conflict in drivers/w1/masters/mxc_w1.c
Merging cgroup/for-next (3a32bd72d770 cgroup: fix a race between cgroup_mou=
nt() and cgroup_kill_sb())
Merging scsi/for-next (eed78c36555c Merge remote-tracking branch 'scsi-queu=
e/core-for-3.17' into for-next)
Merging scsi-core/core-for-3.16 (7bafc240e126 scsi: use the scsi data buffe=
r length to extract transfer size)
Merging scsi-drivers/drivers-for-3.16 (8faeb529b2da virtio-scsi: fix variou=
s bad behavior on aborted requests)
Merging target-updates/for-next (a497c3ba1d97 Linux 3.16-rc2)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (4aba0a02ff80 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (bd88acba5f98 remoteproc/ste_modem: staticize l=
ocal symbols)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (0fb394122af4 gpio: pxa: Make of_device_id array cons=
t)
Merging dma-mapping/dma-mapping-next (f70e3c4f8b6a CMA: correct unlock targ=
et)
Merging pwm/for-next (39fd3f99aba3 pwm: fsl-ftm: set pwm_chip can_sleep fla=
g)
Merging dma-buf/for-next (dfb945473ae8 Merge git://www.linux-watchdog.org/l=
inux-watchdog)
Merging userns/for-next (3efe1ac78e99 vfs: Block intuitively in the case of=
 BSD accounting files)
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/namei.c
CONFLICT (content): Merge conflict in fs/dcache.c
CONFLICT (content): Merge conflict in fs/btrfs/ioctl.c
Merging ktest/for-next (4c16b1d6d5e0 ktest: Update documentation on config_=
bisect)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (27b8d5f723e6 clk: flatten clk tree in debugfs)
Merging random/dev (5458c2fecbb8 hw_random: fix sparse warning (NULL vs 0 f=
or pointer))
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (855ef0dec727 aio: kill the misleading rcu read locks in=
 ioctx_add_table() and kill_ioctx())
Merging llvmlinux/for-next (f9da455b93f6 Merge git://git.kernel.org/pub/scm=
/linux/kernel/git/davem/net-next)
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (d5be754bfca4 Object-like macros are different than =
function-like macros: https://gcc.gnu.org/onlinedocs/cpp/Object-like-Macros=
.html https://gcc.gnu.org/onlinedocs/cpp/Function-like-Macros.html)
Merging akpm-current/current (3e854aac314c lib/scatterlist: clean up useles=
s architecture versions of scatterlist.h)
Applying: printk-allow-increasing-the-ring-buffer-depending-on-the-number-o=
f-cpus-fix
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: init/main.c: code clean-up
Applying: arch/arm/mach-omap2: replace strict_strto* with kstrto*
Applying: arch/arm/mach-pxa: replace strict_strto call with kstrto
Applying: arch/arm/mach-s3c24xx/mach-jive.c: replace strict_strto* with kst=
rto*
Applying: arch/arm/mach-w90x900/cpu.c: replace obsolete strict_strto
Applying: arch/powerpc: replace obsolete strict_strto* calls
Applying: arch/x86: replace strict_strto calls
Applying: drivers/scsi: replace strict_strto calls
Applying: net/sunrpc: replace strict_strto calls
Applying: include/linux: remove strict_strto* definitions
Applying: pci-dma-compat: add pci_zalloc_consistent helper
Applying: atm: use pci_zalloc_consistent
Applying: block: use pci_zalloc_consistent
Applying: crypto: use pci_zalloc_consistent
Applying: infiniband: use pci_zalloc_consistent
Applying: i810: use pci_zalloc_consistent
Applying: media: use pci_zalloc_consistent
Applying: amd: use pci_zalloc_consistent
Applying: atl1e: use pci_zalloc_consistent
Applying: enic: use pci_zalloc_consistent
Applying: sky2: use pci_zalloc_consistent
Applying: micrel: use pci_zalloc_consistent
Applying: qlogic: use pci_zalloc_consistent
Applying: irda: use pci_zalloc_consistent
Applying: ipw2100: use pci_zalloc_consistent
Applying: mwl8k: use pci_zalloc_consistent
Applying: rtl818x: use pci_zalloc_consistent
Applying: rtlwifi: use pci_zalloc_consistent
Applying: scsi: use pci_zalloc_consistent
Applying: staging: use pci_zalloc_consistent
Applying: synclink_gt: use pci_zalloc_consistent
Applying: vme: bridges: use pci_zalloc_consistent
Applying: drivers/net/ethernet/amd/pcnet32.c: neaten and remove unnecessary=
 OOM messages
Applying: kernel/kprobes.c: convert printk to pr_foo()
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: mm-replace-remap_file_pages-syscall-with-emulation-fix
Applying: mm: remap_file_pages: initialize populate before usage
Applying: mm: remap_file_pages: grab file ref to prevent race while mmaping
Applying: memcg: deprecate memory.force_empty knob
Applying: memcg-deprecate-memoryforce_empty-knob-fix
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: zero out seek range on _fat_get_block
Applying: fat: fallback to buffered write in case of fallocated region on d=
irect IO
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (3c411e84eafd mm: add strictlimit knob)

--Sig_/mNbOwf1S0SR5BP8xI6KhpUH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTsko7AAoJEMDTa8Ir7ZwV0y0P/i9ij0IuxP8lT1oQsFRqF1CO
RnC7ZRfUg9yJyzxLhfSojrsCTP/xdUCxB6j+1+8iT4rVk1eKGZ4CTQ4t5hUk8rxD
WezoCIVtXVBDhcsaKjfgCyS/KMOgGG7sra+S9cfmxQqJ5l1iEv3/zSNtnCyQPSr8
3U9k8uP+5yTiFS5ZsarQ8FuH+/L8mbm8buWthkRZE0Z5WoSirT+J8rilg4tYs5LG
yWeUa8SnugdfayJMa7aTAbGqUgCru+/d8UAY+E65epXeUZ9vorrSXtAOor3DLbxk
Zn0wKXbQ4lAlzd5fzYGH1jliPsQnehytdO2livYBBQsXVK1nDt7bFXI1ZCu72PfX
YOm4aSvH7Eo2wJBvoEhmlRvbsD4yXSkrrxk995Cy7ladq6zR4yo36sV9qpfSrCit
qtkWEJop5NN4HV+F3EXYDxItiaCHjd/wITPKVPw6LvXFOJBc7nNkxjKA75fnlljY
k7WGLS0thvyYyY5/A5iXmmpdjrwflFpJCCNAs9iGg9cdIOn78yiUtN2OKzuh+YR8
KEicF1qghs0JLKFyOQjSzaycVD++378wMT9u2/CnCCVQITDWuMpgo8jk/pZ6cBQl
idIgP772Jh15dtgXDqwJezDORhrdQf/nKxF4tBnjLsJleQwWimZcPfmsDoqQpeIX
j/A4BuPu6yrL+uH7yXTy
=jmRH
-----END PGP SIGNATURE-----

--Sig_/mNbOwf1S0SR5BP8xI6KhpUH--
