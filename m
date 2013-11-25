Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3KYRSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:18:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49973 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3KYRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:18:14 -0500
Date: Mon, 25 Nov 2013 17:17:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Florian Meier <florian.meier@koalo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20131125171748.GN14725@sirena.org.uk>
References: <528F7718.5@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6AFz5yWxU/FsGPwt"
Content-Disposition: inline
In-Reply-To: <528F7718.5@koalo.de>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5] ASoC: Add support for BCM2835
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6AFz5yWxU/FsGPwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 22, 2013 at 04:24:08PM +0100, Florian Meier wrote:
> This driver adds support for digital audio (I2S)
> for the BCM2835 SoC that is used by the
> Raspberry Pi. External audio codecs can be
> connected to the Raspberry Pi via P5 header.

Applied, thanks.

--6AFz5yWxU/FsGPwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSk4Y5AAoJELSic+t+oim9xTwP/2H4HxBqj2l3uI3ZECB/qS7X
vA4P7R2Z78t8wol9zSl4RSxAOUT+qxgrVJmgTG2O1g9wA1MXrD+n2HU+VDzhXyAM
gM/fKCCmfMX2/5X/QXyA9h7N561Gu8OK0z87Plu+V6sDPgN4UKYNrggR7m/rZjaN
qVOPu8vQyNGyOwheh3uQRz2qcyFvubdPImhztpj5FYar6FQfCbnhXzBLSI7Eqh96
14ZU4k3GD3N+8C6bWBTPr0zRr6RTiDcNXqgKzyJ7QCQTK4FIZ2DRihumGRs0GMCi
ckAStfkEA7Axlrl87uP9U2K3Its0PKS7Ccrg/nHZpzymj54axTNCsJB7CJDcEyzV
tnTH1WixGE/a6L3KafSbmOGPJC7B66Va5+BioKwbKTO9Df0ouxlH5L403ynlu9/A
0u4OLlcVnpbyAiiu71jZCy1nzig66jr5twfOHG3C3rww5MJw+aF4UoIxdMA7R+ge
ILggcMowf60h+apV966yXpeymqnFZ5G16QlPVYMdYQJMnkleeEXFn6Ufmjy0YhY+
mAlFAjpoZydnHSpYAvgJU3VjIe6HpH9Mx/jhScn1c0Vlbnl+Pjr9Dn/pK046Xdit
7BPhAxXCLQEa5K5MXPD5q30T6eND666pEJEUOc0uJqSODWHvjZMJ/ks63L4ZuhFI
3U0BfyFugiwfg9pRgRsk
=yKcQ
-----END PGP SIGNATURE-----

--6AFz5yWxU/FsGPwt--
