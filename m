Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3JVHmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:42:12 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42219 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3JVHmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:42:10 -0400
Date: Tue, 22 Oct 2013 09:39:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/pwm: don't use
 devm_pinctrl_get_select_default() in probe
Message-ID: <20131022073939.GD8681@ulmo.nvidia.com>
References: <1381681071-6021-1-git-send-email-wsa@the-dreams.de>
 <1381681071-6021-4-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AbQceqfdZEv+FvjW"
Content-Disposition: inline
In-Reply-To: <1381681071-6021-4-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 13, 2013 at 06:17:49PM +0200, Wolfram Sang wrote:
> Since commit ab78029 (drivers/pinctrl: grab default handles from device c=
ore),
> we can rely on device core for setting the default pins. Compile tested o=
nly.
>=20
> Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/pwm/pwm-tiecap.c   | 6 ------
>  drivers/pwm/pwm-tiehrpwm.c | 6 ------
>  2 files changed, 12 deletions(-)

Applied, thanks.

Thierry

--AbQceqfdZEv+FvjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZiu7AAoJEN0jrNd/PrOhsBgP/Rg3KNu1HfZV1gD2bgLN/XdY
DCvAbqfkG+bNFNGuf+Hq5VCxwqfYJlfRvnB91r3lSZAkWs93u4kxqmtY3eYrYkYn
esifJ+Ac5ydklG/spD6Xtggj09GpWwcYo5xe7AqzJmT+a5lPSN3rRzcJRo5PnnL7
giKtOIGFV8bfM+fHEY16Ir1xtOh+60NmyXa24i4bCFXu/kyHtxm3fqSPq8cX3EAG
nyksq6126rISMvLP1oEb5PEpaVr4fZx+sje3vuVITpPXC8sjsD0PyGnRyaGnKYND
/Rv4Q4w2me7EHv4abG0YShtlZiaXa7RYUKPTCOTlR5oya7ru6tGw/VaWPEokoffC
YgWviEUwuuYJqmq0yiCnkXwm3gGNx4rWjkpg8NmpExAMn4lNo9MGpd6PoiuyL9QH
oDpVdVjqf3n2nHUZQpIeXEJuS/WokINsXF3MGkPddFkTQ4OAxDGvQWS3VJGadGRY
T6M4c/jKSP8tB7UMaJ2u/7ep/5ZAURNGO08xcvyGNoUM1BITbzWIqMEGNzO5e4zn
d83ONnZ9vWjsjMf5D2zxJZNhwIzdDKfp5b41NKJ8Yn6jrh6dIFrBLLATpCl2PTLV
WJuqqa+xeTryOP19BQwqdHqBkF7cpEfH2T3rxE0P3S3ie07kMkzylIdSDG6yU+7R
BcvWY3YG4rMvzpTsVKXH
=9NwG
-----END PGP SIGNATURE-----

--AbQceqfdZEv+FvjW--
