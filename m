Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaK0MDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:03:13 -0500
Received: from ozlabs.org ([103.22.144.67]:60547 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbaK0MDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:03:07 -0500
Date: Thu, 27 Nov 2014 23:02:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Nov 27
Message-ID: <20141127230251.5273a72f@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XIK7_oS1cLD2CV7fiGQWy+z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XIK7_oS1cLD2CV7fiGQWy+z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141126:

The block tree gained a conflict against the ext4 tree.

The omap_dss2 tree lost its build failure.

The irqchip tree gained a conflict against the mips tree.

The staging tree gained conflicts against the kbuild and vfs trees.

The akpm tree lost a patch that turned up elsewhere.

Non-merge commits (relative to Linus' tree): 9044
 8635 files changed, 334054 insertions(+), 234320 deletions(-)

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

I am currently merging 229 trees (counting Linus' and 32 trees of patches
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
Merging origin/master (3314bf6ba2ac Merge tag 'for-linus' of git://git.kern=
el.org/pub/scm/virt/kvm/kvm)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (f114040e3ea6 Linux 3.18-rc1)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (ef59a20ba375 ARM: 8216/1: xscale: correct auxili=
ary register in suspend/resume)
Merging m68k-current/for-linus (f7bbd12a4b7e m68k: Wire up bpf)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (d7ce4377494a powerpc/fsl_msi: mark the msi=
 cascade handler IRQF_NO_THREAD)
Merging sparc/master (0d1d9092b536 sparc: Add NOP dma_cache_sync() implemen=
tation.)
Merging net/master (d1c637c51d87 Merge tag 'master-2014-11-25' of git://git=
.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging ipsec/master (d10845fc85b2 Merge branch 'gso_encap_fixes')
Merging sound-current/for-linus (d42472ecffd7 ALSA: pcm: Add big-endian DSD=
 sample formats and fix XMOS DSD sample format)
Merging pci-current/for-linus (7fc986d8a972 PCI: Support 64-bit bridge wind=
ows if we have 64-bit dma_addr_t)
Merging wireless/master (7d63a5f9b25b rtlwifi: Change order in device start=
up)
Merging driver-core.current/driver-core-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging tty.current/tty-linus (a5e9ab291c60 Revert "serial: of-serial: add =
PM suspend/resume support")
Merging usb.current/usb-linus (263e80b43559 usb-quirks: Add reset-resume qu=
irk for MS Wireless Laser Mouse 6000)
Merging usb-gadget-fixes/fixes (520fe7633692 usb: dwc3: ep0: fix for dead c=
ode)
Merging usb-serial-fixes/usb-linus (75bcbf29c284 USB: ssu100: fix overrun-e=
rror reporting)
Merging staging.current/staging-linus (8bb9b9a006e8 Merge tag 'iio-fixes-fo=
r-3.18c' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into st=
aging-linus)
Merging char-misc.current/char-misc-linus (0df1f2487d2f Linux 3.18-rc3)
Merging input-current/for-linus (a1f9a4072655 Input: xpad - use proper endp=
oint type)
Merging md-current/for-linus (d47648fcf061 raid5: avoid finding "discard" s=
tripe)
Merging crypto-current/master (24c65bc7037e hwrng: pseries - port to new re=
ad API and fix stack corruption)
Merging ide/master (7546e52b5e3d Drivers: ide: Remove typedef atiixp_ide_ti=
ming)
Merging dwmw2/master (5950f0803ca9 pcmcia: remove RPX board stuff)
Merging devicetree-current/devicetree/merge (094cb98179f1 of/fdt: memblock_=
reserve /memreserve/ regions in the case of partial overlap)
Merging rr-fixes/fixes (3438cf549d2f param: fix crash on bad kernel argumen=
ts)
Merging vfio-fixes/for-linus (239a87020b26 Merge branch 'for-joerg/arm-smmu=
/fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/will/linux into fo=
r-linus)
Merging kselftest-fixes/fixes (884716497d4c selftests/timers: change test t=
o use ksft framework)
Merging drm-intel-fixes/for-linux-next-fixes (afa4e53a7bcd drm/i915: Cancel=
 vdd off work before suspend)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (996bad6cb351 ARC: add power management options)
Merging arm/for-next (fd093429650d Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (cac7f2429872 Linux 3.18-rc2)
Merging arm-soc/for-next (123ccfcc632a Revert merge of sunxi/dt)
Merging bcm2835/for-next (6298ed17a404 ARM: bcm2835: Add device tree for Ra=
spberry Pi model B+)
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
Merging mvebu/for-next (b1385ec5628b Merge branch 'mvebu/dt-usb_phy' into m=
vebu/for-next)
Merging renesas/next (2ed235fdf545 Merge branches 'heads/dt-cleanups-for-v3=
.19', 'heads/dt-clocksource-for-v3.19', 'heads/dt-fixes-for-v3.18', 'heads/=
kconfig-cleanups-for-v3.19', 'heads/clock-fixes-for-v3.18' and 'heads/runti=
me-pm-for-v3.19' into next)
Merging samsung/for-next (9db7d78aca2c Merge branch 'v3.19-next/dt-samsung-=
3' into for-next)
Merging sunxi/sunxi/for-next (ad01dbad5626 Merge branch 'sunxi/clocks-for-3=
.19' into sunxi/for-next)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/sun6i-a31.dtsi
Merging tegra/for-next (620e0b217672 Merge branch for-3.19/soc into for-nex=
t)
Merging arm64/for-next/core (034edabe6cf1 arm64: Move some head.text functi=
ons to executable section)
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (069fb0b63722 syslog: Provide stub check_syslog_permissio=
ns)
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (0259650b4cf7 m68knommu: fix irq handler types i=
n 68360/commproc.c)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (a4f174dee4ae microblaze: Wire up bpf syscall)
Merging mips/mips-for-linux-next (a2443f547166 Merge branch '3.18-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (26981a83bf16 nios2: Make NIOS2_CMDLINE_IGNORE_DTB=
 depend on CMDLINE_BOOL)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (56c381f93d57 Merge branch 'for-linus' of git://=
git.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging powerpc/next (5d01410fe4d9 Linux 3.18-rc6)
Merging powerpc-mpe/next (35891d40bfc4 Merge remote-tracking branch 'scottw=
ood/next' into next)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (e56da345eb52 s390/traps: die on translation exceptio=
ns)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (c47b15c4928c arch/tile: update MAINTAINERS email to EZ=
chip)
Merging uml/next (989e59fa41c5 um: Include generic barrier.h)
CONFLICT (content): Merge conflict in arch/um/include/asm/Kbuild
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (c0d7aa07504a Merge tag 'xtensa-for-next-20141021-2=
' of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (a43bb39b5c71 btrfs: Fix compile error when CONFIG_SECUR=
ITY is not set.)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
Merging cifs/for-next (a8a7a807cd94 Update MAINTAINERS entry)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (942080643bce eCryptfs: Remove buggy and unnecessary =
write in file name decode routine)
Merging ext3/for_next (fdf2657bc81b udf: One function call less in udf_fill=
_super() after error detection)
Merging ext4/dev (b60f6e52435c btrfs: add an is_readonly() so btrfs can use=
 common code for update_time())
Merging f2fs/dev (95f5b0fc5e25 f2fs: fix to recover converted inline_data)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (d7afaec0b564 fuse: add FUSE_NO_OPEN_SUPPORT flag to =
INIT)
Merging gfs2/master (ec7d879c4576 GFS2: gfs2_atomic_open(): simplify the us=
e of finish_no_open())
Merging jfs/jfs-next (bb5e50aaa805 fs/jfs/super.c: convert simple_str to ks=
tr)
Merging logfs/master (339466142b3f Fix the call to BUG() caused by no free =
segment found)
Merging nfs/linux-next (624bd5b7b683 nfs: Add DEALLOCATE support)
Merging nfsd/nfsd-next (d395ac8becda sunrpc: release svc_pool_map reference=
 when serv allocation fails)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (8cb983cec9d1 ovl: support multiple lower =
layers)
Merging squashfs/master (6d565409503f Squashfs: fix failure to unlock pages=
 on decompress error)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (002758992693 xfs: track bulkstat progress by agino)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (8ce74dd60578 Merge tag 'trace-seq-file-cleanup' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into for-ne=
xt)
Merging pci/next (149792795d2b Merge branch 'pci/msi' into next)
Merging hid/for-next (3d9e35c76e08 Merge branch 'for-3.19/wacom' into for-n=
ext)
Merging i2c/i2c/for-next (6e79807443cb Merge branch 'i2c/for-3.19' into i2c=
/for-next)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (e46066eae1df hwmon: Driver for Nuvoton NC=
T7802Y)
Merging v4l-dvb/master (7996d58f03c1 [media] omap: disable COMPILE_TEST)
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
Merging kbuild/for-next (9d07302e14db Merge branch 'kbuild/misc' into kbuil=
d/for-next)
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (598e9a9005ef sata_rcar: Document deprecated "renes=
as,rcar-sata")
Merging pm/linux-next (0349e91d602f Merge branch 'acpi-pm' into linux-next)
Merging idle/next (a8b65b07d753 tools/power turbostat: decode MSR_*_PERF_LI=
MIT_REASONS)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (6ceaf58abe25 Merge branch 'int340x-thermal' of .git i=
nto next)
Merging thermal-soc/next (b1d52b27ea8d Merge branch 'work-linus' into work-=
next)
Merging ieee1394/for-next (51b04d59c274 firewire: ohci: replace vm_map_ram(=
) with vmap())
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (9d3cc3e58429 Merge branch 'topic/at_xdmac' into nex=
t)
Merging net-next/master (799d2fff1858 sky2: Fix crash inside sky2_rx_clean)
CONFLICT (content): Merge conflict in net/netfilter/nf_log.c
Merging ipsec-next/master (12bfa8bdba05 xfrm: Use __xfrm_policy_link in xfr=
m_policy_insert)
Merging wireless-next/master (18ca43823f3c mwifiex: add Tx status support f=
or ACTION frames)
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-fw.h
Merging bluetooth/master (3bb30a7cdf92 Bluetooth: ath3k: Add support of MCI=
 13d3:3408 bt device)
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (89cf38dd536a mtd: cfi_cmdset_0001.c: fix resume for LH2=
8F640BF chips)
Merging l2-mtd/master (068b44b71495 mtd: atmel_nand: replace memcpy32_toio/=
memcpy32_fromio with memcpy)
Merging crypto/master (0653a7cf6fa4 crypto: drbg - use MODULE_ALIAS_CRYPTO)
Merging drm/drm-next (0a3d775fb2c9 MAINTAINERS: add maintainer for i.MX DRM=
 driver)
CONFLICT (content): Merge conflict in drivers/gpu/drm/tegra/dc.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/intel_pm.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_drv.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/exynos/exynos_drm_drv=
.c
Merging drm-panel/drm/panel/for-next (1976dbca047e drm/panel: Add Sharp LQ1=
01R1SX01 support)
Merging drm-intel/for-linux-next (68fe07966064 drm/i915: Deal with video ov=
erlay on GPU reset)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (e5bcbabac53c drm: Handle atomic state pr=
operly in kms getfoo ioctl)
Merging sound/for-next (51e6f47dd2e3 ALSA: asihpi: used parts of message/re=
sponse are zeroed before use)
Merging sound-asoc/for-next (c5faa12aa220 Merge remote-tracking branches 'a=
soc/topic/wm9712' and 'asoc/topic/wm9713' into asoc-next)
Merging modules/modules-next (18eb74fa9416 params: cleanup sysfs allocation)
Merging virtio/virtio-next (5a10b7dbf904 virtio_balloon: free some memory f=
rom balloon on OOM)
Merging input/next (5447326ff7e4 Input: atkbd - correct MSC_SCAN events for=
 force_release keys)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (2ef5864b6dee Merge branch 'for-3.19/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in fs/fs-writeback.c
Merging device-mapper/for-next (c864e2483f19 dm cache: when reloading a dis=
card bitset allow for a different discard block size)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (903101a83949 mmc: omap_hsmmc: Fix UHS card with DDR50 =
support)
CONFLICT (modify/delete): arch/arm/mach-at91/at91sam9g45_devices.c deleted =
in HEAD and modified in mmc-uh/next. Version mmc-uh/next of arch/arm/mach-a=
t91/at91sam9g45_devices.c left in tree.
$ git rm -f arch/arm/mach-at91/at91sam9g45_devices.c
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (206c5f60a3d9 Linux 3.18-rc4)
Merging mfd/for-mfd-next (439b8bddaa1e mfd: da9063: Get irq base dynamicall=
y before registering device)
CONFLICT (content): Merge conflict in drivers/mfd/viperboard.c
Merging backlight/for-backlight-next (3e0e9ce4ae9b backlight: Extend of_fin=
d_backlight_by_node stub-check to modules)
Merging battery/master (99a79565e6db power: ds2782_battery: Simplify the PM=
 hooks)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (10254e83abe1 Merge branches '3.19/simplefb' and=
 '3.19/omapdss' into for-next)
CONFLICT (content): Merge conflict in include/linux/of.h
Merging regulator/for-next (3a0028b1f0f3 Merge remote-tracking branches 're=
gulator/topic/sky81452' and 'regulator/topic/stub' into regulator-next)
Merging security/next (ac14ae25b676 Merge branch 'smack-for-3.19' of git://=
git.gitorious.org/smack-next/kernel into next)
Merging integrity/next (6fb5032ebb1c VFS: refactor vfs_read())
Merging selinux/next (4093a8443941 selinux: normalize audit log formatting)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8ae1a57f54af watchdog: s3c2410_wdt: Fix the mask b=
it offset for Exynos7)
CONFLICT (content): Merge conflict in drivers/watchdog/s3c2410_wdt.c
Merging iommu/next (0747669a8f9f Merge branches 'arm/omap', 'arm/msm', 'arm=
/rockchip', 'arm/renesas', 'arm/smmu', 'x86/vt-d', 'x86/amd' and 'core' int=
o next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (86d3e023e05d Merge branch 'docs-3.19' into docs-=
next)
Merging trivial/for-next (078014dd3698 intel_ips: fix a type in error messa=
ge)
Merging audit/next (0288d7183c41 audit: convert status version to a feature=
 bitmap)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (ce79d54ae447 spi/of: Add OF notifier ha=
ndler)
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging dt-rh/for-next (a0e27f51ba8a documentation: pinctrl bindings: Fix t=
rivial typo 'abitrary')
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (3e91ced55c60 Merge remote-tracking branches 'spi/topi=
c/rockchip', 'spi/topic/samsung', 'spi/topic/sirf' and 'spi/topic/spidev' i=
nto spi-next)
Merging tip/auto-latest (1fdf2540a41b Merge branch 'x86/vdso')
CONFLICT (content): Merge conflict in drivers/pci/host/pcie-rcar.c
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (d0585cd815fa sb_edac: Claim a different PCI device)
Merging edac-amd/for-next (50872ccd8786 EDAC, MCE, AMD: Correct formatting =
of decoded text)
Merging irqchip/irqchip/for-next (b54fc1fefe83 Merge branch 'irqchip/irqdom=
ain-arm' into irqchip/for-next)
CONFLICT (content): Merge conflict in drivers/irqchip/Makefile
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (1dc38aa215e8 Merge branch 'for-next/ftrace/seq-buf=
' into trace/for-next)
Merging rcu/rcu/next (71f55432d812 rcu: Expand SRCU ->completed to 64 bits)
CONFLICT (content): Merge conflict in kernel/sched/core.c
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (b65d6e17fe22 kvm: x86: mask out XSAVES)
CONFLICT (modify/delete): arch/ia64/kvm/kvm-ia64.c deleted in kvm/linux-nex=
t and modified in HEAD. Version HEAD of arch/ia64/kvm/kvm-ia64.c left in tr=
ee.
$ git rm -f arch/ia64/kvm/kvm-ia64.c
Merging kvm-arm/next (016ed39c54b8 arm/arm64: KVM: vgic: kick the specific =
vcpu instead of iterating through all)
CONFLICT (modify/delete): arch/ia64/kvm/kvm-ia64.c deleted in HEAD and modi=
fied in kvm-arm/next. Version kvm-arm/next of arch/ia64/kvm/kvm-ia64.c left=
 in tree.
$ git rm -f arch/ia64/kvm/kvm-ia64.c
Merging kvm-ppc/kvm-ppc-next (8d0eff638564 KVM: PPC: Pass enum to kvmppc_ge=
t_last_inst)
Merging oprofile/for-next (6ce4eac1f600 Linux 3.13-rc1)
Merging fw-nohz/nohz/next (74876a98a87a printk: Wake up klogd using irq_wor=
k)
Merging xen-tip/linux-next (689562c293a6 swiotlb-xen: remove BUG_ON in xen_=
bus_to_phys)
Merging percpu/for-next (bfaa047a9415 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging workqueues/for-next (e09c2c295468 workqueue: apply __WQ_ORDERED to =
create_singlethread_workqueue())
Merging drivers-x86/for-next (e403d4742a6e hp_accel: Add support for HP ZBo=
ok 15)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (a63b87838a59 Merge remote-tracking branches 'regma=
p/topic/ac97' and 'regmap/topic/headers' into regmap-next)
Merging hsi/for-next (d95dc9e38810 HSI: nokia-modem: fix error handling of =
irq_of_parse_and_map)
Merging leds/for-next (7a8685accb95 leds: lp8860: Introduce TI lp8860 4 cha=
nnel LED driver)
Merging ipmi/for-next (ee0a40fd288e Change ACPI IPMI support to "default y")
CONFLICT (content): Merge conflict in arch/powerpc/platforms/powernv/opal-w=
rappers.S
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/opal.h
Merging driver-core/driver-core-next (6386a15c445c Revert "core: platform: =
add warning if driver has no owner")
CONFLICT (content): Merge conflict in sound/soc/intel/sst-haswell-pcm.c
CONFLICT (modify/delete): drivers/staging/media/omap24xx/omap24xxcam.c dele=
ted in HEAD and modified in driver-core/driver-core-next. Version driver-co=
re/driver-core-next of drivers/staging/media/omap24xx/omap24xxcam.c left in=
 tree.
CONFLICT (modify/delete): drivers/net/ieee802154/fakehard.c deleted in HEAD=
 and modified in driver-core/driver-core-next. Version driver-core/driver-c=
ore-next of drivers/net/ieee802154/fakehard.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/devices/docg3.c
CONFLICT (content): Merge conflict in drivers/mfd/syscon.c
CONFLICT (modify/delete): drivers/memory/tegra30-mc.c deleted in HEAD and m=
odified in driver-core/driver-core-next. Version driver-core/driver-core-ne=
xt of drivers/memory/tegra30-mc.c left in tree.
CONFLICT (content): Merge conflict in drivers/leds/leds-gpio.c
CONFLICT (content): Merge conflict in drivers/iommu/tegra-smmu.c
CONFLICT (content): Merge conflict in drivers/input/keyboard/gpio_keys_poll=
ed.c
CONFLICT (content): Merge conflict in drivers/hwmon/ibmpowernv.c
CONFLICT (content): Merge conflict in drivers/bus/omap_l3_noc.c
CONFLICT (content): Merge conflict in drivers/base/Makefile
$ git rm -f drivers/memory/tegra30-mc.c drivers/net/ieee802154/fakehard.c d=
rivers/staging/media/omap24xx/omap24xxcam.c
Merging tty/tty-next (8ad3b1352693 serial: of-serial: add PM suspend/resume=
 support)
CONFLICT (content): Merge conflict in drivers/tty/serial/of_serial.c
CONFLICT (content): Merge conflict in drivers/tty/n_tty.c
Merging usb/usb-next (2d4d9f35bab1 Merge tag 'usb-for-v3.19' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next)
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/dwc3/ep0.c
CONFLICT (content): Merge conflict in drivers/usb/dwc2/gadget.c
Merging usb-gadget/next (ebf3992061db usb: musb: Use IS_ENABLED for tusb601=
0)
Merging usb-serial/usb-next (e7181d005e84 USB: qcserial: Add support for HP=
 lt4112 LTE/HSPA+ Gobi 4G Modem)
Merging staging/staging-next (2d00bd17a270 staging: lustre: Coalesce string=
 fragments)
CONFLICT (modify/delete): drivers/staging/media/omap24xx/tcm825x.c deleted =
in HEAD and modified in staging/staging-next. Version staging/staging-next =
of drivers/staging/media/omap24xx/tcm825x.c left in tree.
CONFLICT (modify/delete): drivers/staging/media/omap24xx/omap24xxcam.c dele=
ted in HEAD and modified in staging/staging-next. Version staging/staging-n=
ext of drivers/staging/media/omap24xx/omap24xxcam.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_imon.c
CONFLICT (modify/delete): drivers/staging/media/lirc/lirc_igorplugusb.c del=
eted in HEAD and modified in staging/staging-next. Version staging/staging-=
next of drivers/staging/media/lirc/lirc_igorplugusb.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/s=
tatahead.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/n=
amei.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/l=
lite_lib.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/l=
lite_internal.h
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/f=
ile.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/d=
cache.c
CONFLICT (content): Merge conflict in .gitignore
$ git rm -f drivers/staging/media/lirc/lirc_igorplugusb.c drivers/staging/m=
edia/omap24xx/omap24xxcam.c drivers/staging/media/omap24xx/tcm825x.c
Merging char-misc/char-misc-next (e88b1fc6a1c1 Revert "misc: always assign =
miscdevice to file->private_data in open()")
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/Kconfig
CONFLICT (modify/delete): arch/arm/kernel/etm.c deleted in char-misc/char-m=
isc-next and modified in HEAD. Version HEAD of arch/arm/kernel/etm.c left i=
n tree.
$ git rm -f arch/arm/kernel/etm.c
Merging cgroup/for-next (eeecbd197151 cgroup: implement cgroup_get_e_css())
Merging scsi/for-next (47a4ad6981d8 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.18' into for-next)
CONFLICT (content): Merge conflict in drivers/usb/storage/uas.c
Merging target-updates/for-next (95e22500b3fe target: Fix target_core_regis=
ter_fabric() for built-in fabric modules)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (7bc043cd6861 Merge branch 'devel' into for-next)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-rockchip.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/ste-nomadik-stn8815=
.dtsi
Applying: pinctrl: nomadik: fix up for binding changes
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (397944df3290 rpmsg: fix kconfig dependencies for VI=
RTIO)
Merging gpio/for-next (5cd3b5774ca1 gpio: mcp23s08: Do not free unrequested=
 interrupt)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (06e4cb6b1d5c pwm: samsung: Allow Samsung PWM driver t=
o be enabled on Exynos7)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (a1998908ba46 nfs: fix kernel warning when removing=
 proc entry)
CONFLICT (content): Merge conflict in fs/nfs/client.c
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (98d147f50eb0 clk: pxa clocks build system fix)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (d3785cf42979 Merge ../aio-fixes)
Merging llvmlinux/for-next (ec25a590c29c arm: LLVMLinux: Use global stack r=
egister variable for percpu)
CONFLICT (content): Merge conflict in include/crypto/hash.h
CONFLICT (content): Merge conflict in drivers/crypto/qat/qat_common/qat_alg=
s.c
Merging documentation/for-next (0415447aa3b4 Documentation: fix broken v4l-=
utils URL)
Merging kselftest/next (a2f19efd2e10 selftests/user: add install target to =
enable installing test)
CONFLICT (content): Merge conflict in tools/testing/selftests/user/Makefile
CONFLICT (content): Merge conflict in tools/testing/selftests/net/Makefile
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
Merging akpm-current/current (8895b8fe5776 shmdt: use i_size_read() instead=
 of ->i_size)
CONFLICT (content): Merge conflict in mm/hugetlb.c
CONFLICT (content): Merge conflict in kernel/printk/printk.c
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in fs/ocfs2/inode.h
CONFLICT (content): Merge conflict in drivers/usb/storage/debug.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-omap.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ven=
dor-prefixes.txt
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/i2c=
/trivial-devices.txt
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: slab: fix cpuset check in fallback_alloc
Applying: slub: fix cpuset check in get_any_partial
Applying: mm/cma: make kmemleak ignore CMA regions
Applying: mm: cma: split cma-reserved in dmesg log
Applying: fs: proc: include cma info in proc/meminfo
Applying: lib/show_mem.c: adds cma reserved information
Applying: lib-show_mem-this-patch-adds-cma-reserved-infromation-fix
Applying: fallocate: create FAN_MODIFY and IN_MODIFY events
Applying: tools/testing/selftests/Makefile: alphasort the TARGETS list
Applying: fsnotify: unify inode and mount marks handling
Applying: fsnotify: remove destroy_list from fsnotify_mark
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (3777fe4f661a mm: add strictlimit knob)

--Sig_/XIK7_oS1cLD2CV7fiGQWy+z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdxL4AAoJEMDTa8Ir7ZwVupQQAIEIqYHvRLZ5v6RCiQRRTJxz
4ksC5elhlu3/mQrYSJcg59lNEpbLoJxXywlCZgI17/LKELD+4hSTSBgplSy7/9H0
d07/cz2RVb9oRXKRXhNan0BFc9vCsDRLwPypmDdysYV3oC0H6/GNgsMCvMHGQABZ
l75pGvwUmAd4mc86jO1AiZDIUWqfdztRQ6CwNiSK6tOzlrtSO54Kh+8/zce8E117
9yq+sCFv5FI0YxBI5hpde8h4IL07ewqWzoUX5/XOneWF9UYnmLDzIvemNmv3aOVb
6BLA9E1kd8KmU4IDO6YkLx7OEvXCp9HBwFHeRble75zl54XnQXPRq2LBuXQeypmb
Ofvp0aW9R5i30VteAA4x/bc+7JtudIz67SsAYMtr6iG+/ZZIfMV0zGN1x/e3buXI
7iLPDhVNxL1Cc/9HKHyLAye8iZYoSgUSMjM2FGRsWgW0XyQGuM6U8qmeIQZ3t7Pu
5NZdEiG67Dc9aCM/HvMNUxrcLe14k4d2+1mwCbmabyvU1K5W//dB+UfgHVHxFl7X
/sdISTt3yge6AOAphaVcizsv9WK75Qc/M4g1G2mGVFyImNgXdNQMrHsbEPzKszp+
UHCnXX7E40UMAAhM20ElMjIoO/yWmzDEWAazRAhOJfpHHnswZX8QIkxUB5Tf3keL
Aw80KQdWFknE1LYCpiJA
=NBzg
-----END PGP SIGNATURE-----

--Sig_/XIK7_oS1cLD2CV7fiGQWy+z--
