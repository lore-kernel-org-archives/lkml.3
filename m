Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3LBRgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:36:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33464 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3LBRgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:36:18 -0500
Date: Mon, 2 Dec 2013 17:36:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Michal Nazarewicz <mpn@google.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131202173612.GL27568@sirena.org.uk>
References: <1385744947-10283-1-git-send-email-mpn@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hun9kSK4g7A5t+iU"
Content-Disposition: inline
In-Reply-To: <1385744947-10283-1-git-send-email-mpn@google.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap-100k: remove pointless _remove function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hun9kSK4g7A5t+iU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2013 at 06:09:07PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> Commit [8074cf06: use devm_spi_register_master()] removed the last
> bit of omap1_spi100k_remove function that had side effects.  After
> call to spi_unregister_master was removed, the function consisted
> of:

Applied, thanks.

--hun9kSK4g7A5t+iU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnMUJAAoJELSic+t+oim9huAP/jOSBU9eTdhgqx4MocERlJH9
EmND7C7i8z+vDkueW70g4iNDHx4PvGSojCtmPVKhOw8EIf/K1OMzO0qwOdvIlaiJ
2h0soCqf21FsaxqGcH0GnT8ejQv4ryX7ghHJh7Wyu5r0dzKXLFKo9t0JdIsWAppd
mLasQFj18BiywJ+WyiSCE+Sq9dmxIATbaSHTodnDeibZkjCg62b/y3zCjmCX5lvb
+dHnMBGT1N9Mpjq66KIuRFNvQDCTYwgu/VvdV/KefyYoKQhloTdeh4wfBBgrj+sH
B4fJLyroWGbOu1daxCbuclFJfASgkp+ug+dj8Dz0ZntTCeMuU/lhnLOgzqVMecYO
4uHgxuj1/JVgYAQz8Dm06cZq6cA+Y/ZStJwbW1gzb30+hV9S37vXSbpeJDPszju+
Am7j6hIUKZTte5mC41rw2CJquBvzbyiMrmdgbOFqDzexwnLmWzMO5dyzvQd41h4z
2K0uRyWu+j0UXYa1kECirdCEP8piahrNNR+TT80UIZ3G2Ii5VJsp8eyFACxQ56Ex
RFPzacGwGBf7f3w+pzVMMw9D2eoQMJSafRi7A+QRwNJ+YXLTiD/O7vQCABEw5v2v
EJHDPozx8nXhXu+yJGGzY1HyZyd+cmZelPnlSVXSFTdHk9/LEisYU7mrhmJ8Cura
Oz2Yhm6fxah7UD3I48SU
=zNyN
-----END PGP SIGNATURE-----

--hun9kSK4g7A5t+iU--
