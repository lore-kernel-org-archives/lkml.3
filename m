Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3AVG4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:56:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3AVG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:56:48 -0500
Date: Tue, 22 Jan 2013 07:56:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, arnd@arndb.de, w.sang@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 20/33] net: Convert to devm_ioremap_resource()
Message-ID: <20130122065629.GA14523@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-21-git-send-email-thierry.reding@avionic-design.de>
 <20130121.152913.1377695352860141642.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20130121.152913.1377695352860141642.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:iDsSi7E1lwVVugvZSWCCVRNNNaj7JWAc1A0O+JPOEJQ
 dFcQ9Remda/Cp6GXsQUqrjXTf0noqbWmViOHy9FP9vVf7CCH4X
 nCq27mohlqGWbyYcuLp0r2C07RFe2L4q/r8vQkfSQk4eYQ3re0
 aguZwb3A6saG5885E/JXshgltYPSaR+CFDlWlXvJJdGlFD1VkZ
 aE/R6LwYRlXm+HakA2tXxjnbAf1e+3MKgwETR/w8S+YXHTQGAy
 D4sudVH7NeFvyG1R9d9k/l7q1C2DPl4rm8oNNU2B67J+kgy08Z
 l8qZ7TfoKPByuVY65XnZy/+EGxNmASzZ3wl/dnw43NwbR4Jbc7
 gy/l27pdDNqlkKD48PerftOlUruNlTJFStNumZF+3hBwXGQgpv
 ugmJFe2Nh+yqFDkEj9YCrtNdtwck/Nu5N5/Fy9wO5XRT8Lwr6+
 r/v+9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 03:29:13PM -0500, David Miller wrote:
> From: Thierry Reding <thierry.reding@avionic-design.de>
> Date: Mon, 21 Jan 2013 11:09:13 +0100
>=20
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
> >=20
> > devm_ioremap_resource() provides its own error messages so all explicit
> > error messages can be removed from the failure code paths.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> This won't compile if I apply it.
>=20
> You really have to be clear when you submit patches like this.
>=20
> Since you only CC:'d the networking developers for this one
> patch, there is _ZERO_ context for us to work with to understand
> what's going on.
>=20
> You have to also CC: us on the other relevant changes and your
> "[PATCH 00/33]" posting that explains what is happening.

I planned to do so initially, but that yielded a Cc list of 156 people
and mailing lists, which I thought wasn't going to go down so well
either. In general I like Cc'ing everyone concerned on all patches of
the series, specifically for reasons of context. Some people have been
annoyed when I did so. Still, for small series where only a few dozen
people are concerned that seems to me to be the best way. But 156 email
addresses is a different story.

Either you add to many people or you don't add enough. Where do we draw
the line?

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/jgdAAoJEN0jrNd/PrOhetQQAJ7YTGZWK9SThwX+tLwCJYm0
HGCA0iqQHN3BQKWtthOweYlqi7cWiDvSabKuPzPAIpdGbIRMuhdL3eU9O0d6ixoD
R6mPhbVBVIL/bGxAgfk6g+lZpzmuPnmw1Ey8DL/H4voOIrSK5tG05LZRUxTkVT4u
2FidzNE8xIiVYrkH0kJSGVe8ZdalM5nGmVgd8vsAJNoSl26co7/rHTI7APQrdC3w
4u+fkxqxgPsNzFzhzaHL88IhYTM7nKAo22w/QqM7puZg4sdtwKOwv4a4jzAmgLNs
0xOcMXojDIlsSLAUlvAU3LrqPj7DC+M8wtjtBiJnb+bMOsoyvhWiC3LzOOi1moqx
2lJge/7tV4EAj0HQgpYJtvSJMsz5wShgH8vFDgRCXPekvd7kHXmCfb6P5Rm4US/E
pCoWA6Jgpb5kDL9Vid0f9DLeXOF4/hp8JkzedAiTivJgIsbhc7glL4ioxz7M6d/B
tIXouLQ1nhBfGJ+8cZLQzD8C9GaArDIHbA0EArHdu394eP15gxqzbHhaVxf0nc2O
hNAYykp0kzTToCp1v3bw6bLmHtqMv/7bGKEURRX1Go+SQA3Ew9KYozTXRxrlRJ0+
negtlgcspRJnPHNf28d/pL6FpYr0jAn5RN4QrcPmw7HATT6XJ33yqwZXRN0dlPIi
xiQwvgmsCxxuwpQ8yZ2W
=gLke
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
