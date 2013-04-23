Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3DWK0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:26:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49436 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab3DWK0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:26:50 -0400
Date: Tue, 23 Apr 2013 11:26:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regulator: tps62360: Fix off-by-one shift for ramp_ctrl
Message-ID: <20130423102648.GD5019@opensource.wolfsonmicro.com>
References: <1366691753.25625.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Content-Disposition: inline
In-Reply-To: <1366691753.25625.6.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2013 at 12:35:53PM +0800, Axel Lin wrote:
> According to the datasheet[1]
>=20
> Register 0x06h Description: RmpCtrl (REGISTER ADDRESS: 0x06h Read/Write)
> BIT[5..7]:

Applied, thanks.

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdmHhAAoJELSic+t+oim9caQP/2nsfbvFdp62l3PFoVDRD+ju
jgMo83TC4FpIFsyHmZIkAutKyAYwwkQbNcYtLiSUWgfzizMXu5b7CU7BMlL3ssso
C2GOH7+oyefxNt+X2sOwzBp5+btHJEv6d7yktSLP2Pz2T1UmAYkH7gYADWu9APyP
BLSIJqt5BKl29eqQeANPhFZqAZ624SEnNCTlaauJ0gldQ+O826w8YuoaP3D2tKw3
97vp4PVc75GUwEqAlk4ftofCtaFovK3qc8H55gCTD3+nhR04FsfFURVAaKD6R75r
ifk7eVKW8RB5EyxLjr9hM7dRs9TrRovR68I/o4ixlZmwevrWMBFYA7oIayqW8Mvw
HVXD4GELs488Bh2eNHl0YShvypczhJlWI1Uaz/kPnqIRGUvo3x1TKa+LzKchoIHK
eU5RotD6UHpdZTnSRMUwnPr7WCgrtxN0uJ3u6S+bciz02L9ZdL8gSSAi8337ggs/
R6hI+gmFwjoyRHWDbg2+2lDonbFXdpdrcWWQJZDrgHt4PdZxLodDh+gZ1YvnWPJM
8oxhpVjuznrwHiebBJT5fUX1bbQg9idwTuD4J9SEcPm8wvlybo4XoL+28OlCySCg
b0/o8Soenv8jopRWLj4uV4dqppx9FY/tcWoMK8vP1HWoKkMA2VvF+USMBvYk79+h
QuEpPF0HNpBip/TqF0p0
=0WEb
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
