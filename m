Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3JCP6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55772 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3JCP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:39 -0400
Date: Thu, 3 Oct 2013 16:58:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@tabi.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20131003155816.GU27287@sirena.org.uk>
References: <1380773722-1295-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dBMBt2YGaTHbdllf"
Content-Disposition: inline
In-Reply-To: <1380773722-1295-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_ssi: Fix irq_of_parse_and_map() return value
 check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dBMBt2YGaTHbdllf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 02, 2013 at 09:15:22PM -0700, Guenter Roeck wrote:
> irq_of_parse_and_map() returns 0 on error, not NO_IRQ.

Applied, thanks.

--dBMBt2YGaTHbdllf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTZQVAAoJELSic+t+oim9JlwP/0Ala1E0M65Sn7xS/CORBpuf
/602EdUaXZGQW2x4c+WSs8q8TGjiiK+UsJiXTTgFYUsKtJnw0XRjQ3OxuO1GL6TQ
atp0R4X4mWchwhO3by8k2lonx2aO5pZdoFz4jHBBDJn7dYyjJswX3y5yaZJGYCNM
7KoV2+xv3LiKcFui3gRO7fBVZr11ptmZ1kJ+w4AGfpinFpYRmxu3JCOuLU7W8pHL
Aqi8x4aFUkeizcR7h+v6942DgWWNApkIveNavLWTQzwhtAE+wl7+UT2UUFZ2/QEs
4vwKKm0N15hr62XRh4IcT+sCSQJPppjH5BHfJnMJZBKi4elk3BEYAT8aRJnq1YW3
JTxEan2OlZ/o3XtaVR4yFhNUWRzF9DbNoIzH+AgCLI88xbAvKSt3ojVU9H0Q3A8R
GANlsuDUw2ecvrfvPY+t9UdH9HEi9ucBmD9fWEifgP200DTx1t5Nuuy/9Y6pokYv
k/bhm1gVQPc5Yuo+BAveyAFIFbnHsjs0M23vprDF4N6F/zUNKkBaa3cZrr46X+Kk
fXOY7B7jZ7vQp3rtQGDHJIHNtNyc5QknK9/3yd+d6Hu4yO0Z1k2ar527eMeXwBYH
g2BZEo5jM9z8B8WHesakmzt9GCA8stbOYhdAbuDyk6NmZQu39AnQbUmFATvZ+F+C
G/NLvvg80V2bikvN5JLU
=UWBo
-----END PGP SIGNATURE-----

--dBMBt2YGaTHbdllf--
