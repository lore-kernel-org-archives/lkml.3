Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaIHLQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:16:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbaIHLQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:16:43 -0400
Date: Mon, 8 Sep 2014 12:16:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Message-ID: <20140908111627.GI4015@sirena.org.uk>
References: <1410158617-16827-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EDJsL2R9iCFAt7IV"
Content-Disposition: inline
In-Reply-To: <1410158617-16827-1-git-send-email-mpa@pengutronix.de>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: Fix debugfs-file 'registers' mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EDJsL2R9iCFAt7IV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2014 at 08:43:37AM +0200, Markus Pargmann wrote:
> The macro "REGMAP_ALLOW_WRITE_DEBUGFS" can be used to enable write
> support on the registers file in the debugfs. The mode of the file is
> fixed to 0400 so it is not possible to write the file ever.

Applied, thanks.

--EDJsL2R9iCFAt7IV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDZAKAAoJECTWi3JdVIfQ6UYH/0BRez381R/lIBmLN/stSPHm
qMccHBfVHahVeWMoT/uXR57I0xm+PnBaPdw6Y+Z6G1utD4y7k3O+pUAb3cXwCOwi
WuQYRGhO2Znw0nmgKRh4EStLgkmzy6aUTI1VwvhQZ6Adta2UUkJknYvN62poMTl7
t5Fun9wO2N6kf/SdQrZPp+OBH8TWDBSkti6DbpHGZ3e9xMM3kx7VWAr6TUWwru7y
oY3HmRSoHQkTqZH/ICX8NzgXuB1TBAPSt/CqqbSt19Hz8n8em5PEAHdYsyQKolps
J1XQHhYvbLucCpYec4EMz00lKjVeuD1XYDQvYFyguQB2SEA43VA794TrsbfoKdg=
=3Lrv
-----END PGP SIGNATURE-----

--EDJsL2R9iCFAt7IV--
