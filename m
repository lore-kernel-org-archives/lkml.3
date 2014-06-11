Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaFKTtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:49:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaFKTs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:48:58 -0400
Date: Wed, 11 Jun 2014 12:52:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.7
Message-ID: <20140611195247.GA3175@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.7 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/DocBook/media/Makefile              |    2=20
 Documentation/debugging-via-ohci1394.txt          |   13 ++-
 Documentation/device-mapper/thin-provisioning.txt |    5 +
 Makefile                                          |    2=20
 arch/arm/include/asm/uaccess.h                    |    3=20
 arch/arm/kernel/entry-header.S                    |    4 +
 arch/arm/mach-imx/devices/platform-ipu-core.c     |    2=20
 arch/arm/mach-omap2/board-flash.c                 |    2=20
 arch/arm/mach-omap2/cclock3xxx_data.c             |    3=20
 arch/arm/mach-omap2/cpuidle44xx.c                 |   25 ++++++-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c        |    2=20
 arch/mips/kernel/traps.c                          |    4 -
 drivers/ata/libata-core.c                         |    8 +-
 drivers/block/virtio_blk.c                        |    4 -
 drivers/cpufreq/cpufreq-cpu0.c                    |   16 +++-
 drivers/cpufreq/cpufreq_governor.c                |    6 +
 drivers/cpufreq/intel_pstate.c                    |   72 ++++++++++++-----=
-----
 drivers/firewire/core.h                           |    4 -
 drivers/firewire/ohci.c                           |    2=20
 drivers/gpio/gpio-mcp23s08.c                      |   11 ++-
 drivers/gpu/drm/i915/i915_drv.h                   |    1=20
 drivers/gpu/drm/i915/i915_gem_execbuffer.c        |   54 +++++++++-------
 drivers/gpu/drm/i915/intel_crt.c                  |    1=20
 drivers/gpu/drm/i915/intel_display.c              |   14 +++-
 drivers/gpu/drm/i915/intel_dp.c                   |   23 ++++++-
 drivers/gpu/drm/i915/intel_drv.h                  |    8 ++
 drivers/gpu/drm/i915/intel_dsi.c                  |    1=20
 drivers/gpu/drm/i915/intel_dvo.c                  |    1=20
 drivers/gpu/drm/i915/intel_hdmi.c                 |    1=20
 drivers/gpu/drm/i915/intel_lvds.c                 |    1=20
 drivers/gpu/drm/i915/intel_sdvo.c                 |    1=20
 drivers/gpu/drm/i915/intel_tv.c                   |    1=20
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c   |    2=20
 drivers/gpu/drm/radeon/atombios_crtc.c            |    6 -
 drivers/gpu/drm/radeon/radeon_asic.c              |    4 -
 drivers/gpu/drm/radeon/radeon_bios.c              |   14 ++++
 drivers/gpu/drm/radeon/radeon_cs.c                |   15 +++-
 drivers/gpu/drm/radeon/radeon_device.c            |    4 +
 drivers/gpu/drm/radeon/radeon_object.c            |   38 +++++++----
 drivers/gpu/drm/radeon/radeon_pm.c                |   43 ++++++++++++-
 drivers/gpu/drm/radeon/sid.h                      |    4 -
 drivers/hwmon/Kconfig                             |    2=20
 drivers/hwmon/ntc_thermistor.c                    |   15 ++--
 drivers/infiniband/ulp/isert/ib_isert.c           |    2=20
 drivers/iommu/intel-iommu.c                       |   18 +++++
 drivers/md/dm-cache-target.c                      |    2=20
 drivers/md/dm-thin.c                              |   12 ++-
 drivers/md/md.c                                   |    5 +
 drivers/scsi/scsi_transport_sas.c                 |    3=20
 drivers/staging/comedi/drivers/ni_daq_700.c       |    2=20
 drivers/staging/rtl8192e/rtllib_tx.c              |    2=20
 drivers/staging/speakup/main.c                    |    1=20
 drivers/staging/speakup/selection.c               |   52 +++++++++++++--
 drivers/staging/speakup/speakup.h                 |    1=20
 drivers/target/iscsi/iscsi_target_login.c         |   57 ++++++++---------
 drivers/target/target_core_configfs.c             |    5 +
 drivers/tty/tty_buffer.c                          |    2=20
 drivers/usb/core/driver.c                         |    9 +-
 drivers/usb/core/hub.c                            |   15 +++-
 drivers/usb/host/pci-quirks.c                     |    7 ++
 drivers/usb/host/xhci-mem.c                       |   20 +++---
 drivers/usb/serial/ftdi_sio.c                     |    2=20
 drivers/usb/serial/ftdi_sio_ids.h                 |    5 +
 drivers/usb/serial/io_ti.c                        |    2=20
 drivers/usb/serial/io_usbvend.h                   |    2=20
 drivers/usb/serial/option.c                       |    2=20
 fs/proc/task_mmu.c                                |    2=20
 include/linux/percpu-refcount.h                   |    6 -
 include/uapi/linux/usb/Kbuild                     |    1=20
 include/uapi/linux/usb/cdc-wdm.h                  |    2=20
 kernel/cpu.c                                      |    6 +
 kernel/events/core.c                              |   63 ++++++++++++-----=
