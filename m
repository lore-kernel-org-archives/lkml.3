Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3L3Ltj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:49:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46234 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3L3Lti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:49:38 -0500
Date: Mon, 30 Dec 2013 11:49:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Markus Pargmann <mpa@pengutronix.de>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131230114927.GG31886@sirena.org.uk>
References: <1388307620.15300.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MKyq+TZLpK62LzFe"
Content-Disposition: inline
In-Reply-To: <1388307620.15300.1.camel@phoenix>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: tps65910: Simplify setting enable_mask for
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MKyq+TZLpK62LzFe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 29, 2013 at 05:00:20PM +0800, Axel Lin wrote:
> BBCH_BBCHEN_MASK is equivalent to TPS65910_SUPPLY_STATE_ENABLED.
> So all regulators have the same enable_mask setting.

Applied, thanks.

--MKyq+TZLpK62LzFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwV3EAAoJELSic+t+oim9J4oP+wWkJncVI+XvC89L1eGSJiSG
x3EvwFatb7Ok04kbs8OFqsV1uUji06Y3Fsor+ByypT4phB1Ip/SQWjEHTok0AHB3
VidJdZIFmTAh1M4vhNR+RZIb8BRaF4zcwxwYAQ2ndPl58+5hzlR+BRhTi5AawG2d
Vvkv/PVi7TEnCRnJ8MfLBnpHgBVMhNdSj8MhWTzwSCiD6ywkKr5+3DaKuI8KzNsl
NhJ5EdVeKt8gIBwDP3q2269rappecIPvTpdA4AOextAFsZ3ra0hL2Pze/q1HXmWY
qgHfJFtCL5VL5RI8dRBO/nIcixfUi8K23wjy9eCuo8cnJymz/X9398Kk3KAPiWz9
eafKa3LETj5eOpZKl9u9GXiR5gYe6yMAkHB8seEJ/vqmwB3TgfweVGbNCmQs/RWQ
PoBDV3yz8kvs85ozflypT/Mnw3I87KBgrX+Zd1kfnTmRf2NSXMbLzLA3Y1Icaxc3
nOFlG68vhFhxsxkvOfbVzHnGE1XvRvZljKKQ20Xt0HY02I2ivKN7P8NZ9maNfa/E
u2fNBTaUBHCmrUYVIuVv7s0sFfRQd7oFRdIHkXCBvrdfbBaHYoD5zwACy46XxIIP
fDee5IBohSqEX/I7XmE5GlV3pRnN85idtpUhi8NMzjHjj4lQJwPb6RHRodldkkPT
aprS5b/Vykj6tKby80FZ
=9U3Q
-----END PGP SIGNATURE-----

--MKyq+TZLpK62LzFe--
