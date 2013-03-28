Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3C1A0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:26:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47262 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942Ab3C1A0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:26:50 -0400
Date: Thu, 28 Mar 2013 00:26:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] regulator: palmas: add input supply names
Message-ID: <20130328002643.GU18316@opensource.wolfsonmicro.com>
References: <1363787797-20659-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xO5xrem3WM9Yl24j"
Content-Disposition: inline
In-Reply-To: <1363787797-20659-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xO5xrem3WM9Yl24j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 20, 2013 at 07:26:37PM +0530, Laxman Dewangan wrote:
> Palmas regulator support the different input supply pins for each of
> the rails. Fill the regulator info data with their input supply pin
> names.

Applied, thanks.

--xO5xrem3WM9Yl24j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU44gAAoJELSic+t+oim9GhoP/iPWdrgs1W7dXzhmIMPMth5h
01AnGFHLbMCdUA3oLeLLQJa2S0N/2hyVLYaXcWUd/Rw3JpF+rSbbURpKzNDgnXqm
Djy99ar2DpzHCIYIhKfK6hjXIXOopYELvIoiIbCOMXPehGXd0fCbqQBszBZsJXjt
L70+bq3l87Dhj7n4QXXZcx+Fe+6uDN51HOCMCTQPy6nRS4Oz0PNLkComtNO6j/5J
/5OHEopVpSD7kcaKr5pB7Ax8cpBjP10obblsDpNaxyML8FSlvB31zMRp32rRk055
NLEjqCct258PlQdzTHNo1aaHpdBZxSLYshb5TwCMlCKKGSPvD+SnoRSkLAeoaAsT
M0+tsPrhioXnFi5RpeA+pZ7ZuVeqeDZxyMwcLFzN3KkykevenKRlHPo4X5IvTTKI
j/KbQWk7pS7iMVDTXEjUZHPh9R08nvkRR1XwFECgS5QLrW3EM0V8yFWCA4G308dc
bLOsdqERsV6a+0nkvJrqLJugLwjoc5+t8weYWtIivHggJ14gusuP8WoGDmLQKvbR
+d9rR087jggG0WJSxr1SBYnFVEVT6fVYiYLiC3G9xe46hKhxEkSBWRAnhnfwTLek
fJNOnGzBV6EjnXvMkkL3peIorf1Vap/cKcZD4JH2Nt3UK55ye5EWkzmb3j/ZXYrn
xVw/w44YzDPMxDxYb+vt
=k2hS
-----END PGP SIGNATURE-----

--xO5xrem3WM9Yl24j--
