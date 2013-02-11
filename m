Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab3BKRqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:46:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62814 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab3BKRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:46:19 -0500
Date: Mon, 11 Feb 2013 09:46:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.63
Message-ID: <20130211174616.GA22940@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.63 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/x86/ia32/ia32entry.S               |    4=20
 drivers/gpu/drm/radeon/evergreen.c      |    2=20
 drivers/gpu/drm/radeon/radeon_combios.c |    8=20
 drivers/gpu/drm/radeon/radeon_display.c |    4=20
 drivers/rtc/rtc-isl1208.c               |    3=20
 drivers/usb/host/ehci-sched.c           |    2=20
 drivers/usb/host/xhci-ring.c            |    6=20
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
 18 files changed, 158 insertions(+), 339 deletions(-)

Alan Stern (2):
      USB: EHCI: fix bug in scheduling periodic split transfers
      USB: XHCI: fix memory leak of URB-private data

Alex Deucher (2):
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout
      drm/radeon: add quirk for RV100 board

Bj=F8rn Mork (1):
      USB: option: add Changhong CH690

Daniele Palmas (2):
      USB: option: add support for Telit LE920
      USB: qcserial: add Telit Gobi QDL device

Greg Kroah-Hartman (1):
      Linux 3.0.63

Jan Beulich (1):
      x86-64: Replace left over sti/cli in ia32 audit exit code

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq h=
andler

Petr Kub=E1nek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Sarah Sharp (1):
      xhci: Fix isoc TD encoding.

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

Vyacheslav Dubeyko (1):
      nilfs2: fix fix very long mount time issue

fangxiaozhi (2):
      USB: storage: Define a new macro for USB storage match rules
      USB: storage: optimize to match the Huawei USB storage devices and su=
pport new switch command

liu chuansheng (1):
      drm/radeon: Calling object_unrefer() when creating fb failure


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRGS5oAAoJEDjbvchgkmk+o3gP/3To4OPasuK74QQmdTAgJLEO
vMhqoZ3g3m9ijNeWO8Au4kVNvGN3sGSQTwndEPj3GqNFYkVKwmW4Dy37z47MSAq0
sOuHmCdaPppar3lnjcOjmHXBrvS7A+0yjrJ51I8DHKsZxk90l/vGaq7YmesASdwf
FLXUJH5rhyvXXo9GjaOLIOxXB5i3aN3hFvDP0BCQXkecH9mCe/s3fblZ3cBO4Frj
KSf+rMG1fhsPSY/16h+fAf4o2q5VXYo15ROMS/K+wCpofu0LYqXDqiF/fsK+HT66
ZxKjXY3r5UHei9kSddiwu+Tl9t7esaPtdj5jiBgrVNg1pQoLds3muMFW4iy9qqMt
Fbzi936ETsGAl+pZbPEx0Z7/Y3FhogTsENfw2dw1lbbiKq8k4ViSnEgqVy69xiSx
Jm4a3ToQ7rb8xOFE2ZdKvE2jBRytdBOZchl6d4+RnWYAAPujAHRM2g0eeETItNMm
OiUJkLI6a3cVmc0Y/x+FVyuJIFufffNLmThz/UyGYdXMuOxHxN/oPFPMz55Iipug
W54nyrrj4hqHQZqxAJBEwDu4hcdonKwZQYWydWxrPYj4YppS55phVIkVyuKFRZzd
jxNfiNc+dEGG2PW7uzHu/htUaHUByv4njDsJAz0iqBVXQRvP3L52zfJjrn9cf8xs
ZgNrRuMXE4T/lfEbzNOa
=yH/z
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
