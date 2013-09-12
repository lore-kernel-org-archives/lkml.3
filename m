Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3ILLwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:52:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43319 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3ILLwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:52:08 -0400
Date: Thu, 12 Sep 2013 12:51:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, linux@roeck-us.net, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130912115106.GM29403@sirena.org.uk>
References: <1378985061-28547-1-git-send-email-wni@nvidia.com>
 <1378985061-28547-2-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LAThOmUcSmfEsnm5"
Content-Disposition: inline
In-Reply-To: <1378985061-28547-2-git-send-email-wni@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/3] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LAThOmUcSmfEsnm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 12, 2013 at 07:24:19PM +0800, Wei Ni wrote:

> +#include <linux/delay.h>

You don't need this any more, otherwise

Reviewed-by: Mark Brown <broonie@linaro.org>

--LAThOmUcSmfEsnm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMaqnAAoJELSic+t+oim9nmoQAIfb7z1IwpTynk3KqYsa52vo
M1uKfF6uSoyVR4xc/9zRnr1ZtqXMGv/JElBDbSjTP2qmCq6cTh8yh/mIhcRjv9PB
h8k0ZVVAxfZKGnzps+1FY/DdJn6uKVeb7IN1fk9EdfzkZXjj4V5ATMoDhZKyLREb
is6fO6vs7hkei4sUwzYZuXuTkTEujnvFSVx/cxBYiHyuiRYtAezsCOpy2xvqmkey
MC60Tx4cugHZt5ok3vcaW5n7Y4MAiPJ+yaS/jE9v7b9owABfERNK/+Uz2yItsOF7
Z+rcbbpUXi5iN6rxxGcoV0HYnSiuqXpCheS4mY8xLJooHBf72XYyb/CMYgj2/0Pt
kc+k1B/x5MWWJlOz2FfhzksoBlpbouF1Romri6YPJTsOyOIaNWMTf6t86oVXuD0o
85CB+ZHiDt6A/Ob9pCkr3QSRQFT1powQ8bl3/E+kaNM3I9WmgvurT4Y8/noFN0Jm
KcwJM5kwvwdm8EMy1z36mt99X6B8eIC4KY6875zPcr2YRjMvzMeF6pdKfYckWhp8
NN/g5Wnan09bm8h+AigGIQOeFMcEe2emA/Ncy+WNiDmfjv51UF5fxeofhklCbi86
4akVdzn954GMuIldhHpJ75RgI57RiWXdkcRjAazTrjYNfS8QRkgrhuKevYJUtvhI
rDnodfnlnVX28n46Bpqr
=lJNd
-----END PGP SIGNATURE-----

--LAThOmUcSmfEsnm5--
