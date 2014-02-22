Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaBVXie (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:38:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49549 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaBVXia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:38:30 -0500
Date: Sat, 22 Feb 2014 12:10:37 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Message-ID: <20140222031037.GQ25940@sirena.org.uk>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
 <1392907389-21798-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="63aIh6YiuHX+oBFP"
Content-Disposition: inline
In-Reply-To: <1392907389-21798-2-git-send-email-geert@linux-m68k.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.4.12
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/10] spi: sh-msiof: Fix SPI bus population from DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--63aIh6YiuHX+oBFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 03:43:00PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> DT doesn't instantiate SPI children if spi_master.dev.of_node is not set =
up
> properly.

Applied, thanks.

--63aIh6YiuHX+oBFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBUqAAoJELSic+t+oim9q5wP/RpPlJQZGw/BwnnuhaNtBYrw
bDaf7lyQJ80OV8XY/EtjqKpHSLejkZhMnoxhhgBOFX5or59qEYP4WBXRwM4xt4FX
XouzMuGNJZrMevciWWaZyk36qHr/2DGFyCrYkhEUl9mHcDdyYzJIKptP4+SfCoDl
2YzHiHHFL+SxoBnNCEF3kFov9yszXrqc3kRAVaqD+vw9qODWPpdm51iLL04FN3+d
1GRJxwsKV81+CGriwhS6HyPbwwfJMmabQ7lqyEFmmVJId3q+4EYI5vxOdaE62/vE
beuictknV3HQsDgZcQCvYLlxABlJvVhjYeIksrXD9aFMiXNqJDPMxvZJE0/gsq+k
D+I9+kyDB+bkqP1fwWPwCyhFntZz7oORgFQusqKJGIwDFF+aV8xNS5nmcyDRNfYT
UKWXGZGkSWcY92EZHNaYAwa9mUxsaozEN2dhvtpnyo86LQAjvPx4SWOiqleeTkEt
xEQUgmqUGBYVGm4V0rpasG+LcHmeTNG3P9BbYgqX1rfVWVra1/rk1d0zg6/5MChU
WMZQOF94UKrevbFcAXpQZ6A6dfTElJwq6d8VVXUbfqX//ezJTolmlbygwV2qeZCq
uqDf7THBbGq4i151EdiYPtTADI+uWfknTNHkqM741YU8D33Q2mlCN2tYQVcGyxCb
VUTW87g5CRRwyxqZ3XQF
=bqtL
-----END PGP SIGNATURE-----

--63aIh6YiuHX+oBFP--
