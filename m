Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3BKRo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:44:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:50420 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab3BKRo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:44:57 -0500
Date: Mon, 11 Feb 2013 09:44:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.7.7
Message-ID: <20130211174454.GB11640@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.7.7 kernel.

All users of the 3.7 kernel series must upgrade.

The updated 3.7.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.7.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/powerpc/mm/hash_low_64.S           |   62 +++---
 arch/x86/ia32/ia32entry.S               |    4=20
 drivers/gpu/drm/radeon/evergreen.c      |   27 ++
 drivers/gpu/drm/radeon/r600.c           |    7=20
 drivers/gpu/drm/radeon/radeon_combios.c |    8=20
 drivers/gpu/drm/radeon/radeon_display.c |    4=20
 drivers/gpu/drm/radeon/radeon_ring.c    |    3=20
 drivers/gpu/drm/radeon/reg_srcs/cayman  |    1=20
 drivers/mtd/nand/davinci_nand.c         |    2=20
 drivers/rtc/rtc-isl1208.c               |    3=20
 drivers/rtc/rtc-pl031.c                 |    8=20
 drivers/usb/core/hub.c                  |   70 +++++-
 drivers/usb/host/ehci-hub.c             |    6=20
 drivers/usb/host/ehci-q.c               |   50 ++--
 drivers/usb/host/ehci-sched.c           |    4=20
 drivers/usb/host/ehci-timer.c           |   29 +-
 drivers/usb/host/pci-quirks.c           |    1=20
 drivers/usb/host/xhci-ring.c            |   13 -
 drivers/usb/serial/ftdi_sio.c           |    2=20
 drivers/usb/serial/ftdi_sio_ids.h       |    9=20
 drivers/usb/serial/option.c             |   13 +
 drivers/usb/serial/qcserial.c           |    1=20
 drivers/usb/storage/initializers.c      |   76 +++++++
 drivers/usb/storage/initializers.h      |    4=20
 drivers/usb/storage/unusual_devs.h      |  329 ---------------------------=
-----
 drivers/usb/storage/usb.c               |   12 +
 drivers/usb/storage/usual-tables.c      |   15 +
 fs/nilfs2/ioctl.c                       |    5=20
 include/uapi/linux/usb/ch9.h            |    6=20
 kernel/sched/rt.c                       |    2=20
 lib/digsig.c                            |    2=20
 mm/hugetlb.c                            |    1=20
 mm/migrate.c                            |    4=20
 34 files changed, 351 insertions(+), 434 deletions(-)

Alan Stern (6):
      USB: EHCI: remove ASS/PSS polling timeout
      USB: EHCI: unlink one async QH at a time
      USB: EHCI: fix timer bug affecting port resume
      USB: EHCI: fix bug in scheduling periodic split transfers
      USB: XHCI: fix memory leak of URB-private data
      USB: EHCI: fix for leaking isochronous data

Alex Deucher (5):
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout
      drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
      drm/radeon: add quirk for RV100 board
      drm/radeon: fix backend map setup on 1 RB sumo boards
      drm/radeon: prevent crash in the ring space allocation

Aneesh Kumar K.V (1):
      powerpc/mm: Fix hash computation function

Bj=F8rn Mork (1):
      USB: option: add Changhong CH690

Christopher Staite (1):
      drm/radeon: fix MC blackout on evergreen+

Daniele Palmas (2):
      USB: option: add support for Telit LE920
      USB: qcserial: add Telit Gobi QDL device

David Moore (1):
      usb: Prevent dead ports when xhci is not enabled

Greg Kroah-Hartman (1):
      Linux 3.7.7

Haojian Zhuang (1):
      drivers/rtc/rtc-pl031.c: fix the missing operation on enable

Jan Beulich (1):
      x86-64: Replace left over sti/cli in ia32 audit exit code

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq h=
andler

Lan Tianyu (1):
      usb: Using correct way to clear usb3.0 device's remote wakeup feature.

Mikko Tiihonen (1):
      drm/radeon: protect against div by 0 in backend setup

Nickolai Zeldovich (1):
      drivers: xhci: fix incorrect bit test

Petr Kub=E1nek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Sarah Sharp (2):
      xhci: Fix isoc TD encoding.
      xhci: Fix TD size for isochronous URBs.

Sergei Shtylyov (1):
      mtd: davinci_nand: fix modular build with CONFIG_OF=3Dy

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

Tony Lu (1):
      mm/hugetlb: set PTE as huge in hugetlb_change_protection and remove_m=
igration_pte

Vyacheslav Dubeyko (1):
      nilfs2: fix fix very long mount time issue

YOSHIFUJI Hideaki (1):
      digsig: Fix memory leakage in digsig_verify_rsa()

fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
      USB: storage: optimize to match the Huawei USB storage devices and su=
pport new switch command

liu chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure


--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRGS4WAAoJEDjbvchgkmk+ojkQAKNiA3twaYJQFY+6o27I2iik
vydtf2EW51RStvNOnfRp52PCg/6Ke/96EKXJq68JI4xpnENU4CnVf+rteGCuHitx
725rO/U9sAjG+KfXDylvQEqLNEbIRQ34DhVrM8i4c4mmgnCknJ1WXOKI8QXI7Dq6
mGIId8QeLJO/QLvZgwEPrFVfQXKFr/c5W5F1MjW6+MNro2cIq5ooyg1346+6sYCq
hPFcLvchG/0hx+kBOptZGEdLVINwHJtk5F71q1Fe0mbgE+ScFF+hXwcf5lCszLnf
Xy7k9aR+Yzo8lkBWsMHQzCW5TugHFjPK8PA70TA7eTstJED0kH55BszpIycdOFyC
1mRhFPLO7vbddfFMWQh1fWd3COtgQrw5KPZIXJiPJG7Q/AAmaEp/RPoCcemptYrw
WWauvnZiqjhj+PMx7IehHTu0xRlGpNCTq0nf3sjdgIqKecuzm8XxMQ9EYhJVVVi9
Dpc6acCAtZf+yrRv7c8G/xQrXh+1h0L0f3JH6W3z6VH31X18qc9hKi/9m03X5u+v
45yZr3bdw5jhWigUxnsFS4neB8/DgOEco94dRuacbB+IAl9BfgxxW3CEPlTBP5il
57TgCuEA4jobRiouIEvba7rV7RYuj9HKTwrhK3GpPz7rXfTGMS0oAR/yLFMX7zEX
g4PnjFXoPhcNJQ8U5FHU
=ELM9
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
