Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183Ab3HNSJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:09:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40581 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3HNSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:09:33 -0400
Date: Wed, 14 Aug 2013 19:09:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Barry Song <baohua.song@csr.com>, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130814180907.GE2401@sirena.org.uk>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376471493-22215-26-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5Mfx4RzfBqgnTE/w"
Content-Disposition: inline
In-Reply-To: <1376471493-22215-26-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 25/29] drivers/spi/spi-sirf.c: simplify use of
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5Mfx4RzfBqgnTE/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 11:11:29AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.

Applied, thanks.

--5Mfx4RzfBqgnTE/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC8fAAAoJELSic+t+oim9bggP/R6LtCCXRFnBopJg0oymKvWL
6TRQrua89PUx05BFqg7CsSyaemU6DKh3RmojruXTfgbjXtd+/YdzuIBwMu/ou8c8
oNXTZjzogMa2JctE4vAvIq3y/Pxh9BFc7WLrq9X08NlA7jEZ9eXgs1+HiOneHya9
wAlDwAK6SpVF7BC5h0x0N7v7l43tkBce+SlZblGpEQzm/NhF4EIsASExc9Uc0DAa
QUfuc8Y2iC/A9XAXZhGJWvk+mEPb9YKu6kRCLASQFaIe630wrsdVxupcAui46Cf4
pRGBhUohjrA+Wa+3YHPtVOMosjgrbXD57erilwQqrMmU2XvzOWDWqfwvjW3FwYXN
JHS2cWplR7WwyFLq8VTbqRGTxPr5HtCYR+TYZkxmw+jOzJJqUKR3Ovn6IbZO8EG/
E4UDushEJAlxFvRSdWbBnIPvc9uMhHlkuNKeRpWEXDq5OOoc6Vo9yohHrmW+lzMk
ZFZUQWRSzK56Ez6ho5X2jQ8Qf0lQZQdVSZwFYgZj7Tm7rl0RBw0dauCVhg0ui6+a
MoMZ32TbU746YA1zCIbjcPYHYB9OVucSPmMixjFcl9YC0GEnrc2TW128rDQZRw/D
OjkFrchh2k2kj7nI4NeUWgvUbiomLQB7viq4TOciiDzk9+g+6TAeoHHof+aknd3B
H+9SvVv0atuPYDPStlse
=OAMf
-----END PGP SIGNATURE-----

--5Mfx4RzfBqgnTE/w--
