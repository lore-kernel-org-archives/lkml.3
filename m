Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3JAUDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 16:03:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3JAUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 16:03:40 -0400
Date: Tue, 1 Oct 2013 13:03:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.3
Message-ID: <20131001200350.GA27960@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.3 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/arm/mach-omap2/cclock44xx_data.c              |    2=20
 block/cfq-iosched.c                                |    2=20
 drivers/gpu/drm/ast/ast_drv.h                      |    2=20
 drivers/gpu/drm/drm_crtc.c                         |   18 -
 drivers/gpu/drm/i915/i915_drv.h                    |    7=20
 drivers/gpu/drm/i915/i915_irq.c                    |   85 ++++-
 drivers/gpu/drm/i915/intel_display.c               |   15=20
 drivers/gpu/drm/i915/intel_opregion.c              |    2=20
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |   15=20
 drivers/gpu/drm/radeon/atombios_dp.c               |    6=20
 drivers/gpu/drm/radeon/atombios_encoders.c         |    8=20
 drivers/gpu/drm/radeon/atombios_i2c.c              |    4=20
 drivers/gpu/drm/radeon/btc_dpm.c                   |    6=20
 drivers/gpu/drm/radeon/cik.c                       |   84 ++++-
 drivers/gpu/drm/radeon/cikd.h                      |    4=20
 drivers/gpu/drm/radeon/evergreen.c                 |   34 +-
 drivers/gpu/drm/radeon/evergreend.h                |    4=20
 drivers/gpu/drm/radeon/ni.c                        |    9=20
 drivers/gpu/drm/radeon/ni_dpm.c                    |    6=20
 drivers/gpu/drm/radeon/ppsmc.h                     |    2=20
 drivers/gpu/drm/radeon/r600.c                      |   14=20
 drivers/gpu/drm/radeon/radeon_asic.c               |    2=20
 drivers/gpu/drm/radeon/radeon_asic.h               |    1=20
 drivers/gpu/drm/radeon/radeon_atombios.c           |   13=20
 drivers/gpu/drm/radeon/radeon_connectors.c         |   34 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |    8=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |   10=20
 drivers/gpu/drm/radeon/radeon_kms.c                |    3=20
 drivers/gpu/drm/radeon/rs400.c                     |    9=20
 drivers/gpu/drm/radeon/rs780_dpm.c                 |   13=20
 drivers/gpu/drm/radeon/rv770.c                     |    9=20
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   20 -
 drivers/gpu/drm/radeon/si.c                        |  138 +++++---
 drivers/gpu/drm/radeon/si_dpm.c                    |    6=20
 drivers/gpu/drm/radeon/sid.h                       |    4=20
 drivers/gpu/drm/radeon/trinity_dpm.c               |    2=20
 drivers/gpu/drm/radeon/trinity_dpm.h               |    1=20
 drivers/gpu/drm/radeon/trinity_smc.c               |    8=20
 drivers/gpu/drm/ttm/ttm_tt.c                       |    2=20
 drivers/hid/hid-core.c                             |   74 +++-
 drivers/hid/hid-input.c                            |   11=20
 drivers/hid/hid-lenovo-tpkbd.c                     |   25 +
 drivers/hid/hid-lg2ff.c                            |   19 -
 drivers/hid/hid-lg3ff.c                            |   29 -
 drivers/hid/hid-lg4ff.c                            |   20 -
 drivers/hid/hid-lgff.c                             |   17 -
 drivers/hid/hid-logitech-dj.c                      |   10=20
 drivers/hid/hid-multitouch.c                       |   26 -
 drivers/hid/hid-sony.c                             |    4=20
 drivers/hid/hid-steelseries.c                      |    5=20
 drivers/hid/hid-zpff.c                             |   18 -
 drivers/net/ethernet/broadcom/bgmac.c              |    2=20
 drivers/net/ethernet/broadcom/bgmac.h              |    2=20
 drivers/net/ethernet/broadcom/tg3.c                |   19 +
 drivers/net/ethernet/marvell/skge.c                |    5=20
 drivers/net/usb/cdc_ether.c                        |    5=20
 drivers/net/wireless/cw1200/cw1200_spi.c           |   28 +
 drivers/net/wireless/cw1200/fwio.c                 |    2=20
 drivers/net/wireless/cw1200/hwbus.h                |    1=20
 drivers/net/wireless/cw1200/hwio.c                 |   15=20
 drivers/net/wireless/rt2x00/rt2800lib.c            |   18 -
 drivers/pci/pci-acpi.c                             |    6=20
 drivers/usb/gadget/dummy_hcd.c                     |    7=20
 fs/bio-integrity.c                                 |    2=20
 fs/cifs/dir.c                                      |    1=20
 fs/udf/super.c                                     |  342 ++++++++++++----=
