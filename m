Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbaLLQzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:55:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54660 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934379AbaLLQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:55:42 -0500
Message-ID: <1418403328.3599.85.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 000/164] 3.2.65-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Phil Jensen <pjensen@evernote.com>, akpm@linux-foundation.org
Date: Fri, 12 Dec 2014 16:55:28 +0000
In-Reply-To: <20141212162623.GC28564@roeck-us.net>
References: <lsq.1418364865.554543691@decadent.org.uk>
	 <20141212162623.GC28564@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FrtDs7i1xpJOHAtiCcd5"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FrtDs7i1xpJOHAtiCcd5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-12-12 at 08:26 -0800, Guenter Roeck wrote:
> On Fri, Dec 12, 2014 at 06:14:25AM +0000, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.65 release.
> > There are 164 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Sun Dec 14 06:14:25 UTC 2014.
> > Anything received after that time might be too late.
> >=20
> Build results:
> 	total: 111 pass: 107 fail: 4
> Failed builds:
> 	arm:mxs_defconfig
> 	mips:allmodconfig
> 	xtensa:defconfig
> 	xtensa:allmodconfig
>=20
> Qemu tests:
> 	total: 20 pass: 20 fail: 0
>=20
> The arm build failure looks like it is new, but it is due to 'Inconsisten=
t
> kallsyms data' which I see randomly with arm builds, so it is not a real
> concern. It may show up now because I switched from the Yocto 1.4.2 toolc=
hain
> to Yocto 1.7; as result some previously failing arm builds now pass while
> others now fail.
>=20
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for checking.  I caught a couple of build failures with your
build server before sending these out for review.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-FrtDs7i1xpJOHAtiCcd5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVIseBee/yOyVhhEJAQoD9g//V/boUlIjWVOLmjxSGy8R61YLQnbRv+JB
ht74IygX+aXEfA0OtxiU3SBMe9n1DmVB9ZpX9YSwLp2YyRjCRK0ZrlMzhFswbjms
SEYvoilgQoKXyk0L1iBcIwlb9/SYjpZP1AEG9F4L1ad1aseoat+NDLpfem9lUwXV
ecrLtjJ6JKVgwP4APEHFC9hNpRZ+QNL0Jkv0VwMpnTJCbuiw2qL6KuzShrfsWaSQ
SUVkFmybraTK3xX4LsAFQJwKTw4Kk+Elj+ct4Pxsks9nCL3E/ehOCyMvED6STmlL
7AcwM4i5WTpyWXzNr54ko8c156teLNGXChKK7haRFqw3gzR7pYVF7iw+w8KQeuxy
UMkeg9fN0KYQwE8z117uNXxdiX+eUwLWKPjt4A5/sRDuNoWiiXK06ffi7ls6etu5
iIxiwghw1oNTuXs2+9wUvOmFXl0tBSLNYpessYOGmPyaxOierXcawDw0JjS4sxSE
vEUYZVumF9eQgFmCM8vpyNSgtDspTJYhVNrX00v5zDh4+Z/FxHlimV0pxETqjc91
8RisSosjHZ0FYbHMLPVdOtFeVY+6aki1a0gDIY9lkvs5rzN3q4KrrhKbcCgEpTr8
fMk1mMmFLxg57YBOilQb4i3PJg3SHoDSZk19aQQn2FSrFdw2RhWbF0U7VCauNH/o
HJjToB02Lo8=
=2pH7
-----END PGP SIGNATURE-----

--=-FrtDs7i1xpJOHAtiCcd5--
