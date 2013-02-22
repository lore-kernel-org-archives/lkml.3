Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3BVSCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:02:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42976 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758134Ab3BVSC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:02:28 -0500
Date: Fri, 22 Feb 2013 18:02:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V3] spi: tegra114: add spi driver
Message-ID: <20130222180226.GC19796@opensource.wolfsonmicro.com>
References: <1361536659-23225-1-git-send-email-ldewangan@nvidia.com>
 <CAKDJKT5yngpZQC-ZvHSaKeBVHW97wo4QwLSXQ4KsVWCs5J1YKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <CAKDJKT5yngpZQC-ZvHSaKeBVHW97wo4QwLSXQ4KsVWCs5J1YKg@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 07:59:11PM +0530, Manish Badarkhe wrote:
> On Fri, Feb 22, 2013 at 6:07 PM, Laxman Dewangan <ldewangan@nvidia.com> w=
rote:
> > Add SPI driver for NVIDIA's Tegra114 SPI controller. This controller
> > is different than the older SoCs SPI controller in internal design as
> > well as register interface.
> >
> > This driver supports the:
> > - non DMA based transfer for smaller transfer i.e. less than FIFO depth.
> > - APB DMA based transfer for lager transfer i.e. more than FIFO depth.
>=20
> s/lager/larger
>=20
> > - Clock gating through runtime PM callbacks.
> > - registration through DT only.

Delete unneeded context from your replies, we shouldn't need to page
through the entire patch because you've noticed a spelling error...

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJ7KrAAoJELSic+t+oim99m0P/1Lv2IL0oI8UFS0+iR75/yiE
TP4aMhgt4h6FdU9YG9xz7tUI2d/ur0J0lHfgcA0jSB+HqdSy/5rNo/FN7j8qMge4
ydavTAvxGbMBdiEpg9XA2FCaxlNyLAcfOOG3OVDyGpmEQxdI1r5eXXKC8jdR2p8W
uQ2aSZpxAqwpBDO8jvLkT5f11+EhSKRd0OwyuA2dIYLmeAkQNnWTTttO1VEAfKpy
69jOUgSFpvuYs7QojdRgFcUKr/BZD4/HCgOcWhHDLT5FUp/fREhb/dKtpGuiePng
7As38F/nVsu9Sm47FBTMprE4Lxly0/h8j3ywbubHfv69j1L763k/skZsTUkCjsmr
Y3/kpsXXWMc956pEN8GTltyWIm+NepcGenOQqnT/ViXmjuuIMxFao2GdrOQX/Y1S
NmO95k9suxTvgi9+y13Cb7G84SI8n7b5kDvjQKx8u3Kz/v7M48xgOpcI/39fjs7R
UdEmnUUj11ocfCerh+mTgiR9IksGwnXYYNbmXxqBGovdqfEEqoDHYdZUnDocSeT1
SBZw9TVsGOIHd/1EffEI71mOQfZ/vVri3jUv69+SzJslwvuw/4WTZvku7DpjKCJY
P+lGNJYwfKdQkepdJ5E4jDPiwImotfzGgEAwiHfBrtcBobdbMka6mzH62xYB5zuF
X/qwoX2N1Y73F/x0EVDq
=I72D
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
