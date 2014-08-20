Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaHTPSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:18:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51074 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHTPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:18:48 -0400
Date: Wed, 20 Aug 2014 10:17:41 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Guodong Xu <guodong.xu@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140820151741.GU24407@sirena.org.uk>
References: <1408329248.12083.2.camel@phoenix>
 <20140818141051.GY14537@sirena.org.uk>
 <CAFRkauAZGnd5JDkvYtZDbNPTt1JT==zyg1a96hbkY24h2kofng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yk1sSvxP8cRAjBs"
Content-Disposition: inline
In-Reply-To: <CAFRkauAZGnd5JDkvYtZDbNPTt1JT==zyg1a96hbkY24h2kofng@mail.gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 63.139.182.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix build error due to const qualifier
 for ops
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yk1sSvxP8cRAjBs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 10:51:33AM +0800, Axel Lin wrote:

> As I mentioned in the commit log:
>     Drop const qualifier for ops of struct regulator_desc.
>     Allow regulator drivers to update ops before registering regulator.
>     So I don't think it's necessary to add const for ops in struct
> regulator_desc.
>     (I think the original point was the "regulator core" won't modify the ops).

> The fix is either drop the 'const' qualifier in hi6421-regulator driver or
> add back const qualifier for ops of struct regulator_desc in
> include/linux/regulator/driver.h.
> Which one do you prefer?

Adding back the const qualifier.

--3yk1sSvxP8cRAjBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9LwLAAoJELSic+t+oim9BGoQAIj7/C8Uu2JNlEklTyAhjdyb
9bZCYa4G44iJ1eStjh6c/0EnkjTYe92DrKByNUVoONUdJ6lx0S6SQoH1zQgc/+n9
rFRjK1gUeUjMxFehocxhbSwIprkdrBkt8HnnJaHd6jkIeeqKDU6jB+OslyQSzqdF
XsvgVVD6l05IdYeXAAPFZfTHw4D2NJAgOFd9L3TpLvjkqM2AMJwc8bmICr+2vKUJ
Qf7+tkurhzGpiiUbykbN+e9xG9khX1bU8Ych5ukTuAk4eW51/ssuHLVjwpeNm4/T
iBX2/hSqTdyoUdoW9qs8JGKh8qZihDyE7eE3iNchuaEWMIrOSO4yRDcHBxLrgeXh
dz2OaXqWNzmj0fZMOFa74D0hl/HRcD9iou2MQh34h/dWXUa3bZ5it0GNBmjknm/s
awrUL2SPT/qIPLT5NUvAGZppHwFTWKsmRsVlkCZJ9kgW3JYSJASQ3QGdNn6q3cta
D5mMnvFXcNKvnfmY635cxZTz1j064AW7g6aBCDPdtYLLw+ZuPlwS2D/HEZSzDNl4
OWYmGJ3ch8DUkyRdeJ9mbLd7I9QTyNqDjAOIHD35Yrd39Af8wqt80V/xArqNuYnh
WGYCthkKLUWHJewlXGR8zeVouy1ptqat6AfPDt0iJ3GWw8Rs1FriVUc81qShBzAN
5DWKNAQHVwK0qp28FpRk
=/dpg
-----END PGP SIGNATURE-----

--3yk1sSvxP8cRAjBs--
