Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3L2Ou3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 09:50:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57403 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab3L2Ou1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 09:50:27 -0500
Message-ID: <1388328610.14575.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 000/185] 3.2.54-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Sun, 29 Dec 2013 15:50:10 +0100
In-Reply-To: <20131229135449.GA25007@roeck-us.net>
References: <lsq.1388282923.751256928@decadent.org.uk>
	 <20131229135449.GA25007@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OINH1oXdepv7oA4w8Ow4"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.234.213
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OINH1oXdepv7oA4w8Ow4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2013-12-29 at 05:54 -0800, Guenter Roeck wrote:
> On Sun, Dec 29, 2013 at 03:08:43AM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.54 release.
> > There are 185 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed Jan  1 00:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >=20
> > A combined patch relative to 3.2.53 will be posted as an additional
> > response to this.  A shortlog and diffstat can be found below.
> >=20
> Build results:
> 	total: 100 pass: 78 skipped: 14 fail: 8
>=20
> qemu tests all pass.
>=20
> Results are as expected.

Thanks for checking.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-OINH1oXdepv7oA4w8Ow4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUsA2oue/yOyVhhEJAQrkIw//QLn5z5WAo5Cwg2piV4l2OnEyNCos3ejW
3ffzOk8D15oVDptg/OJwHcMCqaj8rLj9lfKmxfOKLeMljNV41hp92q4HR5aoSqKe
y7ia1x0nwHRYxGD9qBiJnGPTTsswqkOGunheH/NruIpVc1IanUWFS2sMTsct4MZF
g3l3/gMKF2FwcGUa1LmKmMhbE0UhUiuKew6K/eUqHU139MmIkvaXm1Usyq6vP3vJ
c/vGP9WSgZOwbHK8veuhaWZBJyyISC6ntLZKn5NyI6zqZ1Dhu+dvnptq6CsyzHpl
iLhEYdznWOgcAajS8o5W8XQTvsiKY4cg3krhh0PYzEoN7wPIBfhg/s4KH8QB/mJU
XAgk2Iety1TwlUSjaJ2uBVgVoXVbEYo33Jr8Ch4QM+gh841gheRECJHODnDJIfGv
7VxYr3n2A+PNCwdeJjnUJ21Nz6cTjdbqr3Dgr7NQ/MIc3rPtLfvqA9HMGDwGDQJx
GpC1ZVTSTXXpZ76GROluV3CDeOeAVPo5Vmyjn+oFDs1vfloh8fiE9gLO5hZ1B88D
07QxFLRus61IX5Af+f0yCPC3VJrka2GLfqLEJkNcC/1xlxheKEKLzfEApaemNC0V
8qv7/s7DyDdRbFSfvVXD/zvUcDc5IZ2DDJLrSY+n0d05Yl6NPxa/BEujpcga8O5I
pPJMkg25i+I=
=kw1f
-----END PGP SIGNATURE-----

--=-OINH1oXdepv7oA4w8Ow4--