-----
 include/drm/drm_pciids.h                           |   21 +
 include/linux/hid.h                                |    4=20
 include/linux/timex.h                              |    1=20
 include/uapi/drm/radeon_drm.h                      |    2=20
 kernel/audit.c                                     |    5=20
 kernel/sched/cputime.c                             |   19 -
 kernel/sched/fair.c                                |   14=20
 kernel/time/ntp.c                                  |    6=20
 kernel/time/timekeeping.c                          |    2=20
 mm/swap.c                                          |   77 +++-
 net/netfilter/ipset/ip_set_hash_gen.h              |   28 -
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   26 +
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   41 +-
 net/sunrpc/auth_gss/gss_rpc_xdr.h                  |    5=20
 81 files changed, 1070 insertions(+), 508 deletions(-)

Alan Stern (1):
      usb: gadget: fix a bug and a WARN_ON in dummy-hcd

Alex Deucher (20):
      drm/radeon: fix LCD record parsing
      drm/radeon/dpm: add reclocking quirk for ASUS K70AF
      drm/radeon: fix endian bugs in hw i2c atom routines
      drm/radeon: fill in gpu_init for berlin GPU cores
      drm/radeon: update line buffer allocation for dce8
      drm/radeon: fix init ordering for r600+
      drm/radeon/cik: update gpu_init for an additional berlin gpu
      drm/radeon: add berlin pci ids
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: update line buffer allocation for dce6
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects
      drm/radeon/dpm: make sure dc performance level limits are valid (BTC-=
SI) (v2)
      drm/radeon: add some additional berlin pci ids
      drm/radeon/r6xx: add a stubbed out set_uvd_clocks callback
      drm/radeon/atom: workaround vbios bug in transmitter table on rs880 (=
v2)
      drm/radeon/dpm: handle bapm on trinity
      drm/radeon/dpm: fix fallback for empty UVD clocks
      drm/radeon/dpm/rs780: don't enable sclk scaling if not required
      drm/radeon: fix panel scaling with eDP and LVDS bridges

Anatol Pomozov (1):
      cfq: explicitly use 64bit divide operation for 64bit arguments

Ben Skeggs (1):
      drm/ttm: fix the tt_populated check in ttm_tt_destroy()

Benjamin Tissoires (3):
      HID: validate feature and input report details
      HID: multitouch: validate indexes details
      HID: lenovo-tpkbd: fix leak if tpkbd_probe_tp fails

Bjorn Helgaas (1):
      bio-integrity: Fix use of bs->bio_integrity_pool after free

Christian K=C3=B6nig (2):
      drm/radeon: enable UVD interrupts on CIK
      drm/radeon: avoid UVD corruptions on AGP cards

Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point =
to invalid ones

Daniel Vetter (3):
      drm/i915: fix hpd work vs. flush_work in the pageflip code deadlock
      drm/i915: fix gpu hang vs. flip stall deadlocks
      drm/i915: fix wait_for_pending_flips vs gpu hang deadlock

Dave Airlie (1):
      drm/ast: fix the ast open key function

David Herrmann (1):
      drm: fix DRM_IOCTL_MODE_GETFB handle-leak

Emil Velikov (1):
      drm/nv50/disp: prevent false output detection on the original nv50

Fabio Porcedda (1):
      net: usb: cdc_ether: Use wwan interface for Telit modules

Greg Kroah-Hartman (1):
      Linux 3.11.3

