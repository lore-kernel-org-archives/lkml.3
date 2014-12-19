Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaLSU7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:59:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:42555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaLSU7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:59:43 -0500
Date: Fri, 19 Dec 2014 21:59:36 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH RESEND] power: reset: augment versatile driver for
 integrator
Message-ID: <20141219205935.GA27012@earth.universe>
References: <1419004587-7580-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1419004587-7580-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Dec 19, 2014 at 04:56:27PM +0100, Linus Walleij wrote:
> Augment the Versatile reset driver to also handle the core
> module reset sequence used on the Integrator/AP and
> Integrator/CP.

Thanks, applied to the battery-2.6 tree:

http://git.infradead.org/battery-2.6.git/commit/02088e3ed79f0639d71caeb3dd49d42f88746c88

-- Sebastian

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUlJG0AAoJENju1/PIO/qaqdMP/0fmnNsWHqwbWGjuCbXut/c4
6JbXiJQNImqZxw6JbT6OCZCMI2Lx/xocqPt0E5ajDOXKRvaTAWqUnxMvowU71yID
k+FuECYvhL+w1kpvWbddHFmSEX8dYbbd8LWKyDA9xVZmq1DAAoABkpEPT30/YE6t
sBJqg5g7goiS0xtjcGCWNxc3mvbhSeysQP0JuBHXTdvDuzFRLwwKmR4LITxCdKgF
9ZsCEVRSkuJ1w6PgxsOdTofNrikbeOkzyFAQEj4uGBZwf0+SxuNnM+YR33NJ957g
NlwLtlVrf+imQFlqV/Dzd0TUUV0GptcLMI08chENcCaXZbUbO9nBaRumZW0yRQGs
WSAQ67YXHq0LVP5YgOIxvmx3w8m7YIwUnRWE/gU7CZng3yUDDLB3w+NERVl5k4xg
0Azq9Byncf0OM2dn0p0FJwQ997KavKcbjjXh8xpIUEkUKD5ylzVNhC5vCYzaXJ5X
/a+E//5/5qorXPqPQW8QAi1NBMMXe/IjEAclbLEyWl87PeUrlv6V1CkaPf8HhyLX
iuGgeJrteDuCXGnQJNi8uNEVbTqjeesdygbG51DenthU0A4Vfu6jj6waHRBLSGtX
gEDmxbyAQlkqOrWmFynd3YmTN2uAynpt4aotWxjmBPN+LZQbP92HsITOU8D41pzD
KCVq+QdVet17KUO0dPLC
=qTeY
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
