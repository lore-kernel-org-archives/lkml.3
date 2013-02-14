Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab3BNLGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:06:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51152 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933839Ab3BNLGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:06:42 -0500
Date: Thu, 14 Feb 2013 11:06:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regmap: irq: Add support for interrupt type
Message-ID: <20130214110640.GB13249@opensource.wolfsonmicro.com>
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com>
 <20130213135440.GI5062@opensource.wolfsonmicro.com>
 <511CC41E.7040608@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <511CC41E.7040608@nvidia.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 04:31:50PM +0530, Laxman Dewangan wrote:

> is this mean we should have variable like
> .supported_iflags which capture what it is supported or not.
> And then irq_type_val[MAX_REGMAP_IRQ_TYPE] as array and define the
> REGMAP_IRQ_TYPE_[FALLING/RISING/BOTH] as index and client can fill
> this info as per the hardware or

I think this option is best; it's going to avoid us having to write
explicit cases for every single use case.  But perhaps it's going to be
too painful to work with.

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHMU6AAoJELSic+t+oim9u/IP+gPmwxUKV9XS5/X7wF9gDtfy
hD29RzxMtsEcnqMai03Inz7485n9MxmR/w6PDf27Wb0hcvctSWT86wqWOd/r46ct
4szD89wTlrBNGjUb3Dpzy9ocM0xU9vlL97InPQaViBzfiiV8BxZA6qyMQcCMNmXq
YP8M0GPznxL09JoYLQA3h5iOenPtkB4fN9C5t8DoXQ10Pyra2vU5wlkOHQNn4Eh/
BZKxLkZ+tNeyuiJwmA5g/OTLimeFZh36sjLd+Jb5W4gAuyKnoVKz8e2Il4PFjWd+
PQbpfWsjV71E8yGDhe4kAY7YKtlUMRxFSwgS3iZNKHfgeH+umJA1ge4TNFDS8CTn
Jv/ALMcifEuN7hk98Y8MhjJR7e3bx4rR0Ewa6xxFodhUCVRmiXvZ7x7+RcnULYQ9
/apK406LjS7U9vGtD0z25lFLmRGYvCakARzE5KVgrMUayQZo+yV1kRcygsBO7zpD
nK9zZlLvHPw6ARmMc7n1xJXi1KO8Ibc3kh0GUY76iGFO7+puMZgvk4WNWIVAIHUu
i2+Lj+f0nvX5GKH+aaskLO9wqO7zvE7qXNTI7FjAQrYl/nMVmhuVGGrZs/5XdW6X
gfMRi9DZSy5HT7SvMC+/pNIIpfH/tTIxbZOmwD1Tl9ojqZmGgtqWUvyXqGpaZ+xe
oY8YlP/D+KtsXefW0VYo
=v6G1
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
