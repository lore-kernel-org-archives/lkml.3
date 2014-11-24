Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaKXKFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:05:10 -0500
Received: from ozlabs.org ([103.22.144.67]:41014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbaKXKFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:05:04 -0500
Date: Mon, 24 Nov 2014 21:04:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Nov 24
Message-ID: <20141124210456.4438a30a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p0_3FYH/nuu5Fm2RMl6UeiE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p0_3FYH/nuu5Fm2RMl6UeiE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Unfortunately, I lost most of the log today ... sorry about that.

Changes since 20141121:

The sunxi tree gained a conflict against the arm-soc tree.

The v4l-dvb tree gained a conflict againt the arm-soc tree.

The omap_dss2 tree still had its build failure for which I applied a patch.

The i2c tree gained a build failure for which I reverted a commit.

The iommu tree gained a conflict against the tegra tree.

The tip tree gained a conflict against the pci tree.

The ftrace tree lost its build failure.

The kvm tree gained a build failure so I used the version from
next-20141121.

The driver-core tree gained conflicts against the tegra and v4l-dvb trees.

The staging tree gained conflicts against the v4l-dvb tree.

The char-misc tree gained a conflict against the arm tree.

The akpm-current tree gained a conflict against the ftrace tree.

Non-merge commits (relative to Linus' tree): 8073
 7869 files changed, 295401 insertions(+), 203599 deletions(-)

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

Merging ftrace/for-next (204153212493 Merge branch 'trace/rfc/seq-buf' into=
 trace/for-next)
Merging rcu/rcu/next (9ea6c5885681 Merge branches 'torture.2014.11.03a', 'c=
pu.2014.11.03a', 'doc.2014.11.13a', 'fixes.2014.11.13a', 'signal.2014.10.29=
a' and 'rt.2014.10.29a' into HEAD)
Merging uprobes/for-next (0326f5a94dde uprobes/core: Handle breakpoint and =
singlestep exceptions)
Merging kvm/linux-next (1d7fe1d1fb18 KVM: x86: support XSAVES usage in the =
host)
$ git reset --hard HEAD^
Merging next-20141121 version of kvm
Merging kvm-arm/next (f62c95fd4041 Merge tag 'kvm-s390-next-20141028' of gi=
t://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD)
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
Merging ipmi/for-next (2666ea7056e6 Change ACPI IPMI support to "default y")
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
Merging tty/tty-next (e4c787dac21e Revert "serial: of-serial: fetch line nu=
mber from DT")
CONFLICT (content): Merge conflict in drivers/tty/n_tty.c
Merging usb/usb-next (69b7290e51e5 Merge 3.18-rc4 into usb-next.)
Merging usb-gadget/next (7b0f000b2fdc usb: gadget: function: delete an unne=
cessary check before rndis_add_hdr())
CONFLICT (content): Merge conflict in drivers/usb/gadget/udc/pxa27x_udc.c
CONFLICT (content): Merge conflict in drivers/usb/dwc3/ep0.c
CONFLICT (content): Merge conflict in drivers/usb/dwc2/gadget.c
CONFLICT (content): Merge conflict in drivers/usb/chipidea/otg_fsm.c
Merging usb-serial/usb-next (e7181d005e84 USB: qcserial: Add support for HP=
 lt4112 LTE/HSPA+ Gobi 4G Modem)
Merging staging/staging-next (962dbfd6144a staging: lustre: mdc: use __FMOD=
E_EXEC macro)
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
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/n=
amei.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/l=
lite_lib.c
CONFLICT (content): Merge conflict in drivers/staging/lustre/lustre/llite/f=
ile.c
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
Merging scsi/for-next (6c8a2ce9aea5 Merge remote-tracking branch 'scsi-queu=
e/drivers-for-3.19' into for-next)
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
Merging ktest/for-next (18656c7099c6 ktest: Add name to running title)
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
Merging kselftest/next (49296470830a selftests/timers: change test to use k=
sft framework)
Merging y2038/y2038 (45446a99cef6 staging: media: lirc: Replace timeval wit=
h ktime_t in lirc_parallel.c)
CONFLICT (content): Merge conflict in drivers/staging/media/lirc/lirc_sasem=
.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-usb/ft1=
000_debug.c
CONFLICT (content): Merge conflict in drivers/staging/ft1000/ft1000-pcmcia/=
ft1000_hw.c
[master be91dc3caa65] Revert "i2c: rk3x: handle dynamic clock rate changes =
correctly"
Merging akpm-current/current (8af0244ab072 shmdt: use i_size_read() instead=
 of ->i_size)
CONFLICT (content): Merge conflict in mm/hugetlb.c
CONFLICT (content): Merge conflict in lib/Kconfig
CONFLICT (content): Merge conflict in kernel/printk/printk.c
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in fs/ocfs2/inode.h
CONFLICT (content): Merge conflict in drivers/usb/storage/debug.c
CONFLICT (content): Merge conflict in drivers/rtc/rtc-omap.c
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
Merging akpm/master (4822e94085a2 mm: add strictlimit knob)

--Sig_/p0_3FYH/nuu5Fm2RMl6UeiE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUcwLNAAoJEMDTa8Ir7ZwVI1IP/AlF2DX1JclG6adf1FaheTho
s1O3QvuXOwTW00RytmuX9/zqjWEXpbztvSA3wNNaPXMAXmhzPeXB1E/3yrG/ex4R
Uc6bRT3l14H+UEwV1/3IvS0gD5wF7l7NutMiA0Zi9HmHqFnzIzok7zPk/BVXWtYj
BUBsVH3aMDB3dRL0tkrocXblMpznLyv0OXWyaZ3vFO08/YHCX1OdzgNSbyagCOI4
Mn5T9J5KxXNTLHS47oCYwV16qu4lYY+HRPnLageM6JNKMk7s+/LAIyUZX0fRPDf5
6ZuKDjrTOcBYLY8bZfEy+v9/AU7E5jUfnmG0qqAWWA62p+6TZlrv8eUUK3Fo0TtK
OB0GYRF2hkxdl3OkIaF532M4w3JUGA0CXKNoGtbmz4TN9oiXBKKOD8PESEhl/C3F
BX8m5mf3jb0Ni2Evb1Xg5lJbody8BwD+SrEktHr0BNCTkec4fX3K4ViH3ZvlCT8D
v4G4Kku0+E9E/Ocl8AOIGBPdxSw5vF2uroRCokPjwwSKTTwSr/FymjHa6Smi2p/R
KLr+YK6EXeI96IAVfF3QsEVIYP4YajvxgeKI8U++kehJmW3JDTxVrgJ+zLW1ZXxQ
sJz8muYF3MyDv3fvsXOR9SkkiRH13bia46vEQ3KganWkvHeBukFCAXZuU7rGeMI6
1U4DD+H2rKRcsuFIRpXI
=ROBC
-----END PGP SIGNATURE-----

--Sig_/p0_3FYH/nuu5Fm2RMl6UeiE--
