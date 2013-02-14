Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3BNOOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:14:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53991 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199Ab3BNOOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:14:41 -0500
Date: Thu, 14 Feb 2013 14:14:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] regmap: debugfs: Simplify calculation of `c->max_reg'
Message-ID: <20130214141439.GL13249@opensource.wolfsonmicro.com>
References: <1360850644-15581-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DXIF1lRUlMsbZ3S1"
Content-Disposition: inline
In-Reply-To: <1360850644-15581-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DXIF1lRUlMsbZ3S1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 02:04:04PM +0000, Dimitris Papastamos wrote:

> -	unsigned int i, ret;
> +	unsigned int i = 0, ret;

Coding style and are you sure this is a good default.

--DXIF1lRUlMsbZ3S1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHPE4AAoJELSic+t+oim9D0QP/3oOIDjl6aUuYPn7YiVdqfRJ
atgs9zOp78q6s4sW3XL6zIs0bH843JCC7ifBHvr/6fpmT4i4WpDBOI92OCRjBasa
0e9Cm+5lkF0LRFELGHlmeA1CFnRmsmSfnE8vzfPP9/6+eCCsrHoAD2ffRH6T9eBZ
7GzX43x8JRUyEY7Rqg9DXiH66ul9D5uj7dJZL7Blc7Rem753sphCtRDFlh0ybqWu
vMt7Nw43/v/QusujJc4qWNuAGwPjlzphGjfJzGr6UlIl9e8v1GWJnN79/AVMtpUq
XxhqApctctgk6eJrzKNnc4dQf7eeESEWSF6qtk+mZLpkJRniaPE3S6jgnDuoz7uw
d9E6zm9afnt2W9l7an/OVdCHROlOqApI8DuFBnekvNYne3Wk60tzaQLYWNsKNdAN
pleL030/4IxU5tspB1WNsKYiK2JEc/5WRccbvQY0SgysXyoH3Aojdd/L3bn+2bUL
hra2Ofp9M8PoVMu/Axj7jwS2AIWJjPbzJhQ8VWsX64s6sHv/UkN/kcsL8e47pRqr
fo8OmtHWN+j2J1Nn+Cfzu7FnMIkQ/pUcCtZLRbhahw+kqeZDQ46ASgtKM6Cy9uN7
UUeKannSE6C9uqFJ4yvTL52c/pb1AE5iAl9P3u4/1z13pXf7o7k3E6HqJDdUa5Bn
KsrtmUwmoBjeqzP96TtG
=oDgk
-----END PGP SIGNATURE-----

--DXIF1lRUlMsbZ3S1--
