Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3FATJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:09:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36902 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3FATJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:09:14 -0400
Date: Sat, 1 Jun 2013 20:08:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Maarten ter Huurne <maarten@treewalker.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Message-ID: <20130601190850.GN16790@sirena.org.uk>
References: <1370010975-10655-1-git-send-email-maarten@treewalker.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7VkxxUl3xUvPtoxk"
Content-Disposition: inline
In-Reply-To: <1370010975-10655-1-git-send-email-maarten@treewalker.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: regcache-flat: Implemented sync operation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7VkxxUl3xUvPtoxk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2013 at 04:36:15PM +0200, Maarten ter Huurne wrote:
>=20
> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>

This should probably just go into regcache.c as a default sync operation
based on doing reads rather than being open coded - it's not meanigfully
using any features of the cache data structure really.

--7VkxxUl3xUvPtoxk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqka/AAoJELSic+t+oim9EX8P/iqJP69144sR32KbRy9osORF
9hFxdsKXfYTEsrH9w3LdIDaio5mttW+Vkb9adSNeKNFqInNIckWsMR244hCaH4vR
I5aVpw6aYzxjqLiXaWEVQtSU0RbcMcvAna4PfokMAw+JWRuRxyNr1+RJElOT1GSX
Ti44+egGSceEcic6Zs++c7K0O23Lhhh7OClZJCcTZ8jr2Kr6H9FPiUgv0DODXWmI
ehWSo6zxdSjZYPykyAPauLtH3ISb68RU0dJAL7dEehV24fOXbURpLpyLqat5uaMc
/zUq6pV3pw5sQP+OZh0adAYAy00t4NcABOCx+qkNJ4OacvFaIHw5x3t72Nu5D50D
pKPVTSWYyrNb5ClUg1Hjr/UZUPiB/Q28K+hIkUpoPzqFbuxRRbRGca0f4FfkUd4K
GopJicGYJuzgzJ8L1UmOuUHmmavIzMqDOCaROQoEs0d1WBW8XoTe0CwNsYzdn42w
BmvDlM0hPHZqbSzZuuhDUbAiqIUzASW7jkGB72HMmxZHZLs/+7c8KehQYBztmMX6
bAIbPtJFmtVlJW4rHjt+QRPJ5rb0bn+HHJbEpUdxaeCc/VpLz3l6MaOi+gN2ENqQ
ZPmM6MEn3LpbcDuFn+sbMQ3zO1jxTJtFMyXoSEroyJBfAOvQiKXx2XXQij39BkGE
1E1atxCi8gYw8PYRAh6b
=rzfW
-----END PGP SIGNATURE-----

--7VkxxUl3xUvPtoxk--
