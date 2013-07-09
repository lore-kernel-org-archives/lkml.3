Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3GIJaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:30:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56327 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3GIJ37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:29:59 -0400
Date: Tue, 9 Jul 2013 10:29:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20130709092917.GO27646@sirena.org.uk>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-2-git-send-email-richard.genoud@gmail.com>
 <20130708150721.GK27646@sirena.org.uk>
 <CACQ1gAgJyTSdxAKK7uwG-ybE2ddC90podM3+tOAqQwZUspsU8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7FStWnNH2oej3A8m"
Content-Disposition: inline
In-Reply-To: <CACQ1gAgJyTSdxAKK7uwG-ybE2ddC90podM3+tOAqQwZUspsU8Q@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7FStWnNH2oej3A8m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 10:19:45AM +0200, Richard Genoud wrote:
> 2013/7/8 Mark Brown <broonie@kernel.org>:

> > The obvious question here is of course if we can use the same driver for
> > both of them.

> I haven't got a g20 to test that, but that's the goal.

I think I do somewhere.

> For now, g20 is still non-DT, so I think it's best to have a DT-only
> driver like this one for the 9x5 family (9g15, 9g25, 9x25, 9g35,
> 9x25).
> When the g20 will move to DT completely, we can drop sam9g20_wm8731.c
> and adjust sam9x5_wm8731.c (mainly master clock and widgets it seems)
> By the way, maybe g45 could use that also (and SAMA5 ?)

If this is the goal then this driver needs a more generic name.

--7FStWnNH2oej3A8m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR29fqAAoJELSic+t+oim9kTUP/RnXfngH4qYtFNxsuGNduDWY
15Xb5BCw5xkGxG0I155ECa/FOvmgatjSIZEKjmTPVuiDgHpTRbPi8df7yQBXkZQB
xKf5PGoW3Zasld8nj5okR6jNNcHM7T+aXtyTM5PD+JylIxoIkRnR3c4Xj9P4COJH
eMncCKIyZ1yFKUkhElBypGLZukR4rkS3dWBxLxl5TthU0RO9uf+T/UhkO9SI4D/c
xPr4Omr7nwD5vcemYfOa5DbxlSUSka5zVZu+E+dFnpFTzjA+dNfIVrx9LxuNmgqR
eVxsBagptVi+AZdjRSUVD7dAktHCyPQ8M5AOikHy2fmH3SR3aXcwVVrnJNHuq7WF
wUPttHxwrI8EnQEjXHno1mb2/siaB6u9fRRh5A6cQ0Bsx3XwZQRB6Ob7HKhuB8JJ
xUvrY3TDUzzOSHVwtfwX5Zg3XRvf2Aa1BVR7D3Hil8ybNcZvFpuKMb7tO25XsFLO
UpnbjU9BNu2K8XxzaTJgPRr/7NVVo6+VUd+OVpFjPxkuGERw22L9dOM5j1H15vn/
RU5TOZ6IXrijBPZxB75v8yKPIK2DdYyUD+KgUMm9q/bNruPUhpTsRmxahNIO41it
ZZWfe4dc0RT3XhV6aZlNVfpx+78Lrukqf30XUT7czTLSg3wPHbdN20JJVMQbW/az
PpVgOwtW0BV6wN7mhVuB
=zh0I
-----END PGP SIGNATURE-----

--7FStWnNH2oej3A8m--
