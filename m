Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3GHOgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:36:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41617 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3GHOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:36:52 -0400
Date: Mon, 8 Jul 2013 15:36:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <20130708143620.GF27646@sirena.org.uk>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-4-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vmAJtI3ncFun9MAx"
Content-Disposition: inline
In-Reply-To: <1373290193-25300-4-git-send-email-richard.genoud@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v2 3/5] ARM: AT91: DTS: sam9x5ek: add WM8731
 codec
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vmAJtI3ncFun9MAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 08, 2013 at 03:29:51PM +0200, Richard Genoud wrote:
> The WM8731 codec on sam9x5ek board is on i2c, address 1A
>=20
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Acked-by: Mark Brown <broonie@linaro.org>

This should go via arm-soc.

--vmAJtI3ncFun9MAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2s5aAAoJELSic+t+oim9WOMP/2cxxwVEWX3VmRHWRCQooQth
wGxyk7WVqb4JUschwhgTjxcNexDeg3A6L0GhgKNOyqbFLux9EChTqyp7TMsfgPvQ
Sf+ZFA1nDMHCjgU/iGHzVd7NZVuXWf9LRwji+IT4anZMPWBO71Xv7XdDTXvGSvbb
bX3UsqKgiU0p/QUTKCtWgaXUPNmdtpUw8NTGWkBSB97EgU12JtvKUZKi6gOl5ZrC
kGcrWcgPbcrEqPsHuQZZQB3PChl9LV/xPU76PH2yDGMLb/590/zuVSEqyad/3jC6
nxs6Ti32EMm+XbWben+MRBLKIZJzM+Uzw6RWOQKXUK8lObPZ+ZyfRY5KG6JpZY6v
jPAR5R1ScKadF+J7hjIxjpGIqKiOYmH5Ckr3WonXQXlT9ygd5Ji6tzxJIs9f6NYY
mHFpGjbd/6SzHiXUx244G8bI2oEQuBWfhJag9pltUF6oMZUxGMEwWOd32sBUba59
4cQvR4Q2lFsXy0kiKtqatxCrrYVspFf4fPrbfJYkxjicZ2cqUXmrXuzYJ3OMmXKM
2h2lsN3Ao3rBqbzfkSvv6FxQcKXQWIrNFLy2GDsig6qzvcsMINmkbxWL/Ohp7FM2
HMpMbWVPhJF/8dtK63PMcE5PwXVRpZxqSmXB8Wt5MphXfMEwtEod2ZNWf/iAaPs5
2IC4nKzY/w/q1Ijnd1Ik
=yrBV
-----END PGP SIGNATURE-----

--vmAJtI3ncFun9MAx--
