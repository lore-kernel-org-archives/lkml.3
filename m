Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaKAXnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:43:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60836 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbaKAXnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 19:43:37 -0400
Message-ID: <1414885404.27313.4.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 000/102] 3.2.64-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Phil Jensen <pjensen@evernote.com>, akpm@linux-foundation.org
Date: Sat, 01 Nov 2014 23:43:24 +0000
In-Reply-To: <54556CEE.3030407@roeck-us.net>
References: <lsq.1414880882.522510247@decadent.org.uk>
	 <54556CEE.3030407@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-D9GZCZxbpNxLUfhTZUku"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D9GZCZxbpNxLUfhTZUku
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-11-01 at 16:29 -0700, Guenter Roeck wrote:
> On 11/01/2014 03:28 PM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.64 release.
> > There are 102 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue Nov 04 00:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >
>=20
> Build results:
> 	total: 111 pass: 108 fail: 3
> Failed builds:
> 	mips:allmodconfig
> 	xtensa:defconfig
> 	xtensa:allmodconfig
>=20
> Qemu test results:
> 	total: 20 pass: 20 fail: 0
>=20
> Results are as expected.
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for checking.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-D9GZCZxbpNxLUfhTZUku
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFVwIee/yOyVhhEJAQoT6g/+M3cyrp0NWhAtbmM209O76s4Jw+qTFJcJ
966uqBj26XKuy4brdmkarWykQXUlzIQ+31sHmrDNaABpj3OVCR708gkX1LT3tnSM
g84zhicmYzQj1HyLD79IT2NU55yDRhiszhKPir+VLy7jA/QWLcdGMki1Qlnldkdw
XX0Y2i9Oii7yuvkeEjfZA2X2EtBFPjkPj/O1iOYfacH/7X5Z6qX/frO4wmRq/YNq
OXknfzi6cd2fjYUT4ccb2WE0NHvOD3zrEXOuI9Qiqp8zXCs6Djr/XFQEIP15E6TP
rlDvteHvlVDBcvzCWdKhTn8DjbouhplcaKobCqeCaFt4GFU86+EtxpnO/pOmvxJX
eV7URLYWtIkU7bduwcafWa/I+yGNHzEinhOV/GUK9tKFdSTegLPtyC1r6P40g2e9
HiqIKco9HyXyDqHkeiHxzdG9D8Hojbq+Q9xpurKzG8bRT3ExPtawU0O5czWmZBhe
8EZlt/bCs3kk1yPJNEwdwILFwuISHei9zdkVLszEbPGoBvDzEiKLY7zWNiDPW5Km
FJbntwqXUAumhRojPGC2eV4NYDSxDJEXeZDZXoydhH/Z9UzV1sfwWwnaS04aGyVd
uYYqJgKyZReTBSXVCtKFeuQedf0rClf1lqQB8plctuvscae5TEFr53XND/8NaNjM
2ICsd3XCDu4=
=SZCO
-----END PGP SIGNATURE-----

--=-D9GZCZxbpNxLUfhTZUku--
