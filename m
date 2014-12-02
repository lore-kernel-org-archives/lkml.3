Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbaLBL74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:59:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46052 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaLBL7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:59:55 -0500
Date: Tue, 2 Dec 2014 11:59:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        Bo Shen <voice.shen@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Message-ID: <20141202115928.GS7712@sirena.org.uk>
References: <1417461001.30245.35.camel@x220>
 <1417511075-13725-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DreyolINzixGV+Ru"
Content-Disposition: inline
In-Reply-To: <1417511075-13725-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Kconfig: remove not used SND_AT91_SOC_AFEB9260
 option
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DreyolINzixGV+Ru
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 10:04:35AM +0100, Nicolas Ferre wrote:
> Now that the driver snd-soc-afeb9260.c is deleted, remove its Kconfig option.

Applied, thanks.

--DreyolINzixGV+Ru
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfamfAAoJECTWi3JdVIfQRGsH/0ndC/TsdROt8TsVTA3L01ZJ
3SpGHH1PRjgS+QLDzfHDW/3xB2/EemjzfzmgaekO6+FL56gnF5cmuRlt1N9Fwt68
yzW9J78EvK/mZueOEIJsxvE79Zh6eyoIrxjgOJGaU9PJ6jYvUKJa1XypM3I2cOlB
wg5e4td7vwRXKOUFyN59wsmtdeKU9VwkWRV2/7bGDMVW73wJYb3XFoevRsxWOQp3
AEcOkA30VPqxCYFqHxEpGNGu6tn/e1IPecnB75Nh2yxiPGtyJRWRz7W69NqDzVkc
O+3JwuWgf509tGTmcEd/hC9KgptoM3a691TbYYrO3wc0JEIpK0cRKo+0UMd9okE=
=wEbe
-----END PGP SIGNATURE-----

--DreyolINzixGV+Ru--
