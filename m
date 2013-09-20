Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3ITQ4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:56:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34390 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3ITQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:56:42 -0400
Date: Fri, 20 Sep 2013 17:56:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org
Message-ID: <20130920165602.GQ21013@sirena.org.uk>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
 <1379680214-9143-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eOjGLwyQwZ6mtm8V"
Content-Disposition: inline
In-Reply-To: <1379680214-9143-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 1/5] regmap: add helper macro to set min/max range of
 register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eOjGLwyQwZ6mtm8V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 20, 2013 at 06:00:10PM +0530, Laxman Dewangan wrote:
> Add helper macro to set the min and max value of the register range.
>=20
> This is useful when initialising the register ranges of the device like

Applied on a branch, thanks - please feel free to pull

 git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git regmap-ra=
nge-macro

in for anything that depends on it.

--eOjGLwyQwZ6mtm8V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPH4fAAoJELSic+t+oim9XVAP/1ZfeJrqQRX/yf63eUvZvTi7
OkfpcdrUakaU6H97+I8sQxDTQc8mN2VqAdFbnFq6iOKSTpi4MlpqCuXdPkbDeBmD
QDNkxTavESCLKlVS7KE4uVwfTHbcXy3ggz4G1dBfVWAqLZprV/r7hT2O98XJrxn+
Q0SnAt30XdibYlNTlWtL9s0sM/YFYYi1JBuoT+7vd/ipR+jWgseuL3v+v9bNZ+63
Oj+qp9YN6jTV0XL+7n13+8HnB18G1BjIW0nhuAkIOpqooMyA4DN2BnBWraBnQ3eA
QY1ou8DTLSbC5s/N0ps3z8dla0SGD2DpmeApJtXamgE+kKEfxHF8xb+1X4fYI16+
yLtPYVFmUeV0pvACAxWFY0JuHoAbo+a56RlAID8nktmP9/PIrfrjfs4eQ31p9xCJ
NoKW7Rha9g/YEVXb1Xb03Rr2Xg+L0lqBPPnY5vV7uRuH0sV7mqXhivjfOrmyzjin
niGaeLTyHRJDbBH2OugRMDx3V+D9QciEU26e7klx3JXtZDVpcp0Q2GiVmyIEvP8K
2ySeh7jRDNvBwm2nhv6oadzNNUlWZqO19Uzk9Qdr12ZuPdfThGs0GO4YJ6PcvcnW
UXlcqa30beBji2wN7qWShvKA09xgxiWTmTWfkGkWQn2+36UiDZpMioLTNfGlimqc
fqBo/PbSjPxcnV4+XP4k
=0Oey
-----END PGP SIGNATURE-----

--eOjGLwyQwZ6mtm8V--
