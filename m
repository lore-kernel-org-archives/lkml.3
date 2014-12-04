Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbaLDWsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:48:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48590 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbaLDWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:48:41 -0500
Date: Thu, 4 Dec 2014 22:48:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Jiada Wang <jiada_wang@mentor.com>
Cc: timur@tabi.org, festevam@gmail.com, lars@metafoo.de, arnd@arndb.de,
        mpa@pengutronix.de, alsa-devel@alsa-project.org,
        Li.Xiubo@freescale.com, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, nicoleotsuka@gmail.com, tiwai@suse.de,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20141204224829.GJ11764@sirena.org.uk>
References: <1417499707-3125-1-git-send-email-jiada_wang@mentor.com>
 <1417499707-3125-3-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MzdA25v054BPvyZa"
Content-Disposition: inline
In-Reply-To: <1417499707-3125-3-git-send-email-jiada_wang@mentor.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: fsl_ssi: use platform_get_irq instead of
 irq_of_parse_and_map
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MzdA25v054BPvyZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 02:55:07PM +0900, Jiada Wang wrote:
> Use platform_get_irq as no mapping needs to be done.
> By using platform_get_irq, driver can avoid to free IRQ manually
> when SSI driver exits.

Fabio sent a version of this before yours so I applied his, I think the
code is the same.

--MzdA25v054BPvyZa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgOS8AAoJECTWi3JdVIfQ3M8H+wSnaBd8ZqS5scwBA4+nuvOt
Nav08xc13F8K+uyfeIXk0a765aXfhLaMsJXesj8hotgxVb3SEoXOc/EMjvYEA8ol
/+ZGTQISUibE1IA5c5N+eN7duVGEC0H5hM5DwL5VSfM9tNHFKWz1B0yrJwYOj7i0
9wy9oZhymbTYb5jTtlIeRfkg0CUUM/LS8Um7PTjvsfxZEWodYDnZdSeGaWfimHV7
2HeR1XqXTWx/2zTCnZx4pPWlyDNPkEjim7sN31jOMazUDzkxJ3XfhiCPARuDivnF
Lskgc1qbUSnJm93S3rbgA8yZhCn8EQ+ybQu3Krk5Ix60fxWuJVG4N8a0yZa+Iyw=
=a+Pl
-----END PGP SIGNATURE-----

--MzdA25v054BPvyZa--
