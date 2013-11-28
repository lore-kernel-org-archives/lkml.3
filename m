Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab3K1ROu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:14:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34587 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab3K1ROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:14:45 -0500
Date: Thu, 28 Nov 2013 17:14:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131128171434.GN27568@sirena.org.uk>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fz0LNKsoEivY4NpG"
Content-Disposition: inline
In-Reply-To: <1385626183-22990-6-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/5] mfd: sec: Constify regmap configs and regmap irqs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fz0LNKsoEivY4NpG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 28, 2013 at 09:09:43AM +0100, Krzysztof Kozlowski wrote:
> Add "const" to "static struct regmap_irq" and "static struct
> regmap_config".

Reviewed-by: Mark Brown <broonie@linaro.org>

--fz0LNKsoEivY4NpG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl3n3AAoJELSic+t+oim9k+sP/2Kr/kvO8wjI4foIqfntLU0x
e3/5auRQEDCmuP2VykgvV0HCLAg2+mLWBDiOK6qEAkB6JXKeiyhR2VwqJlknvBEb
vqrgutV4c+OnFuJt3kd79rsEcbV3q2gtvZAk+xitdH3QCrtjyryQEbbDwn/EX+aU
vmOOdKU8x7yn5sbAEB1HwxTi85xi8t7ALvhu7FhFvWaiKdS1uEQ7JZNMIJmsphPl
km4wbVOUEsrdZpVN8/pXxCemkmnOsiFYCXN4S2aqJq8HHzNm0WRKeeF5pky7h3DQ
Hn14l6ggjBVx+v523tIMAb2Z6Liu5zbD24Qx7BXop/DQYKp2hMXzSOtxSj0v79m3
Vpe3oEvk2sgaR54vBOprl93o8PjJWmDmnRJ0dhuz5MV4ipScMa0+iYDIgXtAYFdv
tbyGFVMkRSRa9ihmm3Ky0Zieg+ikq9Tol4mxeL5IKo0iJuE9eavxNxuTfkb90Rsl
vHD8QKmbRNk5QndfT9ytlCX1yLjVay3XUvLgWzG4DnhtDj2t6iWnNwQak1/2r+gY
FkelzoZDSSjb7ZVbRYdUYfbuuW5pjSlNtGu3r3YM5/aFGYuIZUXGt3qAf6MGvdfB
jCbG30YQQ7VGrM56gVAPS3ulGY6/tgEzohvBdsQrGs/PP+tndjoia/ZW9zfT9BgG
AQPkR76GcFp0m3yw5/cN
=f1ak
-----END PGP SIGNATURE-----

--fz0LNKsoEivY4NpG--
