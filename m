Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3BCNKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:10:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab3BCNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:10:19 -0500
Message-ID: <1359896994.29976.2.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 26/89] mwifiex: update config_bands during infra association
From: Ben Hutchings <ben@decadent.org.uk>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 03 Feb 2013 14:09:54 +0100
In-Reply-To: <20130201130209.370951271@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
	 <20130201130209.370951271@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3Awv0dUYyhtH4YwzXvf/"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Awv0dUYyhtH4YwzXvf/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-02-01 at 14:07 +0100, Greg Kroah-Hartman wrote:
> 3.7-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Amitkumar Karwar <akarwar@marvell.com>
>=20
> commit d7b9c5204e9c6810a20d509ee47bc70419096e59 upstream.
>=20
> Currently "adapter->config_bands" is updated during infra
> association only if channel is provided by user in "iw connect"
> command. config_bands is used while preparing association
> request to calculate supported rates by intersecting our rates
> with the rates advertised by AP.
>=20
> There is corner case in which we include zero rates in
> supported rates TLV based on previous IBSS network history,
> which leads to association failure.
>=20
> This patch fixes the problem by correctly updating config_bands.
>=20
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[...]

Is this fix needed for earlier kernel versions (3.0, 3.2, 3.4)?  If so,
could you provide backports?

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-3Awv0dUYyhtH4YwzXvf/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQ5houe/yOyVhhEJAQoHrBAAwAyM96GaWwdeun17DW+mU3g9gjihmj78
QeoGBUZ434LMQBogohjMhmVLCGHDILYiJO/qJfSxMC2LEWuyW4C62QmdjrZ1Ci2O
BpLfh4hJN4mwZhhldeY6VLjFNp2Fd4tLIPFwCgi4m7u/sEldOqCqY3lQbMOEUiuh
MEVwl/tXbJk0Y/mWjmmfcWf/8x8O3PI7z4uS9ckednxlnVZEPZC+qrm+zivSry0B
NqzkaCMr2EqL6aKdsJenyj7ouGfi6BGZmEFW2OUjfD3ss5G59MK4eJFgmB4YHxUS
tcQN38xy+4LpUajTRtJ1m7Cov3v5xCO+1c25O6R25VhCs92mdO75O5+rHrUfhnNw
ch9oeEyaagkJ70ACfHJyg0BOfT/Nre/CsjtKmiqC+Sv4OHTStJsrt338xYHwTk9v
dv9jTM055lIwiF+C8mbPh9/UImcCvotJw9Rl3lDX4heAgHxFy12zkZKLUFuJw7mo
CuXLu7HoOblj4Ukjw22i5wwfPS/4VNEsTQLABEKtw093kv0v3+9m1xprzirdHOIv
sLAbLJcCP9pziT8HUAzJtGyy9/QAN4dOz0liaJ2xJgGIvtlkm0hYol+5JUJDuvuG
Q2uOHBMU13kFVWTVsbuzBF4RY+ODvx0jgnGZSDVBdGoNLVRVYE6f4WyDAzVb5rT5
bibMV3sgZZ4=
=fg6K
-----END PGP SIGNATURE-----

--=-3Awv0dUYyhtH4YwzXvf/--
