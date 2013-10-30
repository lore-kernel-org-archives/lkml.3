Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3J3Q2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:28:54 -0400
Received: from sauhun.de ([89.238.76.85]:52845 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab3J3Q2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:28:52 -0400
Date: Wed, 30 Oct 2013 17:28:48 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use gpio_set_value_cansleep()
Message-ID: <20131030162848.GH3663@katana>
References: <5257EC46.8040603@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5bfZ/T2xnjpUIbw"
Content-Disposition: inline
In-Reply-To: <5257EC46.8040603@nsn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e5bfZ/T2xnjpUIbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 02:17:10PM +0200, Ionut Nicu wrote:
> Some gpio chips may have get/set operations that
> can sleep. gpio_set_value() only works for chips
> which do not sleep, for the others we will get a
> kernel warning. Using gpio_set_value_cansleep()
> will work for both chips that do sleep and those
> who don't.
>=20
> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

Applied to for-next, thanks! Added to stable, too. Also, please write
the changes since last time. This really speeds up reviewing!


--e5bfZ/T2xnjpUIbw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJScTPAAAoJEBQN5MwUoCm2JCUP/0+jWv2Mn2bE2dx7K8kEcHH9
GjCRAnuapj3kuyFJuKVauuwiNMP/eMrKgiKK0eiDVgEJmCWdWD069DCHLqEYI+Q1
awzIHqGlHLoWB++hTZD1tScBIqp7zXOcYmkNeYnFDAZO8pfbE5ZuISPl2pR16Yk4
ix05Q+5xmFH7cze2LDD888ceYxhNP+/PVnalk++s3oAVr6/Q3aehPNOHpRpji32n
lZ2DlqLaRvMEzkrTrp4cBp2wUg3hWwS7d4eBVAL6Y2ebAak10D1n4MRiaRgsS2Qm
nvHnwtUm+wuilR8QMaycv+d+pyYZOFqS6KDwyo1RMrlX8fRtMo5dakM+hx7fnosV
/MvHA/GPJKZLdKqVgZPHeH8dQrtwzRzh957SkG8rRkpVF7jauCPd17/QPj75dl8l
TM8pGkDH5cXSxupWExM0XDOlFWa+Dcevt/+o/G7KugGqP4Zp0gzuHXI9O2fIKXcN
MUA49zuu4oPr2vb9U4UQymx8Xv2yIznRDNdJNn3OkqpitJqsXveNG46+qS/VfuJe
ltO0zhcQOQcT8HLy9H9PR0nYqAEkkNdGo6gEroOlibFDoHHHq79vF3+JkY3SsAw5
EWlW7lXYBDyx/lr8ASDGgJYU9sZ2FZXmHSKLjlnNbTDCQ1D1UzPYj40TqHt+QLPT
bhqbekY3vjEHyzek+N3M
=DOj4
-----END PGP SIGNATURE-----

--e5bfZ/T2xnjpUIbw--
