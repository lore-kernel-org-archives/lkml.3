Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaB0MJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:09:39 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:50703 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaB0MJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:09:37 -0500
Date: Thu, 27 Feb 2014 13:09:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pwm@vger.kernel.orig
Subject: Re: [PATCH resend] pwm: Remove obsolete HAVE_PWM Kconfig symbol
Message-ID: <20140227120932.GA21422@ulmo.nvidia.com>
References: <1390550056-5924-1-git-send-email-s.hauer@pengutronix.de>
 <20140210102017.GA20143@ulmo.nvidia.com>
 <201402252011.01902.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <201402252011.01902.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2014 at 08:11:01PM +0100, Arnd Bergmann wrote:
> On Monday 10 February 2014, Thierry Reding wrote:
> > On Fri, Jan 24, 2014 at 08:54:16AM +0100, Sascha Hauer wrote:
>=20
> > > Thierry as PWM maintainer has agreed to take this patch. Would be nice
> > > to get some Acks from affected architectures. Russell, Ralf?
> >=20
> > No replies for over two weeks and this looks simple enough, so I just
> > went ahead and applied it. Thanks,
>=20
> Am I looking in the wrong place, or have you not pushed this for linux-ne=
xt yet?
> I still see all the HAVE_PWM symbols in today's -next.

I had pushed to the wrong tree. It should be in linux-next as of today.

Thierry

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDyr8AAoJEN0jrNd/PrOhWnEQAKG2U1vH7WlWZD6g/EVnuatb
InNz3qzabmofTy9PP5UubiMnXvV4+FLC6ILxD7I6puetlRrq61YEXpxFxWfPfK/x
apEISxfgunAW/JDq4Hd0GYx2wCk8AhvY83eCYosd/gZiXvjDPzfcGxVNXzZ14OZY
qOMiS2cWWRrQbg3eoQS08o1pPhWf4h1Bb0uT/Pv08u4+6Ma0eWHNfBPMhDFZrgNS
WEXbbWKyf20k/GgBfbh4n+6YXHGN6vfIIclh4tZqs/EgGFyfHV1/wfdi8ZDzBjeh
uvjSMfablMGK98hzja72i/nBGpL4qmE9BSFeXIoFNvbwsJiKpqwjkU2/SoR24LAW
2zwtip+AVijGusDMtRaGnfg/7mFWTkiqLqw+pGwCforlqABqPX9txx5L1CobzE7i
n3vC+OmlNd2XllxhRe1Q5PfdLsymIEB3+l5ycKY6diNF2Kp7BhByKXMR3rYHxVql
+cdkE2agfiOWIRxYafSTipFVIeLTj9iklmNaB994Mn5k5USBL4KLmn2BHhTB1SWf
WXRuIyJ9pfmi4FaviaIyYm6/w8uwmJ0drR/TAFUIWdsSmZ2fG/b7kP3nS1oprM2S
VntTziwPyUprDT2u7SeE6Hdwdz7Np1ym2b8qUgHz5JPqpK1fB4+YVc9d5y0YlXjR
NObGFmaOHNrSrhVBj3Uj
=1pq9
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
