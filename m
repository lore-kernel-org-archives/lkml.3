Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaEADcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:32:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53516 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaEADcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:32:50 -0400
Date: Wed, 30 Apr 2014 20:32:37 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140501033237.GQ3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-6-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="90KBcPA0h13nTGdQ"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-6-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/15] ASoC: nuc900: export nuc900_ac97_data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--90KBcPA0h13nTGdQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:26PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The symbol "nuc900_ac97_data" is used by the nuc900_pcm driver,=20
> which may be a loadable module, so we should export it.

Applied, thanks.

--90KBcPA0h13nTGdQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYcBSAAoJELSic+t+oim9yv0P/A5Sgpw7ZwhzhYQD+hSJk8ov
he+IvnrnQXwmi8fKVGIvQCwo+wOtYI4fG1YO+KA/EgaG1Sz7ImVMeDpmlmQM1wD+
IP7+vN7P+vtvHZZuQN//TjgESz3JxClSGCFSfRtYUsneyOsJFobbFRHNlSo7pTtf
ArjM9XWjhCmxbP0NZH/lEUD50500JZK4zJ8+CiYZ8sKC1Yr1KayOVVH+pVsHhsmy
NR2CZ6DkF1KUOk3TW38Z7UFZRKmPV+ehCcFeKIdIigDT26VctcmrzgHlsrm2zQT4
X3co8DNEjiv/TVnJUjUUvWa8Jmde1xbghgm53hcxx2P7i+dRtCGZ+ZSWsUDRoTQ0
Vi30Udwm2siaPVgtBJoD/sC6BEnOoOegWtOSe2kA+cnahKdvpo+l4kgp7Ew/kvT8
+L9Sydu/202c+7SczyrkSCIV+gQxQYPYZ7vmOeqe+j16QTpdzZ3JCYZrBGPRJUBU
C5I1sBF8NV7oHYo0XMeZYd9Deji7RbuLHjm1+d8bvvofCfmu1jiE9ErcTmr47PJp
F6v8MNPwtoBpriIkpmx0oiHBX4JL5X5VVHfwz96t7SCFykMdHPztjEw6fsyoFRI4
GrYYSrrb0Zm0zQRNLjAiHekP+jRsE/QJL4sKQzFTRW00h4s2Gpv0Qggui+OR7Dj/
pZF6a0plXW+syUSR4yp8
=OaPN
-----END PGP SIGNATURE-----

--90KBcPA0h13nTGdQ--
