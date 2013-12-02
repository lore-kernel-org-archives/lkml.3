Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3LBMVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:21:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59837 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3LBMVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:21:40 -0500
Date: Mon, 2 Dec 2013 12:21:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131202122113.GY27568@sirena.org.uk>
References: <cover.1385913227.git.stefan@agner.ch>
 <2d5282f031a16d2ff227694daaabc977440fbd2e.1385913228.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O2v8LnVIcZ+EDjcF"
Content-Disposition: inline
In-Reply-To: <2d5282f031a16d2ff227694daaabc977440fbd2e.1385913228.git.stefan@agner.ch>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] mfd: tps6586x: add version detection
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O2v8LnVIcZ+EDjcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 01, 2013 at 04:59:13PM +0100, Stefan Agner wrote:

> +int tps6586x_get_version(struct device *dev)
> +{
> +	struct tps6586x *tps6586x = dev_get_drvdata(dev);
> +
> +	return tps6586x->version;
> +}
> +EXPORT_SYMBOL_GPL(tps6586x_get_version);

May as well make this a static inline in the header.

--O2v8LnVIcZ+EDjcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnHs2AAoJELSic+t+oim97FcP+wTzTbJMrzwNnxGbgu0hyLT7
HwpyhAUmbD+CL1L+l1hYRGpwsztVacrTtX2HfPp9/XEs+5wo5GtlLMSpL+TwWto2
0NHZAVxYzJO9eMC/3+AjJYyGfXlK8XEYaEt3FoBUB6SOMhxataVLVolAl44M9iBG
+MF7Zb4EkdfGlIRgHEf4xxiKizCYBmF8LDppDp50fmmNp3DFrCedyb2Vs6NBD2PX
7rbAEIKWwyNt4DfrXEwrN1oYVe/8o/qmxtTw4cEqYIyw0nuwJOf1l7SZGOkPe63C
XxAbFBekeW9erTsZviwWMmZYR46Oo/DURygXQdN4PT6UD+sGVVPohgXz9h++U8l7
QsiON4WPwAY+YjPAFX0g7k1eBLNEUcMqH5emT58rjETdZWNTmbJ4+qAUpbVFDGQr
bXVJDljSljvt2qB9Wp4FrFjLulHdnTyf9xdkqOK1E9vA9bilWneUxXKMqgRNIzCd
8YDHUC4ZFj2yJFJRurrTh0xDAOUxpkY83MA64GV/8MTpt3+CHfu+vhmXUbup17og
J8Fl/pmBi2gdJDcpDhq8nEIUsrSnkDX6zGai+2El73GYP18lrrGxxNRfeYE0FTdU
wyzH5osNE1GDsuEStJMzv42X9Fm3+7ZxhneG82ugSoRBD9A1jp1EVEQ83r7ggmcS
TQ3AzCbo1Y2UKtd+w7u6
=4lxs
-----END PGP SIGNATURE-----

--O2v8LnVIcZ+EDjcF--
