Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3FEOB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:01:58 -0400
Received: from sauhun.de ([89.238.76.85]:52371 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab3FEOB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:01:57 -0400
Date: Wed, 5 Jun 2013 16:03:40 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
Message-ID: <20130605140338.GC2934@katana>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 03:44:31PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> If a device have sleep and idle states in addition to the
> default state, look up these in the core and stash them in
> the pinctrl state container.
>=20
> Add accessor functions for pinctrl consumers to put the pins
> into "default", "sleep" and "idle" states passing nothing but
> the struct device * affected.
>=20
> Solution suggested by Kevin Hilman, Mark Brown and Dmitry
> Torokhov in response to a patch series from Hebbar
> Gururaja.
>=20
> Cc: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Some nits:

> +	if (IS_ERR(pins->sleep_state))
> +		return 0; /* No default state */

Comment wants to say "sleep state"?

> +	ret =3D pinctrl_select_state(pins->p, pins->sleep_state);
> +	if (ret)
> +		dev_err(dev, "failed to activate sleep pinctrl state\n");

Better say "pinctrl sleep state"?

> +	if (IS_ERR(pins->idle_state))
> +		return 0; /* No default state */
> +	ret =3D pinctrl_select_state(pins->p, pins->idle_state);
> +	if (ret)
> +		dev_err(dev, "failed to activate idle pinctrl state\n");

Similar issues here...

Other than that, on all 3 patches:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRr0U6AAoJEBQN5MwUoCm2NJkP+wTmFx+A3SUevh8UpEBI/mUx
9t7fcyVCteWPIKwRh4hhA5I+HUc3AKqHBPwhR4A2xtHoj6FTKWzKpVTL0hw9vgBx
0SUUml1dXXRhth1YB/Xc99EDIG93mqKTAkGRdndJ8s5nbfhy7A7Q8SLzRGo9sPBp
VCJ8D4XLGZHQpcR1sqZqfxJZQa7nWQqSxM4NxjkkmJhfrN/tRp5fR4lFaKn6tOAC
nEdk7x2ne2L4syRq9G4Sa4IW2Ex6uzOuaKE2tDZMEO1rvqQHJz856rsCzti7BHW5
1E5SyK5d956Cx9QPK4b7yUxC/nvYhNgSc4fslvackc2Afg+hmKqqIGKzMDLWsem6
kGkKqYXQucj+zTyygm+QQd6emy427+DSE4f5iZsjC/HBsMHpGChgTCeNdJj3orF2
BbkOgEqm7m9Dqe9PQuElmXVHWI1i49Q5QRgu44YPdHnrMLfaySyt945xhRXu3TFm
KdHuiQixbwlLfGY3VGP3pO4XadzUqYaxtV5YgMFYHOmt1LxeXyi8VFUprC1XA9HX
gjVeTfexZP2ZpsLVmiIH6rqsWyd55ZBx33Cxk5giMKDKoklppfIVKkOISi+9N8Dd
p6yHJecYIa4zRBNfA1vxxNFGrP38D5I4KcezOYnRC6UExv2XgjutfKx5jyRLy+AM
m57vmAJfu9rIFxWapkNP
=XBwd
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
