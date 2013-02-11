Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3BKNQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 08:16:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49027 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157Ab3BKNQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 08:16:43 -0500
Date: Mon, 11 Feb 2013 13:16:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: debugfs: Add a registers `range' file
Message-ID: <20130211131641.GG4607@opensource.wolfsonmicro.com>
References: <1360579943-29938-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Content-Disposition: inline
In-Reply-To: <1360579943-29938-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: It's all in the mind, ya know.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 11, 2013 at 10:52:23AM +0000, Dimitris Papastamos wrote:

> +struct regmap_reg_range  {
> +	unsigned int start;
> +	unsigned int end;
> +	unsigned int attr;
> +};

All we ever do with this struct is

> +		r.start = c->base_reg;
> +		r.end = c->max_reg;
> +		r.attr = c->reg_attr;

pack it with the contents of a cache entry.  Why not just use the cache
entry directly?

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRGO7zAAoJELSic+t+oim9bTcP/jsC0wt4SRKGaD4ioZO6yhmI
Ujwkrl31J4Tx1kMEKGp8AGMj1jmgAJEXLF2awP17V93D+vsF5KWhGcuEDZADwiBY
SSqyVPzVgAZQJJrjzNG7i8J2R5KMNRFK/Iq7m+ZhOs57zLqMSaQZa1A93faGtFIn
MNwK4Ap1h2WZiwB+L1FoyqMmzrsbwWKwAkh04neicLsDAQ35SJcBeGuAcsfmPBCI
UMOMM6zxbM8FK/OOrsWeEIXyHpegx0Rm5i0AZFDZ/ERNcWbJfg/c642lJrNXfXqN
YE2zyB+a/mLdlG0AvCoKEII3bA405bYaTHZnpXDUmi/Noeh+fyYAMhRDsybw1k4z
GZBRvWjqFr3LD8piAUjtMX0QHOvpfeU79X0W3FwHEqb/5vq0bxQ8nfWJpD+HLm4l
J8vlx0UzgZDE3x043aoChA5Uv8OwBfu34ss0OCgkuPbPsVKZ/19DUxhDs2GY2r1u
i/IcNTFZLDJbX4A8L4efJuDB/Qhp+xkBRNovrjUGSda4Z2SQRnSKU8YPZFwRhLhA
OEfZfbHdPwIroJCXsfT2+PEE0b2TjN0CDDHBH/vNHe43ZMSJuciVLfhTIcVLtP9K
5ema1S3mn3YBKz1RK2f8OGPJG4WBn2Dwd1SpGoFZXBGKgncgtrdAlmqWc5yE15xY
bXFZyy2bRSna1im5AYke
=lBs8
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
