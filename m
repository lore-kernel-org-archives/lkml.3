Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaFUVK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:10:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52730 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaFUVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:10:27 -0400
Date: Sat, 21 Jun 2014 21:54:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Message-ID: <20140621205435.GE24291@sirena.org.uk>
References: <20140620203858.GA14718@himangi-Dell>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
Content-Disposition: inline
In-Reply-To: <20140620203858.GA14718@himangi-Dell>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap-uwire: use devm_ functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wchHw8dVAp53YPj8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 21, 2014 at 02:08:58AM +0530, Himangi Saraogi wrote:
> This patch introduces the use of devm_clk_get and devm_ioremap instead
> of the unmanaged interfaces and removes the corresponding free function
> calls.

Applied, thanks.

--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTpfEIAAoJELSic+t+oim9tWcP/3ks25sQZDaskKbXtGfrrbc+
2juowYOME824rs6dx+tXKs1fY8iA9VZSAHEtLkgXQgoaC0Q8MPcgRGmZeJDxyQKb
8Xt7Qy6AHbWwbWP0kNu6SG63AgI0l6ggsxQY/FSztFmHHKURcPlJjW5qQNmWcHI5
CdXHsrpCpJt+TVp4mwqUZ7dAwppMxw2On0V7D0c9Hu5G9ROMX7FN/vABYjDBQ8Cj
MOk8NLe2FG7snCtVKeXj7aN/eO5kR/SSoiIaidQdW+xGPF3qSV+aOGpPfSEQ60N7
XlutpZWOF1H6KA9CENdz49yqForeSin1yQfuyxaWs3riYgzsZbVrFEV40Ka4uukE
FrAE0TTAlSrdVs6rgk2kjOmnPWo6vct3QfWBlint95/J/ATJeNAPljXbAcZiabSm
WvCTQ23GBuMTKqMghIbqZ8tYFo5wrkEvZOkWrCtuzGboHS73V8mBcZe+JecOTzfz
/a3grLPNPw2eE8714KjfKaRN1TgEhrZkKnf1jUBya/F3Ol0j5bySuot4Dasmhxmi
2SFXEiIJtzUU/6d8GoDc7sUKzUl2G+fB3MkCqdCKSJH6Zb6hjhhJHTwIBVFhuaVK
IkskFoi9jhK6iAdJOaL4UL/8Ehdgi+hsUmsEMFlzjGgfZdk9czoNkYIkeAJQgxFO
nZVysLYUH73qCFJKdCUs
=x9v5
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
