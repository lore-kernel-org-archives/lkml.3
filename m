Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbaDIPuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:50:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933129AbaDIPuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:50:06 -0400
Date: Wed, 9 Apr 2014 17:45:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/15] ARM: sunxi: add A31 PL pins support
Message-ID: <20140409154509.GL28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
 <20140409151747.GH28585@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p7S+EREVcBHk3zUG"
Content-Disposition: inline
In-Reply-To: <20140409151747.GH28585@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p7S+EREVcBHk3zUG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 05:17:47PM +0200, Maxime Ripard wrote:
> > I have started to document the PRCM block: http://linux-sunxi.org/PRCM
>=20
> It's quite different on the A31 and on the A23 actually :(
>=20
> You don't have any of the audio thing for example, but you have the
> CPUs power clamp controls, that have been moved to the=20

-that have been moved to the
+that have been removed in the A23

Sorry :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--p7S+EREVcBHk3zUG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRWsFAAoJEBx+YmzsjxAgdrAP/0UsAQQ/Fp4ncaFc5+UMuFzP
BH36sSn+d6qmBUr1TQogbHiB6KW2oQkkf4m4/BDdsAGvsP1RtEWHNrokWZ8U1Aee
fd8l5lMvRCzqzssMvovvbEM7dAl70EZkUsDcq9U39Y/jT0HxUYEKfG4FF0nQqhSj
bibY5c/wlMZRLlQmgU5r2SDzRRAL0rjVGuKxO++0O49AtxwXq7eqh5t5UDv7OCgz
z44xAt/x7Lg7gPWM5ZG66vDQYUNa7CugZQlA2hICdX1lsxtnF4pTvUePvt3u0xH+
X13xMdseocpgSNe5N6ngURaJA2dn2+DLJQK8m0hKdJ+BBmFwKiHmpgPU+koeSlTd
5Fgma5cLHaUbG13P+fjItU6NGyDQwrDGJD1l2gos1OoJdnWfoAtok4xRqzzjTTFy
iV/Sr0pOVbcrC8ogWvcnrodatQ/RWqPvkVQMYcVzPg1Wh7O/QSlxTam8p1mYpJxS
l0B8l2CdsFFkwnVFtre1uaki5kbnbA6g6O82/SVQtltoJ4nf+K19LaF3YoIsc9dq
vKyaXyRwKxJNYQlICwCFCQnhwM9RFavjs8Nkl2A87+Q0z2a0K5KH6Jp8VGwAX8jP
7HYVtzuyqyLnJ0+RAK14abhdr1vy1RqyaI91RcWGfr/R0H9vsi2sb6xSk2sGP2bw
kEX8FPyQyKIoDxFoSSUt
=6LGz
-----END PGP SIGNATURE-----

--p7S+EREVcBHk3zUG--
