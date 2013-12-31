Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3LaNFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 08:05:01 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56628 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3LaNFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 08:05:00 -0500
Date: Tue, 31 Dec 2013 13:04:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20131231130457.GX31886@sirena.org.uk>
References: <1388433804-30541-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkhOn4hPPRcnTymj"
Content-Disposition: inline
In-Reply-To: <1388433804-30541-1-git-send-email-festevam@gmail.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: wm831x-dcdc: Remove unneeded 'err' label
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkhOn4hPPRcnTymj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 30, 2013 at 06:03:24PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> There is no need to jump to the 'err' label.

Applied, thanks, but please do remember to CC all maintainers on
patches.

--FkhOn4hPPRcnTymj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwsD2AAoJELSic+t+oim9er8QAIFoGdifZi9PwRxf0/3HcfeW
cG1xDEuKAdXQfO1DxR6GPB27MxwvFenYtpDISrPa8sX3UQLlIU1ZhHnvWAAWvNDP
Nm8SmgEc7OqstAMnblP23IWaZVrDQ/cRMBtSxqiSHIlWVMBIs4+G6IzLLHHw04fE
xDz+RI7R67djCPNLIW0kO6OlFw6bbY/MW8UZVKTvxRnC1aDotvu4V7k0kOhtjPFS
ncxpfyPGH+fHG1D4N6NDQkOfu5vimHB1wl352ab+QryhRoLW2/MdpCgjYKKvCrrp
uKuuyK9h6HX95OT5yCrGo+ow4z2SzPxCYU8TtTGHHziQgLlYC27tSQo8KKHm7VJD
ih22vIk37QSgk0UIVpEiCUlABPSQer3fTpYb9j18wKFXDON0tkMIQCJVbTgvmRkq
Hx/JtmOpt75rhHe+ztZSA1MC6JJAkhGEMqul92levhcLI944DR9Iu3fN6KbE00ra
LJKHNCCKrhKxRFxgD/NjLQ+zAeDpc7rQtHJc7Cc9JW+IlhVeaSLcb1GvTc8M9UCn
cTDbey1tjpkPnAPivFnFlGu21J93jSnoqvh9d7tJe7wmos5d/L86ZYZP7V69AKYG
DZJZDx1wqMxC+0etCH3LMkzAFRh9brXp+05kaArgMBPWe34+qHpzXnrXGIY4PYVO
WyEVGVgohqKZ996vCZfk
=qPVe
-----END PGP SIGNATURE-----

--FkhOn4hPPRcnTymj--
