Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaJ0FMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:12:16 -0400
Received: from ozlabs.org ([103.22.144.67]:60783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaJ0FMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:12:12 -0400
Date: Mon, 27 Oct 2014 16:12:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Oct 27
Message-ID: <20141027161202.0449a99b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eX0+11I208x5cb=06371_xD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eX0+11I208x5cb=06371_xD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141023:

New trees: thermal-soc, y2038

The bluetooth tree gained a build failure so I used the version from
next-20141023.

The sound-asoc tree lost its build failure.

The pinctrl tree gained a build failure so I used the version from
next-20141023.

The akpm-current tree gained a build failure for which I applied a
patch.

Non-merge commits (relative to Linus' tree): 1460
 1485 files changed, 36227 insertions(+), 48000 deletions(-)

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
Merging origin/master (88e237610b42 Merge tag 'armsoc-for-rc2' of git://git=
.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc)
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
Merging sparc/master (06090e8ed89e sparc64: Implement __get_user_pages_fast=
().)
Merging net/master (b71e821de50f drivers: net: xgene: Rewrite buggy loop in=
 xgene_enet_ecc_init())
Merging ipsec/master (d10845fc85b2 Merge branch 'gso_encap_fixes')
Merging sound-current/for-linus (56779864f135 ALSA: hda/realtek - Update re=
store default value for ALC283)
Merging pci-current/for-linus (f10e3cd690b8 Merge branch 'remove-weak-funct=
ion-declarations' into for-linus)
Merging wireless/master (08054200117a rtlwifi: Add check for get_btc_status=
 callback)
Merging driver-core.current/driver-core-linus (f114040e3ea6 Linux 3.18-rc1)
Merging tty.current/tty-linus (f114040e3ea6 Linux 3.18-rc1)
Merging usb.current/usb-linus (8071e6f8b4d1 Merge tag 'fixes-for-v3.18-rc2'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging usb-gadget-fixes/fixes (9b1763553a89 usb: gadget: function: Fixed t=
he return value on error path)
Merging usb-serial-fixes/usb-linus (7f2719f0003d usb: serial: ftdi_sio: add=
 "bricked" FTDI device PID)
Merging staging.current/staging-linus (7e74783a9db7 Merge tag 'iio-fixes-fo=
r-3.18a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (f114040e3ea6 Linux 3.18-rc1)
Merging input-current/for-linus (859abd1d59e2 Input: wm97xx - adapt paramet=
ers to tosa touchscreen.)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (09adc8789c4e crypto: qat - Enforce valid num=
a configuration)
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
Merging arm-soc/for-next (13a2a4dbdf32 Merge branch 'fixes' into for-next)
Merging bcm2835/for-next (fa389e220254 Linux 3.14-rc6)
Merging berlin/berlin/for-next (efeff8913c20 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (809d4af84856 Merge branch 'imx/dt' into for-next)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (c9eaa447e77e Linux 3.15-rc1)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (65a3bb88bb33 Merge branch 'mvebu/dt' into mvebu/for=
-next)
Merging renesas/next (b66b779c3c2d Merge branch 'heads/soc-cleanups-for-v3.=
19' into next)
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
Merging mips/mips-for-linux-next (c47521dfcdfd Merge branch 'mips-for-linux=
-next' of git://git.linux-mips.org/pub/scm/john/linux-john into mips-for-li=
nux-next)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (5e40d331bd72 Merge branch 'next' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging powerpc/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging powerpc-mpe/next (c3351dfabf5c Merge branch 'for-next' of git://git=
.kernel.org/pub/scm/linux/kernel/git/nab/target-pending)
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
Merging xtensa/for_next (66acb0216d5a Merge tag 'xtensa-for-next-20141021-1=
' of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (a43bb39b5c71 btrfs: Fix compile error when CONFIG_SECUR=
ITY is not set.)
Merging ceph/master (c27a3e4d667f libceph: do not hard code max auth ticket=
 len)
Merging cifs/for-next (6212096bb0a1 [CIFS] Update modinfo cifs version for =
cifs.ko)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (332b122d39c9 eCryptfs: Force RO mount when encrypted=
 view is enabled)
Merging ext3/for_next (3c9cafe05ff0 fs, jbd: use a more generic hash functi=
on)
Merging ext4/dev (813d32f91333 ext4: check s_chksum_driver when looking for=
 bg csum presence)
Merging f2fs/dev (320e655eb9f0 f2fs: remove pointless bit testing in f2fs_d=
elete_entry())
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (bd2614983dd7 GFS2: directly return gfs2_dir_check())
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (f114040e3ea6 Linux 3.18-rc1)
Merging nfsd/nfsd-next (ccc6398ea5d5 nfsd: clean up comments over nfs4_file=
 definition)
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
Merging jdelvare-hwmon/master (625f857de892 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (8c7ff586a6f8 hwmon: (iio_hwmon) Add suppo=
rt for humidity sensors)
Merging v4l-dvb/master (f3d83a101266 [media] s5p-jpeg: Avoid -Wuninitialize=
d warning in s5p_jpeg_parse_hdr)
Merging kbuild/for-next (e9f717fb534c Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (8ccee3cf7d8e Merge branch 'for-3.18' into for-next)
Merging pm/linux-next (1c45d9a920e6 Merge tag 'pm+acpi-3.18-rc2' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm)
Merging idle/next (e7c95ff32d00 tools/power turbostat: tweak whitespace in =
output format)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6ceaf58abe25 Merge branch 'int340x-thermal' of .git i=
nto next)
Merging thermal-soc/next (df67e40f5139 thermal: fix multiple disbalanced de=
vice node counters)
Merging ieee1394/for-next (d584a6627994 firewire: ohci: disable MSI for VIA=
 VT6315 again)
Merging dlm/next (c07127b48c63 dlm: fix missing endian conversion of rcom_s=
tatus flags)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (f114040e3ea6 Linux 3.18-rc1)
Merging net-next/master (9286ae01ac76 Merge branch 'sunvnet-napi')
Merging ipsec-next/master (61ed53deb1c6 Merge tag 'ntb-3.18' of git://githu=
b.com/jonmason/ntb)
Merging wireless-next/master (61ed53deb1c6 Merge tag 'ntb-3.18' of git://gi=
thub.com/jonmason/ntb)
Merging bluetooth/master (f81f466ca588 mac802154: tx: make worker informati=
on static)
$ git reset --hard HEAD^
Merging next-20141023 version of bluetooth
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (8b3d58e55445 mtd: nand: omap: Correct CONFIG_MTD_NAND_O=
MAP_BCH help message)
Merging l2-mtd/master (b00358a5632b nandsim: add id_bytes module parameter)
Merging crypto/master (bac68f2c9a43 crypto: caam - add support for rfc4106(=
gcm(aes)))
Merging drm/drm-next (dfda0df34264 drm/mst: rework payload table allocation=
 to conform better.)
Merging drm-panel/drm/panel/for-next (7d1311b93e58 Linux 3.17-rc1)
Merging drm-intel/for-linux-next (07c338ce9826 drm/i915: fix short vs. long=
 hpd detection)
Merging drm-tegra/drm/tegra/for-next (8ed05f485498 drm/tegra: Depend on COM=
MON_CLK)
Merging drm-misc/topic/core-stuff (5a1cbdb0fb67 gpu: drm: Fix warning cause=
d by a parameter description in drm_crtc.c)
Merging sound/for-next (49d776ffb50f ALSA: pcm: Avoid mmap warnings on x86)
Merging sound-asoc/for-next (a929d726a507 Merge remote-tracking branches 'a=
soc/topic/stac9766' and 'asoc/topic/tegra' into asoc-next)
Merging modules/modules-next (d3051b489aa8 modules, lock around setting of =
MODULE_STATE_UNFORMED)
Merging virtio/virtio-next (1bbc26062754 virtio-rng: refactor probe error h=
andling)
Merging input/next (6696777c6506 Input: add driver for Elan I2C/SMbus touch=
pad)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (d32f6b57523b block: fix wrong error return in eleva=
tor_init())
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
Merging mfd/for-mfd-next (645d10214b28 mfd: tps65910: Convert ti,system-pow=
er-controller DT property to poweroff-source)
Merging backlight/for-backlight-next (b6af73b42219 backlight: omap1: add bl=
ank line after declarations)
Merging battery/master (7881c64716f3 power: ab8500_fg: Fix build warning)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (f114040e3ea6 Linux 3.18-rc1)
Merging regulator/for-next (4089cda09d11 Merge remote-tracking branches 're=
gulator/topic/rn5t618', 'regulator/topic/s2mps11', 'regulator/topic/sky8145=
2', 'regulator/topic/stub' and 'regulator/topic/suspend' into regulator-nex=
t)
Merging security/next (594081ee7145 integrity: do zero padding of the key i=
d)
Merging integrity/next (1b68bdf9cded ima: detect violations for mmaped file=
s)
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (d2aa9ba6cdf4 watchdog: meson: remove magic value f=
or reboot)
Merging iommu/next (f34b4fa45e28 Merge branches 'arm/omap' and 'arm/msm' in=
to next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (93899a679fd6 vfio-pci: Fix remove path locking)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (6808a40dd953 Documentation: Add CONFIG_DEBUG_KME=
MLEAK_DEFAULT_OFF case)
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
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
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
Merging rcu/rcu/next (2c48269eae4d rcu: Remove "cpu" argument to rcu_cleanu=
p_after_idle())
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
Merging xen-tip/linux-next (63401a5dca18 Merge branch 'hypercall_cache_flus=
h_v5' into xentip-linux-next-7)
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
Merging staging/staging-next (b0ef3ed48eb8 staging: rts5208: fix case of bi=
twise operator on zero in ms.c)
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
Merging pinctrl/for-next (a4956b4239c8 Merge branch 'devel' into for-next)
$ git reset --hard HEAD^
Merging next-20141023 version of pinctrl
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (580b9676e53a Documentation: dts: add bindings for Vy=
brid GPIO/PORT module)
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
Merging y2038/y2038 (fffb68ae4b18 power: ab8500_fg.c: use 64-bit time types)
Merging akpm-current/current (5203c520019e ipc-msg-increase-msgmni-remove-s=
caling-checkpatch-fixes)
Applying: mm/cma: include linux/io.h for phys_to_virt()
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (4f019dbfda06 mm: add strictlimit knob)

--Sig_/eX0+11I208x5cb=06371_xD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTdQnAAoJEMDTa8Ir7ZwVGk0P/0dXDae69RvdeyDtBXv1UeP7
WbpbfPPbQKY7EEweRcfaCz8cOCkUV+EUvrWvYHgEOUjzX9ULHL59He2owYoNhazX
suSMLzxo18hy75SjUS565CEaT0YPK7EdouMW29CnaFK57Z2zOLJpRQEyhDZVo2vu
yOX0hyd9Tzlj3lNQtXb/7oT0DMl3vG6AR0DHPkY6t0A11GrC5fhX3dU0tecpSern
h18cfKJJv4+k8c5d7oRC+6CoWYhlc0dcjad9rsXuKp3Hgjy5OURMCjddAEoWoo2f
MRSJrvJEQTPIzA7Me0tOSJ2KcKaK6yf4ZMz38yMDTV3JkQbnD4UQ8CVKswPNG8o0
qN7Pk9n2QWnN5DAiS3OdgS5ik59NuTqkTT9dpGZVDbscGk0jGhzzwCQe+HbUdD82
ErKTW9FctDLOQCWT18lVDMtrvMctnSBhOgkYzgKcj2LnQ/ttarMS0kx9mDOe3Odl
NmQEFS2qrJzg42WRkLRmq0sMgjHKfOjdNnueNUT7J4OXluAnUr1kmApZ3a+GDPlv
pPrydFvI6K1gl/9/M2gUTcO+MZsegrPfJHpL5Y3HbCZ/Wr4exhbsRD9TGnhKhxgU
Gz5IHOqdD3MxPPWCRctyoOEyds9066Do8XD5QHtZLd5pL5ptFtAGq0CDM6990yfl
05uiEabHdLFVLqStwTPY
=kWmO
-----END PGP SIGNATURE-----

--Sig_/eX0+11I208x5cb=06371_xD--