--
 kernel/sched/core.c                               |   55 +++++++++++-----
 kernel/sched/cpudeadline.c                        |    4 -
 kernel/sched/cpupri.c                             |    3=20
 kernel/sched/cputime.c                            |   32 ++++-----
 kernel/sched/deadline.c                           |   10 ++-
 mm/memory-failure.c                               |    2=20
 mm/mempolicy.c                                    |    6 +
 mm/rmap.c                                         |    3=20
 mm/vmscan.c                                       |   18 -----
 net/bluetooth/l2cap_core.c                        |    4 -
 net/ipv6/netfilter.c                              |    6 +
 net/netfilter/nfnetlink.c                         |    8 +-
 sound/pci/hda/patch_analog.c                      |    1=20
 sound/pci/hda/patch_realtek.c                     |   10 +--
 86 files changed, 619 insertions(+), 295 deletions(-)

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/r=
esume

Alex Deucher (4):
      drm/radeon: fix register typo on si
      drm/radeon: handle non-VGA class pci devices with ATRM
      drm/radeon/pm: don't allow debugfs/sysfs access when PX card is off (=
v2)
      drm/radeon/dpm: resume fixes for some systems

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Ben Hutchings (2):
      Staging: speakup: Move pasting into a work item
      Staging: speakup: Update __speakup_paste_selection() tty (ab)usage to=
 match vt

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Bibek Basu (1):
      cpufreq: remove race while accessing cur_policy

Bj=F8rn Mork (1):
      usb: cdc-wdm: export cdc-wdm uapi header

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from execbu=
ffer

Christian K=F6nig (3):
      drm/radeon: also try GART for CPU accessed buffers
      drm/radeon: avoid crash if VM command submission isn't available
      drm/radeon: use the CP DMA on CIK

David Woodhouse (1):
      iommu/vt-d: Fix missing IOTLB flush in intel_iommu_unmap()

Denys Fedoryshchenko (1):
      netfilter: nfnetlink: Fix use after free when it fails to process bat=
ch

Dirk Brandewie (4):
      intel_pstate: remove unneeded sample buffers
      intel_pstate: Remove C0 tracking
      intel_pstate: Correct rounding in busy calculation
      intel_pstate: add sample time scaling

Doug Smythies (1):
      intel_pstate: Improve initial busy calculation

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (3):
      Revert "revert "mm: vmscan: do not swap anon pages just because free+=
file is low""
      USB: cdc-wdm: properly include types.h
      Linux 3.14.7

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Ian Abbott (1):
      staging: comedi: ni_daq_700: add mux settling delay

Imre Deak (2):
      drm/i915: add unregister callback to connector
      drm/i915: dp: fix order of dp aux i2c device cleanup

Jean Delvare (2):
      hwmon: (ntc_thermistor) Fix dependencies
      hwmon: (ntc_thermistor) Fix OF device ID mapping

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Joe Lawrence (1):
      SCSI: scsi_transport_sas: move bsg destructor into sas_rphy_remove

Johan Hovold (1):
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Johannes Berg (1):
      Documentation: fix DOCBOOKS=3D... building

Juri Lelli (1):
      sched/deadline: Restrict user params max value to 2^63 ns

Kirill Tkhai (1):
      sched/dl: Fix race in dl_task_timer()

Lai Jiangshan (1):
      sched: Fix hotplug vs. set_cpus_allowed_ptr()

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_=
m5 on all OMAP3 platforms

