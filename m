Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaFKTsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:48:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaFKTsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:48:21 -0400
Date: Wed, 11 Jun 2014 12:52:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.43
Message-ID: <20140611195210.GA3092@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.43 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/DocBook/media/Makefile            |    2=20
 Documentation/sysctl/kernel.txt                 |   26 +++
 Makefile                                        |    2=20
 arch/arm/include/asm/uaccess.h                  |    3=20
 arch/arm/kernel/perf_event.c                    |   11 +
 arch/arm/mach-imx/devices/platform-ipu-core.c   |    2=20
 arch/arm/mach-omap2/cclock3xxx_data.c           |    3=20
 arch/arm/mach-omap2/cpuidle44xx.c               |   25 +++
 arch/x86/kernel/cpu/perf_event.c                |   12 +
 drivers/gpu/drm/i915/i915_gem_execbuffer.c      |   54 ++++----
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c |    2=20
 drivers/gpu/drm/radeon/radeon_bios.c            |   14 ++
 drivers/gpu/drm/radeon/radeon_object.c          |   38 +++--
 drivers/hwmon/Kconfig                           |    2=20
 drivers/hwmon/ntc_thermistor.c                  |   15 +-
 drivers/infiniband/ulp/isert/ib_isert.c         |    2=20
 drivers/md/dm-cache-target.c                    |    2=20
 drivers/md/md.c                                 |    5=20
 drivers/staging/comedi/drivers/ni_daq_700.c     |    2=20
 drivers/staging/speakup/main.c                  |    1=20
 drivers/staging/speakup/selection.c             |   38 ++++-
 drivers/staging/speakup/speakup.h               |    1=20
 drivers/usb/core/driver.c                       |    9 -
 drivers/usb/core/hub.c                          |   15 +-
 drivers/usb/host/xhci-mem.c                     |   20 +--
 drivers/usb/serial/ftdi_sio.c                   |    2=20
 drivers/usb/serial/ftdi_sio_ids.h               |    5=20
 drivers/usb/serial/io_ti.c                      |    2=20
 drivers/usb/serial/io_usbvend.h                 |    2=20
 drivers/usb/serial/option.c                     |    2=20
 include/linux/perf_event.h                      |    7 +
 include/uapi/linux/usb/Kbuild                   |    1=20
 include/uapi/linux/usb/cdc-wdm.h                |    2=20
 kernel/cpu.c                                    |    6=20
 kernel/events/core.c                            |  157 +++++++++++++++++++=
-----
 kernel/sched/core.c                             |    1=20
 kernel/sched/cpupri.c                           |    3=20
 kernel/sched/cputime.c                          |   32 ++--
 kernel/sysctl.c                                 |   10 +
 mm/memory-failure.c                             |    2=20
 mm/rmap.c                                       |    3=20
 net/ipv6/netfilter.c                            |    6=20
 sound/pci/hda/patch_realtek.c                   |   10 -
 tools/perf/util/evsel.c                         |    2=20
 44 files changed, 421 insertions(+), 140 deletions(-)

Alan Stern (1):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/r=
esume

Alex Deucher (1):
      drm/radeon: handle non-VGA class pci devices with ATRM

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
      mm: rmap: fix use-after-free in __put_anon_vma

Ben Hutchings (1):
      Staging: speakup: Move pasting into a work item

Ben Skeggs (1):
      drm/gf119-/disp: fix nasty bug which can clobber SOR0's clock setup

Bj=F8rn Mork (1):
      usb: cdc-wdm: export cdc-wdm uapi header

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from execbu=
ffer

Christian K=F6nig (1):
      drm/radeon: also try GART for CPU accessed buffers

Dave Hansen (1):
      perf: Drop sample rate when sampling is too slow

David Ahern (1):
      perf evsel: Fix printing of perf_event_paranoid message

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID

Greg Kroah-Hartman (2):
      USB: cdc-wdm: properly include types.h
      Linux 3.10.43

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Ian Abbott (1):
      staging: comedi: ni_daq_700: add mux settling delay

Jean Delvare (2):
      hwmon: (ntc_thermistor) Fix dependencies
      hwmon: (ntc_thermistor) Fix OF device ID mapping

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add

Johan Hovold (1):
      USB: io_ti: fix firmware download on big-endian machines (part 2)

Johannes Berg (1):
      Documentation: fix DOCBOOKS=3D... building

Knut Petersen (1):
      perf: Enforce 1 as lower limit for perf_event_max_sample_rate

Lai Jiangshan (1):
      sched: Fix hotplug vs. set_cpus_allowed_ptr()

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_=
m5 on all OMAP3 platforms

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole device

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoi=
son

NeilBrown (2):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "res=
ync".
      md: always set MD_RECOVERY_INTR when interrupting a reshape thread.

Nicholas Bellinger (1):
      iser-target: Add missing target_put_sess_cmd for ImmedateData failure

Peter Zijlstra (2):
      perf: Limit perf_event_attr::sample_period to 63 bits
      perf: Fix race in removing an event

Ronan Marquet (1):
      ALSA: hda/realtek - Correction of fixup codes for PB V7900 laptop

Santosh Shilimkar (1):
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Sergey Popovich (1):
      netfilter: Fix potential use after free in ip6_route_me_harder()

Stephane Eranian (1):
      perf: Fix interrupt handler timing harness

Steven Rostedt (Red Hat) (1):
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

Takashi Iwai (1):
      ALSA: hda/realtek - Fix COEF widget NID for ALC260 replacer fixup

Thomas Gleixner (1):
      sched: Sanitize irq accounting madness

Will Deacon (1):
      ARM: perf: hook up perf_sample_event_took around pmu irq handling


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmLNqAAoJEDjbvchgkmk+tAgP/37i4x+EsiI3nUcsGpUEpwpl
OJdvZ2ckyb5Q6JHddUsalydldV7/UsfJ24IFTYcoKmA4xcyejOqiBwH8L0uf8BdJ
9eHF2Vok7FGLRUKdaZu2eqk8qBk+/3UYDHMFI8ysOHynK8pQ4Oc4Cxek9idrRGfe
fPWLcpnNGOA8vzZcUe0NeJmUOfJhSnwzztR3I1ePjGuHd1AA6n2ccKWn0yTmYf6P
6Z6uU58+dX6IKDTirGOZBlAv0Yaa7orXklPgLeEhQj5YNhUbDsa+viIfz44X9S/O
T87ahsrHDY8SMkAnjXj7gxbK4w+LRNzVv2QFM3lJFirzntslpHnusmfD218//+SQ
jJzuCscFx8iIdoRi8a6w6cAKnxKYvR6QzxQMm25nZL75Y2Rt6mJYCo5c67wyM10E
yq/ziT+51VQh/M7BlaJJgP8WhYZpiSu9dfTELfqR6ITOfmNMTEbbEtRdqcb8QYze
yqdWyqhvSxiO32629AboELwCMVKZVh5wG8y8MqWoaWjnv2FjPJN+6QzVQyN3ILSA
zpJwaSxDNIVTJ5ItPEwF6m+VKOSFXl1Eq+G0jtC64iwx+zLVYjnqAPzpsRCs5uzx
k9JN76BDjgFP3vaE8D2JF9rlDb9CL/j3bXBfgcwrZ96PdkC9x49maBWt9FaRqbsi
8DGqpRYbl6mAvpA3N8xl
=EHle
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
