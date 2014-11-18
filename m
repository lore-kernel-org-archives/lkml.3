Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaKRPQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:16:52 -0500
Received: from sauhun.de ([89.238.76.85]:45798 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857AbaKRPQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:16:43 -0500
Date: Tue, 18 Nov 2014 16:17:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Carlo Caione <carlo@caione.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v3 2/3] i2c: add support for Amlogic Meson I2C controller
Message-ID: <20141118151758.GF30004@katana>
References: <1415907123-4318-1-git-send-email-b.galvani@gmail.com>
 <1415907123-4318-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGR76rFJjkSxVeRa"
Content-Disposition: inline
In-Reply-To: <1415907123-4318-3-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGR76rFJjkSxVeRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 08:32:02PM +0100, Beniamino Galvani wrote:
> This is a driver for the I2C controller found in Amlogic Meson SoCs.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>

Applied to for-next, thanks!


--bGR76rFJjkSxVeRa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa2MmAAoJEBQN5MwUoCm2FLwP/2Sx4AtZlXOoxp4AQkbuA4rO
2kld6cbPBWE3Biijb9mM1UUs//O30j/Vju2jitQYGGyJ8bkDfd5qPnUxgcB+EHQV
7uW/jpugAMNd1SxaWe0ezsUVCSjAdOh4sMxOHFcezNtQbM9fcKTJF/1cZBOdb6wc
wH2xYlepWYRJaAs2iILgftMmqU/dtGRgs/sTdeE6Lb277GNWP188SWw2QK+C75Gg
Vidf6GQMQXLmhvIv/263d+6jbCFLgCQNohnr1tMYw5kyZM8r8VURlwuOSjqxUzrr
Y5svtTwJVPTgMcaF3e9SaADSUF1y/Gqy1u0w6uYZNPriOH8y8l67iesBKwNCYXGc
e23paM1qHXet8nYfnRnnI8PH6ejHqBSu/SOx0f15xrDFQIerd6y2ohm+RepYzKEO
bjeHKnIgrPRy5adR6JrFahmKgRbZAHrWjCac5lDU4qX7/ZTp+ozmRvOc8UpwtOpu
Akr07ClwAx4lu0S1Tlm7TxtPrDvpeShbZ/TQDFUZnLIVAjUQa48uCXLWYfpfQF44
OGPhJ/hqUUUAji+/K0cfOzHkiN5L4Klsa7lSlSNRUVr+kAIY7v/dUvH0NNBtXXDf
qsfu5lwXWxCYqylnhr4Qo0C4cYOonaPQEiKerc+dz2eiROdLyb62K/JvDNw18A4g
hWskMMviRLSdw43IRscH
=aPkN
-----END PGP SIGNATURE-----

--bGR76rFJjkSxVeRa--
