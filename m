Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaKLVfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:35:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:50384 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbaKLVfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:35:18 -0500
Date: Wed, 12 Nov 2014 22:35:13 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: reset: augment versatile driver for integrator
Message-ID: <20141112213512.GB10533@earth.universe>
References: <1415100672-31425-1-git-send-email-linus.walleij@linaro.org>
 <CACRpkdZUZJmSrHVH4BbNbANgN-BphYL_wCF=6QdXndXdXYXiZg@mail.gmail.com>
 <CALT56yM15FbKm6RKqUe59cWtMSfZgOR7koYcgM_J3F_TyHp2WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <CALT56yM15FbKm6RKqUe59cWtMSfZgOR7koYcgM_J3F_TyHp2WA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 12, 2014 at 10:20:34PM +0400, Dmitry Eremin-Solenikov wrote:
> 2014-11-12 17:54 GMT+03:00 Linus Walleij <linus.walleij@linaro.org>:
> > On Tue, Nov 4, 2014 at 12:31 PM, Linus Walleij <linus.walleij@linaro.or=
g> wrote:
> >
> >> Augment the Versatile reset driver to also handle the core
> >> module reset sequence used on the Integrator/AP and
> >> Integrator/CP.
> >>
> >> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> >> Cc: David Woodhouse <dwmw2@infradead.org>
> >> Cc: Sebastian Reichel <sre@kernel.org>
> >> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> >> ---
> >> Sebastian: please merge this into your power tree if you're
> >> OK with it, the corresponding platform changes are orthogonal
> >> so these can go separately through the ARM SoC tree.
> >
> > Power folks: ping on this patch.
>=20
> I will apply tomorrow, if Sebastian does not respond earlier.

Ack.

-- Sebastian

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUY9KQAAoJENju1/PIO/qaHikP/ibIvNApDer+0rqpBGcmt48W
8MBTB3gTCWkwWoDbvn4fUofCko/8z5zt4u3ybJuYFH8CSIZUw+rzDIQO3K27q4uB
SI3SrEDQeDu8UbNwvkj21rbR8uINBmFGYKYYiycw1qAeKp5BnjZoN8IHvOKJJr08
GK03COG4NEGbTm4kmblVlx2lCCv/RsrYv5A2bc2BSE2pP7uv4cmwGU7w95ZmR9Z5
Ak90EVTHP3bHM8hrqVLaV/+H2vgpTzLgV4zVR7uYioAci82oXKxIHRVEfUTzSCZC
TYRtHexMT4qGImNLPDzuFUb+mQc3AiAw+A5T9UQI3GVRQ4B+NkEYFshj4TVbxwdn
98gqlYstz5dZs5al259GjAcBxukktTANtG9YS07Ayi1/7yNd66sZG3zxsIc1iVzN
ZCoNKcUvGTtnfCK9T4mR+rpKm2LwAHvG8gDXl6uTTcAAj2tzkmkzH2FQG2cxtrBw
6eqXRmxrD7ztyoSlkpJRlHjeuIX/0sA+6pm3g/x7ayc3+pA8LmakyD8liGgyz8jS
+59DmJpiwAQ3RSYNn+Lql//sRDTW1feoSDkj/P+VVGn6AMCeqEoVpEgjDIJ5/f/4
TwUrwd51pgeItfkM86TwWBhIdVDx45aFytjBnDb3vAmA/2biFx2xZZ3HZ3YcePub
wobBAHl7iV3aGoe+LbmU
=ktwa
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
