Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaBRCfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:35:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39929 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaBRCfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:35:05 -0500
Date: Tue, 18 Feb 2014 10:57:07 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218015707.GZ2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0tC/8VcTcTa+VwnR"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/9] regulator: act8865: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0tC/8VcTcTa+VwnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:29PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--0tC/8VcTcTa+VwnR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr3vAAoJELSic+t+oim9sY8P/RP8ZxAv2QGEAHCRopPMRsDJ
06dixSfZwPnm40fO+2UpjuMR/6zqxMqaD5lBiouQGuTx0xYRkbzM3l+IWN1LjIHk
7c14Rteh1MGD4VKIu9Wxircv6MkOGR8aC/Z+CMEVaXto0t72jps45sDaTF5sLNtu
FEvN1F5BlBOma81My2/ZfllZXG9wCP+zPkcE5LHbXxUZKJTpYRNMZup3pl5fK7mt
d97ALM1GFmc1KWVJC4mBwn6zhbtpJkH4sG8eT8Z9wdykBBQY8/JJ/Bp0+wDO7LQh
uJBTwOreaqnLo9UQZX90euwF5zZJUQLG/PLb3/iZ9yJbg7h0S6OPSSiwNl5ac17q
n6JF3RSBu1XG76tZcfnXKBbQ5ZoRb8SfyDt8S6RsBtKdxDDav95EDp/PesB++LUz
6X9+I598LpVW4e6sx632n69bQwatO5ZwhzL3GsO3LqX/HqX06hTIDgjyvBTx6tcG
7CWHeaLyaEWD1GcHGmCSmGE2JaVNnmBVGI9PLSXoeuMTXNEaWQ7D02pe4zB0i7Rh
rOdVxlyJC++1GoJVaw/dA5iDjmkkXQz9fJv3vfQVM1UJbOqMfNw0sXwi/tg0nRqg
kUm5cBnilc3h+oKp1NRuyu0rxjwdN1DND8LHXTuLP6U+LjMi6veZk18CHdIuTOVa
FCBHO9i7zXFN+V9hkwCP
=cloY
-----END PGP SIGNATURE-----

--0tC/8VcTcTa+VwnR--
