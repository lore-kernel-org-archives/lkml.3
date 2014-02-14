Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaBOKJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:09:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60504 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaBOKI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:57 -0500
Date: Fri, 14 Feb 2014 21:15:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211558.GG4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-9-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PMnBCHLB6K0Tl81y"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-9-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/16] regulator: as3711: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PMnBCHLB6K0Tl81y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:55PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--PMnBCHLB6K0Tl81y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oeKAAoJELSic+t+oim9cxEP/R/aTKAqoSmNR3g16AMeEClW
blq56h7SxCQLtErR38Qp23hVucp9A7KFY/9xOTLqXosBszf+BX6RCj6bqK+NQ8eT
Ie4HFozeRlc5mt2szRND9piOYv7i+ALgA+sAz2EzNnr4BxIkDUk9hYnKSkOcoaq/
KkB9DnRoKtusG6ct74k8aSwGlCm2jzwg+t+FGMHUkotXMwu57BfeG3TYIyrQxCXI
7oiIdnA18ep8aehL6BRyQi+A0yUVYmpkeRoi7TtDQeaXlrNBnCbRCh8ivKMUvweB
V0636OVkAmEkHy21YNEBmghU6APcpeEf55eNIyGpQuy+G5DtIYm2qIilue8sS09H
aq8P++2y9VKWsdsU0MT1UX8x9quvgLYGt6LwJ2K54Ywd+yqBvG/hsFconEvGYlsK
j7GFUgdky6xukSHVZmmWt1hPd2ky01z38J7LFP5si4WoMgUtDQ0H+PH8jtMu+Mde
K4AxQVrBFRq6K6UN5YYJDGU+iuiyzBSP222c1HlTpw9MO+YDZch9qnb9e4oO3XUK
X3z8IpksFEljqAhCyr88pBXcyIiJtJ/sFeSNKD4I63GY0xNtgoYmiTW4p9gXOJlm
xNmgrDHXu4HICKR+pLqo+JKIu7PVtBC7Ze4gQkDhrRyMDoYT3pFWZf56n/ZDGaU+
wOQ/Rko7/BSnF8QftSnX
=yWz9
-----END PGP SIGNATURE-----

--PMnBCHLB6K0Tl81y--