J. Bruce Fields (4):
      rpc: clean up decoding of gssproxy linux creds
      rpc: comment on linux_cred encoding, treat all as unsigned
      rpc: fix huge kmalloc's in gss-proxy
      rpc: let xdr layer allocate gssproxy receieve pages

Jan Kara (2):
      udf: Standardize return values in mount sequence
      udf: Refuse RW mount of the filesystem instead of making it RO

Jani Nikula (2):
      drm/i915: try not to lose backlight CBLV precision
      drm/i915: do not update cursor in crtc mode set

John Stultz (1):
      timekeeping: Fix HRTICK related deadlock from ntp lock changes

Kees Cook (7):
      HID: provide a helper for validating hid reports
      HID: LG: validate HID output report details
      HID: zeroplus: validate output report details
      HID: steelseries: validate output report details
      HID: sony: validate HID output report details
      HID: lenovo-tpkbd: validate output report details
      HID: logitech-dj: validate output report details

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP

Konstantin Khlebnikov (1):
      audit: fix endless wait in audit_log_start()

Miklos Szeredi (1):
      cifs: fix filp leak in cifs_atomic_open()

Mikulas Patocka (1):
      skge: fix broken driver

Nithin Sujir (2):
      tg3: Don't turn off led on 5719 serdes port 0
      tg3: Expand led off fix to include 5720

Oliver Smith (1):
      netfilter: ipset: Fix serious failure in CIDR tracking

Rafael J. Wysocki (1):
      PCI / ACPI / PM: Clear pme_poll for devices in D3cold on wakeup

Rafa=C5=82 Mi=C5=82ecki (1):
      bgmac: fix internal switch initialization

Sergey Senozhatsky (1):
      radeon kms: fix uninitialised hotplug work usage in r100_irq_process()

Solomon Peachy (2):
      cw1200: Prevent a lock-related hang in the cw1200_spi driver
      cw1200: Don't perform SPI transfers in interrupt context

Stanislaw Gruszka (3):
      rt2800: change initialization sequence to fix system freeze
      rt2800: fix wrong TX power compensation
      sched/cputime: Do not scale when utime =3D=3D 0

Tom Stellard (1):
      drm/radeon/si: Add support for CP DMA to CS checker for compute v2

Tony Lindgren (1):
      ARM: OMAP4: Fix clock_get error for GPMC during boot

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Don't enable the cursor on a disable pipe


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSyqmAAoJEDjbvchgkmk+tvQQAKrEe7/O/tRap8dBAlKRrA/n
84F/JzrNIsYu2F74mbeNWvO7D5zfUwEr1RhnbCjUACURy0IpJ7CWFg/nQmVqeUvB
+w13lQ1IeEMe+bWKsXPHqR1QQf8XugGYPpaft66YKuijn6PMGDXAN6wDYEC0O4DA
ypblE4rv45pTMkz137N+2vepXFwLAQGUhiRFU1juRQ+dwWX+VWElCwAIZq0zEmHA
XBD3j49WTffggtCkcRQZh/XtjbzwMgu8IWCmUDnQZQmOUOoZLWcVjv8A8D9w3ZhG
WdkmkI68T8WRmyQAZVd03vhDDCuNOY/3gEYk7nkBX0plLgjB4JkSR69EbjBvQcmq
l5jbJ/9/9W4KjTIyPR++GaPLuXC0aA+iOiewWonmXHqXQRTqX903yrX+PCOy9gCb
CCdkzmI6Kcn3fFvoo5r1ueboVtYgf1RgPms3HZxACPGDpAj+esEuOqakJvkYU987
jZZioXCcBCiBzqfSURcGaIDqDQBpYNJVHS20tzANNAOl3tEZlJMC6I98xuIE1ace
kaH/nT71vignpCIVnALb9eyqYv49ugx9iobACHPJAkJJXXAsxuDw9DShbJuRibVM
CAVzajHbdlLb6QGS0uqIoNBMnVmXJW1lwkbqUJlIJSbKppJFJNzPp5uwV6VmhdTC
flDRbHoJO4pn/yNoWliM
=IeOx
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
