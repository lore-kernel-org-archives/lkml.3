Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbaGQXpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:45:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648AbaGQXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:45:15 -0400
Date: Thu, 17 Jul 2014 16:45:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.6
Message-ID: <20140717234514.GA16980@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.6 kernel.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/cpu-freq/intel-pstate.txt      |    7 +
 Makefile                                     |    2=20
 arch/arm64/include/asm/memory.h              |    2=20
 arch/parisc/kernel/hardware.c                |    3=20
 arch/parisc/kernel/sys_parisc32.c            |   10 ++
 arch/parisc/kernel/syscall_table.S           |    2=20
 arch/powerpc/Kconfig                         |    3=20
 arch/powerpc/include/asm/perf_event_server.h |    3=20
 arch/powerpc/kvm/book3s_hv_interrupts.S      |    5 -
 arch/powerpc/perf/core-book3s.c              |   26 ++++-
 arch/powerpc/perf/power8-pmu.c               |    2=20
 arch/x86/crypto/sha512_ssse3_glue.c          |    2=20
 arch/x86/mm/ioremap.c                        |   26 +++--
 drivers/acpi/ac.c                            |  130 ++++++++++++++++++++++=
++++-
 drivers/acpi/battery.c                       |   27 +++++
 drivers/acpi/ec.c                            |  128 ++++++++++++----------=
----
 drivers/acpi/resource.c                      |   10 +-
 drivers/ata/ahci_imx.c                       |   35 ++++++-
 drivers/base/dma-contiguous.c                |   12 ++
 drivers/char/i8k.c                           |    4=20
 drivers/clk/clk-s2mps11.c                    |    7 -
 drivers/clk/qcom/mmcc-msm8960.c              |    2=20
 drivers/clk/spear/spear3xx_clock.c           |    2=20
 drivers/cpufreq/Makefile                     |    2=20
 drivers/cpufreq/intel_pstate.c               |   35 ++++---
 drivers/crypto/caam/jr.c                     |    8 -
 drivers/gpu/drm/i915/i915_drv.h              |    1=20
 drivers/gpu/drm/i915/i915_gem_stolen.c       |   44 +++++++++
 drivers/gpu/drm/i915/i915_reg.h              |    3=20
 drivers/gpu/drm/i915/intel_display.c         |   14 ++
 drivers/gpu/drm/i915/intel_panel.c           |    8 +
 drivers/gpu/drm/radeon/ci_dpm.c              |    2=20
 drivers/gpu/drm/radeon/evergreen.c           |    8 -
 drivers/gpu/drm/radeon/radeon_vm.c           |    4=20
 drivers/gpu/drm/radeon/rs600.c               |    6 -
 drivers/gpu/drm/radeon/rv770_dpm.c           |    6 -
 drivers/hv/connection.c                      |    8 +
 drivers/hwmon/adc128d818.c                   |   28 ++---
 drivers/hwmon/adm1021.c                      |   14 +-
 drivers/hwmon/adm1029.c                      |    3=20
 drivers/hwmon/adm1031.c                      |    8 +
 drivers/hwmon/amc6821.c                      |    2=20
 drivers/hwmon/emc2103.c                      |   15 +--
 drivers/iio/adc/ti_am335x_adc.c              |    2=20
 drivers/md/dm-io.c                           |   22 +---
 drivers/md/dm-mpath.c                        |    5 -
 drivers/md/dm.c                              |   15 ++-
 drivers/mtd/nand/omap2.c                     |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c  |    2=20
 drivers/pci/pci.c                            |    9 +
 drivers/phy/phy-core.c                       |    7 -
 drivers/rtc/rtc-puv3.c                       |    4=20
 drivers/thermal/thermal_hwmon.c              |   33 +++---
 drivers/tty/serial/imx.c                     |    3=20
 drivers/tty/serial/ip22zilog.c               |    2=20
 drivers/tty/serial/m32r_sio.c                |    8 +
 drivers/tty/serial/pmac_zilog.c              |    3=20
 drivers/tty/serial/sunsab.c                  |    3=20
 drivers/tty/serial/sunzilog.c                |    2=20
 drivers/usb/serial/cp210x.c                  |    1=20
 drivers/usb/serial/ftdi_sio.c                |    5 -
 drivers/usb/serial/ftdi_sio_ids.h            |    9 +
 drivers/usb/serial/option.c                  |    2=20
 fs/ext4/extents_status.c                     |    4=20
 fs/ext4/ialloc.c                             |   14 +-
 fs/ext4/mballoc.c                            |    4=20
 fs/ext4/super.c                              |   60 +++++-------
 fs/f2fs/data.c                               |    3=20
 fs/f2fs/f2fs.h                               |    1=20
 fs/f2fs/node.c                               |   46 +++++----
 fs/f2fs/node.h                               |    5 -
 fs/jbd2/transaction.c                        |    5 -
 fs/kernfs/dir.c                              |    1=20
 fs/kernfs/kernfs-internal.h                  |    5 +
 fs/kernfs/mount.c                            |   41 ++++++++
 include/linux/kernfs.h                       |    5 +
 include/linux/ring_buffer.h                  |    2=20
 kernel/cgroup.c                              |   53 ++++++++++-
 kernel/cpuset.c                              |    8 +
 kernel/trace/ring_buffer.c                   |    5 -
 kernel/trace/trace.c                         |   25 +++--
 kernel/trace/trace.h                         |    4=20
 kernel/workqueue.c                           |    3=20
 mm/mempolicy.c                               |    2=20
 84 files changed, 792 insertions(+), 320 deletions(-)

