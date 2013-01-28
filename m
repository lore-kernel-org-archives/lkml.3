Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3A1Kqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:46:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41300 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3A1Kqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:46:43 -0500
Date: Mon, 28 Jan 2013 12:46:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the driver-core
 tree
Message-ID: <20130128104615.GA28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130128213535.15bb937175de3ec3b4a09daa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20130128213535.15bb937175de3ec3b4a09daa@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 09:35:35PM +1100, Stephen Rothwell wrote:
> Hi Greg,
>=20
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/phy/omap-usb2.c between commit 148e11349b0c ("usb: Convert to
> devm_ioremap_resource()") from the  tree and commit ca784be36cc7 ("usb:
> start using the control module driver") from the usb tree.
>=20
> I fixed it up (I wasn't sure how, so I effectively dropped the former
> change) and can carry the fix as necessary (no action is required).

thank you ;-)

--=20
balbi

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBlb3AAoJEIaOsuA1yqREDnEP/29Wcc/ajVzn7isKBGq0X3ej
oxhUPUrrddp8vvKV/ExKnMOI2esBH/mLR76050kt4rgD2x3Q00k1/L6Kaq8MH/mA
8WdefkO7CqOkWZbfO+gw4giULEs0yjKvAhBRQWmw7Ev75z5SJ4oHqfWzth5/Mwl9
IwRlf89eUzsJbOJ0Rb95eRwKpaV0t00037oNPxapBqVN4WZUVNqon/dGaTLH3phY
jF8jgcCC/v1lA41pl6sPaPE39BX3StkbaPqfARZLeMaIK1tNE9NwukcO0cv+03Pe
A6JeVJf9usmJJ3xYpw2Nzo8FX2zarzh8BiCibugGOUHXcTjVM46CBiEsPgYCbn06
QZdygRKKGifG28KlA4QWTK+hEhHAkwXER6iLv5VCr1KMbkq4iWj57UhJPTheJYEl
i5pq3bshquk+Iw1o9mXyRgzvyadIrpzWZd9vUqqk2gBoEbId+dPfF+O6ZggGX81Z
gLEsiYyuJ/+ApZcvlYAKTMtw6wFKTGDS4+8iUgIlSyrSQQNCl+D3QYxuyMRGOIpC
KnyaHN1TotYyZOw5LLUqdzD3cZ6m5Lw73F2gNaFzZxVsvt8elVrrtPeHcICILmIG
LdLya/U+YfSiIdIkf0WfO4ZAbjhFXL42ljUYAomlIWfEqohHEGzMEUj+/goVf3MB
jnqqVrefsFeTYNXXwX9l
=znbb
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
