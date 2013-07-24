Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3GXGdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:33:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56058 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3GXGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:33:02 -0400
Date: Wed, 24 Jul 2013 16:32:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <linux-next@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for Jul 24
Message-Id: <20130724163254.f026790fa2fe367f85969901@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Jul_2013_16_32_54_+1000_WErG.sausHWVO=Gi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jul_2013_16_32_54_+1000_WErG.sausHWVO=Gi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20130723:

Removed trees:
	irqdomain-current, spi-current, gpio-current, spi,
	irqdomain, gpio (at maintainer's request)

Renamed trees:
	spi-mb -> spi
	gpio-lw -> gpio

The wireless-next tree gained a build failure for which I have applied a
supplied patch.

The sound-asoc tree lost its build failure.

The tty tree gained a build failure so I used the version from next-2013072=
3.

The akpm-current tree gained a conflict against the staging tree.

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
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc,
sparc64 and arm defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 224 trees (counting Linus' and 33 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

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
Merging origin/master (a474902 Merge tag 'devicetree-for-linus' of git://gi=
t.secretlab.ca/git/linux)
Merging fixes/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging kbuild-current/rc-fixes (ad81f05 Linux 3.11-rc1)
Merging arc-current/for-curr (ad81f05 Linux 3.11-rc1)
Merging arm-current/fixes (ab8d46c0 ARM: 7788/1: elf: fix lpae hwcap featur=
e reporting in proc/cpuinfo)
Merging m68k-current/for-linus (ad81f05 Linux 3.11-rc1)
Merging metag-fixes/fixes (dfe248b MAINTAINERS: add linux-metag mailing lis=
t)
Merging powerpc-merge/merge (ea461ab powerpc/eeh: Fix fetching bus for sing=
le-dev-PE)
Merging sparc/master (6d128e1 Revert "Makefile: Fix install error with make=
 -j option")
Merging net/master (f8c0aca fec: Add MODULE_ALIAS)
Merging ipsec/master (01cb71d net_sched: restore "overhead xxx" handling)
Merging sound-current/for-linus (be2f93a ALSA: usb-audio: 6fire: return cor=
rect XRUN indication)
Merging pci-current/for-linus (fb94197 PCI: pciehp: Convert pciehp to be bu=
iltin only, not modular)
Merging wireless/master (23d412a brcmfmac: bail out of brcmf_txflowblock_if=
() for non-netdev interface)
Merging driver-core.current/driver-core-linus (3b2f64d Linux 3.11-rc2)
Merging tty.current/tty-linus (3b2f64d Linux 3.11-rc2)
Merging usb.current/usb-linus (9419030 usb: option: add TP-LINK MA260)
Merging staging.current/staging-linus (72bb99c staging: android: logger: Co=
rrect write offset reset on error)
Merging char-misc.current/char-misc-linus (ed4bb97 Tools: hv: KVP: Fix a bu=
g in IPV6 subnet enumeration)
Merging input-current/for-linus (88ce3c3 Merge branch 'next' into for-linus)
Merging md-current/for-linus (352ffda md/raid5: fix interaction of 'replace=
' and 'recovery'.)
Merging audit-current/for-linus (c158a35 audit: no leading space in audit_l=
og_d_path prefix)
Merging crypto-current/master (9c23b7d crypto: caam - Fixed the memory out =
of bound overwrite issue)
Merging ide/master (6d128e1 Revert "Makefile: Fix install error with make -=
j option")
Merging dwmw2/master (5950f08 pcmcia: remove RPX board stuff)
Merging sh-current/sh-fixes-for-linus (4403310 SH: Convert out[bwl] macros =
to inline functions)
Merging devicetree-current/devicetree/merge (cf9e236 of/irq: init struct re=
source to 0 in of_irq_to_resource())
Merging rr-fixes/fixes (2b4fbf0 virtio/console: Add pipe_lock/unlock for sp=
lice_write)
Merging mfd-fixes/master (5649d8f mfd: ab8500-sysctrl: Let sysctrl driver w=
ork without pdata)
Merging vfio-fixes/for-linus (7d13205 Linux 3.10-rc6)
Merging drm-intel-fixes/drm-intel-fixes (363202b drm/i915: fix hdmi portclo=
ck limits)
Merging asm-generic/master (fb9de7e xtensa: Use generic asm/mmu.h for nommu)
Merging arc/for-next (ad81f05 Linux 3.11-rc1)
Merging arm/for-next (c579c69 Merge branch 'devel-stable' into for-next)
Merging arm-perf/for-next/perf (ad81f05 Linux 3.11-rc1)
Merging davinci/davinci-next (fe0d422 Linux 3.0-rc6)
Merging xilinx/arm-next (b028161 Merge branch 'for-3.11' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/tj/cgroup)
Merging arm64/upstream (ff70130 arm64: use common reboot infrastructure)
Merging blackfin/for-linus (eb043d3 smp: blackfin: fix check error, using a=
tomic_ops to handle atomic_t type)
Merging c6x/for-linux-next (f934af0 add memory barrier to arch_local_irq_re=
store)
Merging cris/for-next (32ade6a CRIS: Add kvm_para.h which includes generic =
file)
CONFLICT (content): Merge conflict in arch/cris/arch-v32/drivers/Kconfig
Merging hexagon/linux-next (de44443 HEXAGON: Remove non existent reference =
to GENERIC_KERNEL_EXECVE & GENERIC_KERNEL_THREAD)
Merging ia64/next (9c510f7 [IA64] dmi.h: Make dmi_alloc use kzalloc)
Merging m68k/for-next (ad81f05 Linux 3.11-rc1)
Merging m68knommu/for-next (1a2ac3e m68knommu: Mark functions only called f=
rom setup_arch() __init)
Merging metag/for-next (8a69782 metag: tz1090: instantiate gpio-tz1090-pdc)
Merging microblaze/next (9903883 Merge tag 'dm-3.11-changes' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/agk/linux-dm)
Merging mips/mips-for-linux-next (1cae733 Merge branch '3.11-fixes' into mi=
ps-for-linux-next)
Merging openrisc/for-upstream (6af6095 openrisc: remove HAVE_VIRT_TO_BUS)
Merging parisc/for-next (6c700d7 [PARISC] hpux: Remove obsolete regs parame=
ter from do_execve() in hpux_execve())
Merging parisc-hd/for-next (465b944 parisc: add generic 32- and 64-bit defc=
onfigs)
Merging powerpc/next (1d8b368 pstore: Add hsize argument in write_buf call =
of pstore_ftrace_call)
Merging 4xx/next (2074b1d powerpc: Fix irq distribution)
Merging mpc5xxx/next (dd0120d powerpc/mpc512x: enable USB support in defcon=
fig)
Merging galak/next (9e2ecdb powerpc/fsl-booke: add the reg prop for pci bri=
dge device node for T4/B4)
Merging s390/features (2954ca4 s390: replace remaining strict_strtoul() wit=
h kstrtoul())
Merging sh/sh-latest (37284bd Merge branches 'sh/hw-breakpoints' and 'sh/se=
rial-of' into sh-latest)
CONFLICT (content): Merge conflict in include/linux/serial_sci.h
CONFLICT (content): Merge conflict in arch/sh/kernel/cpu/sh2a/Makefile
Merging sparc-next/master (f8ce1fa Merge tag 'modules-next-for-linus' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux)
Merging tile/master (9ae8480 tile: convert uses of "inv" to "finv")
Merging unicore32/unicore32 (c284464 arch/unicore32: remove CONFIG_EXPERIME=
NTAL)
Merging xtensa/for_next (0eb5afb xtensa: remove the second argument of __bi=
o_kmap_atomic())
Merging btrfs/next (cbacd76 Merge branch 'for-chris' of git://git.kernel.or=
g/pub/scm/linux/kernel/git/josef/btrfs-next into next)
Merging ceph/master (71b4325 ceph: wake up writer if vmtruncate work get bl=
ocked)
Merging cifs/for-next (c4a7408 Do not attempt to do cifs operations reading=
 symlinks with SMB2)
Merging configfs/linux-next (b930c26 Merge branch 'for-linus' of git://git.=
kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs)
Merging ecryptfs/next (cc18ec3 Use ecryptfs_dentry_to_lower_path in a coupl=
e of places)
Merging ext3/for_next (e628753 quota: Convert use of typedef ctl_table to s=
truct ctl_table)
Merging ext4/dev (dda5690 ext3: fix a BUG when opening a file with O_TMPFIL=
E flag)
Merging f2fs/dev (379da23 f2fs: use list_for_each rather than list_for_each=
_safe, in remove_orphan_inode())
Merging fscache/fscache (bcd7351 Merge tag 'fscache-20130702' of git://git.=
kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs)
Merging fuse/for-next (c7263bc fuse: readdirplus: cleanup)
Merging gfs2/master (1067f2a GFS2: Fix typo in gfs2_create_inode())
Merging jfs/jfs-next (eb8630d jfs: Update jfs_error)
Merging logfs/master (3394661 Fix the call to BUG() caused by no free segme=
nt found)
Merging nfs/linux-next (1771c57 NFSv4.1 Use the mount point rpc_clnt for la=
youtreturn)
Merging nfsd/nfsd-next (1c327d9 lockd: protect nlm_blocked access in nlmsvc=
_retry_blocked)
Merging ocfs2/linux-next (4538df6 ocfs2: Don't spam on -EDQUOT.)
Merging omfs/for-next (976d167 Linux 3.1-rc9)
Merging squashfs/master (4b0180a Squashfs: add mount time sanity check for =
block_size and block_log match)
Merging v9fs/for-next (ad81f05 Linux 3.11-rc1)
Merging ubifs/linux-next (beadadf UBIFS: correct mount message)
Merging xfs/for-next (d892d58 xfs: Start using pquotaino from the superbloc=
k.)
Merging vfs/for-next (d405be4 ext4: ->tmpfile() support)
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Merging pci/next (4f1eba3 Merge branch 'pci/aw-acs-fixes-v2' into next)
Merging hid/for-next (3b3294a Merge branch 'for-3.12/upstream' into for-nex=
t)
Merging i2c/i2c/for-next (3b2f64d Linux 3.11-rc2)
Merging jdelvare-hwmon/master (6f7e0b6 hwmon: (w83792d) Update module autho=
r)
Merging hwmon-staging/hwmon-next (d8df13e hwmon: (nct6775) Fix size of data=
->temp array)
Merging v4l-dvb/master (2217438 Merge /home/v4l/v4l/for_upstream)
Merging kbuild/for-next (b4ac615 Merge v3.11-rc1 into kbuild/for-next)
Merging kconfig/for-next (4eae518 localmodconfig: Fix localyesconfig to set=
 to 'y' not 'm')
Merging libata/for-next (8409538 Merge branch 'for-3.11-fixes' into for-nex=
t)
Merging pstore/master (bd08ec3 pstore/ram: Restore ecc information block)
Merging pm/linux-next (82703ad Merge branch 'acpi-pci-hotplug-next' into li=
nux-next)
Merging idle/next (5c99726b Merge branch 'fspin' into next)
Merging apm/for-next (fb9d78a Merge branch 'for-linus' of git://git.kernel.=
org/pub/scm/linux/kernel/git/jikos/apm)
Merging cpupowerutils/master (f166033 cpupower tools: add install target to=
 the debug tools' makefiles)
Merging thermal/next (ace120d Thermal: Fix lockup of cpu_down())
Merging ieee1394/for-next (bcabcfd firewire: remove support of fw_driver.dr=
iver.probe and .remove methods)
Merging ubi/linux-next (83ff59a UBI: support ubi_num on mtd.ubi command lin=
e)
Merging dlm/next (cfa805f dlm: Avoid LVB truncation)
Merging swiotlb/linux-next (af51a9f swiotlb: Do not export swiotlb_bounce s=
ince there are no external consumers)
Merging slave-dma/next (4eb3883 Merge branch 'topic/api_caps' into next)
Merging dmaengine/next (41ef2d5 Linux 3.9-rc7)
Merging net-next/master (2b52c3a ip6mr: change the prototype of ip6_mr_forw=
ard().)
Merging ipsec-next/master (0289094 af_key: constify lookup tables)
Merging wireless-next/master (c6c7788 wil6210: drop -Werror compiler flag)
Applying: bgmac: make bgmac depend on bcm47xx
Merging bluetooth/master (f0868e1 Bluetooth: hidp: remove wrong send_report=
 at init)
CONFLICT (content): Merge conflict in drivers/net/wireless/rtlwifi/ps.c
Merging infiniband/for-next (e04abfa Merge branches 'mlx5', 'qib' and 'srp'=
 into for-next)
Merging mtd/master (a637b0d Merge tag 'for-linus-20130509' of git://git.inf=
radead.org/linux-mtd)
Merging l2-mtd/master (fb1585b mtd: nand: omap2: clean-up BCHx_HW and BCHx_=
SW ECC configurations in device_probe)
Merging crypto/master (aa2faec crypto: caam - Moved macro DESC_JOB_IO_LEN t=
o desc_constr.h)
Merging drm/drm-next (85d9cb4 drm: remove drm_order)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_dma.c
Merging drm-intel/for-linux-next (9601ae7 drm/i915: Use Graphics Base of St=
olen Memory on all gen3+)
CONFLICT (content): Merge conflict in drivers/gpu/drm/i915/i915_gem.c
Merging drm-tegra/drm/for-next (ebae30b gpu: host1x: Rework CPU syncpoint i=
ncrement)
Merging sound/for-next (b785a49 ALSA: replace strict_strto*() with kstrto*(=
))
Merging sound-asoc/for-next (ff273d9 Merge remote-tracking branch 'asoc/top=
ic/wm8994' into asoc-next)
Merging modules/modules-next (ad81f05 Linux 3.11-rc1)
Merging virtio/virtio-next (927cfb9 tools/lguest: offer VIRTIO_F_ANY_LAYOUT=
 for net device.)
Merging input/next (46146e7 Input: nspire-keypad - replace magic offset wit=
h define)
Merging input-mt/for-next (ad81f05 Linux 3.11-rc1)
Merging cgroup/for-next (ed55cff Merge branch 'for-3.12' into for-next)
Merging block/for-next (3fe9649 Merge branch 'for-3.11/drivers' into for-ne=
xt)
Merging device-mapper/master (ad81f05 Linux 3.11-rc1)
Merging embedded/master (4744b43 embedded: fix vc_translate operator preced=
ence)
Merging firmware/master (6e03a20 firmware: speed up request_firmware(), v3)
Merging pcmcia/master (80af9e6 pcmcia at91_cf: fix raw gpio number usage)
Merging mmc/mmc-next (6d1d6b4 mmc: tmio: fix compiler warning)
Merging kgdb/kgdb-next (6bedf31 kdb: Remove unhandled ssb command)
Merging slab/for-next (0450b0c Merge branch 'slab/next' into for-next)
Merging uclinux/for-next (6dbe51c Linux 3.9-rc1)
Merging md/for-next (0779008 md/raid5: make release_stripe lockless)
Merging mfd/master (25f311f mfd: sec: Provide max_register to regmap)
Merging battery/master (5a6c220 charger-manager: Fix regulator_get() return=
 check)
Merging fbdev/for-next (5e8be02 video: atmel_lcdfb: add device tree suport)
Merging viafb/viafb-next (838ac78 viafb: avoid refresh and mode lookup in s=
et_par)
Merging omap_dss2/for-next (e72b753 fbdev/ps3fb: fix compile warning)
Merging regulator/for-next (72f5372 Merge remote-tracking branch 'regulator=
/topic/sec' into regulator-next)
Merging security/next (be0306b Merge branch 'linus-master'; commit 'v3.11-r=
c2' into ra-next)
Merging selinux/master (c2d7b24 Merge tag 'v3.4' into 20120409)
Merging lblnet/master (2fba3cb SELinux: fix selinuxfs policy file on big en=
dian systems)
Merging watchdog/master (b3a3a9c Merge tag 'trace-3.11-rc2' of git://git.ke=
rnel.org/pub/scm/linux/kernel/git/rostedt/linux-trace)
Merging dwmw2-iommu/master (6491d4d intel-iommu: Free old page tables befor=
e creating superpage)
Merging iommu/next (01ce784 Merge branches 'x86/vt-d', 'arm/omap', 'core', =
'x86/amd' and 'arm/smmu' into next)
Merging vfio/next (47188d3 Merge tag 'ext4_for_linus' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/tytso/ext4)
Merging osd/linux-next (861d666 exofs: don't leak io_state and pages on rea=
d error)
Merging jc_docs/docs-next (5c050fb docs: update the development process doc=
ument)
Merging trivial/for-next (8ecada1 doc: printk-formats: fix format specifier=
 to %p[Ii]4[hnbl])
Merging audit/for-next (dcd6c92 Linux 3.3-rc1)
Merging fsnotify/for-next (1ca39ab inotify: automatically restart syscalls)
Merging edac/linux_next (de4772c edac: sb_edac.c should not require prescen=
ce of IMC_DDRIO device)
Merging edac-amd/for-next (aad19e5 EDAC, MCE, AMD: Add an MCE signature for=
 new Fam15h models)
Merging devicetree/devicetree/next (6dd18e4 of: Fix address decoding on Bim=
ini and js2x machines)
Merging dt-rh/for-next (d683b96 Linux 3.10-rc4)
Merging spi/for-next (c1ad66b Merge remote-tracking branch 'spi/topic/xilin=
x' into spi-next)
Merging tip/auto-latest (54396a6 Merge branch 'x86/urgent')
Merging ftrace/for-next (e70e78e tracing: Kill the unbalanced tr->ref++ in =
tracing_buffers_open())
Merging rcu/rcu/next (0f791c9 nohz_full: Force RCU's grace-period kthreads =
onto timekeeping CPU)
Merging cputime/cputime (c3e0ef9 [S390] fix cputime overflow in uptime_proc=
_show)
Merging uprobes/for-next (0326f5a uprobes/core: Handle breakpoint and singl=
estep exceptions)
Merging kvm/linux-next (103af0a perf, kvm: Support the in_tx/in_tx_cp modif=
iers in KVM arch perfmon emulation v5)
Merging kvm-arm/kvm-arm-next (8bd4ffd ARM: kvm: don't include drivers/virti=
o/Kconfig)
Merging kvm-ppc/kvm-ppc-next (20f7462 Merge remote-tracking branch 'cmadma/=
for-v3.12-cma-dma' into kvm-ppc-next)
CONFLICT (content): Merge conflict in mm/Kconfig
Merging oprofile/for-next (f722406 Linux 3.10-rc1)
Merging fw-nohz/nohz/next (74876a9 printk: Wake up klogd using irq_work)
Merging xen/upstream/xen (af3a3ab Merge git://git.kernel.org/pub/scm/linux/=
kernel/git/steve/gfs2-3.0-fixes)
Merging xen-two/linux-next (21f3c04 Merge branch 'stable/for-linus-3.11' in=
to linux-next)
Merging xen-arm/linux-next (2451ade xen/arm,arm64: update xen_restart after=
 ff701306cd49 and 7b6d864b48d9)
Merging percpu/for-next (a424445 percpu-refcount: use RCU-sched insted of n=
ormal RCU)
Merging workqueues/for-next (bbe2a23 Merge branch 'for-3.10-fixes' into for=
-next)
Merging drivers-x86/linux-next (de91b53 x86 platform drivers: fix gpio leak)
Merging hwpoison/hwpoison (46e387b Merge branch 'hwpoison-hugepages' into h=
wpoison)
Merging sysctl/master (4e474a0 sysctl: protect poll() in entries that may g=
o away)
Merging regmap/for-next (8d8ad1a Merge remote-tracking branch 'regmap/topic=
/sparse' into regmap-next)
Merging hsi/for-next (43139a6 HSI: hsi_char: Update ioctl-number.txt)
Merging leds/for-next (9394690 leds: support new LP8501 device - another LP=
55xx common)
Merging driver-core/driver-core-next (3b2f64d Linux 3.11-rc2)
Merging tty/tty-next (ad0cc7b n_tty: Factor tty->closing receive_buf() into=
 separate fn)
$ git reset --hard HEAD^
Merging next-20130723 version of tty
Merging usb/usb-next (e452828 USB: sl811: remove CONFIG_USB_DEBUG dependenc=
y)
Merging usb-gadget/next (b1fd6cb usb: dwc3: omap: Adds dwc3_omap_readl/writ=
el wrappers)
Merging staging/staging-next (a159d62 staging: usbip: improve error reporti=
ng)
Merging char-misc/char-misc-next (3b2f64d Linux 3.11-rc2)
Merging scsi/for-next (085b513 [SCSI] sd: fix crash when UA received on DIF=
 enabled device)
Merging target-updates/for-next (ca40d24 iser-target: Ignore non TEXT + LOG=
OUT opcodes for discovery)
Merging target-merge/for-next-merge (317ddd2 Linux 3.10-rc5)
Merging ibft/linux-next (935a9fe ibft: Fix finding IBFT ACPI table on UEFI)
Merging isci/all (6734092 isci: add a couple __iomem annotations)
Merging bcon/master (e284f34 netconsole: s/syslogd/cancd/ in documentation)
CONFLICT (content): Merge conflict in drivers/block/Kconfig
Merging tmem/linux-next (8f0d816 Linux 3.7-rc3)
Merging writeback/writeback-for-next (8bb495e Linux 3.10)
Merging arm-dt/devicetree/arm-next (ede338f dt: add documentation of ARM dt=
 boot interface)
Merging hwspinlock/linux-next (8b37fcf hwspinlock: add MAINTAINERS entries)
Merging pinctrl/for-next (f2577e7 Merge branch 'devel' into for-next)
Merging vhost/linux-next (22fa90c vhost: Remove custom vhost rcu usage)
Merging memblock/memblock-kill-early_node_map (7bd0b0f memblock: Reimplemen=
t memblock allocation using reverse free area iterator)
Merging remoteproc/for-next (b977785 remoteproc: fix kconfig dependencies f=
or VIRTIO)
Merging rpmsg/for-next (397944d rpmsg: fix kconfig dependencies for VIRTIO)
Merging gpio/for-next (cd2f7f0 Merge branch 'devel' into for-next)
Merging arm-soc/for-next (b87502d Merge branch 'next/cleanup' into for-next)
Merging bcm2835/for-next (7d13205 Linux 3.10-rc6)
Merging cortex/for-next (3ad87ac ARM: ARMv7-M: Fix name of NVIC handler fun=
ction)
Merging ep93xx/ep93xx-for-next (9c59be7 Merge branch 'ep93xx-devel' into ep=
93xx-for-next)
Merging imx-mxs/for-next (6a94b73 Merge branch 'mxs/dt' into for-next)
CONFLICT (content): Merge conflict in arch/arm/Kconfig.debug
Merging ixp4xx/next (19f949f Linux 3.8)
Merging msm/for-next (d701eda ARM: dts: msm: Fix merge resolution)
Merging mvebu/for-next (ad81f05 Linux 3.11-rc1)
Merging renesas/next (833574a Merge tag 'renesas-clocksource-for-v3.12' int=
o next)
Merging samsung/for-next (5302ef0 Merge branch 'v3.12-next/cleanup-samsung'=
 into for-next)
Merging tegra/for-next (e4f00cf Merge branch for-3.12/defconfig into for-ne=
xt)
Merging dma-mapping/dma-mapping-next (f7d8f1e Merge remote-tracking branch =
'dma-public/for-v3.12-cma-dma' into for-next)
Merging pwm/for-next (b388f15 pwm: pwm-tiehrpwm: Use clk_enable/disable ins=
tead clk_prepare/unprepare.)
Merging dma-buf/for-next (8bb495e Linux 3.10)
Merging userns/for-next (78008c4 proc: Restrict mounting the proc filesyste=
m)
Merging ktest/for-next (df5f7c6 ktest: Reset grub menu cache with different=
 machines)
Merging signal/for-next (20b4fb4 Merge branch 'for-linus' of git://git.kern=
el.org/pub/scm/linux/kernel/git/viro/vfs)
Merging clk/clk-next (45e3ec3 clk: tegra: fix ifdef for tegra_periph_reset_=
assert inline)
Merging random/dev (b980955 random: fix locking dependency with the tasklis=
t_lock)
Merging lzo-update/lzo-update (42b775a lib/lzo: huge LZO decompression spee=
dup on ARM by using unaligned access)
Merging arm64-hugepages/for-next/hugepages (af07484 ARM64: mm: THP support.)
Merging ptr-ret/PTR_RET (ad151d5 GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO)
Merging aio/master (0c45355 aio: fix build when migration is disabled)
Merging scsi-post-merge/merge-base:master (65112dc Merge git://git.samba.or=
g/sfrench/cifs-2.6)
Merging akpm-current/current (1f02e5b staging/lustre: replace num_physpages=
 with totalram_pages)
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/ldlm/ld=
lm_pool.c
$ git checkout -b akpm remotes/origin/akpm/master
Applying: fs: bump inode and dentry counters to long
Applying: super: fix calculation of shrinkable objects for small numbers
Applying: dcache: convert dentry_stat.nr_unused to per-cpu counters
Applying: dentry: move to per-sb LRU locks
Applying: dcache: remove dentries from LRU before putting on dispose list
Applying: mm: new shrinker API
Applying: shrinker: convert superblock shrinkers to new API
Applying: shrinker-convert-superblock-shrinkers-to-new-api-fix
Applying: list: add a new LRU list type
Applying: inode: convert inode lru list to generic lru list code.
Applying: inode: move inode to a different list inside lock
Applying: dcache: convert to use new lru list infrastructure
Applying: list_lru: per-node list infrastructure
Applying: list_lru: per-node list infrastructure fix
Applying: list_lru: fix broken LRU_RETRY behaviour
Applying: list_lru: per-node API
Applying: list_lru: remove special case function list_lru_dispose_all.
Applying: shrinker: add node awareness
Applying: vmscan: per-node deferred work
Applying: fs: convert inode and dentry shrinking to be node aware
Applying: xfs: convert buftarg LRU to generic code
Applying: xfs-convert-buftarg-lru-to-generic-code-fix
Applying: xfs: rework buffer dispose list tracking
Applying: xfs: convert dquot cache lru to list_lru
Applying: xfs-convert-dquot-cache-lru-to-list_lru-fix
Applying: xfs: fix dquot isolation hang
Applying: fs: convert fs shrinkers to new scan/count API
Applying: fs-convert-fs-shrinkers-to-new-scan-count-api-fix
Applying: UBIFS: signedness bug in ubifs_shrink_count()
Applying: drivers: convert shrinkers to new count/scan API
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix
Applying: drivers-convert-shrinkers-to-new-count-scan-api-fix-2
Applying: i915: bail out earlier when shrinker cannot acquire mutex
Applying: shrinker: convert remaining shrinkers to count/scan API
Applying: shrinker-convert-remaining-shrinkers-to-count-scan-api-fix
Applying: hugepage: convert huge zero page shrinker to new shrinker API
Applying: hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix
Applying: shrinker: Kill old ->shrink API.
Applying: shrinker-kill-old-shrink-api-fix
Applying: list_lru: dynamically adjust node arrays
Applying: super: fix for destroy lrus
Merging akpm/master (69733db super: fix for destroy lrus)

--Signature=_Wed__24_Jul_2013_16_32_54_+1000_WErG.sausHWVO=Gi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR73UaAAoJEECxmPOUX5FE/AkP/0medffFBnQfFlF5sM/4kM43
j5aHneDoFzY9IfKh519oguupVKG/rN2j6iI1Vmqof8KF0E6gk4khhkQ2FaX5VBeN
4H4Qx0e/fqlLFTA8/1FIfm4hbR6RE7vPSvbLdlrabaBipSLY/X+qoTLskaWPqbq7
QRbU1O32FsxKXxSL+e8B47UOQqPcXlb9oyJJ1p6nkun2zzqpvM24mKrmhGF+3hrD
wGpqE3KoW1H+Xh8Fx5uT1+WOGUHnfP7Bel2KzCRXRixJxDwquiuYw9p8dfHBFtMv
5qYGhVXuFyyAZHAUM3XAnpa4EKEHsRcBrnmK0O60XV5h9J7VpYgPVIc52glT7xWD
xWiV6gKSFKUDFUDX90tSwYbfPhJ0rHsYFSr2pvQsnTxN2b9XQ57Zi1f88ksIg2NA
jvRbzMEQxOioZVoAEQRldvvXpJ6D/6CMawydrcKuxjbt/9co4hgueYMxeRjoyc37
r5Ujj92gVpFVZXYLP13Rj/WFGR7KjZfcb9rWGZ8IzTfMcBDZUv2fO9++dtEkInkg
s9cTYhdf0phmCWj8w3JTHXzrodCW3Zk5Hji8nHKdqXdXfSkK+hGAMuCQPnvm/tWA
2WPMDeUFtK+srrlTVU/CMCOLfbilo4cKgsXHxi6xoiFwBrzFTpYR21nxWWJYpW7Q
BSj2VD6yFS1S0P+mpbLx
=IqVn
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jul_2013_16_32_54_+1000_WErG.sausHWVO=Gi--
