Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbaIIPWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:22:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59336 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaIIPWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:22:48 -0400
Date: Tue, 9 Sep 2014 16:22:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140909152225.GB2601@sirena.org.uk>
References: <1410268670-7132-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g9DrFxK9lbE4xtT+"
Content-Disposition: inline
In-Reply-To: <1410268670-7132-1-git-send-email-stigge@antcom.de>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.152.174.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] SPI: Fix error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g9DrFxK9lbE4xtT+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 03:17:50PM +0200, Roland Stigge wrote:
> This patch fixes an error message typo ("not" missing).
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Applied.  Please use subject lines matching the style for the subsystem.

--g9DrFxK9lbE4xtT+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDxswAAoJECTWi3JdVIfQctYH/iwdXE0hjzYvsNNyB8dOJKAm
uUGYkzEcOi1UoiOwNRXjFnGD9ea42bdWjpAHA4zJTmm2M6XkZLSfbNUmSgQ+ZGCm
jOi05D6S9cAg6vuhxbXQhOK3P3GDsQ/d9/tUn6l+B0PRi+h1dZ4DpuNxYXm00ClV
iN9+iqWaLUWcRLsNBnsM9lDRK/376fkh2cKIc9XiGL4kFDkpDwWcMh/e83/JMJdr
DUPZ4QwUB7yZg356aj+jBQDqZ/fbmke91b8dFnOffsvefpdyHbcoTA0wu5qZg76G
RHwjMpO4k2hjtPJ12/gIhr4lYvO0aTn/oNOQ8VUmFPN195pQvBvyeNZ4rOiqbKM=
=1qxA
-----END PGP SIGNATURE-----

--g9DrFxK9lbE4xtT+--
