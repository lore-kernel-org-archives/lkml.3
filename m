Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaFWSkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:40:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50506 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754283AbaFWSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:40:04 -0400
Date: Mon, 23 Jun 2014 18:00:13 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] ARM: sunxi: Introduce Allwinner A23 support
Message-ID: <20140623160013.GH19730@lukather>
References: <1403275973-24259-1-git-send-email-wens@csie.org>
 <1403275973-24259-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OdQvBiqfLsaeimeB"
Content-Disposition: inline
In-Reply-To: <1403275973-24259-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OdQvBiqfLsaeimeB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2014 at 10:52:50PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A23 is a dual-core Cortex-A7-based SoC. It re-uses most of
> the IPs found in previous SoCs, notably the A31.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Applied, thanks

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--OdQvBiqfLsaeimeB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqE8NAAoJEBx+YmzsjxAg7eAQAMDLRpN54i36dfBSEjdcLGQz
IkZ8ABc4BgifcFZkpNIKekHiVa36SzXpLeMAw3WhwP09mBlr+VsXW0faf4LGUc7Q
yw1Z+9yWnWUOlgrG98HBrzsylj9FNV5P8TgBW3dw5RNcot7y0QRz1jNZG0Zz3Wmm
MeEJzekNKL6rS+Mfw73Z8DcC9vyIUJZITpSen+A4V3LoPqmSFw5XhOXL++1knTXe
M2SMaDU6SjlWbDENpQhZO0/KALdCM/7YkQfY2z1+PCTg9+05AoBWyEaM5fGRZCqR
HCVAlUn5Hb+T2BiLpLdGusEu8eSHhRBEerqYm/mVxGtMw9TTKGxegInITt11qabb
ecq+AeCKmns4Ax3ABCEL2BhzU9nJdre8uAXHP7/D7jauJXErjFvw8lIvDsqwwov3
jkNq1E1EahyiKhpwtzszDTGVDk8sNAyu2ZhmVjHwu8VbRd+0dPIXamaDqHMcBg7E
BgAR0g+kFZBzZTKkHYkflpZcM0/5KbkQ7AkKdWbCVGsbqhngRrI2bpqsF7splFvE
rAalTbYyT9beNoHAlGb9f4msoDlZuAQDsKQIGbnxiEYKOVgGBboe7Yy8msBx79DW
8soTnnQTZq4sKIB3kE7tlm9E7PlJnboFhwHkysLdLrCbTEKcYJKnt81r1pPIokXU
oOylERDrOGrW9DJyPFRO
=GH0q
-----END PGP SIGNATURE-----

--OdQvBiqfLsaeimeB--
