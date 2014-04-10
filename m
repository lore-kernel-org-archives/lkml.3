Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbaDJIUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:20:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36886 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965065AbaDJIUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:20:07 -0400
Date: Thu, 10 Apr 2014 10:16:11 +0200
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
Message-ID: <20140410081611.GN28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
 <534571F0.10706@free-electrons.com>
 <CAGb2v651R-sG3OB4aD4UXWiyQVcHz7zXub1wO6B4xp-toUcC7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QGBKWVSgmlsIyJ+t"
Content-Disposition: inline
In-Reply-To: <CAGb2v651R-sG3OB4aD4UXWiyQVcHz7zXub1wO6B4xp-toUcC7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QGBKWVSgmlsIyJ+t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 01:14:26AM +0800, Chen-Yu Tsai wrote:
> >  3) other things I haven't noticed yet :-)
>=20
> Reworking EINT to use one interrupt per bank will yield some more surpris=
es.
>=20
> There's also new gpiolib irqchip helpers, but that will require reworking
> each pin bank into separate gpio chips. May be more work than just adding
> different irq domains for different banks.
>=20
> See: https://lkml.org/lkml/2014/3/25/175

I'm not sure it's worth it actually. Using these helpers will probably
simplify the A31/A23 case, where you have one interrupt controller per
bank, but it will be much more complicated to handle the A10/A20 case
where you have a single interrupt controller for all the banks.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--QGBKWVSgmlsIyJ+t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRlNLAAoJEBx+YmzsjxAgaS4P/A2N1vwJCW7mo+wHOjdgZzry
oZOvn5I7asACoB4aHAVCAfkCcK4v0ThQC3PSfuxlE05CcIjnrxr2OfT+Y/j5bpRT
+MGsAyHuQRnslTbXyu28FSO0A5LfeGiyLw0SecOKIKdieZBMTD3wIsbI14ophc0k
2POnK/jFAGcuv4yksUCVNtMPJy1V1FDDzQl9MyDBsNXNi+0XHWOWFRLdbjillNrX
L4o9V9FQ6q/WpJQ8zLmIO9EJMN4OwCUsSL+f3mSq/hKjUPFDvnWIn2CVb5Ksp26d
A2L0JQC5KRPTQl/GYYZx4/D7m8gE5lWkP1NnEscMpUpNKw9ZEwPeLudPNXLnC8Bg
XWjFfnIEVd0uHfhayKzQogi2l1juw1cgrHl4B4zQACUK8ruC2SwMAkOtb4wU2aI8
eLBycv2F6FXSpOe6/T6EZsQJlY/FcOjhOuvi7LL95YLlAuizgiII8c2Po4Dkhd0f
Kd+k5EGtDMaSqpXFpAoAUSfD9elyDiY9s8f8367is4oGjA1FKJ9ODOdJoaf+XXcF
k2rejUqqRdvUbLwkn/QP7hO3HfE1j9WyePHJvT3AeIybN3wq1NzsTZ07+MY1N69x
pDEUp1f83bVxRaExUSTUNNcG0PnijYL52Xo4dlaUYTr1m2DWcF3WV6sLnS3Yogt9
JuRYpanaPypveA39L7In
=KGOJ
-----END PGP SIGNATURE-----

--QGBKWVSgmlsIyJ+t--
