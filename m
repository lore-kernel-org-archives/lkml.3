Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaL2L2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:28:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbaL2L2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:28:38 -0500
Message-ID: <1419852504.5686.4.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 00/27] 3.2.66-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Phil Jensen <pjensen@evernote.com>, akpm@linux-foundation.org
Date: Mon, 29 Dec 2014 12:28:24 +0100
In-Reply-To: <20141229093956.GA13940@roeck-us.net>
References: <lsq.1419815490.288081487@decadent.org.uk>
	 <20141229093956.GA13940@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KRs+fjzLMOwxocuqbdxz"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KRs+fjzLMOwxocuqbdxz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-12-29 at 01:39 -0800, Guenter Roeck wrote:
> On Mon, Dec 29, 2014 at 02:11:30AM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.66 release.
> > There are 27 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed Dec 31 12:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >=20
> Build results:
> 	total: 111 pass: 108 fail: 3
> Failed builds:
> 	mips:allmodconfig
> 	xtensa:defconfig
> 	xtensa:allmodconfig

So, nothing new there.

> Qemu tests:
> 	total: 20 pass: 20 fail: 0
>=20
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks.

Ben.

--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

--=-KRs+fjzLMOwxocuqbdxz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVKE63ee/yOyVhhEJAQoZHw//b+Gof2vIZnBYMvAmDH26l8KV/EwdcRYn
xqf+zk7ArfnII3Z0lOOgxJ/Mv9CWOzzaJlo9yRFqnvKn3nzdt6s/ttvF2NWSDtyb
Rfgk3S+PuVqCROlY6TI6nqKSJSt+aW0UiHRypkBpnKr5A1hvvKFp5n+KBR+stHPt
NwML/dm2KasLm9cV6YgRnxj8+BzTIyknuAQ6wHvF2h6WK+jbiu9BiM/sAqNrNgeH
ykY1yZxX0RwRGA4c836+rgQBafXRhei8qltMUnoNxL7hdiYd46+WsanZvPSfYay/
yS9pRKcg6LwGOACkQGe9s204v38yjZc7/Z9y1kyf5W8ZRKvtsBZOEC+RZ3JDZICf
x+N6JO96akY7VV2GIR0yKAHdCpl/+a1v9mxDQlmHFlGnp4KrnrVnuq7OvtH4AUol
rV8vFjc2nyIAEUidR/FS/Ji7n3/eSi39ZQcKiccdUYYEKsOCMJFmS4oTwLWtFB9a
SJCnbZRP8n/ZTRgJC8TmqijMIywv+qrGRwCLzQqLPo8/mROCe+29JpiD9cadVRnz
eYOsajc9uj3mqD8Z9rdgaxH6wX9KZdbxc5Zo608L2BTdLnvSG7azfXKizGp9qJwP
IAc0tyw/lNQAEXWzht9YahvnE09t1gpPMKJZX2WfPdMGrLi/m5F0SL+acch87mLf
VICeEndCQ3M=
=Z9Vr
-----END PGP SIGNATURE-----

--=-KRs+fjzLMOwxocuqbdxz--
