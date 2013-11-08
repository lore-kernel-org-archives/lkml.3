Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3KHLMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 06:12:23 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33805 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab3KHLMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 06:12:21 -0500
Date: Fri, 8 Nov 2013 11:11:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Wenyou Yang <Wenyou.Yang@atmel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131108111152.GL2493@sirena.org.uk>
References: <1383816846-10561-1-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s6Wo+7iKhEdF4/RK"
Content-Disposition: inline
In-Reply-To: <1383816846-10561-1-git-send-email-richard.genoud@gmail.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.69.173
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: atmel: add support for changing message transfer
 speed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s6Wo+7iKhEdF4/RK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 07, 2013 at 10:34:06AM +0100, Richard Genoud wrote:
> The only speed available was max_speed (the maximum speed declared for a
> device).
> This patch adds the support for spi_tranfer->speed_hz parameter.
> We can now set a different speed for each spi message.

Applied, thanks.

--s6Wo+7iKhEdF4/RK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfMb1AAoJELSic+t+oim9mokP/iqAJ0SWcE4KJH9Tg73t7FDL
m6QQImAgYJL4cBsRAYzu9kwnAXXbLlgq7qPNw6iH6pjn/FdGw5tqQoxvamDEx0IK
bxy2dGvX1HsIGkQou0AcPn0vVJzx5N9sh397rdqzOzcV2N0JDJCi5P0TsuxjjBFy
PNXbf/nTm6OA17ksoFFINHZhO+rTOVO38rb+SCYX8pyQNV7Bl7j/qKY+orfbE17h
1DKAUfxBZF2zq8L2zJ1SMO7NIbwwzm7423g9W1W2f/UQHX7jmM0TNebLNH0I0Nx0
ZejIHKm4YiYNc617MNcdVWMAf9JyBvvJ7aBDZ6zzJ0m+xK0XK16tozZj9OshNQHB
8jmnEOkrRN0NG8//G7uh7aEk+vH4JrV5uJWX2VeJuOC5N6V/9uxlFIfUEy1soMUj
hhKbJDHYKZcN4a9PcumFOFxfWqdlAEqcX8HCBM5xuclAbfBwnkrCbkmg4oKukA86
maLMiOMQo1rGMx/aUILbwvZPQWiiWeB41ADMMlPY8iKIdW30jQdQOHjH766bcI04
zarsI3zr7Hc57lLYzhcHFq76l+STn2VbYlgRXHzSzDPhUVvK5ZB/ZKyC1SY9ttrJ
5c6dqEk2upHBO6n6bTFIOZrfOFtEObVVvhZhcppRuqDERhlasZQjhMWTU3um3aUS
FqROpNSFRv2GZaJORWFl
=6SqR
-----END PGP SIGNATURE-----

--s6Wo+7iKhEdF4/RK--
