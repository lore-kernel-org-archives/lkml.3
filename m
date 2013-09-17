Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3IQLno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:43:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35184 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3IQLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:43:42 -0400
Date: Tue, 17 Sep 2013 12:43:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, florian.lobmaier@ams.com
Message-ID: <20130917114338.GW21013@sirena.org.uk>
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com>
 <1379400338-20704-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zGa1rFMfQatMxgJk"
Content-Disposition: inline
In-Reply-To: <1379400338-20704-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] drivers/rtc/rtc-as3722: add RTC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zGa1rFMfQatMxgJk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 17, 2013 at 12:15:38PM +0530, Laxman Dewangan wrote:

> +Optional properties:
> +-------------------
> +ams,enable_clk32k_out: Enable CLK32K output.

This looks like it should be being supported via the clock API?  This
sort of thing is one of the reasons why I'm not too keen on representing
the MFD structure directly in the DT.

--zGa1rFMfQatMxgJk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOEBmAAoJELSic+t+oim9I0AQAIbpSzwHF9eepbxJXqKUCUhB
aWROqPd7Dyj65kx4iU0wOlyiYl1f+RhUliFC6q6k+q7us1gjdOGJbThFdSaV/dNA
JehexnH5/Pyd24KEQsVGWcP3FuYJPSf63XScbzanrfEKUCsypiSAdB0KdxyJU6AT
Ty4cAREnpyEjnKnjHGRK/4Qrrt4gOsZMjFQffkvky2Vp62s81SztC1EV2G6D9u1O
QR4E/z5dqBUhUyFGqpJyBJsxV6ZUcykd5TI0pzbFbYHqqsuKwcw6Y47vebUHTreA
1keChsQYoJbh1mb5IuBEXgkrR7afccNiLvYr15MX7nJH2EugJ6LhxlsXzLtwRd1E
jDVf/BRfHHA4hTEP2e4QCDEHigqslwS4JXL2AlaTM5TgRPZWS8u0DZzgvU4Gl/2K
D30b0DXWtg03ofT/PebIvAx+KHe+kdSFz9DRc7VR0Bf7dVnZA/ckcFdjAxntsRo/
iJ/WRWRIYrFc9Kj93Q7pfBgkHhDAxF0FJWBMkWj/8jkSFufO3H+5qYMugmQaeM17
OC2ebPcy03ML9fWmX9rYMKSG9EDvpanwsk9K5EY8/Nj39FR9ZX4l83IsTZrjEB+B
udBRxYzhlpcvutIVEzPEQo7OB5hWj0Ftd2IPXWpWiN+svuE2mL6XJkFHz9j5cYjg
aBMssUYJt0aE10yH3QYH
=Ktbe
-----END PGP SIGNATURE-----

--zGa1rFMfQatMxgJk--
