Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaCGQwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:52:19 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41767 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaCGQwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:52:18 -0500
Date: Fri, 7 Mar 2014 10:50:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH v6] phy: omap-usb2: move omap_usb.h from linux/usb/ to
 linux/phy/
Message-ID: <20140307165043.GC23885@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
 <1394210888-1587-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <1394210888-1587-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 10:18:08PM +0530, Kishon Vijay Abraham I wrote:
> No functional change. Moved omap_usb.h from linux/usb/ to linux/phy/.
> Also removed the unused members of struct omap_usb (after phy-omap-pipe3
> started using it's own header file)

does this depend in any other patch ? I get the following when applying
*only* this patch on top of v3.14-rc5:

drivers/phy/phy-omap-usb2.c: In function =E2=80=98omap_usb2_suspend=E2=80=
=99:
drivers/phy/phy-omap-usb2.c:106:21: error: =E2=80=98struct omap_usb=E2=80=
=99 has no member named =E2=80=98is_suspended=E2=80=99
  if (suspend && !phy->is_suspended) {
                     ^
drivers/phy/phy-omap-usb2.c:109:6: error: =E2=80=98struct omap_usb=E2=80=99=
 has no member named =E2=80=98is_suspended=E2=80=99
   phy->is_suspended =3D 1;
      ^
drivers/phy/phy-omap-usb2.c:110:28: error: =E2=80=98struct omap_usb=E2=80=
=99 has no member named =E2=80=98is_suspended=E2=80=99
  } else if (!suspend && phy->is_suspended) {
                            ^
drivers/phy/phy-omap-usb2.c:117:6: error: =E2=80=98struct omap_usb=E2=80=99=
 has no member named =E2=80=98is_suspended=E2=80=99
   phy->is_suspended =3D 0;
      ^
drivers/phy/phy-omap-usb2.c: In function =E2=80=98omap_usb2_probe=E2=80=99:
drivers/phy/phy-omap-usb2.c:194:5: error: =E2=80=98struct omap_usb=E2=80=99=
 has no member named =E2=80=98is_suspended=E2=80=99
  phy->is_suspended =3D 1;
     ^
make[1]: *** [drivers/phy/phy-omap-usb2.o] Error 1
make: *** [drivers/phy/] Error 2
make: *** Waiting for unfinished jobs....
  CC [M]  drivers/usb/phy/phy-mxs-usb.o
drivers/usb/phy/phy-omap-usb3.c:22:32: fatal error: linux/usb/omap_usb.h: N=
o such file or directory
 #include <linux/usb/omap_usb.h>
                                ^
compilation terminated.
make[1]: *** [drivers/usb/phy/phy-omap-usb3.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers/usb/phy/] Error 2

--=20
balbi

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGfjjAAoJEIaOsuA1yqREtakP/i5Xq1WCREC6V+xV1Nn0m5yZ
2SkYdYLPqgmnvlCiQHOv3ejZeC60YVCYw9/QyXoAdzbB0LyHZNOw3In3UfE4E1PJ
Fz1AvgStQCT3T0amDQYp8j9QigLilQ9PKFmDTm2ijHSzMy4V93I8m95ZCUBsNb1q
cA1IVzAkkRcAqR3w2I5gT9VQNwptzlQQ9CswRJAG/njbw6QSU9/e3K6PlYbIer6A
hqr7FeUuqkevoHtUNxwofmBH+Vr8LXwMt1w5kQVf2g5iYRFbsjNR/orPiPIxtqif
n/ua2QDdf8jcReB0uCxLua+PAbN7owknoZsgodkBytBKFdxCk5fj/3CjKTjObA9S
MbiJHmVI81Ta1e7xYLGUbH5SGuwoOzWChILDOEjIEaRV0VleXRZVc85Pb/NlU3BV
tbEfjJgrFSUB5bqydVTWKOlKQgZsZ7BWnOXMs1LXMvviGqTHmt1hdZnkUNRSVjZ+
mzmdW9QYYYrsqt6JZhGLoRaty6PzhZXXFRfzQouRoM00znYq1MVuYcr+uIu9MOk3
4ApHbp9gSQGTsNSFGvWr+5ZUe6YBanUZuTbdA8oor0Rn3aM19KvYHRF0719mGEcA
QX6ffDPYcvxt0o0OnDfuTQudjCA9xZA4H78cdmHapiwUmhhyStBDwadGSHP0P9Xx
01Pwzl1kYAtR8VYpmbyB
=20qx
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
