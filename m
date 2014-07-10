Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaGJKox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 06:44:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57052 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaGJKow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 06:44:52 -0400
Date: Thu, 10 Jul 2014 12:32:31 +0200
From: Mark Brown <broonie@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Message-ID: <20140710103231.GX30458@sirena.org.uk>
References: <20140709212112.GA11848@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GXtmylMy6DdaH5oR"
Content-Disposition: inline
In-Reply-To: <20140709212112.GA11848@himangi-Dell>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: omap-dmic: use managed interfaces
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GXtmylMy6DdaH5oR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 10, 2014 at 02:51:12AM +0530, Himangi Saraogi wrote:
> This patch moves data allocated using clk_put and
> snd_soc_register_component to the corresponding managed interfaces and
> does away with the functions to free memory in the probe and remove
> functions. The probe function is no longer required and is completely
> removed.

This doesn't apply against current code, please check and resend.

--GXtmylMy6DdaH5oR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvmu8AAoJELSic+t+oim9FugP/2GyegUIrlgk9vGDleDPuJSw
+tD8dO+SXOU8+C/+CEJs+QyDa4gJ904y3UszHMLD0pUFXxjQWdZawb46SYji9EQ1
FOK1FCdhWe0vUcYti6e0Ej1bdO0lHvysFzUwhtEMFpzHTwlcRMkPRV/vY5+rO1vb
nTCq577Tw7jLwfnM3MxWE71FqLWGqPRbgRfTIYZSNqTkTSHZMjGMKbuUcoCti42e
lYZbPH5s45g1zMXV8hbuR2U3NBJizdh8Ps/c6H6YFxmtunkWtXoL+lJpolyQbOeX
EFuKDu0Q2sUOXzsn+StBHrhBMFfACy9kaw4dYTAtbSe4VSqwsPfhgNuj28bcjvS7
yAQJRIn1u1Hh/knKfatsnjGCUry8+ugXXonMpmy1ipLuMmPSpq9I1NBkS4Lubmal
PFiXEubflX0KHoNSoVP9jy6I9Ep3a/OPbrw37F7pJEVzIuMoKVGFmHna+K1+ORDA
LQaKcEPRHAjjz+1dHS5SHRLgg6zEYS16hKEyL+WKpQRa0scH1uL0+Clff4oM6JQA
FqNy45f1lCuZce30JG8LyMCOKWXDeYK+pW9lKN1mT0PYRaUim2DvMpGDY0HprC5T
XlkPYcYOKw82NcGh8z/u26X3H6uUY0KF/OFO+pm/K/bV5RQNaMKO7ReLJOJlB6Gs
B2UqwJpS7TKecbwMdcTi
=B5i8
-----END PGP SIGNATURE-----

--GXtmylMy6DdaH5oR--
