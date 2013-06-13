Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab3FMRGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:06:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3FMRGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:06:09 -0400
Date: Thu, 13 Jun 2013 10:06:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.82
Message-ID: <20130613170646.GA12797@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.82 kernel.

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

 Makefile                          |    2 -
 drivers/acpi/video.c              |   16 ++++++++++
 drivers/gpu/drm/drm_irq.c         |    6 +++
 drivers/gpu/drm/i915/intel_sdvo.c |    2 -
 drivers/hwmon/adm1021.c           |   58 ++++++++++++++++++++++++++++++++-=
-----
 drivers/usb/host/ehci-sched.c     |    2 -
 drivers/usb/serial/ark3116.c      |    2 -
 drivers/usb/serial/cypress_m8.c   |   18 +++++++++++
 drivers/usb/serial/cypress_m8.h   |    4 ++
 drivers/usb/serial/ftdi_sio.c     |    4 ++
 drivers/usb/serial/iuu_phoenix.c  |    4 +-
 drivers/usb/serial/keyspan.c      |    2 -
 drivers/usb/serial/mos7720.c      |   25 +++++++++++-----
 drivers/usb/serial/option.c       |    2 +
 drivers/usb/serial/visor.c        |    1=20
 drivers/usb/serial/whiteheat.c    |    2 -
 kernel/trace/ftrace.c             |   34 +++++++++++-----------
 sound/usb/quirks-table.h          |    8 ++++-
 18 files changed, 149 insertions(+), 43 deletions(-)

Alan Stern (1):
      USB: revert periodic scheduling bugfix

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4

Andrew Worsley (1):
      USB: serial: ftdi_sio: Handle the old_termios =3D=3D 0 case e.g. uart=
_resume_port()

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Bj=F8rn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DD=
C.

Greg Kroah-Hartman (1):
      Linux 3.0.82

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1=
617

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Johan Hovold (8):
      USB: iuu_phoenix: fix bulk-message timeout
      USB: keyspan: fix bogus array index
      USB: ark3116: fix control-message timeout
      USB: whiteheat: fix broken port configuration
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: mos7720: fix DMA to stack
      USB: mos7720: fix message timeouts
      USB: mos7720: fix hardware flow control

Namhyung Kim (1):
      tracing: Fix possible NULL pointer dereferences

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Steven Rostedt (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Takashi Iwai (1):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audi=
o iface

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL =
pointer


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRufwmAAoJEDjbvchgkmk+ZyAP/jTPHsvNxC4Me5tMbXYpjkIW
Im3iv8/6b53U7uf6SI4BZrBIpdWUT0+3rzZQwPlKLNvNuuxAuKUNtpQ7NX51ilPh
J4LrtwJYQlis2Rj32OY+vXKpBd45xyylP8rrWcgDIpm8BT3x+S9TnGnGJl06bq9C
gSLWxetfNPNxXDY7HvwSxmbwbqKfuAB+irDUP1lv8WRGclvd/Hymdu6ALz0p8dHh
TmoGNkR5nkCyPqrXlVzQofqNwSre4/W559CFkfhZd40l2k6JnF3PSI1/kj9RDLEg
/gpAY5wv5uNtxAUY8zDIwhrsYJuPh5cPsxA2Yq8h+OVtXQo05GrZcanKToGNHiUv
IhrPNezFt2zz2YqJGE7mXyk/wIjTzP3da1V5ufEfKsOYEoAOp2/oetwfq9nzsW2W
v1CqM+XI0kKv5B/w7cNZOzl10BSDs6Gqb37DiCR3/nrePiyJpqIbzvHYHzzXnTsT
ZGcE9R3R/9UaRjPcZYukq2HsUKbA7BMMVKnhEWuvb/ckdH7MGgB1VAqTAVoKz+qg
QIN4pTMeUu2FPwgFN2fuShZGOpeAslt/RBqIX5BvnHylTsU/n2+hwA3YHz43EvCj
AF4f9WssMFbUxuwnyx3e+xh50yXnGJ65m7PeydxsVV6pxmF6Q4n4VTIsz0CXjsm8
KKqlVX1kM25dEpRiy08p
=zmS5
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
