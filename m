Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3IZLKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:10:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34383 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3IZLKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:10:02 -0400
Date: Thu, 26 Sep 2013 12:09:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: t.figa@samsung.com, s.nawrocki@samsung.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, t.stanislaws@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130926110938.GL19304@sirena.org.uk>
References: <1380038866-1861-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+jEI8cDoTn6Mu9E"
Content-Disposition: inline
In-Reply-To: <1380038866-1861-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] Spi s3c64xx fix for s5pv210
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m+jEI8cDoTn6Mu9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 24, 2013 at 06:07:46PM +0200, Mateusz Krawczuk wrote:

> Replace all symbols by simple dependency PLAT_SAMSUNG.

Applied, thanks.  Please use subject lines that fit in with the
subsystem.

--m+jEI8cDoTn6Mu9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRBXvAAoJELSic+t+oim98KQP/20SL7SNRTsS92kLyERshYnh
iyG+2Jn0f2QhqtC8FGV6WrEURG9h93PlDGfj/9lzraB/YdzBZd2lf37rraZn8gRd
UuOXXhAW83gN++QlJO/qdppj+6FXDBrtrKrPavzvllZgweDmFNR+zn3zDvTBj3fO
YiexGUuzKX32Cd6Tit0oKrm9Q+8/Sl9pGNCtj22WKifsEOFpOKlotio+/VeDwCNC
j92evSXvViBbBKEt0N8f5pkL17D70C3nbkAkMwjXkCNo3H3nkOHjYmhr/Mycvh1N
OtZoNPKgoZzBTj9FRbKNItJIv43b9tM6CcGGLS1JANxIHYE0wYii8qwtaOKgFnqr
APwt8+xFqEYtquNNxG/VnzAxaDOO+LeIcoBBBo8g/PdtiNHxT1X70UuT+YpjGfxL
u3trq4/qN/GJhAAcP0CwljRrWUgurGCkSPTrENQoPobAlUYItPskIQiYrvwmEIsg
AMhpVz/9h0NI23oa9iUPyyXvc+tmCppF0Juu2rdqP1uz3Xt0qCk/1e0terTbWux8
Wiq7kiURYNxUaBF67iUEgdoYbQD5p8RhFzCcNP7Jkg6KhUJtRfOMsy2+567br+GI
8tfQiaV05bw20ec8PAOnraWY4t9tAS+NnsI4rUQ/nyaF/DefEHDt8yHg7bKHS0NK
ucLtb9+qdnSt35hJmJq/
=3ETB
-----END PGP SIGNATURE-----

--m+jEI8cDoTn6Mu9E--
