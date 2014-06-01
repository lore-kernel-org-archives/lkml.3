Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaFAKq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 06:46:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaFAKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 06:46:24 -0400
Date: Sun, 1 Jun 2014 11:46:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com
Message-ID: <20140601104613.GZ5099@sirena.org.uk>
References: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
 <1401409510-28238-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ggC1wwkyYWqEab//"
Content-Disposition: inline
In-Reply-To: <1401409510-28238-3-git-send-email-cw00.choi@samsung.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/3] regulator: s2mps11: Add support S2MPU02 regulator
 device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ggC1wwkyYWqEab//
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 30, 2014 at 09:25:09AM +0900, Chanwoo Choi wrote:
> This patch add S2MPU02 regulator device to existing S2MPS11 device driver
> because of little difference between S2MPS1x and S2MPU02. The S2MPU02
> regulator device includes LDO[1-28] and BUCK[1-7].

Acked-by: Mark Brown <broonie@linaro.org>

--ggC1wwkyYWqEab//
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTiwRyAAoJELSic+t+oim9xscP/RJ3PuOCDTnaaOW6VJX81ALp
lW68OmjdQFskmakba3ugCi62E/5hrIMTKn8JTmMU+VskQZS6mbPmSN5kaXRjfr09
kuY3OIIQXfdIMkBESIZH6LUvT8rAcNrhzNYwLsQz/0Wc6rX/50SCepWhLaNHGRap
/a1PqYytfxC3+1ew+5yjegIoh3JMxoGxDl0P6jDNeVaqzj0apwNMJVCZtORaje7m
AdlKCZoALQ1pHgmm5cTd0xUaXD6Q8ni2SUCbipr0tXPTIwEM9jfryxgmKVbLpikq
ITLo9bEmIHpdnGcNoXx0h33Pt1Igwc19IzdsXpvmNTDhwgAMTx6pjZ4dQML1pqgO
j+z9AQz0OaAItHbGZI/nSOmdjRZqLbbPYGBprTnIsfLXtsmkOIMz+3RXBKC8hLQH
t0xUYLKFQa+Omdoz290kNyGg4Yw75Hw9WcMiM7YU30V37Adw4AuQL5mT64Lf3D2z
nAr5GCBCO9wMujKAEJRrf7iEgTBrgXjFAJXw5Z6fVDjYB5wPinKUqVloZXdbf6Qe
qaHwdjxN8VOe/1cHvWlwYvIrmy4lsCs9Lw7ndv5QDVW64HbuAV/vp/hIHgLCZe/L
1OK0BQcvsFMxlAYvX04LK/qHDkFFfdk11ygclfqWtxMojDhh0Dke3FlWHiX1ILkz
NXZE/Y5MDdgFTV28U2t7
=OaK8
-----END PGP SIGNATURE-----

--ggC1wwkyYWqEab//--
