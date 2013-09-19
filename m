Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3ISNWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:22:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40872 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3ISNWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:22:47 -0400
Date: Thu, 19 Sep 2013 14:22:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130919132234.GQ21013@sirena.org.uk>
References: <1379582286-10600-1-git-send-email-treding@nvidia.com>
 <20130919104525.GJ21013@sirena.org.uk>
 <20130919112104.GB10852@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwwPlZPbpBX9O0Yk"
Content-Disposition: inline
In-Reply-To: <20130919112104.GB10852@ulmo>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rt5640: Omit ACPI match table only if !ACPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwwPlZPbpBX9O0Yk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2013 at 01:21:04PM +0200, Thierry Reding wrote:

> Or perhaps we can annotate the table so that the compiler will stop
> complaining but remove the table nonetheless if it isn't used. Similarly
> to what we can do with
>=20
> 	if (IS_ENABLED(CONFIG_FOO)) {
> 		...
> 	}
>=20
> constructs. I can't really think of a way to do that, though. Perhaps
> gcc will throw away the table anyway, so we'll just need a way to make
> it shut up?

There's an annotation which can stop the unreferenced variable warning
and then modern compilers are able to eliminate unreferenced static
symbols.  Not sure if it's actually worth the effort of doing all this
though, but it is nice to be able to avoid needing multiple builds.

--rwwPlZPbpBX9O0Yk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOvqXAAoJELSic+t+oim9FLYP/iOV4teUC3n7y1c5yChrKEIr
mWPc04x4xq2GfFho4ySCFQ1xAaUDp6DRMSHAGfpPI/X5ZpDV7SbJ2ynztRrpio/P
XYIMFusWWWbziaFdCGIsRWlIYiDMflQ20qMt+a8/5BEvizMfPpTCBS+30ib1PBqS
fz0nufBfa3s0mZAGkNF6wANnMCo3EJSG81JQSqo/ZqbIE6LbBhadRoZMw4glQGyu
PYIp2dp96RbcP/4PC+o24PI5gElHkACf9R7ADJQpoWfpvj12VKLXMd4AoV/DlM5R
sjhRYSNsrAJY49VV4lZJa8+fEX3BdepeQAWcJM8gAyNEZUIPxXJmjFv0BhNVgqr3
QcEdQhnIK1QBFY8A09sDykxpw5gRQGtybBM3C2hh2vpOyTvc420d/BwrHILIYAmw
7aBMoriwGc0Iu00fcLEx2OaZ+7AECsL2c5F7sjaa7UY3zfdPiSZwlSr9D6eB5WzB
lL0fQL4676CXHnqZ1sJVXDNJi12u+Nw0TlojU4ojAeXVYv6GbMQwb4hf12k6Tn7t
crhcryvx7tB+FkL4zYyxopcoK2H56wHJOjJdSSftfRlmKt7ZCnSZWTkLt+KcAYnW
Slvbg3MZQ2q4S4zKtiVmXcaR1lSyiqp7wgScDXnFKMM0QQxrfEwKxq5tZngTLN7D
hskZsk8x/h7sScaShqRO
=3R8o
-----END PGP SIGNATURE-----

--rwwPlZPbpBX9O0Yk--
