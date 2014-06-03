Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaFCOoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:44:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52126 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaFCOoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:44:16 -0400
Date: Tue, 3 Jun 2014 15:43:19 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140603144319.GD31751@sirena.org.uk>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140528185051.GB22488@sirena.org.uk>
 <20140603131204.GJ27722@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JGq01gMRpXZxBGpH"
Content-Disposition: inline
In-Reply-To: <20140603131204.GJ27722@lukather>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JGq01gMRpXZxBGpH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2014 at 03:12:04PM +0200, Maxime Ripard wrote:
> On Wed, May 28, 2014 at 07:50:51PM +0100, Mark Brown wrote:
> > On Wed, May 28, 2014 at 07:11:07PM +0200, Maxime Ripard wrote:

> > >  		axp_mic_reg: ldo5 {
> > > +			vin-supply = <&axp_ipsout_reg>;

> > This is saying that every single regulator on the device is powered by a
> > (presumably) single input called "vin".  This would certainly be an
> > unusual package design...  As ever the name of the supply should follow
> > the name of the pin on the device.

> Not exactly. Each regulator has its own input pin, named
> <regulator_name>in in the schematics, with the exception of LDO2 and
> LDO4 that share the same pin.

OK, so the supplies should be called <regulator_name>in then not vin.

--JGq01gMRpXZxBGpH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjd78AAoJELSic+t+oim9gTIP/RFoGTEdwt7pHWORTSpjUvHw
w0R8nxrSlfSCwI7oieA0gmmHbX/pxdtX8qt/fw8nS3HIYYiyB6q9nwcUgZp6wsT/
3fGmKAxqqVvdGC4wObhUCfT307X3XBLXP7qL9lMydddGYMfYUneGEipKktX8Xjgf
T2Q+4sW1v7icoKT7RCRXkrooi0QxasPlIwoJAQk+eV4s/VPfUOkGXJnFAXiZl/M4
+7hJEM3IAjFo7I7XPlRg3AbS4pClH47GoPfQ5S5K2zjoYu2CewFqu+3BtwKkJrdv
BnDpqKPWQrb61q67LB5+6xPWz0hmqR92n1BQxh3Ry+bWpXb+krH3quYPATKKz2zQ
anBtPYxkF5MHNVxP4pxwVpnzAM88FHSz2RJCVhJLEZcycAzgkjxV0Nxz5WLxMB0h
3J7bVcAS/pUQdzwc//GTMomQMgxnUGeeH8c4QnN1Ls9ahLJDsdS7qx9kD3+JZfT5
Qv0HnECfcOygWgmhd2n/0Zj5QdnpLjFRwvCY/a5mL/E1rOL/sGWdY0yeC/LuIfJr
nwyRMrsMTncHU+cDtLc6SVj7m8WqYdL/LPitJHwUKlLi1YEuLmRVNb1vgEunl7RU
Z9HYAnOjC/9tQ400y6mNyug0/Bp6eVrUaq/r31P6y6lIbMAWHNrXBhv1O42TRFgG
wwaNW8F5Nnaj98x4sQHZ
=Nr2e
-----END PGP SIGNATURE-----

--JGq01gMRpXZxBGpH--
