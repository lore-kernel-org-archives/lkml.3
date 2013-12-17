Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3LQW2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:28:19 -0500
Received: from ozlabs.org ([203.10.76.45]:34947 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3LQW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:28:18 -0500
Date: Wed, 18 Dec 2013 09:28:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: hym8563: include clkout code only if COMMON_CLK
 active
Message-Id: <20131218092810.b63c31277c6ee61af2bf6614@canb.auug.org.au>
In-Reply-To: <201312171611.30526.heiko@sntech.de>
References: <201312171611.30526.heiko@sntech.de>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_09_28_10_+1100_nyG0vksjTBQdG3HN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_09_28_10_+1100_nyG0vksjTBQdG3HN
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Heiko,

On Tue, 17 Dec 2013 16:11:30 +0100 Heiko St=C3=BCbner <heiko@sntech.de> wro=
te:
>
> The contents of clk-provide.h, struct clk_hw etc, are only available
> if CONFIG_COMMON_CLK is selected. Therefore IS_ENABLED(COMMON_CLK) is
> not sufficient and real preprocessor conditions are necessary to
> keep the code in question from being compiled on non-COMMON_CLK systems.
>=20
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

I will add this to the akpm-current merge today (unless Andrew beats me to =
it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Dec_2013_09_28_10_+1100_nyG0vksjTBQdG3HN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsM//AAoJEMDTa8Ir7ZwVbIMP/3OG9Hw/IZGdQjuWklZmd3mT
qpBpdxl/O7H8hRHcRI4akj1i4Aco5klJ3LcWSnVrQPYs3v8YUEMN8c/5sy6ib3X0
OXMYSl2waw4+vSYLYURE5xpyPfqIEt04DPwPaYyCFte6NNQdNtIiXtUi/0mqeP9n
K7t0BUntS+u/7bQjGt6jGEyLf18WE4D6NuuH/eedHkid4WHM/S/kK6+tuwdrViuB
lfcJnubMeuHyPuDdVzHh8+q3h8+4iA+iCwasRlGTtByp5huQAy6Ol0GQ54ql++/G
8bHwlSPvKqSg3X5cBCoWwwZRcpjq29s/2jFCXSEzIQRVdRuOdFO7tHeCvIPV6adV
x2YzhZMGLaX33BeWdxOCDghWoSNPtC3JJCT9lxYFJ4u91+kKuBu6Pg2KqwQ7qWYF
b53g/6Pxxguk3ehndcHyFB7uLqOQlC5GjvAdUdTfYIiUQvf3cVtLgtbvVAF0X0Ta
6oLQDQqmJf9mYlIQDAn8U2CKAFU/cLRxalYVVIiRXzYHv2ATboJ2dA10QoCS+0PM
LesEk0QautHgNlguLLC2O88oV1TP8RWqiDGMz8MD9GLkA7bE6zXESwhaY2zRQ3Ww
6Lw2RId8LVXu4Rjn+KXEtXSVc8lmyXCqVBnx2ciBVOd/O8Rehxgj245HfdHfLHgz
dYe04gR3ZXA5cehN3K8t
=6fSO
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_09_28_10_+1100_nyG0vksjTBQdG3HN--
