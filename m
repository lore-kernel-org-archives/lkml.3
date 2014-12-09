Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbaLINNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:13:52 -0500
Received: from ozlabs.org ([103.22.144.67]:57901 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbaLINNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:13:46 -0500
Date: Wed, 10 Dec 2014 00:13:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Dec 9
Message-ID: <20141210001335.53661d6e@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/C1AkBQ6UM+m7mOo5q2eW62w"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/C1AkBQ6UM+m7mOo5q2eW62w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20141208:

Dropped tree: access_once

The thermal tree gained a build failure so I used the version from
next-20141208.

The slave-dma tree gained a conflict against the arm tree.

The spi tree lost its build failures.

The rcu tree gained a build failure for which I reverted a commit.

The usb tree still had its build failure so I used the version from
next-20141128.

The access_once tree lost its build failure and gained a semantic merge
fix patch, but gained more build failures, so I dropped it again.

Non-merge commits (relative to Linus' tree): 10745
 9729 files changed, 400815 insertions(+), 285648 deletions(-)

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
Merging origin/master (b2776bf7149b Linux 3.18)
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
Merging powerpc-merge-mpe/fixes (152d44a853e4 powerpc: 32 bit getcpu VDSO f=
unction uses 64 bit instructions)
Merging sparc/master (0d1d9092b536 sparc: Add NOP dma_cache_sync() implemen=
tation.)
Merging net/master (f2a01517f2a1 openvswitch: Fix flow mask validation.)
Merging ipsec/master (f2a01517f2a1 openvswitch: Fix flow mask validation.)
Merging sound-current/for-linus (bf35df66f1c6 ALSA: jack: Add dummy snd_jac=
k_set_key() definition)
Merging pci-current/for-linus (5106787a9e08 PCI: tegra: Use physical range =
for I/O mapping)
Merging wireless/master (87141db0848a rtlwifi: rtl8192ce: Fix missing inter=
rupt ready flag)
Merging driver-core.current/driver-core-linus (206c5f60a3d9 Linux 3.18-rc4)
Merging tty.current/tty-linus (009d0431c391 Linux 3.18-rc7)
Merging usb.current/usb-linus (009d0431c391 Linux 3.18-rc7)
Merging usb-gadget-fixes/fixes (520fe7633692 usb: dwc3: ep0: fix for dead c=
ode)
Merging usb-serial-fixes/usb-linus (009d0431c391 Linux 3.18-rc7)
Merging staging.current/staging-linus (009d0431c391 Linux 3.18-rc7)
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
Merging kselftest-fixes/fixes (3ce51050fadd selftest: size: Add size test f=
or Linux kernel)
Merging drm-intel-fixes/for-linux-next-fixes (b0616c5306b3 drm/i915: Unlock=
 panel even when LVDS is disabled)
Merging asm-generic/master (cb61f6769b88 ARM64: use GENERIC_PCI_IOMAP)
Merging arc/for-next (996bad6cb351 ARC: add power management options)
Merging arm/for-next (e9f2d6d66037 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (cac7f2429872 Linux 3.18-rc2)
Merging arm-soc/for-next (362e82d6e295 arm-soc: document merges)
Merging bcm2835/for-next (6298ed17a404 ARM: bcm2835: Add device tree for Ra=
spberry Pi model B+)
CONFLICT (content): Merge conflict in arch/arm/boot/dts/Makefile
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
Merging renesas/next (2ed235fdf545 Merge branches 'heads/dt-cleanups-for-v3=
.19', 'heads/dt-clocksource-for-v3.19', 'heads/dt-fixes-for-v3.18', 'heads/=
kconfig-cleanups-for-v3.19', 'heads/clock-fixes-for-v3.18' and 'heads/runti=
me-pm-for-v3.19' into next)
Merging samsung/for-next (9db7d78aca2c Merge branch 'v3.19-next/dt-samsung-=
3' into for-next)
CONFLICT (content): Merge conflict in arch/arm64/Kconfig
Merging sunxi/sunxi/for-next (ad01dbad5626 Merge branch 'sunxi/clocks-for-3=
.19' into sunxi/for-next)
Merging tegra/for-next (fa047e01365d Merge branch for-3.19/soc into for-nex=
t)
Merging arm64/for-next/core (eb8a653137b7 arm64: remove the unnecessary arm=
64_swiotlb_init())
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (21bd887cd7c4 CRISv32: Remove last remnants of ETRAX_=
SPI_MMC_BOARD)
Merging hexagon/linux-next (a9a44fdf3296 Hexagon: update CR year for elf.h)
Merging ia64/next (0fd2468fd035 Merge branch 'misc-3.19' into next)
Merging m68k/for-next (f0b99a643e96 m68k/mm: Eliminate memset after alloc_b=
ootmem_pages)
Merging m68knommu/for-next (0259650b4cf7 m68knommu: fix irq handler types i=
n 68360/commproc.c)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (a4f174dee4ae microblaze: Wire up bpf syscall)
Merging mips/mips-for-linux-next (17aabbd94a29 Merge branch '3.18-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (2b2b4074e647 nios2: Make NIOS2_CMDLINE_IGNORE_DTB=
 depend on CMDLINE_BOOL)
Merging openrisc/for-upstream (548dafe880ad openrisc: Use get_signal() sign=
al_setup_done())
Merging parisc/for-next (6c700d71f7fa [PARISC] hpux: Remove obsolete regs p=
arameter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (b2776bf7149b Linux 3.18)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (56548fc0e86c powerpc/powernv: Return to cpu offli=
ne loop when finished in KVM guest)
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
Merging xtensa/for_next (c0d7aa07504a Merge tag 'xtensa-for-next-20141021-2=
' of git://github.com/jcmvbkbc/linux-xtensa into for_next)
Merging btrfs/next (9627aeee3e20 Merge branch 'raid56-scrub-replace' of git=
://github.com/miaoxie/linux-btrfs into for-linus)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
Merging cifs/for-next (15d987063348 cifs: remove unneeded condition check)
Merging configfs/linux-next (b930c26416c4 Merge branch 'for-linus' of git:/=
/git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (942080643bce eCryptfs: Remove buggy and unnecessary =
write in file name decode routine)
Merging ext3/for_next (fdf2657bc81b udf: One function call less in udf_fill=
_super() after error detection)
Merging ext4/dev (b189e97a43b7 ext4: ext4_da_convert_inline_data_to_extent =
drop locked page after error V2)
Merging f2fs/dev (cb39c224dbc7 f2fs: count the number of inmemory pages)
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
Merging nfs/linux-next (388f0c776781 sunrpc: add a debugfs rpc_xprt directo=
ry with an info file in it)
Merging nfsd/nfsd-next (d395ac8becda sunrpc: release svc_pool_map reference=
 when serv allocation fails)
Merging omfs/for-next (976d167615b6 Linux 3.1-rc9)
Merging overlayfs/overlayfs-next (8cb983cec9d1 ovl: support multiple lower =
layers)
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (f38aed975c0c UBI: Fix invalid vfree())
Merging xfs/for-next (6044e4386cd5 Merge branch 'xfs-misc-fixes-for-3.19-2'=
 into for-next)
Merging file-locks/linux-next (1b2b32dcdb3d locks: fix fcntl_setlease/getle=
ase return when !CONFIG_FILE_LOCKING)
Merging vfs/for-next (683751000dad Merge branch 'iov_iter' into for-next)
Merging pci/next (149792795d2b Merge branch 'pci/msi' into next)
Merging hid/for-next (7059c360d9bd Merge branch 'for-3.19/wacom' into for-n=
ext)
Merging i2c/i2c/for-next (c13ea29a7ce6 Merge branch 'i2c/for-3.19' into i2c=
/for-next)
Merging jdelvare-hwmon/master (ae530d4403e9 hwmon: (i5500_temp) Convert to =
use ATTRIBUTE_GROUPS macro)
Merging hwmon-staging/hwmon-next (907a6d582459 hwmon: (tmp401) Detect TMP43=
5 on all addresses it supports)
Merging v4l-dvb/master (4d0522ca5d07 Merge branch 'patchwork' into to_next)
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-rx51-periph=
erals.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/meson.dtsi
Merging kbuild/for-next (09e6511b4b0b Merge branch 'kbuild/kbuild' into kbu=
ild/for-next)
CONFLICT (content): Merge conflict in scripts/Kbuild.include
Merging kconfig/for-next (95edca5c523c localmodconfig: Add config depends b=
y default settings)
Merging libata/for-next (d325a876e2b3 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging pm/linux-next (2e50fb96d61e Merge branch 'pm-tools' into linux-next)
CONFLICT (content): Merge conflict in include/linux/pm_runtime.h
Merging idle/next (a8b65b07d753 tools/power turbostat: decode MSR_*_PERF_LI=
MIT_REASONS)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging cpupowerutils/master (f16603386b38 cpupower tools: add install targ=
et to the debug tools' makefiles)
Merging thermal/next (4106eba9589a Merge branches 'thermal-core-fix', 'ther=
mal-soc' and 'thermal-int340x' into next)
$ git reset --hard HEAD^
Merging next-20141208 version of thermal
Merging thermal-soc/next (b1d52b27ea8d Merge branch 'work-linus' into work-=
next)
Merging ieee1394/for-next (51b04d59c274 firewire: ohci: replace vm_map_ram(=
) with vmap())
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (24ff7a433f6f Merge branch 'topic/slave_caps_device_=
control_fix' into next)
CONFLICT (content): Merge conflict in drivers/dma/pl330.c
$ git reset --hard HEAD^
Merging next-20141208 version of slave-dma
Merging net-next/master (8d0c4697534a Merge branch 'ebpf-next')
CONFLICT (content): Merge conflict in net/netfilter/nf_log.c
CONFLICT (content): Merge conflict in include/uapi/linux/Kbuild
Merging ipsec-next/master (fbe68ee87522 vti6: Add a lookup method for tunne=
ls with wildcard endpoints.)
Merging wireless-next/master (81c412600f94 Merge branch 'master' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/linville/wireless)
Merging bluetooth/master (9437d2edc39e Bluetooth: Fix generation of non-res=
olvable private addresses)
Merging infiniband/for-next (7b909bb49ac2 Merge branches 'core', 'cxgb4', '=
iser', 'mlx5' and 'ocrdma' into for-next)
Merging mtd/master (89cf38dd536a mtd: cfi_cmdset_0001.c: fix resume for LH2=
8F640BF chips)
Merging l2-mtd/master (58c81957b7d2 mtd: spi-nor: allow NULL as chip name a=
nd try to auto detect it)
Merging crypto/master (bc84b94a715f crypto: qat - fix problem with coalesci=
ng enable logic)
Merging drm/drm-next (b75478d1c7e4 Merge branch 'drm_iommu_v15' of https://=
github.com/markyzq/kernel-drm-rockchip into drm-next)
Merging drm-panel/drm/panel/for-next (1976dbca047e drm/panel: Add Sharp LQ1=
01R1SX01 support)
Merging drm-intel/for-linux-next (ee86e80a6f97 drm/i915: Don't complain abo=
ut stolen conflicts on gen3)
Merging drm-tegra/drm/tegra/for-next (7e0180e3570c drm/tegra: gem: Check be=
fore freeing CMA memory)
Merging drm-misc/topic/core-stuff (a0a0bde32a46 drm: Fix memory leak at err=
or path of drm_read())
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_edid.c
Merging sound/for-next (bf35df66f1c6 ALSA: jack: Add dummy snd_jack_set_key=
() definition)
Merging sound-asoc/for-next (e32a46487533 Merge remote-tracking branches 'a=
soc/fix/adsp', 'asoc/fix/davinci', 'asoc/fix/max98090', 'asoc/fix/samsung',=
 'asoc/fix/sigmadsp' and 'asoc/fix/tlv320aic31xx' into asoc-linus)
Merging modules/modules-next (18eb74fa9416 params: cleanup sysfs allocation)
Merging virtio/virtio-next (5a10b7dbf904 virtio_balloon: free some memory f=
rom balloon on OOM)
Merging input/next (66aee90088da Input: add support for Elan eKTH I2C touch=
screens)
Merging input-mt/for-next (5e01dc7b26d9 Linux 3.12)
Merging block/for-next (731608cbd316 Merge branch 'for-3.19/core' into for-=
next)
Merging device-mapper/for-next (8bea6809aafe random: add and use memzero_ex=
plicit() for clearing data)
Merging embedded/master (4744b43431e8 embedded: fix vc_translate operator p=
recedence)
Merging firmware/master (6e03a201bbe8 firmware: speed up request_firmware()=
, v3)
Merging pcmcia/master (80af9e6d7ae6 pcmcia at91_cf: fix raw gpio number usa=
ge)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (33d73935e4ab mmc: sdhci-msm: Convert to mmc_send_tunin=
g())
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-n8x0.c
CONFLICT (modify/delete): arch/arm/mach-at91/at91sam9g45_devices.c deleted =
in HEAD and modified in mmc-uh/next. Version mmc-uh/next of arch/arm/mach-a=
t91/at91sam9g45_devices.c left in tree.
$ git rm -f arch/arm/mach-at91/at91sam9g45_devices.c
Merging kgdb/kgdb-next (0f16996cf2ed kernel/debug/debug_core.c: Logging cle=
an-up)
Merging uclinux/for-next (6dbe51c251a3 Linux 3.9-rc1)
Merging md/for-next (c156ee101edc md: make reconfig_mutex optional for writ=
es to md sysfs files.)
Merging mfd/for-mfd-next (a3b63979f8a3 mfd: rtsx: Add func to split u32 int=
o register)
CONFLICT (content): Merge conflict in drivers/mfd/viperboard.c
Merging backlight/for-backlight-next (a98549c2b76a backlight: lp855x: Add s=
upply regulator to lp855x)
Merging battery/master (b81180b3fd48 power: reset: adjust priority of simpl=
e syscon reboot driver)
Merging fbdev/for-next (718b90ac4c21 video: xilinxfb: Simplify error path)
Merging viafb/viafb-next (838ac785d521 viafb: avoid refresh and mode lookup=
 in set_par)
Merging omap_dss2/for-next (574d54112fda Merge branches '3.19/omapdss' and =
'3.19/simplefb' into for-next)
CONFLICT (content): Merge conflict in include/linux/of.h
Merging regulator/for-next (176488fbc121 Merge remote-tracking branches 're=
gulator/topic/sky81452' and 'regulator/topic/stub' into regulator-next)
Merging security/next (b2d1965dcea1 Merge branch 'next' of git://git.infrad=
ead.org/users/pcmoore/selinux into next)
Merging integrity/next (63a0eb7891bd ima: Fix build failure on powerpc when=
 TCG_IBMVTPM dependencies are not met)
Merging selinux/next (00fec2a10b51 selinux: Remove security_ops extern)
Merging lblnet/next (d8ec26d7f828 Linux 3.13)
Merging watchdog/master (8ae1a57f54af watchdog: s3c2410_wdt: Fix the mask b=
it offset for Exynos7)
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
CONFLICT (content): Merge conflict in drivers/pci/pci-driver.c
Merging audit/next (0288d7183c41 audit: convert status version to a feature=
 bitmap)
Merging fsnotify/for-next (1ca39ab9d21a inotify: automatically restart sysc=
alls)
Merging devicetree/devicetree/next (c46ca3c8310b of: Delete unnecessary che=
ck before calling "of_node_put()")
CONFLICT (content): Merge conflict in include/linux/of.h
CONFLICT (content): Merge conflict in drivers/i2c/i2c-core.c
Merging dt-rh/for-next (a0e27f51ba8a documentation: pinctrl bindings: Fix t=
rivial typo 'abitrary')
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (0e647037fed5 Merge remote-tracking branches 'spi/topi=
c/spidev' and 'spi/topic/txx9' into spi-next)
Merging tip/auto-latest (6c06952d9730 Merge branch 'x86/vdso')
CONFLICT (content): Merge conflict in drivers/pci/host/pcie-rcar.c
CONFLICT (content): Merge conflict in drivers/irqchip/Makefile
Merging clockevents/clockevents/next (b0ad5917960c ARM/ARM64: arch-timer: f=
ix arch_timer_probed logic)
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (50872ccd8786 EDAC, MCE, AMD: Correct formatting =
of decoded text)
Merging irqchip/irqchip/for-next (5cc8f658723f Merge branch 'irqchip/irqdom=
ain-arm' into irqchip/for-next)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (2db633eb8df6 Merge branch 'for-next/ftrace/testing=
' into trace/for-next)
Merging rcu/rcu/next (3c9e966a381e rcutorture: Add checks for stall ending =
before dump start)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (e08e833616f7 KVM: cpuid: recompute CPUID 0xD.0:EBX,=
ECX)
CONFLICT (modify/delete): arch/ia64/kvm/kvm-ia64.c deleted in kvm/linux-nex=
t and modified in HEAD. Version HEAD of arch/ia64/kvm/kvm-ia64.c left in tr=
ee.
CONFLICT (modify/delete): arch/ia64/kvm/Kconfig deleted in kvm/linux-next a=
nd modified in HEAD. Version HEAD of arch/ia64/kvm/Kconfig left in tree.
$ git rm -f arch/ia64/kvm/Kconfig arch/ia64/kvm/kvm-ia64.c
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
Merging xen-tip/linux-next (2e917175e1ef xen: Speed up set_phys_to_machine(=
) by using read-only mappings)
CONFLICT (content): Merge conflict in arch/arm/include/asm/dma-mapping.h
Applying: arm: introduce is_device_dma_coherent merge fix
Merging percpu/for-next (bfaa047a9415 Merge branch 'for-3.18-fixes' into fo=
r-next)
Merging workqueues/for-next (008847f66c38 workqueue: allow rescuer thread t=
o do more work.)
Merging drivers-x86/for-next (e4da91427fbe dell-smo8800: Add more ACPI ids =
and change description of driver)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging sysctl/master (4e474a00d7ff sysctl: protect poll() in entries that =
may go away)
Merging regmap/for-next (a63b87838a59 Merge remote-tracking branches 'regma=
p/topic/ac97' and 'regmap/topic/headers' into regmap-next)
Merging hsi/for-next (d95dc9e38810 HSI: nokia-modem: fix error handling of =
irq_of_parse_and_map)
Merging leds/for-next (2969bb18f889 leds: lp8860: Fix module dependency)
Merging ipmi/for-next (ee0a40fd288e Change ACPI IPMI support to "default y")
CONFLICT (content): Merge conflict in arch/powerpc/platforms/powernv/opal-w=
rappers.S
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/opal.h
Merging driver-core/driver-core-next (f30d0a815bb9 fs: debugfs: add forward=
 declaration for struct device type)
CONFLICT (modify/delete): sound/soc/omap/omap-hdmi.c deleted in HEAD and mo=
dified in driver-core/driver-core-next. Version driver-core/driver-core-nex=
t of sound/soc/omap/omap-hdmi.c left in tree.
CONFLICT (modify/delete): sound/soc/omap/omap-hdmi-card.c deleted in HEAD a=
nd modified in driver-core/driver-core-next. Version driver-core/driver-cor=
e-next of sound/soc/omap/omap-hdmi-card.c left in tree.
CONFLICT (content): Merge conflict in sound/soc/intel/sst-haswell-pcm.c
CONFLICT (modify/delete): drivers/staging/media/omap24xx/omap24xxcam.c dele=
ted in HEAD and modified in driver-core/driver-core-next. Version driver-co=
re/driver-core-next of drivers/staging/media/omap24xx/omap24xxcam.c left in=
 tree.
CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath9k/debug.c
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
rivers/staging/media/omap24xx/omap24xxcam.c sound/soc/omap/omap-hdmi-card.c=
 sound/soc/omap/omap-hdmi.c
Merging tty/tty-next (dd63af108f08 Merge 3.18-rc7 into tty-next)
CONFLICT (content): Merge conflict in drivers/tty/n_tty.c
CONFLICT (content): Merge conflict in Documentation/devicetree/bindings/ser=
ial/pl011.txt
Merging usb/usb-next (3ff67445750a usbip: fix error handling in stub_probe(=
))
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/dwc2/gadget.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/core.c
$ git reset --hard HEAD^
Merging next-20141128 version of usb
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/dwc3/ep0.c
CONFLICT (content): Merge conflict in drivers/usb/dwc2/gadget.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/core.c
[master 9ad054c0d7a9] next-20141128/usb
Merging usb-gadget/next (ebf3992061db usb: musb: Use IS_ENABLED for tusb601=
0)
Merging usb-serial/usb-next (e7181d005e84 USB: qcserial: Add support for HP=
 lt4112 LTE/HSPA+ Gobi 4G Modem)
Merging staging/staging-next (17d2c6439be6 Staging: slicoss: Fix long line =
issues in slicoss.c)
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
$ git rm -f drivers/staging/media/lirc/lirc_igorplugusb.c drivers/staging/m=
edia/omap24xx/omap24xxcam.c drivers/staging/media/omap24xx/tcm825x.c
Merging char-misc/char-misc-next (91905b6f4afe parport: parport_pc, do not =
remove parent devices early)
CONFLICT (content): Merge conflict in drivers/misc/cxl/irq.c
CONFLICT (content): Merge conflict in drivers/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/Kconfig
CONFLICT (modify/delete): arch/arm/kernel/etm.c deleted in char-misc/char-m=
isc-next and modified in HEAD. Version HEAD of arch/arm/kernel/etm.c left i=
n tree.
$ git rm -f arch/arm/kernel/etm.c
Merging cgroup/for-next (eeecbd197151 cgroup: implement cgroup_get_e_css())
Merging scsi/for-next (b34681d64769 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.19' into for-next)
CONFLICT (content): Merge conflict in drivers/usb/storage/uas.c
Merging target-updates/for-next (36ab12ea2b7c iser-target: Fix wc->wr_id ca=
st warning)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging writeback/writeback-for-next (f9b0e058cbd0 writeback: Fix data corr=
uption on NFS)
Merging hwspinlock/linux-next (8b37fcfc9b34 hwspinlock: add MAINTAINERS ent=
ries)
Merging pinctrl/for-next (ae76f13b9b49 pinctrl: meson: add device tree bind=
ings documentation)
CONFLICT (content): Merge conflict in drivers/pinctrl/pinctrl-rockchip.c
CONFLICT (content): Merge conflict in arch/arm/boot/dts/ste-nomadik-stn8815=
.dtsi
Applying: pinctrl: nomadik: fix up for binding changes
Merging vhost/linux-next (970379f59d81 vhost: move memory pointer to VQs)
CONFLICT (content): Merge conflict in drivers/vhost/net.c
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (0e9a5edf5d01 gpio: fix deferred probe detection for =
legacy API)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (39e046f2c1dd pwm: atmel-hlcdc: add at91sam9x5 and sam=
a5d3 errata handling)
Merging dma-buf/for-next (101e31050bf1 dma-buf/fence: Fix one more kerneldo=
c warning)
Merging userns/for-next (3e6a4ad789d7 userns: Unbreak the unprivileged remo=
unt tests)
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging signal/for-next (20b4fb485227 Merge branch 'for-linus' of git://git=
.kernel.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (646cafc6aa4d clk: Change clk_ops->determine_rate to r=
eturn a clk_hw as the best parent)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging lzo-update/lzo-update (42b775abafaf lib/lzo: huge LZO decompression=
 speedup on ARM by using unaligned access)
Merging aio/master (d3785cf42979 Merge ../aio-fixes)
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
Merging luto-misc/next (5595364a6bd9 x86, entry: Switch stacks on a paranoi=
d entry from userspace)
Merging access_once/linux-next (4803c6e6b311 kernel: tighten rules for ACCE=
SS ONCE)
Applying: x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE
$ git reset --hard HEAD^
$ git am -3 ../patches/0001-Revert-srcu-Isolate-srcu-sections-using-CONFIG_=
SRCU.patch
Applying: Revert "srcu: Isolate srcu sections using CONFIG_SRCU"
Merging akpm-current/current (35ac317b788c shmdt: use i_size_read() instead=
 of ->i_size)
CONFLICT (content): Merge conflict in tools/testing/selftests/Makefile
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
Applying: percpu: remove __get_cpu_var and __raw_get_cpu_var macros
Applying: percpu: update local_ops.txt to reflect this_cpu operations
Applying: parisc: percpu: update comments refereing to __get_cpu_var
Applying: mm: replace remap_file_pages() syscall with emulation
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (0672e2570eaf mm: add strictlimit knob)

--Sig_/C1AkBQ6UM+m7mOo5q2eW62w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhvWGAAoJEMDTa8Ir7ZwVSnwP/21O0m1C9pwwquuEdu/vwq/D
MKDHxL7nIH6QPOQuC9UYvUjwkpyf+UaajFp+9ZqZdG8G5LfJZc2fnIbjrhOYaTVw
rRly2r9B0HglNLSDSS6U2MWrfu3IHJHlaNBHwKYJYCI2UeEBs5VbLtTDV6dOokb7
DNV78rqRHaohjOoNzcQNuXmmwGvNpXoKBi6ZOQP8qpXuV2H2SN0XXT7JAbYI6bI5
TLJp8ftt5HCAtcnbYMqvQAL5xsfB2o9w63SqwgEcehFh7LXvAaX2kfSkIwdWq7O2
KR8uVUK4f87R8sqGwz5gUlnNOfdIAr/lbljCLWNrqixLAbei733cjiQ8xvHaZe4C
v1jtiiDuL2kWHED8GcguIBKVpl/b5erfn3VPTwPaMcFUg2MW0xxGaaoYVUYc0Zn1
9UuBjTdTS79RlVNbB5wgtiAK7yzn5aWtAAei/4A5xjRyMn0AB9RQwaWJrAvjn2cI
7Hj922+x8rLeBmB0/YidvUWQrfV1M8O09i1VuivnYL15NkUPas6w4eAkjY/iJvIg
CIS7UgCVjmyvFxBOcfhz+1l1PU+ReCvPgdIad5by2gjzm9cF6OwVqtam6cpHAO+B
L53+frfs4uHFKku7+CXlgdP0kNrPLScnRG2syVWcNWXSa/hj5mZPmePOapodaY0H
vn5HmCMl68AY8wlfPkOf
=+JEw
-----END PGP SIGNATURE-----

--Sig_/C1AkBQ6UM+m7mOo5q2eW62w--
