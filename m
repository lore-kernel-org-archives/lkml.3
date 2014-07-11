Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaGKNJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:09:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60022 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaGKNJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:09:53 -0400
Date: Fri, 11 Jul 2014 14:09:01 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140711130901.GS30458@sirena.org.uk>
References: <201407110248.s6B2mRIU038328@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zvf7DYrKnARJlhgd"
Content-Disposition: inline
In-Reply-To: <201407110248.s6B2mRIU038328@krsrvapps-01.diasemi.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V5] regulator: DA9211 : new regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zvf7DYrKnARJlhgd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 11:30:58AM +0900, James Ban wrote:

> +	if (chip->chip_irq != 0) {
> +		ret = devm_request_threaded_irq(chip->dev, chip->chip_irq, NULL,
> +					da9211_irq_handler,
> +					IRQF_TRIGGER_LOW|IRQF_ONESHOT,
> +					"da9211", chip);
> +		if (ret != 0) {
> +			dev_err(chip->dev, "Failed to request IRQ: %d\n",
> +				chip->chip_irq);
> +			return ret;
> +		}
> +		dev_info(chip->dev, "# IRQ configured [%d]\n", chip->chip_irq);

As previously noted please remove this print, it's not adding anything.

--zvf7DYrKnARJlhgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTv+HqAAoJELSic+t+oim9sQEP/1i85HvVN/S1fg/0THS3JY26
DFoA0EjptpyqNg/d3pkH5hE0MwActHpCpDDx3fWeu0Hv/ri+EQMdIMoEpzN9urnt
vFsmrYmexUIH7Y/0iQN5aQZa6g+wGoYdxF6a2C+lzvTi3pz5Gllx9a25Ve9O7zjs
a1Q5Tx/U02/iv9nHBi7lRLetpUdn9ZEvx4jRD+xZthKKLU+p4AaX/9bnZd/NYur2
SbHb+FEBOnR8faYM8P6zZ3MUdmXSz+A6rky1uDJPK4msmUPXPDDmEU57g4NsiAHv
Fckf0bIdrWUCzu0gc5S01ofZl1O2ieIvjjGm9HbiQOk33z4xxemshKKXbXAZUtJx
vPXkbeQkTvg19DdfhC1Hlg3xmpaEDFltXYAV2cJew4CJ2DH8V9uti/UEA1R0JpSZ
a9DMNQrYS6tczDrnB44eBgsNOdfY3qQDKc2B0/MEizjP4j9rbxSL6lgCz48nFyU5
rZVtEfHyxBC8hJHfF/CQ8mVu3weWkVnii3t5RjrOO1u1g8ngqoCqAVjFoHzUlptt
boU7wo0XiHF7ow9uEeuIEvqIdDdCdAuhJq3P7v2GRxL4vaYy/t9luIyAQZhbjhuu
ZiDdkX4i73dQ5bp64sclCSe21DlbdDiTetd16IiU97tNr/bO3sYJaZ8hJ/POEgLQ
jsXhwZmuFbXI+8/SVZga
=9j3j
-----END PGP SIGNATURE-----

--zvf7DYrKnARJlhgd--
