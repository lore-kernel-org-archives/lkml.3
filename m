Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3FENtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:49:07 -0400
Received: from sauhun.de ([89.238.76.85]:53164 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab3FENtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:49:04 -0400
Date: Wed, 5 Jun 2013 15:50:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: omap: convert to module_platform_driver()
Message-ID: <20130605135048.GB2934@katana>
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
 <1366723151-23209-2-git-send-email-grygorii.strashko@ti.com>
 <87fvwylxl8.fsf@linaro.org>
 <51ADD06B.3000201@ti.com>
 <87zjv5zq41.fsf@linaro.org>
 <51AF20F0.30000@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <51AF20F0.30000@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> The similar patch already exists:
> https://patchwork.kernel.org/patch/2448251/ - [v2,1/2] RTC: rtc-twl:
> Fix rtc_reg_map initialization
> from Peter Ujfalusi

So, I think it is best if you resend this patch after all the fixes it
needs are applied or you resend the series with all patches it depends
on. Which should then probably go via arm-soc. Or?


--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRr0I4AAoJEBQN5MwUoCm2P/AQAJMIs20ZMapwSiHTjbxmTwnC
g37LT4J/myLchAXowmI0H0CnDO5mppUkKGsWyeVnIBJt1kkQMY735sdnf2KRNqJ2
muEgy/cx1AQad+S3kRE/Z/ni6KaPk2t1hw6nbpP3Ah7mdWJJjeG54ifGt4GGp3fE
dFzB+s++HAaiUPPNqMaaIMFiaX1NmcWkrIEOGxaF0y3QCkPlyFXFulCgejJwkfle
8JDXwWVfRms7DXp6LqhzSr8CiONRhtqmHYzgnVb1Hr+DD0q32ZCZWGocb/NJYLim
gauYXT70+JAatBW0FOJsZSnrkmPgVt6WgZlv2aKsHnQ6DoGeJ/fmnhjSYBc3Itk1
aPbvwSYD/jYeeJeelw4AOeNs7HfMMLsmvgiJxWXwwia96yhJk5Bp0nUQlykgG89o
gAiwwe2PUONu8ZuwVCGGkcpHCzJeN/lMmuBc9npZ/MctsY4tI2RT4dCjQy2SXxt1
Uy2Aqy554qvG1g1y28qvXOy+ZZcaBBj/Oag43Rqkt1XNy+rW+mfPKp6HXy1mKYYo
HohvFD88GpHoeO/ZgsuhEnJNu5SR0Pw2UKibdf3x9frhqP3PFqRB/Z6yvECFsfGr
FqQToex2i1v9aqbS2yIPOlXrYKYAdjwlh7TXixghTTNYLLoJ1J4/OGSmLRE7+7fd
tQrHnQuEOZJszHdMFR3z
=IztA
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