Aaron Lu (1):
      thermal: hwmon: Make the check for critical temp valid consistent

Alex Deucher (2):
      drm/radeon: fix typo in ci_stop_dpm()
      drm/radeon: fix typo in golden register setup on evergreen

Alex Williamson (1):
      PCI: Fix unaligned access in AF transaction pending test

Alexandre Demers (1):
      drm/radeon/dpm: Reenabling SS on Cayman

Andras Kovacs (1):
      USB: cp210x: add support for Corsair usb dongle

Andy Whitcroft (1):
      ACPI / resources: only reject zero length resources based at address =
zero

Anton Blanchard (1):
      powerpc/perf: Never program book3s PMCs with values >=3D 0x80000000

Axel Lin (3):
      hwmon: (amc6821) Fix permissions for temp2_input
      hwmon: (adm1029) Ensure the fan_div cache is updated in set_fan_div
      hwmon: (adm1021) Fix cache problem when writing temperature limits

Bernd Wachter (1):
      usb: option: Add ID for Telewell TW-LTE 4G v2

Bert Vermeulen (1):
      USB: ftdi_sio: Add extra PID.

Chen Gang (2):
      drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue
      drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo=
 issue

Christian K=F6nig (2):
      drm/radeon: page table BOs are kernel allocations
      drm/radeon: stop poisoning the GART TLB

Colin Cross (1):
      arm64: implement TASK_SIZE_OF

Cristian Stoica (1):
      crypto: caam - fix memleak in caam_jr module

Dirk Brandewie (3):
      intel_pstate: Fix setting VID
      intel_pstate: don't touch turbo bit if turbo disabled or unavailable.
      intel_pstate: Update documentation of {max,min}_perf_pct sysfs files

Eric Sandeen (1):
      ext4: disable synchronous transaction batching if max_batch_time=3D=
=3D0

Greg Kroah-Hartman (1):
      Linux 3.15.6

Gu Zheng (1):
      cpuset,mempolicy: fix sleeping function called from invalid context

Guenter Roeck (5):
      i8k: Fix non-SMP operation
      hwmon: (adc128d818) Drop write support on inX_input attributes
      hwmon: (emc2103) Clamp limits instead of bailing out
      hwmon: (adm1031) Fix writes to limit registers
      powerpc: Disable RELOCATABLE for COMPILE_TEST with PPC64

Helge Deller (2):
      parisc: add serial ports of C8000/1GHz machine to hardware database
      parisc: fix fanotify_mark() syscall on 32bit compat kernel

Jaegeuk Kim (2):
      f2fs: adjust free mem size to flush dentry blocks
      f2fs: check bdi->dirty_exceeded when trying to skip data writes

Jan Kardell (1):
      iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends

Jean Sacren (1):
      i40e: fix passing wrong error code to i40e_open()

Joe Thornber (1):
      dm io: fix a race condition in the wake up code for sync_io

Joel Stanley (3):
      powerpc/kvm: Remove redundant save of SIER AND MMCR2
      powerpc/perf: Add PPMU_ARCH_207S define
      powerpc/perf: Clear MMCR2 when enabling PMU

Joonsoo Kim (1):
      DMA, CMA: fix possible memory leak

