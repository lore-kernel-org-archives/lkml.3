Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaHUOt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:49:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53168 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaHUOtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:49:55 -0400
Date: Thu, 21 Aug 2014 09:49:38 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140821144938.GH24407@sirena.org.uk>
References: <1408587094.10818.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FIfSo9pyi3Jhph90"
Content-Disposition: inline
In-Reply-To: <1408587094.10818.1.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Add back the const qualifier for ops of
 struct regulator_desc
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FIfSo9pyi3Jhph90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 21, 2014 at 10:11:34AM +0800, Axel Lin wrote:
> Fix below build warning:
> CC [M]  drivers/regulator/hi6421-regulator.o
> drivers/regulator/hi6421-regulator.c:356:2: warning: initialization discards 'const' qualifier from pointer target type [enabled by default]

Applied, thanks.

--FIfSo9pyi3Jhph90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9gb/AAoJELSic+t+oim9DQsQAJvj/IUPtRaNODB13tDAHCzZ
QXBxxfj+TcR1UVgT8tC7Ob3Dpy+hYN+e8YVa1tuxI7klyInAUA2fmP9fPswbtD8A
3M5iM9+NQhbR1DPnAiQXai2YDS5ixU5QBGw7JWTrKh1gmcpzl1PgWAaNyQsqoNCa
m+wyf5D7xNCfYb0ITuCdPQOEPYis9TzGtfB8Ex53o5UmVuLCjtta9o4FErVvD8DA
Ng4XDyzpHq4j6Fs9WmkTHPOxuMlp5UweseGcD5m8yj8mrftNU2IOY6eXAQCwPIio
I+6GLtt6et/lGMUuC786nE0kyVcw5sCqU+1ceJgkP9yuXn1956gfGyQ4/Zw1pjJu
XqAv49UIIzL5doRrEeaaYMp+nIqoQG2HWmZjXX5OQkEqq3w1rHZ1S+jRbCm7Wyfg
3z55faBrvFdkt3i6ldxX3BMnOWjSuhVM1maMX8u1mRY54VlyZe2DV9Hibkplr1qH
AYW18ZZvoYZZr9cEa6V0wIJvjtsp2aZOdROMQ2V3cEoDDhMU8fhJWXCyRrXBdTDx
ywjvN6nsP3QFwmqs/5TkjC1ZoIr8AVtdKGxHolI8hVlVt9CBY2LBggfdnrJrqZ8h
1nIfIFH7Tkupr2Aoa8TpfXh+uB6mY9so6yPimlCsH7hQl3UvWskgospfDDiNYv9+
FLe2IBa7fB9Phq8/KxG6
=nDjm
-----END PGP SIGNATURE-----

--FIfSo9pyi3Jhph90--
