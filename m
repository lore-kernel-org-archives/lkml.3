Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966302Ab3E2TuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:50:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52409 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab3E2TuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:50:10 -0400
Date: Wed, 29 May 2013 20:49:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
Message-ID: <20130529194950.GC5180@sirena.org.uk>
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org>
 <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.128.126
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 21, 2013 at 08:36:35PM -0600, Stephen Warren wrote:
> Fill in the recently added spi_master.bits_per_word_mask field in as
> many drivers as possible. Make related cleanups, such as removing any
> redundant error-checking, or empty setup callbacks.

Applied, thanks.

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRplvbAAoJELSic+t+oim9NcEP/jQlSi4rxx6f/33hz3GTb8tO
uTl1q2uuYT7AotzGbgFYX4Vjbuc1qqWhJ1wz2HKQd09/jHTqixQric/nrpai5dee
SeWRbeiyxaBdNt2oqvQSbOrr7CLP0E/hShZfSL2jPYWHXh40KY4ncYE0XLkws9Rt
lVBJHs5Mcy+IPGWkTjb4q9aqZ24q9w63k6t31w2/P3EQ9uyZvQ7vxV9BZDN9KYIF
hcn3SZTkky/iDdES0M4EkjxyZfUM1ppiu1YVClnFAMZrshWQR/k6tHW8BnYLd5vX
A7vcpDATs+3DQlASykuePV9eBUrquqFtgS1Opz8rdoDbROFmMJZWZ9mR3n19nIad
9j2JxRenyPRgLRx2iyeNyOuYxVT14RITQFjDLaW2LIyNaUqLofrZqOd6YpSK7wHg
VxV9DpbFh1rNmkpf3/n1h0mHMCBjNzDlrY8/+G/S1BH6upkITvABoTxv9B6bT9WX
KHoqADGqX+4Zmp6l016zdcfHVusopQvi40T/lDFO/WJd4GHl6qxoJx+ihy3355ms
xOmDoYkbkoo2pBjphvdPa7qSuBw1GogcA6vSpAjvRezbaNO0Pw1OfbzvQnhV3oHa
po0+5xoogSy0p0nUnVfSSLrYHCCEQaM1s1zNuVcu+c7k63fYKfGUArjq9g2f7EjS
DAcs47oR9c7WPRU2JOPO
=yEGr
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
