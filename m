Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaFBWRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:17:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51258 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFBWRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:17:10 -0400
Date: Mon, 2 Jun 2014 23:16:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Message-ID: <20140602221627.GP31751@sirena.org.uk>
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com>
 <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com>
 <538CA24B.1010602@wwwdotorg.org>
 <538CA635.4050502@ziswiler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kOdvwer/5gjFgNo6"
Content-Disposition: inline
In-Reply-To: <538CA635.4050502@ziswiler.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev,
 lm95245, pwm leds
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kOdvwer/5gjFgNo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 06:28:37PM +0200, Marcel Ziswiler wrote:
> On 06/02/2014 06:11 PM, Stephen Warren wrote:

> >>+CONFIG_SPI_SPIDEV=y

> >Is this useful with DT? I thought that unlike I2C_CHARDEV, spidev needed
> >dummy devices to exist in DT for spidev to work? If so, there's not much
> >point adding the option to defconfig, since people can add it when they
> >put the dummy devices into DT.

> Yes, the Apalis T30 DT I sent actually contains two of them which we call
> generic Apalis SPI1 and SPI2 out-of-the-box configured for exactly that.
> Without the config enabled though it probably does not make much sense to
> include it in the DT so I would consider removing it again.

Your DT is broken if it's got a "spidev" node in it, you should be
describing the hardware not the Linux implementation of the software.
It would be really nice if we had a good way of handling this but we
don't yet.

--kOdvwer/5gjFgNo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjPe4AAoJELSic+t+oim9KWcQAJWlBDlz9bvmVX06mKnKprj0
r3TntvSqpPTauZhXWC9pSNtBIuF9+GTAB0NgdP69nhoUbZU3+bdrUc8/0kzX+kDF
lfpdqumhze9+m0N0ioJm9mT49EM+Sl1QOkMMWrq7WL7UfunZRXq98NMzL370TYGJ
+FzIeUiwbVojbVa0nxD+fK1VKuJEQt92/IFfQpfvhkaZFrTWkxIzc2IE4DG+mCk4
uqmbqLAMHI96xZ5YL1NHAQh/Bq6OCkYzBS1perYb9KYON0dF57oc8KGebln2ZxH1
KY6O5tnHjpJjUa+OU58etASimysTveDbNuaqyFNO6tSx/ZvD2oV11ygvuLSQHyUD
8FQv6kDHUWaxs2vOgvaXNugcKcsdnMaU7Q/UhmFGg0pz60Fb8VdbKu9EEinYn/vh
IpA5J52oXIsGum8vuuCWxhQDeQvqrjoQuoC5nw5dWzUuqwKa/Oeg/0ygX30wmbMZ
IX0Q7/13GuZke6pnJ20ET+P+OHT9Dcl5kF62ycSIC1NYXJzy5K9ESh99928GiNmw
FlHyHq9pDHdwSAIQIPG8nMq1MRlPOvxxB8C1zx9yakpX9NnUu138rI5IA4gPs0zt
RA7CZOSn8hKkmYj8bhQJhr/MbR2AMlyWy9kxk7cWK6tVz6F9kgeaMAiSHM0/PVrK
2cHOUTMpP0LqVudoeyGG
=YuF8
-----END PGP SIGNATURE-----

--kOdvwer/5gjFgNo6--
