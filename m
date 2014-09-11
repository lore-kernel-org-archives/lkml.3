Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaIKTdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:33:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35448 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaIKTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:33:50 -0400
Date: Thu, 11 Sep 2014 20:33:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        wsa@the-dreams.de, sjoerd.simons@collabora.co.uk
Message-ID: <20140911193325.GT4015@sirena.org.uk>
References: <54119DB6.8020807@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uLzYCuFow5JXEQYy"
Content-Disposition: inline
In-Reply-To: <54119DB6.8020807@collabora.co.uk>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: SPI and module auto-loading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uLzYCuFow5JXEQYy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2014 at 03:03:50PM +0200, Javier Martinez Canillas wrote:

> This can be easily worked around (and probably why it never was an issue)=
 if
> the OF and SPI tables are kept in sync but I don't know if that is a hard
> requirement for all use-cases (e.g: a SPI driver that is DT only?).

I'm not sure I see that as an interesting use case, it seems better to
have drivers usable without DT and it's trivial to do so.

> I'm sending an RFC patch [1] to know what you think about it.
>=20
> Thanks a lot and best regards,
> Javier
>=20
> [0]: https://lkml.org/lkml/2014/9/11/127
> [1]
> From a7cd35209a597a578df6c801e5ff7b63b584bf3e Mon Sep 17 00:00:00 2001
> From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Date: Thu, 11 Sep 2014 14:31:04 +0200
> Subject: [PATCH RFC] spi: core: report OF style modalias when probing usi=
ng DT

We already have a perfectly good way of sending patches.

--uLzYCuFow5JXEQYy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEfkFAAoJECTWi3JdVIfQBKMH/AvgdddkgsAuZXg0uSXksiX3
UvFMGkZKC3GPQFagIuItNqMVzR7VCNfAQE84RX7ms7tuoco07mTRj+C9rcktxdxy
qtHavXlHzRtCNIUttL4RSA9R1vLxyKj5AF5D0IsWuzetcyZ2SVF/uWUO/+Gk8hGr
NSujW8pNQLSjWp5J+3/C5cjjELhp+QHuSYB7Zyozks9PDpmKZ7lFhiPSR3TDDQ25
s7TTVWZIXmpm5Tr/agx2GuKLbQyE6oc2tSgypSPcjTmnezCeZ3ksKT3qWKvdDEyF
1wgLuNW6Iskv2YCG6w1LgX1rqZOe2vCp7uheK06fXke86P2GlieE/MonOm7AIQc=
=ysPq
-----END PGP SIGNATURE-----

--uLzYCuFow5JXEQYy--
