Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaBJMiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:38:07 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:45736 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBJMiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:38:04 -0500
Date: Mon, 10 Feb 2014 13:37:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: David Airlie <airlied@linux.ie>, gnurou@gmail.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/ttm: declare 'struct device' in ttm_page_alloc.h
Message-ID: <20140210123757.GF20143@ulmo.nvidia.com>
References: <1391938998-4848-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/WcH0a6A93yCHGr"
Content-Disposition: inline
In-Reply-To: <1391938998-4848-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 09, 2014 at 06:43:18PM +0900, Alexandre Courbot wrote:
> Declare 'struct device' explicitly in ttm_page_alloc.h as this file
> does not include any file declaring it. This removes the following
> warning:
>=20
> 	warning: 'struct device' declared inside parameter list
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> This warning was visible when compiling Nouveau on -next today.
>=20
>  include/drm/ttm/ttm_page_alloc.h | 2 ++
>  1 file changed, 2 insertions(+)

I don't think I've seen this on x86, but I've certainly encountered the
same warning when building nouveau on ARM, so:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--Y/WcH0a6A93yCHGr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MglAAoJEN0jrNd/PrOhJsEP/jyI0ghrwf8b1kM+dzSzhDKp
WraYwCxiD1Ku+TA7u+JvP9Hl0x28RDnUnAfEyyEgJt1XzsmKsFiNpWUmdSPoN80z
5QWpL28y5q1JPx2Aa8igy6WkLTbCBVXsg3g1rr7Rh54oz2N05u3WTHb+dF8NXRfm
a/WC6/Tx0gPwCXx7Q23N1Mtyd5kjwCUjRgvI10iHm0GBZIiaMGtQVk+7Md7iQNDD
jVzKT0EZvbT3mEl5x7/f/r0bDWoBQUTTOqCP9wVV7K+h+aWx6VTz85oEY28e98Uy
BLsyI7CJe5jWbv3hgSlPsRlchd2lYC0JGf+UkCWYD3aUULsOXnoo0ibvT2Y9UxAv
axZG+I6FM/lyJaTWdkODCAzSPiVJG7mNHWWClkO/CO25AGaziUeQbdWMB4zl6EiL
C+ovdfACJUhraJ13tVWa69dgaBh+rmTcBgV/tfbOF07Gn8LE/tB0w4v9vDkbbkOY
rUWcbjuPgNjTIW3vGM7e/2mlxh1W2suuTDRJhN/OxpkhKu6/1AFs68NpCc8ztitB
sOKaWPI6giimAs1XlHf0WLzlOfbkMLuoCZrQAd6uQXXGJv0tvx+I49bqlW8XXiu+
EJ44lNaMdUNWoUHZ6o/r9XKi8Rb05ok0yC7UbAFfNUSFqLSsfedxhVZUgHiJOIqb
yti5DbYt/PBGqgcP1+Ns
=ocaK
-----END PGP SIGNATURE-----

--Y/WcH0a6A93yCHGr--
