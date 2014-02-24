Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaBXJFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:05:11 -0500
Received: from top.free-electrons.com ([176.31.233.9]:51406 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbaBXJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:05:09 -0500
Date: Mon, 24 Feb 2014 10:04:24 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 0/7] Add Allwinner A10 SPI Controller Driver
Message-ID: <20140224090424.GC3468@lukather>
References: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <1393104959-12831-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 22, 2014 at 10:35:52PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> This patchset brings support for the SPI controller found in the
> Allwinner A10 and derived SoCs.
>=20
> Even though the controller supports DMA, the driver only supports PIO
> mode for now. This driver will be used to bring up and test DMA on the
> SoC, so support for the DMA will come eventually.
>=20
> It doesn't support transfer larger than the FIFO size (64 bytes) for
> now, It's one of the things that will be fixed whenever we will have
> DMA support.

Applied patches 2-7 to sunxi/dt-for-3.15

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTCwsYAAoJEBx+YmzsjxAgG5QP/RFUpXFsoITNvSb5TWzt199j
hctAi6objewNo0X0YwRDkVQdTpymKNuBal8MA9Q2kusZT8fagzikhdG3bi902UUf
1A+43VnJJReexMGANMQmSJlM7H7FvvYIXYuLhCml0I+h6eKrfmJa4X8c+LkC6MPs
wrw3uFYs5KPSCyWjO8aTOPdnJcjoO62FMt+GLVrTEUnA1Y4emquhojVZg3xA6Vw2
dQyUfRhi4BaejVh3Vqeb6R/oa5M4xIpV+QMrLRky03HRWn4AF1sKJpZekCdXW0mg
7ovOQ2cAXg9ZTJn64F5esY03dM6CImw2y/h2RZfdy8KWczTBCFh9Dk2UuBQ1OB69
6jSn+r2nBaxHYcZo1hdtvKdZ0lkYvseVac8JJlF6o01VgPNteAG7gJiIkJUoQkPp
3psvrJjipLY8mfy6pCSGpOkuwMjuJ7CEA88t3r8lJEtv1tT9XP5C2cIvcZhxVNFe
psbm1HOqGG4AXmDgRgdyQeP8sol4oPWcuUc3AaJOOjprJf1PB3evX1WU+hKiw+h6
dsLDkFI/fL0+9lC2MNrv9Tqd+Vcge4OVGgrfw2A56G5LpgMXeWKF6msQ/iB6pPC3
c4v19S/k/Oc8pQGYQTNdyK0cDd7XvCC/8ALG8mVW1mx1f57SWzm5TGlIxlUnVKa1
Cm8ooRSmGjSpGDD4lKkb
=mD1l
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--
