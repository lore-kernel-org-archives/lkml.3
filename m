Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaBSBMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:12:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44491 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbaBSBMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:12:32 -0500
Message-ID: <1392772341.10088.56.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Pavel Machek <pavel@denx.de>
Cc: Sebastian Reichel <sre@debian.org>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?UTF-8?Q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE_?=
	 =?UTF-8?Q?=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Wed, 19 Feb 2014 01:12:21 +0000
In-Reply-To: <20140215223006.GA19186@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
	 <201312301531.29768@pali> <20131230145250.GA16904@earth.universe>
	 <201401082236.25135@pali>
	 <CAHYPw2EJC9RwgzXmGuQgh5_L6EMtS7MW8N3u2dR8KeVc0kb43g@mail.gmail.com>
	 <20140214172802.GA26969@earth.universe>
	 <20140215223006.GA19186@amd.pavel.ucw.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-50tEtse6rAwQs4rKTh6V"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d8bb:639b:205c:713a
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-50tEtse6rAwQs4rKTh6V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-02-15 at 23:30 +0100, Pavel Machek wrote:
> Hi!
>=20
> > > >> > Firmware files are available for download from nemo project:
> > > >> >
> > > >> > https://api.merproject.org/public/source/nemo:devel:hw:ti:om
> > > >> > ap3:n900/bcm-bt-firmware/bcm-bt-firmware-0.21rc3.tar.bz2
> > > >> > https://api.merproject.org/public/source/nemo:devel:hw:ti:o
> > > >> > map3:n950-n9/ti-wl1273-bt-firmware/bt-firmware-ti1273_0.23+0
> > > >> > m6.tar.gz
> > > >>
> > > >> Would be nice to have them added to the linux-firmware.git.
> > > >
> > > Now when driver is queued for staging, can somebody add firmware file=
s
> > > to linux-firmware repository? Note that without firmware files, drive=
r
> > > not working...
> >=20
> > I just had a look at the file for the Nokia N900
> > (bcm-bt-firmware-0.21rc3.tar.bz2) and I think the license is too
> > restrictive for linux-firmware.git. Actually I can't see any
> > statement allowing redistribution. For reference this is the license
> > text:
> >=20
> > Copyright (c) Nokia Corporation 2010
> > All Rights Reserved.
> >=20
> > This material, including documentation and any related computer program=
s, is
> > protected by copyright controlled by Nokia Corporation. All rights are
> > reserved. Modifying, adapting and/or translating, any or all of this ma=
terial
> > requires the prior written consent of Nokia. Distribution for commercia=
l
> > purposes not allowed without prior written approval from Nokia.
>=20
> With my lingvistics hat on, this says "distribution for non-commercial
> purposes is ok". (Because otherwise, they would say "Distribution not
> allowed without ...")=20

It implies that ('the exception proves the rule'), but that's not
something I would like to rely on.

Anyway, I think that anything added to linux-firmware.git ought to be
safe to include in a commercial distribution, so a non-commercial
restriction can't be accepted.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-50tEtse6rAwQs4rKTh6V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUwQE9ee/yOyVhhEJAQoVgw/9EhZwnAvsatF4JYRwHm4EVWgRWahHpLWO
1O5ZkhWUslNyjT7ZtynuUPpSNbJhC2E5S4RE3d6ToZ60OjNw6+WtkArknclroegU
Vo5MH6LkxpUL6W7+WoIexbl1+9HKjEpqzp33PYdnOUT4aGWUcGArFs2kAnE5GM+R
sHd5GwJ098A+Gm9tpq3LRoFAuCgoPxQaK994oQHhHNdj/b4N3CiTZEn44XbR2PPF
qpdvLGJEPD53IhiuCYlANZkvczRXyiRIQiwyCRIYsEVirUuTuAsZP45cODPw+o1Z
iOJXNxSXBKm40Ay6wnG/sb7hZUr8/OrPc71KaocKAnx50APQKaYTt3rOyspLhFKz
7sxwmUWMk05Hgskb7+00kB3FfW4HI88heiI+b7Ctya0jgt3fG0W+jnF6xFOgZwM9
+EytQUrd0MJvAcDPqj92QcixKiLL8BLxXaatbghFhBWc+ev9TW5Lxw1tRR/liif2
VmlsgOTKlkN6pVlSgI39TOzqiMwSJvoLdzJTet9idqnUvdqZAG1mPh8BF7gQBG6A
4KnjhIsbMOPQnY2jqXJJ8Z3Cpo1lDAvalRhUczVbJBsSMobjsGIDww/XPKv6+YPV
70Vr4ExUIywJ5d+EckyR5h9WVe2+FMk1EaUQ0y/RuPZT9br90rbEKMRQQ7HSLvE/
oN6ITh1yi2k=
=Jlt1
-----END PGP SIGNATURE-----

--=-50tEtse6rAwQs4rKTh6V--
