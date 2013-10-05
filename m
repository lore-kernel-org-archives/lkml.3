Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3JEPts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 11:49:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3JEPtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 11:49:47 -0400
Date: Sat, 5 Oct 2013 08:48:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.65
Message-ID: <20131005154824.GA1286@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.65 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 +-
 arch/x86/kernel/reboot.c               |   16 ++++++++++++++++
 arch/x86/platform/efi/efi.c            |   11 +++++++----
 drivers/gpu/drm/i915/intel_dp.c        |   13 ++++++++++++-
 drivers/gpu/drm/radeon/radeon_device.c |   15 ++++++++++++---
 drivers/hid/hid-lg2ff.c                |   19 +++----------------
 drivers/hid/hid-lg3ff.c                |   29 ++++++-----------------------
 drivers/hid/hid-lg4ff.c                |   20 +-------------------
 drivers/hid/hid-lgff.c                 |   17 ++---------------
 drivers/hwmon/applesmc.c               |   11 ++++++++++-
 drivers/md/dm-snap-persistent.c        |    2 +-
 drivers/md/dm-snap.c                   |    5 ++---
 drivers/staging/vt6656/main_usb.c      |    3 ++-
 drivers/usb/core/devio.c               |   16 ++++++++++++++++
 drivers/usb/host/xhci-hub.c            |    2 +-
 drivers/usb/host/xhci-ring.c           |   24 ++++++++++++++++++++++--
 drivers/usb/host/xhci.c                |   25 +++++--------------------
 drivers/usb/host/xhci.h                |    1 +
 mm/oom_kill.c                          |    8 ++++----
 sound/core/compress_offload.c          |    3 ++-
 20 files changed, 126 insertions(+), 116 deletions(-)

Alex Deucher (1):
      drm/radeon: disable tests/benchmarks if accel is disabled

David Rientjes (1):
      mm, memcg: give exiting processes access to memory reserves

Florian Wolter (1):
      xhci: Fix race between ep halt and URB cancellation

Greg Kroah-Hartman (1):
      Linux 3.4.65

Henrik Rydberg (1):
      hwmon: (applesmc) Check key count before proceeding

Jani Nikula (1):
      drm/i915/dp: increase i2c-over-aux retry interval on AUX DEFER

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Kees Cook (1):
      HID: LG: validate HID output report details

Kurt Garloff (1):
      usb/core/devio.c: Don't reject control message to endpoint with wrong direction bit

Liam Girdwood (1):
      ALSA: compress: Fix compress device unregister.

Malcolm Priestley (1):
      staging: vt6656: [BUG] main_usb.c oops on device_close move flag earlier.

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically

Mathias Nyman (2):
      xhci: Ensure a command structure points to the correct trb on the command ring
      xhci: Fix oops happening after address device timeout

Mikulas Patocka (2):
      dm snapshot: workaround for a false positive lockdep warning
      dm-snapshot: fix performance degradation due to small hash size


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSUDTIAAoJEDjbvchgkmk+/3oQAL7FuJrl8YlugT7NBLoald3n
T1EBdHLGAvfE2SD6QfZ5f7m0ZPmHKvJIK7tyZKBJRlel6ridGSLPSXpM9yCV+nw4
KxaJLd+06FJd1EKLdX8IAAvJDaXJ3bWau8jHMXb0OOpQkzyRlkysFZd0xA3iAydL
Qo2Nxat+Dn9AtVP1k7oyozgcgVDTDXjtSbwU/yD49hxvxfmRN02NREyMplAq+orU
MTLLDcPl267vk0oTsNpJW6QZiNns3aKGxB5xosfET4jnt63xNZysftf4rZqhxpAQ
ZW2lWum6mEndJiTmSflLgKyYbCwsr1ccv8atvklU9FHdAa2iFaUmJzkJZPaK71dq
OxM1W8sriTlVDviFqU6JMqo5qwp+4rECZn84CNObABG2rTGUlYfGiDxUKLj7IpjI
uAYSue5e+gT7as34WGWHkfc/542kaGqV9CDYRiR+NmAhprMP+oaIClOLcCQiissf
eCQk0HYNQQdcnNb3MgVgcbj4hNznpqyeMjiFrDXu1Grc8GUjZr2avnIkhq/Uugws
/2JZCxL90ZZ0h0ZDc6qKIiJszaBmCehx1uw3cuFmbciOFr+NQgOLzwS2uawyxP8S
/I7xCQop+FHAgbtPNea9TM0JdfAJk5Y+dHucG59tjZoYbXo2JMBsI/GOavj30+S3
4AOMK/fKXSMsaQD5aI3X
=ov2g
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