Jun'ichi Nomura (1):
      dm mpath: fix IO hang due to logic bug in multipath_busy

Jussi Kivilinna (1):
      crypto: sha512_ssse3 - fix byte count to bit count conversion

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code

Krzysztof Kozlowski (1):
      clk: s2mps11: Fix double free corruption during driver unbind

Lan Tianyu (2):
      Revert "ACPI / AC: Remove AC's proc directory."
      ACPI / battery: Retry to get battery information if failed during pro=
bing

Li Zefan (3):
      cgroup: fix mount failure in a corner case
      kernfs: introduce kernfs_pin_sb()
      cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()

Lv Zheng (4):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()

Maxime Bizon (1):
      workqueue: fix dev_set_uevent_suppress() imbalance

Michal Sojka (1):
      USB: serial: ftdi_sio: Add Infineon Triboard

Mikulas Patocka (1):
      dm: allocate a special workqueue for deferred device removal

Peter Hurley (2):
      serial: Test for no tx data on tx restart
      serial: imx: Fix build breakage

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Roger Quadros (1):
      phy: core: Fix error path in phy_create()

Roland Dreier (1):
      x86, ioremap: Speed up check for RAM pages

Scot Doyle (3):
      drm/i915: quirk asserts controllable backlight presence, overriding V=
BT
      drm/i915: Acer C720 and C720P have controllable backlights
      drm/i915: Toshiba CB35 has a controllable backlight

Shawn Guo (1):
      ahci: imx: manage only sata_ref_clk in imx_sata_enable[disable]

Stephen Boyd (1):
      clk: qcom: HDMI source sel is 3 not 2

Steven Rostedt (Red Hat) (1):
      ring-buffer: Check if buffer exists before polling

Ted Juan (1):
      mtd: nand: omap: fix omap_calculate_ecc_bch() for-loop error

Tejun Heo (1):
      kernfs: implement kernfs_root->supers list

Theodore Ts'o (5):
      ext4: fix unjournalled bg descriptor while initializing inode bitmap
      ext4: clarify error count warning messages
      ext4: clarify ext4_error message in ext4_mb_generate_buddy_error()
      ext4: revert commit which was causing fs corruption after journal rep=
lays
      ext4: fix a potential deadlock in __ext4_es_shrink()

Thomas Gleixner (1):
      clk: spear3xx: Use proper control register offset

Ville Syrj=E4l=E4 (1):
      drm/i915: Don't clobber the GTT when it's within stolen memory

Vincent Minet (1):
      intel_pstate: Set CPU number before accessing MSRs

Yasuaki Ishimatsu (1):
      workqueue: zero cpumask of wq_numa_possible_cpumask on init


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyGAKAAoJEDjbvchgkmk++DoP/1PAOQzfY/DbZIZKlFMtztTU
CEBXTeigP/907sushP3uoLsa8FjGmnOHQ+F9u2WYPHdyUA3YuHCeD8FxoWkj3a0B
WBPqefHxxdTygnu9cxdYnH/DKSIXzuA4NmE7O88jqQAZA0RQBqo4HsVgwG5lOfCO
U6lXAn24DzpTcuGBeYQIlngNkjko99Xq3DDj7/0cmr7widTnTusVS2qIarFsWzAO
Ubn/Nw7ndjKsR1bvu4LWiC0CX2CZS6fWKy1J+8S5q9ftDYnsmX3z13sD7ZrucV8M
Xw9Wx28CDjBLyA4oD4Haunwm4SrNlWHePALW31nVv29qcKv7cgD74yl3voYUv3g+
hD5jbwouw2Rk/dMbrVSbzcmYVXAwo3eh6uE1kzmxP4xeLfRdOslyxIpyaPKZ+TvM
8bbd/9PQGG0eXatXv5ZYZMAL2hx7Z2BDhbvVUTIxIFAJjKUbt4z74TjUk0OaqCTj
0xWvNRtbiRclqx10ArZmOcd+J6iqN3RXuGdP7YtiIerIk14K6mRVvHbkGK7tMjmK
/IjmALQ7kFoc0WC6Pn+qwMYpOffLLZRn+jdQgqApQx9fd+vDlXzMPsYjf4hUnf+B
ut/Bi8dL+27cggMu51Hpn7ap2Y/ATEIhDGa4rK730ehwLw2qAJZ/Mxx9eeh3SpG1
lMSGxRwPUMeePGrzQSyG
=3i/3
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
