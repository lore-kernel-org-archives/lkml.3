Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3LQMsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:48:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50812 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3LQMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:48:11 -0500
Date: Tue, 17 Dec 2013 12:47:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        vpalatin@chromium.org, nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <20131217124750.GX3185@sirena.org.uk>
References: <1387258597-21866-1-git-send-email-wenyou.yang@atmel.com>
 <1387258597-21866-3-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZYMWYzz24GaIu3e"
Content-Disposition: inline
In-Reply-To: <1387258597-21866-3-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3 v2] regulator: act8865: add device tree binding doc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NZYMWYzz24GaIu3e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 01:36:36PM +0800, Wenyou Yang wrote:

> +Required properties:
> +- compatible: "active-semi,act8865"
> +- reg: I2C slave address

This needs to also document the regulators property, for example all the
regulator names.

--NZYMWYzz24GaIu3e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsEfzAAoJELSic+t+oim9oKQP/1jh55BVuh2HAFivNeOKsPPe
0h6v+D54tdBnAmV996wIrU+9INNlFPWocWfj+pfK6Q4zCucrbE+6m/oGfzHqfg80
FaQN0aKW6A95dR61NLHIzZ9c3uWKbQ+flffb1ZhzXOmL2O7ACsj8EwM8Js1+M9Ni
9DGQMx9Mwyh93T0QkmX+j9G8uyY9EenpQnOC/Er7vNeteBub6cWLOIvDycQBW2Pi
2xr8grvXpzI/+u4FqIwssblVWb5z9Bpp/N8pghCnRnvDwvCgf6jbNFBGt550HVgJ
XygBj0IHFG5ZTHWaSh39v2u1bhbS0AFKFedLsEuJXMG6y446aAG4eV2oVsfCWJms
08yLyXnVQ5f6tNZYap3RAQKVddgVtbhdEa5aeRGBpTV9dRjIwcTSkOWjBq+x7qEc
xVhKuNzcsdJLVbil18t9d3XO8bMbBoef4Ro9r48Gzfo6g56AgwsaDwOM8Fx9hpSK
xoRznZQHEVQFb8e4uBHU9uR/1RUMDhI/SIMHg0R/XNtPJc7Tn5FQ5lNrtht1q83G
8jxWfMkdQjJBDKx9IhiDAK7nh1sXHVHOIXv8hGd3dVoHTCPerFCtkrxe0vst496o
ySHgfVrB11/20s/wuHiuZG4DVMPu/zWOBOu5LSfuUGSuvpY7mC6g00majWHCi66x
4aZoNvEN05orIkRlSxAU
=/mBm
-----END PGP SIGNATURE-----

--NZYMWYzz24GaIu3e--
