Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab3ELVcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:32:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50858 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965Ab3ELVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:32:01 -0400
Message-ID: <1368394312.4304.27.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [000/118] 3.2.45-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Sebastian Reichel <sre@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 12 May 2013 22:31:52 +0100
In-Reply-To: <20130512083058.GA17531@earth.universe>
References: <lsq.1368193179.973009354@decadent.org.uk>
	 <20130512083058.GA17531@earth.universe>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o7q7moU0MRdcmG/T6KL4"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o7q7moU0MRdcmG/T6KL4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-05-12 at 10:31 +0200, Sebastian Reichel wrote:
> Hi Ben,
>=20
> On Fri, May 10, 2013 at 02:39:39PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.45 release.
> > There are 118 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Mon May 13 12:00:00 UTC 2013.
> > Anything received after that time might be too late.
>=20
> Please consider adding the patch "ARM: OMAP: RX-51: change probe
> order of touchscreen and panel SPI devices" [0] to this or the next
> 3.2-stable update. It has already been added to the 3.0 and 3.4
> stable queue [1].
>=20
> -- Sebastian
>=20
> [0] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3De65f131a14726e5f1b880a528271a52428e5b3a5
> [1] http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/t=
ree/queue-3.0/arm-omap-rx-51-change-probe-order-of-touchscreen-and-panel-sp=
i-devices.patch

The last time I scanned Linus's tree for cc's I got up to commit
150a8dcf109f68f322bf112c7604f2d950303f00 (you can see this in the file
upstream-head in
<git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-3.2.y-queue.git>).=
  The patch you're referring to is later and should go into my queue the ne=
xt time I scan for cc's.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-o7q7moU0MRdcmG/T6KL4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUZAKSOe/yOyVhhEJAQrzTBAAjTvVStIEGpJJ/sQJUpWV0LpZXeySIk17
w1vhUokiSoX93IYk1rcKgMhvOlDR+j3x6GlqvqrK5do/Z9qkWSJlHgLDky5DKoO0
+x0eQKDcBykoOLU1ZkVmL78Pnd4NWMgdn5rUT3qwJSbMkNRJh1I/pXR6PHFyhaOI
VBP3VJjSEBWnWGmIy0JkzAPnPH7pFxZGVf+MUFc02SOubglUNWQ44KJqh8Hsaac+
cYUBWknO06cSsUeGO0ut/770q6X2xvLcsizNwwd3PCtXn6A42t5ZSKtbI1DKlPI6
MwuxyarIpwbYnoVulNYPaLulN5Z33cEiU0xA8AM9clkIXTDXp9IBGgDXAe9530p7
CiVwHkKEdmVfDzJTDme1naMyAa6trPxo8NBPS27ySA8lUjsV/9hjk8LZgl1sN0Vo
8akmIsV5Sm12NYC9QfBygj2rhOVEv6vO7yEUe7nsAv9bl2RgWSZn01WNe9PrOLbk
OYIGVlTLu7GzCc5X7DZZ64vx74DNj2ByD64jdvBQhVvN5q9pbKmJ9TENs+1tqalQ
KFkis0oVKx6duqbXEJv5hi8LAazP6jo1jpol/HZRsBE94p7xaix7w4vOZrIemrsi
KbnocqclGWSo5umERDgHijHbNBDVKNyvu+by0ACO87En7BrklePBZ7O+nxlPQZhR
XxwYIa0eG+g=
=36xh
-----END PGP SIGNATURE-----

--=-o7q7moU0MRdcmG/T6KL4--
