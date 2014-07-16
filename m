Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaGPW1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:27:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40877 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaGPW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:27:52 -0400
Date: Wed, 16 Jul 2014 23:27:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20140716222746.GN17528@sirena.org.uk>
References: <1405095208-14642-6-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sh9dYexoRflRb0jn"
Content-Disposition: inline
In-Reply-To: <1405095208-14642-6-git-send-email-geert+renesas@glider.be>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 6/6] spi: atmel: Use dmaengine_prep_slave_sg() API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sh9dYexoRflRb0jn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 06:13:28PM +0200, Geert Uytterhoeven wrote:
> Use the inline wrapper introduced by commit
> 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave: introduce
> inline wrappers").

Applied, thanks.  Please make sure everyone gets the cover letter on
patch serieses (or just send the patches individually if there's no
dependency) - it makes it easier to figure out what's going on.

--Sh9dYexoRflRb0jn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxvxfAAoJELSic+t+oim9P/8P/iw5Pw1Esd/hizoVoujvCTT6
JHyW6hrXDjPxDiBAN2y+4rOIa8kbl2cn8XYwRiH7qN5hZZYEyKcvH6iiJ7dUQsaN
zOyk1MAG7HxI2nYnraTqcOukrVX5cpm7D5I83v3MedNbOJrWj2fN/QiZcT9B7mRJ
J2j0UTyPUe0657A1A46D3OPyHI7nALVO3oRDdnU81coyW3hU5MzyQ+joNyqqL3NT
WgfIzGMUqJ84ElQlj/DJVYJRJPiFQuXa6noil9kp6gjgg1EeaDjSBq8PVB1389Wp
wvzXCXRV00uBvNtut2ycxGr04RRAfVCkPd8OzzwZ75O56QML2359GWz51/ErULJt
BhyHCvJ8ru6PjznhPehyAk0haXazsnldi4HjH9ChSnFSgbxwQQljjMqEMCaLj2Zd
ti4WP1FD1MEOgmCTND/WCXAhQL5kOeWrfLK6bajSdKNcLBuwEW1wiBJUF69VCQyx
8AwZNOTMBlv5ilxayrZ+jq1tuxRVVJIkfS9H2jZG8oQAGDXaEZgoO5F54Nm37RUI
DUy3l7jFp3NfHEmlH+7q/uNLxqBo9G8jBroovMaDG92NxYdyWR3DEk8J00gsFaSQ
O0wq3THu3i9NPxly2HcfRFDWRzPaNJWw5KeKy248WOVnYytxX93GloqxbPdwXkvk
S6znuHDRK0T3QQbkUFni
=lS9P
-----END PGP SIGNATURE-----

--Sh9dYexoRflRb0jn--
