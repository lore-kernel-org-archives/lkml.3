Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3CAIOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:14:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54289 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab3CAIOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:14:22 -0500
Date: Fri, 1 Mar 2013 16:13:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: twl: Remove TWL6030_FIXED_RESOURCE
Message-ID: <20130301081350.GR25302@opensource.wolfsonmicro.com>
References: <1360983229.6332.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eyYj78xbwv+yMvU1"
Content-Disposition: inline
In-Reply-To: <1360983229.6332.5.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eyYj78xbwv+yMvU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 16, 2013 at 10:53:49AM +0800, Axel Lin wrote:
> TWL6030_FIXED_RESOURCE is not used now, remove it.
>=20
> TWL6030_FIXED_RESOURCE is not used since commit e76ab829cc
> "regulator: twl: Remove references to the twl4030 regulator"

Applied, thanks.

--eyYj78xbwv+yMvU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMGM2AAoJELSic+t+oim9h50P/1TUrIXE+cFCXvg28J6s0tyc
rLzSbinyEH0ljGWNJKVt26n98X4Nx/7aBbLGvZ/EaWkSIdcLlg3PYGLQ4HbvTzWr
TYfQPkFactF2K/wN9ma8DTWEs6G8rtZWf2W2XTEnCv10u3e3+4Uzc3pl9yw9rtuG
Ng29c2oOpKiKscmfIGH+A67kuPy5cTI59kfSC52SlzAAJM8G7DeFDCcm3h3dOzCB
z1X87eRJLRV/v+IK0TCctFQUvrkQUHU+EvZE+Xf+Ns1rxQtj5eVf6wz0lmQiEnIE
80Tq5lId8SU2PaFF+mPiv5Rc2SUf9Ut/SJmYGeHxriYk9WZvwArJie+uvlKEAP6v
WwYUX//mA0Hsd2oI7PE8jqPXSZEWcjG3I0Z9L6NSMPeQ36TvoCM1t34AZlldXfTS
gTDACNSP0AzP80YxxojFLYmvIYH0SfXBcza0BZE+8mm0oLIEPFzb+mot4IQchc/R
/AGBiMO969DcY+03rbTkyPeY0suXNZ1YoTp7GstqFXNMqZ/1i4v+gRM483kcRIkJ
vdDW/wD/wkV7fgdsIcyMWWUGW86GT4KaDcN54JIK/7LpSEIuQkb/512uCMzvmA4B
avyEgfxkZecwe/6PQOahBh6a0/N+4ljk1tKlFDR0b561MNnDt6RteBc+8oDhKZKe
peVqcqfC0DNaJZZaetjf
=lU9Q
-----END PGP SIGNATURE-----

--eyYj78xbwv+yMvU1--
