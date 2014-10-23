Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbaJWEVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 00:21:41 -0400
Received: from ozlabs.org ([103.22.144.67]:42041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJWEVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 00:21:37 -0400
Date: Thu, 23 Oct 2014 15:21:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Oct 23
Message-ID: <20141023152129.28558ddf@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lTakS1lCK4UBrbzmqMYXx6V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lTakS1lCK4UBrbzmqMYXx6V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141022:

The sound-asoc tree still had its build failure so I used the version from
next-20141020.

The akpm-current tree gained a conflict against the pm tree.

Non-merge commits (relative to Linus' tree): 969
 1089 files changed, 21364 insertions(+), 36533 deletions(-)

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

I am currently merging 225 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (c3351dfabf5c Merge branch 'for-next' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/nab/target-pending)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (7d1311b93e58 Linux 3.17-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (178c3dfe853a ARM: fix some printk formats)
Merging m68k-current/for-linus (24cae7934cf1 m68k: Reformat arch/m68k/mm/hw=
test.c)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (396a34340cdf powerpc: Fix endianness of flash_=
block_list in rtas_flash)
Merging powerpc-merge-mpe/for-linus (e89dafb5ca50 powerpc: Only do dynamic =
DMA zone limits on platforms that need it)
Merging sparc/master (61ed53deb1c6 Merge tag 'ntb-3.18' of git://github.com=
/jonmason/ntb)
Merging net/master (942396b01989 hyperv: Fix the total_data_buflen in send =
path)
Merging ipsec/master (d10845fc85b2 Merge branch 'gso_encap_fixes')
Merging sound-current/for-linus (dde1c652d7b1 ALSA: pcm: Fix false lockdep =
warnings)
Merging pci-current/for-linus (f10e3cd690b8 Merge branch 'remove-weak-funct=
ion-declarations' into for-linus)
Merging wireless/master (f8adaf0ae978 brcmfmac: Fix off by one bug in brcmf=
_count_20mhz_channels())
Merging driver-core.current/driver-core-linus (f114040e3ea6 Linux 3.18-rc1)
Merging tty.current/tty-linus (f114040e3ea6 Linux 3.18-rc1)
Merging usb.current/usb-linus (f114040e3ea6 Linux 3.18-rc1)
Merging usb-gadget-fixes/fixes (0b93a4c838fa usb: dwc3: fix TRB completion =
when multiple TRBs are started)
Merging usb-serial-fixes/usb-linus (dc477ad386fb USB: kobil_sct: Remove unu=
sed transfer buffer allocs)
Merging staging.current/staging-linus (54d5c5cd0fb2 staging: rtl8723au: Fix=
 alignment of mac_addr for ether_addr_copy() usage)
Merging char-misc.current/char-misc-linus (f114040e3ea6 Linux 3.18-rc1)
Merging input-current/for-linus (4dfb15cd5aaa Input: xpad - add Thrustmaste=
r as Xbox 360 controller vendor)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (be34c4ef693f crypto: sha - Handle unaligned =
input data in generic sha256 and sha512.)
Merging ide/master (7546e52b5e3d Drivers: ide: Remove typedef atiixp_ide_ti=
ming)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (e66c98c7a0ea of: Fix NULL dere=
ference in selftest removal code)
Merging rr-fixes/fixes (f49819560f53 virtio-rng: skip reading when we start=
 to remove the device)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (ce6a144a0d01 selftests/memfd: Run test on al=
l architectures)
Merging drm-intel-fixes/for-linux-next-fixes (03a3780b0c82 drm/i915: Fix GM=
BUSFREQ on vlv/chv)
Merging asm-generic/master (f3670394c29f Revert "x86/efi: Fixup GOT in all =
boot code paths")
Merging arc/for-next (21d2271fd081 Merge git://www.linux-watchdog.org/linux=
-watchdog)
Merging arm/for-next (178c3dfe853a ARM: fix some printk formats)
Merging arm-perf/for-next/perf (f114040e3ea6 Linux 3.18-rc1)
Merging arm-soc/for-next (c60c536716fd Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (36483b843974 Merge branch 'berlin/dt' into =
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
Merging samsung/for-next (2b5fa1d5dabb Merge branch 'v3.19-next/dt-samsung'=
 into for-next)
Merging sunxi/sunxi/for-next (3f9f9abe20a1 Merge branches 'sunxi/core-for-3=
.19' and 'sunxi/dt-for-3.19' into sunxi/for-next)
Merging tegra/for-next (5599b9197647 Merge branch for-3.18/defconfig into f=
or-next)
Merging arm64/for-next/core (0a6479b0ffad arm64: Remove unneeded extern key=
word)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (cd065a010a97 CRISv10: Readd missing header)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0f33be009b89 Linux 3.17-rc6)
Merging m68k/for-next (24cae7934cf1 m68k: Reformat arch/m68k/mm/hwtest.c)
Merging m68knommu/for-next (e803d4bd3118 m68k: Fix typo 'COFNIG_MBAR')
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (554336c714f4 microblaze: Use empty asm-generic/lin=
kage.h)
Merging mips/mips-for-linux-next (2fd1ca93ab87 Merge branch '3.18-fixes' in=
to mips-for-linux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (5e40d331bd72 Merge branch 'next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging powerpc-mpe/next (e89dafb5ca50 powerpc: Only do dynamic DMA zone li=
mits on platforms that need it)
Merging fsl/next (cb0446c1b625 Revert "powerpc/fsl_msi: spread msi ints acr=
oss different MSIRs")
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (d6fe5be34cf0 s390/uprobes: fix kprobes dependency)
Merging sparc-next/master (61ed53deb1c6 Merge tag 'ntb-3.18' of git://githu=
b.com/jonmason/ntb)
Merging tile/master (78410af51146 tile: add clock_gettime support to vDSO)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (f2589bff1ce8 xtensa/uapi: Add definition of TIOC[S=
G]RS485)
Merging btrfs/next (a43bb39b5c71 btrfs: Fix compile error when CONFIG_SECUR=
ITY is not set.)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (6212096bb0a1 [CIFS] Update modinfo cifs version for =
cifs.ko)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (35425ea24921 ecryptfs: avoid to access NULL pointer =
when write metadata in xattr)
Merging ext3/for_next (6174c2eb8ece udf: Fix loading of special inodes)
Merging ext4/dev (813d32f91333 ext4: check s_chksum_driver when looking for=
 bg csum presence)
Merging f2fs/dev (e82a62d14c44 f2fs: fix possible data corruption in f2fs_w=
rite_begin())
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (d29c0afe4db7 GFS2: use _RET_IP_ instead of (unsigned l=
ong)__builtin_return_address(0))
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (f114040e3ea6 Linux 3.18-rc1)
Merging nfsd/nfsd-next (04a04675107b NFSD: Always initialize cl_cb_addr)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (91401a34038e UBI: Fastmap: Calc fastmap size corr=
ectly)
Merging xfs/for-next (6889e783cd68 Merge branch 'xfs-misc-fixes-for-3.18-3'=
 into for-next)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (a457606a6f81 fs/file_table.c: Update alloc_file() com=
ment)
Merging pci/next (f114040e3ea6 Linux 3.18-rc1)
Merging hid/for-next (afdb5cce979b HID: input: Map unknown consumer page co=
des to KEY_UNKNOWN)
Merging i2c/i2c/for-next (f114040e3ea6 Linux 3.18-rc1)
Merging jdelvare-hwmon/master (6f524c0e53c0 hwmon: (i5500_temp) Convert to =
devm_hwmon_device_register_with_groups)
Merging hwmon-staging/hwmon-next (8c7ff586a6f8 hwmon: (iio_hwmon) Add suppo=
rt for humidity sensors)
Merging v4l-dvb/master (9f93c52783fa [media] hackrf: harmless off by one in=
 debug code)
Merging kbuild/for-next (e9f717fb534c Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (8ccee3cf7d8e Merge branch 'for-3.18' into for-next)
Merging pm/linux-next (78a484e98b94 Merge branch 'freezer')
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6ceaf58abe25 Merge branch 'int340x-thermal' of .git i=
nto next)
CONFLICT (content): Merge conflict in drivers/acpi/fan.c
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (c07127b48c63 dlm: fix missing endian conversion of rcom_s=
tatus flags)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (f114040e3ea6 Linux 3.18-rc1)
Merging net-next/master (61ed53deb1c6 Merge tag 'ntb-3.18' of git://github.=
com/jonmason/ntb)
Merging ipsec-next/master (61ed53deb1c6 Merge tag 'ntb-3.18' of git://githu=
b.com/jonmason/ntb)
Merging wireless-next/master (1fca350b7616 rtlwifi: Fix possible unaligned =
array in ether_addr_copy())
Merging bluetooth/master (c783b68d11d8 Bluetooth: Fix missing channel unloc=
k in l2cap_le_credits)
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (8b3d58e55445 mtd: nand: omap: Correct CONFIG_MTD_NAND_O=
MAP_BCH help message)
Merging l2-mtd/master (d4efafcc040d mtd: docg3: fix 'defined but not used' =
warning)
Merging crypto/master (be34c4ef693f crypto: sha - Handle unaligned input da=
ta in generic sha256 and sha512.)
Merging drm/drm-next (dfda0df34264 drm/mst: rework payload table allocation=
 to conform better.)
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (07c338ce9826 drm/i915: fix short vs. long=
 hpd detection)
Merging drm-tegra/drm/tegra/for-next (8ed05f485498 drm/tegra: Depend on COM=
MON_CLK)
Merging drm-misc/topic/core-stuff (2d164fbd0b3b drm/dp-helper: Move the leg=
acy helpers to gma500)
Merging sound/for-next (b46882b6eb71 Merge branch 'topic/hda-lo-jack' into =
for-next)
Merging sound-asoc/for-next (0fb8f1621d9d Merge remote-tracking branches 'a=
soc/topic/sta32x', 'asoc/topic/sta350', 'asoc/topic/sta529', 'asoc/topic/st=
ac9766' and 'asoc/topic/tegra' into asoc-next)
$ git reset --hard HEAD^
Merging next-20141020 version of sound-asoc
Merging modules/modules-next (d3051b489aa8 modules, lock around setting of =
MODULE_STATE_UNFORMED)
Merging virtio/virtio-next (1bbc26062754 virtio-rng: refactor probe error h=
andling)
Merging input/next (29fbd64b0fd2 Input: add driver for Elan I2C/SMbus touch=
pad)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (b3ea6e035ac9 Merge branch 'for-linus' into for-next)
Merging device-mapper/for-next (330f26b97345 dm thin: refactor requeue_io t=
o eliminate spinlock bouncing)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (f114040e3ea6 Linux 3.18-rc1)
Merging kgdb/kgdb-next (662bfa325be1 kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (b395f75eabb3 lib/raid6: Add log level to printks)
Merging mfd/for-mfd-next (69ef42279d3a mfd/regulator: dt-bindings: max77686=
: Document regulators off in suspend)
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (7881c64716f3 power: ab8500_fg: Fix build warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (f114040e3ea6 Linux 3.18-rc1)
Merging regulator/for-next (63c0e4ce7d4e Merge remote-tracking branches 're=
gulator/topic/rn5t618', 'regulator/topic/s2mps11', 'regulator/topic/sky8145=
2' and 'regulator/topic/suspend' into regulator-next)
Merging security/next (594081ee7145 integrity: do zero padding of the key i=
d)
Merging integrity/next (1b68bdf9cded ima: detect violations for mmaped file=
s)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (d2aa9ba6cdf4 watchdog: meson: remove magic value f=
or reboot)
Merging iommu/next (09b5269a1b3d Merge branches 'arm/exynos', 'arm/omap', '=
arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (93899a679fd6 vfio-pci: Fix remove path locking)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (011bc4870fb2 Docs: Document that the sticky bit =
is understood by hugetlbfs)
Merging trivial/for-next (7bb38d57fd75 Remove MN10300_PROC_MN2WS0038)
Merging audit/next (915f389d9c52 audit: add Paul Moore to the MAINTAINERS e=
ntry)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (2118f4b8dfc6 of/selftest: Move hash tab=
le off stack to fix large frame size)
Merging dt-rh/for-next (d22e9131187d of: add vendor prefix for Chipidea)
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (828617219082 Merge remote-tracking branches 'spi/topi=
c/atmel', 'spi/topic/dw' and 'spi/topic/fsl-dspi' into spi-next)
Merging tip/auto-latest (fc287d7ee5f0 Merge branch 'x86/urgent' into auto-l=
atest)
Merging clockevents/clockevents/next (3252a646aa2c clocksource: exynos_mct:=
 Only use 32-bits where possible)
Merging edac/linux_next (d0585cd815fa sb_edac: Claim a different PCI device)
Merging edac-amd/for-next (a18c3f16a907 mpc85xx_edac: Make L2 interrupt sha=
red too)
Merging irqchip/irqchip/for-next (3bbccffba8d5 Merge branch 'irqchip/core' =
into irqchip/for-next)
Merging tiny/tiny/next (d45461ff03ad Merge branches 'tiny/bloat-o-meter-no-=
SyS', 'tiny/more-procless', 'tiny/no-advice', 'tiny/tinyconfig' and 'tiny/x=
86-boot-compressed-use-yn' into tiny/next)
Merging ftrace/for-next (70c738a64478 Merge branch 'trace/ftrace/testing' i=
nto trace/for-next)
Merging rcu/rcu/next (22b38d950e70 rcu: Remove "cpu" argument to rcu_needs_=
cpu())
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (da01e61428aa Merge tag 'f2fs-for-3.18' of git://git=
.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs)
Merging kvm-arm/next (2df36a5dd679 arm/arm64: KVM: Fix BE accesses to GICv2=
 EISR and ELRSR regs)
Merging kvm-ppc/kvm-ppc-next (8d0eff638564 KVM: PPC: Pass enum to kvmppc_ge=
t_last_inst)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (95afae481414 xen: remove DEFINE_XENBUS_DRIVER()=
 macro)
Merging percpu/for-next (0a15cbdaefcd Merge branch 'for-3.18' into for-next)
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (eabde0fa9670 toshiba_acpi: Adapt kbd_bl_timeo=
ut_store to the new kbd type)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (46f6c620e8a1 Merge remote-tracking branches 'regma=
p/topic/cache' and 'regmap/topic/headers' into regmap-next)
Merging hsi/for-next (a26a42508157 HSI: remove deprecated IRQF_DISABLED)
Merging leds/for-next (a4c84e6aafda leds: gpio: cleanup the leds-gpio drive=
r)
Merging ipmi/for-next (ef4a48c51321 Merge tag 'locks-v3.18-1' of git://git.=
samba.org/jlayton/linux)
Merging driver-core/driver-core-next (f114040e3ea6 Linux 3.18-rc1)
Merging tty/tty-next (f114040e3ea6 Linux 3.18-rc1)
Merging usb/usb-next (f114040e3ea6 Linux 3.18-rc1)
Merging usb-gadget/next (72a65a0d19c1 Revert "usb: gadget: composite: deque=
ue cdev->req before free its buffer")
Merging usb-serial/usb-next (5f9f975b7984 USB: serial: keyspan_pda: fix Ent=
rega company name spelling)
Merging staging/staging-next (9246a4a98a01 android: binder: remove binder.h)
Merging char-misc/char-misc-next (f114040e3ea6 Linux 3.18-rc1)
Merging cgroup/for-next (55e8955e6eba Merge branch 'for-3.18' into for-next)
Merging scsi/for-next (e166e75ff6e6 scsi_debug: error message should say sc=
si_host_alloc not scsi_register)
Merging target-updates/for-next (62d3ab49b8a5 target/file: fix inclusive vf=
s_fsync_range() end)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (b55d0deddcd9 Merge branch 'devel' into for-next)
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (0429fbc0bdc2 Merge branch 'for-3.18-consistent-ops' =
of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu)
Merging dma-mapping/dma-mapping-next (b4bbb107d73b dma-mapping: Provide wri=
te-combine allocations)
Merging pwm/for-next (e2e08970100d pwm: atmel: Fix calculation of prescale =
value)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (d832d743385d ktest: Don't bother with bisect good o=
r bad on replay)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (98d147f50eb0 clk: pxa clocks build system fix)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (668044a5d632 aio: Make it possible to remap aio ring)
Merging llvmlinux/for-next (ec25a590c29c arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
Merging kselftest/next (49296470830a selftests/timers: change test to use k=
sft framework)
Merging akpm-current/current (7a152b7f7e60 gcov: enable GCOV_PROFILE_ALL fr=
om ARCH Kconfigs)
CONFLICT (content): Merge conflict in mm/oom_kill.c
CONFLICT (content): Merge conflict in kernel/power/process.c
CONFLICT (content): Merge conflict in include/linux/oom.h
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: fat: add i_disksize to represent uninitialized size
Applying: fat: add fat_fallocate operation
Applying: fat: skip cluster allocation on fallocated region
Applying: fat: permit to return phy block number by fibmap in fallocated re=
gion
Applying: Documentation/filesystems/vfat.txt: update the limitation for fat=
 fallocate
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (b5e7f3b79c52 mm: add strictlimit knob)

--Sig_/lTakS1lCK4UBrbzmqMYXx6V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUSIJNAAoJEMDTa8Ir7ZwVNmYP/3MJ1NSCuQRfEnoHYDC9uBJu
k5aSMPfr4Bt0iv38jSxZtGoqyQd+mN/nywP6EMngfkGoExEMf+527U76js/R7PLN
X5xJ/1GGg8naNw5ZTYt+syJEM0ck7U+THUYLhicr1wEcbNO4VNXRLDhXKGLKb0XQ
bFnwCIO9sSZlZiGWMGMbKQ1B2uDHMuKfpWF1mAmrd7iNwiIBTed/Ay6uiMtD85La
LIgDxA/4t+JnW3QyCuvS5hbF1XR7AfqkbFM+zzFPD4EsWkc2NReLxcDg1KqwDK/r
QhDTLiSbeunlutIZkzOd3Z88+zaHsvvl8iZ0MCT8yfDLW/AWj/qCtHrQ0fe8zYaC
grEMF1n/S+hPK7gt2Q5QZjThf0aq8NxQepZQkG4aKex37GyAblpjrulAvaGhC5gt
c1Yp2dCVZe4ZUCK+dPrVJZTpshNx94ASWDkmsRnFlb6AV7vplrNaUBuQDVt61qkY
+IIWV18LoCZhR9pV5ME9D0Jt+/N7TkE7AaG5hZV1NRybTWDEJ98f9OnB7MSrw3cd
YXnIeOGcwCyzC+OK0CDdoThxtd4DFoX2CcOhedLDU7jWjE9hXZ7tRCgtbDENlLMf
tFAr1qJ1To60g/pPPfdjuEBjYtRqdhVU91bV8PiMXytkKIJdfj/tmpzeWD7kjd3f
AthQDTc2KrtEgcL3iUQl
=3SNy
-----END PGP SIGNATURE-----

--Sig_/lTakS1lCK4UBrbzmqMYXx6V--
