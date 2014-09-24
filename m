Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbaIXJKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:10:37 -0400
Received: from ozlabs.org ([103.22.144.67]:35910 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaIXJKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:10:23 -0400
Date: Wed, 24 Sep 2014 19:10:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 24
Message-ID: <20140924191013.7d3912c3@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Rv21c92on=fQVgFQzKkp+8Q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Rv21c92on=fQVgFQzKkp+8Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20140923:

My fixes tree contains:
	mips: Set CONFIG_NET=3Dy in defconfigs
	parisc: Set CONFIG_NET=3Dy in defconfigs
	powerpc: Set CONFIG_NET=3Dy in defconfigs
	sh: Set CONFIG_NET=3Dy in defconfigs
	sparc: Set CONFIG_NET=3Dy in defconfigs

The samsung tree gained build failures so I used the version from
next-20140923.

The tip tree gained conflicts against the audit tree.

The tiny tree lost its build failure.

The kvm-arm tree still had its build failure so I used the version from
next-20140919.

Non-merge commits (relative to Linus' tree): 7025
 6259 files changed, 249328 insertions(+), 141208 deletions(-)

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

I am currently merging 227 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (452b6361c4d9 Merge tag 'rdma-for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/roland/infiniband)
Merging fixes/master (33cdadc24f8a sparc: Set CONFIG_NET=3Dy in defconfigs)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (55d65081ef2a ARC: [nsimosci] Allow "headless"=
 models to boot)
Merging arm-current/fixes (505013bc9065 ARM: 8149/1: perf: Don't sleep whil=
e atomic when enabling per-cpu interrupts)
Merging m68k-current/for-linus (4ed7800987b1 m68k: Wire up memfd_create)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/for-linus (7d59deb50aaf powerpc: Wire up sys_secc=
omp(), sys_getrandom() and sys_memfd_create())
Merging sparc/master (c21c4ab0d692 sparc64: Move request_irq() from ldc_bin=
d() to ldc_alloc())
Merging net/master (98f75b8291a8 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec/master (b8c203b2d2fc xfrm: Generate queueing routes only from=
 route lookup functions)
Merging sound-current/for-linus (e76bf634870e ALSA: snd-usb-caiaq: Fix LED =
commands for Kore controller)
Merging pci-current/for-linus (7cbeb9f90db8 PCI: pciehp: Fix pcie_wait_cmd(=
) timeout)
Merging wireless/master (f8adaf0ae978 brcmfmac: Fix off by one bug in brcmf=
_count_20mhz_channels())
Merging driver-core.current/driver-core-linus (9e82bf014195 Linux 3.17-rc5)
Merging tty.current/tty-linus (9e82bf014195 Linux 3.17-rc5)
Merging usb.current/usb-linus (0f33be009b89 Linux 3.17-rc6)
Merging usb-gadget-fixes/fixes (0b93a4c838fa usb: dwc3: fix TRB completion =
when multiple TRBs are started)
Merging usb-serial-fixes/usb-linus (dee80ad12d2b USB: cp210x: add support f=
or Seluxit USB dongle)
Merging staging.current/staging-linus (0f33be009b89 Linux 3.17-rc6)
Merging char-misc.current/char-misc-linus (9e82bf014195 Linux 3.17-rc5)
Merging input-current/for-linus (807362cd960d Input: atmel_mxt_ts - fix mer=
ge in DT documentation)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (413e55742a4f crypto: qat - Enable all 32 IRQ=
s)
Merging ide/master (a53dae49b2fe ide: use module_platform_driver())
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (5a12a597a862 arm: Add devicetr=
ee fixup machine function)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (ce6a144a0d01 selftests/memfd: Run test on al=
l architectures)
Merging drm-intel-fixes/for-linux-next-fixes (c84db7701087 drm/i915/hdmi: f=
ix hdmi audio state readout)
Merging asm-generic/master (fb9de7ebc3a2 xtensa: Use generic asm/mmu.h for =
nommu)
Merging arc/for-next (2a5e95d4181c mm, arc: remove obsolete pagefault oom k=
iller comment)
Merging arm/for-next (18cdbcb74636 Merge branches 'fiq' (early part), 'fixe=
s' and 'misc' into for-next)
Merging arm-perf/for-next/perf (7d1311b93e58 Linux 3.17-rc1)
Merging arm-soc/for-next (2626cbd7168f Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (8d4f3361e05c Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (2b2244a3e7c3 ARM: dts: imx6: make gpt per clock c=
an be from OSC)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (65a3bb88bb33 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (cc38f02b87ef Merge branches 'heads/dt-for-v3.18' and =
'heads/soc-for-v3.18' into next)
Merging samsung/for-next (897387833bba Merge branch 'v3.18-next/defconfig-s=
amsung' into for-next)
$ git reset --hard HEAD^
Merging next-20140923 version of samsung
Merging sunxi/sunxi/for-next (429823087fec Merge branches 'sunxi/dt-for-3.1=
8' and 'sunxi/drivers-for-3.18' into sunxi/for-next)
Merging tegra/for-next (5599b9197647 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (6f325eaa86f1 Revert "arm64: dmi: Add SMBIOS/DM=
I support")
CONFLICT (content): Merge conflict in Documentation/networking/filter.txt
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0f33be009b89 Linux 3.17-rc6)
Merging m68k/for-next (9aa59cacdf22 m68k/atari - stram: Add missing #includ=
e <linux/ioport.h>)
Merging m68knommu/for-next (016371190da6 m68knommu: add missing ioport_map(=
) and ioport_unmap())
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (554336c714f4 microblaze: Use empty asm-generic/lin=
kage.h)
Merging mips/mips-for-linux-next (4b050ba7a66c MIPS: pgtable.h: Implement t=
he pgprot_writecombine function for MIPS)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (d26a7730b587 parisc: Only use -mfast-indirect-c=
alls option for 32-bit kernel builds)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging fsl/next (cb0446c1b625 Revert "powerpc/fsl_msi: spread msi ints acr=
oss different MSIRs")
Merging mpc5xxx/next (bc7505942233 powerpc/512x: dts: add MPC5125 clock spe=
cs)
Merging s390/features (722d92d38b22 s390/uprobes: architecture backend for =
uprobes)
Merging sparc-next/master (619df5d2870b Merge tag 'microblaze-3.17-rc5' of =
git://git.monstr.eu/linux-2.6-microblaze)
Merging tile/master (9c29b2aea7fa tile gxio: use better string copy primiti=
ve)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (f2589bff1ce8 xtensa/uapi: Add definition of TIOC[S=
G]RS485)
Merging btrfs/next (1d52c78afbbf Btrfs: try not to ENOSPC on log replay)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (dbb6ba16f387 [SMB3] add defines for two new file att=
ributes)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (04ec5f5c0022 ecryptfs: remove unnecessary break afte=
r goto)
Merging ext3/for_next (52362810bec8 ocfs2: Don't use MAXQUOTAS value)
Merging ext4/dev (f6e63f908099 ext4: fold ext4_nojournal_sops into ext4_sop=
s)
Merging f2fs/dev (9a41533c77ae f2fs: refactor flush_nat_entries to remove c=
ostly reorganizing ops)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (00a158be8383 GFS2: fix bad inode i_goal values during =
block allocation)
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (5466112f0935 pnfs/blocklayout: Fix a 64-bit divisio=
n/remainder issue in bl_map_stripe)
Merging nfsd/nfsd-next (9d137dc5a4cb NFSD: Implement SEEK)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (7fbbd0579997 UBI: return on error in rename_volum=
es())
Merging xfs/for-next (33044dc408e6 Merge branch 'xfs-misc-fixes-for-3.18-2'=
 into for-next)
Merging file-locks/linux-next (b0dd1b52742a locks: flock_make_lock should r=
eturn a struct file_lock (or PTR_ERR))
CONFLICT (content): Merge conflict in fs/locks.c
Merging vfs/for-next (bb4623448d40 vfs: move getname() from callers to do_m=
ount())
Merging pci/next (2f419d76599e Merge branch 'pci/hotplug' into next)
Merging hid/for-next (968d080261db Merge branch 'for-3.18/wacom' into for-n=
ext)
Merging i2c/i2c/for-next (1b1352824e03 i2c: move acpi code back into the co=
re)
Merging jdelvare-hwmon/master (c7208164e66f Linux 3.15-rc7)
Merging hwmon-staging/hwmon-next (ac407362ee6f hwmon: (ntc_thermistor) Add =
ntc thermistor to thermal subsystem as a sensor.)
Merging v4l-dvb/master (231f6015144a Merge branch 'topic/devel-3.17-rc6' in=
to to_next)
Merging kbuild/for-next (04d29c44a5c9 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (ec489eb8e027 Merge branch 'for-3.18' into for-next)
Merging pm/linux-next (263ece9387d5 Merge branch 'pm-cpufreq-next' into lin=
ux-next)
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/setup-sh73a0.c
CONFLICT (content): Merge conflict in arch/arm/mach-shmobile/board-ape6evm-=
reference.c
CONFLICT (content): Merge conflict in arch/arm/configs/mvebu_v7_defconfig
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (dd634666793e Merge branches 'eduardo-soc' and 'bang-b=
ang-governor' of .git into next)
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (883854c5457a dlm: keep listening connection alive with sc=
tp mode)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (88e2c354799e Merge branch 'for-linus' into next)
Merging dmaengine/next (fbeec99ad5c0 dma: mv_xor: Rename __mv_xor_slot_clea=
nup() to mv_xor_slot_cleanup())
Merging net-next/master (3c4d1daecef8 vxlan: Fix bug introduced by commit a=
cbf74a76300)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3188-radxarock.dts
Merging ipsec-next/master (689f1c9de2ab ipsec: Remove obsolete MAX_AH_AUTH_=
LEN)
Merging wireless-next/master (7a0a260a0f6f ath9k: enable ext channel pulse =
detection)
Merging bluetooth/master (48e68ff5e55a Bluetooth: Check for SCO type before=
 setting retransmission effort)
Merging infiniband/for-next (3bdad2d13fa6 Merge branches 'core', 'ipoib', '=
iser', 'mlx4', 'ocrdma' and 'qib' into for-next)
Merging mtd/master (b25046b1e5e3 mtd: nand: fix DocBook warnings on nand_sd=
r_timings doc)
Merging l2-mtd/master (6d178ef2fd5e mtd: nand: Move ELM driver and rename a=
s omap_elm)
Merging crypto/master (383b75e9d05c crypto: qat - Removed unneeded partial =
state)
Merging drm/drm-next (94318d50ffc8 drm/ttm: Clean usage of ttm_io_prot() wi=
th TTM_PL_FLAG_CACHED)
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (bda0381e7202 drm/i915: Use EIO instead of=
 EAGAIN for sink CRC error.)
Merging drm-tegra/drm/tegra/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging sound/for-next (7a7686bd0d15 ALSA: ctxfi: sparse warning)
Merging sound-asoc/for-next (621905d3526d Merge remote-tracking branches 'a=
soc/topic/wm8978' and 'asoc/topic/wm8994' into asoc-next)
Merging modules/modules-next (184c3fc3f52f moduleparam: Resolve missing-fie=
ld-initializer warning)
Merging virtio/virtio-next (7ec62d421bdf Merge branch 'for_linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs)
Merging input/next (05f7588c3c16 Input: palmas-pwrbutton - fix typo in the =
license string)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (d9fdbe7c26ad fix merge error)
Merging device-mapper/for-next (bf6ee77f38b0 dm crypt: sort writes)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (bb98d9d1d2e7 mmc: tmio: prevent endless loop in tmio_m=
mc_set_clock())
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (4a888fc79b3f md/bitmap: remove bev_logical_block_size =
rounding where not needed.)
Merging mfd/for-mfd-next (420795acbd11 mfd: twl4030-power: Use 'ti,system-p=
ower-controller' as alternative way to support system power off)
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (5e37195f30cc ipaq_micro_battery: fix sparse non sta=
tic symbol warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (30296f61159e video: fbdev: use %*ph specifier t=
o dump small buffers)
Merging regulator/for-next (53e77bada464 Merge remote-tracking branches 're=
gulator/topic/sky81452', 'regulator/topic/tps65023', 'regulator/topic/tps65=
217', 'regulator/topic/tps65910' and 'regulator/topic/voltage-ev' into regu=
lator-next)
Merging security/next (35e1efd25a9e Merge tag 'keys-next-20140922' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs into next)
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
CONFLICT (content): Merge conflict in fs/nfsd/vfs.c
Merging integrity/next (1b68bdf9cded ima: detect violations for mmaped file=
s)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (4c7c9da51c09 devicetree: Add Cadence WDT devicetre=
e bindings documentation)
Merging iommu/next (f55c86642759 Merge branches 'iommu/fixes', 'arm/exynos'=
, 'arm/omap', 'x86/vt-d' and 'x86/amd' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (9b936c960f22 drivers/vfio: Enable VFIO if EEH is not sup=
ported)
Merging osd/linux-next (ce5d36aac26c ore: Support for raid 6)
Merging jc_docs/docs-next (5c050fb96380 docs: update the development proces=
s document)
Merging trivial/for-next (00703e0b7990 Documentation: remove obsolete pcmci=
a-cs from Changes)
CONFLICT (content): Merge conflict in block/blk-core.c
Merging audit/master (9eab339b197a audit: get comm using lock to avoid race=
 in string printing)
CONFLICT (content): Merge conflict in arch/arm64/kernel/ptrace.c
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (a9ecdc0fdc54 of/irq: Fix lookup to use =
'interrupts-extended' property first)
Merging dt-rh/for-next (99de64984c3a OF: fix of_find_node_by_path() assumpt=
ion that of_allnodes is root)
Merging mailbox/mailbox-for-next (29de0a1d6aa4 dt: mailbox: add generic bin=
dings)
Merging spi/for-next (8fb794ce36bc Merge remote-tracking branch 'spi/topic/=
xilinx' into spi-next)
Merging tip/auto-latest (ad9bed2b6aca Merge branch 'x86/uv')
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdm.c deleted in HEA=
D and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/blockl=
ayout/blocklayoutdm.c left in tree.
CONFLICT (modify/delete): fs/nfs/blocklayout/blocklayoutdev.c deleted in HE=
AD and modified in tip/auto-latest. Version tip/auto-latest of fs/nfs/block=
layout/blocklayoutdev.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/ptrace.c
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_64.S
$ git rm -f fs/nfs/blocklayout/blocklayoutdev.c fs/nfs/blocklayout/blocklay=
outdm.c
Applying: pnfs: merge fixup for sched cleanup of set_current_state(TASK_RUN=
NING)
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (50d1bb93672f sb_edac: add support for Haswell base=
d systems)
Merging edac-amd/for-next (7981a28f1ab5 amd64_edac: Modify usage of amd64_r=
ead_dct_pci_cfg())
Merging irqchip/irqchip/for-next (1633cd9aed67 Merge branch 'irqchip/gic' i=
nto irqchip/for-next)
Merging tiny/tiny/next (3cf6b0151ba5 Merge branches 'tiny/bloat-o-meter-no-=
SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x=
86-boot-compressed-use-yn' into tiny/next)
Merging ftrace/for-next (3ddee63a099e ftrace: Only disable ftrace_enabled t=
o test buffer in selftest)
Merging rcu/rcu/next (dd56af42bd82 rcu: Eliminate deadlock between CPU hotp=
lug and expedited grace periods)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (f51770ed465e kvm: Make init_rmode_identity_map() re=
turn 0 on success.)
Merging kvm-arm/next (a98f26f18380 arm/arm64: KVM: vgic: make number of irq=
s a configurable attribute)
$ git reset --hard HEAD^
Merging next-20140919 version of kvm-arm
CONFLICT (content): Merge conflict in virt/kvm/arm/vgic.c
CONFLICT (content): Merge conflict in arch/arm64/include/asm/kvm_host.h
[master 688328cb5477] next-20140919/kvm-arm
Merging kvm-ppc/kvm-ppc-next (f51770ed465e kvm: Make init_rmode_identity_ma=
p() return 0 on success.)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (59119fad2954 xen-scsifront: don't deadlock if t=
he ring becomes full)
Merging percpu/for-next (cbbe3a37a8b9 Merge branch 'for-3.18' into for-next)
CONFLICT (content): Merge conflict in fs/ext4/super.c
Applying: percpu_counter: fix for ext4 updates
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (aeaac098bd58 toshiba_acpi: fix and cleanup to=
shiba_kbd_bl_mode_store())
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (402dd4061206 Merge remote-tracking branch 'regmap/=
topic/cache' into regmap-next)
Merging hsi/for-next (3fd276e9c0d7 HSI: omap_ssi: Fix return value check in=
 ssi_debug_add_ctrl())
Merging leds/for-next (3ef7de5304ed leds: Improve and export led_update_bri=
ghtness)
Merging ipmi/for-next (662d15871626 ipmi: Clear drvdata when interface is r=
emoved)
Merging driver-core/driver-core-next (00e262fd8744 Documentation/sysfs-rule=
s.txt: Add device attribute error code documentation)
Merging tty/tty-next (93b887747179 tty: serial_mctrl_gpio: Fix COMPILE_TEST=
 build for architectures with custom termios.h)
Merging usb/usb-next (6ca01a1b451d Merge 3.17-rc6 into usb-next)
CONFLICT (content): Merge conflict in drivers/usb/gadget/function/f_fs.c
Merging usb-gadget/next (72a65a0d19c1 Revert "usb: gadget: composite: deque=
ue cdev->req before free its buffer")
Merging usb-serial/usb-next (f8c0e057b489 USB: serial: remove zte_ev driver)
Merging staging/staging-next (92db2a276c6a Staging: rtl8192e: Fix else is n=
ot useful warning style)
Merging char-misc/char-misc-next (e60cdc907c1d Merge tag 'extcon-next-for-3=
.18' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into c=
har-misc-next)
Merging cgroup/for-next (4e1024b53102 Merge branch 'for-3.18' into for-next)
Merging scsi/for-next (a36a9a7ea09e Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
Merging target-updates/for-next (c435285df112 target: fix unused shift in c=
ore_scsi3_pri_report_capabilities)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (5ce339f6ab29 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (94a62c615b13 Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (70145f87139f pwm: Fix uninitialized warnings in pwm_g=
et())
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (fee9d3e61d04 ktest: add ability to skip during BISE=
CT_MANUAL)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (a52ae5a755d9 Merge branch 'clk-fixes' into clk-next)
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/clo=
ck/renesas,cpg-mstp-clocks.txt
Merging random/dev (13aa93c70e71 random: add and use memzero_explicit() for=
 clearing data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (7be141d05549 Merge branch 'x86-urgent-for-linus' of git=
://git.kernel.org/pub/scm/linux/kernel/git/tip/tip)
Merging llvmlinux/for-next (7d4cd0ef629a arm64: LLVMLinux: Fix inline arm64=
 assembly for use with clang)
CONFLICT (content): Merge conflict in Makefile
Merging powernv-cpuidle/powernv-cpuidle (0888839c5b62 cpuidle/powernv: Pars=
e device tree to setup idle states)
Merging rd-docs/master (78cbcabd472b Documentation: disable vdso_test to av=
oid breakage with old glibc)
CONFLICT (content): Merge conflict in Documentation/networking/timestamping=
/Makefile
Merging kselftest/next (69e273c0b0a3 Linux 3.17-rc3)
Merging signal-cleanup/signal_v4 (b9f0fb2d4a7a powerpc: Use sigsp())
CONFLICT (content): Merge conflict in arch/unicore32/kernel/signal.c
Merging powerpc-mpe/next (fd0af3889b26 powerpc: Fix build failure when CONF=
IG_USB=3Dy)
Merging akpm-current/current (ff22a6f914a0 scripts/sortextable: suppress wa=
rning: `relocs_size' may be used uninitialized)
CONFLICT (content): Merge conflict in drivers/clk/Kconfig
CONFLICT (content): Merge conflict in arch/arm64/mm/dma-mapping.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: x86, vdso: fix vdso2c's special_pages error checking
Applying: arch/x86/kernel/cpu/common.c: fix unused symbol warning
Applying: lib/string.c: remove duplicated function
Applying: lib: string: Make all calls to strnicmp into calls to strncasecmp
Applying: ARM: replace strnicmp with strncasecmp
Applying: block: replace strnicmp with strncasecmp
Applying: netfilter: replace strnicmp with strncasecmp
Applying: video: fbdev: replace strnicmp with strncasecmp
Applying: cifs: replace strnicmp with strncasecmp
Applying: ocfs2: replace strnicmp with strncasecmp
Applying: isofs: replace strnicmp with strncasecmp
Applying: batman-adv: replace strnicmp with strncasecmp
Applying: ACPI/battery: replace strnicmp with strncasecmp
Applying: cpufreq: replace strnicmp with strncasecmp
Applying: cpuidle: replace strnicmp with strncasecmp
Applying: scsi: replace strnicmp with strncasecmp
Applying: ib_srpt: replace strnicmp with strncasecmp
Applying: input: edt-ft5x06: replace strnicmp with strncasecmp
Applying: altera-stapl: replace strnicmp with strncasecmp
Applying: thinkpad_acpi: replace strnicmp with strncasecmp
Applying: PNP: replace strnicmp with strncasecmp
Applying: s390/cio: replace strnicmp with strncasecmp
Applying: staging: r8188eu: replace strnicmp with strncasecmp
Applying: thermal: replace strnicmp with strncasecmp
Applying: kdb: replace strnicmp with strncasecmp
Applying: fs: check bh blocknr earlier when searching lru
Applying: arch/x86/mm/numa.c: fix boot failure when all nodes are hotplugga=
ble
Applying: mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggabl=
e-checkpatch-fixes
Applying: include/linux: remove strict_strto* definitions
Applying: lib / string_helpers: move documentation to c-file
Applying: lib / string_helpers: refactoring the test suite
Applying: lib / string_helpers: introduce string_escape_mem()
Applying: lib-string_helpers-introduce-string_escape_mem-fix
Applying: lib/vsprintf: add %*pE[achnops] format specifier
Applying: lib-vsprintf-add-%pe-format-specifier-fix
Applying: wireless: libertas: print esaped string via %*pE
Applying: wireless: ipw2x00: print SSID via %*pE
Applying: wireless: hostap: proc: print properly escaped SSID
Applying: wireless-hostap-proc-print-properly-escaped-ssid-fix
Applying: wireless-hostap-proc-print-properly-escaped-ssid-fix-2
Applying: lib80211: remove unused print_ssid()
Applying: staging: wlan-ng: use %*pEhp to print SN
Applying: staging: rtl8192e: use %*pEn to escape buffer
Applying: staging: rtl8192u: use %*pEn to escape buffer
Applying: kernel/watchdog.c: control hard lockup detection default
Applying: watchdog-control-hard-lockup-detection-default-fix
Applying: watchdog, nmi: Fix compile issues on sparc
Applying: kvm: ensure hard lockup detection is disabled by default
Applying: kernel: add support for kernel restart handler call chain
Applying: power/restart: call machine_restart instead of arm_pm_restart
Applying: arm64: support restart through restart handler call chain
Applying: arm: support restart through restart handler call chain
Applying: watchdog: moxart: register restart handler with kernel restart ha=
ndler
Applying: watchdog: alim7101: register restart handler with kernel restart =
handler
Applying: watchdog: sunxi: register restart handler with kernel restart han=
dler
Applying: arm/arm64: unexport restart handlers
Applying: watchdog: s3c2410: add restart handler
Applying: clk: samsung: register restart handlers for s3c2412 and s3c2443
Applying: clk: rockchip: add restart handler
Applying: frv: remove unused declarations of __start___ex_table and __stop_=
__ex_table
Applying: ia64: remove duplicate declarations of __per_cpu_start[] and __pe=
r_cpu_end[]
Applying: kernel/param: consolidate __{start,stop}___param[] in <linux/modu=
leparam.h>
Applying: mm: replace remap_file_pages() syscall with emulation
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
Merging akpm/master (42f218d01e70 mm: add strictlimit knob)

--Sig_/Rv21c92on=fQVgFQzKkp+8Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIop5AAoJEMDTa8Ir7ZwVYU0P/0mJrqZv/Y0rqi19lYC07VqF
Yw6FG5ise8fRVUvjSKhhspXN0HNtk+N2ScqrCVuo3gnKj20Asr+o2iNDi9xlJvCk
cAUCxY/5T4icOPPuaP0ESWZGBB7hcjITZ8FT6hZkUpNhtYIGRf4fiweYj/NzcxTa
1mys879S8j6HdhH2KfitWzOxIIMZdGm3IiJjQ+mfGNPqtu1lrpI7/833MSliPQIT
Z7CgjG6HeySIRa4oXZ/0G7s9Ow3wsUHDFHVwXfExEpQzxXX53bd0ugzUIxA2lSki
QBOv3dU/9rSslp7QKNvVehqaHe2BgsD/psIJS3/EyQHEkzOOW/71ry+/d0TW3NmI
2PWUBn9nLIeuxQDgvIHcGZ7rWGOOV2ZZMzoePCy2Ymf8NWW7Wz4Eh0m4ADR/CUt3
Dikg/e525hFgmsyDZfObp3yn9t7e+QJ47Z4+44oNl7GsihcejhzFJs1I73CHlGQj
kq3l8FUwg4YZVrwOnIBjzPN8LyNnVRrL/eYWXImMJ3GDjK53WPnZArajLKH/Esj6
u1+sUook0T4Ye65UxtG5+PZ5K/WwqIU6c1YSLsG8bY3x1FIOPwB7gmlphoWOmlG8
/fEb9BRXx8+qPKYBMePzuPYZmtFtrPNinjUxpz96X29TKVopdaXc6jA7rmtYpGbs
WSkYJf4orwtj6SNUi+/C
=hL7H
-----END PGP SIGNATURE-----

--Sig_/Rv21c92on=fQVgFQzKkp+8Q--
