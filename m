Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaLVMCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 07:02:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43773 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaLVMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 07:02:37 -0500
Date: Mon, 22 Dec 2014 12:02:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20141222120201.GE17800@sirena.org.uk>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-26-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FN+gV9K+162wdwwF"
Content-Disposition: inline
In-Reply-To: <1419196495-9626-26-git-send-email-wsa@the-dreams.de>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 25/28] ASoC: omap: drop owner assignment from
 platform_drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FN+gV9K+162wdwwF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 10:14:46PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.

Applied, thanks.

--FN+gV9K+162wdwwF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmAg4AAoJECTWi3JdVIfQPsYH/jGOqmG1m9OPV0AQEqMHx7+M
FPFUfYUrTmIIqXUdc3sjK/6ti1HsgFuoFM0BGOIewI0/xoPgwz0EVUg1JD0ohJnI
mqX3H37bcqGTL3B6aBkFBzGVodFb/I7p5KsxxgI7QKo3hoJqNoXauaUggnG8EnEc
0bBDxTyQa02AoSTxDrPM8AHqzCG0vC/2X206dWBM4RZGJvulezTom6LyT/S+M/gK
Wf1dMfMs+W6qbe1D5QtPzmRUD60WevduoH12pP0oxcE1cVhkoCYZfH17jcSXd7Hn
GvnbWhl8bixgUGbBZXxZjQhMhzvb7EpzIM0m9Jna2RM5J4zquagmSzGrZxC7ryY=
=m8sN
-----END PGP SIGNATURE-----

--FN+gV9K+162wdwwF--
