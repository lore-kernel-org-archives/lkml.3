Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3KMNdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:33:52 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50373 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab3KMNdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:33:50 -0500
Date: Wed, 13 Nov 2013 13:33:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Message-ID: <20131113133320.GL878@sirena.org.uk>
References: <1384329748-2897-1-git-send-email-gerlando.falauto@keymile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6CXocAQn8Xbegyxo"
Content-Disposition: inline
In-Reply-To: <1384329748-2897-1-git-send-email-gerlando.falauto@keymile.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: spi-gpio: Add check for cs-gpios dt property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6CXocAQn8Xbegyxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 09:02:28AM +0100, Gerlando Falauto wrote:
> The bindings assumed that the cs-gpios property is always there.
> However, a single SPI device can also work fine without an explicit chip select.
> Use the SPI_GPIO_NO_CHIPSELECT mode when the property is not present or invaild.

Given that for most systems a missing /CS would be an error it seems
better to add an explicit property to enable this in order to help make
problems with the more common case more obvious.

--6CXocAQn8Xbegyxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg3+dAAoJELSic+t+oim9myUP/2pPxxfQwVev85qb/DR/RQMm
2vsHXdhHEPfkU1mYJMFgF824mzQuyDVDU1GM5zuj0bHHelMRvUKKDfmYSd/trHsB
TY5c/STAlMW6R8vtls//UOzJ3EF94QjhKc/094MsRJLayDMRIUGDeytt8pYOpWTK
lAMi8x5fJ+GvX+OY61kObnXTgFS47KqsiFl4xedSoyTZ71JyFXywjaKsTqxtVcvk
ZYZdtmyn/LJ4JkXi5/8iq4hq9qjSnhed9M0+dYqe1tIuA9To+F/E6WD8rREuaw3+
ynbdb0RrztWa6US3SPbVG8QyTp9QNWUlbERkaz4292j5unDoqjooKT0QOTQ7yHc+
3Bvn9MVkG7AyVEcM9okhKpkvsRcDSeP0LdFfQWmIEw/R68gW5oFdbDFT0B6AfChb
VsDofY1rxq9sMc39R11c/zi3CzMPLawoW1Nn8+EdD62wmuDG/CQnYdAim+qOcAFN
WUict+Nd7vrqe2pbnhB38PWHj+mY6RYMboVoROcTyUDOFkXx6zKOqc/IagrftUS/
6nUFi7hcGgsdnxb0LvWivNx3aoqKupGzHgcjHV8ZqYJReIDDfJDY7t2fadLvIiKG
2ShwfyXRFPggNKzpUB6TpDKFpWdm0JnSTiq32GE2nbSgX+zsJUnE4P0awh+NwLTg
PCazyMqM6/jnBbrIVnKW
=/hKf
-----END PGP SIGNATURE-----

--6CXocAQn8Xbegyxo--
