Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaJBKwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:52:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58423 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJBKwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:52:30 -0400
Date: Thu, 2 Oct 2014 11:52:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141002105220.GP4273@sirena.org.uk>
References: <1412234880-8308-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gbLSGltGDiWAAjZc"
Content-Disposition: inline
In-Reply-To: <1412234880-8308-1-git-send-email-thierry.reding@gmail.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tas2552: Fix compilation warning for !PM_RUNTIME
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gbLSGltGDiWAAjZc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 09:28:00AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> The tas2552_sw_shutdown() function is only used by runtime suspend
> support, so only build it when necessary.

Applied, thanks.

--gbLSGltGDiWAAjZc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULS5kAAoJECTWi3JdVIfQYbMH/jgBHPKRJKTu1OUNrBvXO0Xi
4fXF/Hc1DZhbwjVZkj2N4Umg8JnsUZktGx+2bn94QEGQcYEGgN9VajgDDy51DhV+
sXh+Als3s+EJWVLEg3OXxM2TxD3MfTFWOIBPhv/WTlgnLtD7Fb3rxpZvxGdrzHbV
b4uPBlhy+9wJ/sJUrrkL10lx8ajFTKBnbpQwupZfOTsoedNDxzAhkV9xghf6oKta
W04/v/+8qgMT6gxbwLlJxBqQ/C7JpJHlk2hpWxzvhtwg8g0nupqDcP3k99172Rkq
jlwjA4BpJ7astqNVEE0LdQpOvlchAJa4AuZlZZkYYCf3xOWl92/GZ3UfvxM1KFs=
=5VDg
-----END PGP SIGNATURE-----

--gbLSGltGDiWAAjZc--
