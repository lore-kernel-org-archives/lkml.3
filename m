Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3IWNvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:51:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35618 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3IWNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:51:23 -0400
Date: Mon, 23 Sep 2013 14:50:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130923135042.GH21013@sirena.org.uk>
References: <1379929545-27517-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eY8wQnuu3RZDiCQc"
Content-Disposition: inline
In-Reply-To: <1379929545-27517-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: s3c64xx: Add missing compatibles
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eY8wQnuu3RZDiCQc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2013 at 11:45:45AM +0200, Mateusz Krawczuk wrote:
> Add compatibles for s3c6410, s5pc100 and s5pc110/s5pv210 boards.

>  static const struct of_device_id s3c64xx_spi_dt_match[] = {
> +	{ .compatible = "samsung,s3c2443-spi",
> +			.data = (void *)&s3c2443_spi_port_config,
> +	},
> +	{ .compatible = "samsung,s3c6410-spi",
> +			.data = (void *)&s3c6410_spi_port_config,
> +	},

This is missing s3c6400 and at least one other s3c24xx I think.  They
can be added later though so applied, thanks.

--eY8wQnuu3RZDiCQc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQEcvAAoJELSic+t+oim99NkQAJ3onBLT5qwGPqvgkTbHRguh
j88tNPkcN6C/C82SwrVWOVQRByzhrqcoVbZP8xEXIPyHFjvPUJKCObi+/ztc3UHe
9sMQ3hx2RcT5IQ3LLUSr993+deStRdu0Yc9MN4pHXJiYd9dclY7RCpAnHl6y8VKU
BGDijajF/JkLREUSPfVvxq7whVrHrlmODow21zStGPUILmXXLVq8QOEyYrW06rB/
HU7I8RSuuXhzUAbQzDw5th8+/ebWzwgJxdEzdx/6yHLK2lu0o6kEjB07vuoQ4Rt0
PSqQ+hjm5BtRy8CfjJhwe34YFLrIGWJ/8igpaUI0u9qsmp7VaVCy6hTiGHzx7+j3
492HmdGOC/H9WBiWufJSkssCrkSnAcVv9k3ML3/k/YCvKTxoAjgUXTig1u8p1QUB
dZQ4Pf7QaLsdujjY97VriEw2G2A6116bQF/bERLhcH10sN1MRnSMQZpAoYr6cBp0
vNZ9YGqtlg1CRBOZ/3ZPx51CgzVdDQafc3J8e3s4nXxy0fVVft8fqU5M3A6rvJOZ
wHFJL6owMEOUkSPrP2mXxEZ54yBIrA3sk3t2ePzjPtn7uicoTV2o5GX2/Nu9p2Ab
8Tw5Y5AudsWtt40ky5XKtycbAMeZ8h3eW+L81cjSgxW1cOiH+IVAyd94cWgUQ0ZP
gi3h0QffMqzNwvvuaU+v
=cNpF
-----END PGP SIGNATURE-----

--eY8wQnuu3RZDiCQc--
