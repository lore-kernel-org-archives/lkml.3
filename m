Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3EUR1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:27:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45933 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab3EUR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:27:33 -0400
Date: Mon, 20 May 2013 18:15:04 -0500
From: Mark Brown <broonie@kernel.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130520231504.GA1627@sirena.org.uk>
References: <A874F61F95741C4A9BA573A70FE3998F82E5F679@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McORcswOES2gGXLb"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5F679@DQHE06.ent.ti.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regulator: lp872x: support the device tree feature
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--McORcswOES2gGXLb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 20, 2013 at 12:36:07PM +0000, Kim, Milo wrote:
> This patch enables the DT structure of the LP8720 and LP8725 device.
> The LP872x platform data is generated when the device tree is configured.
> Even if the platform data is NULL, it is no issue at all because the driver is
> configured with the default mode.

Applied, thanks.

--McORcswOES2gGXLb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRmq51AAoJELSic+t+oim98ccP/RRmWIGdSXLl0R3Zan1KPUkU
bkr1qW7pLgp0t+VeT1Z5Cg34ZbhW97A10uVYJoF9ElvG6oZpQSFBLsu60q3PosAm
xKmD3G11EdIs9vofdGc6DA9eQX7j+3kbEo/i0/IP1N1sIfkVhjF221AFrfeihAmS
eR5gjO0ZZr1SVnGSormTN7PqElTLdMc6RyDGt04088lTqOhHWECIL6QyiWEKGbqA
prPNes9N6hbMyx3X3Qon264G/IQ4DV2INJPNi+zqoYlRICL4s1wbMNSlhYQMdcxq
7eJP/+sc/e7UHT6mV983XYPkjqO8/oXuUvaHxxXxJfUskVt/CbLqbhmgcpsoaLub
XxQlB0M5bCGjh+4uC2iSoXSZUpg3Xy8qLLuq876yoNli8K1DwYlqprjB/ht5JebY
P3RfFlL75Ltp6IhRsWxsYIx3HDbc3cIj4E6MdqZZCNu+XUos5YOMzEIbjl/nnY4q
CDx6FhBszv+6rsBWEzp/BLBchy0c9WcRIZJ5/uOMQyDyA0S9HGOoNA3mZWs400NA
9eMpWeBm+7lOyFywH3uLtbTIlqFe/L/QRBb5rUWp7ruUlpIiFwW1NZiIm7VNMzKs
M3M2YNYwbUPDMObzSwgT8o379t0gphKv69OtSeH1RFHjpk3eLmTuQBbkbuY7gZic
lMHpOEM3l9PKmXt3jqZh
=JUyM
-----END PGP SIGNATURE-----

--McORcswOES2gGXLb--
