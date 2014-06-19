Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbaFSR6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:58:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49414 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473AbaFSR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:58:00 -0400
Date: Thu, 19 Jun 2014 18:57:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@codethink.co.uk, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk, heiko@sntech.de
Message-ID: <20140619175745.GS5099@sirena.org.uk>
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XDVLi0tRPfHfrgwa"
Content-Disposition: inline
In-Reply-To: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Change gpio-reulator-probe() to use managed resources.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XDVLi0tRPfHfrgwa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 04:46:01PM +0100, Rob Jones wrote:
> Add new managed resource functions as needed to achieve this.
>=20
> Amend the following functions:

You appear to have omitted the actual patch, I'm quoting the entire
mail here.  Please see Documentation/SubmittingPatches for some tips
on how to do things.

>=20
> devm_kstrdup()
> gpio_regulator_probe()
>=20
> Add the following functions:
>=20
> devm_kmemdup()
> devm_gpio_request_array()
> devm_gpio_free_array()
>=20
> Remove the following functions:
>=20
> gpio_regulator_remove()
>=20
>=20
> From Rob Jones <rob.jones@codethink.co.uk> # This line is ignored.
> From: Rob Jones <rob.jones@codethink.co.uk>
> Subject:=20
> In-Reply-To:=20
>=20
>=20


--XDVLi0tRPfHfrgwa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToySWAAoJELSic+t+oim9mNcP/AoNuTkEkqarIf5NnEEjJpaL
aTBTtZP7sjxQ0DjPE56/F+HOAk89YgkK9XaykgeeZdoZRNP8XdpBxHR8mqYdtD+X
JsxJEfwYAKuRznpYshwIdJL9ZkgZMkGCsh4LnIKgpYZBG6hxuVmSWEk5pisf5cyX
g+fDILlk93RX4c6ZnnO38k9HBCQAiXxl6krRDQzCHowyVT7arSSQTOV9BDHGxgE7
Enz1Rfb0psAN1wa1IZHEoOu0qzaoccb8WYrnzMEebeSvyRDqAj/ZA4Gc2rYG9FCN
LukWlUDuaeVSvil+BzLayntaFxPaApkuwcUlKEbFUtK7JbiNWUKELFwSbnw/etNL
mptRcMRZNfRQ69MLO6qMgglxz1qYWByXlWCVlnz5EvLpYbxeDHUAVnXLBE6T+Iht
RHeQSSgXyBoZfoPo7QpZ+RCI6g3iVkl8bXdmcNZyBaZYYlBAlcVZMh4ggFOCpqGs
Bc0sFBQ0L54L+qPwpkX13GPzAVwI2gTeucpkuMx2sLnQzuMKvhuA00my3dbh3iQo
X97Saxa7UeXZriadY6ViNqmcRllPYqeFJtKEWRZHtvcAJIaWkTPN5d86yP9PXerm
hdZwKF4IQP1VGH+7V0P94EZrS/eE5iZWCpufPYuSJ/pwnaZOm2qPkP6BGrjtoJmd
QWvdu0wBDEIx0J46QuGW
=FleA
-----END PGP SIGNATURE-----

--XDVLi0tRPfHfrgwa--
