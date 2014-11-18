Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaKRAgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:36:55 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:47739 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaKRAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:36:52 -0500
Date: Mon, 17 Nov 2014 20:01:36 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>, Wei Ni <wni@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCHv2 1/1] thermal: of: improve of-thermal sensor
 registration API
Message-ID: <20141118000133.GA10027@developer>
References: <1416263769-6578-2-git-send-email-edubezval@gmail.com>
 <1416264255-10083-1-git-send-email-edubezval@gmail.com>
 <546A8EA9.5070001@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <546A8EA9.5070001@kapsi.fi>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Mikko,

On Tue, Nov 18, 2014 at 02:11:21AM +0200, Mikko Perttunen wrote:

<big cut>

> > diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_s=
octherm.c
> > index 70f7e9e..893c39c 100644
> > --- a/drivers/thermal/tegra_soctherm.c
> > +++ b/drivers/thermal/tegra_soctherm.c
> > @@ -317,6 +317,10 @@ static int tegra_thermctl_get_temp(void *data, lon=
g *out_temp)
> >   	return 0;
> >   }
> >
> > +static const struct thermal_zone_of_device_ops tegra_of_thermal_ops =
=3D {
> > +	.get_trend =3D tegra_thermctl_get_temp,
> > +};
>=20
> This should probably read ".get_temp =3D tegra_thermctl_get_temp" instead=
=20
> of .get_trend :)

Indeed. Sending in v3.

>=20
> > ...
>=20
> Cheers,
> Mikko
>=20

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUaoxTAAoJEMLUO4d9pOJWJAAH/2qZa9BRjOyRJafxzuMVJsPq
n7vOsR67hXnAL0EI44g6GB6EWHT9dKlFz9P/9oQsdnVxwYJJdyX4w956ZW3Lu2XO
uPc+6hwtkd/iFNs9weunfNG1UzRR/N+F4EDZJZwui8cCqstnhQKwp95LXxCxsj/S
pcEjKbntS12X24HB759xsfKRE5YFlZ2HzBL5MDOBSR71Y583lya5vwShJQ+uuwRc
7ZWaHV26Wy0wiBnAbdDwlXSnkLPt/1E4rsFpM/gfGK5H0aXwpDaOzLHbvllIYrqO
obXnaciSf0t1tODk1U6LrQiN944jbY4iSpaugwRx8g3ndNqPDzHT6E/paexIazs=
=KoFZ
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
