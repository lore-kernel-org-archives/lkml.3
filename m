Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbaAHTIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:08:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48915 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaAHTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:08:04 -0500
Date: Wed, 8 Jan 2014 19:07:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20140108190758.GY31886@sirena.org.uk>
References: <1389201738-31406-1-git-send-email-lpapp@kde.org>
 <20140108180747.GT31886@sirena.org.uk>
 <CAOMwXhN8x0xHstrwsrxqXoE+n19TP=r1HJDCFOHs2O024HaY1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UrJM+AaNQ4+/7DE/"
Content-Disposition: inline
In-Reply-To: <CAOMwXhN8x0xHstrwsrxqXoE+n19TP=r1HJDCFOHs2O024HaY1w@mail.gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] include/linux/regmap.h: fix a couple of typos
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UrJM+AaNQ4+/7DE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2014 at 06:59:57PM +0000, Laszlo Papp wrote:
> On Wed, Jan 8, 2014 at 6:07 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Jan 08, 2014 at 05:22:18PM +0000, Laszlo Papp wrote:

> >> - *             (eg, a clear on read interrupt status register). If this
> >> + *             (e.g. a clear on read interrupt status register). If this

> > This is somewhat outdated orthorgraphy...

> Pardon ?

It's not that common to write it as an abbreviation (even though it is
one) and for some random reason you've decided to drop the comma which
is standard.

--UrJM+AaNQ4+/7DE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzaILAAoJELSic+t+oim974EP/3nWtAv2qPu/f2xlyDnyTc0P
u6JjYWPLRIGMK2F3o7PnHWC6td8Sx9PJKrT6mnFp+AJvXnCeBJsbCan3Qo4qR7/0
YWIUF13IU/BQ5GTj8f/6coTAf7R1uA464IQ+24CS/LWyaThWx4d9e3lRGnb4FJ7q
2Og12k5tqx7PUMSWu2E1kJjKP1Qc2/FzGitoc/InPe07qXJw2OAkScaBf3yADiDF
+PmVv+X4Mh2LcDOEzdmaI8fyCD2V/bONVH+Nkm7LiEhLZGMCvn+5y1i5X3r0G+61
o3ZyerqGckmNXVVqTN6yhnn0wDEOxtoQG9rl/1pQYJpcezDbU7nYqGIPIAkkrvQS
51rmOEuhl6w5crmMZktEtMhd5SebEYRir8duCUQrwYdEwkaopBAFgz7mIa7t0Q8N
8PyS1GwSVHISfH0I/koox3Hvo/ibcXC7ijwE92+Ib8Mu+IiKR5SNIwimwCCftINY
f2PZa9acH/30pRcgshxMpRunORhidITg59G3yeYmaT8a9azjmFORge2YpBAS01Tl
22mE7W7psjiDIG/SIoKCjH+Gs6eAcCnsccn/nU8zw1ixqjbvru57v+VlLzE93MEi
i7CuiQQ5iao9nZNx1elCy9MKsjuxdbDqC9cyNWxksMmHaGq0gVD1xFWGGEhE4vfK
anwnrpRumKjqn+ZIfJ4u
=+C+e
-----END PGP SIGNATURE-----

--UrJM+AaNQ4+/7DE/--
