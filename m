Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaHRRfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:35:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54492 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbaHRRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:35:04 -0400
Date: Mon, 18 Aug 2014 19:33:49 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ARM: sun8i: Enable pinctrl, i2c and mmc
Message-ID: <20140818173349.GD15297@lukather>
References: <1408380711-26308-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PUgybOivvlPvn0/l"
Content-Disposition: inline
In-Reply-To: <1408380711-26308-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PUgybOivvlPvn0/l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 12:51:49AM +0800, Chen-Yu Tsai wrote:
> Hi Maxime,
>=20
> This is v2 of the remaining sun8i series. I've dropped the patches you
> merged. The remaining patches have been rebased onto sunxi-next.
>=20
> This series enables all the controllers on sun8i that we already have
> drivers for, excluding SPI as the tablet I have does not use it and
> I cannot test it. If there's a way to test it without external connections
> or devices please let me know.
>=20
> The commit logs pretty much explain themselves. Note that PLL6 is not
> implemented yet. I've some patches for the clocks that I will send later.

Merged, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PUgybOivvlPvn0/l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8jj9AAoJEBx+YmzsjxAgy00P/je60R60oH4/cMXCGyZWmcYa
Vo3rnXoQ3psxCcX7FmkMI8P9ICldc2pNcG4jVotdRZUiBtmIyQTb9jUir95RsRy+
pmCXJyiansKacktzw6mtsK3fGuQduYGLZH4826MGHnQyvF0cKG8mMeDYVWKMjV7d
qLVBRy2A3ziM85K+NoDKthm9OQMNal/yRlhOU16st+lBmcvLWlk0akFf8JAGH7GE
avSsuHXTxjWwjfwzWKUA41g1Wh5FnSTiJ0zhIPlERlFjd8uWYOhUoLNETm34aMwi
tt83Wv4nBaaqNqueTaghm/W/+TU/WUPPmOzpwiMKkvRTuF6CvUvdrTwyuRgSmNq2
T3tdra16dUyHbzMn6U/oTQM5GiTIB0LBymcxy1uPIOKAOMRIRmRQabjQoBs0HSM+
SMr9u/yyZfol4q6cm4uOtdv78bVgnXjSaThFC4z7rr82G0Ittd1p6LSgUyClQA7v
mxTzcI+IH7e5rBBHG6b8DMWIBCH71+3qRWUAHbAQ9XpAe5ngUXyXVGwLypTdYUYa
vFK2EqCby6WB1jsi226PP1yA4hGg2/2iCdHH6WugP47DBpN2gWFavwrwBYOyf+ma
DFhh2nox1dknmgWB5aIMZUEGsXIkOJoQ+o8wNSIVv3OYe7d+UoSnUWmzSSqKojvt
CD+pDN8OZbCiqQFbjptx
=3juc
-----END PGP SIGNATURE-----

--PUgybOivvlPvn0/l--
