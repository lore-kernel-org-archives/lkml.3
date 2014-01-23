Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaAWTaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:30:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58705 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaAWT37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:29:59 -0500
Date: Thu, 23 Jan 2014 19:29:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123192942.GF11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-6-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GV0iVqYguTV4Q9ER"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-6-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/8] ASoC: core: set_tdm_slot() will return -ENOTSUPP if
 no operation provided
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GV0iVqYguTV4Q9ER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:47PM +0800, Xiubo Li wrote:
> Make it easier for generic code to work with set_tdm_slot() by distinguishing
> between the operation not being supported and an error as is done.

Applied, thanks.

--GV0iVqYguTV4Q9ER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4W2jAAoJELSic+t+oim91WEP/i1IReTZuU5q6zvPu8BetSHY
BNOIPkYj2pIXqBZiz3BFmG8GaTOv4ZVI6DnaAHzTBzOJQWz11J+pf9Bdo8f5GW6U
Ew5xDvSKlhZ36ZnQU6K0TeCcBcQyByUzIxcqvq3fG6BnHDUT/D76UngSbv4jaD+n
Hw1ByaaKrWMC7e1V797wnAWunC0pcaKDhhyiTCgYYRKOVLlWOYVsDXx9mO9vS34Q
D7aoAh2XmP82dhL4aTwDUU2WqYj5cEGwtBq2zrC6xHZ6NSWR2DNpcFHwrUROwQyU
C96AdL93q34rpREfqE9HzeW9bsm/+oPdeerTOtaNwUirvGy1Jt6sEnATftptS6DG
g6Aduh37GjbFm2lW/dODzlCysg0Mz256Xu2tCseac/kRrRw7EC212Vybdu6r6QIc
HliZBdV0zIlxAhxypX5oLwTh4bXylJk0OuqoZahVkx2vWEWyBGEDtSr5Qw9htMsL
bKCpLG2foj18XFjKkhKM87O80+IK6Ij07XSwXhMlLzHVVUSJPP7KLHG89FHS2Wcx
znpNS+hJhgiMTTcMtQUBJByqQs+icaIGiRXGsGlzgENET/qM8dSTu2SYQfw8YVyS
VJZ6v8US/VcZQXAfdt0eTyM9wQcVdxmD6sr8b7cXSrodIV1Rz+HOqTAZoGTyoOc3
wUUQ5Xf0raXaY5/UiiTZ
=n7u9
-----END PGP SIGNATURE-----

--GV0iVqYguTV4Q9ER--
