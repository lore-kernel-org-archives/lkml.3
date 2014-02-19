Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaBSQeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:34:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51779 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaBSQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:34:23 -0500
Date: Thu, 20 Feb 2014 01:34:09 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163409.GS2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-10-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u069b4B8G2WN/2uP"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-10-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/15] regulator: da9055: Do not hardcode return value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u069b4B8G2WN/2uP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:06PM +0530, Sachin Kamat wrote:
> Propagate the error value returned by the function instead.

Applied, thanks.

--u069b4B8G2WN/2uP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBNz+AAoJELSic+t+oim9keUP+wTfX0Sa4O/Nmvr+Dj9zu4RT
4AZvrdzkKrlEixbcWBKzqmI5VtKC5GzeZnUHik6BvvBqxypJ/rN6uvrsQgOUrf6W
M5cLyrl412Cq62KOhfDAOtB78w8iyZMUFULFvp9jCEpc1fdHOiMBMJcpl1GwD3zg
fGuEguU0yMhQh0GOgXJ6mN6fbOAUmig3X6kw6peNz1gWDPPmWAwe4/W30vRMImny
XFa+8dUWi1w95yLOsFJMpmnZVOGrXk2CG2KaVW/nS3ckOxwuTds5v0oNcV5d1T8W
LK68XrwG221JA/bH60b4uzksEigWgmF6Pfy6+FfsLyRFZdrdYTGbbmDN/ZdZhEnL
XUMczJSqgSjCWZy7O8uSiV63Yg3rd/sSW3QG9TIGxVL5nlMps4Ip9yHoDtersdlA
Wx58sEcX9nGwGfGgW106jQl2JsFfmC+QBcoyYTqCwH2Tf465gB6ZakGGqTHGfnH1
Q7wij0j5cwuEGHoKWxwxLNWXY3Lwyh5IVVMoKG1kz/0ZwT5DnLMwDhdQe6D2MO48
Q2xhMFYcFQ33Z7BNsureB7AS5PtROpgt0SQOgLN/KnyFopvpevfhCwkevQiq3ID5
k5KkV8T/mLjHwKZ/oED0/lJKZ26zoceP2bHdJF+qlpW8JM6wZS6uB0uAXSRRvbgW
3c3WZO88n/Czcim6V9bz
=/pWf
-----END PGP SIGNATURE-----

--u069b4B8G2WN/2uP--
