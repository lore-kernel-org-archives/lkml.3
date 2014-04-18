Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaDROHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:07:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37842 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDROHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:07:44 -0400
Date: Fri, 18 Apr 2014 15:07:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140418140724.GL12304@sirena.org.uk>
References: <1397779590-4128-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWvls6SgojIh1mq8"
Content-Disposition: inline
In-Reply-To: <1397779590-4128-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tlv320aic31xx: document that the regulators are
 mandatory
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWvls6SgojIh1mq8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 18, 2014 at 02:06:30AM +0200, Alexandre Belloni wrote:
> The driver will not probe if regulators are not provided. Move the regulator
> properties to the required section.

Applied, thanks.

--pWvls6SgojIh1mq8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUTGZAAoJELSic+t+oim9fyoP/RGkHO6OtnXy9E1NNJldYqb6
LdNxpTDCwRTdi1e4zSEGg9r+J6zJn762It3QW4slJVL+XmY/zUudIVLtW3cnwPkD
yDLncC0p2LzLqHlRyD4j3cvrPrcGB4GYVizSI16VfaLBm7w83Bq1erH87eGEhB3x
vE+yZs28PDJhxasoWOsAioVCJU6QxLs8W5e0UjeKkVdHYul7fhJGVFrSkO5QYHh/
jJsfpiFZn36zt3cVioqqilPDCrXXVw12ix94XM7LoPLGSWqNYkTBrdzbQePBOub3
W6MgpBw2SQikGz35H8EVcwRsBXY3XCeApifIDzlkPppxd1R0RhZ4FoGoG5fpyLcA
mjD3znfIkyIH7k3+FYy3Ck3MwUdePMoDVsDHM54dcSL8t2be1oRS6SIgq/+xSWtr
yHshLNWYj3Cf7YYHBa2UaXPh8C0b6o48CFuqCZZAqZNBlf+a1Xl3zVTWdIm1xphV
YlAxlsm6K02Wk+dt5mFNBD7nx1amjLqvA+RG8NrqOHuTe2TpZ7zqQljccSx7Ih0s
UYfNIhEIApWaAbrO/2wkn0O83xrBzSG5/lMRIFxiFqsP5QJ6J0QN9wybWzHUq7Wt
wIuPDV0rkP5IzESuTnn+D+qFVCpj0a/NIwPcQG4gORBbzqaGf/e4VZAx1eT1xvs6
Gcvq5FbGFTSC1OYSfnkr
=xqYX
-----END PGP SIGNATURE-----

--pWvls6SgojIh1mq8--
