Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaFPT1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:27:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44254 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaFPT1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:27:42 -0400
Date: Mon, 16 Jun 2014 20:27:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140616192720.GK5099@sirena.org.uk>
References: <1402941758-11216-1-git-send-email-javier.martinez@collabora.co.uk>
 <1402941758-11216-7-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/OcK+/OmjmyK8lO9"
Content-Disposition: inline
In-Reply-To: <1402941758-11216-7-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 06/10] mfd: Add driver for Maxim 77802 Power
 Management IC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/OcK+/OmjmyK8lO9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 08:02:34PM +0200, Javier Martinez Canillas wrote:

> +- max77802,pmic-buck-dvs-gpios: The DVS GPIOs. We'll try to set these GPIOs
> +  to match pmic-buck-default-dvs-idx at probe time if they are defined. If
> +  some or all of these GPIOs are not defined it's assumed that the board has
> +  any missing GPIOs hardwired to match pmic-buck-default-dvs-idx.

I can't tell from reading this what the property means exactly - I
expect it is an array of the GPIOs in some order but that order isn't
specified.

> +config MFD_MAX77802
> +	tristate "Maxim Integrated MAX77802 PMIC Support"
> +	depends on I2C=y
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	select REGMAP_IRQ
> +	select IRQ_DOMAIN
> +	help
> +	  Say yes here to support for Maxim Integrated MAX77802.
> +	  This is a Power Management IC with RTC on chip.
> +	  This driver provides common support for accessing the device;
> +	  additional drivers must be enabled in order to use the functionality
> +	  of the device.
> +

It is a bit unorthodox to put the build infrastructure in the same patch
as the DT binding...

--/OcK+/OmjmyK8lO9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTn0UUAAoJELSic+t+oim9+XAP/0k0xAGWLJs4e/JK0xyzjNB0
Sl0DuDX9IVU5pey7WnyzKGy2WArtwvgRe/5R4m1Ekr3PHaQEZ5rx3R4TZQIlNj1c
xPkMELl82hJQtrDQIuZfGdU03d8YlnvudfeS82cN6QuKt32eS9PZy+HapYTbB5mc
DYTTznAMvuoIFhg3t7KYBX18/uSmA2PmqjvpBbSAj7TwkzopbvzTvA223dUkbL++
Deli/6SBehLsVGi6+akVHpXw9kfpEkutJ3L5yGiaDjH34C/yPs1yAHzQn0lkiOl9
ziRMb+c/lU+hOVEkIpKSsutiy3sq/GidOWzXU55b2+9d74yTeTmGOLOhnoGtI9gh
WBqlRYuHs6yW9UC/6lpc6N+BOcLJXblELJPIeJtfk4a0aJwzrwn1n+zlWg2Tow6c
yiCc0SXT+sEPmovMgDaJQRV8nAW3AddqRmvxCuV8wzwmLUH7aotzqq3UkGWIcdhk
zWMmTuRooZQ1WID37XwaikIUp4qWPIMv7bgatV1A1C8X7Zu26wDjqy9AOp8+L80m
AH0JEOlrPTqJVOxpw7iikIEtlzTXziax41zFTLyE6/7xKrcQeSXMELahDKCRw2PY
Krb/Fqmjo2i9IQDBgDk7s/afF3X02yUAW7ELU2iPkZ+U/RJ2OKuGyIFmBwFQQYyo
w2yaxMGKIlrO208PVbvc
=3csc
-----END PGP SIGNATURE-----

--/OcK+/OmjmyK8lO9--
