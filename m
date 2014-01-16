Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaAPOMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:12:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55708 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAPOME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:12:04 -0500
Date: Thu, 16 Jan 2014 14:11:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lars@metafoo.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140116141148.GH17314@sirena.org.uk>
References: <1389859684-27456-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="poemUeGtc2GQvHuH"
Content-Disposition: inline
In-Reply-To: <1389859684-27456-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: core: Fix possible NULL pointer dereference of
 pcm->config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--poemUeGtc2GQvHuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 04:08:04PM +0800, Xiubo Li wrote:
> Since the soc generic dmaengine pcm driver allows using the defualt settings,
> so the pcm->config maybe NULL.

Applied, thanks.

--poemUeGtc2GQvHuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1+ihAAoJELSic+t+oim9CikP/1oNK1e+eBhQ9o/T1mBIodH2
56C9jY1ODYITiKgNY2mtZXagqNBT/PjX9xl1WDq4HrnrvbhNeQstfkX+M2KV/5XU
hbBv5rEpkOGJmT2T48+Pda+yPL65Oy7ELmzbGD1+jdjFy0oRWo+Vi3HP5+Bo5ROQ
FS6oE8rzfsCSkjrantfSbdaa36i9SrVuvYaVZFps+213Nwr4pYuDl1a0AK5rq/DB
EYRdynACum1VAgnKCHKC7exkr2uVWH0VtgaZpZ6DSxSaSBLaIOzOOh/eDXsA69Bb
q+J8UheQ6I2xq2WH8YT8zW+8LLztV8g1zrorlacfczWwVRyDR12E0oDLmmp8RD4Z
jBaSY12eXWhujWJnhOjhYI9GqHhv83nB0WlnBkZTOslW3bhFfQJPYKh3VhfpmCxG
o/e7bMJCBTsMqYQ+ztwS6V2hjZVIFhADKlCNnp0cGvRi3SrXYKxoXZn8KCTncIOm
b29gz/7Pw5TqZKtOvFv4sHDubWkY0HtPjCF7ONb9zfw+qLrVCWccP1LXv4kwGCo4
TIeCRJpSvoXuqRi49aUGyGrWsgkJdDHDQ53FaqknB8TvMFGSjH8WyjxOfC4Dln1R
tw0gYpYzG8ftw9Fv9avcjok+gvWdTH3ie670xjkZsZDl2/ePWgo/TCgxNU2LUgWA
Hz3R+9EIKGBiVvtx5kfE
=X34d
-----END PGP SIGNATURE-----

--poemUeGtc2GQvHuH--
