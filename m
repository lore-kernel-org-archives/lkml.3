Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3GKKgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:36:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43751 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3GKKgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:36:12 -0400
Date: Thu, 11 Jul 2013 11:35:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Message-ID: <20130711103539.GI24508@sirena.org.uk>
References: <1373474298-13470-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jQIvE3yXcK9X9HBh"
Content-Disposition: inline
In-Reply-To: <1373474298-13470-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: revert master->setup function removal for altera
 and nuc900
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jQIvE3yXcK9X9HBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2013 at 10:38:18AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Commit 24778be "spi: convert drivers to use bits_per_word_mask" removed
> what appeared to be redundant code from many drivers. However, it
> appears that in the spi-bitbang case, these functions are required by
> the spi-bitbang core, even if they don't do anything. Restore them.

Applied, thanks.

--jQIvE3yXcK9X9HBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3op4AAoJELSic+t+oim9NL0P+wfctQkwfoV4447DYfwQwdtk
QYDE4Gf3fick/IFMFqGuFSelPwknBzCNeNeVZVKSKmGgOpWGrlt20Fp5tXkkIPl1
mLi4wNdDxnmFYfHeCaUttYbdSNRgrTkUcLza4wmYsi+Sw7M2znK30pq9VEMSLjoc
orUjj+NvMLGbWgJJP0V/vP63op+RJBFLagbn6BRKHByvjX8ZUz1dFCYu7Fk/b5cP
iUjWtfElU9SNoi868ON3ICU+k+l1jupLaUdkglS3ggbwmxekaGxzIwoHm2vVLpR9
MLf07kVJiqBOZ/7NRrDMWcCgWUuBE3w3COUDHatKWvP0pOLPq3JEzxVkRiyJyBpr
HHsclORcqhXHoKOAzgOnONtBaSFHZpUmFUwf72VperSyOiL2hGAJb5Qr83tbaqzS
bwvhUQ1ksSjysKYpA5Z+CE+iTjYOj/P/h2j+Ap2zqDgBGKkJw+MiJLZx6BCkQfHR
9DahQS0XVeTQHlhW8xtjY0nALw+sJlJeBI6SXO0E4ZF7xsVE7Onc4+g496TY+suS
XGg+B2VTRtiAF6jyTV7asFUPVjquaCieKV8H9TfQSARKI7itxHkT76uZT/iNy+ZO
nAfDjzJwD1wHPdMhM6daDLJ6EfQJ0TM8Ydgn7pdX+j7vf4dj/IaQVjvjFeM0YTic
lCcIqQLuOmyW3707/Ig/
=SL7R
-----END PGP SIGNATURE-----

--jQIvE3yXcK9X9HBh--
