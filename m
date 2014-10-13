Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaJMNVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:21:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50762 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaJMNVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:21:05 -0400
Date: Mon, 13 Oct 2014 15:20:43 +0200
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Message-ID: <20141013132043.GE27755@sirena.org.uk>
References: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
 <1412940935-14721-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oHs6GRo50UrIH54O"
Content-Disposition: inline
In-Reply-To: <1412940935-14721-4-git-send-email-cw00.choi@samsung.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5 3/3] ARM: dts: Add sleep mode of regulator for
 exynos3250-rinato board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oHs6GRo50UrIH54O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 10, 2014 at 08:35:35PM +0900, Chanwoo Choi wrote:
> This patch add sleep mode of regulator for exynos3250-rinato board to opt=
imize
> power-consumption in sleep state.
>=20
> The power-consumption in suspend state is 0.6mA after applied this patch.

Reviwed-by: Mark Brown <broonie@kernel.org>

--oHs6GRo50UrIH54O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO9GqAAoJECTWi3JdVIfQj0QH/1HApca+q4KA4+ZB+gz3pYX2
asyLFNRi40Vj8xmglEBFL4uqBgz8g4RZnXTWqpN7Qvn3ud0pB1K7xAyJUJYYKrfB
6TjS91JQx9BAnq+IzuckxhQulNes6yDGk7TCk2GIZsME0u5wX3/xjIg0k1KZWcTg
ht7pzIAeCahf09XdEIx1G/pcLQMfwV8VKkgQfBX28hXrSBETixHJfiYW6n8fqL6n
Csa32gX+d0H1m3QucMYE4VBDlajd9P/OA6/1PZVOep2fgMUAcangr6XP+GMZ5goW
SYCXnd1GjZ2x0zGNFJfw+VJU41rGgaUqSoG62+1PBA9+S7xBZPl/oMivnFdjx3I=
=4MhF
-----END PGP SIGNATURE-----

--oHs6GRo50UrIH54O--
