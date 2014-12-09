Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaLIQRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:17:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53327 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaLIQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:17:42 -0500
Date: Tue, 9 Dec 2014 16:17:17 +0000
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Heiko Stuebner <heiko@sntech.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-spi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Message-ID: <20141209161717.GL1934@sirena.org.uk>
References: <2091649.zj2SIBdzpD@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7l042bGvurpep9Wg"
Content-Disposition: inline
In-Reply-To: <2091649.zj2SIBdzpD@vostro.rjw.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.171.30.28
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7l042bGvurpep9Wg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 06, 2014 at 03:30:23AM +0100, Rafael J. Wysocki wrote:

> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).

> Please let me know if it is OK to take this one into linux-pm.

Acked-by: Mark Brown <broonie@kernel.org>

if you fix the subject line to resemble the style for the subsystem
(spi: ) - using normal subject line styles really helps spot relevant
mails in the inbox.

--7l042bGvurpep9Wg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhyCMAAoJECTWi3JdVIfQZDAH/jxHEqTaZq0PSH+i6f7lKHTd
VaFYWWOA+kv50Djh9WSr8mXVKMqOPtWFG30RDRPW3aNwVguDmPgkQ5gDLBsVIxAN
GSMkMqe5+dnR7T5O6JkUIg3lEw2DATtifuX4Jv5mJpqcTPdKNPxD5HFiNpHsg3Z+
GkWeAy4taukU5J/fCf+WJOaBySnigOTfHCctD2uqMrLTo6zl9zSpI8tFX7ldRk12
E6zVNCHaexLuKpHQmuwEO3O+sQyIeQyBqpg+U/ya0DU0d6ufK45PmB9+zMmbI2OZ
V3o5atUqSD9vWw3aT6dPgsvub5Jgx0GMS7utBdoIAqevtPWRlyQ2msG1aY44Zlc=
=nKwU
-----END PGP SIGNATURE-----

--7l042bGvurpep9Wg--
