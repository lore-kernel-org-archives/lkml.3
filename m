Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3BTRL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:11:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39247 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648Ab3BTRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:11:26 -0500
Date: Wed, 20 Feb 2013 17:11:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sound/soc/codecs: Convert SI476X codec to use
 regmap
Message-ID: <20130220171123.GP2726@opensource.wolfsonmicro.com>
References: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
 <1361246375-8848-7-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ccJhwVfaC+fHwTsl"
Content-Disposition: inline
In-Reply-To: <1361246375-8848-7-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ccJhwVfaC+fHwTsl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 07:59:34PM -0800, Andrey Smirnov wrote:
> From: Andrey Smirnov <andreysm@charmander.(none)>
>=20
> The latest radio and MFD drivers for SI476X radio chips use regmap API
> to provide access to the registers and allow for caching of their

Applied, thanks.  Always use subject lines appropriate for the subsystem
you're submitting against.

--ccJhwVfaC+fHwTsl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJQOtAAoJELSic+t+oim99zYP/jgOMPZ5Wakkd29LrN/1WAiL
wBImcFcu/W9yqdXljGLj8bw7II0ij4t7AUQTrlN8GRx5F3cOyXFY6kBgTEZgb2sM
iraMj1sfNl5ahw/5SwGP8dkI+J2NxniZIfljSYuNORsEq8P7mP7Y6xsEtJh1/vTM
PLwuVtrMxW3xkaVeRhI38/TgFwsV6umbZw93mCukN4tYXFpI0WQgOo7pao5w4OME
eVHrSNQFO+TwaW2Q/6ZFxo2Q1k2LGcEOXetdJx2FCZvXEX5HfEKEkGgKJUDNSFPv
UUo2jO15Dbw25/VBTdOTNYRoSQSZeZVP9OIx13SpLE1ETsAYoveqCdDRYzvALwDC
y5zc8eRc1tjC0pVKyxV10dTcyb7ViMFjR9RUE5zeInNpt/WXQoIcTPTv1YnE+Po5
GxUqGY1sIsQ5+q0VltEmsKrnqdZRuZo+YBuUZR8gGLl0uqFgvBAS1KbXU11ravS0
6k5wpgjP9ycMxvBiz7ZyyCiOwj7azvrNxYuWk/V1SvZScPed6gMFqOv5FaUkqqZa
YBwRg/PWiLF8rZpuqgsftkTDz2x9dzMcmOH4DJR1Li9p0kP6jBZBf3k6bqlhmc3B
/7VkEKaMHRaozOrsc/JKeohY5XMU9FrGQQDV07j6VNdwMsc7KdNdpOX8iTaDAN1a
274OBz1O0pK2/J+JSSK/
=NplI
-----END PGP SIGNATURE-----

--ccJhwVfaC+fHwTsl--
