Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaJCO2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:28:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60466 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaJCO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:28:21 -0400
Date: Fri, 3 Oct 2014 15:27:46 +0100
From: Mark Brown <broonie@kernel.org>
To: atull@opensource.altera.com
Cc: linux@roeck-us.net, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Message-ID: <20141003142746.GA24441@sirena.org.uk>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
 <1412275071-6417-4-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <1412275071-6417-4-git-send-email-atull@opensource.altera.com>
X-Cookie: The coast was clear.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/4] pmbus: add regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 01:37:50PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
>=20
> Add support for simple on/off control of each channel.
>=20
> To add regulator support, the pmbus part driver needs to add
> regulator_desc information and number of regulators to its
> pmbus_driver_info struct.

Reviewed-by: Mark Brown <broonie@kernel.org>

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULrJeAAoJECTWi3JdVIfQx5YH/2Or3CYT25D8ArNXkmGEnXvN
PPXAbRTmKOGRdX3gH5p7Vbijw0n2YonPF4s4lFNr3OPwPBXic8AHlB6nBOFQkho/
4MD196tDboRfOFbAuEtZxHU2BREBEPo1JK10Q5EO/knRnTow7ub5GrOSDs0ToKdw
ieI8fG4GYxcUAoIeUnelt9TQmjqtxlOTaAmPEQ00RzL0zLQxt4AlLxFgQywQrrps
9AjY3mLzF/isYGVfGFOYzmu0Ny9iCKLBuffu8i/pdBZaU6BtUsPBkeqZszjR+PeJ
fbsARKC/o8Tryp9ttaWsA4jnoSAeNKKyc0IoJPkXjqbcmt1Sn3Px4hB3hgUFCMc=
=J0bv
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
