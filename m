Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3LRQi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:38:26 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50786 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3LRQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:38:24 -0500
Date: Wed, 18 Dec 2013 10:37:44 -0600
From: Felipe Balbi <balbi@ti.com>
To: Huang Rui <ray.huang@amd.com>
CC: Roger Quadros <rogerq@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: usbtest: Add timetout to simple_io()
Message-ID: <20131218163445.GI4970@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387361411-15139-1-git-send-email-rogerq@ti.com>
 <20131218144603.GA19091@hr-dev.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5VuzLDXibKSJvVYD"
Content-Disposition: inline
In-Reply-To: <20131218144603.GA19091@hr-dev.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5VuzLDXibKSJvVYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2013 at 10:46:03PM +0800, Huang Rui wrote:
> Hi Roger,
>=20
> On Wed, Dec 18, 2013 at 03:40:10PM +0530, Roger Quadros wrote:
> > Without a timetout some tests e.g. test_halt() can remain stuck forever.
> >=20
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  drivers/usb/misc/usbtest.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
> > index b415282..6294e1b 100644
> > --- a/drivers/usb/misc/usbtest.c
> > +++ b/drivers/usb/misc/usbtest.c
> > @@ -10,6 +10,7 @@
> > =20
> >  #include <linux/usb.h>
> > =20
> > +#define SIMPLE_IO_TIMEOUT	10000	/* in milliseconds */
> > =20
>=20
> Only one question, how do you confirm the timeout value?

dude, it's just a timeout. It could be anything, really. 10 seconds is
just large enough value that would allow even the slowest scenarios
(host + device) to complete, while not being so slow that you would
wanna kill yourself after waiting for such a long time ;-)

--=20
balbi

--5VuzLDXibKSJvVYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSsc9YAAoJEIaOsuA1yqRE7CwP/iiZtPHvLHvmh7Fc05XCtlHs
jpiNiqwkFNdmQuMg6qRnRAGTYO8GfRWvf4iPKW5P+o5hFSZ9+RMNpdEfrcTz3nAh
u5o0kXhiiAkc+vgbnKFZP/r2+ZMgdS/IxffJw6ez6dbIhddunFSDTHnJ8F60SWHJ
k9LUwKz/VPl1Oec50/2RD0ErzyK289yksqrqfcjW7Hn6l0kiJEVfHTC5MYWGBxTM
djf4NDBPgnhKlWxu1mcHWlD1Hn0Zd2MwkV/Q+Qs0A3rjg8tuv1UhTMvDH4RaiZuL
JgoiIgVrl1X3/t8zwfbqm+IKIIBIijuYZGcWbCOsgJ4Xjg7OMlcv35bnEj2EsE6G
O6OWsmOAGfnD1OKWxzrRWYJBc6beD1yhKT2JN19wByBsPGtIJYf4qcWLH8eTyI/2
IQBp8/Li7wQatBaxtTMyRzF3blz+SKge8XsbLgFIa8HNqoltLLhs5hPjbARIsloB
MFr0WQOQtg9JW+adq/JcLQTC2WUVkvfSBOlb3n5GcrmS/aUdAHXMUGSiF+uVnbvu
Dszfxo2J7/PAznfgw8GtMwpFKX7SW1HC2Fe2vEgl/Vnq5dqsdOcPjAEO1ammzoOX
BW1XQ1DCvCR4m+XZu05og90KV2gemAEaEXIukfaLciyOYNvUCRa0mQphLyEUTpjF
orm7kegwF6vrVFlLGqwE
=LQWH
-----END PGP SIGNATURE-----

--5VuzLDXibKSJvVYD--
