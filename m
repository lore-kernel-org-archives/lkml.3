Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaAGPh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:37:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48356 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAGPhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:37:52 -0500
Date: Tue, 7 Jan 2014 15:37:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20140107153748.GM31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+6PFc4gFogXO4FO2"
Content-Disposition: inline
In-Reply-To: <1387468508-12286-5-git-send-email-lee.jones@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/11] ASoC: Ux500: Match platform by device node when
 booting Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+6PFc4gFogXO4FO2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 03:55:01PM +0000, Lee Jones wrote:
> We're getting closer to fully enabling the Ux500 ASoC driver for Device
> Tree. When we switch over from using AUXDATA we'll need to match platform
> by only Device Tree nodes. In this patch we NULL out the platform_name,
> and supply nodes for each platform device.

Applied, thanks.

--+6PFc4gFogXO4FO2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzB9JAAoJELSic+t+oim9peoP/2pmEP6cEyVTq9a/ZVH2XRH3
fmT/A2BQ2bVIAN4HpaMTYumz9mCctewznUZ/dje0vPcSQ0gYI0xOZc419FuGqJ+6
i1jc+B99a3wEe7j6L6LbeAndR53LxBRRN4h7bwL+NId4NLnm6b7cZe3JE/5FQbZu
oCfqwT90KTow+2RoK0B+cIWMd36oAV635jf7nn7yNcMm29txhWxEltK1oMe60r49
3Y6XKG73LH5RpOUi+MEdXifxKKQov9CtSQjLts+bl02n5amnFRi4fo339u65KK9s
hTgAti3eUAgwNPILk+2/81Ur/d6tGM0SGLoddZs+z8pcvRjcOM+SSXCAPS2wN2Gd
Uh8dBwVw83is6Rn9QRiw/loI0Yj7RYORISH3H+1Pjm2pfFSmU7+duKBYzC1r07TP
Q9PJm/3CLog1FITay2/3ASCQY2oLsOVDTDGuw0mxxNG1pj7kUmKkd7mZh/mz1RLR
NpvTc9TAwO09tLnW+wN75mUNm5K45zOydUrdC0YOrxevk7ijo672XYuEq+FzeHyZ
HezJp/5uwY5KmSajtNeotMgI1XoN7iRNrnAYLarnIRf3PbnhFDiLl2SIOvlBmpUx
oRIGXgGhoauhawTvPIoLWSG+Skmrhh1CBTkYCEIaL38jY1kwgLlSnZIjSPeJvVi/
GYMGV4KBgURXL8t09I3Z
=FSVJ
-----END PGP SIGNATURE-----

--+6PFc4gFogXO4FO2--
