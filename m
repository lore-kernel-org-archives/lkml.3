Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbbA2IMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:12:18 -0500
Received: from ozlabs.org ([103.22.144.67]:60144 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbbA2IML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:12:11 -0500
Date: Thu, 29 Jan 2015 19:11:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Jan 29
Message-ID: <20150129191148.080d995f@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nm_MZg5y_fN/JO3ibJtRF1a"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nm_MZg5y_fN/JO3ibJtRF1a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20150128:

The drm tree gained a conflict against Linus' tree.

The sound-asoc tree lost its build failure.

The block tree gained a conflict against the l2-mtd tree.

The akpm-current tree gained a conflict against the xen-tip tree.

Non-merge commits (relative to Linus' tree): 6020
 6140 files changed, 247961 insertions(+), 128184 deletions(-)

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

I am currently merging 206 trees (counting Linus' and 30 trees of patches
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
Merging origin/master (c59c961ca511 Merge branch 'drm-fixes' of git://peopl=
e.freedesktop.org/~airlied/linux)
Merging fixes/master (b94d525e58dc Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging kbuild-current/rc-fixes (a16c5f99a28c kbuild: Fix removal of the de=
bian/ directory)
Merging arc-current/for-curr (2ce7598c9a45 Linux 3.17-rc4)
Merging arm-current/fixes (909ba297beb5 ARM: 8292/1: mm: fix size rounding-=
down of arm_add_memory() function)
Merging m68k-current/for-linus (f27bd5bfeda5 m68k: Wire up execveat)
Merging metag-fixes/fixes (ffe6902b66aa asm-generic: remove _STK_LIM_MAX)
Merging mips-fixes/mips-fixes (1795cd9b3a91 Linux 3.16-rc5)
Merging powerpc-merge/merge (31345e1a071e powerpc/pci: Remove unused force_=
32bit_msi quirk)
Merging powerpc-merge-mpe/fixes (0eb13208aa16 powerpc/powernv: Restore LPCR=
 with LPCR_PECE1 cleared)
Merging sparc/master (66d0f7ec9f10 sparc32: destroy_context() and switch_mm=
() needs to disable interrupts.)
Merging net/master (59343cd7c480 Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging ipsec/master (59343cd7c480 Merge git://git.kernel.org/pub/scm/linux=
/kernel/git/davem/net)
Merging sound-current/for-linus (4161b4505f16 ALSA: ak411x: Fix stall in wo=
rk callback)
Merging pci-current/for-linus (19c5392eb1c1 PCI: designware: Reject MSI-X I=
RQs)
Merging wireless-drivers/master (e3f31175a3ee ath9k: fix race condition in =
irq processing during hardware reset)
Merging driver-core.current/driver-core-linus (26bc420b59a3 Linux 3.19-rc6)
Merging tty.current/tty-linus (ec6f34e5b552 Linux 3.19-rc5)
Merging usb.current/usb-linus (54eb4cd46542 Merge tag 'fixes-for-v3.19-rc6'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-linus)
Merging usb-gadget-fixes/fixes (0df8fc37f6e4 usb: phy: never defer probe in=
 non-OF case)
Merging usb-serial-fixes/usb-linus (a6f0331236fa USB: cp210x: add ID for RU=
GGEDCOM USB Serial Console)
Merging staging.current/staging-linus (41c9e95d641a MAINTAINERS: add Androi=
d driver entries)
Merging char-misc.current/char-misc-linus (26713c812313 drivers/Kconfig: re=
move duplicate entry for soc)
Merging input-current/for-linus (1d90d6d5522b Input: i8042 - add noloop qui=
rk for Medion Akoya E7225 (MD98857))
Merging crypto-current/master (3e14dcf7cb80 crypto: add missing crypto modu=
le aliases)
Merging ide/master (f96fe225677b Merge git://git.kernel.org/pub/scm/linux/k=
ernel/git/davem/net)
Merging devicetree-current/devicetree/merge (6b1271de3723 of/unittest: Over=
lays with sub-devices tests)
Merging rr-fixes/fixes (d5db139ab376 module: make module_refcount() a signe=
d integer.)
Merging vfio-fixes/for-linus (7c2e211f3c95 vfio-pci: Fix the check on pci d=
evice type in vfio_pci_probe())
Merging kselftest-fixes/fixes (f5db310d77ef selftests/vm: fix link error fo=
r transhuge-stress test)
Merging drm-intel-fixes/for-linux-next-fixes (6b96d705f3cf drm/i915: BDW Fi=
x Halo PCI IDs marked as ULT.)
Merging asm-generic/master (643165c8bbc8 Merge tag 'uaccess_for_upstream' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost into asm-generic)
Merging arc/for-next (5840adceb962 arc: Remove unused prepare_to_copy())
Merging arm/for-next (292c11f80cc8 Merge branch 'devel-stable' into for-nex=
t)
Merging arm-perf/for-next/perf (97bf6af1f928 Linux 3.19-rc1)
Merging arm-soc/for-next (91c7b5065f5d arm-soc: document merges)
Merging bcm2835/for-next (b2776bf7149b Linux 3.18)
Merging berlin/berlin/for-next (8553bf8fd181 Merge branch 'berlin/dt' into =
berlin/for-next)
Merging cortex-m/for-next (e799b6f37e6c ARM: zImage: add support for ARMv7-=
M)
Merging imx-mxs/for-next (395ae1400a35 Merge branch 'imx/defconfig' into fo=
r-next)
Merging keystone/next (b17275a4a6cc Merge branch 'for_3.19/soc' into next)
Merging mvebu/for-next (cd3892730fbc Merge branch 'mvebu/defconfig' into mv=
ebu/for-next)
Merging omap/for-next (da27c2abefeb Merge branch 'omap-for-v3.20/fixes-not-=
urgent' into for-next)
Merging omap-pending/for-next (30aa18d3bea5 MAINTAINERS: add maintainer for=
 OMAP hwmod data)
Merging renesas/next (f99d8a90958c Merge branch 'heads/defconfig-fixes-for-=
v3.20' into next)
Merging samsung/for-next (9b20e28716aa Merge branch 'v3.20-samsung-defconfi=
g' into for-next)
Merging sunxi/sunxi/for-next (16e8c17e18d6 Merge branch 'sunxi/clocks-for-3=
.20' into sunxi/for-next)
Merging tegra/for-next (794345d409ad Merge branch for-3.20/arm64 into for-n=
ext)
Merging arm64/for-next/core (a1c76574f345 arm64: mm: use *_sect to check fo=
r section maps)
CONFLICT (content): Merge conflict in arch/arm64/mm/dump.c
Merging blackfin/for-linus (275f5a8573e7 blackfin: defconfigs: cleanup unus=
ed CONFIG_MTD_CHAR, add MTD_SPI_NOR for BF537-STAMP)
Merging c6x/for-linux-next (ae72758f1dd9 c6x: fix build failure caused by c=
ache.h)
Merging cris/for-next (2abbda3d1709 CRIS: macro whitespace fixes in uaccess=
.h)
Merging hexagon/linux-next (8914d7e85780 Hexagon: fix signal delivery for d=
ebug traps)
Merging ia64/next (a6b8978c54b7 pstore: Fix sprintf format specifier in pst=
ore_dump())
Merging m68k/for-next (87511d09206d m68k/atari: Remove obsolete IRQ_TYPE_*)
Merging m68knommu/for-next (8d84d4aaf311 arch: m68k: 68360: config: Remove =
unused function)
Merging metag/for-next (f93125ae17d1 metag: cachepart: Fix failure check)
Merging microblaze/next (51cae8bfe7dd microblaze: Remove generated *.dtb fi=
les from dts)
Merging mips/mips-for-linux-next (86f9f1e287be Merge branch '3.19-fixes' in=
to mips-for-linux-next)
Merging nios2/nios2-next (d24c8163b755 nios2: fix kuser trampoline address)
Merging parisc-hd/for-next (b2776bf7149b Linux 3.18)
Merging powerpc/next (d557b09800da powerpc/mm/thp: Use tlbiel if possible)
Merging powerpc-mpe/next (6501ab5e380c powerpc/powernv: Skip registering lo=
g region when CONFIG_PRINTK=3Dn)
Merging fsl/next (76f3e2929bb6 powerpc/config: Enable memory driver)
Merging mpc5xxx/next (9e813308a5c1 powerpc/thp: Add tracepoints to track hu=
gepage invalidate)
Merging s390/features (a3f52ab45d59 s390/ftrace: hotpatch support for funct=
ion tracing)
Merging sparc-next/master (9f935675d41a Merge branch 'for-linus' of git://g=
it.kernel.org/pub/scm/linux/kernel/git/dtor/input)
Merging tile/master (b9f705758a4f tile: enable sparse checks for get/put_us=
er)
Merging unicore32/unicore32 (d670878e2c9a unicore32: Remove ARCH_HAS_CPUFRE=
Q config option)
Merging xtensa/for_next (1f2fdbd0078c xtensa: disable link optimization)
Merging btrfs/next (1edb647bb954 Btrfs: remove non-sense btrfs_error_discar=
d_extent() function)
Merging ceph/master (388cfdc9bc19 libceph: require cephx message signature =
by default)
CONFLICT (content): Merge conflict in net/ceph/auth_x.c
CONFLICT (content): Merge conflict in fs/ceph/super.h
CONFLICT (content): Merge conflict in fs/ceph/super.c
CONFLICT (content): Merge conflict in fs/ceph/snap.c
Merging cifs/for-next (7a1ceba07170 cifs: fix MUST SecurityFlags filtering)
Merging ecryptfs/next (e7a823be2adc Merge tag 'linux-kselftest-3.19-rc-5' o=
f git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest)
Merging ext3/for_next (a39427007e7c xfs: Remove some pointless quota checks)
Merging ext4/dev (8675f58ed42b ext4: change to use setup_timer() instead of=
 init_timer())
Merging f2fs/dev (b83bd37d3b01 f2fs: introduce a batched trim)
Merging fscache/fscache (1a8ed18fb7db cachefiles: remove two unused pagevec=
s.)
CONFLICT (content): Merge conflict in fs/fscache/object.c
Merging fuse/for-next (9759bd518994 fuse: add memory barrier to INIT)
Merging gfs2/master (45094a58b1f5 GFS2: Eliminate a nonsense goto)
Merging jfs/jfs-next (e1f1fe798d2f jfs: get rid of homegrown endianness hel=
pers)
Merging nfs/linux-next (cf6726e2ee38 NFSv4: Deal with atomic upgrades of an=
 existing delegation)
Merging nfsd/nfsd-next (70789780f356 nfsd: default NFSv4.2 to on)
Merging overlayfs/overlayfs-next (4330397e4e8a ovl: discard independent cur=
sor in readdir())
Merging squashfs/master (62421645bb70 Squashfs: Add LZ4 compression configu=
ration option)
Merging v9fs/for-next (f15844e0777f 9P: fix return value in v9fs_fid_xattr_=
set)
Merging ubifs/linux-next (346be9bc802d Add myself as UBI co-maintainer)
Merging xfs/for-next (438c3c8d2bb9 Merge branch 'xfs-buf-type-fixes' into f=
or-next)
Merging file-locks/linux-next (8116bf4cb62d locks: update comments that ref=
er to inode->i_flock)
Merging vfs/for-next (2f8e319e73f4 target: rewrite fd_execute_write_same)
Merging pci/next (12ae9ecc4619 Merge branch 'pci/config' into next)
CONFLICT (content): Merge conflict in arch/mips/pci/pcie-octeon.c
CONFLICT (content): Merge conflict in arch/mips/pci/pci-octeon.c
CONFLICT (content): Merge conflict in arch/mips/pci/pci-bcm1480.c
Merging hid/for-next (5786cd773d19 Merge branch 'for-3.20/upstream' into fo=
r-next)
Merging i2c/i2c/for-next (020614b83312 Merge branch 'i2c/for-current' into =
i2c/for-next)
Merging jdelvare-hwmon/master (26bc420b59a3 Linux 3.19-rc6)
Merging hwmon-staging/hwmon-next (9130880a1c2d hwmon: (jc42) Allow negative=
 hysteresis temperatures)
Merging v4l-dvb/master (a5f23e34da02 Merge branch 'v4l_for_linus' into to_n=
ext)
Merging kbuild/for-next (8d18d1d514d1 Merge branch 'kbuild/kconfig' into kb=
uild/for-next)
Merging kconfig/for-next (b2776bf7149b Linux 3.18)
Merging libata/for-next (50c705312a57 Merge branch 'for-3.20' into for-next)
Merging pm/linux-next (69b838b0f0c8 Merge branch 'pm-cpuidle' into linux-ne=
xt)
Merging idle/next (2985a86aa4ec Merge branch 'turbostat' into next)
CONFLICT (content): Merge conflict in arch/x86/include/uapi/asm/msr-index.h
Merging apm/for-next (53675abbd1e5 x86, apm: Remove unused variable)
Merging thermal/next (f67744c4d91e Merge branch 'thermal-soc' of .git into =
next)
Merging thermal-soc/next (1024cf8b0fcd thermal: exynos: Remove exynos_tmu_d=
ata.c file)
Merging ieee1394/for-next (b625a825955e firewire: ohci: Remove unused funct=
ion)
Merging dlm/next (2ab4bd8ea3a6 dlm: adopt orphan locks)
Merging swiotlb/linux-next (8e0629c1d4ce swiotlb: don't assume PA 0 is inva=
lid)
Merging slave-dma/next (409490076137 Merge branch 'for-linus' into next)
Merging net-next/master (ff660f75be36 Merge branch 'stmmac-pci')
CONFLICT (content): Merge conflict in arch/arm/boot/dts/stih410.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/stih407-family.dtsi
CONFLICT (content): Merge conflict in arch/arm/boot/dts/rk3288.dtsi
Merging ipsec-next/master (ff660f75be36 Merge branch 'stmmac-pci')
Merging wireless-drivers-next/master (314112e0023a rtlwifi: rtl8192cu: Set =
fw_ready flag)
Merging bluetooth/master (385a768c3be1 Bluetooth: btusb: Provide hardware e=
rror handler for Intel devices)
Merging infiniband/for-next (a7cfef21e3d0 Merge branches 'core', 'cxgb4', '=
ipoib', 'iser', 'mlx4', 'ocrdma', 'odp' and 'srp' into for-next)
Merging mtd/master (97bf6af1f928 Linux 3.19-rc1)
Merging l2-mtd/master (240181fd0ffa mtd: nand: default bitflip-reporting th=
reshold to 75% of correction strength)
Merging crypto/master (db71f29a1c32 crypto: testmgr - mark rfc4106(gcm(aes)=
) as fips_allowed)
Merging drm/drm-next (21773f16f2cb Merge tag 'topic/atomic-core-2015-01-27'=
 of git://anongit.freedesktop.org/drm-intel into drm-next)
CONFLICT (content): Merge conflict in drivers/gpu/drm/amd/amdkfd/kfd_device=
_queue_manager.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/amd/amdkfd/kfd_device=
_queue_manager.c
Applying: drm/amdkfd: disable driver due to interaction with a bug fix
Merging drm-panel/drm/panel/for-next (b5217bf46922 drm/bridge: dw-hdmi: Ada=
pt to bridge API change)
Merging drm-intel/for-linux-next (e3d998451090 drm/i915/skl: Enabling PSR o=
n Skylake)
Merging drm-tegra/drm/tegra/for-next (31f40f86526b drm/tegra: Use correct r=
elocation target offsets)
Merging drm-misc/topic/core-stuff (b77037262511 drm/probe-helper: clamp unk=
nown connector status in the poll work)
Merging sound/for-next (d832f3dcb6e2 Merge branch 'topic/ak411x-fix' into f=
or-next)
Merging sound-asoc/for-next (6280b11acc8c Merge remote-tracking branches 'a=
soc/topic/wm8804', 'asoc/topic/wm8904', 'asoc/topic/wm8960', 'asoc/topic/wm=
8988' and 'asoc/topic/xtfpga' into asoc-next)
Merging modules/modules-next (97bf6af1f928 Linux 3.19-rc1)
Merging virtio/virtio-next (76545f066d2a virtio_pci_modern: drop an unused =
function)
Merging input/next (43c0e2234021 Input: sun4i-ts - add support for touchpan=
el controller on A31)
Merging block/for-next (044324ce946c Merge branch 'for-3.20/drivers' into f=
or-next)
CONFLICT (content): Merge conflict in drivers/mtd/mtdcore.c
CONFLICT (content): Merge conflict in drivers/block/loop.c
CONFLICT (content): Merge conflict in drivers/ata/libata-core.c
Applying: libata: fix for move of sas tag allocation code
Merging device-mapper/for-next (f7b2d0c5f5f1 Merge tag 'dm-3.19-fixes-3' of=
 git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm into =
dm-for-3.20)
Merging mmc/mmc-next (11bc9381b277 mmc: sdhci-s3c: use mmc_of_parse and rem=
ove the card_tasklet)
Merging mmc-uh/next (9608337945a6 mmc: dw_mmc: rockchip: remove incorrect _=
_exit_p())
CONFLICT (content): Merge conflict in drivers/mmc/host/sunxi-mmc.c
Merging kgdb/kgdb-next (c7d9ebf81c45 kdb: Fix off by one error in kdb_cpu())
Merging md/for-next (f851b60db0fd md: Check MD_RECOVERY_RUNNING as well as =
->sync_thread.)
Merging mfd/for-mfd-next (bb400d2120bd mfd: rtsx_usb: Defer autosuspend whi=
le card exists)
Merging backlight/for-backlight-next (3d6969a641d0 MAINTAINERS: Remove my n=
ame from Backlight subsystem)
Merging battery/master (24727b45b484 power_supply: 88pm860x: Fix leaked pow=
er supply on probe fail)
Merging omap_dss2/for-next (7efc436cd45c Merge branches '3.20/fbdev' and '3=
.20/omapdss' into for-next)
Merging regulator/for-next (6f41c982c9af Merge remote-tracking branches 're=
gulator/topic/rt5033' and 'regulator/topic/tps65023' into regulator-next)
Merging security/next (bfd33c4b4b1a MAINTAINERS: email update)
Merging integrity/next (bfd33c4b4b1a MAINTAINERS: email update)
Merging selinux/next (0307dadc924d selinux: add security in-core xattr supp=
ort for pstore and debugfs)
Merging lblnet/next (b2776bf7149b Linux 3.18)
Merging watchdog/master (4adca1cbc4ce Merge branch 'akpm' (patches from And=
rew Morton))
Merging iommu/next (5c15917fc8a0 Merge branches 'iommu/fixes', 'arm/renesas=
', 'ppc/pamu' and 'core' into next)
Merging dwmw2-iommu/master (1860e379875d Linux 3.15)
Merging vfio/next (5e9f36c59a48 drivers/vfio: allow type-1 IOMMU instantiat=
ion on top of an ARM SMMU)
Merging osd/linux-next (1fa3a002b254 Boaz Harrosh - fix email in Documentat=
ion)
Merging jc_docs/docs-next (174236285cf8 Merge branch 'doc/sp-update' into d=
ocs-next)
Merging trivial/for-next (edb0ec0725bb kexec, Kconfig: spell "architecture"=
 properly)
Merging audit/next (2fded7f44b8f audit: remove vestiges of vers_ops)
Merging devicetree/devicetree/next (fca8ba4ee24d of/unittest: Remove obsole=
te code)
Merging dt-rh/for-next (e94fbe607f8c dt-bindings: use isil prefix for Inter=
sil in vendor-prefixes.txt)
Merging mailbox/mailbox-for-next (9f3e3cacb2ff dt: mailbox: add generic bin=
dings)
Merging spi/for-next (ff01f7f7a1ad Merge remote-tracking branch 'spi/topic/=
xilinx' into spi-next)
Merging tip/auto-latest (72fbe1ce6a68 Merge branch 'x86/ras')
Merging clockevents/clockevents/next (4c8305221193 clocksource: Driver for =
Conexant Digicolor SoC timer)
CONFLICT (content): Merge conflict in drivers/clocksource/Kconfig
Merging edac/linux_next (fec53af531dd sb_edac: Fix typo computing number of=
 banks)
Merging edac-amd/for-next (a4972b1b9a04 edac: i5100_edac: Remove unused i51=
00_recmema_dm_buf_id)
Merging irqchip/irqchip/for-next (91d117921216 irqchip: atmel-aic-common: P=
revent clobbering of priority when changing IRQ type)
Merging tiny/tiny/next (f114040e3ea6 Linux 3.18-rc1)
Merging ftrace/for-next (14a5ae40f0de tracing: Use IS_ERR() check for retur=
n value of tracing_init_dentry())
Merging rcu/rcu/next (a8cd3b1af4c4 documentation: Update per-CPU kthreads d=
ocumentation)
Merging kvm/linux-next (8fff5e374a2f Merge tag 'kvm-s390-next-20150122' of =
git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next)
CONFLICT (content): Merge conflict in arch/arm64/kvm/Kconfig
CONFLICT (content): Merge conflict in arch/arm/kvm/Kconfig
Merging kvm-arm/next (4b990589952f KVM: Remove unused config symbol)
Merging kvm-ppc/kvm-ppc-next (2c4aa55a6af0 Merge tag 'signed-kvm-ppc-next' =
of git://github.com/agraf/linux-2.6 into HEAD)
Merging kvms390/next (0eb135ff9f19 KVM: s390: remove redundant setting of i=
nterrupt type)
Merging xen-tip/linux-next (dab069c61aa3 xen/gntdev: provide find_special_p=
age VMA operation)
Merging percpu/for-next (4c907baf36d8 percpu_ref: implement percpu_ref_is_d=
ying())
Merging workqueues/for-next (b5b3ab523e31 Merge branch 'for-3.19-fixes' int=
o for-next)
Merging drivers-x86/for-next (97bf6af1f928 Linux 3.19-rc1)
Merging chrome-platform/for-next (5502486a2077 platform/chrome: chromeos_la=
ptop - Add a limit for deferred retries)
Merging regmap/for-next (18b2ce75d844 Merge remote-tracking branch 'regmap/=
topic/doc' into regmap-next)
Merging hsi/for-next (67e9a2ce6e07 hsi: nokia-modem: fix uninitialized devi=
ce pointer)
Merging leds/for-next (7aea8389a77a leds: Add LED Flash class extension to =
the LED subsystem)
Merging ipmi/for-next (b942c653ae26 Merge tag 'trace-sh-3.19' of git://git.=
kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging driver-core/driver-core-next (26bc420b59a3 Linux 3.19-rc6)
Merging tty/tty-next (61b6b7fbda1b Merge 3.19-rc5 into tty-next)
Merging usb/usb-next (1cee6b8d0042 USB: host: ohci-at91: Fix wake-up suppor=
t)
Merging usb-gadget/next (73815280a5af usb: dwc3: remove reliance on dev_vdb=
g())
CONFLICT (content): Merge conflict in drivers/usb/musb/musb_virthub.c
Merging usb-serial/usb-next (3e264ffc831e USB: mos7840: remove unused code)
Merging staging/staging-next (f049a526ad3d staging: sm7xxfb: fix alignment)
Merging char-misc/char-misc-next (786f949631c7 Merge tag 'extcon-next-for-3=
.20' of git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon into c=
har-misc-next)
CONFLICT (content): Merge conflict in drivers/char/mem.c
Merging cgroup/for-next (8abba61bcfd4 Merge branch 'for-3.19-fixes' into fo=
r-next)
Merging scsi/for-next (ddc90c39e08a Merge branch 'misc' into for-next)
Merging target-updates/for-next (ecc3f3edbfb6 ib_srpt: wait_for_completion_=
timeout does not return negative status)
Merging target-merge/for-next-merge (b28a960c42fc Linux 3.14-rc2)
Merging pinctrl/for-next (4d1216ba80e8 Merge branch 'devel' into for-next)
Merging vhost/linux-next (eaa27f34e91a linux 3.19-rc4)
Merging remoteproc/for-next (9a3c4145af32 Linux 3.16-rc6)
Merging rpmsg/for-next (b1b9891441fa rpmsg: use less buffers when vrings ar=
e small)
Merging gpio/for-next (4044101fa72b Merge branch 'devel' into for-next)
Merging dma-mapping/dma-mapping-next (dda02fd6278d mm, cma: make parameters=
 order consistent in func declaration and definition)
Merging pwm/for-next (6a6bdf52a3c4 pwm: sunxi: document OF bindings)
Merging dma-buf/for-next (4eb2440ed60f reservation: Remove shadowing local =
variable 'ret')
Merging userns/for-next (db86da7cb76f userns: Unbreak the unprivileged remo=
unt tests)
Merging ktest/for-next (17150fef4ab1 ktest: Add back "tail -1" to kernelrel=
ease make)
Merging clk/clk-next (9bbb8a338fb2 clk: pxa: add pxa3xx clock driver)
Merging random/dev (7185ad2672a7 crypto: memzero_explicit - make sure to cl=
ear out sensitive data)
Merging aio/master (5f785de58873 aio: Skip timer for io_getevents if timeou=
t=3D0)
Merging llvmlinux/for-next (25d4aee23af2 arm: LLVMLinux: Use global stack r=
egister variable for percpu)
Merging kselftest/next (97bf6af1f928 Linux 3.19-rc1)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
Merging luto-misc/next (188c901941ef Merge branch 'leds-fixes-for-3.19' of =
git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds)
Merging access_once/linux-next (c5b19946eb76 kernel: Fix sparse warning for=
 ACCESS_ONCE)
Merging livepatching/for-next (dbed7ddab967 livepatch: fix uninitialized re=
turn value)
Merging akpm-current/current (45ed7ef0dd49 ipc,sem: use current->state help=
ers)
CONFLICT (content): Merge conflict in mm/swap.c
CONFLICT (content): Merge conflict in include/linux/mm.h
$ git checkout -b akpm remotes/origin/akpm/master
Applying: drivers/gpio/gpio-zevio.c: fix build
Applying: rtc: isl12022: deprecate use of isl in compatible string for isil
Applying: rtc: isl12057: deprecate use of isl in compatible string for isil
Applying: staging: iio: isl29028: deprecate use of isl in compatible string=
 for isil
Applying: arm: dts: zynq: update isl9305 compatible string to use isil vend=
or prefix
Applying: mm: fix XIP fault vs truncate race
Applying: mm-fix-xip-fault-vs-truncate-race-fix
Applying: mm-fix-xip-fault-vs-truncate-race-fix-fix
Applying: mm: allow page fault handlers to perform the COW
Applying: mm-allow-page-fault-handlers-to-perform-the-cow-fix
Applying: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3
Applying: mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix
Applying: vfs,ext2: introduce IS_DAX(inode)
Applying: dax,ext2: replace XIP read and write with DAX I/O
Applying: dax,ext2: replace ext2_clear_xip_target with dax_clear_blocks
Applying: dax,ext2: replace the XIP page fault handler with the DAX page fa=
ult handler
Applying: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-faul=
t-handler-fix
Applying: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-faul=
t-handler-fix-2
Applying: daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-faul=
t-handler-fix-3
Applying: dax,ext2: replace xip_truncate_page with dax_truncate_page
Applying: dax: replace XIP documentation with DAX documentation
Applying: vfs: remove get_xip_mem
Applying: ext2: remove ext2_xip_verify_sb()
Applying: ext2: remove ext2_use_xip
Applying: ext2: remove xip.c and xip.h
Applying: vfs,ext2: remove CONFIG_EXT2_FS_XIP and rename CONFIG_FS_XIP to C=
ONFIG_FS_DAX
Applying: ext2: remove ext2_aops_xip
Applying: ext2: get rid of most mentions of XIP in ext2
Applying: dax: add dax_zero_page_range
Applying: dax-add-dax_zero_page_range-fix
Applying: ext4: add DAX functionality
Applying: ext4-add-dax-functionality-fix
Applying: brd: rename XIP to DAX
Applying: MAINTAINERS: fix spelling mistake & remove trailing WS
Applying: ocfs2: prepare some interfaces used in append direct io
Applying: ocfs2: add functions to add and remove inode in orphan dir
Applying: ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix
Applying: ocfs2: add orphan recovery types in ocfs2_recover_orphans
Applying: ocfs2: implement ocfs2_direct_IO_write
Applying: ocfs2-implement-ocfs2_direct_io_write-fix
Applying: ocfs2: allocate blocks in ocfs2_direct_IO_get_blocks
Applying: ocfs2: do not fallback to buffer I/O write if appending
Applying: ocfs2: complete the rest request through buffer io
Applying: ocfs2: wait for orphan recovery first once append O_DIRECT write =
crash
Applying: ocfs2: set append dio as a ro compat feature
Applying: drivers/w1/w1_int.c: call put_device if device_register fails
Applying: mm: add strictlimit knob
Merging akpm/master (1aeefc52b3eb mm: add strictlimit knob)

--Sig_/nm_MZg5y_fN/JO3ibJtRF1a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyetZAAoJEMDTa8Ir7ZwVBkgP/1khha057c/Bdu1cey5sQ5VQ
51IRIzanB+jH3uuiTR+D3OpQDO54y5LLkI8i1DSFMvMXNttcG4++ozYVe6kD+LtI
wVF0wpxEvT1ynU1JZCDzPhXcDlLtAsvsf/DtuUx0J5kEVtUB4xTLH/HEcxFfd947
uy9bsgfG2b7nxCFMOfyrIgG900CEGmdpUraUVpeHYvbfF9lMTHHbvd3ttulojLyZ
UtzKrqi105Xt2a7zfo9gefJP7SGbdc/WCnvoPxL383rIcOFYLIEqJjRkH4ZYEFJf
EkqZiBSeSeMQLFe2dNQFk0bEohgsf07h5vwMEGHPFWAbNC6SlZCePwwC20QkX6pv
Lf8mTn8HBWRkLkkECKeQoNKvEVD9ozQvtCLyFUvKOYf5zOivdKADVCtKl2oxWkMf
d5Xl2gLO/wcroG9PnbnYmnCjdLIJ6z7gP/j7Td7756O/ZCxIpNLJcYpNw6P+MRPX
nH2NcLKYCQqK4+zOD/n3+MiGnGx1InWfz8ql+32zm8ZOLwWtoM5j+J3OClZ7Augf
aW4Xp/kpb/sX8RQHOJ7qKkAWDz1mzoTblGtrG9lhk8vF0lio0QAzjRYZRjAwvJHx
6Nen62iGlyXOhBThjABeivg9LzEZCd7OvlB8dyCIVjVlwhsSW3fSQSJffeXl+4gX
NmQvmVm+CC6g+DsAi7st
=O2br
-----END PGP SIGNATURE-----

--Sig_/nm_MZg5y_fN/JO3ibJtRF1a--
