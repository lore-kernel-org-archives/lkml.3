Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaBOKOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:14:38 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35609 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaBOKH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:07:28 -0500
Date: Fri, 14 Feb 2014 20:50:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20140214205027.GT4451@sirena.org.uk>
References: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yg/4YF7t1SayoUom"
Content-Disposition: inline
In-Reply-To: <1392359564-7205-1-git-send-email-milo.kim@ti.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/10] Documentation: Add device tree bindings for TI LMU
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yg/4YF7t1SayoUom
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 03:32:44PM +0900, Milo Kim wrote:
> Bindings for TI LMU, backlight, LM3631 regulator and LM3633 LED are added.

Ah, sorry - I didn't notice that there were several different binding
documents in the patch.

> @@ -0,0 +1,49 @@
> +TI LMU LM3631 regulator device tree bindings
> +
> +Required properties:
> +  - compatible: "ti,lm3631-regulator"
> +
> +Optional properties:
> +  - regulator-name
> +  - regulator-min-microvolt
> +  - regulator-max-microvolt
> +  - regulator-always-on
> +  - regulator-boot-on
> +
> +  For those properties, please refer to:
> +  Documentation/devicetree/bindings/regulator/regulator.txt

This doesn't correspond to the example which says that there is an
optional property "regulators" which can contain regualators lcd_boost,
lcd_vpos and lcd_vneg.  It's also better to not enumerate all the
standard properties but just refer to the generic document (as you do).
That avoids confusion if new properties are added to the generic
regulator bindings.

The actual binding is fine, it's just the way it's documented.

--Yg/4YF7t1SayoUom
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oGQAAoJELSic+t+oim92qAP/0VrAUyl8xUcrnOMw4f2MPo3
nWu1+VZvNGktXdGJgUmvFq/MZlpEehjhxpToe/SnJg8hYXtuWaVPPVeNMVXggrHh
fUsuHtdsLWH4djXFBcPJCgBqRrmsjGMX0VODlyKfpP6IjIKLsjHC2INvwgsZY1sP
duNEM7VAGO7zOkY9fEPbo629WkLXkiHiLZbwxiLVrNG4bOhsD0w9R4T2Vwq3p8EJ
tsi44lzBjIGnc2+LaoFklZCEbggGA+eBPmT2kAbQuQiMhyHx4RIDJQ51hY/Pn/nV
LAul0biMNUxPOEbDefcUzF1b6YdzZtZWJhdT9DwCp8pjWCCoiLlHjzDR9ypjCQBd
yVEmoxvneESJ8zF6lno8Q9SMyO+zdgxm88icjcw6OzFHRKdyBINGrmNUJcvjx607
Z5WRJlxftCwffuVBwL1gWGENWlJ/UMTAImA0T7ipCeHfC3sNAjBpr7L6xsuVbqBT
7t7kTGlrehDDfqEX6bgMaBynycsRl8zH9VOLQteCyvPrjVhhr+s1LEKG9dS03bOZ
Ze0l+Lyq1OYbqJvBUKHtz9asVed/KEAUPL0BBbQJpM/fxipRoS2r8v7UNnI0AQSf
fKHZUzTXxfTvDsB3KCX4DgOY+JFExz3Z+C5DA2MIGMOwLdC8YHSfKHzVKpS5c6NZ
Z5ljJ4Upsl6V1GDEOVoY
=IIkP
-----END PGP SIGNATURE-----

--Yg/4YF7t1SayoUom--
