Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3FAWSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 18:18:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39903 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab3FAWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 18:18:20 -0400
Date: Sat, 1 Jun 2013 23:17:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Message-ID: <20130601221732.GZ16790@sirena.org.uk>
References: <1370122020-18686-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RGnAp+RkZMffi58C"
Content-Disposition: inline
In-Reply-To: <1370122020-18686-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next resend] blackfin: bf533-stamp: Remove bogus "||"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RGnAp+RkZMffi58C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 01, 2013 at 11:27:00PM +0200, Geert Uytterhoeven wrote:
> arch/blackfin/mach-bf533/boards/stamp.c:545:2: error: operator '||' has no right operand
> arch/blackfin/mach-bf533/boards/stamp.c:662:3: error: 'bfin_snd_resources' undeclared here (not in a function)

Applied, thanks.

--RGnAp+RkZMffi58C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqnL5AAoJELSic+t+oim9S6QQAJgQVrxLpba2DW6R20Rv6zYv
LmHCu/sobjw5h0/aRRW1VB5oVqgsbYVVMv0lQcIVrVYf7ZJq2qjZGv2BMCE/z6fT
60R7T2c9VTLrJAAFVLSF02ivjIecn2t7oBI9GYr9CdoffuYFRAnTfgtZJwDN+y6o
Xj+McjhbD/E1UoIRNL20KQDSXTiWfoK553Yq0SmK5Z6T6qO+wapwjXIyEzwW1JKR
UVKOK8SmwNCCUHVdES2xsHTLXVmeiaUleqMGCkGKgUB7LHl3oERLADl4IFCM6++l
WicKnSBGNqi1N5AwoSMNXW5J6gj8yl5XiSl3f5OQ2KnZWYC7Vsfg2sfwmGnCmnY6
zqe1iETQGbhpAT3ho3pgwh9/jM0AVl8TDPYz6H/dgq0bJ9wUDLh9gdSQatGi2g0Z
/Lvk3m6SQUSKxf1lvI1NuxozuV3g1nLtE9l/KeKUYjzAnCS77UfcrnPKIEZELEXS
zIdxxMc9s9OHFKG+otA518JFQ54cB7aAoIHdgDWJdRZMzUHPp+4WSFMiWu5dDPTC
v1ug31mJD+lyrewVc8nJ3BgI5/c/6bufIbgDoU0RKf6sDK9vvpabgLKo7s7YfZCU
feHzmXEZBVRLpaybTxgmr2H4i79YFTbaTJCka3JS1Wm3fqoSVzqkvMVtZOPy9FEx
/MRhUprd3w4gA87Rn5mp
=CyEu
-----END PGP SIGNATURE-----

--RGnAp+RkZMffi58C--
