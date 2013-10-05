Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3JEPtr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:49:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3JEPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:49:43 -0400
Date: Sat, 5 Oct 2013 08:47:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.99
Message-ID: <20131005154717.GA1164@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

------------------------------
NOTE!  The 3.0.x kernel series will be moving to End-Of-Life soon,
within a few weeks.  Please move anything that is relying on this kernel
version to the other longterm kernel releases (3.4.x or 3.10.x) as soon
as possible.  If anyone has any questions about this, please let me
know.
------------------------------

I'm announcing the release of the 3.0.99 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                          |    2 +-
 arch/x86/kernel/reboot.c          |   16 ++++++++++++++++
 arch/x86/platform/efi/efi.c       |   11 +++++++----
 drivers/gpu/drm/i915/intel_dp.c   |   13 ++++++++++++-
 drivers/hwmon/applesmc.c          |   19 ++++++++++++++++---
 drivers/md/dm-snap-persistent.c   |    2 +-
 drivers/md/dm-snap.c              |    5 ++---
 drivers/staging/vt6656/main_usb.c |    3 ++-
 drivers/usb/core/devio.c          |   16 ++++++++++++++++
 drivers/usb/host/xhci-ring.c      |   14 ++++++++++++--
 fs/splice.c                       |   35 ++++++++++++++++++++---------------
 include/linux/splice.h            |    8 ++++----
 kernel/relay.c                    |    5 +++--
 kernel/trace/trace.c              |    6 ++++--
 net/core/skbuff.c                 |    3 ++-
 15 files changed, 118 insertions(+), 40 deletions(-)

Eric Dumazet (1):
      splice: fix racy pipe->buffers uses

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Greg Kroah-Hartman (1):
      Linux 3.0.99

Henrik Rydberg (2):
      hwmon: (applesmc) Check key count before proceeding
      hwmon: (applesmc) Silence uninitialized warnings

Jani Nikula (1):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

Malcolm Priestley (1):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Mathias Nyman (1):
      xhci: Fix oops happening after address device timeout

Mikulas Patocka (2):
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSUDSFAAoJEDjbvchgkmk+KbIQALfV9ABB/zEiGzqJQLeWsxjt
oylFV0toh/JWgj+YYxg5EvRqWSAV59BNfACbvP3VLuTn/sONyrLIrKroHfz8I7eM
tGDfJCDv/EdMV/6VAriQlvOva1gxI1ZmQdTDexTfo53fybeQPs+OU9OmOeyBTSvO
CXUhHFNX7ME1UweCsoahxoIZmC9Y+/yoUpl2nLGed0XwRvxrdvxHUJV+t0gUkyXB
onqurN2hMIBd5PPqXqrxKiWP1zbAX2frHnQxDRuHz8CCxpI7jiCkqxHHRKCRhRF9
UBrW6VpMzMYfxFy/ZrrwZmHiKozRnAqe0pHYqVGdcFDTryuQbl2c4pBTnbBGS9oJ
yfEFunhd5akAvLBLg0QmXahQ0B1ZDPpFcBNO5NlMAEtaQf0QNeXnLK1ZQu8o9Zc2
OmQYjvxgDt79oSKkziKgu2ilX/+VipIL8cSRCfmrMiAM3diwRAsEtjaL2b/O/aFz
zXyUnbNAU3lZ6lHJcpUDL4igMiK+KS/ec0jCIarmGJwCidn5R6uerr4VMe5Z9Bzq
xrhH84y7OvHtglat9deg1e9wsXoGBOtZ/PT80/+IqFO2lA+qZqlsUzoWmEAeemNH
S45Av57KsbEQ+Q1vU4VOoieZmhArJtYW0mtgrRwLn39s4YGv3L0qVyQa28K/Vque
j50zbYDVU8F6YrCd0mWe
=/EVY
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
