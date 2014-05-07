Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaEGIQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:16:54 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48851 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaEGIQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:16:50 -0400
Date: Wed, 7 May 2014 10:14:56 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pwm@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: SAMSUNG: remove gpio flags in dev-backlight
Message-ID: <20140507081455.GA6362@ulmo>
References: <1393480414-19473-1-git-send-email-acourbot@nvidia.com>
 <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <1393480414-19473-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 02:53:33PM +0900, Alexandre Courbot wrote:
> The pwm-backlight driver is moving to use the gpiod interface,
> which has its own mapping mechanism for platform data GPIOs.
> These mappings carry GPIO properties like active low so they don't have
> to be explicitly handled by GPIO consumers.
>=20
> Because of this change, the enable_gpio_flags member of
> platform_pwm_backlight_data is going away. dev-backlight was passing
> this member, but had no user making use of it, so it can safely be
> removed. Further GPIOs used by pwm-backlight are expected to be
> defined using the mechanisms provided by the gpiod API.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/plat-samsung/dev-backlight.c | 2 --
>  1 file changed, 2 deletions(-)

Applied with Kukjin's Acked-by, thanks.

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTaet/AAoJEN0jrNd/PrOhTTgP/2FPIvOFcimTec4M/F0/whf6
5JaGpsAqvwadgSoDGv3zBxr1N9S2uL11LalPs7g6pNpMBxP0TzEzZ03NLZSOJAfR
sEDAFdlwr1rLU/sdgGoZHq9c7pEeY06T/vBMI9/Od+3Yc6HMZ5jQykZauiWA21S3
tmm+elMbsP1+hH6OAI7hEaCf476l26jc43p7gvixOENXmUbrH9UCY6u1qGuwLWYe
Xz5xHhSF4VcmSbvU9Lm+4VqZGgdQL2oiJqY3jEfId1JyilzDYY9PBRr9BskTtfjD
G0o502Rtbz0MttnhXGweiPGNgVbxQlPa3SmDb1FDqXVlF9NKmRx9bxkiU7AZcHcL
G00ZMK16c5BILFS7Qb1t5qS9OQLKm9Okr12QpDZG82zmQAWsCHNEjAGaXhi/+Y2b
LRPqjlEA/n43NH1qz+G9sLbikPVbXPoa3YJlyUCABmWP0GxEVkWhMfnTbuv0MTg3
j8MFn7cjqDIhuKAYVuTu6EWqKVcCh7pnosH9T0aT6cIPY734bvsoqfYDT/AmR9HE
4Q0TNobuR0g0HtG7HgSL5N73aBLpBhOlBLQQwALTW5TfxYI7yNHskamoplwMIdXl
UJbbgKhd9248ErxbRcl3Vt23SXRzSgsW1fOu8k2Sz6pOzhbYEMA+IgErG1wp9kNp
kmdD7qFNCfC4CJJidhke
=2TFU
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
