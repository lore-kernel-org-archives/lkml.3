Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3JaSh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:37:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54373 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3JaShZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:37:25 -0400
Date: Thu, 31 Oct 2013 11:36:44 -0700
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: timur@tabi.org, shawn.guo@linaro.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, rob.herring@calxeda.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk
Message-ID: <20131031183644.GJ2493@sirena.org.uk>
References: <cover.1383226444.git.b42378@freescale.com>
 <dda0bc1221f053405da616192577228c51821040.1383226444.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3qYtBtpdm1/OJWPn"
Content-Disposition: inline
In-Reply-To: <dda0bc1221f053405da616192577228c51821040.1383226444.git.b42378@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/4] ASoC: fsl_ssi: Add dual fifo mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3qYtBtpdm1/OJWPn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2013 at 09:44:15PM +0800, Nicolin Chen wrote:
> By enabling dual fifo mode, it would allow SSI enter a better performance
> to transimit/receive data without occasional hardware underrun/overrun.
>=20
> [ Passed compile-test with mpc85xx_defconfig ]

Acked-by: Mark Brown <broonie@linaro.org>

--3qYtBtpdm1/OJWPn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJScqM0AAoJELSic+t+oim979EP/ieHTZ0VT5K4I6Ckrka4bOI6
aBBG8IVjrZVySOgn2G46HDEo9xG9Qr2X1+BDS79mlEG1oFliMgRgLdPsSENSiWUx
qg6goC+kS6pqTR+kHykwS9JRRiwpIK23gsXDsQOx0OVk5vdeqYVlgD9fTAgt/Dd7
3dmKpzpuQzxLDrNPiU2VYBZd7rcRwU1uJXfUZ6TqE+4YKWyW0faEaQ/BNzgOS0BC
pqeirRELxXT6ek5G3I5Xms1iVLneJqKh11leOkfCQvu3+M8TNLt1d10GWE9zbcx9
A1kDmOkDVFPNW+igunUhEuBgBBZbdSQzTV2ObiaNvd23zs0HN/tyBAD6gGgYi4yj
3f9ZOSvAc6kzW/by1Ey6L1BHbgTAYMNwB5G6s/JJPMF3qhnL92ntschYtWMAIJvZ
Xgn3OxXCRVm7LbAWEmh6VomqYTdQGEdWkZAESAoyqh0sZsM5Sg00fStbKS6kmItr
1W1SsaBPr8G/s/qV4MAGTrJzIU9hQcMLpfLBg8YkB1AZNn3dqKfOWfms+EFOwH95
3NDjKl8FqBVFUy18RFLmdM2wr2LxdrGTPfvZRK7j+nKjne4e/sa3KwUDce68+Ocj
AVgJgc5L03hIuWVlB2Brrax7IRV0G1xh/iGwTTJg/dv+On40ASAZCgeq5t7LJ5sp
UC3BOQJUTqs38rWNSZKO
=76y0
-----END PGP SIGNATURE-----

--3qYtBtpdm1/OJWPn--
