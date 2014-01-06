Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaAFNTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:19:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47855 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaAFNTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:19:32 -0500
Date: Mon, 6 Jan 2014 13:19:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140106131920.GT31886@sirena.org.uk>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g7KorqjRHmzOu6H+"
Content-Disposition: inline
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/11] ASoC/MFD: twl4030 codec local register cache
 removal
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g7KorqjRHmzOu6H+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 03, 2014 at 03:27:45PM +0200, Peter Ujfalusi wrote:
> Hi,
>=20
> After the twl6040 codec, now it is time for the twl4030 codec driver to l=
oose
> it's local reg cache and let the MFD core's regmap to take care of the ca=
ching.

This all looks good to me - Lee/Samuel how do you want to handle this,
are you OK with merging the MFD bits via ASoC or something else?

--g7KorqjRHmzOu6H+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSyq1VAAoJELSic+t+oim96HwP/A50sejcUBNwZl8WSDw89jQu
5u1XxAiEatnZ31RznZh8LUOQ1zDAk2SEuk3fBY3rZ7/9sYHS+FHhv1jP5JwFFwOu
emfGMjcN58QT/EVkWALtMmT1M74378AFURkNnwxSKdE8Jofw5egd83vBJYBZ5+t+
YSCOG6r97lVJp/JSCt+h/7NWLA7YTz68dk5sPJgALoSjHZ1eZvhM1+e6W0eRqv1L
yjdCQDr/JQ6Xf/nTHvyApJRqZnYYgd3YadtQqFHo3ZtPyOAa2Mged8TNmx6PfmGZ
E1Oe6kbs0EXy4L5kBtHQl7NGSlkKCLqxQbmPmmLnkYbb1/EeOHaPv2I5BLD2wf1n
jubS2DVAaMyDdDfA4Ta2Dt2XI3v5xzeReG568/lAmPtAV96lrgG68kiUlOJCSYxo
i0s7DaD15t3pw9HVe+YZsOAc8mUNU7AZwZ+IYMcbJ+BSOum+WzEkNA2amh2Ghf/f
dyZKQW7Zm/QgRvnwlV3UZg//0KeLlGD9LnWlkKXWHFkLxNeUe23g6JphCqES8KfQ
6sQp0CtIbzQrefUidYA5+GZiAWwRbEDVd4aFKnhQ2lnGWHWCw0PnpO+pEbwSJMc0
KEGhYr7SvHSJc9VdA9QbFgKpupIULXq2KBHrRD+rXRdboSpEH8daHXdeAga6ft5n
HDYoAkvaxc41gcwg6OF8
=yvMg
-----END PGP SIGNATURE-----

--g7KorqjRHmzOu6H+--
