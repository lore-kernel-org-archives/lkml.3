Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3C1NKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:10:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40359 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755349Ab3C1NKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:10:50 -0400
Date: Thu, 28 Mar 2013 13:10:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] clocksource: Fix build in non-OF case
Message-ID: <20130328131044.GA18316@opensource.wolfsonmicro.com>
References: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201303281239.46639.arnd@arndb.de>
 <20130328125513.GY18316@opensource.wolfsonmicro.com>
 <201303281308.22738.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lAtGKe5+IF8yYOOm"
Content-Disposition: inline
In-Reply-To: <201303281308.22738.arnd@arndb.de>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lAtGKe5+IF8yYOOm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2013 at 01:08:22PM +0000, Arnd Bergmann wrote:
> On Thursday 28 March 2013, Mark Brown wrote:

> > That still looks like it'll reference the function?

> Yes, that is intentional. The idea is to create a reference to the
> function so gcc doesn't complain about unused symbols if the function
> gets marked static, but at the same time mark the data structure we
> define as unused so gcc can drop the structure as well as the function
> if they are not referenced from anywhere else.  This should let us
> get away with fewer #ifdef hacks in the code, better build-time coverage
> but without producing larger object code.

So GCC is supposed to be smart enough to figure this out and users need
to not do the ifdefs?  I have to say this does seem a bit surprising
=66rom a user point of view but it does make sense from a general niceness
point of view.

--lAtGKe5+IF8yYOOm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVEE+AAoJELSic+t+oim9zlUP/1Ss6td/WEbwKQW7fdLmJ80L
OT6mI+n1zvHbn5WWs34JEHGgbEkwxyx9CqDwqW6M+9sF3G8/Zxppfi2S1cWS5OIW
+HrLMI5KSQkbWJE+fS4Kio3r06C4k0cAYywlLEgyy2ewj/Md+/9JMDGhEhPOuIVp
3bivPDd4E4Hn3Nn1cD/oQEhp7fIllga81Njk9QVT9jkK6TBUdKgQoIv2Xg+TzmRX
wrGiVPTE592ZTBENpzQMVL+ujOkeeTLca1tGIi7ozt7IbVm5bjrVIZp29ovGiig3
nWrLfFZ8ZT9knW9b7jFOqbhZ6HhRC6scT+/Zst8LFMIYdamD+K/WKalcs/BT4Mfc
A3aSHd0CU8X4+G2rnnGGumgwPxRv05snnFgYzgIjArniWMhkbbfcJPNzt2Nn0Ckx
L5cjQA7epVgy4PU9nMEej5tFY9vQhjmHvq8xX0QPH2gCRtf+yB41SdBJS+zt9OQy
pxrMyrSVr2oJoN37v8v/KlIpVgq1xdRgLRsT9MnNb57dGPUN7yQjsBJF2XiaN3bL
xmyOAgP1OSntcSeI/OEEO0Hyc444yGLIPaUqoiJTYkRUHt0qUaqu9in3sHyTE74M
/0e/hR7f2gum/M4twDBe+TdfEhULrZWyEmiJQB1Ez+OZ1k6e//gLuWwrbRWAR4Zv
pl8bDUTmj2cZYn1v1RsJ
=6BmW
-----END PGP SIGNATURE-----

--lAtGKe5+IF8yYOOm--
