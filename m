Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaLREyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 23:54:54 -0500
Received: from ozlabs.org ([103.22.144.67]:42389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbaLREyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 23:54:50 -0500
Date: Thu, 18 Dec 2014 15:54:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Dec 18
Message-ID: <20141218155440.1d669871@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jWxr94Ka+FHgtGZG0hrWhpn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jWxr94Ka+FHgtGZG0hrWhpn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

There will only be intermittent releases of linux-next between now and
Jan 5.

Please do not add any code destined for v3.20 to your linux-next included
trees/branches until after v3.19-rc1 is released.

Changes since 20141217:

The modules tree gained a build failure so I merged a supplied newer
version of the tree.

The ipmi tree lost its build failure.

The clk tree lost its build failure.

Non-merge commits (relative to Linus' tree): 916
 1062 files changed, 28749 insertions(+), 24071 deletions(-)

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

I am currently merging 231 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (87c31b39abcb Merge branch 'for-linus' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (f114040e3ea6 Linux 3.18-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (3f4aa45ceea5 ARM: 8226/1: cacheflush: get rid of=
 restarting block)
Merging m68k-current/for-linus (f0b99a643e96 m68k/mm: Eliminate memset afte=
r alloc_bootmem_pages)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (b2776bf7149b Linux 3.18)
Merging sparc/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging net/master (65891feac27e net: Disallow providing non zero VLAN ID f=
or NIC drivers FDB add flow)
Merging ipsec/master (f855691975bb xfrm6: Fix the nexthdr offset in _decode=
_session6.)
Merging sound-current/for-linus (7327643ba158 ALSA: hda - Add quirk for Pac=
kard Bell EasyNote MX65)
Merging pci-current/for-linus (5106787a9e08 PCI: tegra: Use physical range =
for I/O mapping)
Merging wireless/master (9a1dce3a0591 rtlwifi: rtl8192ce: Set fw_ready flag)
Merging driver-core.current/driver-core-linus (2dbfca5a1819 Merge branch 'f=
or-next' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-le=
ds)
Merging tty.current/tty-linus (2dbfca5a1819 Merge branch 'for-next' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging usb.current/usb-linus (2dbfca5a1819 Merge branch 'for-next' of git:=
//git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging usb-gadget-fixes/fixes (520fe7633692 usb: dwc3: ep0: fix for dead c=
ode)
Merging usb-serial-fixes/usb-linus (009d0431c391 Linux 3.18-rc7)
Merging staging.current/staging-linus (2dbfca5a1819 Merge branch 'for-next'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging char-misc.current/char-misc-linus (67e2c3883828 Merge branch 'next'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging input-current/for-linus (f20c86cd75f1 Merge branch 'next' into for-=
linus)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (8606813a6c89 crypto: tcrypt - Allow speed te=
sting of arbitrary hash functions)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (094cb98179f1 of/fdt: memblock_=
reserve /memreserve/ regions in the case of partial overlap)
Merging rr-fixes/fixes (3438cf549d2f param: fix crash on bad kernel argumen=
ts)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (3ce51050fadd selftest: size: Add size test f=
or Linux kernel)
Merging drm-intel-fixes/for-linux-next-fixes (b0616c5306b3 drm/i915: Unlock=
 panel even when LVDS is disabled)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (7a70bf797a58 ARC: rename default defconfig)
Merging arm/for-next (e9f2d6d66037 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (cac7f2429872 Linux 3.18-rc2)
Merging arm-soc/for-next (d6ad36913083 clocksource: arch_timer: Only use th=
e virtual counter (CNTVCT) on arm64)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (91bcb334bf0b Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (f0d7515372ff ARM: v7m: add trivial suspend suppo=
rt)
Merging ep93xx/ep93xx-for-next (bfb0709fd17b Merge branch 'ep93xx-fixes' in=
to ep93xx-for-next)
Merging imx-mxs/for-next (8a73e870fc56 Merge tag 'imx-dt-3.19' into for-nex=
t)
Merging ixp4xx/next (19f949f52599 Linux 3.8)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging msm/for-next (81cf1e061d00 ARM: msm: Rename msm devicetrees to have=
 standard 'qcom' prefix)
Merging mvebu/for-next (9993917cbc99 Merge branch 'mvebu/dt-usb_phy' into m=
vebu/for-next)
Merging renesas/next (b56fb445a83f Merge branch 'heads/defconfig-fixes-for-=
v3.19' into next)
Merging samsung/for-next (9db7d78aca2c Merge branch 'v3.19-next/dt-samsung-=
3' into for-next)
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
Merging sunxi/sunxi/for-next (ad01dbad5626 Merge branch 'sunxi/clocks-for-3=
.19' into sunxi/for-next)
Merging tegra/for-next (fa047e01365d Merge branch for-3.19/soc into for-nex=
t)
Merging arm64/for-next/core (fb59d007a0e4 arm64: mm: dump: don't skip final=
 region)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (8914d7e85780 Hexagon: fix signal delivery for d=
ebug traps)
Merging ia64/next (0fd2468fd035 Merge branch 'misc-3.19' into next)
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (0259650b4cf7 m68knommu: fix irq handler types i=
n 68360/commproc.c)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (3a8e3265179b microblaze: Fix mmap for cache cohere=
nt memory)
Merging mips/mips-for-linux-next (79d2311c46a7 Merge branch '3.19-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (f1f2eac9124b nios2/uaccess: fix sparse errors)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (aa47b141a43a parisc: fix out-of-register compil=
er error in ldcw inline assembler function)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (c8742f85125d powerpc/powernv: Expose OPAL firmwar=
e symbol map)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (351997810131 s390/cputime: fix 31-bit compile)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (c47b15c4928c arch/tile: update MAINTAINERS email to EZ=
chip)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (1f2fdbd0078c xtensa: disable link optimization)
Merging btrfs/next (1edb647bb954 Btrfs: remove non-sense btrfs_error_discar=
d_extent() function)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
Merging cifs/for-next (97c7134ae22f Fix signed/unsigned pointer warning)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (942080643bce eCryptfs: Remove buggy and unnecessary =
write in file name decode routine)
Merging ext3/for_next (f54e18f1b831 isofs: Fix infinite looping over CE ent=
ries)
Merging ext4/dev (50db71abc529 ext4: ext4_da_convert_inline_data_to_extent =
drop locked page after error)
Merging f2fs/dev (635aee1fefef f2fs: avoid to ra unneeded blocks in recover=
 flow)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (1c68271cf1bf fuse: use file_inode() in fuse_file_fal=
locate())
Merging gfs2/master (ec7d879c4576 GFS2: gfs2_atomic_open(): simplify the us=
e of finish_no_open())
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (388f0c776781 sunrpc: add a debugfs rpc_xprt directo=
ry with an info file in it)
Merging nfsd/nfsd-next (3c0aeb6da065 nfsd: fi_delegees doesn't need to be a=
n atomic_t)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (2b7a8f36f092 ovl: add testsuite to docs)
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (6044e4386cd5 Merge branch 'xfs-misc-fixes-for-3.19-2'=
 into for-next)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (9d4d65748a5c vfs: make mounts and mountstats honor ro=
ot dir like mountinfo does)
Merging pci/next (149792795d2b Merge branch 'pci/msi' into next)
Merging hid/for-next (59ed9d7ed29a Merge branch 'for-3.20/logitech' into fo=
r-next)
Merging i2c/i2c/for-next (f16ea4f0e180 i2c: sh_mobile: I2C_SH_MOBILE should=
 depend on HAS_DMA)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (907a6d582459 hwmon: (tmp401) Detect TMP43=
5 on all addresses it supports)
Merging v4l-dvb/master (2ea3258b238c Merge branch 'patchwork' into to_next)
Merging kbuild/for-next (657eeca39128 Merge branch 'kbuild/misc' into kbuil=
d/for-next)
CONFLICT (content): Merge conflict in scripts/Kbuild.include
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (d325a876e2b3 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging pm/linux-next (33a872aedc26 Merge branches 'acpi-video' and 'acpi-e=
c')
Merging idle/next (b5805c6d135b Merge branch 'sfi' into release)
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (2707dbd09a85 Merge branches 'thermal-core-fix', 'ther=
mal-soc' and 'thermal-int340x' into next)
Merging thermal-soc/next (d8c3cd75e77d Merge branch 'work-fixes' into work-=
next)
Merging ieee1394/for-next (d737d7da8e7e firewire: sbp2: replace card lock b=
y target lock)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (9a0a47f5e620 Merge branch 'for-linus' into next)
Merging net-next/master (f96fe225677b Merge git://git.kernel.org/pub/scm/li=
nux/kernel/git/davem/net)
Merging ipsec-next/master (fbe68ee87522 vti6: Add a lookup method for tunne=
ls with wildcard endpoints.)
Merging wireless-next/master (81c412600f94 Merge branch 'master' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging bluetooth/master (b2ae82c08a54 Bluetooth: btusb: support public add=
ress configuration for ath3012)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (68f29815034e mtd: tests: abort torturetest on erase err=
ors)
Merging l2-mtd/master (68f29815034e mtd: tests: abort torturetest on erase =
errors)
Merging crypto/master (8606813a6c89 crypto: tcrypt - Allow speed testing of=
 arbitrary hash functions)
Merging drm/drm-next (4e0cd6811562 drm: sti: fix module compilation issue)
Merging drm-panel/drm/panel/for-next (1976dbca047e drm/panel: Add Sharp LQ1=
01R1SX01 support)
Merging drm-intel/for-linux-next (2c550183476d drm/i915: Disable PSMI sleep=
 messages on all rings around context switches)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (7bf2844ed14d drm/fb-helper: Propagate er=
rors from initial config failure)
Merging sound/for-next (7327643ba158 ALSA: hda - Add quirk for Packard Bell=
 EasyNote MX65)
Merging sound-asoc/for-next (c52e5698efef Merge remote-tracking branches 'a=
soc/fix/atmel', 'asoc/fix/intel', 'asoc/fix/rt5645', 'asoc/fix/rt5677' and =
'asoc/fix/samsung' into asoc-linus)
Merging modules/modules-next (12491941a26c param: do not set store func wit=
hout write perm)
$ git reset --hard HEAD^
Merging modules/modules-next (b0a65b0cccd4 param: do not set store func wit=
hout write perm)
Merging virtio/virtio-next (5a10b7dbf904 virtio_balloon: free some memory f=
rom balloon on OOM)
Merging input/next (7c12a5b19e13 Input: stmpe - bias keypad columns properl=
y)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (e248d2ba0082 Merge branch 'for-3.19/drivers' into f=
or-next)
Merging device-mapper/for-next (5164bece1673 dm: fix missed error code if .=
end_io isn't implemented by target_type)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (79b8f3c845d1 PM: Remove the SET_PM_RUNTIME_PM_OPS() ma=
cro)
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (f851b60db0fd md: Check MD_RECOVERY_RUNNING as well as =
->sync_thread.)
Merging mfd/for-mfd-next (a3b63979f8a3 mfd: rtsx: Add func to split u32 int=
o register)
Merging backlight/for-backlight-next (3d6969a641d0 MAINTAINERS: Remove my n=
ame from Backlight subsystem)
Merging battery/master (b81180b3fd48 power: reset: adjust priority of simpl=
e syscon reboot driver)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (574d54112fda Merge branches '3.19/omapdss' and =
'3.19/simplefb' into for-next)
Merging regulator/for-next (1222d8fe578c regulator: s2mps11: Fix dw_mmc fai=
lure on Gear 2)
Merging security/next (b2d1965dcea1 Merge branch 'next' of git://git.infrad=
ead.org/users/pcmoore/selinux into next)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (00fec2a10b51 selinux: Remove security_ops extern)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (2193e69bf650 watchdog: imx2_wdt: Fix the argument =
of watchdog_active())
CONFLICT (content): Merge conflict in drivers/watchdog/imx2_wdt.c
Merging iommu/next (76771c938e95 Merge branches 'arm/omap', 'arm/msm', 'arm=
/rockchip', 'arm/renesas', 'arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' int=
o next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (9b64c09bb960 kobject: grammar fix)
Merging trivial/for-next (078014dd3698 intel_ips: fix a type in error messa=
ge)
Merging audit/next (0288d7183c41 audit: convert status version to a feature=
 bitmap)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (c46ca3c8310b of: Delete unnecessary che=
ck before calling "of_node_put()")
Merging dt-rh/for-next (a0e27f51ba8a documentation: pinctrl bindings: Fix t=
rivial typo 'abitrary')
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (015760563ec7 spi: sh-msiof: Add runtime PM lock in in=
itializing)
Merging tip/auto-latest (aa0f6b220f8a Merge branch 'x86/urgent')
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (50872ccd8786 EDAC, MCE, AMD: Correct formatting =
of decoded text)
Merging irqchip/irqchip/for-next (5cc8f658723f Merge branch 'irqchip/irqdom=
ain-arm' into irqchip/for-next)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (0daa2302968c tracing: Add tp_printk cmdline to hav=
e tracepoints go to printk())
Merging rcu/rcu/next (3cd05fcfa269 Merge tag 'v3.18-rc6' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (333bce5aac9e Merge tag 'kvm-arm-for-3.19-take2' of =
git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD)
CONFLICT (modify/delete): arch/ia64/kvm/kvm-ia64.c deleted in kvm/linux-nex=
t and modified in HEAD. Version HEAD of arch/ia64/kvm/kvm-ia64.c left in tr=
ee.
$ git rm -f arch/ia64/kvm/kvm-ia64.c
Merging kvm-arm/next (05971120fca4 arm/arm64: KVM: Require in-kernel vgic f=
or the arch timers)
Merging kvm-ppc/kvm-ppc-next (e08e833616f7 KVM: cpuid: recompute CPUID 0xD.=
0:EBX,ECX)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
Applying: arm: introduce is_device_dma_coherent merge fix
Merging percpu/for-next (bfaa047a9415 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging workqueues/for-next (008847f66c38 workqueue: allow rescuer thread t=
o do more work.)
Merging drivers-x86/for-next (200db647112d platform/x86/acerhdf: Still depe=
nds on THERMAL)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (b2776bf7149b Linux 3.18)
Merging hsi/for-next (d95dc9e38810 HSI: nokia-modem: fix error handling of =
irq_of_parse_and_map)
Merging leds/for-next (2969bb18f889 leds: lp8860: Fix module dependency)
Merging ipmi/for-next (98e0721c20db ipmi: Fix compile issue with isspace())
Merging driver-core/driver-core-next (2dbfca5a1819 Merge branch 'for-next' =
of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging tty/tty-next (2dbfca5a1819 Merge branch 'for-next' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging usb/usb-next (2dbfca5a1819 Merge branch 'for-next' of git://git.ker=
nel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging usb-gadget/next (ebf3992061db usb: musb: Use IS_ENABLED for tusb601=
0)
Merging usb-serial/usb-next (e7181d005e84 USB: qcserial: Add support for HP=
 lt4112 LTE/HSPA+ Gobi 4G Modem)
Merging staging/staging-next (2dbfca5a1819 Merge branch 'for-next' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging char-misc/char-misc-next (67e2c3883828 Merge branch 'next' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security)
Merging cgroup/for-next (eeecbd197151 cgroup: implement cgroup_get_e_css())
Merging scsi/for-next (49f096fcbaec Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.19' into for-next)
Merging target-updates/for-next (6bf6ca7515c1 iscsi-target: Fail connection=
 on short sendmsg writes)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (96dfdff694ae pinctrl: rockchip: Fix enable/disabl=
e/mask/unmask)
Merging vhost/linux-next (5ff16110c637 virtio_pci: restore module attribute=
s)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (170680abd1eb gpio: mcp23s08: fix up compilation erro=
r)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (39e046f2c1dd pwm: atmel-hlcdc: add at91sam9x5 and sam=
a5d3 errata handling)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (db86da7cb76f userns: Unbreak the unprivileged remo=
unt tests)
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (f1e9203e2366 clk: samsung: Fix Exynos 5420 pinctrl se=
tup and clock disable failure due to domain being gated)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (5f785de58873 aio: Skip timer for io_getevents if timeou=
t=3D0)
Merging llvmlinux/for-next (25d4aee23af2 arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
Merging kselftest/next (0df1f2487d2f Linux 3.18-rc3)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
Merging luto-misc/next (6ce4436c9cbe Merge tag 'please-pull-morepstore' of =
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux)
Merging access_once/linux-next (172c4a69a8cb arm/rpc: avoid static keyword =
removal via define)
Applying: x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE
Merging akpm-current/current (350b61c87ab5 metag: Align thread_info::superv=
isor_stack)
CONFLICT (modify/delete): mm/fremap.c deleted in akpm-current/current and m=
odified in HEAD. Version HEAD of mm/fremap.c left in tree.
$ git rm -f mm/fremap.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: tools/testing/selftests/Makefile: alphasort the TARGETS list
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (682fb0d396c1 mm: add strictlimit knob)

--Sig_/jWxr94Ka+FHgtGZG0hrWhpn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkl4XAAoJEMDTa8Ir7ZwVhpgP/RCmNuTh0wIXKN7JOshYe8gT
zBmhL78jcc5bpvSsxTrQ2kUgs3yosGVNeST430reFKprQ/DtIFXywLpU1i+H1vC/
KiKZ+xF2rVK12N96isFKztZmrwD/Ygtv/cEndBeh1Qdf1dGBXzX35cGY98NcL7z4
2xyRbBQCaQPGbU+fxt8umkMKz9lFbHFg5jyGgCd51QUSSxDvBQ6nBDOXaP/xzBGj
TvnZ3SiWDlPzwEDAHW1XyuCbl77YpAAazPxdhKB/nmSh3mhw/elx6+ffe+9TN5Vo
kNXt/6qVZiVxqAJcBPgCp+PEiagrs5QzGO5TfNwgXK2wlYPAHjICWN9fcFzMzD8p
WQiAwimZkhi6a/IrfOPzHxuunUaO/+PwObatFMLZ3wn+IF1J4+nMkeZzWFnTG6BN
59THjQs0xHLWPm0AKGz9CUgzqdfdd+65McQARN6SmbhY8JVRfaFdwniP4uIhLS/g
LK81cZU7jkkAgxsECkbno4O+twUcZKvfJnwW8WHSFRvpdpu4/MH6v6VzSqeQHmPg
gmZk29gp/1gVohmv4BFFLssis8zGdN2QizR0HSMJS6PYcVDRMgrGaMPk7ZtOSthn
CMrLKCOak3RApXlWHteTxzA1O8s0lpZUyf80dheOtn/8ibcsAN1QxjSZZ20fCFV7
6JjMG1Txu65A4ITyR037
=A3Cp
-----END PGP SIGNATURE-----

--Sig_/jWxr94Ka+FHgtGZG0hrWhpn--
