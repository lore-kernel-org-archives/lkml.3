Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaBLSOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:14:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52207 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbaBLSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:14:29 -0500
Message-ID: <1392228860.11578.2.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/79] 3.2.55-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 18:14:20 +0000
In-Reply-To: <52FB600A.3060903@roeck-us.net>
References: <lsq.1392192611.998273004@decadent.org.uk>
	 <52FB600A.3060903@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-smdrrnfrgmr5HALKX/Iw"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-smdrrnfrgmr5HALKX/Iw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-02-12 at 03:50 -0800, Guenter Roeck wrote:
> On 02/12/2014 12:10 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.55 release.
> > There are 79 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri Feb 14 09:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >
>=20
> Build results:
> 	total: 116 pass: 87 skipped: 22 fail: 7
>=20
> qemu tests all passed.
>=20
> Results are as expected.
>=20
> Details are available at http://server.roeck-us.net:8010/builders.

Thank you.  This caught build failures in some configurations before I
finalised -rc1.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-smdrrnfrgmr5HALKX/Iw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvu5/Oe/yOyVhhEJAQroEQ/9HYas18juFtwHS/KukTEIJYGm8mV+Ud3F
XrickBoQOjMxP8yicoZYKwsm3nAyJKbu3qR/HdhZ2+XajmvNUmFadDeNTjXLEsdt
t7lk7xloH+MtQkljia1Qyz6GiJ+/TbJ7mZNkMajgV1TQtqPGB9IZyiQn3dho5RkI
TzuGSNXpLMdWMCHJj25T6ePruDoIXtgbGC1aWq+GgrU8VUJQhx5F8GG8DQU5RUNW
uryPgXXEMn+uCbczkCc15RcLcrBjn68NGM3zM8WG3fJaNug+r/gmscDmgbBhlsm1
gsqNbY+Cxs8gtSZYf5NgEA/dvg9jtfn05m92TaeISaiT5PqZBqgazpILL35z438V
X1RUHzm4YG3vdfIATWFddbdusHCgtJWxhd8GaxUgeATDAE3lHRRVP9+S9Xz1SUUi
yUoPegj+vsV8mPrSn3RCBmR9x7A6+K0kOOmC6XX7e7QwLe/y/Qv4FyINlHg64TkC
nrDKcG4Dx5ikRu/bJBMQR0NgGG+0ZCSwYI7hVHccRiajDVwlTT5S8zbkEdiQ1x38
DLEg+VgraZAWuEYqdqaDb0pTFMcD0FFByu1PgQKEpZsGwwPLH75GaZMTeRIPfIS5
AYFxrBt8a5yzpEDaaa+76RpRGt5jZVcidf+2zRjCMzXXfRIcwCz4J+3fBZdbw2nq
kCiI8wIokHk=
=hM7P
-----END PGP SIGNATURE-----

--=-smdrrnfrgmr5HALKX/Iw--
