Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaKFI6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:58:33 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60151 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKFI63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:58:29 -0500
Date: Thu, 6 Nov 2014 09:52:02 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH] drm/panel: simple: Update calls to gpiod_get*()
Message-ID: <20141106085201.GC26297@ulmo>
References: <1414052218-20157-1-git-send-email-acourbot@nvidia.com>
 <1414052218-20157-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <1414052218-20157-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2014 at 05:16:58PM +0900, Alexandre Courbot wrote:
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
>  drivers/gpu/drm/panel/panel-simple.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)

Applied, thanks.

Thierry

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUWzaxAAoJEN0jrNd/PrOh8hwP/j8M8prHiIFgrmDBoCnGlyBj
KiGMTooMUhGIQNDXDNHgy+Ilx2YIMCLnE4r59LZYMD4HPDH4N0Qc+eUzUpJKGO6V
Hax51SL8WpwhNgx3es3blnyL51crlki6AT8mJTXSL+rv8VmrCp0aUIAKZ5QtuAT1
q1+VMVIjeS1D26n6ErOjr8u0349ZT/FUpSf9BmwfEOTg2Xg2CYsMMbMt4hDrbTvz
l72qGEpXTvY8vSreCCtA+5bMnNLMzfE3CMaiHQhsrYIbH0ZEZp7MbxJGMW+59h31
1pt7zc22tf2u+DKNsVHr6Qhi25QufMrYKCoMAlPiHXG0O6quTBxyp+j6Ke/aTEAI
g9DPMFT9e/3VmE3XyGHc1U9ogejXjj77Fj3Qg3x7drxChO8G+G7nKlXTT/V+yZl4
24I5HEYclUuqO1ruZEL+2gznespBtg6WEhLfUi1mDrj3zxR8XBM0C7i1dcPsND0E
6I8lHrT+j37+090YmZEuIfJje3YoKJw+9tlmYS8oEhfAyviEIc1O2SsHjge8ogNf
xH8G1QwKj6jW4u2i4bcSvMm7s9ag9zEeKKV4pFuWWewwzEf+Qclm9o6s02J4RH1A
qUF9wWublu7/A9NaCNTgT4HJTk/JmdzRxV2zGiiibsZmWSqLqsfBj2RdA68djpHh
3R6QemwYLt+YdRM+sf2D
=bOOE
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
