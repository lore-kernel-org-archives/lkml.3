Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaBRCBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:01:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58378 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaBRCBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:01:13 -0500
Date: Tue, 18 Feb 2014 11:01:00 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020100.GC2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-4-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pqZtgxSH0iQu6R78"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-4-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/9] regulator: max77686: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pqZtgxSH0iQu6R78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:32PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--pqZtgxSH0iQu6R78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr7YAAoJELSic+t+oim9mwcP/2a+DB0DXFaw+7RPGsain15Y
NQ5FClnIwcn2fsKom02Ft0kHJ7pmJvKOsNG3/Nwje0XltCXFyE4+wcKzXN1bDCex
RADF0FvpYtXU4PykUK3MQQbObB4jQ5v8gpRxwbv9AQwtXXGO0reCx+nBvrYiX1wk
SfnIBmM+zHTJjQWmuRLKaDbv1jHloYywQDvZ/PS/pkVSCOngc+LkFKj/1n6DzFzW
VvPdUwTiL8UUZWpq4PXcN/HFn8o6AQ8K6lMHgcUAP1n+bUtPAA5IibWbHUv4qxA7
jYUgybtAILLdFpdM1hwNWcnTd/ixlG3leT9sNwqw+PI84skonbkUYADOB9k5s9Rg
FtCCS2Z7Bi0oRi1DiVP8EewG7LLtkyOep0OBclnVfSdwNjdlTPlGnx+6rDf/3Jno
sW99/Blh1qAYMF8H1pJRMbnU4hiD0dMnd2GYvzDkReiXPs5fD74Pf/jauI0WEUus
9fFfsZobvoQIeVLNYGJY9AQhBQj1Vmtc02h0WXgPpUlN972DNz8jW2KT389G/tVh
Xl63XYXkfGT/BZKwT6yAJk8AS167xrRdrdM+nTgKSEvzhC+SC3VI+OnD+d82pWRw
7tm3jqxTarxPJMN0bT6Zi7L00bDdv49CuZuWE0qWy+a13cSKi9xnoKSxUxSx9z8G
6uvmA/9lFnfO0aK1yQd6
=cfU4
-----END PGP SIGNATURE-----

--pqZtgxSH0iQu6R78--
