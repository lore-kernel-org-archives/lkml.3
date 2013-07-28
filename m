Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3G1MmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 08:42:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60311 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3G1MmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 08:42:22 -0400
Date: Sun, 28 Jul 2013 13:42:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130728124214.GT9858@sirena.org.uk>
References: <1375000643.21010.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+ks7CzZv1QI9FGuw"
Content-Disposition: inline
In-Reply-To: <1375000643.21010.2.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] regulator: da903x: Convert da9034 ldo12 to use
 linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+ks7CzZv1QI9FGuw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 28, 2013 at 04:37:23PM +0800, Axel Lin wrote:
> The voltage table of da9034 LDO12 is:
> 1700000, 1750000, 1800000, 1850000, 1900000, 1950000, 2000000, 2050000
> 2700000, 2750000, 2800000, 2850000, 2900000, 2950000, 3000000, 3050000

Applied, thanks.

--+ks7CzZv1QI9FGuw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9RGjAAoJELSic+t+oim9NPoP/2lO9OXLyx/NK5mAk7oJ5mbj
+4lnC3k08Ze3RKiGrQNBi1Iccu0XDzpCT64GDy7FtXFuIsUgd04mOIyawZIau5F6
TSLbNL7PRNOx5VeF1KoTaq0zMlkC/daQRZYsqX7DzedSobfNFXKvd9NSvrZokQNn
LSMGsAfP979Ljk/hP2QQeyrChV+sNUYZqq3DW+1X+2Of/H8G/SP9qNes34GIAv0W
JAzwizWscn7j9NNYwECiP3kAJ3ywvYchIRAMlJFSJX6kJkQ3xIqby4yGfzdKQWjC
wWqR7xy+EHFJYbEXdwgV2Ijht26oopoF0N9VMxFLA1LH4kp8i7UBd3t/M5g6K5El
yGcXe778VaBqPt1c9iwvHLN5CvWR6vjZEf08NylM4R9whzYsS8EDjYKrGL2IdvRw
04BJFHORHvjng6XKahUt4LJ7zEvcwpEfXmobT9IOjqdXMwqTIG1IhEQTE85ufShV
YkJiTZy9OqY0sUS5d2BMiAyzEsWX4NDI9AiHA0wOTNiOgXz0wmSPfjWWIwcwWf5i
ivEA+9czSrYsfyj7z7nSvygtVuxm8Jjda5RgBjLDKB7OhN3z08b8d6P/mJBCADt0
AIrSLXleJ8Vb548C3TXPinMoSls7ZQiSRgeZu9QqH/PE0H2wO7qVpvBJxno8oN2U
UStxkC3QCUW3P4zdLamh
=OqHN
-----END PGP SIGNATURE-----

--+ks7CzZv1QI9FGuw--
