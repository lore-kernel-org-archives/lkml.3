Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaKGLSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:18:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48396 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaKGLSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:18:11 -0500
Date: Fri, 7 Nov 2014 11:17:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Message-ID: <20141107111737.GJ8509@sirena.org.uk>
References: <20141106160241.GM8509@sirena.org.uk>
 <1415291985-9784-1-git-send-email-peda@lysator.liu.se>
 <1415291985-9784-2-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YE/X56qLfGGj1U5i"
Content-Disposition: inline
In-Reply-To: <1415291985-9784-2-git-send-email-peda@lysator.liu.se>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: tfa9879: New driver for NXP Semiconductors
 TFA9879 amplifier.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YE/X56qLfGGj1U5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 06, 2014 at 05:39:45PM +0100, Peter Rosin wrote:

> +	{ TFA9879_MISC_STATUS,		0x0000 }, /* 0x15, read-only */

The fix here is the wrong way round - if the device is reporting status
here there should be no default and there should be a volatile operation
(though it's not the end of the world to omit that if it's not used).

Otherwise this looks good.

--YE/X56qLfGGj1U5i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXKpNAAoJECTWi3JdVIfQOfMH/3Rcmq4rTffISiXF4knH2N7l
T6TJ13rGbzTbQ6dgizwKaiW0Vkd/duqolS89J5AA/0vee5FFmbw86QV23ZI/8aoZ
FN+4tJ4Hr+613W5wiwhnEdYo9W4UZVtpXfVpBzG27sWeM04H7Kl4mTojgxMB8kSp
YJlmryDnzrfeszOBgLIINnPTe+XO/bVUJq4CMKgffMOHaFXWGDyHusvgKncZGLTk
m2asdzvoFWr/Q4wNhy7iGAJxJ/Qo4foyvtUI7GxRqzGfqDKP6UbIdnyE+CpT4T0I
LekWxhuD0r+qK5Adbyxpq89pKej/6i6Axy7UKy6lk/fPd2pIO9FlqwtKcdNCF9E=
=gaUC
-----END PGP SIGNATURE-----

--YE/X56qLfGGj1U5i--
