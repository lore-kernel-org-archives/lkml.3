Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbaLDWp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:45:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48560 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709AbaLDWp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:45:59 -0500
Date: Thu, 4 Dec 2014 22:45:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141204224544.GG11764@sirena.org.uk>
References: <1417688237-16835-1-git-send-email-sw0312.kim@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <1417688237-16835-1-git-send-email-sw0312.kim@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix regualtor_ena_gpio_free not to
 access pin after freeing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 07:17:17PM +0900, Seung-Woo Kim wrote:
> After freeing pin from regulator_ena_gpio_free, loop can access
> the pin. So this patch fixes not to access pin after freeing.

Applied, thanks.

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgOQXAAoJECTWi3JdVIfQUEAH/jhPmT7vQs/UqxZCh92rgjIX
N9w4jbz6P7mu7ULOdB0THkgJFXTTjScygON3z5HUCiTG3slDHDNlPp+xf9OsXUa/
qRx4SWOg3YAGybK+jtJakUnRHClEsvBA2mRS+70+Va2xj3zb71S6BWBY1bn7YIDw
AcOYBfQ4j7PhnaOBzyfNMkVGHdDqQ/hqNiz5oWpwnk8tmSEqqzLNrrye/QC3r63h
yGzXYSvHIrT8SbWCOIEur8PhcMclh94/x5g40DFnd2IBrQcamQHoyTcGoArIDaSd
vRRGzvuJU5by8hRpwoMyN5O9N7aej6IcQeovOsW3+184e0yx8QW1O42IHSPfS74=
=qOju
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
