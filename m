Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3G2MYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:24:15 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47402 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751205Ab3G2MYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:24:14 -0400
Date: Mon, 29 Jul 2013 14:24:01 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 1/1] pinctrl: sunxi: Fix incorrect NULL check
Message-ID: <20130729122401.GD1441@lukather>
References: <1375085972-657-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Content-Disposition: inline
In-Reply-To: <1375085972-657-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 01:49:32PM +0530, Sachin Kamat wrote:
> *map should be tested for NULL instead of map as kmalloc pointer
> is assigned to it. This also fixes a potential null pointer dereference
> bug later in the code.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9l7hAAoJEBx+YmzsjxAgU0MP/1Wr+84tNOtHD6rIwUe+Bg0s
7dsRLcCG7YZ2psDM1mAKrCx8dGcnzbHwehNovkRI0aXlBkxT+CJfZCwGkbwR32HB
ZLMq/SdlUTH4sXNaOQs/Ujw4KRfLiWU7X7vNkTrqvCnJXuxiSYt0PV8EGdW+a+5j
Tcd2ANm2xyvIjn2FLCGkl/CgqkjDnrh/pjvAxc8+cyH0eNNP92DpGeGvRYwWgqSo
WiShfkxj2szhdumFNj63xVHQwDtHy6ok+NkNdg/4ZzmmUf5TdTo5XEhrsKnRgSGL
1sJ3sn2MxmtlHD7BlBGI58FCbmn0h9/Zlw6e8GscZq2G8oUd4m0c5jgQf3zs4isd
L5z7ArKv+xeLMYq3iyTmmwcnuEpe127oWPkHahHQikP/LtV3CTlqqJolAr9lRl+P
XrSYffmqqLVPpGs8ZqXP53/pzqw6bM+Ab0W/AsirwXXOMva9HIBcUxWk5ZmDIg6b
7YE1FBWV2swgHJZr7UUt5bcGc0UroqySD0oRi7DlBqW3OWgl/lEs9v/6F1UGf6tr
zjoPp/bhK4o8xEXX0UrNo90oeSfLfICWAm6P+BbgHhSutTgkYOyzBf1qmm5mapbx
JwJ60m1Fn+/W9mIsn7/TBB8RrnIY58Ji/Q4wdgqPIlEws9mij+6JPCaQ5rnE7o5v
5HlGF5k3uR/phIWbiyoE
=k0oW
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
