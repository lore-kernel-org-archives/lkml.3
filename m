Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbaEATJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:09:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54427 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaEATJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:09:14 -0400
Date: Thu, 1 May 2014 12:08:42 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20140501190842.GZ3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-12-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VGJtZYeI3LbW67dD"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-12-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 11/15] ASoC: WM0010 needs SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VGJtZYeI3LbW67dD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 29, 2014 at 07:18:32PM +0800, Xia Kaixu wrote:

> @@ -201,7 +201,7 @@ config SND_SOC_SPEYSIDE
>  	select SND_SAMSUNG_I2S
>  	select SND_SOC_WM8996
>  	select SND_SOC_WM9081
> -	select SND_SOC_WM0010
> +	select SND_SOC_WM0010 if SPI
>  	select SND_SOC_WM1250_EV1

No, this is broken.  The driver won't work if all the components it uses
don't load and the dependency for SPI isn't SPI, it's SPI_MASTER.

--VGJtZYeI3LbW67dD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYpu3AAoJELSic+t+oim9KJ4P/3LmQ+4hfHyEpaoZ1c5NtgIJ
2g3k6VLcChLiBKOKMh/Z4WRUZcF8PuQGkLj6hUHOwVIs6/j2FFJHjN5FMc6KGQ5s
vvFx9e11SUWrufAzFZ2CuU1l2V0a0neGOpPKZlDUhOm7GM6ioUCbIAfyajHjKUp4
0seIH0VQiJ7g2mhksVGdqYRF9yAZxoihxzWHCARwu9zx7Zc9LCaMooLrUYK1tZiP
VU6YB/0hxrhmWBdXcrTlTZ5+GI4O/kRRwBGabcowWiO28NhJF8P9yKJ8tyqHze41
Q4aQNMMX4Apb+nus489SvIYCu36KBCzrnSbhyP+wA86lj8xQ2GXtCh5mTxXKh3sm
/zT6Xhh63sF7h2lTCSNCqUGtibPSi72zIuQD56wJXOcZSQ4PdgCDF+Q99r+UkJuo
HHWPVX0YIBZ4KKZfaT7l7nMNekALMcuLMf2tqlrm94laQ6g2us+ilExL9tma5T/l
gLyxRG11uwUU2rV/j87t2w7J3cHe0XdUxfj3GeqgtWR5wi24/jmGU/7Z2VSRiPDL
vLSRL3M9UNTEobnCzHJRtCLXDagWUL6/WKdxYQY5wG2zRkW+CYgZL9RMlkhDqC20
8VaeXLMtV47htm6HDen1O+Hs0g+d3xt+eGi+7Bj7+WtIaCAjtqoTxBPk1CbzUC4P
g6xIbzyGVg16+lU4/Hfu
=8FMB
-----END PGP SIGNATURE-----

--VGJtZYeI3LbW67dD--
