Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3JJToC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:44:02 -0400
Received: from sauhun.de ([89.238.76.85]:58030 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab3JJTn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:43:59 -0400
Date: Thu, 10 Oct 2013 21:43:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ionut Nicu <ioan.nicu.ext@nsn.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: test if the gpio can sleep
Message-ID: <20131010194354.GC23512@katana>
References: <525667C4.3080309@nsn.com>
 <52566971.5020700@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <52566971.5020700@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 10:46:41AM +0200, Lars-Peter Clausen wrote:

> > +		if (gpio_cansleep(gpio))
> > +			gpio_set_value_cansleep(gpio, val & (1 << i));
> > +		else
> > +			gpio_set_value(gpio, val & (1 << i));
>=20
> The proper way to do this is just always use the _cansleep() version.
> gpio_set_value() only works for chips which do not sleep,
> gpio_set_value_cansleep() works for both those who do sleep and those who=
 do
> not.

To the gpio-list: Has it been considered to have sth. like
gpio_set_value and gpio_set_value_nosleep? I'd think it makes more sense
to have the specific function have the specific name.

Regards,

   Wolfram


--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSVwN6AAoJEBQN5MwUoCm2MuMQAJfpsgqRQ4QYK+J5fzp7Lgot
kr41uwk7mRrX5hT/GlNBatG9PESrnTb6Baxf1wBAQMbSyBUzeJhrlDeISPuISXgf
FX8qVLsCVIZj/aK/KzERLsRK9AUxKyFcGMFqW4MDYD/FlsWufyraPBsNrtIG6ict
zzhGd6zIdWnmgwoUm5D0vPpOziBuEx1ltmQ0AsTf2qR7IvKCWTOqUlErCPnnYL8r
7kPqM97wJ16sxg1DQcvL41AnEa/Qae8sRIpbwqP4ycRyCVVINmiaHiDY3GkbltEC
iUUC95qSWscmi1klGoykZ9yrWHGWUlvpLZb2B7xBvz9J4P4Z+NhctkOD3Pn43lpK
nKCEcGHyNuab5voxxEBwC9/WklnglhnEn87j9IcFXKbj2tcj33xXYIek3a9E0uOf
ifKySkbv5rWRYYcOXQO4DnZQhYNbTA0akDLxp/Wr53oqUtFfCuRgoRVZMGppDJfB
rJN4VmIKsDnYrpiLPqbuBWg3D3MNPnTTejfKie03mTyExEuyDAwzaQjXquKMCRJN
7EQiBR5OoBfzyrwlToE/aISupn5+TncpdjVC27wlbhXVYhI46PFbLzwbQQirDsor
vqrBMkyPzzz/3DJ36JDdlTgF/j+shznI0rGMzLRDOjm57PirrlOT3YMHJLUcSoGG
0xydpcb2o6/86Cgt2F8k
=ybw7
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
