Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab3BKRpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:45:43 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:42406 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396Ab3BKRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:45:39 -0500
Date: Mon, 11 Feb 2013 09:45:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.30
Message-ID: <20130211174536.GA17267@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.30 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/x86/ia32/ia32entry.S               |    4=20
 drivers/gpu/drm/radeon/evergreen.c      |   10=20
 drivers/gpu/drm/radeon/radeon_combios.c |    8=20
 drivers/gpu/drm/radeon/radeon_display.c |    4=20
 drivers/gpu/drm/radeon/radeon_ring.c    |    3=20
 drivers/gpu/drm/radeon/reg_srcs/cayman  |    1=20
 drivers/rtc/rtc-isl1208.c               |    3=20
 drivers/usb/core/hub.c                  |   70 +++++-
 drivers/usb/host/ehci-hub.c             |    6=20
 drivers/usb/host/ehci-sched.c           |    2=20
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
 include/linux/usb/ch9.h                 |    6=20
 kernel/sched/rt.c                       |    2=20
 lib/digsig.c                            |    2=20
 26 files changed, 241 insertions(+), 362 deletions(-)

Alan Stern (3):
      USB: EHCI: fix timer bug affecting port resume
      USB: EHCI: fix bug in scheduling periodic split transfers
      USB: XHCI: fix memory leak of URB-private data

Alex Deucher (4):
      drm/radeon/evergreen+: wait for the MC to settle after MC blackout
      drm/radeon: add WAIT_UNTIL to the non-VM safe regs list for cayman/TN
      drm/radeon: add quirk for RV100 board
      drm/radeon: prevent crash in the ring space allocation

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
      Linux 3.4.30

Jan Beulich (1):
      x86-64: Replace left over sti/cli in ia32 audit exit code

Jan Luebbe (1):
      drivers/rtc/rtc-isl1208.c: call rtc_update_irq() from the alarm irq h=
andler

Lan Tianyu (1):
      usb: Using correct way to clear usb3.0 device's remote wakeup feature.

Nickolai Zeldovich (1):
      drivers: xhci: fix incorrect bit test

Petr Kub=E1nek (1):
      USB: ftdi_sio: add Zolix FTDI PID

Sarah Sharp (2):
      xhci: Fix isoc TD encoding.
      xhci: Fix TD size for isochronous URBs.

Shawn Bohrer (1):
      sched/rt: Use root_domain of rt_rq not current processor

Sven Killig (1):
      USB: ftdi_sio: add PID/VID entries for ELV WS 300 PC II

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


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRGS5AAAoJEDjbvchgkmk+yCsQAJ0AzoR3H5UaU4nU77LFpiCs
UZwtRl4jgIn7/kkkZWv8kQajbD7W2naN5upFU0l+QJbEP7lhLa1A1uPBPr7pfbeG
tRLmqACTVgCSUiH92iRGHoLWodxc3JRM2GMu0+O64IHgcJVegyZxksFueOZkmo2l
lFvWA8YP23MSieaEtFWlWnZLNWyjtbA5eQhRKzKaKsQCo50aQhn5uqfv+fTCQre4
R4P5i+gj/F4MtTEbJTfgLMsNgBWsq57WEhvqT3LD3WcjRco2dsNDOrkBi+z9YCvQ
QnVbFbNpmkD2/z6v1+5JlHdLun7zTrfW3X2XpFx/2mNaZd3QkBVywrdE/POamlYq
QgW3x3FmukfQzx/4BZXj3CMZKapT8rXuhuTPRccPchRG6azcx3IA6xni1U2bYOJM
07eQa6nj1p21DsD3eVdpLzz6mKCwgAaJXbICS+ODbc0gVzUQjBA1HGLcnTq1sr6y
JrR++vY91Hdn4QebZuq/6y2mvoxkw7Fi56YwXgUBkf6jzR3vgrx8LJ6+G4E9Cmvc
GBuV7N3vEBhiYRIRWSdKbA+KH9kWyBzKyT00sekebpqYbuohAbtR86m7A1cv4gtm
6RbDZHYi7GJ0oxykeQNgQ4CHZmwGna07GmtJzExTfb+2clUCe81h/97JFaDm/IvV
3lXhkwZ6VkNq0Lj4lvsf
=r1fK
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
