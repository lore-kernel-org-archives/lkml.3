Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab3HGJi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 05:38:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56107 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab3HGJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:38:55 -0400
Date: Wed, 7 Aug 2013 10:38:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Yunfan Zhang <yfzhang@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130807093831.GV6427@sirena.org.uk>
References: <1375836970.4861.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BcZrms9gUsdgyR6a"
Content-Disposition: inline
In-Reply-To: <1375836970.4861.2.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fan53555: Prevent multiple include of
 fan53555.h
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 07, 2013 at 08:56:10AM +0800, Axel Lin wrote:
> Add define for __FAN53555_H__ to prevent multiple include of the header file.

Applied, thanks.

--BcZrms9gUsdgyR6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSAhWTAAoJELSic+t+oim9PckP/3fSrgeXaepEV8By+3oQSi2X
+GYjNkC2taNBwai/Fwdk7YPXMPXEBs3fhsXgtQ0GmLMfzrkmNJAorebHL5lAfNjS
4vBGbL9XGRa9kvy1YQUxqwxmhRd/McGsHaL5I4lcLgdaEqlkOo8Jr8z5cTjz3m/O
kd6Py+zkZA6pLgIFX7bC/BOKMLqllKqJK+A6H8he/uJb1g5AyTSfhuUOnuDQTSIU
d/gKKL977bnE3/YqHZAH763FCwc2XyOh++KmDUcnLmMFKdyqHNWtI9OQCsnn7GZl
RSW1Sm9A1/Ob3GBCIDU9q6nrW6zIFxqH3dNuw7LXiKT/cO0bp0+Hwz6/e45u2mBM
qatxI9hnFQJZEujRZfUO2+wsfhi7P5WauG3o/Eb1/pQKf8ioG+Y3362NEU1WIUFm
W0hmcXgUGV9AYsA6B4QD8qFIko1Un2akY8zkbI0WO/iaHthSAEGeP9UrqwZfQLH2
KafNAkdUT4AcWvPjcmyijoXEsC6U66ri6upDcck+kRJ2xhpC4xaXJ9RSBZLFwgtQ
pdaW/zH3Rlp3Lvq+UwKtJsPXdxXChHocPKocgJZdKmuLwr3rf7DLawtk4ta8X14J
ICbwq+jsM/5fiSq7bFL+NivaefA2LmBeIazE7pKE0Hhh7J9vi+weDHcmhLx7+Cug
ugK+2rMVFzOrlpG+pBlu
=Bj0/
-----END PGP SIGNATURE-----

--BcZrms9gUsdgyR6a--
