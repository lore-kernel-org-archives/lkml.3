Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3AUBMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:12:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48918 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab3AUBMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:12:44 -0500
Message-ID: <1358730733.24121.228.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] Bluetooth: btmrvl_sdio: look for sd8688 firmware in
 alternate place
From: Ben Hutchings <ben@decadent.org.uk>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        David Woodhouse <dwmw2@infradead.org>, Bing Zhao <bzhao@marvell.com>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 21 Jan 2013 01:12:13 +0000
In-Reply-To: <1358494422.28503.4.camel@unicorn>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
	 <1357689361-7969-2-git-send-email-lkundrak@v3.sk>
	 <1357698538.1806.43.camel@aeonflux>
	 <477F20668A386D41ADCC57781B1F70430D13FDB783@SC-VEXCH1.marvell.com>
	 <1357713088.1105.1.camel@unicorn>  <1357713345.1806.44.camel@aeonflux>
	 <1358494422.28503.4.camel@unicorn>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IfrtQp/Gpct+Rai97Tjk"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IfrtQp/Gpct+Rai97Tjk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-01-18 at 08:33 +0100, Lubomir Rintel wrote:
> On Tue, 2013-01-08 at 22:35 -0800, Marcel Holtmann wrote:
> > Hi Lubomir,
> >=20
> > > > > > linux-firmware ships the sd8688* firmware images that are share=
d with
> > > > > > libertas_sdio WiFi driver under libertas/. libertas_sdio looks =
in both places
> > > > > > and so should we.
> > > > > >
> > > > > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > > > > ---
> > > > > >  drivers/bluetooth/btmrvl_sdio.c |   24 ++++++++++++++++++++++-=
-
> > > > > >  drivers/bluetooth/btmrvl_sdio.h |    6 ++++--
> > > > > >  2 files changed, 26 insertions(+), 4 deletions(-)
> > > > >=20
> > > > > NAK from me on this one. I do not want the driver to check two
> > > > > locations. That is what userspace can work around.
> > > > >=20
> > > > > If we want to unify the location between the WiFi driver and the
> > > > > Bluetooth driver, I am fine with that, but seriously, just pick o=
ne over
> > > > > the other. I do not care which one.
> > > >=20
> > > > The unified location is mrvl/ directory.
> > > >=20
> > > > We can probably move SD8688 firmware & helper binaries to mrvl/ and=
 have both drivers grab the images there?
> > >=20
> > > That would break existing setups, wouldn't it?
> > >=20
> > > I was under impression (commit 3d32a58b) that we care about
> > > compatibility here. Do we?
> >=20
> > that is what symlinks are for.
>=20
> David, Ben: please pull the following branch then:
> git pull git://github.com/lkundrak/linux-firmware.git sd8688-move
>=20
> Thank you!

The symlinks are broken, and you didn't update WHENCE.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-IfrtQp/Gpct+Rai97Tjk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPyV7ee/yOyVhhEJAQoZ1xAAwwDrcuXXBWOU1Uut/FbeE+yRRHXcu4dF
DwzzsXBvVgdB2R0Rw8mX/mM/awqCcyHkQGyL+eZsT9JhG+QuPG75CUiu0z9MqjM2
hVU9gGRBw5uE8YlnLNctcIsI7jd2Uqi1AD72dJPQTl7lk6I+wOlY1ze/zWQPuoN7
4+BJ+YF10w7K2+Ie8RuaLcDuQLOuz7esGDV4FHvKLz7BWnGGcdnGBa5rLtMy8uwK
rBL1FgZpZJPQOYJ+gSj+cai96+KJu+MsEQvv4lngT/7phuujrzZu0RB0RdL+N2LE
TC1q90PPuDl4930KH4GM8hBaVDtl1fEMUHd8bP8/UOyUbBDzljYZEpHBIeHe5FA5
PlFEtBqx3Nno8SWjHV6kDOO7ScIw/UkCZGcn1w3347iEe7GVD7NmMN3uMPK8umDE
T/g7FccfDepy9V4+s4tMbbvEjYST4ytALkFePvgPj5LQavWCF0/PdBZzg2v7GbSy
0aXZc4r8Je0O7c8uFumm0bFktbslU15wrOwdYV2kmA3wilG7l1JEkF0UvSjX8hsJ
iQSn6Uo6RMrumejxw4YB2gcEcKDq+MxIM9um2Tek0cnSbNO/IZ49XkE3A1B5e31Z
IeXTzZ5anE5Sd73RkvihWNWqSqoCNnE8EGoaC8g3IjGzk9OYSqGmV1iOF5z3TX6Y
qFCp+sMH2+c=
=LzkI
-----END PGP SIGNATURE-----

--=-IfrtQp/Gpct+Rai97Tjk--
