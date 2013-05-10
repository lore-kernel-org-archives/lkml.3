Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3EJLMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 07:12:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42391 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3EJLMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 07:12:32 -0400
Date: Fri, 10 May 2013 12:11:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20130510111125.GR3200@sirena.org.uk>
References: <1368009546-20770-1-git-send-email-sachin.kamat@linaro.org>
 <1368009546-20770-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/Dpz40iF3jpiHxF"
Content-Disposition: inline
In-Reply-To: <1368009546-20770-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: palmas: Fix incorrect condition
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/Dpz40iF3jpiHxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 08, 2013 at 04:09:06PM +0530, Sachin Kamat wrote:
> Since 'id' cannot take two values at the same time, the condition
> should probably be an OR (||) instead of AND (&&).
>=20
> Introduced by commit 28d1e8cd67 ("regulator: palma: add ramp delay
> support through regulator constraints").

Applied, thanks.

--2/Dpz40iF3jpiHxF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjNXZAAoJELSic+t+oim9wgMQAIvC0a0ATHoHcnfnI67IosGO
y9Oo8SFRHFMhU5PWqppVG3P9zmK0vj9ULMUMiB6xiujGm2eFlnxGgAvc/TPgZ824
gFGquXKpQmGxytj+bkILiaZMAMsOzMYk0CG7fUdAgfnYYUOWAiIy8BUmiM2qO/zQ
stM30ngPyWSdWY4hkHAK5+cCsObnU0b8zi4DayPwoGzs5cmf9Py3cvCaQwIEmSF1
oVsGaEUAyaf6J3VHuLKp5D8mhpztM5IcWgVrRkKpm4zDnc52U4UcY6XGZXHJYSsd
PNGn7gr1O0UgmmgMWkug4uTbJCGbLGVXWfRzuiMfDwRDSuBk9z+O15ml2D5DoARX
0H0b5b74yOCL7FPPG5BFSqP52BplXbZzJOiGfZIMmlQexYHcK4tQNGpU/gQ7MswK
kl4VVMt23gZoCWEQBXgrdkR7PAZ9Kd2wk9TzWmZBJWOhZ69goA3BxvWED4qKJlU9
rL7TiBN4RGbCK7dhZwcn2piym4KvK+9KeBnydHPS7wDKzUGDuzAN9KIAMLlL+s7C
CE37iY+04tsBvwSb5bUtfo6a3k1m2rBOq5StdYkQcJVZQVitVTwWHZm6p1B4fBHo
eX0vukHfxuguRp9ymG7mXCMBtMg6CS8LPK63WSlOumh6HF20ngp0Ton+Gbz91aIO
FC6bUlt9khn5WRbxkCaR
=2KQC
-----END PGP SIGNATURE-----

--2/Dpz40iF3jpiHxF--
