Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaKFIv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:51:28 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58680 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaKFIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:51:24 -0500
Date: Thu, 6 Nov 2014 09:51:21 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] drm/panel: ld9040: Update calls to gpiod_get*()
Message-ID: <20141106085120.GA26297@ulmo>
References: <1414052177-19978-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1414052177-19978-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 05:16:17PM +0900, Alexandre Courbot wrote:
> Add the new flags argument to calls of (devm_)gpiod_get*() and
> remove any direction setting code afterwards.
>=20
> Currently both forms (with or without the flags argument)
> are valid thanks to transitional macros in
> <linux/gpio/consumer.h>. These macros will be removed once
> all consumers are updated and the flags argument will become
> compulsary.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/panel/panel-ld9040.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Applied, thanks.

Thierry

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWzaIAAoJEN0jrNd/PrOhqlQP/RT9UWBlwSrEtMpDcJ2cwKCq
nwupalbLx3zaO4+XDNj0aQlwOLi+xzyUgoAI1dClZ9adYjHabKXUjQlkAfKQszwF
x5+8eoKZlfDc2Y04CdEiQ2efgfD7bWvV6FEP/ArRCP0L2pchBt/e9XicFKUdJBNb
ZkJc7mHTdkiXWFEFNSZODA2f0YJV/yu6yD9bHDV6PUugj1XMYd5L7LRC4ALie1Cl
97tLFJWBe1e76gD2asu90oO+WehHRJem2OaZoA5zgeONwEtr6P6OA/eIoUQvgXU/
C7yAEYxGtvoH+1GzE8quZRCUs4vDY0kHkpABSmoGTIuK/CtOQ/xUTMqTw751Mu4W
2F7ZOeyMic0HzvWz3VkcDI8BBplGmEziVcwng2FIYXknMkm2ocF0DEfMVJ0dbI1K
5Ta4714h6tOIAf30BtQKH07q9lnhBFh8fOEcrBnkVO38X5zc+CcQYs8eApUxXT9N
D/Js1+YHxELBHjzDHKj0gDpq24hN803q/Ez6JG3Mv9iTpRBD1mt+G1O9EMDxGKzB
IkwhRxqXGz4XqgvHGsTLxU8YSu2vOJmrfywMU6YzTm2D7kaFnIQEUq7QFS6zeC7b
IreLChahjhfcjj5X/qI965Zsgjhzk3dyBcyL15S1RWz0br3h9lXY1z95P9/MB7ej
7R7I5081Qf+SJanbQPLD
=HZCh
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
