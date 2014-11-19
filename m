Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaKSKPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:15:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52788 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaKSKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:15:07 -0500
Date: Wed, 19 Nov 2014 10:14:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141119101420.GX22111@sirena.org.uk>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
 <1416213190-20935-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141117141836.GA2722@sirena.org.uk>
 <20141118080451.GA3319@jack-ThinkPad-T520>
 <20141118112056.GA14734@sirena.org.uk>
 <20141119073954.GA3665@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3rzwkXnKuCXxoL5m"
Content-Disposition: inline
In-Reply-To: <20141119073954.GA3665@jack-ThinkPad-T520>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v7 7/9] regulator: sky81452: Modify Device Tree
 structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3rzwkXnKuCXxoL5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2014 at 04:39:54PM +0900, Gyungoh Yoo wrote:

> If of_match and regulators_node are assigned, don't I need to
> call of_regulator_match()? Does regulator_register() call it internally?
> So can I write code like below?
>=20
> static const struct regulator_desc sky81452_reg =3D {
> 	.name =3D "LOUT",
> 	.of_match =3D of_match_ptr("lout"),
> 	.regulators_node =3D of_match_ptr("regulator"),
> 	.ops =3D &sky81452_reg_ops,
> 	...
> };

> 	config.regmap =3D dev_get_drvdata(dev->parent);
>=20
> 	rdev =3D devm_regulator_register(dev, &sky81452_reg, &config);

Yes, exactly.

--3rzwkXnKuCXxoL5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbG17AAoJECTWi3JdVIfQRMMH+wQ4CWnx0TsuIabIPrnoNu0b
yImmel5gWDXfT8TXYI5wSrYwFC+eQOFNjq91xNnwZAMFrFmgq0nO8NBPBm5gJSCB
aOtnm/fvZ275QmnEPMgd9W/Sl1GYDo2Araqsv1FT4NpxUXbOIy7YMBfBJtFwX06L
T5xHr21x/9RbdwT4++Z8UHYn4x+rY2TZk9MIIc/WN4wxALGhoEzIxgztlRiulvUY
jTtBKXhwB3JrPisWOIegMZs3zO25E3c0p+23288QQlgi6IwnzHnzdGJZ+rqkrdHn
TmFyqTZxy4QZADlrZ8L/neBxfoOtFwPyrfB5zD9asWDtaBsSz+Fjx6j9f8iQ/kY=
=xZVg
-----END PGP SIGNATURE-----

--3rzwkXnKuCXxoL5m--
