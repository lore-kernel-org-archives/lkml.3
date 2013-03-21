Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3CUTJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:09:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47823 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475Ab3CUTJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:09:42 -0400
Date: Thu, 21 Mar 2013 20:09:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regmap: don't corrupt work buffer in _regmap_raw_write()
Message-ID: <20130321190939.GI15926@opensource.wolfsonmicro.com>
References: <1363820522-25954-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8jNwmpfkpox/fiJK"
Content-Disposition: inline
In-Reply-To: <1363820522-25954-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will be run over by a bus.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8jNwmpfkpox/fiJK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 05:02:02PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> _regmap_raw_write() contains code to call regcache_write() to write
> values to the cache. That code calls memcpy() to copy the value data to
> the start of the work_buf. However, at least when _regmap_raw_write() is

Applied, thanks.

--8jNwmpfkpox/fiJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRS1raAAoJELSic+t+oim9vN8QAIJHMaviV8yXhkJZ7Y73sYWB
DRhmD0gV/a85QOEHKp7Xwg8Fd0HCjzhZj13RaGbj7YFS0JK0oG4gbgAki+Q5jrdY
pnlvmxmUbxjZ/buNeFAGC1YmE2qVPqF3cXDwivlJan21y7tshwej6xRJRxpKuBp/
4atNyVhIhKzGM4sbwXKwgB915Hnax5VXbvtQxHnaDqyiuz/Op/fde2QNITmoVdNq
DstnTy9r+FhYs66TP0XG2EBKdalupzCRh8eXawPUjBPkcX0qk9cJ91+XmNom0ZzI
937ZY5X3AAsnn44Y204WSOQ86o0zTx8dbYMZ8yI/HvvJXQUJZANeEb4gVrx4QIqu
k36Ji6aJ/SsQgoMqmZJbTGKL93wWrG8xsmsr8oE9OZX9F06GdzmowMkGzQtabHT/
Wgf0O3Urg6Wj6y/kM8hNF/4E6gigAtj9roX/2UHpMwRUoKWlmr/nhcrsYy7q9OxV
wQdcuebYw71f7iAGKwWA2QDYKrLcuAPnYBXnTcN0JvZzILNaOiIU8MBH5H0CW2Rr
8Kl9CuHqIKA4LGd5Yy0Sv8FfBGmeGzFBPVneTf6XhpNPQYEk/WKxW/31AQx7P26P
djvRm7IQcTBM2yducF2DAW0PrNPGlE/n0PGbywxdidfj/u1b18DkUbM+pM41Yqjl
PxfPWSKV57SMs+0yS56+
=M6I8
-----END PGP SIGNATURE-----

--8jNwmpfkpox/fiJK--
