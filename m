Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3LBL5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:57:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59658 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3LBL52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:57:28 -0500
Date: Mon, 2 Dec 2013 11:57:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Oskar Schirmer <oskar@scara.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20131202115716.GW27568@sirena.org.uk>
References: <1384533863-14288-1-git-send-email-oskar@scara.com>
 <1384588345-22276-1-git-send-email-oskar@scara.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V1B6tgkYnQOXc079"
Content-Disposition: inline
In-Reply-To: <1384588345-22276-1-git-send-email-oskar@scara.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] ASoC: fsl: imx-ssi: omit ssi counter to avoid harm in
 unbalanced situation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V1B6tgkYnQOXc079
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 16, 2013 at 07:52:25AM +0000, Oskar Schirmer wrote:
> Unbalanced calls to imx_ssi_trigger() may result in endless
> SSI activity and thus provoke eternal sound. While on the first glance,
> the switch statement looks pretty symmetric, the SUSPEND/RESUME
> pair is not: the suspend case comes along snd_pcm_suspend_all(),

Applied, thanks.

--V1B6tgkYnQOXc079
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnHWZAAoJELSic+t+oim9sxQP/3qfyjkpRK8alRyZQfRCyCYe
5NWAdlgLhWGv3XjC1pDbyDJ6+AIz/foYP95HEZUXBRuEQmiizWZYwSu0PVEhIlNS
c1EftcWqRdHIixo+iBJrQFWgDBwjHghDOP4DCXPNhoCw69HVgwG6hHcEDGqW3UgA
w57x5Y7N+CWEGQPYptJVdAYzgGVYDyuzGIlscMXHyJMv467fYnOLfpQapBar2SID
xsqfCO/J+4d+Ve18IaOBvmXEVOlYIxK1DKS1WkEsqJwsBbKz3BaLBrVWUjIa6ypt
jROBeJTo459d6txySqmFbeIuf7fV6IDDJc2kvoj6cjldxI7jt4W1aXZDba0Wny7V
vZwS0ltGQLs9VYpkc1c0kGxtX+OibRlNc2vuRq7kR7ndibMbIaLasmiM/SxdvH3U
W+1McshTW8xGpeup7f6JfYI6hnGJNxk6AmDXbOANezrHZm9r46A3jlakKkc/f9rx
k3eGN1bid+j5TjUbYhuUbNKnK1hN1z2sKLHBro39MX8Y3XnY1pMDkx/xzA3reE/w
u3LH+ggpIWw+IyCNjRL45rY8JcV7W7f7CrS3yrI48llstcdHRb1GyQlIkqF5CPjb
/zQ5Ulb22XnqBt09cIvTdTCsr6dU9nC19iEIfOJoUir6Us1NPrBLvtPuF1WaEAHu
zB100pNIJrCP00alME/W
=w35d
-----END PGP SIGNATURE-----

--V1B6tgkYnQOXc079--
