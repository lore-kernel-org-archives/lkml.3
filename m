Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaL0SwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 13:52:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56896 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbaL0SwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 13:52:14 -0500
Message-ID: <1419619556.4705.136.camel@decadent.org.uk>
Subject: Re: deb-pkg: Cleaning of debian/*tmp files when running 'make
 (dist)clean'
From: Ben Hutchings <ben@decadent.org.uk>
To: sedat.dilek@gmail.com
Cc: Michal Marek <mmarek@suse.cz>, maximilian attems <max@stro.at>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
In-Reply-To: <CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>
References: <CA+icZUXPt=GM08PD8LOpCdxCYhNMrr-2MHxPyNRWPXqUjQXFrw@mail.gmail.com>
	 <CA+icZUVfiQ1+k2zD9HXMM40N8rwg6rEmYLdKfHGsGt3xvJu+4w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-JedhCYh3uBvz5Pus0tMX"
Date: Fri, 26 Dec 2014 19:46:02 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.12.9-1 
X-SA-Exim-Connect-IP: 151.217.233.135
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JedhCYh3uBvz5Pus0tMX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-12-26 at 13:43 +0100, Sedat Dilek wrote:
> On Fri, Dec 26, 2014 at 1:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrot=
e:
> [...]
> >
> > Any other make (PHONY) target I don't know?
> >
>=20
> I fell over "clean-dirs"...
>=20
> scripts/package/Makefile:93:clean-dirs +=3D $(objtree)/debian/
>=20
> ...but did not really understood how it works.
> The main Makefile defines some clean-dirs PHONY#s.
> I can only speculate, someone with more skillz in Makefile handling
> should look at this.

It looks like this has not worked for a long time.  The scripts
directory is not included in the main recursive processes; it seems to
be special-cased for build and not for clean.  This is partly deliberate
because clean is supposed to leave 'enough to build external modules'.
It's not obvious to include scripts/packages/ in clean.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-JedhCYh3uBvz5Pus0tMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVJ2s6ue/yOyVhhEJAQqH6Q//SJFgCT4s3ey4N9tMKTUXQyJVQuwKgJR6
tqw7ssbj0+va3HKPBJ/42ipZM50csDlcwv0XRFl3ck6GdJ0Hdeoy93OUhmukx/Xk
pbv1T7xMqwJv+YdelI9YWPkFOnMSx9Fsw++H0XDCYQEjtC6YqYrOJiPdAni1irnS
fayRDFWUrNSitxQNvan//2dhezd1lFF4wIAV5WsFVTTT/WbLVXIWeXCxbLTz9w55
GKnSGBuM1yaWhSjLzFuCb4DUR5XFezMAouVkBAI45mod6GjD9zM7T5ne2azgKRBY
WqGgivH6rI4nzNIHGEcXAJM8XnKxuiKbf/tBzjZGMrBXHgWY+Bgpee8E36axTH2o
r9cUSDDf15TxD4P8vGHtZ92Izfb9YEpLXoPsHj5afw33PFyri3ikJ8G+mCW05MuZ
vZXv50cuu3c+erocFpGSibC7NtJyBFHTBD+Hz2Mc8xMzaKUDrE3G8VNLY+TEOn0d
xFmV1x/QJundibKQXTeOXcbBHT38vOzfepn8EoDdHVrM4r89GQCJ2Kdu8bkd58nt
rQCe/WVbcH+eAzP6DNxk/gV9u3PmPoemwzhXAp5g7RWHPtPVfeYBJFEkRgeC/NRo
/5obEkEH/xqLDl08HlAnpaq/f7wRyVyWDWBKYb5NnLHvbqphEBgrwnLta+pFqpGo
lpSYSeL6FzU=
=9fSy
-----END PGP SIGNATURE-----

--=-JedhCYh3uBvz5Pus0tMX--
