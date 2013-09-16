Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3IPKkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:40:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40501 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3IPKkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:40:13 -0400
Date: Mon, 16 Sep 2013 11:40:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Wang Shilong <wangshilong1991@gmail.com>
Message-ID: <20130916104009.GA29403@sirena.org.uk>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kv1tUqrW/oiGCBvw"
Content-Disposition: inline
In-Reply-To: <20130916091956.GF3999@lee--X1>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kv1tUqrW/oiGCBvw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 16, 2013 at 10:19:56AM +0100, Lee Jones wrote:

> Can't you just NULL .id_table?

> Here's the code which would use it:
> > /* match on an id table if there is one */
> > if (driver->id_table)
> >         return i2c_match_id(driver->id_table, client) != NULL;

> Matching for "dummy" will just waste cycles.

i2c_device_probe() will return -ENODEV if id_table is NULL before we get
to actually matching.  We could remove that check though...

--kv1tUqrW/oiGCBvw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNuAGAAoJELSic+t+oim9ei8P/00Fa5ryWJOfTyt2FqK/T9dV
KYjRAxLvl+Nz+qNmyB/r4f8owYkkrdm55ozTwWKRbJq6JDJ3fVO8V/OJTkwxkRYB
xETR2aZi1KUKmCgJ/+2xpDjXnbGXEz2ybTA9+qiJE1Ic/pg2h1vkL0V3EMKBzRfW
fmOgp7KGewjSDmIa6S9BCxjzDw38oIbX9QI3WWQuu9Yu25F8TxqJc5oE1OaJA28y
m+qP6CF3Uba1yVXirWEDy3eA+PvD/PkEz2vdamqvO5We7ofXGquRgpN35iqK8Xig
TtA/pKyzTw5LxiLxUqD8EFOwRzpxm87grjHH9VpJOgucm4qP3G/QYxjdPGbrs1JO
OlY+0GrO2IxpzAAmjVPT1coRpVHROcyeSRCvS5AVXiy0BUcjcxiG454A907a3xSl
CB04R5+7EKGH4ZFAXP9ZxCfyMzSJwafEAyxHyY96uuMOqsPxoo5830gYN1PO8qEl
AZ6MIql3MfTzs0SVWr4LAMJCYbZckgXCk8zvtoVl/YTAOtDEKDjTVMS9DntUGCQN
TI7altJyMSQtACtjTBMhrEo94uBHfOlDpJvaGLLxSx+23TOi+RnLa+VjQtBPGGDm
zY8houKzJfYmKLUGAti7GTKFR8Bzdfh34Al6txpRy3lkifmkb2inl0dGiwNZULzO
iu/xWh08zPtjLFCD7l72
=rF0s
-----END PGP SIGNATURE-----

--kv1tUqrW/oiGCBvw--
