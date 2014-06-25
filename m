Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaFYUUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:20:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753207AbaFYUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:20:09 -0400
Date: Wed, 25 Jun 2014 22:15:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 3/6] clk: sunxi: Support factor clocks with N factor
 starting not from 0
Message-ID: <20140625201551.GI19569@lukather>
References: <1403603980-31101-1-git-send-email-wens@csie.org>
 <1403603980-31101-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NyChO5MpGs3JHJbz"
Content-Disposition: inline
In-Reply-To: <1403603980-31101-4-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NyChO5MpGs3JHJbz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2014 at 05:59:37PM +0800, Chen-Yu Tsai wrote:
> The PLLs on newer Allwinner SoC's, such as the A31 and A23, have a
> N multiplier factor that starts from 1, not 0.
>=20
> This patch adds an option to the factor clk driver's config data
> structures to specify the base value of N.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NyChO5MpGs3JHJbz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqy33AAoJEBx+YmzsjxAgswwP/RC7rvYBP2z4wH0T327EPD6E
UvoahyZbmXusXrJk2vRMWBgEPlD1n8GV6hNnE+zWIxCi0T7+gNH73rwVouGFtCqn
Y4NisQD91nGaCI69Z1jLDdd/H5+WiQ5MDKnriHyfoJyTXuJehQnS92T0uPLW5P5Z
6GHgvaIKiLR57qp9kpJ7ccW9TUFwBAB0TWEbkhnBda8WDCZLrZwPCpyuSfwLWAep
IQkwyt2BEgcC2PhpWYpRH4LtnhCN/YV/nzW9k12FrDtp7NAdw5qczHOlOGogrbwE
2bYdGGHHp+DgY+SJk1zGR/H/8fFUZWA0Mvmzm3s4F1ygwDpCn3t83k/kd6FUb3Gl
C66gLOz6ccKaJq0t53ExrpoxGF+0XvKfnIQME2RQY7vloy7iL4lubsAM34QVVUWW
RlsSF1GKkaHll8vT9MoTkGUnxNwc+pyL08WWA+KBo0xSlki5dl114+XXdxGj7u52
7Hug4vs6g8VtmsExv8I08dUaPxaXe1mKkDwfZYMitZyIBcRY6uRHVK1dHuKPTN+F
I1NQ6hUj2fBSPXAEWPzS5jRuh4GdvKhBN9bMXwVtfs5A7yEG8G9b8Do4lCou+48v
aDZK23yj44Y2jpUgTooswg7Qcl4XRsGVW7CFr/dSM5NNu0o6XhLhii0hsZx+ocYZ
1TMwp8mk3bcOcVhmByZW
=/VF5
-----END PGP SIGNATURE-----

--NyChO5MpGs3JHJbz--