Li Zefan (1):
      sched/deadline: Fix memory leak

Lucas Stach (1):
      cpufreq: cpu0: drop wrong devm usage

Markos Chandras (1):
      MIPS: Fix typo when reporting cache and ftlb errors for ImgTec cores

Martin K. Petersen (1):
      libata: Blacklist queued trim for Crucial M500

Mathias Nyman (2):
      xhci: delete endpoints from bandwidth list before freeing whole device
      usb: pci-quirks: Prevent Sony VAIO t-series from switching usb ports

Michael Kerrisk (1):
      sched: Make sched_setattr() correctly return -EFBIG

Michael Welling (1):
      gpio: mcp23s08: Bug fix of SPI device tree registration.

Mike Snitzer (1):
      dm thin: add 'no_space_timeout' dm-thin-pool module param

Ming Lei (1):
      virtio_blk: fix race between start and stop queue

Naoya Horiguchi (2):
      mm/memory-failure.c: fix memory leak by race between poison and unpoi=
son
      mm: add !pte_present() check on existing hugetlb_entry callbacks

NeilBrown (2):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "res=
ync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

Nicholas Bellinger (2):
      iser-target: Add missing target_put_sess_cmd for ImmedateData failure
      target: Fix alua_access_state attribute OOPs for un-configured devices

Peter Ujfalusi (1):
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM

Peter Zijlstra (4):
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix race in removing an event
      sched: Disallow sched_attr::sched_policy < 0
      sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE

Rabin Vincent (1):
      ARM: 8064/1: fix v7-M signal return

Richard Weinberger (1):
      sched: Fix sched_policy < 0 comparison

Roger Quadros (1):
      ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards

Roland Dreier (1):
      iscsi-target: Fix wrong buffer / buffer overrun in iscsi_change_param=
_value()

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Samuel Ortiz (1):
      Bluetooth: Fix L2CAP LE debugfs entries permissions

Santosh Shilimkar (1):
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Sean MacLennan (1):
      staging: r8192e_pci: fix htons error

Sebastian Ott (1):
      percpu-refcount: fix usage of this_cpu_ops

Sergey Popovich (1):
      netfilter: Fix potential use after free in ip6_route_me_harder()

Stefan Richter (1):
      firewire: revert to 4 GB RDMA, fix protocols using Memory Space

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Takashi Iwai (2):
      ALSA: hda/analog - Fix silent output on ASUS A8JN
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Gleixner (1):
      sched: Sanitize irq accounting madness


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmLOPAAoJEDjbvchgkmk+NLMQAK0HOXe3orBKG3lfIyJgVqYH
Duxn1lRkWTQuYTy3zFvU8JwOWnpflBWge6wyDehRhNQ3JUr9xvBr2xpWW5ACMPiW
bmIniSxy0gW5+ICnRjG2ef9Q5mimnxtRg3V2BbHcom86A+pf2xzs2GPi3YLPLLQ5
WzI4uYc7YIGPM/BD+INC2VK3fD3wdCn6kVZmL3jxDNdtC4KznDVTCd68FcZTACiB
l/v4ipxhZFATaS8HTH3JKlBthzz6F9/0N/bfkWI0Ncqr/SK36EGbCinVnQjHZHHr
0xUvAINsfb/WMDaKL4k03V9MVR3zmJUU/d8mJxwLmPSbVEtA5RK6oLqpV1NGhERg
oAFdsx2MqZmlTq7oHx4hP6JFfuIkPfz2QFc6MSrZZz1sU5fUDM4iGKjY1XvQkf/a
kOn/SrogWNMVdK9kJ8/jTktBbYVC1RV99ZNPCt/ocsx0lriq2qTz7ev6pQARfk5Y
v+zrSyaSiNIwfz8EVze9yf+a/aAy/028AG9/BNbXgshjO3SPMvoW3NKqALiH0/oW
Q2ctOK6YlUzyUISKXiRgNC2C7+NYyYofAzWqSckuVl++nATLV5dtbFHrWOiMSV+B
tc5slh9terkgGhsoZoA/bF/NoZIxg6zfc8SPPP5Y+HTo4OU6jnHauLwsOFuXCM4N
HlYMrtSY2D8LfdGxw7G+
=YBL6
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
