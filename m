Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaBSE04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:26:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58047 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaBSE0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:26:53 -0500
Date: Wed, 19 Feb 2014 13:14:28 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20140219041428.GS2669@sirena.org.uk>
References: <1392777974-26254-1-git-send-email-festevam@gmail.com>
 <CAK9yfHzaUhBTooqF8+ywGgAS4kob7MTxOv0ncLifmYws0crpAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V39eZ3eeYcE7QFDY"
Content-Disposition: inline
In-Reply-To: <CAK9yfHzaUhBTooqF8+ywGgAS4kob7MTxOv0ncLifmYws0crpAA@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.132.247
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pfuze100-regulator: Fix of_node_get() parameter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V39eZ3eeYcE7QFDY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 09:02:52AM +0530, Sachin Kamat wrote:

> There are a few more instances that should be fixed like this one. How would you
> prefer to handle them - Resend the complete patch or send just the
> incremental fix?

Incremental fixes always.

--V39eZ3eeYcE7QFDY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBC+gAAoJELSic+t+oim9g2EP/jGRXyKV82wM4d2kbkl2/aku
Hi+UGC3EStOYAXgttWpCITulz1JNF+OsK+1tALwVdR9uSQ2XpIeANX8PaZxrTkaM
Nnwf9T20wpNHeNFf+cENnFCulAuG6dJD6p24HzvVhPdUA7j45KmZoHEcAhCFT/Nr
UfqZcR/BTRr/16fhk2nFnied06x+9MlwGkex2buJokc1DxMoG3RiLAzUFOrJnYx2
yyeBm9q1GAMTFRwS7J7mllaY0wxVTv6uYZ0M7qS8B9K0Owhv7f+V4JZrjKXXP4l6
u7bTspd0FlT1eC6lr+toWnf2pJYjqg3aVBMMbze7DiK60WSDwXDcIKanWZ3g1ECq
E+rwdQK5OIrQZaRCo7QU5ffkgerQdoKnSlGCIImO4N5hzQm/cYh+m/2DjeDQ2DoT
jML5d4TIUYBLYiVBwowBZGJWSuoT9uZzrjR+FqQWPmPZm6yOhSo8hf4AuzRZcvF1
ab6nAAIYwJxCkdHROpSDisyO2E/gwrHaNxf7taHw0C0TGh6AE18X1ROzStdIg2cn
ZjRc+U7OYM16FuPzwBhWLCyJ+F0Z1NEKpvEGKpHANGmYdhcDT9Rir4A5WzpnYMUn
/w9xUhn+9t/yexCUJojF+Wqo3RrFrGgLq7asCq4cjPZmC+aPktPdIYqxJbufoLOq
wYxgvpgu91/EVtZGnhwX
=HLga
-----END PGP SIGNATURE-----

--V39eZ3eeYcE7QFDY--
