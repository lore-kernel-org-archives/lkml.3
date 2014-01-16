Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaAPM2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:28:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55570 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAPM22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:28:28 -0500
Date: Thu, 16 Jan 2014 12:28:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com
Message-ID: <20140116122819.GO15567@sirena.org.uk>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VjpKO6h983+pAmpQ"
Content-Disposition: inline
In-Reply-To: <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VjpKO6h983+pAmpQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2014 at 04:46:37PM +0800, Zhang Rui wrote:
> ACPI enumerated devices has ACPI style _HID and _CID strings,
> all of these strings can be used for both driver loading and matching.
>=20
> Currently, in Platform, I2C and SPI bus, the ACPI style driver matching
> is supported by invoking acpi_driver_match_device() in bus .match() callb=
ack.
> But, the module autoloading is still broken.

Acked-by: Mark Brown <broonie@linaro.org>

modulo the PAGE_SIZE stuff Mika noted - unless this changes radically
please just assume I'm OK with it.

--VjpKO6h983+pAmpQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS19BfAAoJELSic+t+oim93BQQAJAh6UiO01wNFvkTnZ7CqkPS
TMFxxVCz+0y+SuzfVu4EAx84RQIO4dMx7i/CWEyKojl1jDvajY//99UiePPwE+iY
Sap0woW8xwzhAnQJ/UARy3tUEwkw/oO6QdgwsuLVRvDODDxvvzoecPNgs0U6aSrV
CBH9YE3XQdObnTu2WbcSKvhmzJEvxEUDMDHQO17sl42E2ZDtp0Q8qmPScJcZAk7u
uZRMC38ApXfN4UOglj3X9GdRg8rFdyvKpsxW02u+OY2iJbc6Vycj28kfjTD9OlyK
jnDP3rMcP1Ui5kk4fQHrC6fE5ijhSrRZvDg8czk/wO2DnUPPuEhhhURXHKjx8fmE
z+qtGmSb0ZDap7VZqFktBsUdr8yJW+Zh/K96OMKaym6AjgVbYMPFAzt+F/pzNNY5
E68/yG4mxT6DAWkxlHjsL8JoPO1RArPomWTuzBjdXa+Gv18lF1L9SDuYHitmxNdL
e0N6m2qD1+obaEgXkt6EdpNBESCTkqblCponhiEUI6Idsk3xyhYUvXb9OxjCSup+
d8pLKIw+cDeN1oW3v3/VeK5qtJWvEcMHPh/kQtr1cEQyB9UGOwvWinEoq+Ti3Zsq
+oUepOlxVE53zUB+OasFJl2RXrH1bmdIEdtYic5juq8EmwRV96PLFRRfV7DsB8au
mci+Ps8ReUHWdPgVfxOk
=CtLh
-----END PGP SIGNATURE-----

--VjpKO6h983+pAmpQ--
