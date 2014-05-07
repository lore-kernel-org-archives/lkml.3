Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaEGT4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:56:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59866 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaEGT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:56:18 -0400
Date: Wed, 7 May 2014 20:55:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Philipp Zabel'" <p.zabel@pengutronix.de>,
        "'Shawn Guo'" <shawn.guo@linaro.org>
Message-ID: <20140507195554.GO22111@sirena.org.uk>
References: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WQS/f3aCdEH+xDC1"
Content-Disposition: inline
In-Reply-To: <01e101cf69c9$abd91f70$038b5e50$%han@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.116
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: anatop: Make of_device_id array const
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WQS/f3aCdEH+xDC1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 04:55:10PM +0900, Jingoo Han wrote:
> Make of_device_id array const, because all OF functions
> handle it as const.

Applied all, thanks.

--WQS/f3aCdEH+xDC1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTao/GAAoJELSic+t+oim9Ro8P/Rm772qY3+praXPzBRITwexa
u9+YLVBtyu3ss3nWRk6eJrMHvt26OL9qiHcXVdKJ4Dby9rA1GCxWFPIroE82MMF1
bGSy3YkgJZL8RUdAvuVjqBIwHzSzJaaOlrtdp/vtlPIN+PJwzj9IFQaBPEdl6N0O
f+pTuik7J4nif9Io4oSxPYW5LTiEbtCQxK+VuBchXcYIfMRfKSScVXIdB4Yke1z3
eLQeYsiDx4DnglupJ8OWEWn1bWyHAfd8wnuwF0pdPtFA3Y3TN8hU7rxEuMIRUJJE
57fVIGpgBYLsr3RCkzRozKuEtGfNh8nim+lxrVOIpttH67JM8Xz/Tgv7KLClJDKJ
W6LInxGXwyPf2yUfXmIR1Gti9lgantUMXZvUdJu6kWJcyxntRJQK9fQQo9EteJ6A
yYYNtATKKoSKddEf7N5IaMrwVZxGtgXnBIG/V2OdoL97Z8JZAl/FCanriLxNmeUk
TrO5PdejS7vKHRzQ4FidJsLeNSThGYxHMG0tDEG5n+fjXK2y+IFWz1Zf1sUFXArh
ZnXRVEmuSjBPSwD21kW8ZeFBtm4Q8HOumQ3bx9ZZKMF5pqELMvZkj8WJB4mZ+ByM
fkjh2YkHQeFVrLJURoEy9MStwKAR3QWVAODZSo6Us5DYIRGKledC81gl8GHzD/ei
5TxgtsntmvUoARr/qrWZ
=zGi3
-----END PGP SIGNATURE-----

--WQS/f3aCdEH+xDC1--
