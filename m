Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3KULlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:41:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35424 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KULlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:41:31 -0500
Date: Thu, 21 Nov 2013 11:41:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20131121114105.GO2674@sirena.org.uk>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1384877043-5640-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131120091636.GA30012@lee--X1>
 <20131120102045.GW2674@sirena.org.uk>
 <20131120104526.GA30524@lee--X1>
 <20131120113400.GY2674@sirena.org.uk>
 <20131121090724.GB19368@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wmfuW8osuO2pi9jF"
Content-Disposition: inline
In-Reply-To: <20131121090724.GB19368@lee--X1>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] mfd: Immutable branch for ASoC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wmfuW8osuO2pi9jF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 21, 2013 at 09:07:24AM +0000, Lee Jones wrote:

> ----------------------------------------------------------------
> ASoC immutable branch, as requested by Mark Brown.
> ----------------------------------------------------------------
> Charles Keepax (1):
>       ASoC: wm5110: Expose input high pass filter controls

I was expecting patch 1 in the series as well (the DSP stuff won't work
properly without the register map updates to go with it).

--wmfuW8osuO2pi9jF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjfFNAAoJELSic+t+oim9DNkP/2StAuJpqUh0K5t56xqyZzxn
NuFZvXfL3SxFfPgLX4B1Gzhndv+zwRX80qOqA13fB4ba5idxLfzAPGpPNugtsEjJ
SInyY+1lhCmINwxfZTe+NAjQC7Nhw/e65ygr+JagTnWlDvuOxWj2DipjcEN5tq3b
H/j0oFc/NHbcTRea+TpxtdwLGhMzVDALaURwBD5ry24pOiBRGj6P0t/9EuvakVQJ
HlTb2sqCA5VXyZo8E1DLKYiMlWrXF9dVot60oOwToBCGE0tgo/C66HMqlN1oqLNj
Vawza2TrnIgaeSSG94mZpB2UhQ5BkczNZ12p+dippa6cf65JbQHaDrc3dEY1Am7r
hhzd1IugX3i8J+0zDVSQOGDQksiD+2XQPdqZD3vdIw2Z9YZ72qcWOezHF5PMHrtj
BOC32UjRHFSK5/kpoOadqlhjOaa0zplCDHqTKMA+O/i+jnST46Tbs7DzYmuulxJN
mlFIvEgM1qW+EqjEhfdBK/syXjdZEwLtQdh39io8PJyGqR4qLGAceFi83K5vnihd
6D3JBT49oy8kZR1aHOIkTmagW3UM2zD2JZ+0v5qOMIzRsmEuY/r+gEyZRpminf6c
YGZ79OUHjDBdey0KzK0QEDEt1sfeb+udX73o1qGlB6PYHrnBlViUmCaY3mngr1/q
XUPLwtZve3XNf7FcMPvW
=vkOe
-----END PGP SIGNATURE-----

--wmfuW8osuO2pi9jF--
