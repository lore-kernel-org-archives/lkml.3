Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaHMMd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:33:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33323 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHMMdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:33:55 -0400
Date: Wed, 13 Aug 2014 13:33:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140813123343.GR17528@sirena.org.uk>
References: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FQUN4+YcNB5eWpmR"
Content-Disposition: inline
In-Reply-To: <d35c656e50eb7cc951499f13ef339d6aa1a23deb.1407930755.git.michal.simek@xilinx.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: xilinx: Remove .owner field for driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FQUN4+YcNB5eWpmR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 01:52:39PM +0200, Michal Simek wrote:
> There is no need to init .owner field.
>=20
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
>=20
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."

Would it not be better to do this as a tree wide or at least subsystem
wide sweep with something like cocinelle?

--FQUN4+YcNB5eWpmR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT61sjAAoJELSic+t+oim9NSAP/i6xKj+OBzIRU2NOebXsaWxQ
o+W2AgNeL7a1enJjM89p73b2ZWD92/52pHsGKeEAvQdeqOj9Y3GYEqzAYL/ds9fA
0eMpawOGBxtw/dSxM/L09Fi9gjD3UCF4MUdieF/k92DM0kXG9Z18snU38pbGdUkh
8RS/UfCaAEqVFoQSm3vOc5hVOuhW3ylZfh98j/RGA7CDJlLzRbC1nKdY4aQiuHQl
x3+8+UMUhIyvnj0BoGH4zD/btJLQR73AcCdZ8gLL6FW4WevGtQbC/y3kc3YEMAzN
YHSOmuqFeNTaGAsYUBDbZkI6YrdWK4224MEtZ2Nx7YyHrlmFdfy8r0TZIaOuhTd0
1RK+eJRfgcO1rz+oGNr9AczCc/0t8Eb+Uo2lXKCce6qTUK+0jtEzw8adNNrmIGJm
Z7VWUcb2lNAshpBpArYaGIRRjiYlB9UO4G3W9FY5dy3dpqkmM/iYcmMtzo2l7ICA
YLeWdXDaHnxWEjuDuGCW+oL3//ZwuO+Aa9RN7chEDXUwea4Sh0gi0n/W5pnqyC2C
r7BLXVg2TALIjUUCBlb+IMkvcBScmtsB4VshldW6liD+jPAbPibcj/7g4NI+DEvF
3fyXle16Y/ooMHa1ot5xDLFnl33NKMfUxMsgFiL7cvwCJBAGozLlvVEBI5XmoejH
tPpGAfDe/O1hDYRFjs6T
=TGiQ
-----END PGP SIGNATURE-----

--FQUN4+YcNB5eWpmR--
