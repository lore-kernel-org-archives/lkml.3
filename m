Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaBTKyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:54:15 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47169 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaBTKyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:54:12 -0500
Date: Thu, 20 Feb 2014 19:53:36 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220105336.GP2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-15-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jpKxKsfdg3Pqjqs8"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-15-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/17 v2] ASoC: pxa: corgi: Update locking around use of
 DAPM pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jpKxKsfdg3Pqjqs8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:25PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--jpKxKsfdg3Pqjqs8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBd6tAAoJELSic+t+oim9nIYP/2xqaGUILXNSeOgq3fuAyAXs
tPgQkUUlrvJ8HwG+J0CMsfBJwVXShL6xt9aqf81uazc+iW5gciCq9+G6IafQH1sR
QVImeMvc7+AKVxrXKt8yI+rrGLpm4VohIEikCR5iVfi6QVW6MmG11YtvSlUqXtOD
1NO9q0ZtcpJoaUZKoh2SCID64urTCQrmuH4uMSP5Aurtc/oMaYX6UbZSYWi5Q5eG
ePD9Hg5mm3ArwPuyV73yggzSYRcd6LzpLJqr52a7vAi0I7bYCoz6LQ2MlFBmypGd
7pMr5vV2PsbkgScYu4hk94pl3YODWHiHEgKj1E9Y6buQLn650qa8vI3qkub9YDb3
9dk+xL5pM36OpnPxO3mBbxBMFoeNKt4mfTT6yxECtXLq2pM3HaXP3NwzsNYriApB
8LPnjiSmioYA81UTqk0N/BWVAErMyfque/ZvbQERmr9mPJ797/Z3V2s1EaHr3P6Q
aUNB5zMpKndW04FNPu0/KXYd5grtq/n8pqYx3cKfAYnwyz2gen3ZAVGnNUErbC0R
l6SHNm8djMym+5pqjVNfvQu1/Uvp900D/nFCJF8E1sBbP4La+BE3TDMxClZ8OQ+r
xKm1TI4MYgdiuvj+E1OvSTR5LB9oxGW40iyfajeAJtQYUqLv7nkUtLfvhcsHaBsA
Z/KK2NUqyh1EfNgJGOnt
=QCds
-----END PGP SIGNATURE-----

--jpKxKsfdg3Pqjqs8--
